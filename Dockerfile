FROM osrm/osrm-backend:v5.22.0
ADD install_depedencies.sh ./install_depedencies.sh
ADD freight.lua ./freight.lua.sh
RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's|security.debian.org|archive.debian.org/|g' \
           -e '/stretch-updates/d' /etc/apt/sources.list
RUN ./install_depedencies.sh
ENTRYPOINT ["sh","-c", "wget -N -nv --show-progress https://download.geofabrik.de/europe/france/alsace-latest.osm.pbf && osmium tags-filter -o filtered-latest.osm.pbf  --overwrite alsace-latest.osm.pbf 'nw/railway' && osrm-extract -p /data/freight.lua /data/filtered-latest.osm.pbf && osrm-partition /data/filtered-latest.osm.pbf && osrm-customize /data/filtered-latest.osm.pbf && osrm-routed --algorithm mld /data/filtered-latest.osm.pbf"]





