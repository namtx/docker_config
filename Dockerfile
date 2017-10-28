FROM ubuntu:latest

ENV username namtx
ENV password pass
ENV rootpassword toor

RUN useradd -ms /bin/bash $username
RUN echo $username:$password | chpasswd
RUN adduser $username sudo

RUN apt-get update

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y sudo

RUN apt-get install -y curl
RUN apt-get install -y build-essential
RUN apt-get install -y nano
RUN apt-get install -y vim

RUN apt-get install -y python3 && \
    apt-get install -y python3-pip

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    \curl -L https://get.rvm.io | bash -s stable --ruby && \
    adduser $username rvm

RUN curl -o ./go.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.linux-amd64.tar.gz && \
    rm -f go.linux-amd64.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin"

RUN echo root:$rootpassword | chpasswd

COPY ./entry.sh /
RUN chmod 744 /entry.sh
ENTRYPOINT ["/entry.sh"]

USER $username
WORKDIR /home/$username
