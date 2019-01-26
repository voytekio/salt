base:
  '*':
    - states.common
#    - testdir
  'kernel:Linux':
    - match: grain
    - states.linux-common
    - states.apps_linux
  'kernel:Windows':
    - match: grain
    - states.windows-common
    #- states.apps_windows
  'vroles:salt_master':
    - match: grain
    - states.salt_master
