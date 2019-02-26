## Introduction to Using Python
There are many tutorials and books online to learn the syntax of Python and coding concepts such as for loops and conditionals. This tutorial will instead focus on installing Python and Python libraries, and being able to run Python files from your terminal.

###  Installation Overview
There are a lot of installation options for Python. One good option is to install Anaconda. Anaconda installs Python on your computer, but it also installs many common packages in Python for data analysis. Packages are publicly available add-on tools to use with Python. Because different versions of Python have been released over time, some packages are only supported by certain Python versions. Anaconda also provides a package management environment to help you handle dependency issues between Python and package versions.

You can choose to either install Miniconda or Anaconda. Miniconda only contains Python and the conda package management environment. You can add just the specific Python packages you want installed by manually installing them with the conda package environment after you have installed Miniconda. You should take this approach if you are concerned about how much space to allocate to Python on your computer. Anaconda comes with many packages preinstalled for you, but it will take up more space.

You also need to decide which version of Python you will initially download with Anaconda or Miniconda. You can use the conda package management environment to download other versions of Python if needed once you have done your initial download. The example script in the create_spells directory was written in Python3, but could easily be modified to work in Python2 if necessary. An overview of the differences between Python2 and Python3 can be found [here](https://www.digitalocean.com/community/tutorials/python-2-vs-python-3-practical-considerations-2), but unless you have preexisting support for Python2 at your organization, you may want to consider Python3 as it is the more recent version.

Instructions for downloading Anaconda can be found [here](https://www.continuum.io/downloads). Select the type of computer you have and the version of Python you wish to install to begin. This is the list of [packages](https://docs.continuum.io/anaconda/packages/pkg-docs) that come with Anaconda. You can skip downloading packages you may not use by downloading Miniconda and specifically downloading the packages you want.

Instructions for downloading Miniconda can be found [here](https://conda.io/miniconda.html). Select the type of computer you have and the version of Python you wish to install to begin. Once you have installed Miniconda you can download additional packages by running `conda install package-name` in your terminal. If you do not know how to use your terminal see the Introduction to Running Programs in a Terminal tutorial section.

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
