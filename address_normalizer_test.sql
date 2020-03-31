
/*
   test_addresss to be normalized
*/

CREATE TABLE test_address
(
	raw_address text
);

-- insert some address to test

INSERT INTO test_address(raw_address) VALUES('Cl. 13b ## 68- 95');
INSERT INTO test_address(raw_address) VALUES('Cl. 24 #112');
INSERT INTO test_address(raw_address) VALUES('Cra17c#21-54');
INSERT INTO test_address(raw_address) VALUES('Cl. 39 #4b 20');
INSERT INTO test_address(raw_address) VALUES('Cra. 39 #10A-55');
INSERT INTO test_address(raw_address) VALUES('Cl. 10 ##16-58');
INSERT INTO test_address(raw_address) VALUES('Cl. 23 #12-44');
INSERT INTO test_address(raw_address) VALUES('Cl. 44 #14-67');
INSERT INTO test_address(raw_address) VALUES('Carrera 3 # 10 - 49');
INSERT INTO test_address(raw_address) VALUES('Carrera 1D #62-70');
INSERT INTO test_address(raw_address) VALUES('Av. de las Americas, # 23A-02');
INSERT INTO test_address(raw_address) VALUES('Cl. 8 #32-00');
INSERT INTO test_address(raw_address) VALUES('Cra. 6a #28-30');
INSERT INTO test_address(raw_address) VALUES('AV 6 BIS # 28 NORTE - 09 AP 201');
INSERT INTO test_address(raw_address) VALUES('CL 28 NORTE # AV 6 BIS - 15 AP 1003');
INSERT INTO test_address(raw_address) VALUES('KR 1A9B # 73A - 02');
INSERT INTO test_address(raw_address) VALUES('avenida 10 A norte 12N-36');
INSERT INTO test_address(raw_address) VALUES('calle 28 96 -186');
INSERT INTO test_address(raw_address) VALUES('calle 44A 5-14');
INSERT INTO test_address(raw_address) VALUES('calle 13 carrera100');
INSERT INTO test_address(raw_address) VALUES('calle 6 oeste 10 oeste - 85 bosques deoeste');
INSERT INTO test_address(raw_address) VALUES('Carrera 3 # 10 - 49');

-- address to test

SELECT raw_address FROM test_address;

-- test function normalize_address from a single address

SELECT normalize_address('Cl. 13b ## 68- 95');

-- test function normalize_address from a table

SELECT normalize_address(raw_address) as normalized_address FROM test_address;

-- Add new pattern 

SELECT addnew_pattern('CARRERRRA','KR');

-- show normalized patterns

SELECT * FROM show_normalized_patterns();









