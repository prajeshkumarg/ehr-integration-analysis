pragma solidity ^0.8.0;

//Permissions are given to doctors to access the records of their patients.

contract ElectronicHealthRecord {

  mapping (address => string[]) public documents;
  function addDocument(string memory documentHash) public returns (uint) {
    address from = msg.sender;
    documents[from].push(documentHash);
    return documents[from].length - 1;
  }

  function getDocuments(address user) public view returns (string[] memory) {
    return documents[user];
  }

  mapping (address => address[]) public doctorsPermissions;

  function giveAccessToDoctor(address doctor) public {
    doctorsPermissions[doctor].push(msg.sender);
  }

  function revokeAccessFromDoctor(address doctor, uint index) public {
    require(doctorsPermissions[doctor][index] == msg.sender, 'You can only revoke access to your own documents.');
    delete doctorsPermissions[doctor][index];
  }

  function getDoctorsPermissions(address doctor) public view returns (address[] memory) {
    return doctorsPermissions[doctor];
  }
}