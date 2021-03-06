FROM ubuntu:latest

ENV BOTDIR /opt/bot

RUN apt-get update && \
  apt-get install -y wget vim && \
  wget -q -O - https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install -y git build-essential nodejs && \
  rm -rf /var/lib/apt/lists/* && \
  git clone --depth=1 https://github.com/nhoag/bot.git ${BOTDIR}

# Tout ça pour Skype :p
RUN apt-get update
RUN apt-get install -y python-software-properties python software-properties-common
RUN add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y skype

RUN apt-get install -y xvfb x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic python-pip redis-server

WORKDIR ${BOTDIR}
       
RUN pip install Skype4Py
 
ENV HUBOT_PORT 8080
#ENV HUBOT_ADAPTER shell
ENV HUBOT_ADAPTER hubot-skype
ENV HUBOT_NAME hubot
ENV PORT ${HUBOT_PORT}

EXPOSE ${HUBOT_PORT}

ADD dialogue.coffee ${BOTDIR}/scripts/example.coffee
ADD package.json ${BOTDIR} 
ADD external-scripts.json ${BOTDIR}
ADD Procfile ${BOTDIR}

RUN npm install
RUN npm install --save hubot-skype

ADD .Skype /root/.Skype

#ADD start.sh ${BOTDIR}/start.sh
#RUN chmod +x ${BOTDIR}/start.sh

#CMD ./start.sh

ADD hubot-run.sh ${BOTDIR}/hubot-run.sh
#CMD xvfb-run /bin/sh ${BOTDIR}/hubot-run.sh
CMD tail -f /dev/null

#Inspiré de https://github.com/netpro2k/hubot-skype
#RUN npm install -g hubot coffee-script
#RUN hubot --create hubot-skype
#WORKDIR hubot-skype
#ADD hubot-scripts.json /hubot-skype/hubot-scripts.json
#ADD .Skype /.Skype
#ADD hubot-run.sh /hubot-skype/hubot-run.sh
#CMD xvfb-run /bin/sh /hubot-skype/hubot-run.sh
