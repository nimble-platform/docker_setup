
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