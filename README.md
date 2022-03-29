# robo-cpufreq

Automatic CPU speed & power optimizer for Linux based on active monitoring of laptop's battery state, CPU usage, CPU temperature and system load. This utility improves battery life without making any performancecompromises.


## Why do I need robo-cpufreq?

One of the problems with Linux today on laptops is that CPU will run in unoptimized manner which will negatively reflect on battery life. For example, CPU will run using "performance" governor with turbo boost enabled regardless if it's plugged in to power or not.

Issue can be mitigated by using tools like [indicator-cpufreq](https://itsfoss.com/cpufreq-ubuntu/) or [cpufreq](https://github.com/konkor/cpufreq), but these still require manual action from your side which can be daunting and cumbersome.

Using tools like [TLP](https://github.com/linrunner/TLP) can help in this situation with extending battery life (which is something I used to do for numerous years), but it also might come with its own set of problems, like losing turbo boost.

The original auto-cpufreq is bloated and contains various "enhancements" outside the scope of cpufreq. robo-cpufreq is an approach to managing cpufreq with the \*nix development philosophy of minimalist modular packages. The main difference between this project ant auto-cpufreq is robo-cpufreq will only make changes to how cpufreq works. Bluetooth will not be disabled and no extra fonts will be installed behind your back. Dependancies are kept to an absolute minimum.

Please note: robo-cpufreq aims to replace TLP and/or auto-cpufreq in terms of functionality and after you install robo-cpufreq _it's recommended to remove these other packages_. If more than one are used for same functionality, i.e: to set CPU frequencies it'll lead to unwanted results like overheating. Hence, only use other tools in tandem if you know what you're doing. Support will not be given in helping solve these issues.

#### Supported architectures and devices

Supported devices must have an Intel, AMD or ARM CPUs. This tool was developed to improve performance and battery life on laptops and handheld PC's, but running it on desktop/servers to lower power consumption should also be possible.

## Features

* Monitoring
  * Basic system information
  * CPU frequency (system total & per core)
  * CPU usage (system total & per core)
  * CPU temperature (total average & per core)
  * Battery state
  * System load
* CPU frequency scaling, governor and [turbo boost](https://en.wikipedia.org/wiki/Intel_Turbo_Boost) management based on
  * Battery state
  * CPU usage (total & per core)
  * CPU temperature in combination with CPU utilization/load (prevent overheating)
  * System load
* Automatic CPU & power optimization (temporary and persistent)

## Installing robo-cpufreq

### robo-cpufreq-installer

Get source code, run installer and follow on screen instructions:

```
git clone https://github.com/ShadowBLip/robo-cpufreq.git
cd robo-cpufreq && sudo ./robo-cpufreq-installer
```

In case you encounter any problems with `robo-cpufreq-installer`, please [submit a bug report](https://github.com/ShadowBlip/robo-cpufreq/issues/new).

### AUR package (Arch/Manjaro Linux)

Coming soon.


## Configuring robo-cpufreq

While robo-cpufreq makes all decisions automatically based on various factors like cpu usage, temperature or system load. It's possible to perform addition configurations in 2 ways:

### 1: power_helper.py script

If detected as running robo-cpufreq will disable GNOME Power profiles service, which would otherwise cause conflicts and cause problems. By default robo-cpufreq uses `balanced` mode which also works the best on various systems. However, if you're not reaching maximum frequencies your CPU is capable of with robo-cpufreq, you can switch to `performance` mode. Which will result in higher frequencies by default, but also higher use of energy (battery consumption).

This can be done by running: `sudo python3 power_helper.py --gnome_power_disable performance`

After robo-cpufreq git repo has been cloned (`git clone https://github.com/ShadowBlip/robo-cpufreq.git`), navagiate to directory where `power_helper.py` script resides by running: `cd robo-cpufreq/robo_cpufreq`

After this step, all necessary changes will still be made automatically. However, if you wish to perform additonal "manual" settings this can be done by following instructions explained in next step.

### 2: robo-cpufreq config file

You can configure profiles for battery and power supply. These profiles will let you pick which governor to use and how and when turbo boost is enabled. The possible values for turbo boost behavior are `always`, `auto` and `never`. The default behavior is `auto`, which only kicks in during high load.

By default, robo-cpufreq does not use the config file! If you wish to use it, location where config needs to be placed for it to be read automatically is: `/etc/robo-cpufreq.conf`

#### Example config file contents
```
# settings for when connected to a power source
[charger]
# see available governors by running: cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# preferred governor.
governor = performance

# minimum cpu frequency (in kHz)
# example: for 800 MHz = 800000 kHz --> scaling_min_freq = 800000
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# to use this feature, uncomment the following line and set the value accordingly
# scaling_min_freq = 800000

# maximum cpu frequency (in kHz)
# example: for 1GHz = 1000 MHz = 1000000 kHz -> scaling_max_freq = 1000000
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# to use this feature, uncomment the following line and set the value accordingly
# scaling_max_freq = 1000000

# turbo boost setting. possible values: always, auto, never
turbo = auto

# settings for when using battery power
[battery]
# see available governors by running: cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# preferred governor
governor = powersave

# minimum cpu frequency (in kHz)
# example: for 800 MHz = 800000 kHz --> scaling_min_freq = 800000
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# to use this feature, uncomment the following line and set the value accordingly
# scaling_min_freq = 800000

# maximum cpu frequency (in kHz)
# see conversion info: https://www.rapidtables.com/convert/frequency/mhz-to-hz.html
# example: for 1GHz = 1000 MHz = 1000000 kHz -> scaling_max_freq = 1000000
# to use this feature, uncomment the following line and set the value accordingly
# scaling_max_freq = 1000000

# turbo boost setting. possible values: always, auto, never
turbo = auto
```

## How to run robo-cpufreq

robo-cpufreq can be run by simply running the `robo-cpufreq` and following on screen instructions, i.e:

`sudo roboo-cpufreq`

## roboo-cpufreq modes and options

### Monitor

`sudo roboo-cpufreq --monitor`

No changes are made to the system, and is solely made for demonstration purposes what robo-cpufreq could do differently for your system.

### Live

`sudo robo-cpufreq --live`

Necessary changes are temporarily made to the system which are lost with system reboot. This mode is made to evaluate what the system would behave with auto-cpufreq permanently running on the system.

### Install - roboo-cpufreq daemon

Necessary changes are made to the system for roboo-cpufreq CPU optimizaton to persist across reboots. Daemon is deployed and then started as a systemd service. Changes are made automatically and live stats are generated for monitoring purposes.

`sudo roboo-cpufreq --install`

After daemon is installed, `roboo-cpufreq` is available as a binary and is running in the background. Its stats can be viewed by running: `roboo-cpufreq --stats`

Since daemon is running as a systemd service, its status can be seen by running:

`systemctl status roboo-cpufreq`

### Remove - roboo-cpufreq daemon

roboo-cpufreq daemon and its systemd service, along with all its persistent changes can be removed by running:

`sudo roboo-cpufreq --remove`

### Stats

If daemon has been installed, live stats of CPU/system load monitoring and optimization can be seen by running:

`roboo-cpufreq --stats`

## Troubleshooting

**Q:** If after installing roboo-cpufreq you're (still) experiencing:
* high CPU temperatures
* CPU is not scaling to minimum/maximum frequencies
* suboptimal CPU peformance

**A:** If you're using `intel_pstate` CPU management driver consider changing it to: `acpi-cpufreq`.

This can be done by editting `/etc/default/grub` file and appending `intel_pstate=disable` to `GRUB_CMDLINE_LINUX_DEFAULT` line, followed by `sudo update-grub`

Example line change:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_pstate=disable"
```

### Code contribution

Supporting the project consists of making a code or documentation contribution. If you have an idea for a new features or want to implement some of the existing feature requests or fix some of the bugs & issues, please make your changes and submit a pull request which I'll be glad to review. If your changes are accepted you'll be credited as part of releases page.

