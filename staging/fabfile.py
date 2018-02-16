from fabric.api import task, local, put, run
from fabric.context_managers import cd

REMOTE_DIR = '/srv/nimble-staging'


@task(default=True)
def deploy_infra():
    update_files()

    with cd(REMOTE_DIR):
        run('./run-staging.sh infra')
        run('./run-staging.sh keycloak')
        run('./run-staging.sh marmotta')
        run('./run-staging.sh elk')

@task
def deploy_services():
    update_files()

    with cd(REMOTE_DIR):
        run('./run-staging.sh services')

@task
def update_files():
    run('mkdir -p ' + REMOTE_DIR)
    put('.', REMOTE_DIR)
