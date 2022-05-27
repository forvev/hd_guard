# hd_guard

The automation of our daily things is really important in terms of speeding up our work. This idea refers to the HD guard.

The essential idea of this program is keeping track of your disk space. 

The user can provide the vaule, which will be followed in the next steps. When disk usage reach this treshold vaule, the program displays information about it.
There are two ways; clear the partition or just skip it.

When we choose the first one the program will display a set of proposed files to choose (in the next steps it will be removed or archiced - depends on user). Everything is properly selected. It avoids files such as links, system's files. Generally speaking any files, which are important for our system, won't be proposed. 
Going forward, hd guard will dispaly a set of file, which are selected. The user can delete them from the list in case when they are supposed to be valuable for the user. Here, all of the files are sorted ascending (when it comes to file's size). In case when we will skip all the files, another ten will be displayed.

After the section with choosing files the user can decide whether he wants to delete them or just archive.

When it comes to removal it is really simple, because the files are just removed form our disk.
Considering the second way, which is an archiving the user has to provide the palace, where zip file will be saved. It accepts only correct directories.
After that the program check whether we cleaned enough space or not. If not, the steps will be repeated.

