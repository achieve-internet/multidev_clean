Prerequisites:
1. Machine token is set in Pantheon account settings and has ran with the following command:
	$ terminus auth:login [--machine-token [MACHINE-TOKEN]] [--email [EMAIL]]





Option 1: Generate Multidev without changing dev environment org name (multidev_create.sh)
Running the command: 
Two arguments are needed for this script: 
	Argument 1: Site (<sitename>.<environment>)
	Argument 2: the name for the multidev
Run the command in the following format:
	bash multidev_create.sh <sitename>.<environment> <Multidev Name>

How it works: 
1. The script will first create the multidev with the name specified in the argument.
2. It will run two terminus commands to obtain information needed for creating the alias file.
3. It then creates an alias file and move it to "~/.drush/aliases" directory, if this directory does not exist it will create one. 
4. Then the multidev environment site will have default orgname, endpoint user credentials configured. 





Option 2: Disconnect dev environment with Edge org first, create multidev, and restore the dev and Edge org connection (dirty_orgname_multidev_create.sh) 

Running the command: 
Two arguments are needed for this script: 
	Argument 1: Site (<sitename>.<environment>)
	Argument 2: the name for the multidev
Run the command in the following format:
	bash multidev_create.sh <sitename>.<environment> <Multidev Name>

How it works: 
1. The script will first create an alias file for the dev environment
2. Then it will first store the orgname from dev environment, and inside a txt file in case if the script stopped, we can manually run terminus command to restore the org
3. It then will change orgname of dev to an invalid space. 
4. Creates the multidev. 
5. Restore the orgname in dev and remove the txt file created, as we have confirm the restoration, the txt file is no longer needed. 
6. Generate alias file for multidev. 
7. Set the orgname and endpoint user credentials of multidev to default testing values