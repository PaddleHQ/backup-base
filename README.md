This is a base layer for our automated backup which provides the
simple service of backing up from S3 locations into encrypted files in
other S3 locations.

Install
=======

To get this to work you must install the operating system requirements
which are not automatically installed by pip.  See below

Until release 1.0 installs will have to be done through direct pip
installs from GitHub

    pip install https://travis-ci.org/backup-cloud/backup-base

or

    pip install https://github.com/backup-cloud/backup-base/archive/20190507151318-f1bc9fc.zip

to install a specific release

OS specific dependencies
------------------------
In order for this to work the appropriate libraries have to be installed on the system.

For Alpine Linux:

    apk add gnupg

For Debian family / Ubuntu systems

    apt-get inatall python3-gpg


The backup configuration
============================

The backup configuration is primarily in SSM.  When the backup class
is initiated then it gets an SSM path which it use to find the rest of
the configuration.  Hardwired under this path are various parameters

- <base-path>/s3_bucket - the bucket the backup system will use
- <base-path>/s3_path - the base path in the bucket where the backup will be

Under s3_path there is a hierarchy

  /config - the configuration for the backup - currrently very limited  
  /config/public-keys - storage location for public keys  
  /backup - storage location for encrypted backups  

The keys stored in the public-keys location 1

Backups should be stored under the backup location.


backup_context.BackupContext
============================

The main class provided in this repo is a context class which reads
configuration from S3 and handles backup encryption for you.

    >>> from backup_cloud import BackupContext
    >>> rcp = ["test@example.com"] 
    >>> bc = BackupContext(ssm_path="/bc-demo", recipients=rcp)
    >>> cp = bc.run("bin/myscript.sh")
    >>> print(cp.stdout.decode('UTF-8').strip())
    *********************
    backing up everything
    *********************


Developing backup-cloud/backup-base
===================================





Makefile Goals
==============

prepare
-------

This will run ansible to set up your account.  See Ansible based
deployment below.  Obviously you need to have (a reasonably recent)
ansible installed first.

test and other subgoals
-----------------------

The various subgoals of test run all the tests.

all: (default)
--------------

This will run through the preparation and all the tests.

Ansible based deployment
========================

There are two ansible scripts included which prepare for testing.

- `prepare-account.yml` - this is for setting up accounts needed for
  other parts - it needs to be run with full AWS admin privilages to be
  able to set up the accounts used for testing.

- `prepare-test-enc-backup.yml` - this is required to setup the
  account where testing will happen.  This needs to be run from an
  account which is able to create S3 buckets.

Status and getting releases
===========================

Releases are currently created automatically in the case of succesfull
automated testing.  You can simply take the latest one from
[the Release page](https://github.com/backup-cloud/backup-base/releases).

Builds are run in travis:
[![Build Status](https://travis-ci.org/backup-cloud/backup-base.svg?branch=tested)](https://travis-ci.org/backup-cloud/backup-base)


Travis Encrypted Files
======================

For the travis build system we need to pass credentials in an encrypted form.

- *aws_credentials.demo.env* - credentials for doctest / demo environment
- *aws_credentials.env* - test user credentials
- *aws_credentials_travis.yml* - 
- *deploy_key* - git key to allow pushes


Dockerised
==========

When running this tool in docker use the following command to build the image :

```sh
make build-docker
```

next, the environment variable for the AWS user
```sh
AWS_ACCESS_KEY_ID=""
AWS_DEFAULT_REGION=us-east-1
AWS_SECRET_ACCESS_KEY=""
```

next, set the following execution variables

`SSM_BACKUP_PATH` - This should point to the ssm that contains the name of the s3 bucket you wish to use for the encrypted folder/ file

`SOURCE_ABSOLUTE_DIR` - This is the absolute path to the folder containing the `ssm` backup created using [THIS](https://github.com/PaddleHQ/backup-ssm)

`DEST_PATH` - This is the key for the object on the s3 backup bucket


Finally, run the docker backup command using something similar to:
```
SOURCE_ABSOLUTE_DIR="/Users/leonsilcott/Workspace/backup-ssm/ssm-backup-YYYY-MM-dd" SSM_BACKUP_PATH="/backup_cloud/base_defs"  DEST_PATH="ssm" make run-docker
```