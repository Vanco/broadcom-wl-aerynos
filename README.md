# broadcom-wl-aerynos

Broadcom Linux hybrid wireless driver (64-bit)

Directory `base/broadcom-wl-6.30.223.271` contains the source
from the source code found on the [Broadcom Support and Downloads page][1],
and patchs from OpenSuse source repository.

**Patched for Linux >= 6.13**

Tested on a BCM4360-based 802.11ac Wireless Network Adapter (MacbookPro11,1)

[1]: https://www.broadcom.com/support/download-search?pg=Wireless+Embedded+Solutions+and+RF+Components&pf=Legacy+Wireless&pa=Driver&dk=BCM4312&l=true

## Prerequisites

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

`/usr/lib/modprobe.d/50-broadcom-wl-blacklist.conf`
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

## Compile and install

### Manually

Build on AerynOS: (2025.03) (Linux 6.13), The builder is `clang` and the linker is `ld.lld`:

```sh
$ make clean && make CC=clang LD=ld.lld V=1
$ sudo make install
$ depmod -A
$ modprobe wl
```

### Go from the begainning

The source alreay pathed to 6.13. If you want to do from the begainning, falls this steps:
1. make new dir `mysrc` and `cd mysrc`
2. untar the source `tar zxf base/broadcom-wl-6.30.223.271/hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz`
3. patchs in the order of `broadcom-wl.spec`'s patch[xx]:
    ```
    Patch0:         broadcom-sta-6.30.223.141-eth-to-wlan.patch
    Patch1:         broadcom-sta-6.30.223.141-gcc.patch
    Patch2:         broadcom-sta-6.30.223.141-makefile.patch   [DO NOT patch this one]
    Patch3:         broadcom-sta-6.30.223.248-r3-Wno-date-time.patch
    Patch4:         broadcom-sta-6.30.223.271-r1-linux-3.18.patch
    Patch5:         broadcom-sta-6.30.223.271-r2-linux-4.3-v2.patch
    Patch6:         broadcom-sta-6.30.223.271-r4-linux-4.7.patch
    Patch7:         broadcom-sta-6.30.223.271-r4-linux-4.8.patch
    Patch8:         isprint.patch
    Patch9:         broadcom-sta-6.30.223.271-Fix-fall-through-warnings.patch
    Patch10:        broadcom-sta-6.30.223.271-Fix-mac-address-setting.patch
    Patch11:        broadcom-wl.linux-4.11.patch
    Patch12:        broadcom-wl.linux-4.12.patch
    Patch14:        broadcom-wl.linux-4.14.patch
    Patch15:        broadcom-wl.linux-4.15.patch
    Patch16:        broadcom-wl.linux-5.1.patch
    Patch17:        broadcom-wl.linux-5.6.patch
    Patch18:        broadcom-wl.linux-5.9.patch
    Patch19:        broadcom-wl.linux-5.17.patch
    Patch20:        broadcom-wl.linux-5.18.patch
    Patch21:        broadcom-wl.linux-6.0.patch
    Patch22:        broadcom-wl.linux-6.1.patch
    Patch23:        broadcom-wl.linux-6.5.patch
    Patch24:        broadcom-wl.linux-6.10_fix_empty_body_in_if_warning.patch
    Patch25:        broadcom-sta-6.30.223.271-wpa_supplicant-2.11_add_max_scan_ie_len.patch
    Patch26:        broadcom-wl.linux-6.12.patch
    Patch27:        broadcom-wl.linux-6.13.patch
    Patch28:        broadcom-wl.linux-6.14.patch
    ```

    like this:

   * `patch -p1 < base/broadcom-wl-6.30.223.271/patches/0001-Add-support-for-Linux-6.13.patch`
   * `patch -p1 < base/broadcom-wl-6.30.223.271/patches/0002-Add-support-for-Linux-6.14.patch`
4. make the source `make CC=clang LD=ld.lld V=1`
5. install the source `sudo make install`
6. depmod -A
7. modprobe wl

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
