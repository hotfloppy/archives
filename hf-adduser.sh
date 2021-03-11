#!/bin/bash

# constant value
HOME="/hfbox/home"
SKEL="$HOME/skel"
aSHELL="/bin/bash" # aSHELL because $SHELL is used by the OS

# params
USERNAME=$1
GROUPNAME="hfuser" # default value for group

if [ $# -lt 1 ]; then
    echo "Usage: hf-adduser [username] [group (default: hfuser)]"
    echo "Example: hf-adduser vader sith"
    echo "  User 'vader' will be created and added to group 'sith'."
    echo "  If group value are omitted, default value 'hfuser' will be used."
    exit 0
fi

if [ $# -eq 2 ]; then
    GROUPNAME="$2"
fi

createUser() {
    echo "New user will be created."
    echo "Username: $USERNAME"
    echo "Group: $GROUPNAME"
    read -p "Is this okay? (Y/n): " OKAY
    if [ -z $OKAY ] || [ $OKAY == "y" -o $OKAY == "Y" ]; then
        useradd -d $HOME/$USERNAME -G $GROUPNAME -k $SKEL -m -s $aSHELL $USERNAME
        chmod 711 $HOME/$USERNAME
        chown $USERNAME:$GROUPNAME $HOME/$USERNAME
        echo "New user has been successfully created."
        echo
        stat $HOME/$USERNAME
        echo
    else
        echo "Cancelled. No new user has been created."
        exit 98
    fi
}

newPassword() {
    read -p "Would you like to set up a password for user '$USERNAME'? (Y/n) " setPASS
    if [ -z $setPASS ] || [ $setPASS == "y" -o $setPASS == "Y" ]; then
        echo; echo "Tips: Use combination of uppercase, lowercase, number and symbol for secure password."
        passwd $USERNAME
        echo "New password for '$USERNAME' has been successfully set up."
    else
        echo "Password for '$USERNAME' are not yet been set up."
        echo "To set, run 'passwd $USERNAME' on your terminal."
        exit 99
    fi
}

createUser
newPassword

make -C /var/yp

exit 0
