FROM ubuntu:focal

RUN apt-get update && apt install lsb-release net-tools vim openssh-server sudo -y
RUN apt install git build-essential libpam0g-dev libcurl4-openssl-dev  libqrencode-dev libssl-dev -y

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 user1
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 user2

RUN sed -i 's/@include common-auth/#@include common-auth\nauth required deviceflow.so/' /etc/pam.d/sshd
RUN sed -i 's/@include common-password/#@include common-password/'  /etc/pam.d/sshd
RUN sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config

COPY lib/deviceflow.so /lib/security/deviceflow.so

RUN  echo 'user1:1' | chpasswd
RUN  echo 'user2:1' | chpasswd

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]

