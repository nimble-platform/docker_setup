# noinspection PyUnresolvedReferences
from fabric.api import task, put, cd, run, env, sudo

env.use_ssh_config = True


@task()
def deploy():
    with cd('/data/nginx/'):
        put('nginx.conf', '.')
        put('docker-compose.yml', '.')
        sudo('docker-compose up --build -d')


@task()
def logs():
    with cd('/data/nginx/'):
        sudo('docker-compose logs -f')
