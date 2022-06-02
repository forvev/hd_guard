# hd_guard

The automation of our daily things is really important in terms of speeding up our work. This idea refers to the HD guard.

The essential idea of this program is keeping track of your disk space.

The user can provide the value, which will be followed in the next steps (e.g. you don’t want to exceed 	30% of the disk usage, so you should put 30).  When disk usage reach this treshold value, the program displays information about it. There are two ways; clear the partition or just skip it.

When we choose the first one the program will display a set of proposed files to choose (in the next steps it will be removed or archived - depends on user). Everything is properly selected. It avoids files such as links, system's files. Generally speaking any files, which are important for our system, won't be proposed. The user can delete them from the list in case when they are supposed to be valuable for the user. Here, all of the files are sorted ascending (when it comes to file's size). In case when we will skip all the files, another ten will be displayed.

After the section with choosing files the user can decide whether he wants to delete or just archive them.

When it comes to removal, it is really simple, because the files are just removed form our disk. Considering the second way, which is an archiving, the user has to provide the palace, where zip file will be saved. It accepts only correct directories. After that, the program will check whether we cleaned enough space or not. If not, the steps will be repeated.

IMPORTANT: before you run the program, please put this command:
dos2unix ./hd_guard.sh  

It will convert a plain text to unix. Otherwise the program couldn't work.
