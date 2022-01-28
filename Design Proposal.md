# Startaste OS Proposal

Startaste is an Operating System designed to run on ARM processors. It has a few specific design goals in mind and is written from the ground up in Assembly and C/C++.

### Target

Startaste aims to create a platform for secure processing and delivery of products. It also allows for a seamless user experience. While most development of the apps and extensions for Startaste must be completed by a programmer, the average user should be able to complete everyday tasks with the base operating system. There are also custom extensions/apps that can be installed that should work in a similar manner. Average users include those in government positions, defense contractors and companies, and intermediate computer users.

### Features

Startaste should include such features in the base operating system:

 + ReactiveX framework - using observers and observables we create a responsive design that only runs when needed, instead of typical scheduled tasks.
 + Functional OS - the underlying code written in Assembly and C is functional.
 + Easy navigable GUI - the user interface should be simple and follow material-like UI design.
 + Peripheral support for standard keyboard and mice - using the ReactiveX framework to employ standards.
 + Secure logins - user set login with securely stored hashes.
 + Ability to install extensions/apps with ease - an easy navigable interface to install community submitted and regulated applications.
 + Declarative language - the "API" used to create applications and extensions is declarative. The code describes what the programmer wants to create rather than how the OS should create it. Similar to how HTML and CSS works as a markup language.

**ReactiveX Framework**

An observable creates data such as key presses or incoming messages. Observers then attach themselves to these observables to call a function whenever new data gets pushed to the observable.