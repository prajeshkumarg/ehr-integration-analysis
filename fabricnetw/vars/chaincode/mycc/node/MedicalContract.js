'use strict';

const { Contract } = require('fabric-contract-api');

class MedicalContract extends Contract {

    async initLedger(ctx) {
        console.info('Initializing the ledger with default data...');

        // Add some sample patient data
        const patients = [
            {
                patientId: 'PAT001',
                name: 'John Doe',
                age: 35,
                gender: 'Male',
                address: '123 Main Street',
                phoneNumber: '555-1234'
            },
            {
                patientId: 'PAT002',
                name: 'Jane Smith',
                age: 28,
                gender: 'Female',
                address: '456 Elm Street',
                phoneNumber: '555-5678'
            }
        ];

        for (let i = 0; i < patients.length; i++) {
            await ctx.stub.putState(patients[i].patientId, Buffer.from(JSON.stringify(patients[i])));
            console.info(`Added patient ${patients[i].patientId} to the ledger.`);
        }

        // Add some sample doctor data
        const doctors = [
            {
                doctorId: 'DOC001',
                name: 'Dr. John Smith',
                specialization: 'Cardiology',
                phoneNumber: '555-2468'
            },
            {
                doctorId: 'DOC002',
                name: 'Dr. Jane Doe',
                specialization: 'Pediatrics',
                phoneNumber: '555-1357'
            }
        ];

        for (let i = 0; i < doctors.length; i++) {
            await ctx.stub.putState(doctors[i].doctorId, Buffer.from(JSON.stringify(doctors[i])));
            console.info(`Added doctor ${doctors[i].doctorId} to the ledger.`);
        }
    }

    async addPatient(ctx, patientId, name, age, gender, address, phoneNumber) {
        console.info('Adding a new patient to the ledger...');

        const patient = {
            patientId,
            name,
            age,
            gender,
            address,
            phoneNumber
        };

        await ctx.stub.putState(patientId, Buffer.from(JSON.stringify(patient)));
        console.info(`Added patient ${patientId} to the ledger.`);
    }

    async addDoctor(ctx, doctorId, name, specialization, phoneNumber) {
        console.info('Adding a new doctor to the ledger...');

        const doctor = {
            doctorId,
            name,
            specialization,
            phoneNumber
        };

        await ctx.stub.putState(doctorId, Buffer.from(JSON.stringify(doctor)));
        console.info(`Added doctor ${doctorId} to the ledger.`);
    }

    async viewPatient(ctx, patientId) {
        console.info(`Retrieving patient ${patientId} from the ledger...`);

        const patientBytes = await ctx.stub.getState(patientId);
        if (!patientBytes || patientBytes.length === 0) {
            throw new Error(`Patient ${patientId} does not exist.`);
        }

        const patient = JSON.parse(patientBytes.toString());
        console.log(patient);
        return patient;
    }

    async viewDoctor(ctx, doctorId) {
        console.info(`Retrieving doctor ${doctorId} from the ledger...`);

        const doctorBytes = await ctx.stub.getState(doctorId);
        if (!doctorBytes || doctorBytes.length === 0) {
            throw new Error(`Doctor ${doctorId} does not exist.`);
        }

        const doctor = JSON.parse(doctorBytes.toString());
        console.log(doctor);
        return doctor;
    }
}

module.exports = MedicalContract;