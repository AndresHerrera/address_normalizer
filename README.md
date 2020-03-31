 PostgreSQL - Colombia Address Normalizer
=========================

A PostgreSQL function to normalice Colombian addresses. 

Release note. This is a early version of the function, and was tested for some urban addresses from Cali city .


Installation
------------

Everything you need is in `address_normalizer_util.sql`. 


Load the file into your database with `psql` or whatever your usual method is.
Eg:

    psql -U <username> -d <dbname> -f address_normalizer_util.sql

Function Reference
------------------

<!-- DO NOT EDIT BELOW THIS LINE - AUTO-GENERATED FROM SQL COMMENTS -->


### normalize_address ###

Returns normalized address text of the raw input address -
`{denormalized}`. 


| denormalized                        | normalized     |
|-------------------------------------|----------------|
| lowercase text                      | uppercase text |
| CARRERA,CRA,KRA,KR,CR,CARERA        | KR             |
| CALLE,CALL,CLLE,CLL,CL,CAL,CLE,CALE | CL             |
| DIAGONAL,DIAG,DGNAL                 | DG             |
| MANZANA,MZNA,MZA,MANZ,MZN           | MZ             |
| CASA,CSA,CAS                        | CS             |
| N,NO,NUMERO,NUM                     | space          |
| punctuation marks (.,;:-)           | space          |
| special characters ($%&/)           | space          |

__Parameters:__

- `raw_address` text - Any raw address denormalized

__Returns:__ `text` - a normalized address


__Example normalize_address query:__

```sql

SELECT normalize_address('Cl. 13b ## 68- 95');

```

| normalize_address(text)
|------------------
| CL 13B # 68 95

```sql

SELECT normalize_address('CaLlE 28 N # AVeNiDa 6 bis - 15 Ap 1003')

```

| normalize_address(text)
|------------------
| CL 28 N # AV 6 BIS 15 AP 1003

### addnew_pattern ###

Adds new patterns to be used by the functions

__Parameters:__

- `denormalized` text - pattern to be normalized
- `normalized` text - normalized pattern

__Returns:__ `boolean` - if a new pattern is added


__Example addnew_pattern query:__

```sql
SELECT addnew_pattern('CARRERRRA','KR');
```

### show_normalized_patterns ###

Show the avaliables  patterns to normalize the addresses

__Example show_normalized_patterns query:__

```sql
SELECT * FROM show_normalized_patterns();
```



Example test address data
------------------

### Insert some addresses to test

```sql
CREATE TABLE test_address
(
	raw_address text
);
```

```sql
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
```

## Test

### normalize_address from a single address

```sql
SELECT normalize_address('Cl. 13b ## 68- 95');
```

### normalize_address from a table

```sql
SELECT normalize_address(raw_address) as normalized_address 
FROM test_address;
```

### Add new pattern funcion 
```sql
SELECT addnew_pattern('CARRERRRA','KR');
```

### show normalized patterns
```sql
SELECT * FROM show_normalized_patterns();
```

## License

Copyright © 2020-present Andres Herrera.<br />
This source code is licensed under [MIT](https://github.com/AndresHerrera/colombia_address_normalizer/blob/master/LICENSE.txt) license<br />
The documentation to the project is licensed under the [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/) license.


