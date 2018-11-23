def test_with_container(docker_cr):
    assert docker_cr.check_output('pwd') == '/'
