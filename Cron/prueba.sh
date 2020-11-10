#!/bin/bash

cd /

NUM="$(aws sqs get-queue-attributes --queue-url https://sqs.us-east-2.amazonaws.com/296466592965/MessagesQueue --attribute-names ApproximateNumberOfMessages)"
NUM=$(echo "$NUM" | jq '.Attributes')
NUM=$(echo "$NUM" | jq '.ApproximateNumberOfMessages')
NUM="${NUM%\"}"
NUM="${NUM#\"}"
echo "$NUM"

while [ "$NUM" != 0 ]; do

    echo "EL MENSAJE ES"
    MESSAGE="$(aws sqs receive-message --queue-url https://sqs.us-east-2.amazonaws.com/296466592965/MessagesQueue)"

    echo "$MESSAGE"

    MES=$(echo "$MESSAGE" | jq '.Messages')
    echo "Segunda Parte"
    echo "$MES"
    ELE=$(echo "$MES" | jq '.[0]')
    echo "$ELE"
    DEL=$(echo "$ELE" | jq '.ReceiptHandle')
    DEL="${DEL%\"}"
    DEL="${DEL#\"}"
    echo "$DEL"
    BOD=$(echo "$ELE" | jq '.Body')
    echo "$BOD"

    ID=$(echo "$BOD" | jq 'fromjson.imageId')
    ID="${ID%\"}"
    ID="${ID#\"}"
    echo "El ID de la imagen es: $ID"
    EMAIL=$(echo "$BOD" | jq 'fromjson.email')
    EMAIL="${EMAIL%\"}"
    EMAIL="${EMAIL#\"}"
    echo "$EMAIL"
    NAME=$(echo "$BOD" | jq 'fromjson.name')
    LASTN=$(echo "$BOD" | jq 'fromjson.lastname')
    DATE=$(echo "$BOD" | jq 'fromjson.dateCreation')
    DES=$(echo "$BOD" | jq 'fromjson.path_original_design')
    DES="${DES%\"}"
    DES="${DES#\"}"
    echo "$DES"
    echo --------------------- imagen---------------------------
    DES=${DES%.*}
    echo "$DES"
    echo -----------------------------------------------------------
    aws s3 cp s3://designmatch-g11/uploads/design/path_original_design/"$ID" /home/designmatchg11/convert/"$ID" --recursive
    echo --------------------------------------------------------------------------------------------------------------------------
    cd /home/designmatchg11/convert/"$ID"
    convert * -set filename:base %[basename] -resize 800x600 -gravity South -pointsize 30 -annotate +0+0 "Diseñado Por $NAME $LASTN\n $DATE" %[filename:base]mod.png
    echo ---------------------------------------------------------------------------------------------------------------------------
    EXT="mod.png"

    aws s3 cp /home/designmatchg11/convert/"$ID"/"$DES$EXT" s3://designmatch-g11/uploads/design/path_original_design/"$ID"/ --acl public-read
    echo ------------------------------------------------------ MONGO ----------------------------------------------------------------
    echo "ID: $ID"
    SET='$set'
    mongo "mongodb://172.31.4.205:27017/designMatch" --eval "db.designs.update({ _id : ObjectId('$ID') }, {$SET: { state_id : ObjectId('5f976b89b4569252bdab73cb') } })"
    echo ---------------------------------------------------------------------------------------------------------------------------------
    echo 'Tu diseño ya ha sido publicado en la pagina del proyecto' | /usr/sbin/ssmtp "$EMAIL"
    aws sqs delete-message --queue-url https://sqs.us-east-2.amazonaws.com/296466592965/MessagesQueue --receipt-handle "$DEL"

    NUM="$(aws sqs get-queue-attributes --queue-url https://sqs.us-east-2.amazonaws.com/296466592965/MessagesQueue --attribute-names ApproximateNumberOfMessages)"
    NUM=$(echo "$NUM" | jq '.Attributes')
    NUM=$(echo "$NUM" | jq '.ApproximateNumberOfMessages')
    NUM="${NUM%\"}"
    NUM="${NUM#\"}"
    echo "$NUM"


done

echo "Se han procesado las imagenes"
