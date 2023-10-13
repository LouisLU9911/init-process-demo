# init process

## Demo

### Prerequisites

* MacOS
* [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/)
* docker image: `ubuntu:20.04`

```bash
$ export IMAGE_TAG=ubuntu:20.04
$ docker pull $IMAGE_TAG
```

### Run without init

```bash
$ make test-without-init
Running /test in the container...

Process table:
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  2.0  0.0   3984  2880 ?        Ss   03:05   0:00 /bin/bash /entrypoint.sh without-init
root         8  0.0  0.0   5884  1456 ?        S    03:05   0:00 /test
root         9  0.0  0.0   5904  2836 ?        Rs   03:05   0:00 ps aux

Sleep 2s...

cat /example.txt
hello

Stop the container using docker stop...
time docker stop init_process_demo
init_process_demo
       10.20 real         0.06 user         0.02 sys

copy /example.txt from the container
example.txt is deleted by /test if /test received the SIGTERM signal

cat example.txt
hello
```

### Run with init

```bash
$ make test-with-init
Running /test in the container...

Process table:
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   1020     4 ?        Ss   03:04   0:00 /sbin/docker-init -- /entrypoint.sh with-init
root         7  0.0  0.0   3984  2928 ?        S    03:04   0:00 /bin/bash /entrypoint.sh with-init
root         8  0.0  0.0   5884  1524 ?        S    03:04   0:00 /test
root         9  0.0  0.0   5904  2852 ?        Rs   03:04   0:00 ps aux

Sleep 2s...

cat /example.txt
hello

Stop the container using docker stop...
time docker stop init_process_demo
init_process_demo
        0.18 real         0.06 user         0.02 sys

copy /example.txt from the container
Error: No such container:path: init_process_demo:/example.txt
example.txt is deleted by /test if /test received the SIGTERM signal

cat example.txt
cat: example.txt: No such file or directory
make: *** [test-with-init] Error 1
```
