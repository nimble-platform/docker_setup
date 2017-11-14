# noinspection PyUnresolvedReferences
from fabric.api import task, put, cd, run, env, sudo

env.use_ssh_config = True


@task()
def pull():
    with cd('/data/deployment_setup/'):
        sudo('git pull origin master')
