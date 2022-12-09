# ksh-env
Suite of ksh functions
======================
These shell functions provide additional facilities at the command line to the standard shell environment. 
They were written in the then Korn shell in the late 1990s mainly on AIX, HP-UX and Solaris and designed to work across the many
unix/linux systems I administered at that time. 

You get hooked on your shell environment, so I still use them in 2022, though now mainly in as zsh/Macs, or bash/Linux. 
There is very little difference, from a scripting viewpoint, between the main interactive shells, viz. sh, bash, ksh, zsh.  
I try to accomodate those differences to they work under all these shells.

Calling Order
-------------

After the .profile is sourced, the shell sources the file described by $ENV environment variable, ".kshrc" by default. 
This file sources all the remaining files.  

Shell Configuration 
-------------------
.kshrc.PS1          - Configures the $PS1 variable for the command line prompt.

.kshrc.PATH         - Functions to help manage paths, PATH, MANPATH and others.

.kshrc.architecture - Determine the host OS and make some configurations dependent on differences between OS'.


