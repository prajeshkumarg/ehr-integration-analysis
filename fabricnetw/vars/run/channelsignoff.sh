#!/bin/bash
# Script to instantiate chaincode
cp $FABRIC_CFG_PATH/core.yaml /vars/core.yaml
cd /vars
export FABRIC_CFG_PATH=/vars

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer1.doctor.example.com:7051
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer1.doctor.example.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
export ORDERER_ADDRESS=orderer2.example.com:7050
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt

# 1. Fetch the channel configuration
peer channel fetch config config_block.pb -o $ORDERER_ADDRESS \
  --cafile $ORDERER_TLS_CA --tls -c hospital

# 2. Translate the configuration into json format
configtxlator proto_decode --input config_block.pb --type common.Block \
  | jq .data.data[0].payload.data.config > hospital_current_config.json

# 3. Translate the current config in json format to protobuf format
configtxlator proto_encode --input hospital_current_config.json \
  --type common.Config --output config.pb

# 4. Translate the desired config in json format to protobuf format
configtxlator proto_encode --input hospital_config.json \
  --type common.Config --output modified_config.pb

# 5. Calculate the delta of the current config and desired config
configtxlator compute_update --channel_id hospital \
  --original config.pb --updated modified_config.pb \
  --output hospital_update.pb

# 6. Decode the delta of the config to json format
configtxlator proto_decode --input hospital_update.pb \
  --type common.ConfigUpdate | jq . > hospital_update.json

# 7. Now wrap of the delta config to fabric envelop block
echo '{"payload":{"header":{"channel_header":{"channel_id":"hospital", "type":2}},"data":{"config_update":'$(cat hospital_update.json)'}}}' | jq . > hospital_update_envelope.json

# 8. Encode the json format into protobuf format
configtxlator proto_encode --input hospital_update_envelope.json \
  --type common.Envelope --output hospital_update_envelope.pb

# 9. Need to sign channel update envelop by each org admin
export CORE_PEER_LOCALMSPID=doctor-example-com
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/doctor.example.com/peers/peer2.doctor.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/doctor.example.com/users/Admin@doctor.example.com/msp
export CORE_PEER_ADDRESS=peer2.doctor.example.com:7051

peer channel signconfigtx -f hospital_update_envelope.pb

export CORE_PEER_LOCALMSPID=hospadmin-example-com
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/hospadmin.example.com/peers/peer1.hospadmin.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/hospadmin.example.com/users/Admin@hospadmin.example.com/msp
export CORE_PEER_ADDRESS=peer1.hospadmin.example.com:7051

peer channel signconfigtx -f hospital_update_envelope.pb

export CORE_PEER_LOCALMSPID=patient-example-com
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/patient.example.com/peers/peer1.patient.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/patient.example.com/users/Admin@patient.example.com/msp
export CORE_PEER_ADDRESS=peer1.patient.example.com:7051

peer channel signconfigtx -f hospital_update_envelope.pb

