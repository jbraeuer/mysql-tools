This repository holds "mysql-tools". These tools offer the following function

- create database dump via `mysqldump`
- restore a backup, create database and user if needed
- obfuscate a dump

These scripts come handy to create backup on production and
obfuscate/anonymize dumps for test systems. Also devs can self-serve
with the provided 'restore' function.

This project also serves as a test-bed for

- GLI (a command line parser for Ruby)
- Aruba (a extension for cucumber)
- testing for command line apps

Jens Braeuer <braeuer.jens@googlemail.com>
