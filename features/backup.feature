Feature: We can backup a database
  As a DB user I want to create a database dump.

Scenario: Get help for the backup command.
  When I successfully run `mysql-tools help backup`
  Then the stdout should contain "database_name"
