#!/bin/bash

set -e

DATE=$(date '+%Y-%m-%d %H:%M:%S')
STATES_DIR="../terraform-states/v1"
PROJECTS_DIR="../terraform-projects"

function create_dirs() {
    PROJECT=$1
    PROJECT_PATH="${PROJECTS_DIR}/${PROJECT}"
    echo "Creating directories in ${PROJECT_PATH}..."
    mkdir -p "${PROJECT_PATH}/states"
    mkdir -p "${PROJECT_PATH}/files"
}

function sync_project() {
    PROJECT=$1
    PROJECT_PATH="${PROJECTS_DIR}/${PROJECT}"
    STATE_PATH="${STATES_DIR}/${PROJECT}"

    echo "Syncing ${PROJECT} from terraform-states to terraform-projects..."
    mkdir -p "${STATE_PATH}/files"
    mkdir -p "${STATE_PATH}/states"
    mkdir -p "${STATE_PATH}/vars"
    mkdir -p "${PROJECT_PATH}/files"
    mkdir -p "${PROJECT_PATH}/states"
    mkdir -p "${PROJECT_PATH}/vars"

    # Sync files and states from state to project
    if [ "$(ls -A ${STATE_PATH}/files 2>/dev/null)" ]; then
        rm -f  "${PROJECT_PATH}/files/*"
        cp -fr "${STATE_PATH}/files/"* "${PROJECT_PATH}/files/" 2>/dev/null || true
    else
        echo "Warning: No files to sync from ${STATE_PATH}/files."
    fi

    if [ "$(ls -A ${STATE_PATH}/states 2>/dev/null)" ]; then
        cp -fr "${STATE_PATH}/states/"* "${PROJECT_PATH}/states/" 2>/dev/null || true
    else
        echo "Warning: No states to sync from ${STATE_PATH}/states."
    fi

    if [ "$(ls -A ${STATE_PATH}/vars 2>/dev/null)" ]; then
        rm -f  "${PROJECT_PATH}/vars/*"
        cp -fr "${STATE_PATH}/vars/"* "${PROJECT_PATH}/vars/" 2>/dev/null || true
    else
        echo "Warning: No vars to sync from ${STATE_PATH}/vars."
    fi
}

function apply_project() {
    PROJECT=$1
    PROJECT_PATH="${PROJECTS_DIR}/${PROJECT}"
    STATE_PATH="${STATES_DIR}/${PROJECT}"
    TIMESTAMP=$(date "+%Y%m%d-%H%M%S")

    echo "Applying Terraform for ${PROJECT}..."
    pushd "${PROJECT_PATH}" >/dev/null

    terraform plan -out=tfplan.out -var-file=vars/default.tfvars || {
        echo "Terraform plan failed. Exiting."
        exit 1
    }

    terraform apply -auto-approve tfplan.out || {
        echo "Terraform apply failed. Exiting."
        exit 1
    }

    echo "Syncing ${PROJECT} back to terraform-states..."
    mkdir -p "${STATE_PATH}/files"
    mkdir -p "${STATE_PATH}/states"
    mkdir -p "${STATE_PATH}/vars"

    # Copy files and states back to state
    cd ..
    cp -rf "${PROJECT_PATH}/files/" "${STATE_PATH}/"
    cp -rf "${PROJECT_PATH}/vars/" "${STATE_PATH}/"

    # Backup terraform state
    cp "${PROJECT_PATH}/states/terraform.tfstate" "${STATE_PATH}/states/terraform.${TIMESTAMP}.tfstate.backup"
    cp -f "${PROJECT_PATH}/states/terraform.tfstate" "${STATE_PATH}/states/"

    # Realizar el commit y el push
    cd $STATES_DIR
    git add $PROJECT

    COMMIT_MESSAGE="Updated states project: $PROJECT | Date: $DATE"
    git commit -m "$COMMIT_MESSAGE"

    # Hacer push al branch actual
    echo "Pushing changes to branch $GIT_BRANCH..."
    git push

    echo "Done!"

    popd >/dev/null
}

function show_usage() {
    echo "Usage: $0 {project} {command}"
    echo "Commands:"
    echo "  sync   - Sync files from terraform-states to the project."
    echo "  apply  - Apply Terraform changes for the project."
}

if [ $# -lt 2 ]; then
    show_usage
    exit 1
fi

PROJECT=$1
COMMAND=$2

create_dirs "${PROJECT}"

case ${COMMAND} in
sync)
    sync_project "${PROJECT}"
    ;;
apply)
    apply_project "${PROJECT}"
    ;;
*)
    show_usage
    exit 1
    ;;
esac
