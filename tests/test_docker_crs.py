def _v_print(text_string):
    print(dir(text_string))
    text_list = text_string.stdout.split('\n')
    for one_line in text_list:
        print(one_line)

def test_with_container(docker_cr):
    #assert docker_cr.check_output('pwd') == '/'
    create_log_message = docker_cr.run('date > /var/log/voytek.log')
    res1 = docker_cr.run('ls -l /')
    #print(res1)
    _v_print(res1)
    assert 1==1

