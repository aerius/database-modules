-- Refresh all materialized views
BEGIN; REFRESH MATERIALIZED VIEW nature.habitats; COMMIT;
BEGIN; REFRESH MATERIALIZED VIEW nature.relevant_habitats; COMMIT;
BEGIN; REFRESH MATERIALIZED VIEW nature.relevant_goal_habitats; COMMIT;
BEGIN; REFRESH MATERIALIZED VIEW nature.relevant_species; COMMIT;
