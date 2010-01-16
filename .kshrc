#   
# N O T E  :  on /bin/ksh scripts for quick invocation
#             use the first line as "#!/bin/ksh -p"
#             in order *NOT* to source ~/.profile and ~/.kshrc


#
# Bugs:     Need a way to say, "If this env is already here, then don't bother..."
#           This is to speed up the execution of ksh scripts
#           Another mechanism would be to say, 'only do this on INTERACTIVE scripts
#            
# NOTES:    I am *NOT ALWAYS* getting ~/.profile executed (default shell is csh), 
#           so it is probably best to make sure all the values are ALSO HERE> 
#
# TEST1 = o DONE   FIRST_LOGIN ksh
# TEST2 = o INTERACTIVE  ksh
# T O   D O   TEST3 = o what architecture and I on and therefore a whollotta stuff....
#
# SECTION 0   - For Every ksh        - both batch and interactive
# SECTION 0.1 - determine the m/c and o/s architecture.....
# SECTION 1   - Interactive ksh ONLY - reset the PS1, etc.
# SECTION 2   - LOGIN ksh ONLY       - these should EXPORT to all future ones though...
#
# C O N V E N T I O N S 
#######################
#  What I have to work with, since fns and aliases share the same name space..
#                          1.lowercase       2.UPPERCASE
#   1. fns (or aliases)     ff                FF
#   2. env.var.s           $ff               $FF
#
#   Some conventions I use in my ksh environment ::
#    facility()        often assigns to the assoc. env. var. 
#                      of the same name 
#    $facility         which contains a simple list which is the 
#                      result of the fn (a sort of string return value that can 
#                      be easily used on the cmmd-line.
#
#    alias facility    takes the place of the function and works in a
#                      simillar way.
#    alias FACILITY    (NB. UPPERCASE).  A related form of facility to  alias facility
#                      This is realy just a lazy way of doing 'facility -different'
#
# MACRO Execution Mechanism
#   Store the macro in an env.var.,    eg.        $eval_params
#   Then eval is using 'eval'          eg. eval  "$eval_params"
#   Can create an alias to do this,    eg. alias   eval_params="eval $eval_params"
#
#
###########################################################################
#
#      0 :  E V E R Y      k s h        (whether batch or interactive)
#
###########################################################################
#
# The problem here is I really only want to do them ONCE and have them 
# 'export'ed, but batch, or 'cron' jobs wouldn't have them....
#  Perhaps my batch jobs should EXPLICITLY source .kshrc
#     s t d     e n v   v a r s  - have these *ALWAYS*

##if [ "$DOT_PROFILE_SOURCED_ALREADY" != "true" ] ;then
##	print "Collecting my   .profile\c"; 
##	print "  Done";
##fi

# guess at an universally safe PATH
# PATH= is picked up from ~/.profile so I don't do it again here, but what about X-....
MANPATH="/usr/share/man:/usr/contrib/man:/usr/local/man:$MANPATH"; export MANPATH

export HOSTNAME="`hostname`"      # q! This is archi. dependent.
       HOSTNAME=${HOSTNAME%%.*};  # remove any domain part in the hostname
export ENV=$HOME/.kshrc

export user=$USER;
export hostname=$HOSTNAME;
##limit coredumpseize 0k;
export tty=$TTY;

umask 027; stty erase ^H; stty intr  ^C
set -o vi; set -o ignoreeof
##set -o vi-tabcomplete; 
WPTERM=/usr/wp/slib/ibm3151_51;    export WPTERM

ESCDELAY=5000;              export ESCDELAY

# Best to detect the best version of vi to use......
##VI="/usr/local/bin/nvi";   export VI  # failing for some reasons...
##WINEDITOR="vim -g -bg black -fg green -bold yellow -fn 10x20"; export WINEDITOR
##VI="/bin/vi";   export VI

EXINIT="so $HOME/.exrc";   export EXINIT
TMOUT="0" >/dev/null 2>&1; export TMOUT
AE1_ROOT="$HOME/projae1";  export AE1_ROOT
AE1_HOME="$HOME/projae1";  export AE1_HOME
MAILNAME="Matthew Hargreaves"
##SHELL="/bin/ksh -p";       export SHELL
# Get the PERL and PERL_FLAGS env.var.s
get_perl_envvar() {
PERL_JUST_GET_ENVVARS="yes"; 
. $HOME/scripts/perl.sh.executor
PERL_JUST_GET_ENVVARS="";  unset PERL_JUST_GET_ENVVARS;
set +x;
}
get_perl_envvar;


