
#!/bin/bash

# Installation des paquets requis
apt-get update

apt-get install -y proftpd proftpd-mod-tls

# Configuration de ProFTPD
# récupérer les fichiers de config sur github et les placer dans le bon dossier
cd /etc/proftpd
service proftpd stop
#rm -f modules.conf tls.conf proftpd.conf
rm -f /etc/proftpd/modules.conf  
rm  -f /etc/proftpd/tls.conf 
rm -f /etc/proftpd/proftpd.conf
wget https://raw.github.com/Leslie-Sayegh/FTP/blob/main/modules.conf -O /etc/proftpd/modules.conf
wget https://raw.github.com/Leslie-Sayegh/FTP/blob/main/proftpd.conf -O /etc/proftpd/proftpd.conf
wget https://raw.github.com/Leslie-Sayegh/FTP/blob/main/tls.conf -O /etc/proftpd/tls.conf
 
#wget https://raw.githubusercontent.com/Leslie-Sayegh/FTP/main/modules.conf -O modules.conf
#wget https://raw.githubusercontent.com/Leslie-Sayegh/FTP/main/proftpd.conf -O proftpd.conf
#wget https://raw.githubusercontent.com/Leslie-Sayegh/FTP/main/tls.conf -O tls.conf

# Configuration des modules
echo "LoadModule mod_tls.c" >> modules.conf
echo "LoadModule mod_sftp.c" >> modules.conf

mkdir -p /etc/proftpd/ssl
# Génération des certificats SSL
openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/proftpd/ssl/proftpd.key.pem -out /etc/proftpd/ssl/proftpd.cert.pem -days 365

# Redémarrage du service ProFTPD
service proftpd restart

echo "L'installation du serveur FTP ProFTPD est terminée."
