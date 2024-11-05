-- step ONE
-- Setup a role for proivder tasks provider_role
-- Create provider_role role and Grant Privileges
use role accountadmin;
create role if not exists provider_role;
grant role provider_role to role accountadmin;
grant create warehouse on account to role provider_role;
grant create database on account to role provider_role;
grant create application on account to role provider_role with grant option;
grant create application package on account to role provider_role;

-- step TWO
-- Create sample_native_app Database to Store Application Files 
use role provider_role;
create database if not exists sample_native_app;
create schema if not exists sample_native_app.napp;

-- step THREE
create stage if not exists sample_native_app.napp.app_stage;
create warehouse if not exists wh_nap with warehouse_size='xsmall';
-- Use Snowsight to Upload Native App Code
-- Upload the code from the App and src files into the sample_native_app.napp.app_stage

-- setp FOUR
-- Create Application Package 
use role provider_role;
create application package sample_native_app_pkg;
-- set the files for the applciation Package
alter application package sample_native_app_pkg add version v1 using @sample_native_app.napp.app_stage;

-- step FIVE
-- Create a Consumer in the provider side to test the app before we package it and share it
-- and Grant Consumer Role Privileges
-- Create test_consumer_role role and Grant Privileges
use role accountadmin;
create role if not exists test_consumer_role;
grant role test_consumer_role to role accountadmin;
grant create warehouse on account to role test_consumer_role;
grant create database on account to role test_consumer_role;
grant create application on account to role test_consumer_role;
grant install, develop on application package sample_native_app_pkg to role test_consumer_role;
use role test_consumer_role;
create warehouse if not exists wh_test_consumer_role with warehouse_size='medium';

-- Step SIX
-- Install App as the Consumer
use role test_consumer_role;
create application sample_native_app_instance from application package sample_native_app_pkg using version v1;

-- Step SEVEN
-- grant teh applciation access to dabases taht need to be used
-- in this exmaple we are giving the applciation ACESS to a database MOVIEs, schema DATA
grant all on database DEMO_DB to application sample_native_app_instance;
grant all on schema DEMO_DB.CRM to application sample_native_app_instance;
grant select on all tables in schema DEMO_DB.CRM to application sample_native_app_instance;
--grant a WEAREHOUSE to be used by the app
grant usage on warehouse wh_test_consumer_role to application sample_native_app_instance;

--sepcial previlege for snwoflake databse
USE ROLE ACCOUNTADMIN;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO application sample_native_app_instance;

-- Step EIGHT
-- run the app through Snowsight
-- list available applications
show applications;

-- Step NINE
-- set release version
--provider settings to share the app
use role provider_role;
show application packages;
ALTER APPLICATION PACKAGE SAMPLE_NATIVE_APP_PKG SET DEFAULT RELEASE DIRECTIVE 
  VERSION = v1
  PATCH = 0;
  

-- CLEANUP
--clean up consumer objects
use role test_consumer_role;
drop application sample_native_app_instance cascade;
drop warehouse wh_test_consumer_role;

--clean up provider objects
use role provider_role;
drop application package sample_native_app_pkg;
drop database sample_native_app;
drop warehouse wh_nap;

--clean up prep objects
use role accountadmin;
drop role provider_role;
drop role test_consumer_role;
