--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: agents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE agents (
    id bigint NOT NULL,
    created_by character varying(255),
    created_datetime timestamp without time zone,
    descr character varying(255),
    last_updated_by character varying(255),
    updated_datetime timestamp without time zone,
    version bigint,
    alt_id character varying(255),
    name character varying(255),
    trust_score numeric(12,6)
);


ALTER TABLE agents OWNER TO postgres;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hibernate_sequence OWNER TO postgres;

--
-- Name: notification_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE notification_logs (
    id bigint NOT NULL,
    created_by character varying(255),
    created_datetime timestamp without time zone,
    descr character varying(255),
    last_updated_by character varying(255),
    updated_datetime timestamp without time zone,
    version bigint,
    content character varying(255),
    type character varying(255),
    status_id bigint
);


ALTER TABLE notification_logs OWNER TO postgres;

--
-- Name: statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE statuses (
    id bigint NOT NULL,
    created_by character varying(255),
    created_datetime timestamp without time zone,
    descr character varying(255),
    last_updated_by character varying(255),
    updated_datetime timestamp without time zone,
    version bigint,
    name character varying(255)
);


ALTER TABLE statuses OWNER TO postgres;

--
-- Name: trust_attribute_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE trust_attribute_types (
    id bigint NOT NULL,
    created_by character varying(255),
    created_datetime timestamp without time zone,
    descr character varying(255),
    last_updated_by character varying(255),
    updated_datetime timestamp without time zone,
    version bigint,
    name character varying(255),
    parent_type_id bigint
);


ALTER TABLE trust_attribute_types OWNER TO postgres;

--
-- Name: trust_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE trust_attributes (
    id bigint NOT NULL,
    created_by character varying(255),
    created_datetime timestamp without time zone,
    descr character varying(255),
    last_updated_by character varying(255),
    updated_datetime timestamp without time zone,
    version bigint,
    importance double precision NOT NULL,
    max_value character varying(255),
    min_value character varying(255),
    value character varying(255),
    trust_attribute_type_id bigint NOT NULL,
    trust_policy_id bigint,
    trust_profile_id bigint
);


ALTER TABLE trust_attributes OWNER TO postgres;

--
-- Name: trust_policies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE trust_policies (
    id bigint NOT NULL,
    created_by character varying(255),
    created_datetime timestamp without time zone,
    descr character varying(255),
    last_updated_by character varying(255),
    updated_datetime timestamp without time zone,
    version bigint,
    owner_id bigint
);


ALTER TABLE trust_policies OWNER TO postgres;

--
-- Name: trust_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE trust_profiles (
    id bigint NOT NULL,
    created_by character varying(255),
    created_datetime timestamp without time zone,
    descr character varying(255),
    last_updated_by character varying(255),
    updated_datetime timestamp without time zone,
    version bigint,
    owner_id bigint
);


ALTER TABLE trust_profiles OWNER TO postgres;

--
-- Data for Name: agents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY agents (id, created_by, created_datetime, descr, last_updated_by, updated_datetime, version, alt_id, name, trust_score) FROM stdin;
\.


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('hibernate_sequence', 1, false);


--
-- Data for Name: notification_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY notification_logs (id, created_by, created_datetime, descr, last_updated_by, updated_datetime, version, content, type, status_id) FROM stdin;
\.


--
-- Data for Name: statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY statuses (id, created_by, created_datetime, descr, last_updated_by, updated_datetime, version, name) FROM stdin;
\.


--
-- Data for Name: trust_attribute_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trust_attribute_types (id, created_by, created_datetime, descr, last_updated_by, updated_datetime, version, name, parent_type_id) FROM stdin;
\.


--
-- Data for Name: trust_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trust_attributes (id, created_by, created_datetime, descr, last_updated_by, updated_datetime, version, importance, max_value, min_value, value, trust_attribute_type_id, trust_policy_id, trust_profile_id) FROM stdin;
\.


--
-- Data for Name: trust_policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trust_policies (id, created_by, created_datetime, descr, last_updated_by, updated_datetime, version, owner_id) FROM stdin;
\.


--
-- Data for Name: trust_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trust_profiles (id, created_by, created_datetime, descr, last_updated_by, updated_datetime, version, owner_id) FROM stdin;
\.


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


--
-- Name: notification_logs notification_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notification_logs
    ADD CONSTRAINT notification_logs_pkey PRIMARY KEY (id);


