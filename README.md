About
=====

PyTorch ready container to build PyTorch projects, with support for
Continuous Integration.

https://hub.docker.com/r/kuralabs/pytorch-dev/

Uses Python:3.10 official image as base image and installs a basic stack ready for
Deep Learning and Python 3 development. It install, among other things:

- torch
- torchvision
- torchaudio
- python3
- python3-dev
- python3-pip
- python3-venv
- python3-wheel
- python3-setuptools
- openssh-client
- build-essential
- cmake
- graphviz
- flake8
- cryptography
- tox
- git
- rsync

Also creates a pytorch user that allows to test as a non-root user
(although it is a sudoer).

Usage
=====


## Running on Nvidia GPU

To take advantage of CUDA capabilities and use the GPU in Docker containers,
first you need to install `Nvidia Container Toolkit
<https://github.com/NVIDIA/nvidia-docker/>`_.

Then you should be able to pass the ``--gpus all`` option to the docker run
command:

    docker pull kuralabs/pytorch-dev:latest
    docker run \
        --rm \
        --gpus all \
        --tty \
        --interactive \
        --name pytorch-dev \
        kuralabs/pytorch-dev:latest bash

## Running on CPU

Just ommit the `--gpus all` parameter.

    docker pull kuralabs/pytorch-dev:latest
    docker run \
        --rm \
        --tty \
        --interactive \
        --name pytorch-dev \
        kuralabs/pytorch-dev:latest bash


There is an entrypoint that can adjust container's user UID and the user GID.

Adjusting the user UID and user GID allows the container user to match the
host's user and avoids permission issues in continuous integration systems that
runs the container. This is different to passing `--user` to the container,
as the files and HOME beloging to the container user will be changed too.

To adjust user and groups identifiers run the container with the following
environment variables:

- `ADJUST_USER_UID`: Host's user UID to adjust container's user UID to.
- `ADJUST_USER_GID`: Host's user GID to adjust container's user GID to.

For example:

    ADJUST_USER_UID=$(id -u)
    ADJUST_USER_GID=$(id -g)

    docker run \
        --interactive --tty --init \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        --env ADJUST_USER_UID=${ADJUST_USER_UID} \
        --env ADJUST_USER_GID=${ADJUST_USER_GID} \
        kuralabs/pytorch-dev:latest bash

For the adjustment to work, the user starting the container must be root, which
is also the default. Make sure to pass `--user root:root` to the container if
unsure if the run environment sets another user. The container's entrypoint
will print a warning if the user running the container is not user 0.

Once the entrypoint ends its tasks, the user command is run as the
unpriviledged user `pytorch`

If you need to set the container to the same time zone as your host machine you
may use the following options:

    --env TZ=America/New_York \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \

There is also support for the execution of startup scripts by placing
executable scripts in the `/docker-entrypoint-init.d/` directory. To do so,
mount the startup scripts directory as follows:

    --volume /your/scripts/path:/docker-entrypoint-init.d/ \


License
=======

    Copyright (C) 2017-2023 KuraLabs S.R.L

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.