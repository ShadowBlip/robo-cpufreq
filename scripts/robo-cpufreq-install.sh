#!/bin/bash
#
# robo-cpufreq daemon install script
# reference: https://github.com/ShadowBlip/robo-cpufreq
# Thanks to https://github.com/errornonamer for openrc fix
echo -e "\n------------------ Running robo-cpufreq daemon install script ------------------"

if [[ $EUID != 0 ]];
then
	echo -e "\nERROR\nMust be run as root (i.e: 'sudo $0')\n"
	exit 1
fi

# First argument is the "sv" path, second argument is the "service" path this
# only exist because the path between distros may vary
runit_ln() {
	echo -e "\n* Deploy robo-cpufreq runit unit file"
	mkdir "$1"/sv/robo-cpufreq
	cp /usr/local/share/robo-cpufreq/scripts/robo-cpufreq-runit "$1"/sv/robo-cpufreq/run
	chmod +x "$1"/sv/robo-cpufreq/run

	echo -e "\n* Creating symbolic link ($2/service/robo-cpufreq -> $1/sv/robo-cpufreq)"
	ln -s "$1"/sv/robo-cpufreq "$2"/service
}

# sv commands
sv_cmd() {
	echo -e "\n* Stopping robo-cpufreq daemon (runit) service"
	sv stop robo-cpufreq
	echo -e "\n* Starting robo-cpufreq daemon (runit) service"
	sv start robo-cpufreq
	sv up robo-cpufreq
}

# Installation for runit, we still look for the distro because of the path may
# vary.
if [ "$(ps h -o comm 1)" = "runit" ];then
	if [ -f /etc/os-release ];then
		eval "$(cat /etc/os-release)"
		case $ID in
			void)
				runit_ln /etc /var
				sv_cmd
			;;
			artix)
			# Note: Artix supports other inits than runnit
				runit_ln /etc/runit /run/runit
				sv_cmd
			;;
			*)
				echo -e "\n* Runit init detected but your distro is not supported\n"
				echo -e "\n* Please open an issue on https://github.com/ShadowBlip/robo-cpufreq\n"
		esac
	fi
# Install script for systemd
elif [ "$(ps h -o comm 1)" = "systemd" ];then
    echo -e "\n* Deploy robo-cpufreq systemd unit file"
    cp /usr/local/share/robo-cpufreq/scripts/robo-cpufreq.service /etc/systemd/system/robo-cpufreq.service

    echo -e "\n* Reloading systemd manager configuration"
    systemctl daemon-reload

    echo -e "\n* Stopping robo-cpufreq daemon (systemd) service"
    systemctl stop robo-cpufreq

    echo -e "\n* Starting robo-cpufreq daemon (systemd) service"
    systemctl start robo-cpufreq

    echo -e "\n* Enabling robo-cpufreq daemon (systemd) service at boot"
    systemctl enable robo-cpufreq
# Install script for openrc
elif [ "$(ps h -o comm 1)" = "init" ];then
	echo -e "\n* Deploying robo-cpufreq openrc unit file"
	cp /usr/local/share/robo-cpufreq/scripts/robo-cpufreq-openrc /etc/init.d/robo-cpufreq
	chmod +x /etc/init.d/robo-cpufreq

	echo -e "Starting robo-cpufreq daemon (openrc) service"
	rc-service robo-cpufreq start

	echo -e "\n* Enabling robo-cpufreq daemon (openrc) service at boot"
	rc-update add robo-cpufreq
else
  echo -e "\n* Unsupported init system detected, could not install the daemon\n"
  echo -e "\n* Please open an issue on https://github.com/ShadowBlip/robo-cpufreq\n"
fi
