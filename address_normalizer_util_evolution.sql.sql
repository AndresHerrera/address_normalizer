/*
   address_normalizer_util_evolution.sql
*/
BEGIN;

CREATE TABLE replace_address_patterns
(
	denormalized text, normalized text 
);


INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('calle', ' C ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cl', ' C ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('kalle', ' C ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('call', ' C ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('clle', ' C ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cal', ' C ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cle', ' C ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cale', ' C ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cale', ' C ');  
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('carrera', ' K ');   
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cra', ' K ');   
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('kra', ' K ');   
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('kr', ' K ');  
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cr', ' K '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('diag', ' D ');	
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('diagonal', ' D ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('diagn', ' D ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('dgnal', ' D ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('transversal', ' T ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('casa', ' CS ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('CSA', ' CS ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('CASA', ' CS ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('avenida', ' AV ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('av', ' AV ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('bis', ' BIS ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('oeste', ' OESTE ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('sur', ' SUR ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('oe', ' OESTE ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('norte', ' NORTE ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('apartamento', ' AP ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('apto', ' AP ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('apt', ' AP ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('ap', ' AP ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('lote', ' LO ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('lo', ' LO ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('manzana', ' MZ ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('mz', ' MZ ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('etapa', ' ET ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('bloque', ' BLO ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('letra', ' LETRA ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('##', '  ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('###', '  ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('# #', '  ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('#', '  ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('.', ' '); 	   
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES(',', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES(';', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES(':', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('-', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('$', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('%', ' ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('&', ' ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('/', ' ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('|', '  ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('_', '  ');

-----------------------------
-----------------------------
-- replace_recursive function
-----------------------------
-- Taken from  https://stackoverflow.com/a/35370146 by Ian Timothy
-----------------------------
-----------------------------

CREATE OR REPLACE FUNCTION replace_recursive(search text, from_to text[][])
RETURNS TEXT LANGUAGE plpgsql AS $$
BEGIN
    IF (array_length(from_to,1) > 1) THEN
        RETURN replace_recursive(
            replace(search, from_to[1][1], from_to[1][2]),
            from_to[2:array_upper(from_to,1)]
        );
    ELSE
        RETURN replace(search, from_to[1][1], from_to[1][2]);
    END IF;
END;$$;



-----------------------------
-----------------------------
-- normalize_address function
-----------------------------
-----------------------------

CREATE OR REPLACE FUNCTION normalize_address( address text ) RETURNS 
	      text AS $$
	DECLARE
		 str_normalized text;
	BEGIN
		SELECT upper(trim(regexp_replace(sub.replaced, '\s+', ' ', 'g'))) 
		INTO str_normalized 
		FROM 
		(
		   SELECT replace_recursive(lower(address), 
		   ( SELECT array_agg(array[denormalized , normalized ]) 
		     from replace_address_patterns 
		    ) 
		  ) as replaced
		) as sub;

		RETURN str_normalized;
	END;
$$ LANGUAGE plpgsql;

END;


-----------------------------
-----------------------------
-- addnew_pattern function
-----------------------------
-----------------------------

CREATE OR REPLACE FUNCTION addnew_pattern( text , text ) RETURNS 
	      boolean AS $$
	DECLARE
	BEGIN
		INSERT INTO replace_address_patterns(denormalized , normalized ) 
		VALUES($1, ' '||$2||' ');
		RETURN true;
	END;
$$ LANGUAGE plpgsql;


-----------------------------
-----------------------------
-- show_normalized_patterns function
-----------------------------
-----------------------------

CREATE OR REPLACE FUNCTION show_normalized_patterns( )  
	      RETURNS TABLE (
      pattern_denormalized text,
      pattern_normalized text
)  AS $$
	DECLARE
	BEGIN
		RETURN QUERY SELECT
		denormalized as d, normalized as n FROM  replace_address_patterns;
	END;
$$ LANGUAGE plpgsql;


END;

-- DROP TABLE replace_address_patterns ;
-- DROP FUNCTION replace_recursive(search text, from_to text[][]);
-- DROP FUNCTION normalize_address( address text );
-- DROP FUNCTION addnew_pattern( text , text );
-- DROP FUNCTION show_normalized_patterns( );

----------------------------------------------------------------------
--- CREATE A TABLE FOR NORMALICE ADDRESSES -------

CREATE TABLE test_address
(
	id integer,
	raw_address text
);

-- TABLE FILL UP  
INSERT INTO test_address(id, raw_address) VALUES(1, 'Cl. 13b ## 68- 95');
INSERT INTO test_address(id, raw_address) VALUES(2, ' CL 9 # 15 - _15');

-- Test a single direccions
SELECT normalize_address(' CL 25 F 4 60') ;
SELECT normalize_address('CL 42A # 17C - 13');
SELECT normalize_address('CL 13 # 4 - 100');

-- Normalice all test_address

SELECT normalize_address(raw_address) as normalized_address FROM test_address;
---



--- FINAL QUERY ---
CREATE TABLE NORMALIZED_CLIENTS_SINCELEJO AS
SELECT t.ID,  normalize_address(t.dirp1) as normalized_address_1 , normalize_address(t.dirp2) as normalized_address_2
FROM public.CLIENTES_SINCELEJO as t ;








