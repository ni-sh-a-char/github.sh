![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
# Git-Automation
Script to automate Git from project working directory with a menu to choose from, you just have configure once and the script can be used for the following operations.

```
Which Git operations you want to perform ?
(0) Configure (configures the script for continuous uses)"
(1) Clone"
(2) Pull"
(3) Push"
(4) Generate Patch"
(5) Send Email"
(6) ETERNITY
(7) Exit"
Enter your choice [0-7]:
```

# About

* Use the script **"github.sh"** file inside your project working directory to automate git procedures by **just configuring the script once and use it any number of times.** 
* You just have to use the configure option once and if you wish to change the working directory you just have to use the configure option to start working with the new project.

* Just give the file write access and use the script by running:

```
$./github.sh
```

# For Windows User

* Use the Windows Subsystem for Linux (WSL) with a valid linux distribution and run the following command in the terminal

```
wsl
```
* Then run the following command and press Y

```
$sudo apt install git
```



# How prepare the file

Use the file as super user or admin acces and provide the file with write access by :
```
$ chmod +x github.sh
```
inside the terminal, in the project working directory.

# How to use the script

Keep working on project files and run :
``` 
$ ./github.sh
```
in the project working directory's terminal, while the **"github.sh"** file is present and provided with **write access** and you will be able to handle your project files with git operations using a simple menu driven approach.
