# Copyright (c) Mark Mauerwerk
# Distributed under the terms of the Modified BSD License.
# Build following fas conda https://github.com/red8012/FastConda/blob/master/Dockerfile
FROM clearlinux:base
LABEL maintainer="mark@mauerwerk.biz"

ENV LANG=C.UTF-8

# use tini init system
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh miniconda3.sh
RUN /bin/bash miniconda3.sh -b -p /conda && rm miniconda3.sh && echo export PATH=/conda/bin:$PATH >> .bashrc

RUN mkdir -p /opt/app
RUN mkdir -p /opt/app/data
RUN mkdir -p /opt/app/templates

WORKDIR /opt/app

ENV PATH="/conda/bin:${PATH}"

# add some python dev packages
#RUN swupd bundle-add python-basic-dev

# baseline of data science packages
RUN conda install --quiet --yes --file requirements.txt

# copy app data
COPY app.py .


ENTRYPOINT ["python"]
CMD ["app.py"]