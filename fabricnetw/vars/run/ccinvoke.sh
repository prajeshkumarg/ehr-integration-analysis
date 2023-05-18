#!/bin/bash
# Script to invoke chaincode
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer1.doctor.example.com:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer1.doctor.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
export ORDERER_ADDRESS=orderer3.example.com:7050
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
peer chaincode invoke -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA \
  --tls -C hospital -n mycc  \
  --peerAddresses peer1.patient.example.com:7051 \
  --tlsRootCertFiles /vars/discover/hospital/patient-example-com/tlscert \
  --peerAddresses peer2.doctor.example.com:7051 \
  --tlsRootCertFiles /vars/discover/hospital/doctor-example-com/tlscert \
  -c '{"Args":["viewPatient","PAT001"]}'
