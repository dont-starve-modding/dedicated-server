ClusterName=Wildnis

echo "Cluster name is ${ClusterName}..."

sleep 3

if [[ ! -f cluster_token.txt ]] ; then
    echo 'File "cluster_token.txt" is not there, aborting. Get a cluster_token here: https://docs.linuxgsm.com/game-servers/dont-starve-together#authentication-token'
    exit
fi

if [[ ! -f pw.txt ]] ; then
    echo 'File "pw.txt" is not there, aborting. This file has to contain the server password for players.'
    exit
fi

echo ""
echo "Ensure that the following packages are installed:"
echo ""
echo "tmux wget ca-certificates file bsdmainutils util-linux python bzip2"
echo "gzip unzip binutils bc jq lib32gcc1 libstdc++6:i38 libcurl4-gnutls-dev:i386"
echo ""
echo "STOP THE PROCESS WITH CTRL+C IF YOU WANT TO INSTALL THOSE PACKAGES NOW!"

sleep 8

mkdir ${ClusterName}-Master
mkdir ${ClusterName}-Caves

wget https://linuxgsm.com/dl/linuxgsm.sh && chmod +x linuxgsm.sh

cp linuxgsm.sh ${ClusterName}-Master/
cp linuxgsm.sh ${ClusterName}-Caves/

cd ${ClusterName}-Master
./linuxgsm.sh dstserver
sleep 2
./dstserver

cd ../${ClusterName}-Caves

./linuxgsm.sh dstserver

sleep 2

./dstserver

cd ..

cp dst-server-Master.cfg ${ClusterName}-Master/lgsm/config-lgsm/dstserver/dst-server-Master.cfg
cp dst-server-Caves.cfg ${ClusterName}-Caves/lgsm/config-lgsm/dstserver/dst-server-Master.cfg

echo "cluster=\"${ClusterName}\"" >> ${ClusterName}-Master/lgsm/config-lgsm/dstserver/dst-server-Master.cfg
echo "cluster=\"${ClusterName}\"" >> ${ClusterName}-Caves/lgsm/config-lgsm/dstserver/dst-server-Master.cfg

cd ${ClusterName}-Master
./dstserver ai

cd ../${ClusterName}-Caves
./dstserver ai

cd ..

${ClusterName}-Master/dstserver start
${ClusterName}-Caves/dstserver start

sleep 3

${ClusterName}-Master/dstserver stop
${ClusterName}-Caves/dstserver stop

cp server-Master.ini ~/.klei/DoNotStarveTogether/${ClusterName}/Master/server.ini
cp server-Caves.ini ~/.klei/DoNotStarveTogether/${ClusterName}/Caves/server.ini

cp cluster.ini ~/.klei/DoNotStarveTogether/${ClusterName}/cluster.ini

echo "cluster_name = ${ClusterName}" >> ~/.klei/DoNotStarveTogether/${ClusterName}/cluster.ini
echo "cluster_password = $(cat pw.txt)" >> ~/.klei/DoNotStarveTogether/${ClusterName}/cluster.ini

cp cluster_token.txt ~/.klei/DoNotStarveTogether/${ClusterName}/cluster_token.txt

cp dedicated_server_mods_setup.lua ${ClusterName}-Master/serverfiles/mods/
cp dedicated_server_mods_setup.lua ${ClusterName}-Caves/serverfiles/mods/

cp modoverrides.lua ~/.klei/DoNotStarveTogether/${ClusterName}/Master/
cp modoverrides.lua ~/.klei/DoNotStarveTogether/${ClusterName}/Caves/

echo "You may change settings now. The file is here: ~/.klei/DoNotStarveTogether/${ClusterName}/cluster.ini"
echo "Finished installation. Edit settings and start servers using ./restart-dst-servers.sh"
