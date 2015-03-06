#!/usr/bin/env bash

LOCAL_REPO=${LOCAL_REPO:-${PWD}/localRepo}
TYCHO_MVN_ARGS="-Dmaven.test.skip=true -Dmaven.repo.local=$LOCAL_REPO -Dtycho.localArtifacts=default"
echo -e "\n\tTYCHO_MVN_ARGS\n"



if [[ ! -d org.eclipse.tycho ]]
then
  git clone git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.git
fi
cd org.eclipse.tycho
git pull git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho
refs/changes/74/43274/1 && git checkout FETCH_HEAD
git fetch git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho
refs/changes/28/43328/1 && git cherry-pick FETCH_HEAD
git revert 2ab08b7a0079f277f52eacab3a9a4bbd0b112564 --no-edit
# dw, removed: -Dtycho.localArtifacts=ignore
mvn ${TYCHO_MVN_ARGS} clean install
cd ..
if [[ ! -d org.eclipse.tycho.extras ]]
then
  git clone git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.extras.git
fi
cd org.eclipse.tycho.extras
git pull git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.extras.git
mvn ${TYCHO_MVN_ARGS} clean install
