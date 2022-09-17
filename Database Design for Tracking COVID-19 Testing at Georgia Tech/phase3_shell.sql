/*
CS4400: Introduction to Database Systems
Fall 2020
Phase III Template

Team 86
Eric Qiu (eqiu7)
Longan Loi (lloi3)
Maxine Lee (mlee624)
Timothy Bang (tbang6)


Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/


-- ID: 2a
-- Author: lvossler3
-- Name: register_student
DROP PROCEDURE IF EXISTS register_student;
DELIMITER //
CREATE PROCEDURE register_student(
		IN i_username VARCHAR(40),
        IN i_email VARCHAR(40),
        IN i_fname VARCHAR(40),
        IN i_lname VARCHAR(40),
        IN i_location VARCHAR(40),
        IN i_housing_type VARCHAR(20),
        IN i_password VARCHAR(40)
)
BEGIN

-- Type solution below
insert into USER(username, user_password, email, fname, lname) values (i_username, MD5(i_password), i_email, i_fname, i_lname);
insert into STUDENT(student_username, housing_type, location) values (i_username, i_housing_type, i_location);
-- End of solution
END //
DELIMITER ;

-- ID: 2b
-- Author: lvossler3
-- Name: register_employee
DROP PROCEDURE IF EXISTS register_employee;
DELIMITER //
CREATE PROCEDURE register_employee(
		IN i_username VARCHAR(40),
        IN i_email VARCHAR(40),
        IN i_fname VARCHAR(40),
        IN i_lname VARCHAR(40),
        IN i_phone VARCHAR(10),
        IN i_labtech BOOLEAN,
        IN i_sitetester BOOLEAN,
        IN i_password VARCHAR(40)
)
BEGIN
-- Type solution below
insert into USER(username, user_password, email, fname, lname) values (i_username, MD5(i_password), i_email, i_fname, i_lname);
insert into EMPLOYEE(emp_username, phone_num) values (i_username, i_phone);
if i_labtech then
	insert into LABTECH(labtech_username) values (i_username);
end if;
if i_sitetester then
	insert into SITETESTER(sitetester_username) values (i_username);
end if;
-- End of solution
END //
DELIMITER ;

-- ID: 4a
-- Author: Aviva Smith
-- Name: student_view_results
DROP PROCEDURE IF EXISTS `student_view_results`;
DELIMITER //
CREATE PROCEDURE `student_view_results`(
    IN i_student_username VARCHAR(50),
	IN i_test_status VARCHAR(50),
	IN i_start_date DATE,
    IN i_end_date DATE
)
BEGIN
	DROP TABLE IF EXISTS student_view_results_result;
    CREATE TABLE student_view_results_result(
        test_id VARCHAR(7),
        timeslot_date date,
        date_processed date,
        pool_status VARCHAR(40),
        test_status VARCHAR(40)
    );
    INSERT INTO student_view_results_result

    -- Type solution below

		SELECT t.test_id, t.appt_date, p.process_date, p.pool_status , t.test_status
        FROM APPOINTMENT a
            LEFT JOIN TEST t
                ON t.appt_date = a.appt_date
                AND t.appt_time = a.appt_time
                AND t.appt_site = a.site_name
            LEFT JOIN POOL p
                ON t.pool_id = p.pool_id
        WHERE i_student_username = a.username
            AND (i_test_status = t.test_status OR i_test_status IS NULL)
            AND (i_start_date <= t.appt_date OR i_start_date IS NULL)
            AND (i_end_date >= t.appt_date OR i_end_date IS NULL);

    -- End of solution
END //
DELIMITER ;

-- ID: 5a
-- Author: asmith457
-- Name: explore_results
DROP PROCEDURE IF EXISTS explore_results;
DELIMITER $$
CREATE PROCEDURE explore_results (
    IN i_test_id VARCHAR(7))
BEGIN
    DROP TABLE IF EXISTS explore_results_result;
    CREATE TABLE explore_results_result(
        test_id VARCHAR(7),
        test_date date,
        timeslot time,
        testing_location VARCHAR(40),
        date_processed date,
        pooled_result VARCHAR(40),
        individual_result VARCHAR(40),
        processed_by VARCHAR(80)
    );
    INSERT INTO explore_results_result

    -- Type solution below

    select test_id, appt_date, appt_time, appt_site, process_date, pool_status, test_status, concat(fname, ' ', lname) as processed_by from TEST, POOL, USER where i_test_id = test_id and TEST.pool_id = POOL.pool_id and processed_by = username;

    -- End of solution
END$$
DELIMITER ;

-- ID: 6a
-- Author: asmith457
-- Name: aggregate_results
DROP PROCEDURE IF EXISTS aggregate_results;
DELIMITER $$
CREATE PROCEDURE aggregate_results(
    IN i_location VARCHAR(50),
    IN i_housing VARCHAR(50),
    IN i_testing_site VARCHAR(50),
    IN i_start_date DATE,
    IN i_end_date DATE)
BEGIN
    DROP TABLE IF EXISTS aggregate_results_result;
    CREATE TABLE aggregate_results_result(
        test_status VARCHAR(40),
        num_of_test INT,
        percentage DECIMAL(6,2)
    );

    Select count(*) into @total from TEST, STUDENT, APPOINTMENT where 
        (i_location is NULL or i_location = location) and 
        (i_housing is NULL or i_housing = housing_type) and 
        (i_testing_site is null or i_testing_site = TEST.appt_site) and 
        (i_start_date is null or TEST.appt_date >= i_start_date) and
        (i_end_date is null or TEST.appt_date <= i_end_date) and
        -- appointment primary key is date, time and site 
        TEST.appt_date =  APPOINTMENT.appt_date and
        TEST.appt_time = APPOINTMENT.appt_time and
        TEST.appt_site = APPOINTMENT.site_name and
        STUDENT.student_username = APPOINTMENT.username;

    INSERT INTO aggregate_results_result

    -- Type solution below

    Select test_status, count(*), ROUND((count(*) * 100.0 / @total), 2) from TEST, STUDENT, APPOINTMENT where 
        (i_location is NULL or i_location = location) and 
        (i_housing is NULL or i_housing = housing_type) and 
        (i_testing_site is null or i_testing_site = TEST.appt_site) and 
        (i_start_date is null or TEST.appt_date >= i_start_date) and
        (i_end_date is null or TEST.appt_date <= i_end_date) and
        -- appointment primary key is date, time and site 
        TEST.appt_date =  APPOINTMENT.appt_date and
        TEST.appt_time = APPOINTMENT.appt_time and
        TEST.appt_site = APPOINTMENT.site_name and
        STUDENT.student_username = APPOINTMENT.username        
        group by test_status;





    -- End of solution
END$$
DELIMITER ;

-- ID: 7a
-- Author: lvossler3
-- Name: test_sign_up_filter
DROP PROCEDURE IF EXISTS test_sign_up_filter;
DELIMITER //
CREATE PROCEDURE test_sign_up_filter(
    IN i_username VARCHAR(40),
    IN i_testing_site VARCHAR(40),
    IN i_start_date date,
    IN i_end_date date,
    IN i_start_time time,
    IN i_end_time time)
BEGIN
    DROP TABLE IF EXISTS test_sign_up_filter_result;
    CREATE TABLE test_sign_up_filter_result(
        appt_date date,
        appt_time time,
        street VARCHAR (40),
        city VARCHAR(40),
        state VARCHAR(2),
        zip VARCHAR(5),
        site_name VARCHAR(40));
    INSERT INTO test_sign_up_filter_result

    -- Type solution below

    SELECT APPOINTMENT.appt_date, APPOINTMENT.appt_time, SITE.street, SITE.city, SITE.state, SITE.zip, SITE.site_name FROM APPOINTMENT,SITE where 
    APPOINTMENT.username is null and
    (i_testing_site is NULL or i_testing_site = APPOINTMENT.site_name) and 
    (i_start_date is NULL or APPOINTMENT.appt_date >= i_start_date)and 
    (i_end_date is NULL or APPOINTMENT.appt_date <= i_end_date)and 
    (i_start_time is null or APPOINTMENT.appt_time >= i_start_time) and
    (i_end_time is NULL or APPOINTMENT.appt_time <= i_end_time) and 
    -- can't do two tests in one day
    (APPOINTMENT.appt_date > (select max(appt_date) from APPOINTMENT where APPOINTMENT.username = i_username)) and
    SITE.location = (select STUDENT.location from STUDENT where STUDENT.student_username = i_username) and APPOINTMENT.site_name = SITE.site_name;

    -- End of solution

    END //
    DELIMITER ;
    CALL test_sign_up_filter('gburdell1', 'North Avenue (Centenial Room)', NULL, '2020-10-06', NULL, NULL);
	select * from test_sign_up_filter_result;

-- ID: 7b
-- Author: lvossler3
-- Name: test_sign_up
DROP PROCEDURE IF EXISTS test_sign_up;
DELIMITER //
CREATE PROCEDURE test_sign_up(
		IN i_username VARCHAR(40),
        IN i_site_name VARCHAR(40),
        IN i_appt_date date,
        IN i_appt_time time,
        IN i_test_id VARCHAR(7)
)
BEGIN
-- Type solution below
sign_up: BEGIN
	if 'pending' in (select test_status from TEST, APPOINTMENT, STUDENT where
        TEST.appt_date =  APPOINTMENT.appt_date and
        TEST.appt_time = APPOINTMENT.appt_time and
        TEST.appt_site = APPOINTMENT.site_name and
        STUDENT.student_username = APPOINTMENT.username and 
        APPOINTMENT.username = i_username)
	then leave sign_up;
    end if;

UPDATE APPOINTMENT SET username = i_username WHERE site_name= i_site_name and appt_date = i_appt_date and appt_time = i_appt_time;
INSERT INTO TEST (test_id, test_status, pool_id, appt_site, appt_date, appt_time) values (i_test_id, 'pending', null, i_site_name, i_appt_date, i_appt_time);

END sign_up;
-- End of solution
END //
DELIMITER ;

-- Number: 8a
-- Author: lvossler3
-- Name: tests_processed
DROP PROCEDURE IF EXISTS tests_processed;
DELIMITER //
CREATE PROCEDURE tests_processed(
    IN i_start_date date,
    IN i_end_date date,
    IN i_test_status VARCHAR(10),
    IN i_lab_tech_username VARCHAR(40))
BEGIN
    DROP TABLE IF EXISTS tests_processed_result;
    CREATE TABLE tests_processed_result(
        test_id VARCHAR(7),
        pool_id VARCHAR(10),
        test_date date,
        process_date date,
        test_status VARCHAR(10) );
    INSERT INTO tests_processed_result
    -- Type solution below

select TEST.test_id, POOL.pool_id, TEST.appt_date, POOL.process_date, TEST.test_status from TEST, POOL where
	(i_start_date is NULL or TEST.appt_date >= i_start_date) and
    (i_end_date is NULL or TEST.appt_date <= i_end_date) and
    (i_test_status is NULL or TEST.test_status = i_test_status) and
    (i_lab_tech_username = POOL.processed_by) and
    TEST.pool_id = POOL.pool_id;


    -- End of solution
    END //
    DELIMITER ;

-- ID: 9a
-- Author: ahatcher8@
-- Name: view_pools
DROP PROCEDURE IF EXISTS view_pools;
DELIMITER //
CREATE PROCEDURE view_pools(
    IN i_begin_process_date DATE,
    IN i_end_process_date DATE,
    IN i_pool_status VARCHAR(20),
    IN i_processed_by VARCHAR(40)
)
BEGIN
    DROP TABLE IF EXISTS view_pools_result;
    CREATE TABLE view_pools_result(
        pool_id VARCHAR(10),
        test_ids VARCHAR(100),
        date_processed DATE,
        processed_by VARCHAR(40),
        pool_status VARCHAR(20));

    INSERT INTO view_pools_result
-- Type solution below
select POOL.pool_id, group_concat(TEST.test_id) as test_ids, POOL.process_date as date_processed, POOL.processed_by, POOL.pool_status 
from POOL RIGHT JOIN TEST on POOL.pool_id = TEST.pool_id
where
    ((i_begin_process_date is NULL or POOL.process_date >= i_begin_process_date) and
    (i_end_process_date is NULL or POOL.process_date <= i_end_process_date) or
    (i_end_process_date IS NULL AND POOL.pool_status = 'pending')) and
    (i_pool_status is NULL or POOL.pool_status = i_pool_status) and
    (i_processed_by is NULL or POOL.processed_by = i_processed_by) and
    (POOL.pool_id is not null)
group by POOL.pool_id;




-- End of solution
END //
DELIMITER ;

-- ID: 10a
-- Author: ahatcher8@
-- Name: create_pool
DROP PROCEDURE IF EXISTS create_pool;
DELIMITER //
CREATE PROCEDURE create_pool(
	IN i_pool_id VARCHAR(10),
    IN i_test_id VARCHAR(7)
)
BEGIN
-- Type solution below
create_pool: BEGIN
    
    if i_pool_id in (select pool_id from POOL) then leave create_pool;
    end if;
    if (select pool_id from TEST where test_id = i_test_id) is not null then leave create_pool; 
    end if;
    if i_test_id not in (select test_id from test) then leave create_pool;
    end if;
    INSERT into POOL values (i_pool_id, 'pending', null, null);
    UPDATE TEST set pool_id = i_pool_id where test_id = i_test_id;
END create_pool;


-- End of solution
END //
DELIMITER ;

-- ID: 10b
-- Author: ahatcher8@
-- Name: assign_test_to_pool
DROP PROCEDURE IF EXISTS assign_test_to_pool;
DELIMITER //
CREATE PROCEDURE assign_test_to_pool(
    IN i_pool_id VARCHAR(10),
    IN i_test_id VARCHAR(7)
)
BEGIN
-- Type solution below
assign_pool: BEGIN
    if ((select count(*) from TEST where pool_id = i_pool_id) >= 7) or ((select pool_id from TEST where test_id = i_test_id) is not null) 
    then leave assign_pool; 
    end if;
    UPDATE TEST set pool_id = i_pool_id where test_id = i_test_id;
END assign_pool;

-- End of solution
END //
DELIMITER ;

-- ID: 11a
-- Author: ahatcher8@
-- Name: process_pool
DROP PROCEDURE IF EXISTS process_pool;
DELIMITER //
CREATE PROCEDURE process_pool(
    IN i_pool_id VARCHAR(10),
    IN i_pool_status VARCHAR(20),
    IN i_process_date DATE,
    IN i_processed_by VARCHAR(40)
)
BEGIN
-- Type solution below

    SELECT pool_status
    INTO @curr_status
    FROM POOL
    WHERE pool_id = i_pool_id;

    IF
        ((@curr_status = 'pending') AND (i_pool_status = 'positive' OR i_pool_status = 'negative'))
    THEN
        UPDATE POOL
        SET pool_status = i_pool_status, process_date = i_process_date, processed_by = i_processed_by
        WHERE pool_id = i_pool_id;
    END IF;


-- End of solution
END //
DELIMITER ;

-- ID: 11b
-- Author: ahatcher8@
-- Name: process_test
DROP PROCEDURE IF EXISTS process_test;
DELIMITER //
CREATE PROCEDURE process_test(
    IN i_test_id VARCHAR(7),
    IN i_test_status VARCHAR(20)
)
BEGIN


Set @curr_pool_status = (select pool_status from POOL join TEST on TEST.pool_id = POOL.pool_id where TEST.test_id = i_test_id);
    valid: BEGIN
    if (i_test_status != 'positive' and i_test_status != 'negative') then leave valid;
    elseif ((select test_status from TEST where test_id = i_test_id) != 'pending') then leave valid;
    elseif (@curr_pool_status  = 'pending') then leave valid;
    elseif (i_test_status != 'negative' and @curr_pool_status  = 'negative') then leave valid;
    
    else
        UPDATE TEST set test_status = i_test_status where test_id = i_test_id;
    END IF;
    END valid;


END //
DELIMITER ;




-- ID: 12a
-- Author: dvaidyanathan6
-- Name: create_appointment

DROP PROCEDURE IF EXISTS create_appointment;
DELIMITER //
CREATE PROCEDURE create_appointment(
	IN i_site_name VARCHAR(40),
    IN i_date DATE,
    IN i_time TIME
)
BEGIN
-- Type solution below

    IF ((10 * (select count(*) from working_at where site = i_site_name)) > (select count(*) from appointment where site_name = i_site_name and appt_date = i_date)) then
            insert into appointment values (null, i_site_name, i_date, i_time);
        END IF;



-- End of solution
END //
DELIMITER ;

-- ID: 13a
-- Author: dvaidyanathan6@
-- Name: view_appointments
DROP PROCEDURE IF EXISTS view_appointments;
DELIMITER //
CREATE PROCEDURE view_appointments(
    IN i_site_name VARCHAR(40),
    IN i_begin_appt_date DATE,
    IN i_end_appt_date DATE,
    IN i_begin_appt_time TIME,
    IN i_end_appt_time TIME,
    IN i_is_available INT  -- 0 for "booked only", 1 for "available only", NULL for "all"
)
BEGIN
    DROP TABLE IF EXISTS view_appointments_result;
    CREATE TABLE view_appointments_result(

        appt_date DATE,
        appt_time TIME,
        site_name VARCHAR(40),
        location VARCHAR(40),
        username VARCHAR(40));

    INSERT INTO view_appointments_result
-- Type solution below

    select appt_date, appt_time, APPOINTMENT.site_name, location, APPOINTMENT.username from APPOINTMENT join SITE on APPOINTMENT.site_name = SITE.site_name where
    (i_site_name is null or APPOINTMENT.site_name = i_site_name) and 
    (i_begin_appt_date is null or appt_date >= i_begin_appt_date) and 
    (i_end_appt_date is null or appt_date <= i_end_appt_date) and
    (i_begin_appt_time is null or appt_time >= i_begin_appt_time) and
    (i_end_appt_time is null or appt_time <= i_end_appt_time) and 
    (CASE WHEN i_is_available is null then true
    when i_is_available = 0 and APPOINTMENT.username is not null then true
    when i_is_available = 1 and APPOINTMENT.username is null then true
    else false
    end);




-- End of solution
END //
DELIMITER ;


-- ID: 14a
-- Author: kachtani3@
-- Name: view_testers
DROP PROCEDURE IF EXISTS view_testers;
DELIMITER //
CREATE PROCEDURE view_testers()
BEGIN
    DROP TABLE IF EXISTS view_testers_result;
    CREATE TABLE view_testers_result(

        username VARCHAR(40),
        name VARCHAR(80),
        phone_number VARCHAR(10),
        assigned_sites VARCHAR(255));

    INSERT INTO view_testers_result
-- Type solution below

	SELECT EMPLOYEE.emp_username as Username, concat(USER.fname, ' ', USER.lname) as Name, EMPLOYEE.phone_num as phone_number, group_concat(WORKING_AT.site order by WORKING_AT.site) as assigned_sites
	FROM EMPLOYEE join USER on EMPLOYEE.emp_username = USER.username left join WORKING_AT on EMPLOYEE.emp_username = WORKING_AT.username
	WHERE EMPLOYEE.emp_username in (Select * from SITETESTER) 
	group by EMPLOYEE.emp_username;
    
-- End of solution
END //
DELIMITER ;
CALL view_testers();
select * from view_testers_result;

-- ID: 15a
-- Author: kachtani3@
-- Name: create_testing_site
DROP PROCEDURE IF EXISTS create_testing_site;
DELIMITER //
CREATE PROCEDURE create_testing_site(
	IN i_site_name VARCHAR(40),
    IN i_street varchar(40),
    IN i_city varchar(40),
    IN i_state char(2),
    IN i_zip char(5),
    IN i_location varchar(40),
    IN i_first_tester_username varchar(40)
)
BEGIN
-- Type solution below
INSERT INTO SITE values (i_site_name, i_street, i_city, i_state, i_zip, i_location);
INSERT INTO WORKING_AT values (i_first_tester_username, i_site_name);

-- End of solution
END //
DELIMITER ;

-- ID: 16a
-- Author: kachtani3@
-- Name: pool_metadata
DROP PROCEDURE IF EXISTS pool_metadata;
DELIMITER //
CREATE PROCEDURE pool_metadata(
    IN i_pool_id VARCHAR(10))
BEGIN
    DROP TABLE IF EXISTS pool_metadata_result;
    CREATE TABLE pool_metadata_result(
        pool_id VARCHAR(10),
        date_processed DATE,
        pooled_result VARCHAR(20),
        processed_by VARCHAR(100));

    INSERT INTO pool_metadata_result
-- Type solution below

	select pool_id, process_date as date_processed, pool_status as pooled_result, (select concat(USER.fname, ' ', USER.lname ) from USER where processed_by = username) as processed_by
	from POOL JOIN USER ON POOL.processed_by = USER.username
	where (pool_id = i_pool_id);


-- End of solution
END //
DELIMITER ;

-- ID: 16b
-- Author: kachtani3@
-- Name: tests_in_pool
DROP PROCEDURE IF EXISTS tests_in_pool;
DELIMITER //
CREATE PROCEDURE tests_in_pool(
    IN i_pool_id VARCHAR(10))
BEGIN
    DROP TABLE IF EXISTS tests_in_pool_result;
    CREATE TABLE tests_in_pool_result(
        test_id varchar(7),
        date_tested DATE,
        testing_site VARCHAR(40),
        test_result VARCHAR(20));

    INSERT INTO tests_in_pool_result
-- Type solution below

    select test_id, appt_date as date_tested, appt_site as testing_site, test_status as test_result
	from TEST
	where (pool_id = i_pool_id);


-- End of solution
END //
DELIMITER ;

-- ID: 17a
-- Author: kachtani3@
-- Name: tester_assigned_sites
DROP PROCEDURE IF EXISTS tester_assigned_sites;
DELIMITER //
CREATE PROCEDURE tester_assigned_sites(
    IN i_tester_username VARCHAR(40))
BEGIN
    DROP TABLE IF EXISTS tester_assigned_sites_result;
    CREATE TABLE tester_assigned_sites_result(
        site_name VARCHAR(40));

    INSERT INTO tester_assigned_sites_result
-- Type solution below
    select site as site_name from working_at where (username = i_tester_username);
-- End of solution
END //
DELIMITER ;

-- ID: 17b
-- Author: kachtani3@
-- Name: assign_tester
DROP PROCEDURE IF EXISTS assign_tester;
DELIMITER //
CREATE PROCEDURE assign_tester(
	IN i_tester_username VARCHAR(40),
    IN i_site_name VARCHAR(40)
)
BEGIN
-- Type solution below
insert into working_at (username, site) values (i_tester_username, i_site_name);

-- End of solution
END //
DELIMITER ;


-- ID: 17c
-- Author: kachtani3@
-- Name: unassign_tester
DROP PROCEDURE IF EXISTS unassign_tester;
DELIMITER //
CREATE PROCEDURE unassign_tester(
	IN i_tester_username VARCHAR(40),
    IN i_site_name VARCHAR(40)
)
main: BEGIN
-- Type solution below
	if (select count(*) from working_at group by site having site = i_site_name) = 1 then leave main; end if;

	delete
	from working_at
	where (username = i_tester_username) and (site = i_site_name);



-- End of solution
END //
DELIMITER ;


-- ID: 18a
-- Author: lvossler3
-- Name: daily_results
DROP PROCEDURE IF EXISTS daily_results;
DELIMITER //
CREATE PROCEDURE daily_results()
BEGIN
	DROP TABLE IF EXISTS daily_results_result;
    CREATE TABLE daily_results_result(
		process_date date,
        num_tests int,
        pos_tests int,
        pos_percent DECIMAL(6,2));
	INSERT INTO daily_results_result
    -- Type solution below

select l.process_date, num_tests, IFNULL(pos_tests,0) as pos_tests, IFNULL(ROUND((pos_tests/num_tests) * 100, 2), 0) as pos_percent
from (
select process_date, count(*) as num_tests
from POOL natural join TEST
where process_date is not null
group by process_date) as l left outer join
(select process_date, count(*) as pos_tests
from POOL natural join TEST 
where test_status = 'positive'
group by process_date) as r
on l.process_date = r.process_date;


    -- End of solution
    END //
    DELIMITER ;















