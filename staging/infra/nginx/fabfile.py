# noinspection PyUnresolvedReferences
from fabric.api import task, put, cd, run, env, sudo

env.use_ssh_config = True


@task()
def deploy():
    with cd('/data/nginx/'):
        # sudo('chmod a+w *')
        put('nginx.conf', '.')
        put('docker-compose.yml', '.')
        run('docker-compose --project-name nginx up --build -d --force-recreate')


@task()
def logs():
    with cd('/data/nginx/'):
        sudo('docker-compose logs -f --tail 100')
