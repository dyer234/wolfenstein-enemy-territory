
cd /app/etpatch/etmain
envsubst < etl_server.cfg.template > etl_server.cfg

cd /app/etpatch
./etlded.x86_64 +exec etl_server.cfg
