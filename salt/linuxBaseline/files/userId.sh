#!/bin/bash

# Check to see id a users uid is 1000 or more but less than the max which is
# used for a nsf user on this system at least.

function main {
    # Uses salt function to reteive user names so they can be passed
    # w/o having to use awk.  Probably not the most efficient way to do that
    for user in $(salt-call user.list_users); do
        id=$(id -u $user 2>/dev/null)
        if ((id > 999)) && ((id != 65534)); then
            [[ -d /home/$user/.vim/bundle/Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git /home/$user/.vim/bundle/Vundle.vim;
        fi
    done

}

main
