FROM rocker/binder:latest@sha256:4421ea7d63b408f6893d368e3ea0f3738efa5997ae9bd26e572c654fe31dfbe5
USER root

COPY apt.txt /tmp/apt.txt
RUN apt-get update && \
    # Ignore comments in packages
    grep '^\s*[^#]\+' /tmp/apt.txt | xargs apt-get -y install \
    && apt remove code-server

USER ${NB_USER}

COPY install.r /tmp/install.r
RUN Rscript /tmp/install.r


COPY environment.yml /tmp/environment.yml
RUN conda env remove jupyter-vscode-proxy && \
    conda env update --file /tmp/environment.yml

# Set working directory so Jupyter knows where to start
WORKDIR /home/rstudio

# Set SHELL so Jupyter launches /bin/bash, not /bin/sh
# /bin/sh doesn't have a lot of interactive features (like tab complete or functional arrow keys)
# that people have come to expect.
ENV SHELL=/bin/bash
