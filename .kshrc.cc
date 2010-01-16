# File:          $HOME/.kshrc.cc
# Description:   ClearCase ksh config. 
#                Called (q?) ONCE ONLY by .kshrc
 
 ###############################
 #  C L E A R C A S E 
 ###############################
	
USER_LEADIN="(cc)$USER_LEADIN";   # For the PS1

PATH=/usr/atria/bin:$PATH;
MANPATH=/usr/atria/bin/doc/man:$MANPATH;

# NOTE: for each of these gotta 
#  -  assume that we are in ClearCase or I wouldn't have sourced this file
#  1. check that the base dir is in a vob
#  2. perhaps check that we want to do the CC thing instead of the unix fs thing.
#
# create general fns here to facilitate this...
#

umask 002; #print "CC: umask has been set to \c"; umask;  #Our ClearCase stds require full group perm.

# Seb's names
typeset -x ATRIAHOME=/usr/atria
typeset -x  ATRIABIN=${ATRIAHOME}/bin
typeset -x CLEARTOOL=${ATRIABIN}/cleartool

##export NABMKDOSVIEW="/view/default/export/vobs/environment/bin/nabmkdosview";
##export NABMKVIEW="/view/default/export/vobs/environment/bin/nabmkview";
export CLEARCASE_BLD_HOST_TYPE=#SomeHost#
export RGYHOST=#SomeHost#  Get from install area
 
export MANPATH=$MANPATH:$ATRIAHOME/doc/man
export PATH=${PATH}:${ATRIABIN}

export RGY=/net/${RGYHOST}/usr/adm/atria/rgy  # Check SEB
export LOGS=/var/adm/atria/log
export SLOGS=${LOGS}/sync_logs

########################################
#  C l e a r c a s e     A l i a s e s 
########################################

alias ct=cleartool;

	# Standard Ones
	################

CT_CMMDS=" setview catcs setcs edcs pwv startview mktag rmtag mkview rmview lsview llview lsvob llvob describe vtree unco cdiff ctdiff space unregister ci co";

for _ct_cmmd in $CT_CMMDS; do 
	unalias $_ct_cmmd; alias $_ct_cmmd="cleartool $_ct_cmmd";
done;


	# Specials
	#############

##unalias vi;    alias vi="cc.vi";  # though cc.vi should be smart enough to detect non-vob files

if [ -x ${ATRIABIN}/multitool ]; then
	alias mt=multitool
fi

##unalias nabmkview; alias nabmkview='echo Using $NABMKVIEW; $NABMKVIEW';

alias ctman="ct man -graphical";
alias ctl="ct ls ";
alias ctll="ct ls -l ";
alias clsco='ct lsco -short -cview -all'
alias ciall='ct ci -cq `ct lsco -cview -me -all -sh`'
alias clsbr='ct lstype -brtype'
alias clslab='ct lstype -lbtype'
alias cm='clearmake'
##alias make='clearmake'
alias sv='setview'

##unalias mkdir; alias ccmkdir="cc_mkdir";
cc_mkdir() {
	CC_MKDIR_DIR="$1"; a bit of an assumption
	ct co -c "to create dir $CC_MKDIR_DIR"  . ; # actually the base dir
	ct mkdir -nc $CC_MKDIR_DIR; 
	ct ci .; # the same assumption...
}

cpLATEST() {
# Assume we are at $PWD correctly, ie. simple path names
CFSPEC="/main/mgc_phase3/LATEST";
for ccfile; do
	cp $PWD/${1}@@/$CFSPEC      $HOME/tmp/$1
done
}

