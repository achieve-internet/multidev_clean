Prerequisites:
1. Machine token is set in Pantheon account settings and has ran with the following command:
	$ terminus auth:login [--machine-token [MACHINE-TOKEN]] [--email [EMAIL]]


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
