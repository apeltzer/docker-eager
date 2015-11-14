# EAGERpipeline Docker Image

To abstract from the madness of getting the environment set up, the users is supposed to use EAGER via an docker image.

## Create the Image

Just pull the image from the (to be established) docker repository or build it your own from this git repository by fireing up the following command alongside this README.md.

```
docker build --rm -t eager .
```

## Use the pipeline

```
$ docker run -d --privileged --name eager -h eager \
             -v $(pwd)/gatk/:/opt/gatk/ \
             -v /dev/null:/dev/null -v /dev/urandom:/dev/urandom \
             -v /dev/random:/dev/random -v /dev/zero:/dev/zero \
             -p 2232:22 eager:latest
88cae0e1714d37ac27888ffd6a035f1dde1037fbd158f37ff324e97b308b0ddb
```

Since the container spawns an ssh server we might lock in (-X forwards X11).

```
$ ssh 192.168.59.103 -Y -i ssh_eager_rsa.key -l eager -p 2232
/usr/bin/xauth:  file /home/eager/.Xauthority does not exist
[eager@eager ~]$
```

The command ```xeyes``` should open an dumy X11 application to check the X11 forwarding.

The pipeline consists of two components:

- ''eager'': Which executes the graphical user interface, that is required to define and configure the workflow. 
- ''eagercli'': Which executes the created configuration files automatically. 



