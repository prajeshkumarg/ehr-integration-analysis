#!/bin/bash
# Script to join a peer to a channel
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer1.hospadmin.example.com:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/hospadmin.example.com/peers/peer1.hospadmin.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=hospadmin-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/hospadmin.example.com/users/Admin@hospadmin.example.com/msp
export ORDERER_ADDRESS=orderer2.example.com:7050
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
if [ ! -f "hospital.genesis.block" ]; then
  peer channel fetch oldest -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA \
  --tls -c hospital /vars/hospital.genesis.block
fi

peer channel join -b /vars/hospital.genesis.block \
  -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA --tls
