#!/bin/bash
# Script to install chaincode onto a peer node
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer1.doctor.example.com:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer1.doctor.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
cd /go/src/github.com/chaincode/mycc


if [ ! -f "mycc_node_2.0.tar.gz" ]; then
  peer lifecycle chaincode package mycc_node_2.0.tar.gz \
    -p /go/src/github.com/chaincode/mycc/node/ \
    --lang node --label mycc_2.0
fi

peer lifecycle chaincode install mycc_node_2.0.tar.gz
