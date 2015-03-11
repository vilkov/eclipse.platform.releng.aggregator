#!/usr/bin/env bash

# This definition of localRepo only matters for testing locally,
# when building only Tycho (not Eclipse Platform with patched version,
# which does this definition and removal before this point).
if [[ -z "${LOCAL_REPO}" ]]
then
  LOCAL_REPO=${LOCAL_REPO:-${PWD}/localRepo}
  echo "remove existing localRepo"
  rm -fr ${LOCAL_REPO}
fi
# Similar for SCRIPT_PATH, relevent here only if local, isolated 
# build, else, it is defined elsewhere. 
SCRIPT_PATH=${SCRIPT_PATH:-${PWD}}

#-Dmaven.test.skip=true -DskipTests=true
TYCHO_MVN_ARGS="-Dmaven.repo.local=$LOCAL_REPO -Dtycho.localArtifacts=ignore -DlocalRepositoryPath=$LOCAL_REPO"
echo -e "\n\tTYCHO_MVN_ARGS: ${TYCHO_MVN_ARGS}\n"
TYCHO_EXTRAS_MVN_ARGS="-Dmaven.repo.local=$LOCAL_REPO -Dtycho.localArtifacts=ignore -DlocalRepositoryPath=$LOCAL_REPO"
echo -e "\n\tTYCHO_EXTRAS_MVN_ARGS: ${TYCHO_EXTRAS_MVN_ARGS}\n"

if [[ -d org.eclipse.tycho ]]
then
  echo "Removing existing directory: org.eclipse.tycho"
  rm -fr org.eclipse.tycho
fi
git clone git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.git --quiet

cd org.eclipse.tycho
#git pull git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho
#echo "Applying patches from ${SCRIPT_PATH}/patches"
#git am  < ${SCRIPT_PATH}/patches/0001-428889-Also-handle-root-features-in-the-PublishProdu.patch
#git am  < ${SCRIPT_PATH}/patches/0002-461517-Adopt-new-version-of-p2.patch
#git am  < ${SCRIPT_PATH}/patches/0003-461606-Always-force-.app-for-mac-root-folder.patch


mvn -X -e clean install ${TYCHO_MVN_ARGS}
rc=$?
if [ $rc == 0 ]
then
  cd ..
  if [[ -d org.eclipse.tycho.extras ]]
  then
    echo "Removing existing directory: org.eclipse.tycho.extras"
    rm -fr org.eclipse.tycho.extras
  fi
  git clone git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.extras.git --quiet
  cd org.eclipse.tycho.extras
  #git pull git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.extras.git
  mvn -X -e clean install ${TYCHO_EXTRAS_MVN_ARGS}
  rc=$?
  if [ $rc != 0 ]
  then
    echo -e "\n\t[ERROR] Tycho Extras build failed. mvn returned $rc\n"
  fi
else
  echo -e "\n\t[ERROR] Tycho Build failed. mvn returned $rc\n"
fi
