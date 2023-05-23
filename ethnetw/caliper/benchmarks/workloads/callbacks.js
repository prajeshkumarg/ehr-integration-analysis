
'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

/**
 * Workload module for the benchmark round.
 */
class AddPatientWorkload extends WorkloadModuleBase {

    /**
     * Initializes the workload module instance.
     */
    constructor() {
        super();
        this.contractId = '';
        this.contractVersion = '';
    }

    
    async submitTransaction() {
        const randomId = Math.floor(Math.random()*this.roundArguments.randomSeed);
        const myArgs = {
            contractId: 'HealthCare',
            contractFunction: 'addPatient',
            //create random patient data using inbuilt random function
            contractArguments: [randomId,"10","1234567890","India"],
            readOnly: false
            
        };
        return this.sutAdapter.sendRequests(myArgs);
    }
}

/**
 * Create a new instance of the workload module.
 * @return {WorkloadModuleInterface}
 */
function createWorkloadModule() {
    return new AddPatientWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
