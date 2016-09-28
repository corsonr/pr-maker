#!/bin/bash
#
# Remi's PR Maker
# Pull requests automation
#
# By @remicorson (http://remicorson.com)
#
# ======================================

# ------------------------
# VARS
# ------------------------

# Local Git Folder
local_folder="/Applications/MAMP/htdocs/Dropbox/GIT/"

# GitHub username
github_username="corsonr"

# ------------------------
# FUNCTIONS & FANCY STUFF
# ------------------------

# Stop on error
set -e

# colorize and formatting command line
# You need iTerm and activate 256 color mode in order to work : http://kevin.colyar.net/wp-content/uploads/2011/01/Preferences.jpg
green='\x1B[0;32m'
cyan='\x1B[1;36m'
blue='\x1B[0;34m'
grey='\x1B[1;30m'
red='\x1B[0;31m'
bold='\033[1m'
normal='\033[0m'

# Jump a line
function line {
  echo " "
}

# ------------------------
# START THE ENGINE...
# ------------------------

# Start the script
line
echo "${cyan}${bold}Alright, so you want to do a Pull Request? Awesome!${normal}"
line
echo "${blue}Please note: you can quit this script whenever you want by typing "Ctrl + c".${normal}"
line

# Move to local Git folder
cd $local_folder
echo "The script just moved to your local GIT folder : ${cyan}$local_folder${normal}"
line

# STEP 1
echo "${bold}===== STEP 1: Define the repo slug =====${normal}"
line

# Define repo slug
echo "Please enter the repo slug (ex: woocommerce-subscriptions) then press [Enter]: "
read repo_slug
line

# STEP 2
echo "${bold}===== STEP 2: Fork the repo =====${normal}"
line

# Repo fork check
while true; do
    read -p "Have you already forked the $repo_slug repo (Y/N)? " yn
    case $yn in
        [Yy]* ) line; echo "Excellent, let's continue!${normal}"; line; break;;
        [Nn]* ) line; echo "Please fork the repo on GitHub.com. To do so, please go to the repo URL and hit the 'Fork' button, on the top right of the page."; line; read -p "Then please press [Enter] when you forked it."; line; break;;
        * ) echo "Please answer Y or N.";;
    esac
done

# STEP 3
echo "${bold}===== STEP 3: Clone the repo locally =====${normal}"
line

read -p "Press [Enter] to continue."
line

# Check if folder exists
if [ -d "$repo_slug" ]; then
	echo "${green}${bold}Folder $repo_slug already exists locally, no need to create it.${normal}"
	line
else
# If not, then lone repo
	echo "${red}${bold}Folder $repo_slug doesn't exist locally.${normal}"
	line
	echo "Repo ${cyan}$repo_slug${normal} is now being cloned in ${cyan}$local_folder. ${normal}Please wait..."
	line
	git clone git@github.com:$github_username/$repo_slug.git --recursive
	line
	echo "${green}${bold}Folder cloned locally successfully!${normal}"
	line
fi

# Go into the new folder
cd $repo_slug
echo "The script just moved to your local copy of : ${cyan}$local_folder$repo_slug${normal}."
line


# STEP 4
echo "${bold}===== STEP 4: Link your repo to the upstream =====${normal}"
line
read -p "Press [Enter] to continue."
line

# Repo fork check
while true; do
    read -p "Is the repo already linked to the upstream (needed the 1st time only) (Y/N)? " yn
    case $yn in
        [Yy]* ) line; echo "Excellent, let's continue!${normal}"; line; break;;
        [Nn]* ) line; git remote add upstream git@github.com:woocommerce/$repo_slug.git; git remote; line; echo "${green}${bold}Fork linked to the git@github.com:woocommerce/$repo_slug.git upstream successfully.${normal}"; line; break;;
        * ) echo "Please answer Y or N.";;
    esac
done

# STEP 5
echo "${bold}===== STEP 5: Update the fork =====${normal}"
line

# Upate fork
read -p "Press [Enter] to continue."
line

git fetch upstream
git merge upstream/master
git push origin master
line
echo "${green}${bold}The fork has been updated successfully !${normal}"
line

# STEP 6
echo "${bold}===== STEP 6: Create a new branch =====${normal}"
line

# Create new branch
echo "And now it's time to create a new branch. Please be descriptive or use an issue ID, ex: issue_4533."
line

echo "Please enter the branch name then press [Enter]: "
read new_branch

git checkout -b $new_branch

line
echo "${green}${bold}Branch $new_branch created successfully!${normal}"
line

# STEP 7
echo "${bold}===== STEP 7: Coding time! =====${normal}"
line

# Code the fix
echo "${red}${bold}STOP! You can now do the coding part! Come back here when your code is ready (but don't close the window in the meantime).${normal}"
line

read -p "Press [Enter] to continue."
line

# STEP 8
echo "${bold}===== STEP 8: Commit changes to GitHub =====${normal}"
line

# Commit
echo "The last step is sending your fix to GitHub. The script will automatically new files if some were created."
line

read -p "Press [Enter] to continue."
line

git add .

line
echo "${green}${bold}All new files added successfully!${normal}"
line

# type commit message
echo "Please enter message that describes your commit, then press [Enter]: "
read commit_message

line
git commit -am "$commit_message"
line
git push origin $new_branch

# STEP 9
echo "${bold}===== STEP 9: Everything went smoothly! =====${normal}"

line
echo "${green}${bold}Wow! You did an amazing job! Congrats! There's just a last step, please go to https://github.com/woocommerce/$repo_slug, and simply hit the [Create Pull Request] button and you're done!${normal}"
line
