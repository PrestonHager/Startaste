Kernel
======

How did we get Here?
~~~~~~~~~~~~~~~~~~~~

The kernel is the brains of an operating system.
That is that, everything can be traced back to the kernel eventually.
The first thing that a computer will do when booting up is run a 512 byte section of code called a bootloader.
More information on the bootloader is available on `its page`_.
When the kernel starts up it will run a specific subroutine that initializes any possible variables and the ReactiveX implementations.
Using ReactiveX concepts, the kernel will create places in the memory called Stars and Planets.
These are equivalent to Observers and Observables, respectively.
More on these two in the next section, More on the ReactiveX.
Since Startaste is fully customizable, it is entirely up to the user what stars and planets are initialized.
For a very basic operating system, a display and keyboard can be initialized such that only a terminal type window will show.
Using the builtin REPL, users may do a variety of simple and complex operations.

More on the ReactiveX
~~~~~~~~~~~~~~~~~~~~~

ReactiveX has bindings for many different languages that can be found on `their website`_.
The main idea is that there are two types of objects or structures.
The observables are things such as keyboards, mice, hard disks, or other IO devices.
These will have an internal buffer, this doesn't truly exist, but rather data is distributed by calling observers.
The second type of object is the observer, these are things such as displays, command lines, or programs.
The observer will bind itself to one or more observable which when receiving data, will call the ``next`` command of the observer.
Startaste does things a little different from ReactiveX.
First, there is no current true binding for a C language ReactiveX, thus the structures are built from scratch.
Second, the Observables and Observers are called Stars and Planets respectively.

.. _their website: http://reactivex.io
.. _its page: https://startaste.rtfd.io/en/latest/bootloader.html
