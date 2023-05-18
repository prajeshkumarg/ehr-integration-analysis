#!/bin/bash
# Script to instantiate chaincode
cp $FABRIC_CFG_PATH/core.yaml /vars/core.yaml
cd /vars
export FABRIC_CFG_PATH=/vars

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer2.doctor.example.com:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer2.doctor.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
export ORDERER_ADDRESS=orderer3.example.com:7050
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt

peer channel fetch config config_block.pb -o $ORDERER_ADDRESS \
  --cafile $ORDERER_TLS_CA --tls -c hospital

configtxlator proto_decode --input config_block.pb --type common.Block \
  | jq .data.data[0].payload.data.config > hospital_config.json