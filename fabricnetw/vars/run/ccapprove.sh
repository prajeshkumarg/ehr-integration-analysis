#!/bin/bash
# Script to approve chaincode
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer2.doctor.example.com:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer2.doctor.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
export ORDERER_ADDRESS=orderer2.example.com:7050
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt

peer lifecycle chaincode queryinstalled -O json | jq -r '.installed_chaincodes | .[] | select(.package_id|startswith("mycc_3.0:"))' > ccstatus.json

PKID=$(jq '.package_id' ccstatus.json | xargs)
REF=$(jq '.references.hospital' ccstatus.json)

SID=$(peer lifecycle chaincode querycommitted -C hospital -O json \
  | jq -r '.chaincode_definitions|.[]|select(.name=="mycc")|.sequence' || true)
if [[ -z $SID ]]; then
  SEQUENCE=1
elif [[ -z $REF ]]; then
  SEQUENCE=$SID
else
  SEQUENCE=$((1+$SID))
fi


export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer1.doctor.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
export CORE_PEER_ADDRESS=peer1.doctor.example.com:7051

# approved=$(peer lifecycle chaincode checkcommitreadiness --channelID hospital \
#   --name mycc --version 3.0 --init-required --sequence $SEQUENCE --tls \
#   --cafile $ORDERER_TLS_CA --output json | jq -r '.approvals.doctor-example-com')

# if [[ "$approved" == "false" ]]; then
  peer lifecycle chaincode approveformyorg --channelID hospital --name mycc \
    --version 3.0 --package-id $PKID \
  --init-required \
    --sequence $SEQUENCE -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA
# fi

export CORE_PEER_LOCALMSPID=hospadmin-example-com
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/hospadmin.example.com/peers/peer1.hospadmin.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/hospadmin.example.com/users/Admin@hospadmin.example.com/msp
export CORE_PEER_ADDRESS=peer1.hospadmin.example.com:7051

# approved=$(peer lifecycle chaincode checkcommitreadiness --channelID hospital \
#   --name mycc --version 3.0 --init-required --sequence $SEQUENCE --tls \
#   --cafile $ORDERER_TLS_CA --output json | jq -r '.approvals.hospadmin-example-com')

# if [[ "$approved" == "false" ]]; then
  peer lifecycle chaincode approveformyorg --channelID hospital --name mycc \
    --version 3.0 --package-id $PKID \
  --init-required \
    --sequence $SEQUENCE -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA
# fi

export CORE_PEER_LOCALMSPID=patient-example-com
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/patient.example.com/peers/peer1.patient.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/patient.example.com/users/Admin@patient.example.com/msp
export CORE_PEER_ADDRESS=peer1.patient.example.com:7051

# approved=$(peer lifecycle chaincode checkcommitreadiness --channelID hospital \
#   --name mycc --version 3.0 --init-required --sequence $SEQUENCE --tls \
#   --cafile $ORDERER_TLS_CA --output json | jq -r '.approvals.patient-example-com')

# if [[ "$approved" == "false" ]]; then
  peer lifecycle chaincode approveformyorg --channelID hospital --name mycc \
    --version 3.0 --package-id $PKID \
  --init-required \
    --sequence $SEQUENCE -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA
# fi
