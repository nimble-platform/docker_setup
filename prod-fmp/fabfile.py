from fabric.api import task, local, put, run, env
from fabric.context_managers import cd
from fabric.contrib.project import rsync_project

env.use_ssh_config = True
WORKING_DIR = '/srv/nimble-fmp'


@task(default=True)
def deploy_infra():
    update_files()

    with cd(WORKING_DIR):
        run('./run-fmp-prod.sh infra')
        run('./run-fmp-prod.sh keycloak')
        run('./run-fmp-prod.sh marmotta')


# @task
# def deploy_services():
#     update_files()
#
#     with cd(WORKING_DIR):
#         run('./run-staging.sh services')


@task
def nginx_update():
    update_files()
    with cd(WORKING_DIR + '/infra/nginx'):
        run('docker-compose --project-name nginx up --build -d --force-recreate')


@task()
def nginx_logs():
    with cd(WORKING_DIR + '/infra/nginx'):
        run('docker-compose logs -f --tail 100')


@task
def update_files():
    run('mkdir -p ' + WORKING_DIR)
    rsync_project(local_dir='.', remote_dir=WORKING_DIR,
                  extra_opts='--progress',
                  exclude=['services/env_vars-fmp', '.git', '*.pyc', '.idea', '__pycache__', '.python-version'
                           'infra/keycloak/keycloak_secrets'])
