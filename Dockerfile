# Archlinux base image including yaourt
FROM base/archlinux

# Update everything, install our local repository with EAGER packages
RUN echo "Server = http://mirror.de.leaseweb.net/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
RUN echo "[lambdait]" >> /etc/pacman.conf
RUN echo "SigLevel = Never" >> /etc/pacman.conf
RUN echo "Server = http://lambda.informatik.uni-tuebingen.de/repo/mypkgs" >> /etc/pacman.conf
RUN pacman-key --refresh-keys
#RUN pacman -Syu  --noconfirm
RUN pacman-db-upgrade
RUN pacman -Syu  --noconfirm
RUN pacman -S --noconfirm freetype2 ttf-dejavu sudo git libcups mesa-libgl rsync strace r python2 gsl; rm /var/cache/pacman/pkg/*

##Installing Required Packages
##Oracle JDK7, BT2, BWA, Samtools, etc.
#Install all the dependencies of my pipeline

RUN pacman -S --noconfirm jdk7
RUN pacman -S --noconfirm bam2tdf
RUN pacman -S --noconfirm dedup
RUN pacman -S --noconfirm circularmapper clipandmerge
RUN pacman -S --noconfirm fastqc
RUN pacman -S --noconfirm preseq
RUN pacman -S --noconfirm vcf2genome
RUN pacman -S --noconfirm fastx_toolkit
RUN pacman -S --noconfirm htslib
RUN pacman -S --noconfirm qualimap
RUN pacman -S --noconfirm mapdamage
RUN pacman -S --noconfirm bwa
RUN pacman -S --noconfirm eager-reportengine eagerstat
RUN pacman -S --noconfirm bowtie2 
RUN pacman -S --noconfirm picard-tools 
RUN pacman -S --noconfirm stampy 
RUN pacman -S --noconfirm angsd
RUN pacman -S --noconfirm schmutzi --force
RUN pacman -S --noconfirm eager --force
RUN pacman -S --noconfirm gatk --force

# Add GATK Licence to image to be consistent with Licencing Permission by Broad Institute
ADD GATKLicence.txt /usr/share/licenses/common/GATKLicence.txt


# X11 login
RUN pacman -Sy --noconfirm openssh
RUN pacman -Sy --noconfirm xorg-xauth
RUN pacman -Sy --noconfirm xorg-xhost
RUN pacman -Sy --noconfirm xorg-xeyes
RUN ssh-keygen -A
RUN sed -i -e 's/#X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config
RUN sed -i -e 's/#UseLogin.*/UseLogin no/' /etc/ssh/sshd_config
RUN sed -i -e 's/#AllowTcpForwarding.*/AllowTcpForwarding yes/' /etc/ssh/sshd_config
RUN sed -i -e 's/#X11UseLocalhost.*/X11UseLocalhost yes/' /etc/ssh/sshd_config
RUN sed -i -e 's/#X11DisplayOffset.*/X11DisplayOffset 10/' /etc/ssh/sshd_config
RUN echo "eager ALL=(ALL) ALL" >> /etc/sudoers

## Install supervisord
RUN pacman -S supervisor --noconfirm
RUN sed -i -e 's/nodaemon=.*/nodaemon=true/' /etc/supervisord.conf
ADD etc/supervisor.d/sshd.ini /etc/supervisor.d/sshd.ini

## ssh key
RUN mkdir -p /home/eager/.ssh
RUN touch /home/eager/.ssh/authorized_keys
RUN chmod 600 /home/eager/.ssh/authorized_keys
ADD ssh_eager_rsa.key.pub /tmp/
RUN cat /tmp/ssh_eager_rsa.key.pub >> /home/eager/.ssh/authorized_keys;rm -f /tmp/ssh_eager_rsa.key.pub

## user
RUN echo "root:root" |chpasswd
ADD opt/qnib/bin/create-user.sh /opt/qnib/bin/
ADD etc/supervisor.d/create-user.ini /etc/supervisor.d/



EXPOSE 22
CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]
