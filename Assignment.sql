/**
 * KIT102 Data Modelling Assignment
 * Semester 2, 2018
 * Shea Bunge (407095)
 */

USE sbunge;

-- remove any existing tables before recreating

DROP TABLE IF EXISTS
	AFFECTS, MEETS,
	SERVICE, DIAGNOSIS, STAFFMEMBER, CLIEN, MOBILITYTEST,
	MOBILITYTESTINGFACILITY, FUNDINGBODY, PRACTITIONER, QUALIFICATION, ADDRESS;


-- ADDRESS(AddressID, [pk] StreetNumber, StreetName, Suburb, Postcode)

CREATE TABLE ADDRESS (
	AddressID    INT(11)     NOT NULL AUTO_INCREMENT,
	StreetNumber SMALLINT(5) NOT NULL,
	StreetName   VARCHAR(30) NOT NULL, # check length
	Suburb       VARCHAR(20) NOT NULL, # check length
	Postcode     SMALLINT(4) NOT NULL,

	PRIMARY KEY (AddressID)

) ENGINE = InnoDB;


-- QUALIFICATION(QualificationName, [pk] Details)

CREATE TABLE QUALIFICATION (
	QualificationName VARCHAR(50)  NOT NULL, # check length
	Details           VARCHAR(255) NOT NULL DEFAULT '',

	PRIMARY KEY (QualificationName)

) ENGINE = InnoDB;

-- PRACTITIONER(PractitionerID, [pk] Name)

CREATE TABLE PRACTITIONER (
	PractitionerID INT(11)     NOT NULL AUTO_INCREMENT,
	Name           VARCHAR(70) NOT NULL,

	PRIMARY KEY (PractitionerID)

) ENGINE = InnoDB;


-- FUNDINGBODY(FunderID, [pk] Details)

CREATE TABLE FUNDINGBODY (
	FunderID INT(11)      NOT NULL AUTO_INCREMENT,
	Details  VARCHAR(255) NOT NULL DEFAULT '',

	PRIMARY KEY (FunderID)

) ENGINE = InnoDB;


-- MOBILITYTESTINGFACILITY(FacilityCode, [pk] TestDetails)

CREATE TABLE MOBILITYTESTINGFACILITY (
	FacilityCode INT(11)      NOT NULL,
	TestDetails  VARCHAR(255) NOT NULL,

	PRIMARY KEY (FacilityCode)

) ENGINE = InnoDB;


-- MOBILITYTEST(TestID, [pk] TestDetails, FacilityCode [fk])

CREATE TABLE MOBILITYTEST (
	TestID       INT(11)      NOT NULL AUTO_INCREMENT,
	TestDetails  VARCHAR(255) NOT NULL,
	FacilityCode INT(11)      NOT NULL,

	PRIMARY KEY (TestID),
	FOREIGN KEY (FacilityCode) REFERENCES MOBILITYTESTINGFACILITY (FacilityCode)

) ENGINE = InnoDB;


-- CLIENT(ClientID, [pk] Name, AddressID [fk1], TestID [fk2])

CREATE TABLE CLIENT (
	ClientID  INT(11)     NOT NULL AUTO_INCREMENT,
	Name      VARCHAR(70) NOT NULL,
	AddressID INT(11)     NOT NULL,
	TestID    INT(11)     NOT NULL,

	PRIMARY KEY (ClientID),
	FOREIGN KEY (AddressID) REFERENCES ADDRESS (AddressID),
	FOREIGN KEY (TestID) REFERENCES MOBILITYTEST (TestID)

) ENGINE = InnoDB;


-- STAFFMEMBER(StaffID, [pk] Name, Sex, Age, QualificationName [fk1], Manager [fk2])

CREATE TABLE STAFFMEMBER (
	StaffID           INT(11)                    NOT NULL AUTO_INCREMENT,
	Name              VARCHAR(70)                NOT NULL,
	Sex               ENUM ('NA', 'M', 'F', 'X') NOT NULL, # see: https://en.wikipedia.org/wiki/ISO/IEC_5218
	Age               TINYINT(3)                 NOT NULL,
	QualificationName VARCHAR(50)                NOT NULL, # check length
	Manager           INT(11),

	PRIMARY KEY (StaffID),
	FOREIGN KEY (QualificationName) REFERENCES QUALIFICATION (QualificationName),
	FOREIGN KEY (StaffID) REFERENCES STAFFMEMBER (StaffID)

) ENGINE = InnoDB;


-- DIAGNOSIS(DiagnosisCode, [pk] Description, PractitionerID [fk])

CREATE TABLE DIAGNOSIS (
	DiagnosisCode  INT(11)      NOT NULL,
	Description    VARCHAR(255) NOT NULL DEFAULT '',
	PractitionerID INT(11)      NOT NULL,

	PRIMARY KEY (DiagnosisCode),
	FOREIGN KEY (PractitionerID) REFERENCES PRACTITIONER (PractitionerID)
) ENGINE = InnoDB;


-- SERVICE(ServiceCode, [pk] Details, DiagnosisCode [fk1], FunderID [fk2], StaffID [fk3])

CREATE TABLE SERVICE (
	ServiceCode   INT(11)      NOT NULL,
	Details       VARCHAR(255) NOT NULL DEFAULT '',
	DiagnosisCode INT(11)      NOT NULL,
	FunderID      INT(11)      NOT NULL,
	StaffID       INT(11)      NOT NULL,

	PRIMARY KEY (ServiceCode),
	FOREIGN KEY (DiagnosisCode) REFERENCES DIAGNOSIS (DiagnosisCode),
	FOREIGN KEY (FunderID) REFERENCES FUNDINGBODY (FunderID),
	FOREIGN KEY (StaffID) REFERENCES STAFFMEMBER (StaffID)

) ENGINE = InnoDB;


-- MOBILITYTEST(TestID, [pk] TestDetails, FacilityCode [fk])

CREATE TABLE MOBILITYTEST (
	TestID       INT(11)      NOT NULL AUTO_INCREMENT,
	TestDetails  VARCHAR(255) NOT NULL,
	FacilityCode INT(11)      NOT NULL,

	PRIMARY KEY (TestID),
	FOREIGN KEY (FacilityCode) REFERENCES MOBILITYTESTINGFACILITY (FacilityCode)

) ENGINE = InnoDB;


-- MEETS(StaffID [fk1], ClientID [fk2], [pk])

CREATE TABLE MEETS (
	StaffID  INT(11) NOT NULL,
	ClientID INT(11) NOT NULL,

	PRIMARY KEY (StaffID, ClientID),
	FOREIGN KEY (StaffID) REFERENCES STAFFMEMBER (StaffID),
	FOREIGN KEY (ClientID) REFERENCES CLIENT (ClientID)

) ENGINE = InnoDB;


-- AFFECTS(DiagnosisCode [fk1], ClientID [fk2], [pk])

CREATE TABLE AFFECTS (
	DiagnosisCode INT(11) NOT NULL,
	ClientID      INT(11) NOT NULL,

	PRIMARY KEY (DiagnosisCode, ClientID),
	FOREIGN KEY (DiagnosisCode) REFERENCES DIAGNOSIS (DiagnosisCode),
	FOREIGN KEY (ClientID) REFERENCES CLIENT (ClientID)

) ENGINE=InnoDB;


-- insert data into tables

INSERT INTO ADDRESS (AddressID, StreetNumber, StreetName, Suburb, Postcode) VALUES
	(1, 5, 'Sandy Bay Road', 'Hobart', 7001),
	(2, 262, 'Invermay Rd', 'Mowbray', 7248);



