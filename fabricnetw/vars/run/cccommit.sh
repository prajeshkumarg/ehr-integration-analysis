#!/bin/bash
# Script to instantiate chaincode
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer1.doctor.example.com:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer1.doctor.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
export ORDERER_ADDRESS=orderer1.example.com:7050
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/ca.crt
SID=$(peer lifecycle chaincode querycommitted -C hospital -O json \
  | jq -r '.chaincode_definitions|.[]|select(.name=="mycc")|.sequence' || true)

if [[ -z $SID ]]; then
  SEQUENCE=1
else
  SEQUENCE=$((1+$SID))
fi

peer lifecycle chaincode commit -o $ORDERER_ADDRESS --channelID hospital \
  --name mycc --version 3.0 --sequence $SEQUENCE \
  --peerAddresses peer1.patient.example.com:7051 \
  --tlsRootCertFiles /vars/discover/hospital/patient-example-com/tlscert \
  --peerAddresses peer2.doctor.example.com:7051 \
  --tlsRootCertFiles /vars/discover/hospital/doctor-example-com/tlscert \
  --init-required \
  --cafile $ORDERER_TLS_CA --tls
