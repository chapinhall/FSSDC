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
If you have an idea for an improvement, but do not have the time to implement the change, want to discuss it with other team members first, or are not sure how to get started, you can create an issue. This will add to the issue discussion forum and others may implement your suggestions. See GitHub's [documentation](https://help.github.com/articles/creating-an-issue/) on how to create an issue

## Further information

[Git Basics](https://git-scm.com/book/en/v1/Getting-Started-Git-Basics) Introduction to Git written by the maintainers of Git.

[Flight Rules for Git](https://github.com/k88hudson/git-flight-rules) Troubleshooting guide. Look here to fix Git mistakes.

[Resources to Learn Git](https://try.github.io/) Interactive tutorials for Git.