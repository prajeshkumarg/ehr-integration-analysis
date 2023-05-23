sudo chmod -R 777 vars/
sudo cp -r ../mycc vars/chaincode/
minifab ccup -l node -n mycc -v 2.0 -p '"initLedger"'

