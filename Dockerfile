FROM ubuntu:16.04

#Get dependencies needed for most projects: update as needed for other homebrew projects
RUN apt-get update && apt-get -y install tmux vim git build-essential curl wget cmake gdb gdbserver emacs netcat python2.7 python-pip python-dev sudo socat wget zip bsdmainutils binwalk 

RUN useradd -m user
RUN usermod -s /bin/bash user
ENV SHELL /bin/bash
ENV HOME /home/user
RUN echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER user

RUN mkdir /home/user/tools

WORKDIR /home/user/tools

#Set up devkitarm
RUN mkdir /home/user/tools/devkitbuild
WORKDIR /home/user/tools/devkitbuild
RUN curl -L https://raw.githubusercontent.com/devkitPro/installer/master/perl/devkitARMupdate.pl -o devkitARMupdate.pl
RUN chmod +x ./devkitARMupdate.pl
RUN sudo ./devkitARMupdate.pl /opt/devkitpro #needs to be sudo
RUN echo "export DEVKITPRO=/opt/devkitpro" >> /home/user/.bashrc
RUN echo "export DEVKITARM=/opt/devkitpro/devkitARM" >> /home/user/.bashrc
RUN echo "export PATH=$PATH:/opt/devkitpro/devkitARM/bin" >> /home/user/.bashrc

ENV DEVKITPRO /opt/devkitpro
ENV DEVKITARM /opt/devkitpro/devkitARM


#Get most recent 3ds examples
WORKDIR /home/user/tools
RUN git clone https://github.com/devkitPro/3ds-examples.git
RUN sudo cp -r 3ds-examples $DEVKITPRO/examples/3ds

#Make armips
WORKDIR /home/user/tools
RUN git clone --recursive https://github.com/Kingcom/armips.git
RUN mkdir /home/user/tools/armips/build
WORKDIR /home/user/tools/armips/build
RUN cmake ../
RUN make
RUN sudo cp armips /usr/local/bin

#Make ctrtool / makerom
WORKDIR /home/user/tools
RUN git clone https://github.com/profi200/Project_CTR.git
WORKDIR /home/user/tools/Project_CTR/ctrtool
RUN make
RUN sudo cp ctrtool /usr/local/bin
WORKDIR /home/user/tools/Project_CTR/makerom
RUN make
RUN sudo cp makerom /usr/local/bin

#Get most updated version of ctrulib
WORKDIR /home/user/tools
RUN git clone https://github.com/smealum/ctrulib.git
WORKDIR /home/user/tools/ctrulib/libctru
RUN make
RUN export DEVKITPRO=/opt/devkitpro
RUN export DEVKITARM=/opt/devkitpro/devkitARM
RUN export PATH=$PATH:/opt/devkitpro/devkitARM
RUN sudo -E make install

#Get most updated version of citro3d
WORKDIR /home/user/tools
RUN git clone https://github.com/fincs/citro3d.git
WORKDIR /home/user/tools/citro3d
RUN make
RUN export DEVKITPRO=/opt/devkitpro
RUN export DEVKITARM=/opt/devkitpro/devkitARM
RUN export PATH=$PATH:/opt/devkitpro/devkitARM
RUN sudo -E make install


#Get most updated version of portlibs
WORKDIR /home/user/tools
RUN git clone https://github.com/xerpi/3ds_portlibs.git
WORKDIR /home/user/tools/3ds_portlibs
RUN sudo -E make all
RUN export DEVKITPRO=/opt/devkitpro
RUN export DEVKITARM=/opt/devkitpro/devkitARM
RUN export PATH=$PATH:/opt/devkitpro/devkitARM
RUN sudo -E make install-zlib
RUN sudo -E make install



#Get most updated version of sf2dlib
WORKDIR /home/user/tools
RUN git clone https://github.com/xerpi/sf2dlib.git
WORKDIR /home/user/tools/sf2dlib/libsf2d
RUN make
RUN export DEVKITPRO=/opt/devkitpro
RUN export DEVKITARM=/opt/devkitpro/devkitARM
RUN export PATH=$PATH:/opt/devkitpro/devkitARM
RUN sudo -E make install


#Get most updated version of sftdlib
WORKDIR /home/user/tools
RUN git clone https://github.com/xerpi/sftdlib.git
WORKDIR /home/user/tools/sftdlib/libsftd
RUN make
RUN export DEVKITPRO=/opt/devkitpro
RUN export DEVKITARM=/opt/devkitpro/devkitARM
RUN export PATH=$PATH:/opt/devkitpro/devkitARM
RUN sudo -E make install


#Get most updated version of sfillib
WORKDIR /home/user/tools
RUN git clone https://github.com/xerpi/sfillib.git
WORKDIR /home/user/tools/sfillib/libsfil
RUN make
RUN export DEVKITPRO=/opt/devkitpro
RUN export DEVKITARM=/opt/devkitpro/devkitARM
RUN export PATH=$PATH:/opt/devkitpro/devkitARM
RUN sudo -E make install


#Get Luma3DS and build
WORKDIR /home/user/tools
RUN git clone --recursive https://github.com/AuroraWright/Luma3DS.git
WORKDIR /home/user/tools/Luma3DS
RUN make

#Get latest GodMode9
WORKDIR /home/user/tools
RUN git clone --recursive https://github.com/d0k3/GodMode9.git
WORKDIR /home/user/tools/GodMode9
RUN make

#Get latest Decrypt9WIP
WORKDIR /home/user/tools
RUN git clone --recursive https://github.com/d0k3/Decrypt9WIP.git
WORKDIR /home/user/tools/Decrypt9WIP
RUN make

#Get homemenu hax
WORKDIR /home/user/tools
RUN git clone https://github.com/yellows8/3ds_homemenuhax.git

#Get homemenu PKSM
WORKDIR /home/user/tools
RUN git clone https://github.com/BernardoGiordano/PKSM.git


#Setup VIM configurations
RUN echo "imap jj <Esc>" >> ~/.vimrc
RUN echo "set number" >> ~/.vimrc
RUN echo "syntax on" >> ~/.vimrc
RUN echo "set tabstop=4 shiftwidth=4 expandtab" >> ~/.vimrc
RUN echo "LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS" >> ~/.bashrc

#Set default editor and startup command
WORKDIR /home/user/
ENV EDITOR vim
CMD tmux
