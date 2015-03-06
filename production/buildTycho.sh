#!/bin/sh
git clone http://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.git
cd org.eclipse.tycho
git revert 2ab08b7a0079f277f52eacab3a9a4bbd0b112564 --no-edit
git fetch git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho 
refs/changes/74/43274/1 && git checkout FETCH_HEAD
git fetch git://git.eclipse.org/gitroot/tycho/org.eclipse.tycho 
refs/changes/28/43328/1 && git cherry-pick FETCH_HEAD
mvn clean install -Dmaven.test.skip=true -Dtycho.localArtifacts=ignore
cd ..
git clone http://git.eclipse.org/gitroot/tycho/org.eclipse.tycho.extras.git
cd org.eclipse.tycho.extras
mvn clean install
