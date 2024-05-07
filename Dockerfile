FROM debian:bullseye-slim

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget unzip gettext && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app/et

# Download Wolfenstein: Enemy Territory full stock install of 2.60 (just need the pk3 files)
RUN wget http://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/et/linux/et-linux-2.60.x86.run -O et-linux && \
    chmod +x et-linux && \
    ./et-linux --noexec --target /app/et && \ 
    cp /app/et/etmain/pak0.pk3 /usr/local/lib/pak0.pk3 && \
    cp /app/et/etmain/pak1.pk3 /usr/local/lib/pak1.pk3 && \
    cp /app/et/etmain/pak2.pk3 /usr/local/lib/pak2.pk3 && \ 
    rm -rf /app/et

WORKDIR /app

# Download the ET: Legacy patch
RUN wget https://www.etlegacy.com/download/file/590 -O etpatch.tar.gz && \
    tar -xvzf etpatch.tar.gz && \
    mv /app/etlegacy*/ /app/etpatch && \
    rm /app/etpatch.tar.gz

RUN ln -s  /usr/local/lib/pak0.pk3 /app/etpatch/etmain/pak0.pk3 && \
    ln -s /usr/local/lib/pak1.pk3 /app/etpatch/etmain/pak1.pk3 && \
    ln -s /usr/local/lib/pak2.pk3 /app/etpatch/etmain/pak2.pk3

# Copy our custom server config files
COPY game_settings/etl_server.cfg.template /app/etpatch/etmain/etl_server.cfg.template
COPY game_settings/objectivecyle.cfg /app/etpatch/etmain/objectivecycle.cfg
COPY game_settings/legacy.cfg /app/etpatch/etmain/legacy.cfg
COPY start.sh /start.sh

# Set the working directory to the ET: Legacy patch
WORKDIR /app/etpatch

# Set the default command to start the server
CMD ["bash", "/start.sh"]

# Expose the default ports
EXPOSE 27960