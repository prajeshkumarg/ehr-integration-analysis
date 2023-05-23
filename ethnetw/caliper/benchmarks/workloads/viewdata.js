
'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

/**
 * Workload module for the benchmark round.
 */
class ViewDataworkload extends WorkloadModuleBase {

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
            contractFunction: 'viewData',
            contractArguments: [randomId],
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
    return new ViewDataworkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
