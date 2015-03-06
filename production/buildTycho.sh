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
#-Dmaven.test.skip=true
TYCHO_MVN_ARGS="-Dmaven.repo.local=$LOCAL_REPO -Dtycho.localArtifacts=ignore"
echo -e "\n\tTYCHO_MVN_ARGS: ${TYCHO_MVN_ARGS}\n"
TYCHO_EXTRAS_MVN_ARGS="-Dmaven.repo.local=$LOCAL_REPO -Dtycho.localArtifacts=ignore"
echo -e "\n\tTYCHO_EXTRAS_MVN_ARGS: ${TYCHO_EXTRAS_MVN_ARGS}\n"

if [[ -d org.eclipse.tycho ]]
then
  echo "Removing existing directory: org.eclipse.tycho"
  rm -fr org.eclipse.tycho
fi
git clone git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.git

cd org.eclipse.tycho
#git pull git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho
.git/refs/changes/74/43274/1 && git checkout FETCH_HEAD
git fetch git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho
.git/refs/changes/28/43328/1 && git cherry-pick FETCH_HEAD
git revert 2ab08b7a0079f277f52eacab3a9a4bbd0b112564 --no-edit
mvn ${TYCHO_MVN_ARGS} clean install
rc=$?
if [ $rc == 0 ]
then
  cd ..
  if [[ -d org.eclipse.tycho.extras ]]
  then
    echo "Removing existing directory: org.eclipse.tycho.extras"
    rm -fr org.eclipse.tycho.extras
  fi
  git clone git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.extras.git
  cd org.eclipse.tycho.extras
  #git pull git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.extras.git
  mvn ${TYCHO_EXTRA_MVN_ARGS} clean install
  rc=$?
  if [ $rc != 0 ]
  then
    echo -e "\n\t[ERROR] Tycho Extras build failed. mvn returned $rc\n"
  fi
else
  echo -e "\n\t[ERROR] Tycho Build failed. mvn returned $rc\n"
fi
