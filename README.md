RPi-BuildEnv
============

This is a set of scrips for preparing a build environment.

Updated 2022/08/09 apocsantos to support raspbian bullseye

Dependencies
------------

You should have installed `debootstrap`, `debootstrap` (`qemu-user-static` package on Debian/Ubuntu) and `chroot`.

Usage
-----

Make sure you have installed the dependencies.

Then just exec `./install.sh` and wait :)

With 50MB down bandwidth it took me about 15 minutes.

Usage for omxplayer
-------------------

Do the previous and `./prepare_omxplayer.sh`. It will install the dependencies on the rootfs.

Useful things to know
---------------------

Now you have a Raspbian setup in the `rootfs` folder. You can enter it using `./chroot.sh`.

When you are inside the Raspbian system you can use `apt-get` to install packages or update the system, also you can get the last firmware with `rpi-update`.

TL;DR for building omxplayer
----------------------------

I'm going to asume you are using Debian, Ubuntu or derivated since you need
`debootstrap`.

    sudo apt-get install debootstrap qemu-user-static
    git clone https://github.com/skgsergio/rpi-buildenv.git
    cd rpi-buildenv
    ./install.sh
    ./prepare_omxplayer.sh
    ./build.sh

If nothing went wrong you now have a deb package in the current directory
ready to use.

License
-------

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
