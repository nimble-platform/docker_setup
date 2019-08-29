from fabric.api import task, local, put, run, env,sudo
from fabric.context_managers import cd
from fabric.contrib.project import rsync_project
from fabric.api import env

env.use_ssh_config = True
WORKING_DIR = '/srv/efactoryefs'


@task
def update_files():
    sudo('mkdir -p ' + WORKING_DIR)
    rsync_project(local_dir='.', remote_dir=WORKING_DIR,
                  extra_opts='--progress --omit-dir-times',
                  exclude=['services/env_vars-prod-efac', '.git', '*.pyc', '.idea', '__pycache__', '.python-version',
                                                                                                  'infra/keycloak/keycloak_secrets',"services/platform-config"])
