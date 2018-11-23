def test_basic1():
    assert 1==1

def test_with_fixture1(somefixture):
    print('fixture is: {}'.format(somefixture))
    assert 1==1
