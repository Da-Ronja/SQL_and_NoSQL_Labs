CREATE TABLE IF NOT EXISTS Technician (
    EmployeeId INT PRIMARY KEY,
    FirstName CHAR(50),
    LastName CHAR(50),
    EmailAddress CHAR(100),
    AnnualSalary INT,
    SpecialSkill CHAR(100),
    EmployeeStatusId INT
);

CREATE TABLE IF NOT EXISTS EmployeeStatus (
    EmployeeStatusId INT PRIMARY KEY,
    StatusDescription CHAR(100)
);

CREATE TABLE IF NOT EXISTS ServiceActivity (
    ServiceActivityId INT PRIMARY KEY,
    EmployeeId INT,
    ElevatorId INT,
    ServiceDateTime DATE,
    ServiceDescription CHAR(255),
    ServiceStatusId INT
);

CREATE TABLE IF NOT EXISTS ServiceStatus (
    ServiceStatusId INT PRIMARY KEY,
    StatusDescription CHAR(100)
);

CREATE TABLE IF NOT EXISTS Building (
    BuildingId INT PRIMARY KEY,
    CityId INT,
    Floors INT
);

CREATE TABLE IF NOT EXISTS City (
    CityId INT PRIMARY KEY,
    CityName CHAR(100)
);

CREATE TABLE IF NOT EXISTS Elevator (
    ElevatorId INT PRIMARY KEY,
    ElevatorModelId INT,
    BuildingId INT,
    InstallationDate DATE
);

CREATE TABLE IF NOT EXISTS ElevatorModel (
    ElevatorModelId INT PRIMARY KEY,
    ModelName CHAR(100),
    Speed INT,
    MaxWeight INT,
    PeopleLimit INT,
    ElevatorTypeId INT
);

CREATE TABLE IF NOT EXISTS ElevatorType (
    ElevatorTypeId INT PRIMARY KEY,
    TypeName CHAR(100)
);

-- Adding foreign keys to Technician
ALTER TABLE Technician
ADD FOREIGN KEY (EmployeeStatusId)
REFERENCES EmployeeStatus(EmployeeStatusId);

-- Adding foreign keys to ServiceActivity
ALTER TABLE ServiceActivity
ADD FOREIGN KEY (EmployeeId)
REFERENCES Technician(EmployeeId);

ALTER TABLE ServiceActivity
ADD FOREIGN KEY (ElevatorId)
REFERENCES Elevator(ElevatorId);

ALTER TABLE ServiceActivity
ADD FOREIGN KEY (ServiceStatusId)
REFERENCES ServiceStatus(ServiceStatusId);

-- Adding foreign keys to Building
ALTER TABLE Building
ADD FOREIGN KEY (CityId)
REFERENCES City(CityId);

-- Adding foreign keys to Elevator
ALTER TABLE Elevator
ADD FOREIGN KEY (ElevatorModelId)
REFERENCES ElevatorModel(ElevatorModelId);

ALTER TABLE Elevator
ADD FOREIGN KEY (BuildingId)
REFERENCES Building(BuildingId);

-- Adding foreign key to ElevatorModel
ALTER TABLE ElevatorModel
ADD FOREIGN KEY (ElevatorTypeId)
REFERENCES ElevatorType(ElevatorTypeId);


INSERT INTO City (CityId, CityName)
VALUES 
(1, 'Stockholm'),
(2, 'Malmö'),
(3, 'Uppsala');

INSERT INTO ElevatorType (ElevatorTypeId, TypeName)
VALUES 
(1, 'Hydraulic elevator'),
(2, 'Passenger elevator'),
(3, 'Service elevator');

INSERT INTO EmployeeStatus (EmployeeStatusId, StatusDescription)
VALUES 
(1, 'Active'),
(2, 'On leave');

INSERT INTO ServiceStatus (ServiceStatusId, StatusDescription)
VALUES 
(1, 'Completed'),
(2, 'On going'),
(3, "Pending");

INSERT INTO Building (BuildingId, CityId, Floors)
VALUES 
(1, 1, 20),  -- Stockholm, 20 floors
(2, 2, 15),  -- Malmö, 15 floors
(3, 3, 25);  -- Uppsala, 25 floors

INSERT INTO ElevatorModel (ElevatorModelId, ModelName, Speed, MaxWeight, PeopleLimit, ElevatorTypeId)
VALUES 
(1, 'Model A', 2, 1000, 10, 1),  -- Hydraulic elevator
(2, 'Model B', 2, 800, 5, 2),   -- Passenger elevator
(3, 'Model C', 1, 5000, 20, 3);   -- Service elevator

 
INSERT INTO Elevator (ElevatorId, ElevatorModelId, BuildingId, InstallationDate)
VALUES 
(1, 1, 1, '2019-01-01'),  -- Hydraulic elevator in Stockholm building
(2, 2, 2, '2020-10-15'),  -- Passenger elevator in Malmö building
(3, 3, 3, '2021-01-20');  -- Service elevator in Uppsala building

INSERT INTO Technician (EmployeeId, FirstName, LastName, EmailAddress, AnnualSalary, SpecialSkill, EmployeeStatusId)
VALUES 
(1, 'John', 'Doe', 'john.doe@example.com', 50000, 'Electrical', 1),  -- Active
(2, 'Jane', 'Smith', 'jane.smith@example.com', 55000, 'Mechanical', 1),  -- Active
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', 60000, 'Lift systems', 2);  -- On Leave

INSERT INTO ServiceActivity (ServiceActivityId, EmployeeId, ElevatorId, ServiceDateTime, ServiceDescription, ServiceStatusId)
VALUES 
(1, 1, 1, '2024-10-10', 'Regular maintenance', 1),  -- John Doe serviced elevator 1
(2, 2, 2, '2024-10-15', 'Emergency repair', 2),     -- Jane Smith serviced elevator 2
(3, 3, 3, '2025-01-13', 'Scheduled inspection', 3); -- John Doe serviced elevator 3


SELECT SA.ServiceDateTime,  SA.ServiceDescription, SS.StatusDescription, C.CityName, B.Floors, EM.ModelName, EM.Speed, EM.MaxWeight, EM.PeopleLimit, ET.TypeName,
E.InstallationDate, T.FirstName, T.LastName, T.EmailAddress, T.AnnualSalary, T.SpecialSkill, ES.StatusDescription
FROM ServiceActivity as SA
JOIN ServiceStatus as SS
  ON SA.ServiceStatusId = SS.ServiceStatusId
JOIN elevator as E
  ON SA.ElevatorId = E.ElevatorId 
JOIN ElevatorModel as EM
  ON E.ElevatorModelId = EM.ElevatorModelId
JOIN ElevatorType as ET
  ON EM.ElevatorTypeId = ET.ElevatorTypeId
JOIN Building as B
  ON E.BuildingId = B.BuildingId 
JOIN City as C
  ON B.CityId = C.CityId
JOIN Technician as T
  ON SA.EmployeeId = T.EmployeeId
JOIN EmployeeStatus as ES
  ON T.EmployeeStatusId = ES.EmployeeStatusId
