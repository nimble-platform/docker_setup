from fabric.api import task, local, put, run
from fabric.context_managers import cd

REMOTE_DIR = '/srv/nimble-staging'


@task(default=True)
def deploy_infra():
    upload_files()

    with cd(REMOTE_DIR):
        run('./run-staging.sh infra')
        run('./run-staging.sh keycloak')
        run('./run-staging.sh marmotta')


@task(default=True)
def deploy_services():
    upload_files()

    with cd(REMOTE_DIR):
        run('./run-staging.sh services')


def upload_files():
    run('mkdir -p ' + REMOTE_DIR)
    put('.', REMOTE_DIR)
