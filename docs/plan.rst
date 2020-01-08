Plan
====

What is “this” exactly?
~~~~~~~~~~~~~~~~~~~~~~~

The Startaste OS is just yet another operating system.
Its goal is to make an operating system that is fast and efficient.
To do this we use some newer methods that older operating systems don't have integrated into them from the start.

What technology is used?
~~~~~~~~~~~~~~~~~~~~~~~~

Originally written in pure assembly, Startaste is now written in C.
The OS is written on a ReactiveX IO structure, completely custom built.
Sphinx Docs is used for this documentation.
And `GitHub`_ is used for version control, issue handling, and improvements.

What are the features?
~~~~~~~~~~~~~~~~~~~~~~

Startaste uses a custom ReactiveX structure so that all events are much faster.
Creating more user interactive environments are encouraged and easier using this structure.
Take a look at either the `ReactiveX website`_, or the in-depth explanation of `Startaste's ReactiveX structure`_.
The basic kernel of Startaste is very minimal and will only start a few drivers depending on the compiled image.
To overcome this, we've built a few drivers to start out.
However, it is possible that you may need to make more drivers for specific devices or take some from the community.

.. _GitHub.: https://github.com/PrestonHager/Startaste
.. _ReactiveX website: https://reactivex.io/intro.html
.. _Startaste's ReactiveX structure: https://startaste.rtfd.io/en/latest/kernel.html
