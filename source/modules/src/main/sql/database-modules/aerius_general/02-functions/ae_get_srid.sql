/*
 * ae_get_srid
 * -----------
 * Function returning the default SRID value.
 */
CREATE OR REPLACE FUNCTION ae_get_srid()
	RETURNS integer AS
$BODY$
	SELECT system.constant('SRID')::integer;
$BODY$
LANGUAGE sql IMMUTABLE;


/*
 * ae_get_buffered_geometry
 * ------------------------
 * Function to return a buffered geometry, based on the INTERSECTION_TOLERANCE.
 */
CREATE OR REPLACE FUNCTION ae_get_buffered_geometry(geometry geometry(MultiPolygon))
	RETURNS  geometry(MultiPolygon) AS
$BODY$
	SELECT ST_Buffer(geometry, system.constant('INTERSECTION_TOLERANCE')::numeric)
$BODY$
LANGUAGE sql IMMUTABLE;
