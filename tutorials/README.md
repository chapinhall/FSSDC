# Tutorials
To use some of these resources requires prior knowledge. This tutorial section provides an introduction to key concepts to use these resources. If you are not clear on a concept or are struggling to get started, please contact <fssdc@chapinhall.org>. Your questions could provide valuable input on how to improve these tutorials for others. 

Many people have written online tutorials about the topics we are covering. We summarize some of those materials and provide links to more in-depth walkthroughs. If in your own searching, you find helpful online materials, please share, as we want to make using and contributing to this repository as easy as possible.

## Using Basic GitHub Online
GitHub is the website you are currently using to read this tutorial and browse these files. It facilitates collaborating with others using Git, a version control system. A version control system tracks who made what changes to files when and helps make collaboration easier. But to make simple changes to this website, you do not need to learn everything about version control right away. You can add or modify files using the GitHub website directly.

The first thing you will need to do is [create](https://github.com/join) your own GitHub account. Next, you will need to request to be added as a collaborator to the project. Email your new GitHub username to <fssdc@chapinhall.org> to get added as a collaborator. Once you are added as a collaborator, the email associated with your GitHub account will recieve a message asking you to accept our invitation.

### Create New Branch
A branch is like a new version of a project. If you have a good idea, you should make a new branch so that you can make your changes. Every project has a master branch, which is like the main version everyone agrees on. When you make a new branch you create a copy of the master branch, but you can edit your branch without interfering with others' work. For example, if you want to make some improvements to our documentation, you might create a descriptively named new branch like "improved-docs".

Creating a new branch can be done by clicking on the arrow where it says master branch and typing in your new branch name. A demonstration can be seen below from [Github's intro documentation](https://guides.github.com/activities/hello-world/). If you do not see a button to create a new branch when you type into the text box, you may not have been added as a collaborator yet. Email <fssdc@chapinhall.org> with your GitHub account name to be added as a collaborator.

![create-branch](create-branch.gif)

### Make Your Changes
Next, click on the file you would like to change. If you are viewing the file, there should be a pencil icon on the upper right hand corner that will open an editor where you can make your changes and leave a note explaining what you did separate from the changes (called a commit message). If you get stuck, this is explained in more detail in [GitHub's intro documentation](https://guides.github.com/activities/hello-world/).

### Request to Move Your Changes to the Master Copy
Once you are satisfied with your changes, you can request that your work be integrated with the main project page. This process is called submitting a pull request to merge branches. The process will create an alert for us to review and approve your changes, and make tweaks if necessary so that your changes are compatible with other people's contributions.

Click the pull request tab and then click the green *New Pull Request* Button.  ![pull-request](pull-request.gif)

Select master as the *base* branch (this is the branch you want the changes to end up in) and select your new branch as the *compare* branch (this is the branch where the changes are coming from). This will create a nice visual comparison of your changes, with any deleted text in red and any added text in green. When you are ready you can click the green *Create Pull Request* button. Again you can add comments here, separate from your actual revisions, to help us understand what you are doing.

We will receive an alert that you have submitted a contribution. Once we approve it, it will be in the new master branch. Now you have made a valuable addition to the project. 

You can also use GitHub by interacting with Git directly on your own personal computer. This has several advantages, but a large one is using version control on your own work as you make incremental changes. Version control lets you easily see and revert to previous versions of your code without having to save files like my_code_v1, my_code_v2, etc. For a more in-depth discussion of how to use Git and how to use it with GitHub, see the Using Git with GitHub section of this tutorial.

### Creating an Issue
If you have an idea for an improvement, but do not have the time to implement the change, want to discuss it with other team members first, or are not sure how to get started, you can create an issue. This will add to the issue discussion forum and others may implement your suggestions. See GitHub's [documentation](https://help.github.com/articles/creating-an-issue/) on how to create an issue.

## Introduction to Using Python
There are many tutorials and books online to learn the syntax of Python and coding concepts such as for loops and conditionals. This tutorial will instead focus on installing Python and Python libraries, and being able to run Python files from your terminal.

###  Installation Overview
There are a lot of installation options for Python. One good option is to install Anaconda. Anaconda installs Python on your computer, but it also installs many common packages in Python for data analysis. Packages are publicly available add-on tools to use with Python. Because different versions of Python have been released over time, some packages are only supported by certain Python versions. Anaconda also provides a package management environment to help you handle dependency issues between Python and package versions.

You can choose to either install Miniconda or Anaconda. Miniconda only contains Python and the conda package management environment. You can add just the specific Python packages you want installed by manually installing them with the conda package environment after you have installed Miniconda. You should take this approach if you are concerned about how much space to allocate to Python on your computer. Anaconda comes with many packages preinstalled for you, but it will take up more space.

You also need to decide which version of Python you will initially download with Anaconda or Miniconda. You can use the conda package management environment to download other versions of Python if needed once you have done your initial download. The example script in the create_spells directory was written in Python3, but could easily be modified to work in Python2 if necessary. An overview of the differences between Python2 and Python3 can be found [here](https://www.digitalocean.com/community/tutorials/python-2-vs-python-3-practical-considerations-2), but unless you have preexisting support for Python2 at your organization, you may want to consider Python3 as it is the more recent version.

Instructions for downloading Anaconda can be found [here](https://www.continuum.io/downloads). Select the type of computer you have and the version of Python you wish to install to begin. This is the list of [packages](https://docs.continuum.io/anaconda/packages/pkg-docs) that come with Anaconda. You can skip downloading packages you may not use by downloading Miniconda and specifically downloading the packages you want.

Instructions for downloading Miniconda can be found [here](https://conda.io/miniconda.html). Select the type of computer you have and the version of Python you wish to install to begin. Once you have installed Miniconda you can download additional packages by running `conda install package-name` in your terminal. If you do not know how to use your terminal see the Introduction to Running Programs in a Terminal tutorial section.

## Introduction to the Running Programs in a Terminal

### What Is a Terminal
The terminal is what allows you to interact with your computer without needing to use a mouse. Custom programs are often launched from a terminal. If you downloaded Anaconda previously, it also installed a terminal called *Anaconda Prompt*. You may use this terminal to launch programs. Not all terminal programs are the same and the terminals that are often used with Mac or Linux have different syntax for some commands.

To launch your programs you may need to navigate through directories (like folders on your Desktop) to find the right files to access. If you open your terminal and type `cd` followed by the *name of the directory* you wish to enter, this will change the working space of your terminal to that directory. Typing `cd ..` will take you back to where you were before.

Some other commands such as the command to list the contents of your current directory will be different depending on the type of terminal you are running. If it is a terminal that uses syntax like Windows terminals, then the command to see the contents of your current folder is `dir`. If it is a Unix-like terminal, the command is `ls`. File paths may also be different depending on whether you are in a Windows environment that uses `\` or a Unix environment that uses `/`. There are many online guides, such as this [one](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/4/html/Step_by_Step_Guide/ap-doslinux.html), to help you navigate the difference between Windows-like terminals and Unix terminals.

### Run a Python Command
#### Check That Your Terminal Recognizes Python
If you have properly installed Python your terminal should recognize the keyword *Python*. If you have installed Python, but your terminal does not recognize the word *Python*, you may need to change your settings so that your terminal knows where to find your Python installation. If you are using the *Anaconda Prompt* it should recognize *Python* as a keyword.

When you type *Python* into the *Anaconda prompt* it will launch a Python shell and you can type Python directly into your terminal to see results.  
    >>> 1 + 1 = 2

However, you will usually want to launch programs that you have written into a Python file such as our example script spells.py. Type `quit()` into your terminal to exit the Python shell and return to your terminal.

#### Launching Python Scripts from Your Terminal  

You can launch commands by typing Python *name-of-your-script* and additional command line arguments the program may require.

 A command line argument takes user input from the terminal and passes it to the Python program. For example, the Python program hello.py printed below:
 ```
 import sys
 name = sys.argv[1]
 print("Hello, {}".(name))
 ```
Will print "Hello, Alex" if you type:
`python hello.py Alex`

#### Finding a Text Editor to Read and Write Python Files
You can read and write Python (.py) files in a text editor that comes with your computer, like notepad. However, some text editors provide syntax highlighting that can make reading and writing programs much easier. A text editor like [Atom](https://atom.io/), which is an open source text editor created by GitHub, can tell that you have a Python script open and will highlight key words in different colors, making it easier to read and edit files.

## Using Git with GitHub
You may eventually want to consider using Git to take full advantage of using GitHub. Git is the version control system GitHub uses. If you install it locally, you can use version control as you make changes locally and interact with the version of the code online (the remote repository) in your terminal or in a graphical user interface (GUI) you download to work on your desktop.

You should be careful not to upload files to GitHub that you do not intend to be public. You should consider keeping these files outside of your Git folder locally. If you need help removing
information from a repository, contact us and we can help you work on it.

### Using Git within Your Terminal
First, [download](https://git-scm.com/downloads) Git for your operating system. After installation, you should see several programs available such as *Git Bash*, *Git CMD*, *Git GUI*. The first two are terminal programs that let you use Git from the terminal. *Git Bash* is like a Unix terminal and *Git CMD* is like a Windows terminal. *Git GUI* is a way to use Git locally without using the terminal but by clicking with your mouse instead.

Play around with a [simulated version](https://try.github.io/levels/1/challenges/1) of using Git with your terminal in your web browser to learn the commands.
