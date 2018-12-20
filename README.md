# Multidev Clean Create
Generate Multidev environment without changing Edge Organization of Development environment

## Getting Started
This instruction will give you information on how to execute the script

### Prerequisites
Machine token is set in Pantheon account settings and has ran with the following command:
```
$ terminus auth:login [--machine-token [MACHINE-TOKEN]] [--email [EMAIL]]
```


### Running the command
Two arguments are needed for this script: 
* Site: (sitename.environment)
* Name: the name for the multidev
Run the command in the following format:
```
bash multidev_create.sh <sitename>.<environment> <Multidev Name>
```

### How it works
* The script will first create the multidev with the name specified in the argument.
* It will run two terminus commands to obtain information needed for creating the alias file.
* It then creates an alias file and move it to "~/.drush/aliases" directory, if this directory does not exist it will create one. 
* Then the multidev environment site will have default orgname, endpoint user credentials configured. 
