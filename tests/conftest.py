import os
import pytest

on_jenkins = 1 if os.environ.get('HUDSON_URL') else 0

print('on_jenkins: {}'.format(on_jenkins))

@pytest.fixture
def somefixture():
    if on_jenkins:
        return "jenkins based fixture"
    else:
        return "non-jenkins based fixture"
