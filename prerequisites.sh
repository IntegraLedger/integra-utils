#!/bin/bash

set -eo pipefail

update_apt_repository() {
    sudo apt-get update
    sudo apt-get install net-tools
}

install_curl() {

        echo ""
        echo ""
        echo "========================================================================"
        echo "====================== INSTALLING CURL ================================="
        echo "========================================================================"
        echo ""
        echo ""

    sudo apt install curl -y
}

install_jq() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== INSTALLING JQ ==================================="
    echo "========================================================================"
    echo ""
    echo ""

    sudo apt install jq -y
}

install_zip() {


    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== INSTALLING ZIP =================================="
    echo "========================================================================"
    echo ""
    echo ""

    sudo apt install zip -y
}

install_unzip() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== INSTALLING UNZIP ================================"
    echo "========================================================================"
    echo ""
    echo ""

    sudo apt-get install unzip -y
}

install_nodejs() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== INSTALLING NODEJS ==============================="
    echo "========================================================================"
    echo ""
    echo ""

    curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -

    sudo apt-get install nodejs -y

}

install_npm() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== INSTALLING NPM =================================="
    echo "========================================================================"
    echo ""
    echo ""
    
    sudo apt install npm -y || true
}

install_nvm() {

    echo ""
    echo ""
    echo "========================================================================="
    echo "====================== INSTALLING NVM ==================================="
    echo "========================================================================="
    echo ""
    echo ""

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

    sleep 1

    NVM_DIR="$HOME/.nvm"
        CONFIG_LINES=(
            'export NVM_DIR="$HOME/.nvm"'
            '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm'
            '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion'
        )

        # Add configuration to ~/.profile if not already present
        for line in "${CONFIG_LINES[@]}"; do
            if ! grep -qF "$line" "$HOME/.profile"; then
                echo "$line" >> "$HOME/.profile"
            fi
        done
}


install_go() {


    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== INSTALLING GO ==================================="
    echo "========================================================================"
    echo ""
    echo ""


    sed -i '/export PATH=$PATH:\/usr\/local\/go\/bin/d' ~/.profile

    folder_name="/home/$USER/go-prereq"

    if [ -d "$folder_name" ]; then
            echo "Folder '$folder_name' already exists."
    else
            mkdir "$folder_name"
            echo "Folder '$folder_name' created."
    fi

    (cd /home/$USER/go-prereq && wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz)
    
    echo 'export PATH=$PATH:/usr/local/go/bin' | tee -a ~/.profile
    source ~/.profile
    go version
    
}


update_go_path() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== SETTING GO PATH ================================="
    echo "========================================================================"
    echo ""
    echo ""

    if ! grep -q "export PATH=$PATH:/usr/local/go/bin" ~/.profile; then
        echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
        echo "Go PATH updated successfully."
        source ~/.profile
    else
        echo ""
    fi
}




install_docker() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== INSTALLING DOCKER ==============================="
    echo "========================================================================"
    echo ""
    echo ""

    while true; do
    if ! command -v docker &> /dev/null; then

        set -x

        sudo curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        
        sudo chmod +x /usr/local/bin/docker-compose

        # Docker is not installed, proceed with installation
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        # sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
        echo | sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'

        apt-cache policy docker-ce
        sudo apt-get install -y docker-ce


        # docker ps

        sudo usermod -aG docker ${USER}


        if [ ! -d "$HOME/fabric-samples/bin" ]; then
        echo 
        echo "Directory $HOME/fabric-samples/bin does not exist."
        echo

    # Run the following commands only if the directory does not exist
    sg docker newgrp "$(id -gn)" <<'END_SG'
            echo ""
            echo "============================================================================="
            echo "====================== DOWNLOAD FABRIC BINARIES ============================="
            echo "============================================================================="
            echo ""

            echo "user is $USER"
            set -x

            echo "cd /home/$USER/ && curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.5 1.5.8" > /home/$USER/fabric-download.sh
            sleep 1

            echo ""
            echo "============================================================================="
            echo "====================== DOWNLOADING =========================================="
            echo "============================================================================="
            echo ""

            chmod +x /home/$USER/fabric-download.sh
            sleep 1
            /home/$USER/fabric-download.sh

            echo ""
            echo "============================================================================="
            echo "====================== ADDING FABRIC BINARIES PATH =========================="
            echo "============================================================================="
            echo ""

            sudo /bin/sh -c "echo 'PATH=\"/home/$USER/fabric-samples/bin:\$PATH\"' >>/home/$USER/.profile"
            echo "SOURCING ~/.profile"
            source ~/.profile
            sudo su - ${USER}
