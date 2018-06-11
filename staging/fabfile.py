from fabric.api import task, local, put, run
from fabric.context_managers import cd

WORKING_DIR = '/srv/nimble-staging'


@task(default=True)
def deploy_infra():
    update_files()

    with cd(WORKING_DIR):
        run('./run-staging.sh infra')
        run('./run-staging.sh keycloak')
        run('./run-staging.sh marmotta')
        run('./run-staging.sh elk')
        # run('./run-staging.sh gost')


@task
def deploy_services():
    update_files()

    with cd(WORKING_DIR):
        run('./run-staging.sh services')


@task
def nginx_update():
    update_files()
    with cd('/srv/nimble-staging/infra/nginx'):
        run('docker-compose --project-name nginx up --build -d --force-recreate')


@task()
def nginx_logs():
    with cd('/srv/nimble-staging/infra/nginx'):
        run('docker-compose logs -f --tail 100')


@task
def update_files():
    run('mkdir -p ' + WORKING_DIR)
    put('.', WORKING_DIR)
