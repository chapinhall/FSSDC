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
