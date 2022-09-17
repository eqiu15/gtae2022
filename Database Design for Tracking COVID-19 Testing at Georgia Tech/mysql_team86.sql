-- CS4400: Introduction to Database Systems -- 
-- Fall 2020 -- 
-- Phase II Create Table and Insert Statements Template -- 

-- Team 86 -- 
-- Team Longan Loi (lloi3) -- 
-- Team Timothy Bang (tbang6) -- 
-- Team Eric Qiu(eqiu7) -- 
-- Team Maxine Lee (mlee624) -- 

drop database if exists COVID_TESTING;
create database if not exists COVID_TESTING;
use COVID_TESTING;

DROP TABLE IF EXISTS user;
create table user (
	Username varchar(20), 
	Password varchar(20),
	Email varchar(30),
	FirstName varchar(20),
	LastName varchar(20),
	PRIMARY KEY (Username)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS location;
create table location (
	Name varchar (4),
	PRIMARY KEY (Name)
) ENGINE = InnoDB;

DROP TABLE IF EXISTS student;
create table student (
    Username varchar(20), 
	HousingType varchar(30),
	LivesIn varchar(10),
	PRIMARY KEY (Username),
	CONSTRAINT student_user FOREIGN KEY (Username) REFERENCES user (Username),
	CONSTRAINT student_location FOREIGN KEY (LivesIn) REFERENCES location (Name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS employee;
create table employee (
	Username varchar(20), 
	PhoneNumber bigint,
	isSiteTester bool,
	isLabTechnician bool,
	PRIMARY KEY (Username),
	CONSTRAINT employee_user FOREIGN KEY (Username) REFERENCES user (Username)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS admin;
create table admin (
	Username varchar(20), 
	PRIMARY KEY (Username),
	CONSTRAINT admin_user FOREIGN KEY (Username) REFERENCES user (Username)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS pool;
create table pool(
	ID int,
	Status varchar(10),
    ProcessDate date,
    ProcessBy varchar(20),
	PRIMARY KEY(ID),
    CONSTRAINT process_by FOREIGN KEY(ProcessBy) REFERENCES employee(Username)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS site;
create table site (
	Name varchar (50),
	Street varchar (50),
	City varchar (20),
	State varchar (10),
    Zip int,
	SiteIn varchar (4),
	PRIMARY KEY (Name),
	CONSTRAINT site_location FOREIGN KEY (SiteIn) REFERENCES location (Name)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS appointment;
create table appointment (
	Date date ,
	Time time,
	SiteName varchar(50),
	Scheduler varchar(20),
	PRIMARY KEY (Date, Time, SiteName),
	CONSTRAINT appointment_site FOREIGN KEY (SiteName) REFERENCES site (Name),
	CONSTRAINT appointment_scheduler FOREIGN KEY (Scheduler) REFERENCES student (Username)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS process;
create table process (
	Technician varchar (20),
	Pool int,
	Date date,
	PRIMARY KEY (Technician, Pool),
	CONSTRAINT TechnicianID FOREIGN KEY (Technician) REFERENCES employee (Username),
	CONSTRAINT PoolID FOREIGN KEY (Pool) REFERENCES pool (ID)
) ENGINE=InnoDB;



DROP TABLE IF EXISTS test;
create table test (
	ID int,
	Status varchar(20),
	Pool_ID int,
	ApptDate date,
	ApptTime time,
	PRIMARY KEY (ID),
	CONSTRAINT contains FOREIGN KEY (Pool_ID) REFERENCES pool (ID),
	CONSTRAINT appointment_date FOREIGN KEY (ApptDate, ApptTime) REFERENCES appointment (Date, Time)
) ENGINE=InnoDB;



DROP TABLE IF EXISTS works_in;
create table works_in (
	SiteName varchar(50),
	SiteTesterID varchar(20),
	PRIMARY KEY (SiteName, SiteTesterID),
	CONSTRAINT site_locate FOREIGN KEY (SiteName) REFERENCES Site (Name),
	CONSTRAINT site_tester FOREIGN KEY (SiteTesterID) REFERENCES Employee (Username)
) ENGINE=InnoDB;

#users
insert into user values 
('jlionel666','password1', 'jlionel666@gatech.edu', 'John', 'Lionel'), 
('mmoss7', 'password2', 'mmoss7@gatech.edu','Mark', 'Moss'), 
('lchen27', 'password3', 'lchen27@gatech.edu', 'Liang', 'Chen'),

('jhilborn97', 'password4', 'jhilborn97@gatech.edu', 'Jack', 'Hilborn'),
('jhilborn98', 'password5', 'jhilborn98@gatech.edu', 'Jake', 'Hilborn'),
('ygao10', 'password6', 'ygao10@gatech.edu', 'Yuan', 'Gao'),
('jthomas520',	'password7', 'jthomas520@gatech.edu', 'James', 'Thomas'),
('cforte58', 'password8', 'cforte58@gatech.edu', 'Connor', 'Forte'),
('fdavenport49', 'password9', 'fdavenport49@gatech.edu', 'Felicia', 'Devenport'),
('hliu88', 'password10', 'hliu88@gatech.edu','Hang', 'Liu'),
('akarev16', 'password11', 'akarev16@gatech.edu',	'Alex',	'Karev'),
('jdoe381', 'password12', 'jdoe381@gatech.edu', 'Jane', 'Doe'),
('sstrange11', 'password13', 'sstrange11@gatech.edu', 'Stephen', 'Strange'),
('dmcstuffins7', 'password14', 'dmcstuffins7@gatech.edu', 'Doc', 'Mcstuffins'),
('mgrey91', 'password15', 'mgrey91@gatech.edu', 'Meredith', 'Grey'),
('pwallace51',	'password16', 'pwallace51@gatech.edu', 'Penny', 'Wallace'),
('jrosario34', 'password17', 'jrosario34@gatech.edu', 'Jon', 'Rosario'),
('nshea230', 'password18', 'nshea230@gatech.edu', 'Nicholas', 'Shea'),

('mgeller3', 'password19', 'mgeller3@gatech.edu', 'Monica', 'Geller'),
('rgeller9', 'password20', 'rgeller9@gatech.edu', 'Ross', 'Geller'),
('jtribbiani27', 'password21', 'jtribbiani27@gatech.edu', 'Joey', 'Tribbiani'),
('pbuffay56', 'password22', 'pbuffay56@gatech.edu', 'Phoebe', 'Buffay'),
('rgreen97', 'password23', 'rgreen97@gatech.edu', 'Rachel', 'Green'),
('cbing101', 'password24', 'cbing101@gatech.edu', 'Chandler', 'Bing'),
('pbeesly61', 'password25', 'pbeesly61@gatech.edu', 'Pamela', 'Beesly'),
('jhalpert75', 'password26', 'jhalpert75@gatech.edu', 'Jim', 'Halpert'),
('dschrute18', 'password27', 'dschrute18@gatech.edu', 'Dwight', 'Schrute'),
('amartin365', 'password28', 'amartin365@gatech.edu', 'Angela', 'Martin'),
('omartinez13', 'password29', 'omartinez13@gatech.edu', 'Oscar', 'Martinez'),
('mscott845', 'password30', 'mscott845@gatech.edu', 'Michael', 'Scott'),
('abernard224', 'password31', 'abernard224@gatech.edu', 'Andy', 	'Bernard'),
('kkapoor155', 'password32',	'kkapoor155@gatech.edu',' Kelly', 'Kapoor'),
('dphilbin81', 'password33', 'dphilbin81@gatech.edu', 'Darryl', 'Philbin'),
('sthefirst1', 'password34', 'sthefirst1@gatech.edu',	'Sofia',	'Thefirst'),
('gburdell1', 'password35', 'gburdell1@gatech.edu',	'George', 'Burdell'),
('dsmith102', 'password36', 'dsmith102@gatech.edu', 'Dani', 'Smith'),
('dbrown85', 'password37', 'dbrown85@gatech.edu', 'David', 'Brown'),
('dkim99', 'password38', 'dkim99@gatech.edu', 'Dave', 'Kim'),
('tlee984', 'password39', 'tlee984@gatech.edu', 'Tom', 'Lee'),
('jpark29', 'password40', 'jpark29@gatech.edu', 'Jerry', 'Park'),
('vneal101', 'password41', 'vneal101@gatech.edu', 'Vinay', 'Neal'),
('hpeterson55', 'password42', 'hpeterson55@gatech.edu', 'Haydn', 'Peterson'),
('lpiper20', 'password43', 'lpiper20@gatech.edu', 'Leroy', 'Piper'),
('mbob2', 'password44', 'mbob2@gatech.edu', 'Mary', 'Bob'),
('mrees785', 'password45', 'mrees785@gatech.edu', 'Marie', 'Rees'),
('wbryant23', 'password46', 'wbryant23@gatech.edu', 'William', 'Bryant'),
('aallman302', 'password47', 'aallman302@gatech.edu', 'Aiysha', 'Allman'),
('kweston85', 'password48', 'kweston85@gatech.edu', 'Kyle', 'Weston');

#location
insert into location values ('East'), ('West');


#admin
insert into admin values ('jlionel666'), ('mmoss7'), ('lchen27');

#employee
insert into employee values ('jhilborn97', 4043802577, false, true),
('jhilborn98', 4042201897, false, true),
('ygao10', 7703928765, false, true),
('jthomas520', 7705678943, false, true),
('cforte58', 4708623384, false, true),
('fdavenport49', 7068201473, false, true),
('hliu88', 4782809765,false, true),
('akarev16', 9876543210, true, false),
('jdoe381', 1237864230, true, false),
('sstrange11', 6547891234, true, false),
('dmcstuffins7', 1236549878, true, false),
('mgrey91', 6458769523, true, false),
('pwallace51', 3788612907, true, false),
('jrosario34', 5926384247, true, false),
('nshea230', 6979064501, true, false);

#student
insert into student values ('mgeller3', 'Off-campus Apartment', 'East'),
('rgeller9', 'Student Housing', 'East'),
('jtribbiani27', 'Greek Housing', 'West'),
('pbuffay56', 'Student Housing', 'East'),
('rgreen97', 'Student Housing', 'West'),
('cbing101', 'Greek Housing', 'East'),
('pbeesly61', 'Student Housing', 'West'),
('jhalpert75', 'Student Housing', 'East'),
('dschrute18', 'Student Housing', 'East'),
('amartin365', 'Greek Housing', 'East'),
('omartinez13', 'Student Housing', 'West'),
('mscott845', 'Student Housing', 'East'),
('abernard224', 'Greek Housing', 'West'),
('kkapoor155', 'Greek Housing', 'East'),
('dphilbin81', 'Greek Housing'	, 'West'),
('sthefirst1', 'Student Housing', 'West'),
('gburdell1', 'Student Housing', 'East'),
('dsmith102', 'Greek Housing', 'West'),
('dbrown85', 'Off-campus Apartment', 'East'),
('dkim99', 'Greek Housing', 'East'),
('tlee984', 'Student Housing', 'West'),
('jpark29', 'Student Housing', 'East'),
('vneal101', 'Student Housing', 'West'),
('hpeterson55', 'Greek Housing', 'East'),
('lpiper20', 'Student Housing', 'West'),
('mbob2', 'Student Housing', 'West'),
('mrees785', 'Off-campus House', 'West'),
('wbryant23', 'Greek Housing', 'East'),
('aallman302', 'Student Housing', 'West'),
('kweston85', 'Greek Housing', 'West');

#sites
Insert into site values
('Fulton County Board of Health', '10 Park Place South SE' , 'Atlanta',  'GA', 30303, 'East'),
('Bobby Dodd Stadium', '150 Bobby Dodd Way NW', 'Atlanta', 'GA', 30332, 'East'),
('Caddell Building', '280 Ferst Drive NW', 'Atlanta', 'GA', 30332, 'West'),
('CCBOH WIC Clinic', '1895 Phoenix Blvd', 'College Park', 'GA', 30339, 'West'),
('Kennesaw State University', '3305 Busbee Drive NW', 'Kennesaw', 'GA', 30144, 'West'),
('Stamps Health Services', '740 Ferst Drive', 'Atlanta', 'GA', 30332, 'West'),
('Coda Building', '760 Spring Street', 'Atlanta', 'GA', 30332, 'East'),
('GT Catholic Center', '172 4th St NW', 'Atlanta', 'GA', 30313, 'East'),
('West Village', '532 8th St NW', 'Atlanta', 'GA', 30318, 'West'),
('GT Connector', '116 Bobby Dodd Way NW', 'Atlanta', 'GA', 30313, 'East'),
('Curran St Parking Deck', '564 8th St NW', 'Atlanta', 'GA', 30318, 'West'),
('North Avenue (Centenial Room)', '120 North Avenue NW', 'Atlanta', 'GA', 30313, 'East');

#pools
INSERT INTO pool VALUES 
(1,'negative', '2020-09-02', 'jhilborn97'), 
(2,'positive', '2020-09-04', 'jhilborn98'), 
(3,'positive', '2020-09-06', 'ygao10'), 
(4,'positive', '2020-09-05', 'jthomas520'), 
(5,'negative', '2020-09-07', 'fdavenport49'), 
(6,'positive', '2020-09-05', 'hliu88'), 
(7,'negative', '2020-09-11', 'cforte58'), 
(8,'positive', '2020-09-11', 'ygao10'), 
(9,'pending', NULL, NULL), 
(10,'pending', NULL, NULL), 
(11,'pending', NULL, NULL), 
(12,'pending', NULL, NULL), 
(13,'pending', NULL, NULL);

#appointments
Insert into appointment values('2020-09-01', '08:00:00', 'Fulton County Board of Health', 'mgeller3'),
('2020-09-01', '09:00:00', 'Bobby Dodd Stadium', 'rgeller9'),
('2020-09-01', '10:00:00', 'Caddell Building', 'jtribbiani27'),
('2020-09-01', '11:00:00', 'GT Catholic Center', 'pbuffay56'),
('2020-09-01', '12:00:00', 'West Village', 'rgreen97'),
('2020-09-01', '13:00:00', 'GT Catholic Center', 'cbing101'),
('2020-09-01', '14:00:00', 'West Village', 'pbeesly61'),
('2020-09-01', '15:00:00', 'North Avenue (Centenial Room)', 'jhalpert75'),
('2020-09-01', '16:00:00', 'North Avenue (Centenial Room)', 'dschrute18'),
('2020-09-03', '08:00:00', 'Curran St Parking Deck','omartinez13'),
('2020-09-03', '09:00:00', 'Bobby Dodd Stadium' , 'mscott845'),
('2020-09-03', '10:00:00', 'Stamps Health Services', 'abernard224'),
('2020-09-03', '11:00:00', 'GT Catholic Center', 'kkapoor155'),
('2020-09-03',	'12:00:00', 'West Village', 'dphilbin81'),
('2020-09-03', '13:00:00', 'Caddell Building', 'sthefirst1'),
('2020-09-03', '14:00:00', 'Coda Building', 'gburdell1'),
('2020-09-03', '15:00:00', 'Stamps Health Services', 'dsmith102'),
('2020-09-03', '16:00:00', 'CCBOH WIC Clinic', 'dbrown85'),
('2020-09-03', '17:00:00', 'GT Connector', 'dkim99'),
('2020-09-04', '08:00:00', 'Curran St Parking Deck', 'tlee984'),
('2020-09-04', '09:00:00', 'GT Connector', 'jpark29'),
('2020-09-04', '10:00:00', 'Curran St Parking Deck', 'vneal101'),
('2020-09-04', '11:00:00', 'Bobby Dodd Stadium', 'hpeterson55'),
('2020-09-04', '12:00:00', 'Caddell Building', 'lpiper20'),
('2020-09-04', '13:00:00', 'Stamps Health Services', 'mbob2'),
('2020-09-04', '14:00:00', 'Kennesaw State University', 'mrees785'),
('2020-09-04', '15:00:00', 'GT Catholic Center', 'wbryant23'),
('2020-09-04', '16:00:00', 'West Village', 'aallman302'),
('2020-09-04', '17:00:00', 'West Village', 'kweston85'),
('2020-09-04', '08:00:00','Fulton County Board of Health', 'mgeller3'),
('2020-09-04', '09:00:00', 'Bobby Dodd Stadium', 'rgeller9'),
('2020-09-04', '10:00:00', 'Caddell Building', 'jtribbiani27'),
('2020-09-10', '11:00:00', 'Bobby Dodd Stadium', 'pbuffay56'),
('2020-09-10',	'12:00:00', 'Caddell Building', 'rgreen97'),
('2020-09-10',	'13:00:00', 'GT Catholic Center', 'cbing101'),
('2020-09-10',	'14:00:00', 'West Village', 'pbeesly61'),
('2020-09-10',	'15:00:00', 'Coda Building', 'jhalpert75'),
('2020-09-10',	'16:00:00', 'Coda Building', 'dschrute18'),
('2020-09-10',	'17:00:00', 'Coda Building', 'amartin365'),
('2020-09-10',	'08:00:00', 'Stamps Health Services', 'omartinez13'),
('2020-09-10',	'09:00:00', 'Bobby Dodd Stadium', 'mscott845'),
('2020-09-10',	'10:00:00', 'West Village', 'abernard224'),
('2020-09-10',	'11:00:00', 'GT Connector', 'kkapoor155'),
('2020-09-10',	'12:00:00', 'Curran St Parking Deck', 'dphilbin81'),
('2020-09-10',	'13:00:00', 'Curran St Parking Deck', 'sthefirst1'),
('2020-09-10',	'14:00:00', 'North Avenue (Centenial Room)', 'gburdell1'),
('2020-09-10',	'15:00:00', 'Caddell Building', 'dsmith102'),
('2020-09-10', '16:00:00', 'CCBOH WIC Clinic', 'dbrown85'),
('2020-09-10', '17:00:00', 'Bobby Dodd Stadium', 'dkim99'),
('2020-09-10', '08:00:00', 'West Village','tlee984'),
('2020-09-10', '09:00:00', 'GT Catholic Center', 'jpark29'),
('2020-09-13', '10:00:00', 'Curran St Parking Deck', 'vneal101'),
('2020-09-13', '11:00:00', 'Coda Building', 'hpeterson55'),
('2020-09-13', '12:00:00', 'Stamps Health Services', 'lpiper20'),
('2020-09-13', '13:00:00', 'Curran St Parking Deck', 'mbob2'),
('2020-09-13', '14:00:00', 'CCBOH WIC Clinic', 'mrees785'),
('2020-09-16', '15:00:00', 'North Avenue (Centenial Room)', 'wbryant23'),
('2020-09-16', '16:00:00', 'West Village', 'aallman302'),
('2020-09-16', '17:00:00', 'Caddell Building', 'kweston85'),
('2020-09-16', '08:00:00', 'Fulton County Board of Health', NULL),
('2020-09-16', '09:00:00', 'CCBOH WIC Clinic', NULL),
('2020-09-16', '10:00:00', 'Kennesaw State University', NULL),
('2020-09-16', '11:00:00', 'Stamps Health Services', NULL),
('2020-09-16', '12:00:00', 'Bobby Dodd Stadium', NULL),
('2020-09-16', '13:00:00', 'Caddell Building', NULL),
('2020-09-16', '14:00:00', 'Coda Building', NULL),
('2020-09-16', '15:00:00', 'GT Catholic Center', NULL),
('2020-10-01', '17:00:00', 'GT Connector', NULL),
('2020-10-01', '08:00:00', 'Curran St Parking Deck', NULL),
('2020-10-01', '09:00:00', 'North Avenue (Centenial Room)', NULL),
('2020-10-01', '17:00:00', 'Fulton County Board of Health', NULL),	
('2020-10-01', '08:00:00', 'CCBOH WIC Clinic', NULL),	
('2020-10-01', '09:00:00', 'Kennesaw State University', NULL),
('2020-10-01', '10:00:00', 'Stamps Health Services', NULL),
('2020-10-01', '11:00:00', 'Bobby Dodd Stadium', NULL),
('2020-10-02', '12:00:00', 'Caddell Building', NULL),
('2020-10-02', '13:00:00', 'Coda Building', NULL),
('2020-10-02', '14:00:00', 'GT Catholic Center', NULL),
('2020-10-02', '15:00:00', 'West Village', NULL),
('2020-10-02', '16:00:00', 'GT Connector', NULL),
('2020-10-02', '17:00:00', 'Curran St Parking Deck', NULL),
('2020-10-06', '08:00:00', 'North Avenue (Centenial Room)', NULL),
('2020-10-06', '09:00:00', 'Fulton County Board of Health', NULL),
('2020-10-06', '10:00:00', 'CCBOH WIC Clinic', NULL),
('2020-10-06', '11:00:00', 'Kennesaw State University', NULL),
('2020-10-06', '12:00:00', 'Stamps Health Services', NULL),
('2020-10-07', '13:00:00', 'Bobby Dodd Stadium', NULL),
('2020-10-07', '14:00:00', 'Caddell Building', NULL),
('2020-10-07', '15:00:00', 'Coda Building', NULL),
('2020-10-07', '16:00:00', 'GT Catholic Center', NULL),
('2020-10-07', '17:00:00', 'West Village', NULL),
('2020-10-07', '08:00:00', 'GT Connector', NULL),
('2020-10-07', '09:00:00', 'Curran St Parking Deck', NULL),
('2020-10-07', '10:00:00', 'North Avenue (Centenial Room)', NULL);

#tests
insert into test values (100001, 'negative', 1, '2020-09-01', '08:00:00'),
(100002, 'negative', 1, '2020-09-01', '09:00:00'),
(100003, 'negative', 1, '2020-09-01', '10:00:00'),
(100004, 'negative', 1, '2020-09-01', '11:00:00'),
(100005, 'negative', 1, '2020-09-01', '12:00:00'),
(100006, 'negative', 1, '2020-09-01', '13:00:00'),
(100007, 'negative', 1, '2020-09-01', '14:00:00'),
(100008, 'negative', 2, '2020-09-01', '15:00:00'),
(100009, 'positive', 2, '2020-09-01', '16:00:00'),
(100011, 'negative', 2, '2020-09-03', '08:00:00'),
(100012, 'positive', 2, '2020-09-03', '09:00:00'),
(100013, 'positive', 2, '2020-09-03', '10:00:00'),
(100014, 'negative', 2, '2020-09-03', '11:00:00'),
(100015, 'negative', 3, '2020-09-03', '12:00:00'),
(100016, 'positive', 3, '2020-09-03', '13:00:00'),
(100017, 'negative', 3, '2020-09-03', '14:00:00'),
(100018, 'negative', 3, '2020-09-03', '15:00:00'),
(100019, 'positive', 3, '2020-09-03', '16:00:00'),
(100020, 'negative', 4, '2020-09-03', '17:00:00'),
(100021, 'negative', 4, '2020-09-04', '08:00:00'),
(100022, 'negative', 4, '2020-09-04', '09:00:00'),
(100023, 'negative', 4, '2020-09-04', '10:00:00'),
(100024, 'positive', 4, '2020-09-04', '11:00:00'),
(100025, 'negative', 5, '2020-09-04', '12:00:00'),
(100026, 'negative', 5, '2020-09-04', '13:00:00'),
(100027, 'negative', 5, '2020-09-04', '14:00:00'),
(100028, 'negative', 5, '2020-09-04', '15:00:00'),
(100029, 'negative', 5, '2020-09-04', '16:00:00'),
(100030, 'negative', 5, '2020-09-04', '17:00:00'),
(100031, 'positive', 6, '2020-09-04', '08:00:00'),
(100032, 'positive', 6, '2020-09-04', '09:00:00'),
(100033, 'negative', 7, '2020-09-04', '10:00:00'),
(100034, 'negative', 7, '2020-09-10', '11:00:00'),
(100035, 'negative', 7, '2020-09-10', '12:00:00'),
(100036, 'negative', 7, '2020-09-10', '13:00:00'),
(100037, 'negative', 7, '2020-09-10', '14:00:00'),
(100038, 'negative', 7, '2020-09-10', '15:00:00'),
(100039, 'negative', 8, '2020-09-10', '16:00:00'),
(100040, 'positive', 8, '2020-09-10', '17:00:00'),
(100041, 'negative', 8, '2020-09-10', '08:00:00'),
(100042, 'pending', 9, '2020-09-10', '09:00:00'),
(100043, 'pending', 9, '2020-09-10', '10:00:00'),
(100044, 'pending', 9, '2020-09-10', '11:00:00'),
(100045, 'pending', 9, '2020-09-10', '12:00:00'),
(100046, 'pending', 9, '2020-09-10', '13:00:00'),
(100047, 'pending', 9, '2020-09-10', '14:00:00'),
(100048, 'pending', 9, '2020-09-10', '15:00:00'),
(100049, 'pending', 10, '2020-09-10', '16:00:00'),
(100050, 'pending', 11, '2020-09-10', '17:00:00'),
(100051, 'pending', 11, '2020-09-10', '08:00:00'),
(100052, 'pending', 11, '2020-09-10', '09:00:00'),
(100053, 'pending', 11, '2020-09-13', '10:00:00'),
(100054, 'pending', 11, '2020-09-13', '11:00:00'),
(100055, 'pending', 12, '2020-09-13', '12:00:00'),
(100056, 'pending', 12, '2020-09-13', '13:00:00'),
(100057, 'pending', 12, '2020-09-13', '14:00:00'),
(100058, 'pending', 12, '2020-09-16', '15:00:00'),
(100059, 'pending', 13, '2020-09-16', '16:00:00'),
(100060, 'pending', 13, '2020-09-16', '17:00:00');

#process relationship
insert into process values ('jhilborn97', 1, '2020-09-02'),
('jhilborn98', 2, '2020-09-04'),
('ygao10', 3, '2020-09-06'),
('jthomas520', 4, '2020-09-05'),
('fdavenport49', 5, '2020-09-07'),
('hliu88', 6, '2020-09-05'),
('cforte58', 7, '2020-09-11'),
('ygao10', 8, '2020-09-11');

#works-in relationship
insert into works_in values 
('Fulton County Board of Health', 'akarev16'),
('CCBOH WIC Clinic', 'akarev16'),
('Kennesaw State University', 'akarev16' ) ,
('Stamps Health Services', 'akarev16'),
('Curran St Parking Deck', 'jdoe381'),
('North Avenue (Centenial Room)', 'jdoe381'),
('Fulton County Board of Health', 'jdoe381'),
('CCBOH WIC Clinic', 'jdoe381'),
('Coda Building', 'sstrange11'),
('GT Catholic Center', 'sstrange11'),
('West Village', 'sstrange11'),
('GT Connector', 'sstrange11'),
('Curran St Parking Deck', 'sstrange11'),
('North Avenue (Centenial Room)', 'sstrange11'),
('Bobby Dodd Stadium', 'dmcstuffins7'),
('Caddell Building', 'dmcstuffins7'),
('Coda Building', 'dmcstuffins7'),
('GT Catholic Center', 'dmcstuffins7'),
('West Village', 'dmcstuffins7'),
('GT Connector', 'dmcstuffins7'),
('Kennesaw State University', 'mgrey91'),
('Stamps Health Services', 'mgrey91'),
('Bobby Dodd Stadium', 'mgrey91'),
('Caddell Building', 'mgrey91'),
('Coda Building', 'pwallace51');


