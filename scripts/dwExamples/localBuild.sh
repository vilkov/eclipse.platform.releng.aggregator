#!/usr/bin/env bash

# Minamal path
export PATH=/usr/local/bin:/usr/bin:/bin:${HOME}/bin
# unset common variables (some defined for e4Build) which we don't want (or, set ourselves)
unset JAVA_HOME
unset JAVA_ROOT
unset JAVA_JRE
unset CLASSPATH
unset JAVA_BINDIR
unset JRE_HOME

export LOG_OUT_NAME=${PWD}/logout.txt
export LOG_ERR_NAME=${PWD}/logerr.txt

# 0002 is often the default for shell users, but it is not when ran from
# a cron job, so we set it explicitly, so releng group has write access to anything
# we create.
oldumask=`umask`
umask 0002
echo "umask explicitly set to 0002, old value was $oldumask" 1>>$LOG_OUT_NAME 2>>$LOG_ERR_NAME


export JAVA_HOME=/shared/common/jdk1.7.0-latest
export ANT_HOME=/shared/common/apache-ant-1.9.2


# Any invocation of Java, Ant, Maven, etc., should use this as default TMP direcotory, 
# instead of the default /tmp by using 
# -Djava.io.tmpdir=${TMP_DIR}
export TMP_DIR=~/builds/localaggr/tmp
# Just in case it doesn't exist yet (it must exist first, or Java will fail)
mkdir -p ${TMP_DIR}

export ANT_OPTS=${ANT_OPTS:-"-Dbuild.sysclasspath=ignore -Dincludeantruntime=false"}
#
# remember, MaxPermSize is specific to "Oracle VMs". It has to be removed (or over ridden) 
# for other VMs or the VM might fail to start due to unrecognized -XX option. 
export MAVEN_OPTS=${MAVEN_OPTS:--Xmx2048m -XX:MaxPermSize=256M -Djava.io.tmpdir=${TMP_DIR} -Dtycho.localArtifacts=ignore -Declipse.p2.mirrors=false}
export MAVEN_PATH=${MAVEN_PATH:-/shared/common/apache-maven-3.1.1/bin}

export PATH=$JAVA_HOME/bin:$MAVEN_PATH:$ANT_HOME/bin:$PATH

cd eclipse.platform.releng.aggregator
# assumed cloned already
# but typically run 'gitClean.sh' to make pristine
echo "Not cleaned. Assumed what ever cleaning/changes/branches checked out were done already by user"


mvn -Pbree-libs -V clean verify -DskipTests=true -Dmaven.repo.local=/home/davidw/builds/localaggr/localrepo/  2>&1 | tee out.txt

