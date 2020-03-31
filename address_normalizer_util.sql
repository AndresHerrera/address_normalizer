
/*
   address_normalizer_util.sql
*/
BEGIN;

CREATE TABLE replace_address_patterns
(
	denormalized text, normalized text 
);


INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('calle', ' CL ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cl', ' CL ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('kalle', ' CL ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('call', ' CL ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('clle', ' CL ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cal', ' CL ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cle', ' CL ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cale', ' CL ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cale', ' CL ');  
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('carrera', ' KR ');   
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cra', ' KR ');   
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('kra', ' KR ');   
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('kr', ' KR ');  
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('cr', ' KR '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('.', ' '); 	   
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES(',', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES(';', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES(':', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('-', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('$', ' '); 
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('%', ' ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('&', ' ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('/', ' ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('diag', ' DG ');	
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('diagonal', ' DG ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('diagn', ' DG ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('dgnal', ' DG ');
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
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('ap', ' AP ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('apartamento', ' AP ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('apto', ' AP ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('##', ' # ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('###', ' # ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('# #', ' # ');
INSERT INTO replace_address_patterns(denormalized , normalized ) VALUES('#', ' # ');

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

