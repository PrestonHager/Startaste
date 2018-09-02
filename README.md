# Startaste
Another OS! This was made simply as a side project, don't expect it to be great.

------

## Install
To install Startaste download the source package via git or zip. `git clone https://github.com/PrestonHager/Startaste.git` to pull via git, or download link [here](https://github.com/PrestonHager/Startaste/archive/release.zip). Then in a terminal run it using `make`, or executing the commands in the `Makefile`.

If you're wanting to run a different bootloader simply add the variable, `bootloader` in the command line; as such, `make bootloader=[filename]`.

You will also need to install [QEMU](https://qemu.org), I'm working on making the entire package independent to compile and emulate, but until then you must install QEMU first.

------

## Differences on Windows
If you haven't installed GNU Cat on your windows computer, use `make platform=win` when making. This will instead have make use the `type` command, which is the windows equivalent of cat.

-----

## Bugs and Development
If you find a bug, or have a suggestion please report it in the [issues tab](https://github.com/PrestonHager/Startaste/issues) of the git repository. If you would like to help us create the OS then create a new pull request in the [request tab](https://github.com/PrestonHager/Startaste/pull) of the repository.

-----

Copyright © 2018 Preston Hager
