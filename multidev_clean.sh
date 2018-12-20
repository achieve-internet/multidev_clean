#!bin/bash
set -e

usage() {
    echo "Generate Multidev environment without changing Edge Organization of Development environment

Examples: 
    ./$0 -h                             Display this help message 
    ./$0 sitename.env multidev_name     Create multidev with name: multidev_name from sitename.dev site

Arguments:
    sitename.env
    Name of Multidev

Options:
    -h                                  Display this help message" 
    1>&2;
}
while getopts ":hs:" opt; do
    case "${opt}" in
        h)
            usage >&2
            exit 0
            ;;        
        s)
            # This allows us to add custom functions
            # Set the flags in here to a global value, and then we will be able to see
            # if we have any other functions to execute at the end
            ;;
        :)
            printf "Missing argument for -%s\n" "$OPTARG" >&2
            usage >&2
            exit 1
            ;;
        \?) 
            printf "illegal option: -%s\n" "$OPTARG" >&2
            usage >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"



#Extracting information from the two arguments given to the script
site=$1
multidev_name=$2
sitename=${site%%.*}
environment=$multidev_name

# Login to Pantheon
terminus auth:login

echo "Creating multidev named $multidev_name..."
terminus multidev:create $site $multidev_name


# Getting the information needed to create the alias file
connection_info=($(terminus connection:info --fields='MySQL Host,MySQL Password,MySQL Port' --format='list' $sitename.$environment))
connection_info+=($(terminus env:info --field='Domain' --format='string' $sitename.$environment))

host=${connection_info[0]}
password=${connection_info[1]}
port=${connection_info[2]}
url=${connection_info[3]}

# Creating the drush alias for the multidev environment site
dbhostafterdbserver=`echo $host | cut -d '.' -f 3-5`
hostwithoutdrush=`echo $dbhostafterdbserver | cut -d '.' -f 1`
echo "<?php
\$aliases['$sitename.$environment'] = array(
  'uri' => '$url',
  'db-url' => 'mysql://pantheon:$password@$host:$port/pantheon',
  'db-allows-remote' => TRUE,
  'remote-host' => 'appserver.$environment.$dbhostafterdbserver',
  'remote-user' => '$environment.$hostwithoutdrush',
  'ssh-options' => '-p 2222 -o \"AddressFamily inet\"',
  'path-aliases' => array(
    '%files' => 'code/sites/default/files',
    '%drush-script' => 'drush',
   ),
);" > $environment-$sitename.aliases.drushrc.php

echo "Alias file $multidev_name-$sitename.aliases.drushrc.php created"
drush cc drush

# Checking if the directory ~/.drush/aliases exists
# Create the directory if it does not
if [ ! -d "/Users/$(whoami)/.drush/aliases" ]; then
  mkdir ~/.drush/aliases
fi

# Move the alias file into ~/.drush/aliases folder. 
mv $environment-$sitename.aliases.drushrc.php ~/.drush/aliases

# Clear all cache including site cache for correct functionalities of dc commands
drush @$environment-$sitename.$sitename.$environment cc all



# Need more info about what org and what credentials to set for this multidev
echo "Resetting multidev organizations and endpoint user..."
drush @$environment-$sitename.$sitename.$environment dc-setorg EDGE_ORGNAME_HERE
echo PASSWORD_FOR_ORG_HERE | drush @$environment-$sitename.$sitename.$environment dc-setauth USERNAME_FOR_ORG_HERE
