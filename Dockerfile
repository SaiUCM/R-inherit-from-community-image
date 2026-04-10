FROM rocker/binder:latest@sha256:9c1bb3dc842755c4ac57b6e5ab78dd353c0f4790bdcd7d1f780b6dff38435d9a
USER root

COPY apt.txt /tmp/apt.txt
RUN apt-get update && \
    # Ignore comments in packages
    grep '^\s*[^#]\+' /tmp/apt.txt | xargs apt-get -y install

USER ${NB_USER}

COPY install.r /tmp/install.r
RUN Rscript /tmp/install.r


COPY environment.yml /tmp/environment.yml
RUN conda env update --file /tmp/environment.yml

# Set working directory so Jupyter knows where to start
WORKDIR /home/rstudio

# Set SHELL so Jupyter launches /bin/bash, not /bin/sh
# /bin/sh doesn't have a lot of interactive features (like tab complete or functional arrow keys)
# that people have come to expect.
ENV SHELL=/bin/bash
