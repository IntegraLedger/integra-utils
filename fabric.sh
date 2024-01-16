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
