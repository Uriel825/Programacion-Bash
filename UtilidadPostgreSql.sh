#!/bin/bash
#Programa para posgres
opcion=0
fechaActual=$(date +%Y%m%d)
#area de funciones

#funcion de instalar
instalar_postgress () {
    echo -e "\n Verificando Instalacion de PostgtreSQL"
 verif=$(which psql) #va a buscar si se encuentra psql en las varaibles de entorno
     if [ $? -eq 0 ]; then # verifica el parametro de si encontro la variable o no 
            echo -e "Se encuentra instalado postgreSQL"
    else  
      read  -s -p "Ingresa la password de SUDO:" password
      echo -e "\n"
      read  -s -p "Ingresa la clave de uso en prostgreSQL" pasPostgres 
      echo "$password" | sudo -S apt update  #| para poder mandar la contrasena al otro comando
      echo "$password" | sudo -S apt-get -y install postgresql postgresql-contrib
      sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '{$PASSWORDpOSTGRES}';"
      echo "$password" | sudo -S systemctl enable postgresql.service
      echo "$password" | sudo -S systemctl start postgresql.service

      fi
    read -n 1 -s -r -p "Presione [ENTER] para continuar..." 
}

#funcion de desinstalar
desinstalar_postgress () {
    echo "Desinstalar postgreSQL"
          read -s -p "Ingresa la password de SUDO:" password
          echo -e "\n"postgresql-common
          echo "$password" | sudo -S systemctl stop postgresql.service
          echo "$password" | sudo -S apt-get -y --purge  remove postgresql  postgresql-11  postgresql-client-11 postgresql-client-common   postgresql-contrib #esto se debe  ir actualizando de acorde a la version que se instalo nadamas hay que cambiar los numeros                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
          echo "$password" | sudo -S rm -rf /etc/postgresql/
          echo "$password" | sudo -S rm -rf /var/log/postgresql/
          echo "$password" | sudo -S rm -rf /var/lib/postgresql/
          echo "$password" | sudo -S userdel -r postgres
          echo "$password" | sudo -S groupdel postgresql
read -n 1 -s -r -p "Presione [ENTER] para continuar..."

}


#funcion de Respaldo
respaldo_postgress () {
    echo "Listar Bases de datos"
    sudo -u postgres psql -c "\l" 
    read -p "Cual base de datos debe ser respaldada:" bddRespa
    echo -e "\n" 
    if [ -d "$1" ] ; then
       echo " Estableciendo permisos"
       echo "$password" | sudo -S chmod 755 $1
       echo "Realizando respaldo"
       sudo -u postgres pg_dump -Fc $bddRespa > "$1/bddRespa$fechaActual.bak"
       echo "El respaldo se realizo correctamente esta en: $1/bddRespa$fechaActual.bak" 
    else
        echo "El directorio no existe" 
    fi
    read -n 1 -s -r -p "Presione [ENTER] para continuar..."
}

#funcion de Restauracion
restore_postgress () {
    echo "Listar respaldos"
    ls -l $1/*.bak 
    read -p "Elige el respaldo a restaurar" respaldoRest
    echo -e "\n"
    read -p "Ingresa el nombre de la base de datos detino" bddDestino
    #Verificar si existe la BD
    verifyBdd=$(sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -wq $bddDestino)
        if [ $? -eq 0 ] ; then
            echo"Restaurando a...$bddDestino"
        else 
            sudo -u postgres psql -c "create database $bddDestino"
        fi
    
    if [ -f "$1/$respaldoRest" ] ; then
        echo "Restaurando.. respaldo"
        sudo -u postgres pg_restore -Fc -d $bddDestino "$1/$bddrespaldorest"
        echo "Listar bases de datos"
        sudo -u postgres psql -c "\l"
    else 
        echo "EL respaldo no existe"

    fi
        read -n 1 -s -r -p "Presione [ENTER] para continuar..."

}




while :
do
#Lmpiar Pantalla
clear
#Deplegar el menu
echo "*******************************************"
echo           "Utilidades de posgreSQL"
echo "*******************************************"
echo                "Menu Principal"
echo "*******************************************"
echo "1. Instalar PostgreSQL"
echo "2. Desinstalar PostgresSQL"
echo "3. Obtener respaldo de una base de datos"
echo "4. Restaurar el respaldo"
echo "5. Salir de programa"
echo "*******************************************"

#leer 
read -e -n1 -p  "Ingresa la opcion deseada 1 a 5:"  opcion
#validar
case $opcion in
1) 
    instalar_postgress
    sleep 3;;
2) 
    desinstalar_postgress
    sleep 3 ;;
3) 
    read -p "Directorio de backup" directorioBack
    respaldo_postgress $directorioBack
    sleep 3 ;;

4)  read -p "Directorio de respaldo:" directorioRes
    restore_postgress $directorioRes
    sleep 3 ;;
5) 
   echo -e "\nBye :)"
   exit 0;; 
    esac
done 