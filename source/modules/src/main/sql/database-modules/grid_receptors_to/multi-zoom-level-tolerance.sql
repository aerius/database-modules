/*
 * receptors_to_assessment_areas_tolerance
 * ---------------------------------------
 * Table linking receptors and assessment areas (mostly natura2000 areas) with the intersected surface.
 * The link is determined based on the hexagon at zoom level 1 corresponding to the receptor.
 * @column is_robust_intersect Boolean if the corresponding receptor is also present in the set which is determined with the tolerance-buffer. This column
 * is only present in the nature-grid build. The data is exported with the filter IS TRUE on this column and imported in the regular Monitor-build in the 
 * original version of this table, so without the "_tolerance" addition.
 */
CREATE TABLE receptors_to_assessment_areas_tolerance (
	receptor_id integer NOT NULL,
	assessment_area_id integer NOT NULL,
	zoom_level smallint NOT NULL,
	is_robust_intersect boolean NOT NULL,
	surface posnum NOT NULL,
	
	CONSTRAINT receptors_to_assessment_areas_tolerance_pkey PRIMARY KEY (receptor_id, assessment_area_id, zoom_level),
	CONSTRAINT receptors_to_assessment_areas_tolerance_fkey_receptors FOREIGN KEY (receptor_id) REFERENCES receptors
);

CREATE INDEX idx_receptors_to_assessment_areas_assessment_area_id ON receptors_to_assessment_areas_tolerance (assessment_area_id);


/*
 * receptors_to_critical_deposition_areas_tolerance
 * ------------------------------------------------
 * Table linking hexagons (by receptor_id), critical deposition areas and assessment areas (mostly natura2000 areas) with the intersected surface
 * and corresponding coverage of that critical deposition area.
 *
 * @column is_robust_intersect Boolean if the corresponding receptor is also present in the set which is determined with the tolerance-buffer. This column
 * is only present in the nature-grid build. The data is exported with the filter IS TRUE on this column and imported in the regular Monitor-build in the 
 * original version of this table, so without the "_tolerance" addition.
 * @column surface Area of the intersection of the hexagon and the critical deposition area.
 * @column receptor_habitat_coverage Average coverage of the critical deposition area on this receptor.
 * The coverage of all (relevant) habitat types that intersect with the hexagon is weighted according to the intersection surface, and averaged.
 * By multiplying the receptor_habitat_coverage value with the surface value, a valid cartographic surface is determined for this combination of receptor and critical deposition area.
 */
CREATE TABLE receptors_to_critical_deposition_areas_tolerance (
	assessment_area_id integer NOT NULL,
	type public.critical_deposition_area_type NOT NULL,
	critical_deposition_area_id integer NOT NULL,
	receptor_id integer NOT NULL,
	zoom_level smallint NOT NULL,
	is_robust_intersect boolean NOT NULL,
	surface posnum NOT NULL,
	receptor_habitat_coverage posnum NOT NULL,

	CONSTRAINT receptors_to_critical_deposition_tolerance_areas_pkey PRIMARY KEY (assessment_area_id, type, critical_deposition_area_id, receptor_id, zoom_level),
	CONSTRAINT receptors_to_critical_deposition_tolerance_areas_fkey_receptors FOREIGN KEY (receptor_id) REFERENCES receptors
);

CREATE INDEX idx_receptors_to_critical_deposition_areas ON receptors_to_critical_deposition_areas_tolerance (receptor_id);
