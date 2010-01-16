# File:               $HOME/.kshrc.bash.to.ksh
# Description         Create a bash env that enables interpretation of ksh commands
#
# NOTES              
#
#  ! I should ALSO do the reverse of this, ie. to enable bash scripts to be interpreted
#    in a ksh.....  someday I'll create one when I need it.
#
#  o bash DOES allow the creation of 'fg %2; clear'
#
# ToDo
#
#  o bash has $[arith-express], where ksh has $(( arith-express ))
#  o bash has 'builtin' to redefine builtins like 'cd'
#  o bash has NO [[    ]]
#
#

alias [[=' [ '

###########################################################
# p r i n t   : Does Not Exist In bash q/ At some levels
# #########     Will implement using echo
#
#     ksh    'print' is the best option. Has lots of -flags
#            'echo' NOT internal (/bin/echo archaic)
#    bash    'print' does NOT exist, 
#            'echo' built in with 2 -flags 
#               -n (no NL) -e (allow \t \n etc.)
#
#
#
alias print=' echo -e '
##print() {
### Should also deal with the removal of the -flags
##	echo "$@"; 
##}

###########################################################
# w h e n c e : Does Not exist in bash q/ at some levels
# ###########   
#
#     ksh     'whence' is part of the shell; 
#             'type' is an alias to " whence -v "
#    bash      can use the 'type' command which has a lot of options - prob posix
#
#

alias whence=' type ';
# May need batter interpretation of ksh flags....

