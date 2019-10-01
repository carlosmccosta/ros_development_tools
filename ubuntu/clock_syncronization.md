# Install chrony

```
sudo apt-get install chrony -y
```

Check chrony configuration [documentation](https://chrony.tuxfamily.org/doc/3.5/chrony.conf.html) and [FAQ](https://chrony.tuxfamily.org/faq.html).



# Enable chrony daemon at boot

```
sudo systemctl enable chronyd
```
or
```
sudo systemctl enable /lib/systemd/system/chrony.service
```

After reboot, if the chronyd is dead (sudo systemctl status chrony), disable systemd-timesyncd:
```
sudo systemctl disable systemd-timesyncd
```
or
```
sudo systemctl disable /lib/systemd/system/systemd-timesyncd
```



# Configure the master /etc/chrony/chrony.conf

Setup the reference clocks for the server:
```
pool ntp.ubuntu.com        iburst maxsources 4
pool 0.ubuntu.pool.ntp.org iburst maxsources 1
pool 1.ubuntu.pool.ntp.org iburst maxsources 1
pool 2.ubuntu.pool.ntp.org iburst maxsources 2
```

Setup the drift file location:
```
driftfile /var/lib/chrony/chrony.drift
```

Setup the clock drift correction on chrony daemon startup (if the drift is higher than 1 second, a clock step will be performed):
```
# initstepslew step_threshold_seconds [hostname]
initstepslew 1
```

If your master is on a closed network without internet, you can use your clients clocks for making sure that on boot the master clock is not started incorrectly. Change the line above to:
```
initstepslew 1 client1_ip client2_ip client3_ip
```

Setup the clock drift correction during runtime, to perform a step when the drift is higher than 1 second:
```
# makestep step_threshold_seconds limit_of_steps
makestep 1 -1
```

If your master and clients are on a closed local network and the master usually has no connection to the internet, set the master state as synchronized using
```
local stratum 8 # change stratum from 10 to 8
```

For allowing manual time change using chronyc settime command, add:
```
manual
```


If your server will have ntpd clients, add the broadcast configurations and allow clients in the specified subnet to connect to the master:
```
# broadcast interval_seconds address [port]
broadcast 10 192.168.255.255
# allow [all] [subnet]
allow 192.168/16
```

Enable rtcsync for copying the system time to the rtc hardware clock:
```
rtcsync
```



# Configure the clients /etc/chrony/chrony.conf

Add master to top of servers list and comment the default servers:
```
# server hostname [option]
server master_ip iburst
# allow [all] [subnet]
allow master_ip
```

Configure clock drift correction:
```
# initstepslew step_threshold_seconds [hostname]
initstepslew 1 master_ip
# makestep step_threshold_seconds limit_of_steps
makestep 1 -1
```

For allowing manual time change using chronyc settime command, add:
```
manual
```

Enable rtcsync for copying the system time to the rtc hardware clock:
```
rtcsync
```



# FAQ

## Restart chrony
```
sudo /etc/init.d/chrony restart
```
or
```
sudo systemctl restart chrony
```


## Check chrony daemon status

```
sudo systemctl status chrony
```


## Force chrony time update without slew
```
sudo chronyc -a makestep
```


## Check chrony synchronization status
```
chronyc tracking
```


## Check chrony clients connected to the master server
```
chronyc clients
```


## Check in the chrony clients, their time sources (servers)
```
chronyc sources -v
chronyc sourcestats -v
```


## Check system time:
```
date
```
or
```
timedatectl status
```
or
```
sudo hwclock --show
```


## Manual set system date:
```
sudo date --set "yyyymmdd hh:mm:ss"
```
or, from a remote pc
```
sudo date --set "`ssh user@server_ip date --rfc-3339="ns"`"
```
