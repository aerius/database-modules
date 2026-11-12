/*
 * ae_get_buffered_geometry
 * ------------------------
 * Function to return a buffered geometry, based on the INTERSECTION_TOLERANCE.
 */
CREATE OR REPLACE FUNCTION system.ae_get_buffered_geometry(geometry geometry(MultiPolygon))
	RETURNS geometry(MultiPolygon) AS
$BODY$
	SELECT ST_Buffer(geometry, system.constant('INTERSECTION_TOLERANCE')::numeric)
$BODY$
LANGUAGE sql IMMUTABLE;
