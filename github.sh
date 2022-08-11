#! /bin/bash

declare -A map

map["Git-Automation"] = "Git-Automation"  # replace remote with remote you created and replace original with your repository you want to push the files
#map["remote"] = "original" # you can add as many remote and destination repository you want to push just like this by changing the remote and original inside the inverted comma.
#map["remote"] = "original" # you can add as many remote and destination repository you want to push just like this
#map["remote"] = "original" # you can add as many remote and destination repository you want to push just like this

git config --global user.name "PIYUSH-MISHRA-00" # replace username inside inverted comma with your GitHub user name
git init
git add .
echo "Enter Commit message: "
read message
git commit -m $echo message

for i in "${!map[@]}"
do
    git remote add $i https://github.com/PIYUSH-MISHRA-00/${map[$i]}.git # replace "PIYUSH-MISHRA-00" with your Github username
    git push -u $i main # you can replace main with the destination branch you want to select
done

git push