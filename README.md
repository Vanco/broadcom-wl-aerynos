# broadcom-wl-aerynos

Broadcom Linux hybrid wireless driver (64-bit)

This project fetch the source from the archlinux package and buid for AerynOS.

The driver is for Broadcom BCM43xx 802.11 wireless devices. and the package well upload to the AerynOS repository.
Install the package by

```sh
sudo moss install broadcom-wl
```

## How to build this project

```sh
# find the version from the archlinux repository before you going.
$ sh fetch-source.sh 6.30.223.271-42

# auto build and package
$ sh autobuild-package.sh
```

## Do every thing by hand.

> **Warning**
: AerynOS is designed in some spectial way, install any thing into `/usr` may be lost after the system update.


If you want install by hand, you can do like this:

#### 1) Prerequisites

The following kernel modules are incompatible with this driver and should not be loaded:
* bcm43xx
* ssb
* b43
* ndiswrapper
* brcm80211
* bcma
* brcmsmac

Make sure to unload (`rmmod` command) and blacklist those modules in order to prevent them from being automatically
reloaded during the next system startup:

`/etc/modprobe.d/50-broadcom-wl-blacklist.conf`
```
# wireless drivers (conflict with Broadcom hybrid wireless driver 'wl')
blacklist bcm43xx
blacklist ssb
blacklist b43
blacklist ndiswrapper
blacklist brcm80211
blacklist bcma
blacklist brcmsmac
```

#### 2) Prepare the install location

As the AerynOS's `/usr` is totally controlled by the system, we need to install the driver to `/usr/local`,
the `/usr/local` is link to `/var/local` in AerynOS.

Set the `INSTALL_MOD_PATH` to `/usr/local` in `/etc/environment.d/10-external-mod.conf`, and patch in the `Makefile`:
```sh
patch -p1 < 001-makefile.patch
```
the final install location is `/usr/local/lib/modules/6.13.10-93.desktop/kernel/drivers/net/wireless/wl.ko`.

#### 3) Build the driver

The AerynOS use `clang` as the default compiler, and `ld.lld` as the linker.
```sh
$ make clean
$ make CC=clang LD=ld.lld V=1
```

#### 4) Install the driver and configure the driver

```sh
$ sudo make install
$ depmod -A -b /usr/local
# try to load the module
$ modprobe wl
```
Put imcompatible modules in the blacklist:

`/etc/modprobe.d/50-wl.conf`
```
blacklist b43
blacklist ssb
blacklist cordic
blacklist bcma
# config wl use the /usr/local
install wl /sbin/modprobe -d /usr/local -i wl
```

Now config automatically load module:
```sh
$ echo "wl" | sudo tee /etc/modules-load.d/wl.conf
```

#### 5) Check the driver
```sh
reboot
```

After reboot, check the driver:
```sh
$ modinfo -b /usr/local wl
filename:       /usr/local/lib/modules/6.13.10-93.desktop/kernel/drivers/net/wireless/wl.ko
license:        MIXED/Proprietary
name:           wl
depends:
alias:          pci:v*d*sv*sd*bc02sc80i*
vermagic:       6.13.10-93.desktop SMP preempt mod_unload
retpoline:      Y
parm:           intf_name:string
parm:           nompc:int
parm:           instance_base:int
parm:           piomode:int
parm:           oneonly:int
parm:           wl_txq_thresh:int
parm:           passivemode:int
```


## See also

* [Official README file][3] (download)
* Arch Linux packages: [broadcom-wl][4] / [broadcom-wl-dkms][5]
* Debian packages: [broadcom-sta][6] ([source repository][7])
* [kmod-wl][8] package for RPM Fusion ([source repository][9])

[3]: https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/README_6.30.223.271.txt
[4]: https://archlinux.org/packages/extra/x86_64/broadcom-wl/
[5]: https://archlinux.org/packages/extra/x86_64/broadcom-wl-dkms/
[6]: https://packages.debian.org/source/sid/broadcom-sta
[7]: https://salsa.debian.org/broadcom-sta-team/broadcom-sta
[8]: http://download1.rpmfusion.org/nonfree/fedora/development/rawhide/Everything/x86_64/os/repoview/kmod-wl.html
[9]: https://pkgs.rpmfusion.org/cgit/nonfree/wl-kmod.git/
