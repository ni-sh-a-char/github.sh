#! /bin/bash

while :
do
echo "Which Git operation you want to perform ?"
echo -e "\t(1) Clone"
echo -e "\t(2) Pull"
echo -e "\t(3) Push"
echo -e "\t(4) Exit"
echo -n "Enter your choice [1-4]: "

read choice

case $choice in
 1) echo "Cloning from GitHub"
    echo
    echo "Enter the repository https url: "
    read clone_url
    git clone $echo $clone_url;;

 2) echo "Pulling from GitHub"
    echo
    echo "Enter the repository https url: "
    read pull_url
    echo
    echo $pull_url
    echo
    while :
    do
    echo "Which type of Git Pull you want ?"
    echo -e "\t(1) Merge (the default strategy)"
    echo -e "\t(2) Rebase"
    echo -e "\t(3) Fast-forward only"
    echo -e "\t(4) Return to main menu"
    echo -n "Enter your choice [1-4]: "
    read pull_choice
    case $pull_choice in
     1) 
     git config pull.rebase false 
     git pull $echo "$pull_url";;
     2) 
     git config pull.rebase true 
     git pull $echo "$pull_url";;
     3) 
     git config pull.ff only 
     git pull $echo "$pull_url";;
     4)
     break
     ;;
        *) 
        echo "Invalid operation"
        ;;
    esac
    done
    ;;
 3) echo "Pushing to GitHub" 
    declare -A map

    map["Git-Automation"] = "Git-Automation"  # replace remote with remote you created and replace original with your repository you want to push the files
    #map["remote"] = "original" # you can add as many remote and destination repository you want to push just like this by changing the remote and original inside the inverted comma.
    #map["remote"] = "original" # you can add as many remote and destination repository you want to push just like this
    #map["remote"] = "original" # you can add as many remote and destination repository you want to push just like this

    git config --global user.name "PIYUSH-MISHRA-00" # replace username inside inverted comma with your GitHub user name
    # git config --global user.signingkey MY_KEY_ID # replace "MY_KEY_ID" with your GPG key for signed commits
    git init
    git add .
    echo "Enter Commit message: "
    read message

    git commit -m $echo "$message" # use git commit -S -m $echo "$message" if you have used your GPG key

    for i in "${!map[@]}"
    do
        git remote add $i https://github.com/PIYUSH-MISHRA-00/${map[$i]}.git # replace "PIYUSH-MISHRA-00" with your Github username
        git push -u $i main # you can replace main with the destination branch you want to select
    done

    git push;;

 4) echo "Quitting..."
    exit;;

 *) echo "Invalid operation";;

 esac
 done   