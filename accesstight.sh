#!/bin/bash
# Chemin du fichier CSV contenant les informations des utilisateurs
CSV_FILE="Shell_Userlist.csv"

# Vérifier si le fichier CSV existe
if [ ! -f "$CSV_FILE" ]; then
  echo "Le fichier CSV $CSV_FILE n'existe pas."
  exit 1
fi

# Supprimer les espaces dans le fichier CSV
sed -i 's/ //g' "$CSV_FILE"


# Fonction pour créer un utilisateur avec le rôle approprié
create_user() {
  nom=$3
  prenom=$2
  role=$5
  password=$4
  id=$1

  # Vérifier si l'utilisateur existe déjà
  if id "$nom$prenom" >/dev/null 2>&1; then
    echo "L'utilisateur $nom$prenom existe déjà."
    return
  fi

  # Créer l'utilisateur
  useradd -m $nom.$prenom -p "$password" -u $id

  # Créer le répertoire /home et définir le propriétaire
 # mkdir "/home/$nom$prenom"
 # chown "$nom$prenom:$nom$prenom" "/home/$nom$prenom"
  
  # Attribuer le rôle de superutilisateur si l'utilisateur est administrateur
  if [ "$role" == "Admin" ]; then
    usermod -aG sudo "$nom$prenom"
    echo "L'utilisateur $nom$prenom a été créé avec le rôle de superutilisateur"
  else
    echo "L'utilisateur $nom$prenom a été créé."
  fi
}

# Lire le fichier CSV ligne par ligne
while IFS=',' read -r id prenom nom passwd role; do
create_user "$id" "$nom" "$prenom" "$passwd" "$role"
echo "$nom.$prenom  $role"
done < <(tail -n +2 "$CSV_FILE")

# Chemin du script actuel
script_path=$(readlink -f "$0")

# Ajouter le script aux tâches cron
(crontab -l 2>/dev/null; echo "@reboot bash $script_path") | crontab -


