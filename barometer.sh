#!/bin/sh
# 26-jun-17 rca 
# Get the weather report from MSN once an hour (at first) to look for 
# barometer readings put into /home/rca/yyyymmddhhmm.txt
URL="http://www.msn.com/en-us/weather/today/Longmont,Colorado,United-States/we-city-40.164,-105.100"
WEATHERDIR=/home/rca/weather

## INSERT INTO `weather` (`timestamp`, `city_name`, `city_lat`, `city_lon`, `temperature`, `humidity`, `barometer`) 
## VALUES (TIMESTAMP(''), 'Longmont', '-40.164', '-105.100', '90', '40', '29.85')

## INSERT INTO `weather` (`timestamp`, `city_name`, `city_lat`, `city_lon`, `temperature`, `humidity`, `barometer`) 
## VALUES ('2017-06-28 19:13:00', 'Longmont', '-40.164', '-105.100', '90', '40', '29.85')


#after much testing, this seems to work as of 27-jun-2017 
# notice cricket and att are merged, so use some of the same infrastructure
EMAIL=7208775915@cricketwireless.net
EMAIL=7208775915@txt.att.net

# use awk and sed to get the barometer values
## grep  Barom weather/*txt| \
##    awk -F ">" '{print $1,$3, $4}'|\
##    sed 's/<\/span/,/'| \
##    sed 's/<\/li//g'| \
##    sed 's/<li//g'
## grep  Barom weather/*txt| awk -F ">" '{print $1,$3, $4}'|sed 's/<\/span/,/'| sed 's/<\/li//g'| sed 's/<li//g'
## grep  Humid weather/*txt| awk -F ">" '{print $1,$3, $4}'|sed 's/<\/span/,/'| sed 's/<\/li//g'| sed 's/<li//g'

if [ ! -d $WEATHERDIR ] 
then
  mkdir $WEATHERDIR
fi

TSTAMP=`date +%Y-%m-%d_%H:%M:%S`
FILENAME=$SWEATHERDIR/`echo $TSTAMP| tr '/://'`.txt
echo $TSTAMP
echo $FILENAME
/usr/bin/wget $URL --output-document=$WEATHERDIR/$TSTAMP.txt
