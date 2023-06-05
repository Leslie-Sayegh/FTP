#!/bin/bash
#
# Arrêter le service FTP s'il est en cours d'exécution
service proftpd stop

# Supprimer le service FTP du démarrage automatique
update-rc.d proftpd remove

# Désinstaller le serveur FTP et ses dépendances
apt-get purge --auto-remove proftpd

# Supprimer les fichiers de configuration et les données du serveur FTP
#rm -f modules.conf tls.conf proftpd.conf
rm -f /etc/proftpd/modules.conf  
rm  -f /etc/proftpd/tls.conf 
rm -f /etc/proftpd/proftpd.conf

# Réinitialiser les autorisations des utilisateurs et des groupes
mv /etc/passwd.bak /etc/passwd
mv /etc/shadow.bak /etc/shadow
mv /etc/group.bak /etc/group

# Supprimer les utilisateurs et groupes créés pour le serveur FTP
deluser ftpuser1
delgroup ftpgroup

echo "Désinstallation du serveur FTP terminée."

