#!/bin/sh
git clone http://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.git
cd org.eclipse.tycho
git fetch git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho
refs/changes/74/43274/1 && git checkout FETCH_HEAD
git fetch git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho
refs/changes/28/43328/1 && git cherry-pick FETCH_HEAD
git revert 2ab08b7a0079f277f52eacab3a9a4bbd0b112564 --no-edit
# dw, removed: -Dtycho.localArtifacts=ignore
mvn clean install -Dmaven.test.skip=true -Dmaven.repo.local=$LOCAL_REPO
cd ..
git clone http://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.extras.git
cd org.eclipse.tycho.extras
mvn clean install -Dmaven.repo.local=$LOCAL_REPO