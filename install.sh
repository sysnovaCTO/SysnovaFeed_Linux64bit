#!/bin/sh
#	This script run for SysnovaFeed 


JAVA=$(which java)
if [ ! -x "${JAVA}" ]; then
	echo no java found. Install Java version 1.7.0 or higher
	exit
else
   	# export JAVA_VERSION
	JAVA_VERSION=`java -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $3 }'`
	JAVA_VER=$(java -version 2>&1 | sed -n ';s/.* version "\(.*\)\.\(.*\)\..*"/\1\2/p;')

	if [ "$JAVA_VER" -ge 17 ]; then
	 	echo $JAVA_VERSION
	else
		echo "Error: Java version is too low. At least Java >= 1.7.0 needed.";
		exit
	fi
fi

if [ $(dpkg-query -W -f='${Status}' libglpk-java 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo Installing gplk..........
	sudo apt-get install libglpk-java -y
	status=$?
	if [ $status != 0 ]; then
	    echo glpk Installation failed, exiting.
	    exit
	fi
else
	echo "libglpk already installed";
fi


# Install h2 database
echo Installing h2 database......
dir=$(dirname "$(readlink -f "$0")")
cp $dir/db/feedDatabase.h2.db ~
status=$?
if [ $status != 0 ]; then
   	h2 database Installation failed libre.h2.db
	exit
fi
#cp $dir/db/feedDatabase.mv.db ~
#status=$?
#if [ $status != 0 ]; then
#   	h2 database Installation failed libre.mv.db
#	exit
#fi
chmod +x $dir/*.sh

echo Successful. Installation done!!!!!
exit 0
