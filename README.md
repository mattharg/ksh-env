# ksh-env
Suite of ksh functions
======================
These shell functions provide additional facilities at the command line to the standard shell environment. 
They were written in the then Korn shell in the late 1990s mainly on AIX, HP-UX and Solaris and designed to work across the many
unix/linux systems I administered at that time. 

You get hooked on your shell environment, so I still use them in 2022, though now mainly in as zsh/Macs, or bash/Linux. 
There is very little difference, from a scripting viewpoint, between the main interactive shells, viz. sh, bash, ksh, zsh.  
I try to accomodate those differences so they work under all these shells.

Calling Order
-------------

After the .profile is sourced, the shell sources the file described by $ENV environment variable, ".kshrc" by default. 
This file sources all the remaining files.  

Shell Configuration 
-------------------
  * .kshrc.PS1          - Configures the $PS1 variable for the command line prompt.
  * .kshrc.aliases      - Just command-line aliases
  * .kshrc.PATH         - Functions to help manage paths, PATH, MANPATH and others.
  * .kshrc.architecture - Determine the host OS and make some configurations dependent on differences between OS'.
  * .kshrc.arch.solaris - Solaris configuration.
  * .kshrc.dev          - Software development configuration. 
  * .kshrc.c_dev        - Configure for C software development. 
  * .kshrc.fns          - General purpose shell functions - this sources additional starting with .kshrc.fns...
  * .kshrc.fns.ps       - Shell functions to assist with process management.
  * .kshrc.fns.paths    - Shell functions to assist with working with paths. 
  * .kshrc.fnprog       - Functional programming facilities.
  * .kshrc.fns.sets     - Shell functions to implement sets of strings.  These are sometimes useful when working at the command line.
  * .kshrc.site...      - Site-specific configurations.  This keeps configurations specific to a site/workplace out of the other files.
  * .kshrc.networking   - Networking specific functions.
 
 Job and Batch Management
 ------------------------
   * .batch.defns       - To be 'source'd to collect functions helpful when running batch at the command-line - i.e. not within cron or a batch management system.  This uses the job control facilities of the shell to manage and report on the background tasks.  Even has some demos and unit testing.  Got carried away. 
   * 

