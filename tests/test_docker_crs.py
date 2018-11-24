def test_with_container(docker_cr):
    #assert docker_cr.check_output('pwd') == '/'
    res1 = docker.cr.run('ls -l /')
    print(res1)
    assert 1==1

