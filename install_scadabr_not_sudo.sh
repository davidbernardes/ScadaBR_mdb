#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo -e "This script must be run as root. Make sure you used sudo:"
    echo -e "./install_scadabr.sh"
    exit 1
fi

MACHINE_TYPE=`uname -m`

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    echo "64-bit machine detected"
    java6=jre-6u45-linux-x64.bin
else
    echo "32-bit machine detected"
    java6=jre-6u45-linux-i586.bin
fi

tomcat=apache-tomcat-6.0.53.tar.gz
CURRENT_FOLDER=`pwd`

echo -e " - Installing $java6"
echo -e " - Creating folder /opt/java"
mkdir -p /opt/java/ 
echo -e " - Moving $java6 to /opt/java"
cp $java6 /opt/java 
echo -e " - Changing path to /opt/java"
cd /opt/java
echo -e " - Set Permissions"
chmod 755 /opt/java/$java6
echo -e " - Installing $java6" 
./$java6
echo -e " - Creating jre symlink"
ln -s jre1.6.0_45 jre
echo -e " - working on update-alternatives"
update-alternatives --install "/usr/bin/java" "java" "/opt/java/jre/bin/java" 1 
update-alternatives --set java /opt/java/jre/bin/java 
update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/java/jre/bin/javaws" 1
update-alternatives --set javaws /opt/java/jre/bin/javaws
echo -e " - Finished installing Java!"
sleep 3
echo -e " - Installing Tomcat6\n   __________________\n\n"
echo -e " - Creating folder /opt/tomcat6"
mkdir -p /opt/tomcat6
echo -e " - Copying installer $tomcat to /opt/tomcat6"
cp ${CURRENT_FOLDER}/$tomcat /opt/tomcat6/
cd /opt/tomcat6
echo -e " - Set permissions for $tomcat"
chmod +x $tomcat
echo -e " - Decompressing $tomcat"
tar xvf $tomcat
echo -e " - Copying ScadaBR"
cp ${CURRENT_FOLDER}/ScadaBR.war /opt/tomcat6/apache-tomcat-6.0.53/webapps/
echo -e " - Changing Tomcat port to 9090"
cp ${CURRENT_FOLDER}/server.xml /opt/tomcat6/apache-tomcat-6.0.53/conf/
echo -e " - Starting Tomcat6: /opt/tomcat6/apache-tomcat-6.0.53/bin/startup.sh"
/opt/tomcat6/apache-tomcat-6.0.53/bin/startup.sh
