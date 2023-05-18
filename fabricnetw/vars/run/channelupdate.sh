#!/bin/bash
# Script to instantiate chaincode
cp $FABRIC_CFG_PATH/core.yaml /vars/core.yaml
cd /vars
export FABRIC_CFG_PATH=/vars

# Need to set to order admin to update channel stuff by default
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/ordererOrganizations/example.com/users/Admin@example.com/msp
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
export ORDERER_ADDRESS=orderer2.example.com:7050

if [ -f "hospital_update_envelope.pb" ]; then
# Now finally submit the channel update tx
  peer channel update -f hospital_update_envelope.pb \
    -c hospital -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA --tls
else
  echo "No channel configuration update envelop found, do channel sign first."
  exit 1
fi