#!/bin/bash
cd $FABRIC_CFG_PATH
# cryptogen generate --config crypto-config.yaml --output keyfiles
configtxgen -profile OrdererGenesis -outputBlock genesis.block -channelID systemchannel

configtxgen -printOrg doctor-example-com > JoinRequest_doctor-example-com.json
configtxgen -printOrg hospadmin-example-com > JoinRequest_hospadmin-example-com.json
configtxgen -printOrg patient-example-com > JoinRequest_patient-example-com.json
