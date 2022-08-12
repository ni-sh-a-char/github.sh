# Git-Automation
Script to automate Git from project working directory with a menu to choose from, you just have to edit the file **github.sh** as directed by the comments in case of **Git Push**

```
Which Git operation you want to perform ?
(1) Clone
(2) Pull
(3) Push
(4) Exit
Enter your choice [1-4]:
```

# About

Use the script **"github.sh"** file inside your project working directory to automate git procedures to your existing repository on GitHub by just making some changes in the file as directed in the comments inside the file.

# How prepare the file

Use the file as super user or admin acces and provide the file with write access by :
```
$ chmod +x github.sh
```
inside the terminal in the project working directory.

# How to use the script

Keep working on project files and run :
``` 
$ ./github.sh
```
in the project working directory in the terminal while the **"github.sh"** file is present and provided with **write access** and your project files will be **pushed to your existing Github repository**.
