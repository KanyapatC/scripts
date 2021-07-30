<Script for Linux>

Step 1: Script name "wildfly" you must edit <YourPath> and <YourService>
Step 2: Move file wildfly to path: /etc/rc.d/init.d
Step 3:
	Command
	root@<Prod AppServer> ~]$ chmod 755 wildfly
	root@<Prod AppServer> ~]$ ln -s /etc/init.d/wildfly /etc/rc.d/rc0.d/K01wildfly
	root@<Prod AppServer> ~]$ ln -s /etc/init.d/wildfly /etc/rc.d/rc1.d/K01wildfly
	root@<Prod AppServer> ~]$ ln -s /etc/init.d/wildfly /etc/rc.d/rc2.d/S99wildfly
	root@<Prod AppServer> ~]$ ln -s /etc/init.d/wildfly /etc/rc.d/rc3.d/S99wildfly
	root@<Prod AppServer> ~]$ ln -s /etc/init.d/wildfly /etc/rc.d/rc4.d/S99wildfly
	root@<Prod AppServer> ~]$ ln -s /etc/init.d/wildfly /etc/rc.d/rc5.d/S99wildfly
	root@<Prod AppServer> ~]$ ln -s /etc/init.d/wildfly /etc/rc.d/rc6.d/K01wildfly
	root@<Prod AppServer> ~]$ systemctl daemon-reload
----- Successfully -------
 