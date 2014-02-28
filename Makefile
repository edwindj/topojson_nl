
GEMEENTE = CBS_gemeenten_2003_gen.topojson \
           CBS_gemeenten_2005_gen.topojson \
           CBS_gemeenten_2006_gen.topojson \
           CBS_gemeenten_2007_gen.topojson \
           CBS_gemeenten_2008_gen.topojson \
           CBS_gemeenten_2009_gen.topojson \

PROVINCIES = CBS_provincies_2003_gen.topojson \
             CBS_provincies_2005_gen.topojson \
             CBS_provincies_2006_gen.topojson \
             CBS_provincies_2007_gen.topojson \
             CBS_provincies_2008_gen.topojson \
             CBS_provincies_2009_gen.topojson \
             CBS_provincies_2010_gen.topojson \
             CBS_provincies_2011_gen.topojson \
             CBS_provincies_2012_gen.topojson \
             CBS_provincies_2013_gen.topojson \

topo: ${GEMEENTE} ${PROVINCIES}

gemeente: ${GEMEENTE}
	topojson -q 2000 -p -o gemeente.topojson ${GEMEENTE} 

%.topojson: layers/%.geojson
	topojson -p --id-property GM_CODE --spherical -o $@ $< 

clean:
	rm *.topojson