        
        set -eo pipefail


        sudo apt-get update

       

        sudo apt install curl -y

        sleep 3

        echo ""
        echo ""
        echo "============================================================================"
        echo "====================== INSTALL JQ =========================================="
        echo "============================================================================"
        echo ""
        echo ""

       

        sudo apt install jq -y

        sleep 3


        echo ""
        echo ""
        echo "============================================================================"
        echo "====================== INSTALL ZIP ========================================="
        echo "============================================================================"
        echo ""
        echo ""

     

        sudo apt install zip -y

        sleep 3

       

        sudo apt-get install unzip -y

        sleep 3

        echo ""
        echo ""
        echo "============================================================================="
        echo "====================== INSTALL NODE JS ======================================"
        echo "============================================================================="
        echo ""
        echo ""

      

        sudo apt install nodejs -y

        sleep 3


        echo ""
        echo ""
        echo "============================================================================="
        echo "====================== INSTALL NPM =========================================="
        echo "============================================================================="
        echo ""
        echo ""

 

        sudo apt install npm -y

        sleep 3



        echo ""
        echo ""
        echo "============================================================================="
        echo "====================== INSTALL NVM =========================================="
        echo "============================================================================="
        echo ""
        echo ""



        #!/bin/bash

        # Install NVM
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

        # Define NVM directory and configuration lines
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

        

        echo ""
        echo ""
        echo "============================================================================="
        echo "====================== INSTALL GO =========================================="
        echo "============================================================================="
        echo ""
        echo ""


        folder_name="/home/$USER/go-prereq"

        if [ -d "$folder_name" ]; then
            echo "Folder '$folder_name' already exists."
        else
            mkdir "$folder_name"
            echo "Folder '$folder_name' created."
        fi

        (cd /home/$USER/go-prereq && wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz)

        
        export PATH=$PATH:/usr/local/go/bin
        
        go version
        
        
        # Check if the line already exists in ~/.profile
        if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' ~/.profile; then
            # Append the line to the ~/.profile file
            echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
            echo "PATH updated successfully."
        else
            echo "PATH already includes /usr/local/go/bin."
        fi
	

        echo ""
        echo ""
        echo "============================================================================="
        echo "====================== INSTALL DOCKER ======================================="
        echo "============================================================================="
        echo ""
        echo ""


   

         echo "test"
        
        set -x

        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
        
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" 
        
        apt-cache policy docker-ce
        
        sudo apt install -y docker-ce

        sleep 3

        echo ""
        echo ""
        echo "============================================================================="
        echo "====================== INSTALL DOCKER COMPOSE ==============================="
        echo "============================================================================="
        echo ""
        echo ""


        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        
        sudo chmod +x /usr/local/bin/docker-compose

        sleep 3


        sleep 3


        echo ""
        echo ""
        echo "============================================================================="
        echo "====================== ADDING USER TO DOCKER GROUP =========================="
        echo "============================================================================="
        echo ""
        echo ""

     

	    sudo usermod -aG docker ${USER}

      




 sg docker newgrp "$(id -gn)" <<'END_SG'
{
 echo ""
        echo "============================================================================="
        echo "====================== DOWNLOAD FABRIC BINARIES ============================="
        echo "============================================================================="
        echo ""
        
        echo "user is $USER"
        set -x

        echo "cd /home/$USER/ && curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.5.5 1.5.8" > /home/$USER/fabric-download.sh
        sleep 3

        echo ""
        echo "============================================================================="
        echo "====================== DOWNLOADING =========================================="
        echo "============================================================================="
        echo ""

        chmod +x /home/$USER/fabric-download.sh
        sleep 3
        /home/$USER/fabric-download.sh

        echo ""
        echo "============================================================================="
        echo "====================== ADDING FABRIC BINARIRES PATH ========================="
        echo "============================================================================="
        echo ""

        sudo /bin/sh -c "echo 'PATH=\"/home/$USER/fabric-samples/bin:\$PATH\"' >>/home/$USER/.profile"
        echo "SOURCING ~/.profile"
        source ~/.profile
}
END_SG




        echo ""
        echo ""
        echo "============================================================================="
        echo "====================== APPLY NEW GROUP MEMBERSHIP ==========================="
        echo "============================================================================="
        echo ""
        echo ""
set -x

sudo usermod -aG docker ${USER}

sudo su - ${USER}