END_SG

        else
            echo "Directory $HOME/fabric-samples/bin exists. Skipping download and configuration."
        fi


        sudo su - ${USER}

    else
        sleep 1
        echo

    if docker ps &> /dev/null; then
        docker ps
    else
        echo "User does not have Docker permissions. Adding to docker group."
        sudo usermod -aG docker ${USER}
        sudo su - ${USER}
fi

        echo 
        break
    fi
done
}

install_docker_compose() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== INSTALLING DOCKER_COMPOSE ======================="
    echo "========================================================================"
    echo ""
    echo ""

    sudo curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        
    sudo chmod +x /usr/local/bin/docker-compose
}

add_user_to_docker_group() {


    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== ADDING USER TO USER GROUP ======================="
    echo "========================================================================"
    echo ""
    echo ""

    sudo usermod -aG docker ${USER}
}

download_fabric_binaries() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== DOWNLOADING FABRIC BINARIES ====================="
    echo "========================================================================"
    echo ""
    echo ""

    echo "curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.5 1.5.8" > /home/$USER/fabric-download.sh

    chmod +x /home/$USER/fabric-download.sh
    /home/$USER/fabric-download.sh

    sed -i "s/export PATH=\"\/home\/${USER}\/fabric-samples\/bin:\$PATH\"//g" ~/.profile

    source ~/.profile


   if ! grep -q "PATH=\"/home/$USER/fabric-samples/bin:\$PATH\"" ~/.profile; then
        sudo /bin/sh -c "echo 'export PATH=\"/home/$USER/fabric-samples/bin:\$PATH\"' >>/home/$USER/.profile"
        echo "SOURCING ~/.profile"
        source ~/.profile
 
        echo "Fabric Bin Path is added to ~/.profile"
        echo
        echo $PATH
        echo
   else
        echo "Fabric Bin path added"
        echo
        echo $PATH
        echo ""
   fi

}



update_fabric_path() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== SETTING FABRIC PATH ============================="
    echo "========================================================================"
    echo ""
    echo ""

    sed -i "s/export PATH=\"\/home\/${USER}\/fabric-samples\/bin:\$PATH\"//g" ~/.profile

    source ~/.profile


   if ! grep -q "PATH=\"/home/$USER/fabric-samples/bin:\$PATH\"" ~/.profile; then
        sudo /bin/sh -c "echo 'export PATH=\"/home/$USER/fabric-samples/bin:\$PATH\"' >>/home/$USER/.profile"
        echo "SOURCING ~/.profile"
        source ~/.profile
 
        echo "Fabric Bin Path is added to ~/.profile"
        echo
        echo $PATH
        echo
   else
        echo "Fabric Bin path added"
        echo
        echo $PATH
        echo ""
   fi

}



apply_new_group_membership() {

    echo ""
    echo ""
    echo "========================================================================"
    echo "====================== APPLYING NEW MEMBERSHIP ========================="
    echo "========================================================================"
    echo ""
    echo ""


    sudo usermod -aG docker ${USER}
    sudo su - ${USER}
}



function_name="$1"

if [ -n "$function_name" ]; then

    $function_name
else

    update_apt_repository

    sleep 1

    install_curl

    sleep 1

    install_jq

    sleep 1

    install_zip

    sleep 1

    install_unzip

    sleep 1

    install_nodejs

    sleep 1

    install_npm

    sleep 1

    install_nvm

    sleep 1

    install_go

    sleep 1

    update_go_path

    sleep 1

    install_docker

    sleep 1

   install_docker_compose

    sleep 1

   add_user_to_docker_group 

   sleep 1

   download_fabric_binaries

   sleep 1

   update_fabric_path

   sleep 1

   apply_new_group_membership

fi
