################################################################################################################
# This is Jenkins Deployment script for UNIX files Deployment related to Datastage project
################################################################################################################

#!/bin/sh

#Define variables
DEP_HOME="/proj/deploy/$1"
TMP_FLD="${DEP_HOME}/temp"
if [ $2 = "IT" ]; then
  PROJ_FLD="/proj/root/for/IT"
else
  PROJ_FLD="/proj/root/for/OTHER"
fi

echo "Linux files for deployment:"	
if grep '^LINUX' ${TMP_FLD}/TrnsfrFiles.txt; then
  grep '^LINUX' ${TMP_FLD}/TrnsfrFiles.txt>${TMP_FLD}/LinuxFiles.txt
fi

if [ -f "${TMP_FLD}/LinuxFiles.txt" ]; then
  
  for file in $(cat ${TMP_FLD}/LinuxFiles.txt); do
    FILE_PATH=`echo $file | cut -d "/" -f 2-`
    FILE_FLD=`echo ${FILE_PATH} | rev | cut -d "/" -f 2- | rev`
    FILE_EXT=`echo $file | rev | cut -d "." -f 1 | rev`
    TYPE_FLD=`echo $file | rev | cut -d "/" -f 2 | rev`
    
    echo ""

    if [ ${TYPE_FLD} = "paramfiles" ]; then
	if [ -f ${PROJ_FLD}/${FILE_PATH} ]; then
	  cp ${PROJ_FLD}/${FILE_PATH} ${PROJ_FLD}/${FILE_FLD}/backup
	  echo "Backed up ${PROJ_FLD}/${FILE_PATH}"
	fi
	cp $DEP_HOME/$file ${PROJ_FLD}/${FILE_PATH}
	chmod 775 ${PROJ_FLD}/${FILE_PATH}
	echo "Deployed ${PROJ_FLD}/${FILE_PATH}"
    elif [ ${TYPE_FLD} = "persistentfiles" ]; then
	if [ -f ${PROJ_FLD}/${FILE_PATH} ]; then
	  cp ${PROJ_FLD}/${FILE_PATH} ${PROJ_FLD}/${FILE_FLD}/backup
	  echo "Backed up ${PROJ_FLD}/${FILE_PATH}"
	fi
	cp $DEP_HOME/$file ${PROJ_FLD}/${FILE_PATH}
 	chmod 775 ${PROJ_FLD}/${FILE_PATH}
	echo "Deployed ${PROJ_FLD}/${FILE_PATH}"
    elif [ ${TYPE_FLD} = "xref" ]; then
	if [ -f ${PROJ_FLD}/${FILE_PATH} ]; then
	  cp ${PROJ_FLD}/${FILE_PATH} ${PROJ_FLD}/${FILE_FLD}/backup
	  echo "Backed up ${PROJ_FLD}/${FILE_PATH}"
	fi
	cp $DEP_HOME/$file ${PROJ_FLD}/${FILE_PATH}
        chmod 765 ${PROJ_FLD}/${FILE_PATH}
	echo "Deployed ${PROJ_FLD}/${FILE_PATH}"
    elif [ ${TYPE_FLD} = "security" ]; then
	if [ -f ${PROJ_FLD}/${FILE_PATH} ]; then
	  cp ${PROJ_FLD}/${FILE_PATH} ${PROJ_FLD}/${FILE_FLD}/backup
	  echo "Backed up ${PROJ_FLD}/${FILE_PATH}"
	fi
	cp $DEP_HOME/$file ${PROJ_FLD}/${FILE_PATH}
        chmod 660 ${PROJ_FLD}/${FILE_PATH}
	echo "Deployed ${PROJ_FLD}/${FILE_PATH}"
    elif [ ${TYPE_FLD} = "scriptfiles" ]; then
	if [ ${FILE_EXT} = "sh" ]; then
	  if [ -f ${PROJ_FLD}/${FILE_PATH} ]; then
            cp ${PROJ_FLD}/${FILE_PATH} ${PROJ_FLD}/${FILE_FLD}/backup
	    echo "Backed up ${PROJ_FLD}/${FILE_PATH}"
	  fi
	  cp $DEP_HOME/$file ${PROJ_FLD}/${FILE_PATH}
          chmod 674 ${PROJ_FLD}/${FILE_PATH}
	  echo "Deployed ${PROJ_FLD}/${FILE_PATH}"
	  else
	    if [ -f ${PROJ_FLD}/${FILE_PATH} ]; then
	      cp ${PROJ_FLD}/${FILE_PATH} ${PROJ_FLD}/${FILE_FLD}/backup
	      echo "Backed up ${PROJ_FLD}/${FILE_PATH}"
	    fi
            cp $DEP_HOME/$file ${PROJ_FLD}/${FILE_PATH}
	    chmod 664 ${PROJ_FLD}/${FILE_PATH}
	    echo "Deployed ${PROJ_FLD}/${FILE_PATH}"
	fi
    fi
  done
    echo -e "\nLinux deployment complete"
else
    echo "No Linux files for deployment"
fi
