#!/bin/bash
# Script to instantiate chaincode
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer2.doctor.example.com:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer2.doctor.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
export ORDERER_ADDRESS=orderer2.example.com:7050
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt

peer chaincode invoke -o $ORDERER_ADDRESS --isInit \
  --cafile $ORDERER_TLS_CA --tls -C hospital -n mycc \
  --peerAddresses peer2.doctor.example.com:7051 \
  --tlsRootCertFiles /vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer2.doctor.example.com/tls/ca.crt \
  --peerAddresses peer1.hospadmin.example.com:7051 \
  --tlsRootCertFiles /vars/keyfiles/peerOrganizations/hospadmin.example.com/peers/peer1.hospadmin.example.com/tls/ca.crt \
  --peerAddresses peer2.patient.example.com:7051 \
  --tlsRootCertFiles /vars/keyfiles/peerOrganizations/patient.example.com/peers/peer2.patient.example.com/tls/ca.crt \
  -c '{"Args":[ "initLedger" ]}' --waitForEvent
