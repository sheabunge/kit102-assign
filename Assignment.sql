/**
 * KIT102 Data Modelling Assignment
 * Semester 2, 2018
 * Shea Bunge (407095)
 */

USE sbunge;

-- remove any existing tables before recreating

DROP TABLE IF EXISTS
	AFFECTS, MEETS,
	SERVICE, DIAGNOSIS, STAFFMEMBER, CLIENT, MOBILITYTESTRESULT, MOBILITYTEST,
	MOBILITYTESTINGFACILITY, FUNDINGBODY, PRACTITIONER, QUALIFICATION, ADDRESS;


-- ADDRESS(AddressID, [pk] StreetNumber, StreetName, Suburb, Postcode)

CREATE TABLE ADDRESS (
	AddressID    INT(11)     NOT NULL AUTO_INCREMENT,
	StreetNumber SMALLINT(5) NOT NULL,
	StreetName   VARCHAR(30) NOT NULL,
	Suburb       VARCHAR(20) NOT NULL,
	Postcode     SMALLINT(4) NOT NULL,

	PRIMARY KEY (AddressID)
) ENGINE = InnoDB;


-- QUALIFICATION(QualificationName, [pk] Details)

CREATE TABLE QUALIFICATION (
	QualificationName VARCHAR(50)  NOT NULL,
	Details           VARCHAR(255) NOT NULL,

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
	Details  VARCHAR(255) NOT NULL,

	PRIMARY KEY (FunderID)
) ENGINE = InnoDB;


-- MOBILITYTESTINGFACILITY(FacilityCode, [pk] Details)

CREATE TABLE MOBILITYTESTINGFACILITY (
	FacilityCode INT(11)      NOT NULL,
	Details      VARCHAR(255) NOT NULL,

	PRIMARY KEY (FacilityCode)
) ENGINE = InnoDB;


-- MOBILITYTEST(TestID, [pk] Details, FacilityCode [fk])

CREATE TABLE MOBILITYTEST (
	TestID       INT(11)      NOT NULL AUTO_INCREMENT,
	Details      VARCHAR(255) NOT NULL,
	FacilityCode INT(11)      NOT NULL,

	PRIMARY KEY (TestID),
	FOREIGN KEY (FacilityCode) REFERENCES MOBILITYTESTINGFACILITY (FacilityCode)
) ENGINE = InnoDB;


-- MOBILITYTESTRESULT(TestResultID [pk], Details, FacilityCode [fk])

CREATE TABLE MOBILITYTESTRESULT (
	TestResultID INT(11)      NOT NULL AUTO_INCREMENT,
	Details      VARCHAR(255) NOT NULL,
	FacilityCode INT(11)      NOT NULL,

	PRIMARY KEY (TestResultID),
	FOREIGN KEY (FacilityCode) REFERENCES MOBILITYTESTINGFACILITY (FacilityCode)
) ENGINE = InnoDB;


-- CLIENT(ClientID, [pk] Name, AddressID [fk1], TestID [fk2])

CREATE TABLE CLIENT (
	ClientID  INT(11)     NOT NULL AUTO_INCREMENT,
	Name      VARCHAR(70) NOT NULL,
	AddressID INT(11)     NOT NULL,
	TestID    INT(11)     NULL,
	# TestID can be set to NULL if the client has not requested a mobility test

	PRIMARY KEY (ClientID),
	FOREIGN KEY (AddressID) REFERENCES ADDRESS (AddressID),
	FOREIGN KEY (TestID) REFERENCES MOBILITYTEST (TestID)
) ENGINE = InnoDB;


-- STAFFMEMBER(StaffID, [pk] Name, Sex, Age, QualificationName [fk1], Manager [fk2])

CREATE TABLE STAFFMEMBER (
	StaffIDEmployee   INT(11)                   NOT NULL AUTO_INCREMENT,
	Name              VARCHAR(70)               NOT NULL,
	Sex               ENUM('NA', 'M', 'F', 'X') NOT NULL,
	# Sex uses the international standard ISO/IEC 5218 (see https://en.wikipedia.org/wiki/ISO/IEC_5218)
	Age               TINYINT(3)                NOT NULL,
	QualificationName VARCHAR(50)               NOT NULL,
	StaffIDManager    INT(11)                   NULL,
	# if an employee has no manager, then StaffIDManager can either be set to NULL or set to the same value as StaffIDEmployee

	PRIMARY KEY (StaffIDEmployee),
	FOREIGN KEY (QualificationName) REFERENCES QUALIFICATION (QualificationName),
	FOREIGN KEY (StaffIDManager) REFERENCES STAFFMEMBER (StaffIDEmployee)
) ENGINE = InnoDB;


-- DIAGNOSIS(DiagnosisCode, [pk] Description, PractitionerID [fk])

CREATE TABLE DIAGNOSIS (
	DiagnosisCode  INT(11)      NOT NULL,
	Description    VARCHAR(255) NOT NULL,
	PractitionerID INT(11)      NOT NULL,

	PRIMARY KEY (DiagnosisCode),
	FOREIGN KEY (PractitionerID) REFERENCES PRACTITIONER (PractitionerID)
) ENGINE = InnoDB;


