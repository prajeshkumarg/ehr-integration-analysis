'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

class MyWorkload extends WorkloadModuleBase {
    constructor() {
        super();
    }

    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
    }

    async submitTransaction() {
        const patientId = `PAT00${this.workerIndex}`;
        const name = `Patient${this.workerIndex}`;
        const age = Math.floor(Math.random() * 100);
        const gender = Math.random() < 0.5 ? 'Male' : 'Female';
        const address = `${Math.floor(Math.random() * 1000)} Main Street`;
        const phoneNumber = `555-${Math.floor(Math.random() * 10000).toString().padStart(4, '0')}`;

        const myArgs = {
            contractId: this.roundArguments.contractId,
            contractFunction: 'addPatient',
            contractArguments: [patientId, name, age, gender, address, phoneNumber],
            readOnly: false
        };

        return this.sutAdapter.sendRequests(myArgs);
    }

}

function createWorkloadModule() {
    return new MyWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;

