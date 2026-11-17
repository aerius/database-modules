/*
 * critical_deposition_areas_buffered
 * ----------------------------------
 * Table with the critical deposition areas with associated type, critical deposition value, and whether or not they are designated. 
 * Is used exclusively in the nature-grid build and has an added geometry_buffered column, used in the tolerance implementation. 
 * This includes both the set of all habitat areas and the set of relevant habitat areas. 
 * Also contains a negatively buffered geometry column, which is used for the tolerance-implementation.
 */
CREATE TABLE critical_deposition_areas_buffered (
	assessment_area_id integer NOT NULL,
	type critical_deposition_area_type NOT NULL,
	critical_deposition_area_id integer NOT NULL,
	name text NOT NULL,
	description text NOT NULL,
	relevant boolean NOT NULL,
	geometry geometry(MultiPolygon),
	geometry_buffered geometry(Multipolygon) GENERATED ALWAYS AS (system.ae_get_buffered_geometry(geometry)) STORED,

	CONSTRAINT critical_deposition_areas_buffered_pkey PRIMARY KEY (assessment_area_id, type, critical_deposition_area_id),
	CONSTRAINT critical_deposition_areas_buffered_fkey_assessment_areas FOREIGN KEY (assessment_area_id) REFERENCES natura2000_areas (assessment_area_id)
);

CREATE INDEX idx_critical_deposition_areas_geometry_gist ON critical_deposition_areas_buffered USING GIST (geometry);
CREATE INDEX idx_critical_deposition_areas_geometry_buffered_gist ON critical_deposition_areas_buffered USING GIST (geometry_buffered);
