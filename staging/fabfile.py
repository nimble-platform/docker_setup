from fabric.api import task, local, put, run, env
from fabric.context_managers import cd
from fabric.contrib.project import rsync_project

WORKING_DIR = '/srv/nimble-staging'
env.use_ssh_config = True


@task(default=True)
def deploy_infra():
    update_files()

    with cd(WORKING_DIR):
        run('./run-staging.sh infra')
        run('./run-staging.sh keycloak')
        run('./run-staging.sh marmotta')
        run('./run-staging.sh solr')
        # run('./run-staging.sh elk')
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
    rsync_project(local_dir='.', remote_dir=WORKING_DIR,
                  extra_opts='--progress', exclude=['services/env_vars-staging', '.git', '*.pyc', '.idea', '__pycache__','infra/keycloak/keycloak_secrets','services/platform-config'])
