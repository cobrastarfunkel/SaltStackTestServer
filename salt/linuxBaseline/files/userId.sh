#!/bin/bash

# Check to see id a users uid is 1000 or more but less than the max which is
# used for a nsf user on this system at least.

function main {
    # Loop through the users on the system
    for user in $(getent passwd |  while IFS=: read -r name password uid gid gecos home shell; do echo $name; done); do
        id=$(id -u $user 2>/dev/null)

        # Make sure uid is abov 100 and below 65534, 65534 is used by an nfs account.
        # This is most likely different elsewhere.  Can be changed if you need that number
        # 0 is for root
        if ((id > 999)) && ((id != 65534)) || ((id == 0)); then

            # Check if the directory already exists if not clone the git repo
            [[ -d /home/$user/.vim/bundle/Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git /home/$user/.vim/bundle/Vundle.vim;
        fi
    done

}

main
