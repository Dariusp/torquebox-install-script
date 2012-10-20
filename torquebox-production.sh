TORQUEBOX_VERSION=2.1.2
TORQUEBOX_URL=http://torquebox.org/release/org/torquebox/torquebox-dist/2.1.2/torquebox-dist-$TORQUEBOX_VERSION-bin.zip
TORQUEBOX_ZIP=torquebox-$TORQUEBOX_VERSION.zip
TORQUEBOX_PROFILE=/etc/profile.d/torquebox.sh

yum install java
cd /opt
if [ ! -f $TORQUEBOX_ZIP ]
then
	wget -O $TORQUEBOX_ZIP $TORQUEBOX_URL
fi

if [ ! -d /opt/torquebox ]
then
	mkdir /opt/torquebox
	unzip $TORQUEBOX_ZIP -d /opt/torquebox/
	cd /opt/torquebox
	ln -s torquebox-$TORQUEBOX_VERSION current
fi



if [ ! -f $TORQUEBOX_PROFILE ]
then
	touch $TORQUEBOX_PROFILE
	export TORQUEBOX_HOME=/opt/torquebox/current
	export JBOSS_HOME=$TORQUEBOX_HOME/jboss
	export JRUBY_HOME=$TORQUEBOX_HOME/jruby
	PATH=$JBOSS_HOME/bin:$JRUBY_HOME/bin:$PATH
	echo "export TORQUEBOX_HOME=/opt/torquebox/current" >> /etc/profile.d/torquebox.sh 
	echo "export JBOSS_HOME=$TORQUEBOX_HOME/jboss" >> /etc/profile.d/torquebox.sh
	echo "export JRUBY_HOME=$TORQUEBOX_HOME/jruby" >> /etc/profile.d/torquebox.sh
	echo "PATH=$JBOSS_HOME/bin:$JRUBY_HOME/bin:$PATH" >> /etc/profile.d/torquebox.sh
fi
if [ ! -f /etc/init.d/jboss-as-standalone ]
then
	cp $JBOSS_HOME/bin/init.d/jboss-as-standalone.sh /etc/init.d/jboss-as-standalone
fi
if [ ! -f /etc/jboss-as/jboss-as.conf ]
then
	if [ ! -d /etc/jboss-as ]
	then	
		mkdir /etc/jboss-as
	fi
	touch /etc/jboss-as/jboss-as.conf
	echo "# General configuration for the init.d script" >> /etc/jboss-as/jboss-as.conf
	echo "JBOSS_USER=torquebox" >> /etc/jboss-as/jboss-as.conf 
	echo "JBOSS_HOME=/opt/torquebox/current/jboss" >> /etc/jboss-as/jboss-as.conf
	echo "JBOSS_PIDFILE=/var/run/torquebox/torquebox.pid" >> /etc/jboss-as/jboss-as.conf
	echo "JBOSS_CONSOLE_LOG=/var/log/torquebox/console.log" >> /etc/jboss-as/jboss-as.conf
	echo "JBOSS_CONFIG=standalone-ha.xml" >> /etc/jboss-as/jboss-as.conf
fi
chkconfig --add jboss-as-standalone
service jboss-as-standalone start
