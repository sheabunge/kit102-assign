

### Step 1

	ADDRESS(AddressID, [pk] StreetNumber, StreetName, Suburb, Postcode)
	CLIENT(ClientID, [pk] Name)
	STAFFMEMBER(StaffID, [pk] Name, Sex, Age)
	QUALIFICATION(QualificationName, [pk] Details)
	DIAGNOSIS(DiagnosisCode, [pk] Description)
	PRACTITIONER(PractitionerID, [pk] Name)
	FUNDINGBODY(FunderID, [pk] Details)
	SERVICE(ServiceCode, [pk] Details)
	MOBILITYTEST(TestID, [pk] TestDetails)
	MOBILITYTESTINGFACILITY(FacilityCode, [pk] TestDetails)
	MOBILITYTESTRESULT(TestResultID, [pk])


### Step 2

	MEETS(StaffID [fk1], ClientID [fk2], [pk])
	AFFECTS(DiagnosisCode [fk1], ClientID [fk2], [pk])


### Step 3

	CLIENT(ClientID, [pk] Name, AddressID [fk1], TestID [fk2])
	STAFFMEMBER(StaffID, [pk] Name, Sex, Age, QualificationName [fk1], Manager [fk2])
	DIAGNOSIS(DiagnosisCode, [pk] Description, PractitionerID [fk])
	SERVICE(ServiceCode, [pk] Details, DiagnosisCode [fk1], FunderID [fk2], StaffID [fk3])
	MOBILITYTEST(TestID, [pk] TestDetails, FacilityCode [fk])
	MOBILITYTESTRESULT(TestResultID [pk], FacilityCode [fk])


### Step 4

	ADDRESS(AddressID, [pk] StreetNumber, StreetName, Suburb, Postcode)
	QUALIFICATION(QualificationName, [pk] Details)
	PRACTITIONER(PractitionerID, [pk] Name)
	FUNDINGBODY(FunderID, [pk] Details)
	MOBILITYTESTINGFACILITY(FacilityCode, [pk] TestDetails)

	MOBILITYTEST(TestID, [pk] TestDetails, FacilityCode [fk])
	MOBILITYTESTRESULT(TestResultID [pk], FacilityCode [fk])
	CLIENT(ClientID, [pk] Name, AddressID [fk1], TestID [fk2])
	STAFFMEMBER(StaffID, [pk] Name, Sex, Age, QualificationName [fk1], Manager [fk2])
	DIAGNOSIS(DiagnosisCode, [pk] Description, PractitionerID [fk])
	SERVICE(ServiceCode, [pk] Details, DiagnosisCode [fk1], FunderID [fk2], StaffID [fk3])

	MEETS(StaffID [fk1], ClientID [fk2], [pk])
	AFFECTS(DiagnosisCode [fk1], ClientID [fk2], [pk])

