FROM debian:buster
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
RUN apt-get update && apt-get install -y \
  python3.6 \
  python3-pip \
  r-base \
  wget \
  bzip2 \
  ca-certificates \
  git \
  curl

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

COPY requirements.txt /tmp/
RUN conda config --add channels conda-forge
RUN conda install xgboost
RUN pip install --requirement /tmp/requirements.txt
WORKDIR /tmp
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/LATEST/ncbi-magicblast-1.3.0-x64-linux.tar.gz
RUN tar xzf ncbi-magicblast-1.3.0-x64-linux.tar.gz
RUN mv ncbi-magicblast-1.3.0/bin/* /usr/bin/
ADD . /tmp
