# Use Ubuntu as the base image
FROM ubuntu:latest

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget unzip lib32gcc-s1 curl gettext && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/et
WORKDIR /app/et


# Download Wolfenstein: Enemy Territory full stock install of 2.60
RUN wget http://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/et/linux/et-linux-2.60.x86.run -O et-legacy
    
RUN chmod +x et-legacy && \
    ./et-legacy --noexec --target /app/et

RUN cp /app/et/bin/Linux/x86/et* /app/et/

WORKDIR /app

# Download the ET: Legacy patch
RUN wget https://www.etlegacy.com/download/file/590 -O etpatch.tar.gz
RUN tar -xvzf etpatch.tar.gz
RUN mv etlegacy* etpatch
RUN mkdir -p /app/etpatch
WORKDIR /app/etpatch

# Copy our custom server config files
COPY game_settings/etl_server.cfg.template /app/etpatch/etmain/etl_server.cfg.template
COPY game_settings/objectivecyle.cfg /app/etpatch/etmain/objectivecycle.cfg
COPY game_settings/legacy.cfg /app/etpatch/etmain/legacy.cfg

# link the pk3 files from the full install to the patch
RUN ln -s /app/et/etmain/pak0.pk3 /app/etpatch/etmain/pak0.pk3 && \
    ln -s /app/et/etmain/pak1.pk3 /app/etpatch/etmain/pak1.pk3 && \
    ln -s /app/et/etmain/pak2.pk3 /app/etpatch/etmain/pak2.pk3

COPY start.sh /start.sh

# Set the default command to start the server
CMD ["bash", "/start.sh"]

# Expose the default ports
EXPOSE 27960