FROM python:3.10
LABEL mantainer="info@kuralabs.io"

# -----

USER root
ENV DEBIAN_FRONTEND noninteractive
ENV USER_UID 1000
ENV USER_GID 1000


# Setup and install base system software
RUN apt-get update \
    && apt-get --yes --no-install-recommends install \
        locales tzdata ca-certificates sudo \
        bash-completion iproute2 tar unzip curl rsync nano vim tree ack git \
    && rm -rf /var/lib/apt/lists/*
ENV LANG en_US.UTF-8


# Install Python stack
RUN apt-get update \
    && apt-get --yes --no-install-recommends install \
        python3 python3-dev \
        python3-pip python3-venv python3-wheel python3-setuptools \
        build-essential cmake \
        openssh-client \
        libssl-dev libffi-dev \
    && rm -rf /var/lib/apt/lists/*


# Install Python modules
ADD requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt \
    && rm -rf ~/.cache/pip


# Create development user
RUN echo "Creating user and group ..." \
    && addgroup \
        --quiet \
        --gid "${USER_GID}" \
        pytorch \
    && adduser \
        --quiet \
        --home /home/pytorch \
        --uid "${USER_UID}" \
        --ingroup pytorch \
        --disabled-password \
        --shell /bin/bash \
        --gecos 'PyTorch' \
        pytorch \
    && usermod \
        --append \
        --groups sudo \
        pytorch \
    && echo "Allowing passwordless sudo to user ..." \
    && echo 'pytorch ALL=NOPASSWD: ALL' > /etc/sudoers.d/pytorch


# Install entrypoint
COPY docker-entrypoint /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]


EXPOSE 8080/TCP
WORKDIR /home/pytorch