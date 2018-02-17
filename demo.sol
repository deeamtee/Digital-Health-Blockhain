pragma solidity ^0.4.17;

contract MedDB {
  address public owner;
  mapping(string => Patient) patients;
  mapping(string => bool) patientExists;

  struct Appointment {
    string symptoms;
    string diagnosis;
  }

  struct Patient {
    string name;
    string surname;
    string patronymic;
    uint8 age;
    uint appointCount;
    string[] dates;
    mapping(string => Appointment) appointments;
  }

  function MedDB() public {
    owner = msg.sender;
  }

  function getPatientInfo(string patientNumber) public view returns (string, string, string, uint8) {
    require(patientExists[patientNumber]);
    Patient storage p = patients[patientNumber];
    return (p.name, p.surname, p.patronymic, p.age);
  }

  function getAppointmentInfo(string patientNumber, string date) public view returns (string, string) {
    require(patientExists[patientNumber]);
    Patient storage p = patients[patientNumber];
    Appointment storage a = p.appointments[date];
    return (a.symptoms, a.diagnosis);
  }

  function getAppointmentsCount(string patientNumber) public view returns (uint256)
 {
    require(patientExists[patientNumber]);
    return patients[patientNumber].appointCount;
  }

  function getAppointment(string patientNumber, uint index) public view returns (string, string, string) {
    require(patientExists[patientNumber]);
    Patient storage p = patients[patientNumber];
    require(index < p.appointCount);
    string storage d = p.dates[index];
    return (d, p.appointments[d].symptoms, p.appointments[d].diagnosis);
  }

  function newPatient(string patientNumber, string name, string surname, string patronymic, uint8 age)public {
    require(!patientExists[patientNumber]);
    string[] memory newDates;
    patients[patientNumber] = Patient(name, surname, patronymic, age, 0, newDates);
    patientExists[patientNumber] = true;
  }

  function newAppointment(string patientNumber, string date, string symptoms, string diagnosis) public {
    require(patientExists[patientNumber]);
    patients[patientNumber].appointments[date] = Appointment(symptoms, diagnosis);
    patients[patientNumber].dates.push(date);
    patients[patientNumber].appointCount++;
  }
}
