#!/bin/bash
# Script to join a peer to a channel
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer1.doctor.example.com:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer1.doctor.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
export ORDERER_ADDRESS=orderer2.example.com:7050
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
if [ ! -f "hospital.genesis.block" ]; then
  peer channel fetch oldest -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA \
  --tls -c hospital /vars/hospital.genesis.block
fi

peer channel join -b /vars/hospital.genesis.block \
  -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA --tls
