FROM ubuntu:22.04

RUN apt update -yy && apt upgrade -yy

RUN apt install -y cabal-install \
    ghc \
    pkg-config \
    libghc-zlib-dev \
    zlib1g-dev \
    g++ 

RUN cabal update

RUN cabal install --lib split \
    pandoc

RUN mkdir /build
COPY mdToHtml.hs /build/

WORKDIR /build/
RUN ghc mdToHtml.hs
COPY mdToHtml .

