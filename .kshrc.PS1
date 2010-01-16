#
# File            .kshrc.PS1
# Description     The .kshrc.* file that deals with setting the $PS1 
#                 Actually, it deals with   ANY    E N V I R O N M E N T A L 
#                 things that should be reflected on the $PS1
#                 o In particular ClearCase, and setting aliases appropriate 
#                   for clearcase.   Perhaps I should have a .kshrc.clearcase...
#                 
#
#


ps1() {  # Use this to repeatedly regain the PS1
	export KSHRC_PS1_COLLECTED="";
	'.' ~/.kshrc.PS1;
}

#      k s h   l e v e l 
##################################
#
export LEVEL

##PARENT_OWNER="`/bin/ps -p $PPID -F user= | /bin/sed 's/ //g' `" #AIX
##PARENT_OWNER="`/bin/ps -fp $PPID | awk '{ln=$1}; END {print ln}'`" #SOLARIS
PARENT_OWNER="`logname`" #cygwin
if [ "$LOGNAME" != "$PARENT_OWNER" ] ; then #become a new uid - login or su
	if [ -z "${LEVEL}" ] ; then 
		let LEVEL=0
	else
		if [ ${LEVEL:-0}  -gt 0 ]  ; then
			let LEVEL=1+LEVEL
		else
			let LEVEL=0
		fi
	fi
else  # not changed my uid
	if [ -z "${LEVEL}" ] ; then
		let LEVEL=1
	else
		let LEVEL=1+$LEVEL
	fi
fi


#    D C E    l o g i n 
###########################
#

if [ ! -z "${KRB5CCNAME:-}" ]
then
##	DCE_LOGGED_IN="`/usr/bin/basename $KRB5CCNAME`"
	DCE_LOGGED_IN=" DCE_LOGGED_IN"
else
	DCE_LOGGED_IN=""
fi

#     r o o t   a c c o u n t 
##############################
#
# Discover UserName

WHOAMI=`$WHOAMI_BIN`;
if [ "$WHOAMI" = "root" ]  # $WHOAMI is set in .kshrc.architecture   ...
then
	USER_PREFIX="#"
	USER_LEADIN="#"
else
	USER_PREFIX=""
	USER_LEADIN=">"
fi


#NB: $WHOAMI is set in .kshrc.architecture ...
if [ "$LOGNAME" != "$WHOAMI" ] 
then 
	SWITCHED=" - $WHOAMI"
else
	SWITCHED=""
fi

#  C l e a r c a s e    V i e w 
#####################################
#
##cc_detection() {
##	CCVIEW=$(cleartool pwv -short)            #warning this is slow.....
##	if [ "$CCVIEW" = '** NONE **' ] ; then 
##		CCVIEW="" ; 
##	else
##		USER_LEADIN="(cc)$USER_LEADIN"
##		'.' $HOME/.kshrc.cc
##	fi
##}

#  P S 1     finish
####################
#

pathlast3() {
	echo he ho ${PWD#/*/*/*/*}
}

if [ ! -z "$CLEARCASE_ROOT" ] ; then # ClearCase Env.
	USER_LEADIN="(cc)$USER_LEADIN";
##	cc_detection;
##	PS1="   ${HON}${CCVIEW}:"'${PWD}'"${HOFF}
	PS1="(${USER_PREFIX}${LEVEL}:${LOGNAME}${SWITCHED}${USER_PREFIX})${HOSTNAME}${DCE_LOGGED_IN}:"'${PWD#/*/*/*/*}'"(cc)${CCVIEW}${USER_LEADIN}"
	PS1="(${USER_PREFIX}${LEVEL}:${LOGNAME}${SWITCHED}${USER_PREFIX})${HOSTNAME}${DCE_LOGGED_IN}:"'$(pathlast3)'"(cc)${CCVIEW}${USER_LEADIN}"
	PS1="(${USER_PREFIX}${LEVEL}:${LOGNAME}${SWITCHED}${USER_PREFIX})${HOSTNAME}${DCE_LOGGED_IN}:"'${PWD#/*/*/*/*}'"(cc)${CCVIEW}${USER_LEADIN}"

else # NON-ClearCase
##	PS1="(${USER_PREFIX}${LEVEL}:${LOGNAME}${SWITCHED}${USER_PREFIX}) ${HOSTNAME}:${DCE_LOGGED_IN}:${CCVIEW}:"'${PWD}'"
##"'${PWD##*/}'"${USER_LEADIN}"
	PS1="(${USER_PREFIX}${LEVEL}:${LOGNAME}${SWITCHED}${USER_PREFIX})${HOSTNAME}${DCE_LOGGED_IN}${CCVIEW}:"'${PWD#/*/*/*/*/*/*/*/*}'${USER_LEADIN}

##	PS1="(${USER_PREFIX}${LEVEL}:${LOGNAME}${SWITCHED}${USER_PREFIX})${HOSTNAME}${DCE_LOGGED_IN}${CCVIEW}:"'${PWD##/*/*/*/*/*}'${USER_LEADIN}
fi

