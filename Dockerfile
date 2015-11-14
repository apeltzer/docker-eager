# Archlinux base image including yaourt
FROM base/archlinux

# Update everything, install our local repository with EAGER packages
RUN echo "Server = http://mirror.de.leaseweb.net/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
RUN echo "[lambdait]" >> /etc/pacman.conf
RUN echo "SigLevel = Never" >> /etc/pacman.conf
RUN echo "Server = http://lambda.informatik.uni-tuebingen.de/repo/mypkgs" >> /etc/pacman.conf
RUN pacman -Sy --noconfirm archlinux-keyring
RUN pacman -Syu  --noconfirm
RUN pacman -S --noconfirm freetype2 ttf-dejavu sudo git libcups mesa-libgl rsync strace r python2 gsl; rm /var/cache/pacman/pkg/*

##Installing Required Packages
##Oracle JDK7, BT2, BWA, Samtools, etc.
#Install all the dependencies of my pipeline

RUN pacman -S --noconfirm jdk7
RUN pacman -S --noconfirm bam2tdf
RUN pacman -S --noconfirm betterrmdup
RUN pacman -S --noconfirm circularmapper clipandmerge
RUN pacman -S --noconfirm fastqc
RUN pacman -S --noconfirm preseq
RUN pacman -S --noconfirm snpcc
RUN pacman -S --noconfirm vcf2draft
RUN pacman -S --noconfirm fastx_toolkit
RUN pacman -S --noconfirm htslib
RUN pacman -S --noconfirm qualimap
RUN pacman -S --noconfirm mapdamage
RUN pacman -S --noconfirm bwa
RUN pacman -S --noconfirm eager-reportengine eagerstat
RUN pacman -S --noconfirm bowtie2
RUN pacman -S --noconfirm picard-tools
RUN pacman -S --noconfirm stampy
RUN pacman -S --noconfirm eager


# X11 login
RUN pacman -Sy --noconfirm openssh
RUN pacman -Sy --noconfirm xorg-xauth
RUN pacman -Sy --noconfirm xorg-xhost
RUN pacman -Sy --noconfirm xorg-xeyes
RUN ssh-keygen -A
RUN sed -i -e 's/#X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config
RUN sed -i -e 's/#UseLogin.*/UseLogin no/' /etc/ssh/sshd_config
RUN echo "eager ALL=(ALL) ALL" >> /etc/sudoers
## user
RUN echo "root:root" |chpasswd
RUN useradd eager -m
RUN echo "eager:eager" |chpasswd

## Install supervisord
RUN pacman -S supervisor --noconfirm
RUN sed -i -e 's/nodaemon=.*/nodaemon=true/' /etc/supervisord.conf
ADD etc/supervisor.d/sshd.ini /etc/supervisor.d/sshd.ini

## Extract script for GATK (only until licencing issues are fixed)
ADD gatk/extract_gatk.sh /usr/local/bin/extract_gatk.sh
ADD etc/supervisor.d/gatk.ini /etc/supervisor.d/gatk.ini
RUN pacman -S --noconfirm gatk


## ssh key
RUN sudo -u eager mkdir /home/eager/.ssh
RUN sudo -u eager touch /home/eager/.ssh/authorized_keys
RUN chmod 600 /home/eager/.ssh/authorized_keys
ADD ssh_eager_rsa.key.pub /tmp/
RUN cat /tmp/ssh_eager_rsa.key.pub >> /home/eager/.ssh/authorized_keys;rm -f /tmp/ssh_eager_rsa.key.pub


EXPOSE 22
CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]
