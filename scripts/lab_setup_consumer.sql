--Setup a role for proivder NACTX
-- Create NACTX role and Grant Privileges
use role accountadmin;
create role if not exists provider_role;
grant role provider_role to role accountadmin;
grant create warehouse on account to role provider_role;
grant create database on account to role provider_role;
grant create application package on account to role provider_role;
grant create application on account to role provider_role with grant option;

-- Create sample_native_app Database to Store Application Files 
use role provider_role;
create database if not exists sample_native_app;
create schema if not exists sample_native_app.napp;
create stage if not exists sample_native_app.napp.app_stage;
create warehouse if not exists wh_nap with warehouse_size='xsmall';


--Step 5.1 - Create Application Package and Grant Consumer Role Privileges
use role provider_role;
create application package sample_native_app_pkg;
--Step 5.2 - Upload Native App Code
--Upload the code from the App and src files into the Cortex Database App Stage
--Step 5.3 - Create Application Package
alter application package sample_native_app_pkg add version v1 using @sample_native_app.napp.app_stage;
grant install, develop on application package sample_native_app_pkg to role nac;



--Create Consumer in the provider side to test the app before we package it and share it
-- Step 4.1 - Create NAC role and Grant Privileges
use role accountadmin;
create role if not exists nac;
grant role nac to role accountadmin;
grant create warehouse on account to role nac;
grant create database on account to role nac;
grant create application on account to role nac;

use role nac;
create warehouse if not exists wh_nac with warehouse_size='medium';

--Step 6.1 - Install App as the Consumer
use role nac;
create application sample_native_app_instance from application package sample_native_app_pkg using version v1;

-- grant all on database movies to application sample_native_app_instance;
-- grant all on schema movies.data to application sample_native_app_instance;
-- grant all on table movies.data.movies_raw to application sample_native_app_instance;
grant usage on warehouse wh_nac to application sample_native_app_instance;


--Step 7.1 - Clean Up
--clean up consumer objects
use role NAC;
drop application sample_native_app_instance cascade;
drop warehouse wh_nac;

--clean up provider objects
use role provider_role;
drop application package sample_native_app_pkg;
drop database sample_native_app;
drop warehouse wh_nap;

--clean up prep objects
use role accountadmin;
drop role provider_role;
drop role nac;
