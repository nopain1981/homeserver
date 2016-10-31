#/bin/bash
# Input Values:
# * $storage
# * $config
# * $tmp
# * $ports
# * $containername if not equal
DOCPATH=`which docker`
dname=$1
# change parameter to the local storage path
if [[ $BUILDER = 'Maik' ]]; then
echo "Here we switch to Maik's folder: ${dstorage}"
dstorage=/Datengrab;
else
dstorage=/storage;
fi
dockerfs=/playground/homeserver
dconfig=config
dtmp=tmp
dport=$2
primary=$dockerfs/RUNTIME
dockerinst=$dockerfs/INSTALL

echo "1. we have to create a local user which is used for the docker runs"
groupadd -r -g 50000 swuser 
useradd -r -u 50000 -g 50000 -d /home/swuser swuser

echo "Setup Docker Container: ${dname} with Values:"
echo -e ".... Prim Loc:   ${primary}\t\t\t- will be master folder"
echo -e ".... Storage:    ${dstorage}                     \t- mapped in Container as /storage"
echo -e ".... Configpath: ${primary}/${dname}/${dconfig}  \t- mapped in Container as /config"
echo -e ".... Tmp Path:   ${primary}/${dname}/${dtmp}     \t- mapped in Container as /tmp"
echo -e ".... Download & Complete folder: $dockerfs/INCOMING & $dockerfs/COMPLETE \t"
echo -e ".... Portmap:    ${dport}"
echo -e "..... starting ..."
echo -e " "
echo -e "First rebuild the container with current docker files:"
echo -e "... switch to folder: ${dockerinst}/${dname}"
cd $dockerinst/$dname

# Create init Folder
mkdir -p $primary/$dname/$dconfig
mkdir -p $primary/$dname/$dtmp
mkdir -p $dockerfs/INCOMING
mkdir -p $dockerfs/COMPLETE


echo "... now lets build ..."
$DOCPATH build --rm -t $dname .

if [[ $BUILDER = 'Maik' ]]; then
if [[ $dname = 'ark' ]]; then
echo "lets create ark docker container"
$DOCPATH run -d --privileged=true --net="host" --name=$dname \
-e SESSIONNAME=$dname \
-e ADMINPASSWORD="arkadmin" \
-e AUTOUPDATE=120 \
-e AUTOBACKUP=60 \
-e WARNMINUTE=30 \
-v $primary/$dname/$dconfig:/$dname \
-p $dport
$dname
elif
echo "lets create plexbeta docker container"
$DOCPATH run -d --privileged=true --name=$dname \
-e SESSIONNAME=$dname \
-e ADMINPASSWORD="arkadmin" \
-e AUTOUPDATE=120 \
-e AUTOBACKUP=60 \
-e WARNMINUTE=30 \
-v $primary/$dname/$dconfig:/$dname \
$dname
else
$DOCPATH run -d --privileged=true --net="host" --name=$dname \
-v $dstorage/STORAGE:$dstorage \
-v $primary/$dname/$dconfig:/config \
-v $primary/$dname/$dtmp:/tmp \
-v $dockerfs/INCOMING:/INCOMING \
-v $dockerfs/COMPLETE:/COMPLETE \
-p $dport \
-v /etc/localtime:/etc/localtime:ro \
$dname
fi
else
if [[ $dname = 'ark' ]]; then
echo "lets create ark docker container"
$DOCPATH run -d --privileged=true --net="host" --name=$dname \
-e SESSIONNAME=$dname \
-e ADMINPASSWORD="arkadmin" \
-e AUTOUPDATE=120 \
-e AUTOBACKUP=60 \
-e WARNMINUTE=30 \
-v $primary/$dname/$dconfig:/$dname \
$dname
else
echo "... now create the container ..."
#-v $dplayground/$DNAME:/$dname \
$DOCPATH run -d --privileged=true --net="host" --name=$dname \
-v $dstorage:$dstorage \
-v $primary/$dname/$dconfig:/config \
-v $primary/$dname/$dtmp:/tmp \
-v $dockerfs/INCOMING:/INCOMING \
-v $dockerfs/COMPLETE:/COMPLETE \
-p $dport \
$dname
fi
$DOCPATH tag $dname nopain1981/$dname
$DOCPATH push nopain1981/$dname
fi

$DOCPATH ps

