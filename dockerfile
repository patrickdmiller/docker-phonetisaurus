FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
COPY openfst-1.7.2/ openfst-1.7.2/
COPY Phonetisaurus/ Phonetisaurus/
COPY mitlm/ mitlm/
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa \
  && apt update \
  && apt install -y python3.8 pip \
  && apt install -y git g++ autoconf-archive make libtool python-setuptools python-dev gfortran 

RUN cd openfst-1.7.2 && ./configure --enable-static --enable-shared --enable-far --enable-ngram-fsts \
  && make -j && make install && cd ..
RUN export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:/usr/local/lib/fst

RUN cd Phonetisaurus && pip3 install pybindgen
ENV PYTHON=python3
RUN cd Phonetisaurus && ./configure --enable-python && make && make install \
  && cd python && cp ../.libs/Phonetisaurus.so . && python3 setup.py install && cd ../..

RUN cd mitlm/ && ./autogen.sh && make && make install

WORKDIR /model
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:/usr/local/lib/fst
CMD pwd && phonetisaurus-train --lexicon cmudict.formatted.dict --seq2_del


