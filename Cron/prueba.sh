#!/bin/bash

cd /home/estudiante/Proyecto1-Grupo11/public/uploads/design/path_original_design

#convert * -set filename:base %[basename] -resize 800x600 -gravity South -pointsize 30 -annotate +0+0 Diseñado Por DesignMatch\n 11/09/2020" %[filename:base]mod.png

rm *modmod.png

cd /

cd /home/estudiante

mysql -u "Admin" -p"Admin123" -e "USE proyecto_1; SELECT email, name, lastname, s.created_at, path_original_design FROM (designs d INNER JOIN designers s ON d.designer_id=s.id) WHERE d.state_id=1" | while read email name lastname date path; do
    # use $theme_name and $guid variables
    #echo El email es: $email"
    #node Mail/server.js $email"
 #   mysql -eUSE proyecto_1; UPDATE designs SET state_id=2 WHERE state_id=1;"
    #echo $name $lastname $created_at"
    cd Proyecto1-Grupo11/public/uploads/design/path_original_design
    convert * -set filename:base %[basename] -resize 800x600 -gravity South -pointsize 30 -annotate +0+0 "Diseñado Por $name $lastname\n $date" %[filename:base]mod.png
    echo 'Tu diseño ya ha sido publicado en la pagina del proyecto' | /usr/sbin/ssmtp "$email"
    rm *modmod.png
done

mysql -u "Admin" -p"Admin123" -e "USE proyecto_1; UPDATE designs SET state_id=2 WHERE state_id=1;"

echo "Se han procesado las imagenes"


