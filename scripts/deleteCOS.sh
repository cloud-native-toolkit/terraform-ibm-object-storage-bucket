#!/bin/bash


echo "Command-Line Arguments" $0 $1 $2 $3 $4
VAR1=$(./mc --version)
if [[ "$VAR1" == mc* ]]
then
    echo "MinIO already installed"    
    chmod +x mc
    echo "Mc has permissions"    
    ./mc config host add IBMCOS $2 $3 $4
    echo "Mc configration done"
else
    wget https://dl.min.io/client/mc/release/linux-amd64/mc
    echo "MinIO has installed" 
    chmod +x mc
    echo "MinIO has permissions"    
    ./mc config host add IBMCOS $2 $3 $4
    echo "MinIO configration done"
fi

# delete contents
./mc rm IBMCOS/$1/ --recursive --force
echo "deleted all bucket contents" 

# remove MinIO
rm -rf mc
echo "Uninstalled MinIO"








  