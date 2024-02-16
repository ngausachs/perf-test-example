#!/bin/sh

wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/1.7/jmeter-plugins-manager-1.7.jar -O ./lib/ext/jmeter-plugins-manager-1.7.jar
wget https://repo1.maven.org/maven2/com/github/johrstrom/jmeter-prometheus-plugin/0.6.0/jmeter-prometheus-plugin-0.6.0.jar -O ./lib/ext/jmeter-prometheus-plugin-0.6.0.jar

/mnt/scripts/runTests.sh

echo "Work in progress. For now open a shell and play with jmeter"

tail -f /dev/null