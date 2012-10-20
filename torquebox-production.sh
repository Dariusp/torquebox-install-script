yum install java
cd /opt
wget http://torquebox.org/release/org/torquebox/torquebox-dist/2.1.2/torquebox-dist-2.1.2-bin.zip
mkdir /opt/torquebox
unzip torquebox-dist-2.1.2-bin.zip -d /opt/torquebox/
cd /opt/torquebox
ln -s torquebox-dist-2.1.2 current
touch /etc/profile.d/torquebox.sh
echo "export TORQUEBOX_HOME=/opt/torquebox/current" >> /etc/profile.d/torquebox.sh 
echo "export JBOSS_HOME=$TORQUEBOX_HOME/jboss" >> /etc/profile.d/torquebox.sh
echo "export JRUBY_HOME=$TORQUEBOX_HOME/jruby" >> /etc/profile.d/torquebox.sh
echo "PATH=$JBOSS_HOME/bin:$JRUBY_HOME/bin:$PATH" >> /etc/profile.d/torquebox.sh

cp $JBOSS_HOME/bin/init.d/jboss-as-standalone.sh /etc/init.d/jboss-as-standalone
mkdir /etc/jboss-as
touch /etc/jboss-as/jboss-as.conf
echo "# General configuration for the init.d script" >> /etc/jboss-as/jboss-as.conf
echo "JBOSS_USER=torquebox" >> /etc/jboss-as/jboss-as.conf 
echo "JBOSS_HOME=/opt/torquebox/current/jboss" >> /etc/jboss-as/jboss-as.conf
echo "JBOSS_PIDFILE=/var/run/torquebox/torquebox.pid" >> /etc/jboss-as/jboss-as.conf
echo "JBOSS_CONSOLE_LOG=/var/log/torquebox/console.log" >> /etc/jboss-as/jboss-as.conf
echo "JBOSS_CONFIG=standalone-ha.xml" >> /etc/jboss-as/jboss-as.conf
chkconfig --add jboss-as-standalone
service jboss-as-standalone start