##DEFAULT_X_STATION="admin4";
#
# D e t e r m i n e    BATCH or INTERACTIVE MODE and whether LOGIN_SHELL or NOT
#
TTY=`tty`;   if [ "$TTY" = "not a tty" ] ;               then export BATCH_MODE="yes"; fi
ME=${0##*/}; if [ "$ME" = "ksh"   -o "$ME" = "-ksh"   -o \
                  "$ME" = "pdksh" -o "$ME" = "-pdksh" -o \
                  "$ME" = "bash"  -o "$ME" = "-bash" ] ; then  INTERACTIVE_MODE="yes"; fi
             if [ "$ME" = "-ksh"  -o "$ME" = "-bash" ] ; then  LOGIN_SHELL="yes"; fi

             if [ -t 1 ] ;                              then  STDIN_A_TERM="yes";  fi

if [ "$ME" = "bash" -o "$ME" = "-bash" ] ; then
	'.' $HOME/.kshrc.bash.to.ksh
fi

'.' $HOME/.kshrc.architecture;  # First things first determine the architecture.

#################################################################
#
#      1:    I N T E R A C T I V E    k s h     O N L Y #
#################################################################

if   [    \( "$INTERACTIVE_MODE" != "yes" \
		-o    "$BATCH_MODE"        = "yes" \
					\) \
		-a -z "$KSHRC_FORCE" ]  ; then 
	if [ ! -z "$NOISY" ] ; then print "NON-INTERACTIVE ksh" ; fi
else # Interactive mode ONLY
	   #######################
	print "Interactive: $INTERACTIVE_MODE, batch: $BATCH_MODE, LOGIN_SHELL: $LOGIN_SHELL, ME: $ME"
	set -o vi;
	set -o ignoreeof;
	export LESS="-isx2e"  # so not to have to type :n at each file
	export LESS="-isx2";
	warn="#"
	stty erase "^H" kill "^U" intr "^C" eof "^D" susp "^Z" hupcl ixon ixoff tostop

	export      HISTFILE="$HOME/.hist/hist.${TTY##*/}.on.$HOSTNAME";
	touch      $HISTFILE 2>/dev/null ; 
	chmod 666  $HISTFILE 2>/dev/null

	export      CDHISTFILE=$HOME/.hist/cdhist.${TTY##*/}.on.$HOSTNAME
	touch      $CDHISTFILE 2>/dev/null ; 
	chmod 666  $CDHISTFILE 2>/dev/null

##	chmod -R 666 $HOME/.hist  2>/dev/null

	# Always get a new PS1 in new interactive shells
	# Check for being in a ClearCase shell
	 
  if [ ! -z "$CLEARCASE_ROOT" ] ; then
		CCVIEW=$(/usr/atria/bin/cleartool pwv -short)            #warning this is slow.....
		if [ "$CCVIEW" = '** NONE **' ] ; then
			CCVIEW="" ;
		else
			print "Collecting ClearCase Env."; '.' $HOME/.kshrc.cc
		fi
	fi

		print "Collecting my   aliases  ";   '.' $HOME/.kshrc.aliases
		print "Collecting my   functs   ";   '.' $HOME/.kshrc.fns
		print "Collecting my   PATH     ";   '.' $HOME/.kshrc.PATH   
		print "Collecting my   nettools ";   '.' $HOME/.kshrc.networking 
		print "Collecting my   PS1      ";   '.' $HOME/.kshrc.PS1
##		print "Collecting my  perl if ";   '.' $HOME/.kshrc.perl.if
##SITE="None";    # It would be smarter to DETECT the site.....
SITE="web-dev";    # It would be smarter to DETECT the site.....
		print "Collecting my   $SITE    ";   '.' $HOME/.kshrc.site.${SITE}
		print "NOT Collecting my   C Dev.   ";##   '.' $HOME/.kshrc.c_dev

fi # INTERACTIVE


#################################################################
#
#      2 :  L o g i n    O N L Y     (once only then EXPORT)
#
#################################################################
if [ "${HAVE_LOGGED_IN:-NO}" != "YES" ]
then 
	export HAVE_LOGGED_IN="YES"
	# Put all commands here that occur *ONLY* on the FIRST LOGIN
	############################################################
	#
	#  The problem with this is when you are in a login csh shell
	#  and execute something like (/bin/)type which is a little ksh
	#  script.  since ENV is already set, it sources this file.
	#  Perhaps ONLY def. ENV just prior to starting an INTERACTIVE ksh.

	print "W e l c o l m e"
##	if [ "$HOSTNAME" = "$DEFAULT_X_STATION" ] ; then xhost +; fi
	/usr/bin/uptime;

	if [ -f $HOME/calendar ] ; then
		(cd ; /usr/bin/calendar)
	fi
##	cookie #2>/dev/null

	if [ -s "$MAIL" ] ; then
		echo $MAILMSG
	fi

##	print "Use the other shell?(y/n):\c"; read REP
##	if [ "$REP" = "y" ] ; then
##		$HOME/.pcl
##	fi

fi #INTERACTIVE_BUT_NOT_FIRST_LOGIN