-- SERVICE(ServiceCode, [pk] Details, DiagnosisCode [fk1], FunderID [fk2], StaffID [fk3])

CREATE TABLE SERVICE (
	ServiceCode   INT(11)      NOT NULL,
	Details       VARCHAR(255) NOT NULL,
	DiagnosisCode INT(11)      NOT NULL,
	FunderID      INT(11)      NOT NULL,
	StaffID       INT(11)      NOT NULL,

	PRIMARY KEY (ServiceCode),
	FOREIGN KEY (DiagnosisCode) REFERENCES DIAGNOSIS (DiagnosisCode),
	FOREIGN KEY (FunderID) REFERENCES FUNDINGBODY (FunderID),
	FOREIGN KEY (StaffID) REFERENCES STAFFMEMBER (StaffIDEmployee)
) ENGINE = InnoDB;


-- MEETS(StaffID [fk1], ClientID [fk2], [pk])

CREATE TABLE MEETS (
	StaffID  INT(11) NOT NULL,
	ClientID INT(11) NOT NULL,

	PRIMARY KEY (StaffID, ClientID),
	FOREIGN KEY (StaffID) REFERENCES STAFFMEMBER (StaffIDEmployee),
	FOREIGN KEY (ClientID) REFERENCES CLIENT (ClientID)
) ENGINE = InnoDB;


-- AFFECTS(DiagnosisCode [fk1], ClientID [fk2], [pk])

CREATE TABLE AFFECTS (
	DiagnosisCode INT(11) NOT NULL,
	ClientID      INT(11) NOT NULL,

	PRIMARY KEY (DiagnosisCode, ClientID),
	FOREIGN KEY (DiagnosisCode) REFERENCES DIAGNOSIS (DiagnosisCode),
	FOREIGN KEY (ClientID) REFERENCES CLIENT (ClientID)
) ENGINE = InnoDB;


-- insert data into tables

INSERT INTO MOBILITYTESTINGFACILITY
	(FacilityCode, Details) VALUES
	(171233, 'Department of Health and Human Services: Disability Assessment and Advisory Team'),
	(278445, 'Allied Health Therapy Services');

INSERT INTO MOBILITYTEST
	(TestID, Details, FacilityCode) VALUES
	(1, 'Hip and ankle mobility tests', 171233),
	(2, 'Thoracic mobility test', 278445);

INSERT INTO MOBILITYTESTRESULT
	(TestResultID, Details, FacilityCode) VALUES
	(1, 'Test 1: Lacking hip mobility', 171233),
	(2, 'Test 2: Passed', 278445);
	# as there is no relational way to connect results to tests, the test identifier is included in the test result details

INSERT INTO ADDRESS
	(AddressID, StreetNumber, StreetName, Suburb, Postcode) VALUES
	(1, 5, 'Sandy Bay Road', 'Hobart', 7001),
	(2, 262, 'Invermay Rd', 'Mowbray', 7248);

INSERT INTO CLIENT
	(ClientID, Name, AddressID, TestID) VALUES
	(1, 'William Traynor', 1, 2),
	(2, 'Margaret Carter', 2, 1);

INSERT INTO QUALIFICATION
	(QualificationName, Details) VALUES
	('Business Manager', 'Manages administrative details about the business.'),
	('Gardener', 'Provides garden care services'),
	('Domestic Cleaner', 'Provides domestic cleaning services'),
	('Personal Carer', 'Provides personal care services');

INSERT INTO PRACTITIONER
	(PractitionerID, Name) VALUES
	(1, 'Dr. Nicholas Riviera'),
	(2, 'Dr. Stephen Strange');

INSERT INTO DIAGNOSIS
	(DiagnosisCode, Description, PractitionerID) VALUES
	(72382, 'Arthritis', 1),
	(46090, 'Dementia', 1),
	(15906, 'Tetraplegia', 2);

INSERT INTO FUNDINGBODY
	(FunderID, Details) VALUES
	(1, 'Department of Veterans\' Affairs'),
	(2, 'Carers Tasmania');

INSERT INTO STAFFMEMBER
	(StaffIDEmployee, Name, Sex, Age, QualificationName, StaffIDManager) VALUES
	(1, 'Jane Thomas', 'F', 43, 'Business Manager', 1),
	(2, 'Samwise Gamgee', 'M', 39, 'Gardener', 1),
	(3, 'Louisa Clark', 'F', 35, 'Domestic Cleaner', 1),
	(4, 'Ami Driss', 'M', 33, 'Personal Carer', 3);

INSERT INTO SERVICE
	(ServiceCode, Details, DiagnosisCode, FunderID, StaffID) VALUES
	(47879, 'Personal care', 15906, 2, 4),
	(70596, 'Gardening', 72382, 1, 2),
	(29481, 'Domestic cleaning', 46090, 2, 3);

INSERT INTO MEETS
	(StaffID, ClientID) VALUES
	(3, 1),
	(4, 1),
	(1, 2),
	(2, 2);

INSERT INTO AFFECTS
	(DiagnosisCode, ClientID) VALUES
	(15906, 1),
	(72382, 2);
