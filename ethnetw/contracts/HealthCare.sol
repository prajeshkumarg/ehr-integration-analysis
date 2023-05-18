//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthCare {
    uint private lastPatientID = 0;
    uint private lastDoctorID = 0;
    uint private lastTreatmentID = 0;

    struct Patient {  
        uint patID;
        string name;
        uint age;
        string contact;
        string homeAddress;
        string[] diagnosis;
        uint[] doctors;
        mapping(uint => bool) dataAccess; // Mapping to track data access by doctors
    }

    mapping (uint => Patient) private patients;

    function addPatient(string calldata name, uint age, string calldata contact, string calldata homeAddress) public {
        patients[lastPatientID].patID = lastPatientID;
        patients[lastPatientID].name = name;
        patients[lastPatientID].age = age;
        patients[lastPatientID].contact = contact;
        patients[lastPatientID].homeAddress = homeAddress;
        lastPatientID++;
    }

    function getPatient(uint patID, uint docID) public view returns (string memory _name, uint _age, string[] memory _diagnoses) {
        require(patID < lastPatientID, "Invalid patient ID");
        require(docID < lastDoctorID, "Invalid doctor ID");
        require(patients[patID].dataAccess[docID], "Access denied");
        _name = patients[patID].name;
        _age = patients[patID].age;
        _diagnoses = patients[patID].diagnosis;
    }

    function grantDataAccess(uint patID, uint docID) public {
        require(patID < lastPatientID, "Invalid patient ID");
        require(docID < lastDoctorID, "Invalid doctor ID");

        patients[patID].dataAccess[docID] = true;
    }

    function revokeDataAccess(uint patID, uint docID) public {
        require(patID < lastPatientID, "Invalid patient ID");
        require(docID < lastDoctorID, "Invalid doctor ID");

        patients[patID].dataAccess[docID] = false;
    }

    function hasDataAccess(uint patID, uint docID) public view returns (bool) {
        require(patID < lastPatientID, "Invalid patient ID");
        require(docID < lastDoctorID, "Invalid doctor ID");

        return patients[patID].dataAccess[docID];
    }


    struct Doctor {
        uint docID;
        string name;
        string medicalFacility;
        string medicalSpecialty;
    }
    
    mapping(uint => Doctor) private doctors;
    
    function addDoctor(string calldata name, string calldata medicalFacility, string calldata medicalSpecialty) public {
        doctors[lastDoctorID].docID = lastDoctorID;
        doctors[lastDoctorID].name = name;
        doctors[lastDoctorID].medicalFacility = medicalFacility;
        doctors[lastDoctorID].medicalSpecialty = medicalSpecialty;
        lastDoctorID++;
    }
    
    function getDoctorDetails(uint docID) public view returns (Doctor memory) {
        return doctors[docID];
    }

    
    function addDiagnosis(uint patID, uint docID, string calldata diagnosis) public {
        require(patID < lastPatientID, "Invalid patient ID");
        require(docID < lastDoctorID, "Invalid doctor ID");
        require(patients[patID].dataAccess[docID], "Access denied");
        patients[patID].diagnosis.push(diagnosis);
    }
    
    receive() external payable {}
}