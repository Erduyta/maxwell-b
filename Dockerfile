FROM nvidia/cuda:10.0-devel

# Do as much installation as possible to make use of caching as installing
# is very slow.
# A few comments:
# 1) openmpi seems to give trouble so use mpich2.
# 2) Use a virtualenv to avoid outdated system packages (i.e. six).
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN apt-get update && \
    apt-get install -y python3-pip \
                       python3-setuptools \
                       libhdf5-serial-dev \
                       mpich

RUN pip3 install virtualenv
RUN virtualenv -p python3 pyenv

RUN /pyenv/bin/pip3 install numpy
RUN /pyenv/bin/pip3 install pycuda jinja2 h5py mpi4py
RUN /pyenv/bin/pip3 install scipy

WORKDIR /app
COPY . /app

EXPOSE 9041

CMD ["./start_maxwell_docker"]
