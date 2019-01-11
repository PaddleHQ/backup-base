Feature: provide an easily configurable standard encryption context for different backup systems
In order to allow us to encrypt backups from different sources we
should have a common system which can manage the keys and set up for
encryption of backups.

  @wip
  Scenario: prepare for backup
  given that I have a backup context configured
  when I run a backup script from that context
  then my S3 URL should be configured
  and my encryption command should be configured

  Scenario: verify 
  given that I have a backup context configured
  when I request an encryption command
  then environment variables and a script should be set up
  and the script should encrypt my data

  Scenario: encryption should handle multiple keys
  given that I have multiple keys for different backup users
  and that I have a system for encypting backups
  when I run the backu
  then that data should be readable with any of the privagt keys corresponding to the public keys in the context

