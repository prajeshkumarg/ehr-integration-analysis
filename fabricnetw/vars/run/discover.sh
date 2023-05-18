#!/bin/bash
# Script to discover endorsers and channel config
cd /vars

export PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/tls/ca.crt
export ADMINPRIVATEKEY=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp/keystore/priv_sk
export ADMINCERT=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp/signcerts/Admin@doctor.example.com-cert.pem

discover endorsers --peerTLSCA $PEER_TLS_ROOTCERT_FILE \
  --userKey $ADMINPRIVATEKEY \
  --userCert $ADMINCERT \
  --MSP doctor-example-com --channel hospital \
  --server peer1.doctor.example.com:7051 \
  --chaincode mycc | jq '.[0]' | \
  jq 'del(.. | .Identity?)' | jq 'del(.. | .LedgerHeight?)' \
  > /vars/discover/hospital_mycc_endorsers.json

discover config --peerTLSCA $PEER_TLS_ROOTCERT_FILE \
  --userKey $ADMINPRIVATEKEY \
  --userCert $ADMINCERT \
  --MSP doctor-example-com --channel hospital \
  --server peer1.doctor.example.com:7051 > /vars/discover/hospital_config.json
