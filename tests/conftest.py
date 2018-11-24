import os
import pytest
import subprocess
import testinfra

import pdb

on_jenkins = 1 if os.environ.get('HUDSON_URL') else 0
print('on_jenkins: {}'.format(on_jenkins))

@pytest.fixture
def somefixture():
    if on_jenkins:
        return "jenkins based fixture"
    else:
        return "non-jenkins based fixture"

@pytest.fixture
def docker_cr(request):
    #pdb.set_trace()
    if on_jenkins:
        workspace_var = os.environ.get('WORKSPACE','unable')
        docker_id = subprocess.check_output(['docker', 'run', '-d', '-v', workspace_var+'/logs:/jenkins_logs', 'alpine', 'sleep', '300']).decode().strip()
    else:
        docker_id = subprocess.check_output(['docker', 'run', '-d', '-v', '/home/voytek/repos/salt/logs:/logs', 'alpine', 'sleep', '300']).decode().strip()
    res = testinfra.get_host("docker://" + docker_id)
    yield res
    subprocess.check_call(['docker', 'rm', '-f', docker_id])

