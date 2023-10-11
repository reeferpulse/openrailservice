.PRECIOUS: %.pbf

# List all the source countries we need
WANTED_COUNTRIES := $(shell grep -v "\#" countries.wanted)

# Transform "belgium" to "world/belgium-latest.osm.pbf"
COUNTRIES_PBF := $(addsuffix -latest.osm.pbf,$(addprefix world/,$(WANTED_COUNTRIES)))

# Download the raw source file of a country
world/%.osm.pbf:
	sudo wget -N -nv -P world/ --show-progress  https://download.geofabrik.de/europe/$*.osm.pbf

# Filter a raw country (in world/*) to rail-only data (in filtered/*)
filtered/%.osm.pbf: world/%.osm.pbf filter.params
	sudo osmium tags-filter --expressions=filter.params $< -o $@ --overwrite

# Combine all rail-only data (in filtered/*) into one file
output/filtered.osm.pbf: $(subst world,filtered,$(COUNTRIES_PBF))
	sudo osmium merge $^ -o $@ --overwrite

# Compute the real OSRM data on the combined file
output/filtered.osrm: output/filtered.osm.pbf freight.lua
	sudo docker run -t -v $(shell pwd):/opt/host osrm/osrm-backend:v5.22.0 osrm-extract -p /opt/host/freight.lua /opt/host/$<

	sudo docker run -t -v $(shell pwd):/opt/host osrm/osrm-backend:v5.22.0 osrm-partition /opt/host/$<
	sudo docker run -t -v $(shell pwd):/opt/host osrm/osrm-backend:v5.22.0 osrm-customize /opt/host/$<

all: output/filtered.osrm

serve: output/filtered.osrm freight.lua
	sudo docker run -t -i -p 5000:5000 -v $(shell pwd):/opt/host osrm/osrm-backend:v5.22.0 osrm-routed --algorithm mld /opt/host/$<
