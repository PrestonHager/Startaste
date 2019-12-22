# Startaste

Another operating system.
Started as a ground-up operating system.
Startaste now uses reactive programming methods in C.

------

## Install

To install Startaste download the source package via git or zip.
`git clone https://github.com/PrestonHager/Startaste.git` to pull via git, or download link [here](https://github.com/PrestonHager/Startaste/archive/release.zip).
Then in a terminal run it using `make`, or executing the commands in the `Makefile`.

If you're wanting to run a different bootloader simply add the variable, `bootloader` in the command line; as such, `make bootloader=[filename]`.

By default the makefile will build the assembly kernel.
To build a different type of kernel use the `type` argument.
For example `type=c` will change most if not all the files to build the c kernel rather than the assembly kernel.

You will also need to install [QEMU](https://qemu.org), I'm working on making the entire package independent to compile and emulate, but until then you must install QEMU first.
Additionally, you may use a secondary computer to load the OS onto, but be careful when doing this.

------

## Differences on Windows

If you haven't installed GNU Cat on your windows computer, use `make platform=win` when making.
This will instead have make use the `type` command, which is the windows equivalent of cat.
If you're building the C kernel on windows you will need to use this as well because the MinGW gcc has a little different entry in assembly.

-----

## Bugs and Development

If you find a bug, or have a suggestion please report it in the [issues tab](https://github.com/PrestonHager/Startaste/issues) of the git repository.
If you would like to help us create the OS then create a new pull request in the [request tab](https://github.com/PrestonHager/Startaste/pull) of the repository.

-----

Copyright (C) 2019 Preston Hager