--
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: trust_attribute_types trust_attribute_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_attribute_types
    ADD CONSTRAINT trust_attribute_types_pkey PRIMARY KEY (id);


--
-- Name: trust_attributes trust_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_attributes
    ADD CONSTRAINT trust_attributes_pkey PRIMARY KEY (id);


--
-- Name: trust_policies trust_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_policies
    ADD CONSTRAINT trust_policies_pkey PRIMARY KEY (id);


--
-- Name: trust_profiles trust_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_profiles
    ADD CONSTRAINT trust_profiles_pkey PRIMARY KEY (id);


--
-- Name: notification_logs fkdoq2j7fhcne4hhe1wgntehd8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notification_logs
    ADD CONSTRAINT fkdoq2j7fhcne4hhe1wgntehd8 FOREIGN KEY (status_id) REFERENCES statuses(id);


--
-- Name: trust_attributes fkepdfs1xgwa9mdkawx3wm4efu8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_attributes
    ADD CONSTRAINT fkepdfs1xgwa9mdkawx3wm4efu8 FOREIGN KEY (trust_attribute_type_id) REFERENCES trust_attribute_types(id);


--
-- Name: trust_profiles fkk32pdoirrs2kbv7g92heqldgo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_profiles
    ADD CONSTRAINT fkk32pdoirrs2kbv7g92heqldgo FOREIGN KEY (owner_id) REFERENCES agents(id);


--
-- Name: trust_attribute_types fklkr103kn01hga32fkkgutlsjs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_attribute_types
    ADD CONSTRAINT fklkr103kn01hga32fkkgutlsjs FOREIGN KEY (parent_type_id) REFERENCES trust_attribute_types(id);


--
-- Name: trust_attributes fkmbf9vp9xitam3nibdb6m66c77; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_attributes
    ADD CONSTRAINT fkmbf9vp9xitam3nibdb6m66c77 FOREIGN KEY (trust_policy_id) REFERENCES trust_policies(id);


--
-- Name: trust_attributes fko05h3wntelc5b1yf7xlagsgvo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_attributes
    ADD CONSTRAINT fko05h3wntelc5b1yf7xlagsgvo FOREIGN KEY (trust_profile_id) REFERENCES trust_profiles(id);


--
-- Name: trust_policies fkp43t63py0c4o47gvij82ixv6g; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trust_policies
    ADD CONSTRAINT fkp43t63py0c4o47gvij82ixv6g FOREIGN KEY (owner_id) REFERENCES agents(id);


--
-- PostgreSQL database dump complete
--


--Execute this script only after trust-service is deployed and trustDb created
--Insert  trust_attribute_types 
insert into trust_attribute_types (id, name, descr, parent_type_id) values (1,'OverallCompanyRating','OverallCompanyRating',null);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (2,'OverallCommunicationRating','OverallCommunicationRating',1);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (3,'QualityOfNegotiationProcessRating','QualityOfNegotiationProcessRating',2);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (4,'QualityOfOrderingProcessRating','QualityOfOrderingProcessRating',2);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (5,'ResponseTimeRating','ResponseTimeRating',2);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (6,'OverallFullfilmentOfTermsRating','OverallFullfilmentOfTermsRating',1);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (7,'ListingAccuracyRating','ListingAccuracyRating',6);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (8,'ConformanceToContractualTerms','ConformanceToContractualTerms',6);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (9,'OverallDeliveryAndPackagingRating','OverallDeliveryAndPackagingRating',1);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (10,'NumberOfCompletedTransactions','NumberOfCompletedTransactions',null);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (11,'NumberOfUncompletedTransactions','NumberOfUncompletedTransactions',null);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (12,'TradingVolume','TradingVolume',null);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (13,'AverageTimeToRespond','AverageTimeToRespond',null);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (14,'AverageNegotiationTime','AverageNegotiationTime',null);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (15,'OverallProfileCompletness','OverallProfileCompletness',null);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (16,'ProfileCompletnessDetails','ProfileCompletnessDetails',15);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (17,'ProfileCompletnessDescription','ProfileCompletnessDescription',15);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (18,'ProfileCompletnessTrade','ProfileCompletnessTrade',15);
insert into trust_attribute_types (id, name, descr, parent_type_id) values (19,'ProfileCompletnessCertificates','ProfileCompletnessCertificates',15);
update trust_attribute_types set created_datetime = now();
update trust_attribute_types set version = 0;
commit;