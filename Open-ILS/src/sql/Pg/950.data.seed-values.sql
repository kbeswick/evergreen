--002.schema.config.sql:
INSERT INTO config.bib_source (id, quality, source, transcendant) VALUES 
    (1, 90, oils_i18n_gettext(1, 'oclc', 'cbs', 'source'), FALSE);
INSERT INTO config.bib_source (id, quality, source, transcendant) VALUES 
    (2, 10, oils_i18n_gettext(2, 'System Local', 'cbs', 'source'), FALSE);
INSERT INTO config.bib_source (id, quality, source, transcendant) VALUES 
    (3, 1, oils_i18n_gettext(3, 'Project Gutenberg', 'cbs', 'source'), TRUE);
SELECT SETVAL('config.bib_source_id_seq'::TEXT, 100);

INSERT INTO config.standing (id, value) VALUES (1, oils_i18n_gettext(1, 'Good', 'cst', 'value'));
INSERT INTO config.standing (id, value) VALUES (2, oils_i18n_gettext(2, 'Barred', 'cst', 'value'));
SELECT SETVAL('config.standing_id_seq'::TEXT, 100);

INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'series', 'seriestitle', $$//mods32:mods/mods32:relatedItem[@type="series"]/mods32:titleInfo$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'title', 'abbreviated', $$//mods32:mods/mods32:titleInfo[mods32:title and (@type='abbreviated')]$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'title', 'translated', $$//mods32:mods/mods32:titleInfo[mods32:title and (@type='translated')]$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'title', 'alternative', $$//mods32:mods/mods32:titleInfo[mods32:title and (@type='alternative')]$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'title', 'uniform', $$//mods32:mods/mods32:titleInfo[mods32:title and (@type='uniform')]$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'title', 'proper', $$//mods32:mods/mods32:titleInfo[mods32:title and not (@type)]$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'author', 'corporate', $$//mods32:mods/mods32:name[@type='corporate']/mods32:namePart[../mods32:role/mods32:roleTerm[text()='creator']]$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'author', 'personal', $$//mods32:mods/mods32:name[@type='personal']/mods32:namePart[../mods32:role/mods32:roleTerm[text()='creator']]$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'author', 'conference', $$//mods32:mods/mods32:name[@type='conference']/mods32:namePart[../mods32:role/mods32:roleTerm[text()='creator']]$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'author', 'other', $$//mods32:mods/mods32:name[@type='personal']/mods32:namePart[not(../mods32:role)]$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'subject', 'geographic', $$//mods32:mods/mods32:subject/mods32:geographic$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'subject', 'name', $$//mods32:mods/mods32:subject/mods32:name$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'subject', 'temporal', $$//mods32:mods/mods32:subject/mods32:temporal$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'subject', 'topic', $$//mods32:mods/mods32:subject/mods32:topic$$ );
--INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
--  ( field_class, name, xpath ) VALUES ( 'subject', 'genre', $$//mods32:mods/mods32:genre$$ );
INSERT INTO config.metabib_field ( field_class, name, xpath ) VALUES 
    ( 'keyword', 'keyword', $$//mods32:mods/*[not(local-name()='originInfo')]$$ ); -- /* to fool vim */;

INSERT INTO config.non_cataloged_type ( id, owning_lib, name ) VALUES ( 1, 1, oils_i18n_gettext(1, 'Paperback Book', 'cnct', 'name') );
SELECT SETVAL('config.non_cataloged_type_id_seq'::TEXT, 100);

INSERT INTO config.identification_type ( id, name ) VALUES 
    ( 1, oils_i18n_gettext(1, 'Drivers License', 'cit', 'name') );
INSERT INTO config.identification_type ( id, name ) VALUES 
    ( 2, oils_i18n_gettext(2, 'SSN', 'cit', 'name') );
INSERT INTO config.identification_type ( id, name ) VALUES 
    ( 3, oils_i18n_gettext(3, 'Other', 'cit', 'name') );
SELECT SETVAL('config.identification_type_id_seq'::TEXT, 100);

INSERT INTO config.rule_circ_duration VALUES 
    (1, oils_i18n_gettext(1, '7_days_0_renew', 'crcd', 'name'), '7 days', '7 days', '7 days', 0);
INSERT INTO config.rule_circ_duration VALUES 
    (2, oils_i18n_gettext(2, '28_days_2_renew', 'crcd', 'name'), '28 days', '28 days', '28 days', 2);
INSERT INTO config.rule_circ_duration VALUES 
    (3, oils_i18n_gettext(3, '3_months_0_renew', 'crcd', 'name'), '3 months', '3 months', '3 months', 0);
INSERT INTO config.rule_circ_duration VALUES 
    (4, oils_i18n_gettext(4, '3_days_1_renew', 'crcd', 'name'), '3 days', '3 days', '3 days', 1);
INSERT INTO config.rule_circ_duration VALUES 
    (5, oils_i18n_gettext(5, '2_months_2_renew', 'crcd', 'name'), '2 months', '2 months', '2 months', 2);
INSERT INTO config.rule_circ_duration VALUES 
    (6, oils_i18n_gettext(6, '35_days_1_renew', 'crcd', 'name'), '35 days', '35 days', '35 days', 1);
INSERT INTO config.rule_circ_duration VALUES 
    (7, oils_i18n_gettext(7, '7_days_2_renew', 'crcd', 'name'), '7 days', '7 days', '7 days', 2);
INSERT INTO config.rule_circ_duration VALUES 
    (8, oils_i18n_gettext(8, '1_hour_2_renew', 'crcd', 'name'), '1 hour', '1 hour', '1 hour', 2);
INSERT INTO config.rule_circ_duration VALUES 
    (9, oils_i18n_gettext(9, '28_days_0_renew', 'crcd', 'name'), '28 days', '28 days', '28 days', 0);
INSERT INTO config.rule_circ_duration VALUES 
    (10, oils_i18n_gettext(10, '14_days_2_renew', 'crcd', 'name'), '14 days', '14 days', '14 days', 2);
INSERT INTO config.rule_circ_duration VALUES 
    (11, oils_i18n_gettext(11, 'default', 'crcd', 'name'), '21 days', '14 days', '7 days', 2);
SELECT SETVAL('config.rule_circ_duration_id_seq'::TEXT, 100);

INSERT INTO config.rule_max_fine VALUES 
    (1, oils_i18n_gettext(1, 'default', 'crmf', 'name'), 5.00);
INSERT INTO config.rule_max_fine VALUES 
    (2, oils_i18n_gettext(2, 'overdue_min', 'crmf', 'name'), 5.00);
INSERT INTO config.rule_max_fine VALUES 
    (3, oils_i18n_gettext(3, 'overdue_mid', 'crmf', 'name'), 10.00);
INSERT INTO config.rule_max_fine VALUES 
    (4, oils_i18n_gettext(4, 'overdue_max', 'crmf', 'name'), 100.00);
INSERT INTO config.rule_max_fine VALUES 
    (5, oils_i18n_gettext(5, 'overdue_equip_min', 'crmf', 'name'), 25.00);
INSERT INTO config.rule_max_fine VALUES 
    (6, oils_i18n_gettext(6, 'overdue_equip_mid', 'crmf', 'name'), 25.00);
INSERT INTO config.rule_max_fine VALUES 
    (7, oils_i18n_gettext(7, 'overdue_equip_max', 'crmf', 'name'), 100.00);
SELECT SETVAL('config.rule_max_fine_id_seq'::TEXT, 100);

INSERT INTO config.rule_recuring_fine VALUES 
    (1, oils_i18n_gettext(1, 'default', 'crrf', 'name'), 0.50, 0.10, 0.05, '1 day');
INSERT INTO config.rule_recuring_fine VALUES 
    (2, oils_i18n_gettext(2, '10_cent_per_day', 'crrf', 'name'), 0.50, 0.10, 0.10, '1 day');
INSERT INTO config.rule_recuring_fine VALUES 
    (3, oils_i18n_gettext(3, '50_cent_per_day', 'crrf', 'name'), 0.50, 0.50, 0.50, '1 day');
SELECT SETVAL('config.rule_recuring_fine_id_seq'::TEXT, 100);

INSERT INTO config.rule_age_hold_protect VALUES
	(1, oils_i18n_gettext(1, '3month', 'crahp', 'name'), '3 months', 0);
INSERT INTO config.rule_age_hold_protect VALUES
	(2, oils_i18n_gettext(2, '6month', 'crahp', 'name'), '6 months', 2);
SELECT SETVAL('config.rule_age_hold_protect_id_seq'::TEXT, 100);

INSERT INTO config.copy_status (id,name,holdable,opac_visible) VALUES (0,oils_i18n_gettext(0, 'Available', 'ccs', 'name'),'t','t');
INSERT INTO config.copy_status (id,name,holdable,opac_visible) VALUES (1,oils_i18n_gettext(1, 'Checked out', 'ccs', 'name'),'t','t');
INSERT INTO config.copy_status (id,name) VALUES (2,oils_i18n_gettext(2, 'Bindery', 'ccs', 'name'));
INSERT INTO config.copy_status (id,name) VALUES (3,oils_i18n_gettext(3, 'Lost', 'ccs', 'name'));
INSERT INTO config.copy_status (id,name) VALUES (4,oils_i18n_gettext(4, 'Missing', 'ccs', 'name'));
INSERT INTO config.copy_status (id,name,holdable,opac_visible) VALUES (5,oils_i18n_gettext(5, 'In process', 'ccs', 'name'),'t','t');
INSERT INTO config.copy_status (id,name,holdable,opac_visible) VALUES (6,oils_i18n_gettext(6, 'In transit', 'ccs', 'name'),'t','t');
INSERT INTO config.copy_status (id,name,holdable,opac_visible) VALUES (7,oils_i18n_gettext(7, 'Reshelving', 'ccs', 'name'),'t','t');
INSERT INTO config.copy_status (id,name,holdable,opac_visible) VALUES (8,oils_i18n_gettext(8, 'On holds shelf', 'ccs', 'name'),'t','t');
INSERT INTO config.copy_status (id,name,holdable,opac_visible) VALUES (9,oils_i18n_gettext(9, 'On order', 'ccs', 'name'),'t','t');
INSERT INTO config.copy_status (id,name) VALUES (10,oils_i18n_gettext(10, 'ILL', 'ccs', 'name'));
INSERT INTO config.copy_status (id,name) VALUES (11,oils_i18n_gettext(11, 'Cataloging', 'ccs', 'name'));
INSERT INTO config.copy_status (id,name,opac_visible) VALUES (12,oils_i18n_gettext(12, 'Reserves', 'ccs', 'name'),'t');
INSERT INTO config.copy_status (id,name) VALUES (13,oils_i18n_gettext(13, 'Discard/Weed', 'ccs', 'name'));
INSERT INTO config.copy_status (id,name) VALUES (14,oils_i18n_gettext(14, 'Damaged', 'ccs', 'name'));

SELECT SETVAL('config.copy_status_id_seq'::TEXT, 100);

INSERT INTO config.net_access_level (id, name) VALUES 
    (1, oils_i18n_gettext(1, 'Filtered', 'cnal', 'name'));
INSERT INTO config.net_access_level (id, name) VALUES 
    (2, oils_i18n_gettext(2, 'Unfiltered', 'cnal', 'name'));
INSERT INTO config.net_access_level (id, name) VALUES 
    (3, oils_i18n_gettext(3, 'No Access', 'cnal', 'name'));
SELECT SETVAL('config.net_access_level_id_seq'::TEXT, 100);

INSERT INTO config.audience_map (code, value, description) VALUES 
    ('', oils_i18n_gettext('', 'Unknown or unspecified', 'cam', 'value'), 
	oils_i18n_gettext('', 'The target audience for the item not known or not specified.', 'cam', 'description'));
INSERT INTO config.audience_map (code, value, description) VALUES 
    ('a', oils_i18n_gettext('a', 'Preschool', 'cam', 'value'),
	oils_i18n_gettext('a', 'The item is intended for children, approximate ages 0-5 years.', 'cam', 'description'));
INSERT INTO config.audience_map (code, value, description) VALUES 
    ('b', oils_i18n_gettext('b', 'Primary', 'cam', 'value'),
	oils_i18n_gettext('b', 'The item is intended for children, approximate ages 6-8 years.', 'cam', 'description'));
INSERT INTO config.audience_map (code, value, description) VALUES 
    ('c', oils_i18n_gettext('c', 'Pre-adolescent', 'cam', 'value'),
	oils_i18n_gettext('c', 'The item is intended for young people, approximate ages 9-13 years.', 'cam', 'description'));
INSERT INTO config.audience_map (code, value, description) VALUES 
    ('d', oils_i18n_gettext('d', 'Adolescent', 'cam', 'value'),
    oils_i18n_gettext('d', 'The item is intended for young people, approximate ages 14-17 years.', 'cam', 'description'));
INSERT INTO config.audience_map (code, value, description) VALUES 
    ('e', oils_i18n_gettext('e', 'Adult', 'cam', 'value'),
	oils_i18n_gettext('e', 'The item is intended for adults.', 'cam', 'description'));
INSERT INTO config.audience_map (code, value, description) VALUES 
    ('f', oils_i18n_gettext('f', 'Specialized', 'cam', 'value'),
	oils_i18n_gettext('f', 'The item is aimed at a particular audience and the nature of the presentation makes the item of little interest to another audience.', 'cam', 'description'));
INSERT INTO config.audience_map (code, value, description) VALUES 
    ('g', oils_i18n_gettext('g', 'General', 'cam', 'value'),
	oils_i18n_gettext('g', 'The item is of general interest and not aimed at an audience of a particular intellectual level.', 'cam', 'description'));
INSERT INTO config.audience_map (code, value, description) VALUES 
    ('j', oils_i18n_gettext('j', 'Juvenile', 'cam', 'value'),
	oils_i18n_gettext('j', 'The item is intended for children and young people, approximate ages 0-15 years.', 'cam', 'description'));

INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('0', oils_i18n_gettext('0', 'Not fiction (not further specified)', 'clfm', 'value'),
	oils_i18n_gettext('0', 'The item is not a work of fiction and no further identification of the literary form is desired', 'clfm', 'description'));
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('1', oils_i18n_gettext('1', 'Fiction (not further specified)', 'clfm', 'value'),
	oils_i18n_gettext('1', 'The item is a work of fiction and no further identification of the literary form is desired', 'clfm', 'description'));
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('c', oils_i18n_gettext('c', 'Comic strips', 'clfm', 'value'), NULL);
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('d', oils_i18n_gettext('d', 'Dramas', 'clfm', 'value'), NULL);
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('e', oils_i18n_gettext('e', 'Essays', 'clfm', 'value'), NULL);
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('f', oils_i18n_gettext('f', 'Novels', 'clfm', 'value'), NULL);
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('h', oils_i18n_gettext('h', 'Humor, satires, etc.', 'clfm', 'value'),
	oils_i18n_gettext('h', 'The item is a humorous work, satire or of similar literary form.', 'clfm', 'description'));
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('i', oils_i18n_gettext('i', 'Letters', 'clfm', 'value'),
	oils_i18n_gettext('i', 'The item is a single letter or collection of correspondence.', 'clfm', 'description'));
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('j', oils_i18n_gettext('j', 'Short stories', 'clfm', 'value'),
	oils_i18n_gettext('j', 'The item is a short story or collection of short stories.', 'clfm', 'description'));
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('m', oils_i18n_gettext('m', 'Mixed forms', 'clfm', 'value'),
	oils_i18n_gettext('m', 'The item is a variety of literary forms (e.g., poetry and short stories).', 'clfm', 'description'));
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('p', oils_i18n_gettext('p', 'Poetry', 'clfm', 'value'),
	oils_i18n_gettext('p', 'The item is a poem or collection of poems.', 'clfm', 'description'));
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('s', oils_i18n_gettext('s', 'Speeches', 'clfm', 'value'),
	oils_i18n_gettext('s', 'The item is a speech or collection of speeches.', 'clfm', 'description'));
INSERT INTO config.lit_form_map (code, value, description) VALUES 
    ('u', oils_i18n_gettext('u', 'Unknown', 'clfm', 'value'),
	oils_i18n_gettext('u', 'The literary form of the item is unknown.', 'clfm', 'description'));

-- TO-DO: Auto-generate these values from CLDR
-- XXX These are the values used in MARC records ... does that match CLDR, including deprecated languages?
INSERT INTO config.language_map (code, value) VALUES ('aar', oils_i18n_gettext('aar', 'Afar', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('abk', oils_i18n_gettext('abk', 'Abkhaz', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ace', oils_i18n_gettext('ace', 'Achinese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ach', oils_i18n_gettext('ach', 'Acoli', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ada', oils_i18n_gettext('ada', 'Adangme', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ady', oils_i18n_gettext('ady', 'Adygei', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('afa', oils_i18n_gettext('afa', 'Afroasiatic (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('afh', oils_i18n_gettext('afh', 'Afrihili (Artificial language)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('afr', oils_i18n_gettext('afr', 'Afrikaans', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-ajm', oils_i18n_gettext('-ajm', 'Aljamía', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('aka', oils_i18n_gettext('aka', 'Akan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('akk', oils_i18n_gettext('akk', 'Akkadian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('alb', oils_i18n_gettext('alb', 'Albanian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ale', oils_i18n_gettext('ale', 'Aleut', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('alg', oils_i18n_gettext('alg', 'Algonquian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('amh', oils_i18n_gettext('amh', 'Amharic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ang', oils_i18n_gettext('ang', 'English, Old (ca. 450-1100)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('apa', oils_i18n_gettext('apa', 'Apache languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ara', oils_i18n_gettext('ara', 'Arabic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('arc', oils_i18n_gettext('arc', 'Aramaic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('arg', oils_i18n_gettext('arg', 'Aragonese Spanish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('arm', oils_i18n_gettext('arm', 'Armenian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('arn', oils_i18n_gettext('arn', 'Mapuche', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('arp', oils_i18n_gettext('arp', 'Arapaho', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('art', oils_i18n_gettext('art', 'Artificial (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('arw', oils_i18n_gettext('arw', 'Arawak', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('asm', oils_i18n_gettext('asm', 'Assamese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ast', oils_i18n_gettext('ast', 'Bable', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ath', oils_i18n_gettext('ath', 'Athapascan (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('aus', oils_i18n_gettext('aus', 'Australian languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ava', oils_i18n_gettext('ava', 'Avaric', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ave', oils_i18n_gettext('ave', 'Avestan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('awa', oils_i18n_gettext('awa', 'Awadhi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('aym', oils_i18n_gettext('aym', 'Aymara', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('aze', oils_i18n_gettext('aze', 'Azerbaijani', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bad', oils_i18n_gettext('bad', 'Banda', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bai', oils_i18n_gettext('bai', 'Bamileke languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bak', oils_i18n_gettext('bak', 'Bashkir', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bal', oils_i18n_gettext('bal', 'Baluchi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bam', oils_i18n_gettext('bam', 'Bambara', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ban', oils_i18n_gettext('ban', 'Balinese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('baq', oils_i18n_gettext('baq', 'Basque', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bas', oils_i18n_gettext('bas', 'Basa', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bat', oils_i18n_gettext('bat', 'Baltic (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bej', oils_i18n_gettext('bej', 'Beja', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bel', oils_i18n_gettext('bel', 'Belarusian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bem', oils_i18n_gettext('bem', 'Bemba', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ben', oils_i18n_gettext('ben', 'Bengali', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ber', oils_i18n_gettext('ber', 'Berber (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bho', oils_i18n_gettext('bho', 'Bhojpuri', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bih', oils_i18n_gettext('bih', 'Bihari', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bik', oils_i18n_gettext('bik', 'Bikol', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bin', oils_i18n_gettext('bin', 'Edo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bis', oils_i18n_gettext('bis', 'Bislama', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bla', oils_i18n_gettext('bla', 'Siksika', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bnt', oils_i18n_gettext('bnt', 'Bantu (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bos', oils_i18n_gettext('bos', 'Bosnian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bra', oils_i18n_gettext('bra', 'Braj', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bre', oils_i18n_gettext('bre', 'Breton', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('btk', oils_i18n_gettext('btk', 'Batak', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bua', oils_i18n_gettext('bua', 'Buriat', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bug', oils_i18n_gettext('bug', 'Bugis', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bul', oils_i18n_gettext('bul', 'Bulgarian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('bur', oils_i18n_gettext('bur', 'Burmese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cad', oils_i18n_gettext('cad', 'Caddo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cai', oils_i18n_gettext('cai', 'Central American Indian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-cam', oils_i18n_gettext('-cam', 'Khmer', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('car', oils_i18n_gettext('car', 'Carib', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cat', oils_i18n_gettext('cat', 'Catalan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cau', oils_i18n_gettext('cau', 'Caucasian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ceb', oils_i18n_gettext('ceb', 'Cebuano', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cel', oils_i18n_gettext('cel', 'Celtic (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cha', oils_i18n_gettext('cha', 'Chamorro', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chb', oils_i18n_gettext('chb', 'Chibcha', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('che', oils_i18n_gettext('che', 'Chechen', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chg', oils_i18n_gettext('chg', 'Chagatai', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chi', oils_i18n_gettext('chi', 'Chinese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chk', oils_i18n_gettext('chk', 'Truk', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chm', oils_i18n_gettext('chm', 'Mari', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chn', oils_i18n_gettext('chn', 'Chinook jargon', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cho', oils_i18n_gettext('cho', 'Choctaw', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chp', oils_i18n_gettext('chp', 'Chipewyan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chr', oils_i18n_gettext('chr', 'Cherokee', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chu', oils_i18n_gettext('chu', 'Church Slavic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chv', oils_i18n_gettext('chv', 'Chuvash', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('chy', oils_i18n_gettext('chy', 'Cheyenne', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cmc', oils_i18n_gettext('cmc', 'Chamic languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cop', oils_i18n_gettext('cop', 'Coptic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cor', oils_i18n_gettext('cor', 'Cornish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cos', oils_i18n_gettext('cos', 'Corsican', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cpe', oils_i18n_gettext('cpe', 'Creoles and Pidgins, English-based (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cpf', oils_i18n_gettext('cpf', 'Creoles and Pidgins, French-based (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cpp', oils_i18n_gettext('cpp', 'Creoles and Pidgins, Portuguese-based (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cre', oils_i18n_gettext('cre', 'Cree', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('crh', oils_i18n_gettext('crh', 'Crimean Tatar', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('crp', oils_i18n_gettext('crp', 'Creoles and Pidgins (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cus', oils_i18n_gettext('cus', 'Cushitic (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('cze', oils_i18n_gettext('cze', 'Czech', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dak', oils_i18n_gettext('dak', 'Dakota', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dan', oils_i18n_gettext('dan', 'Danish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dar', oils_i18n_gettext('dar', 'Dargwa', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('day', oils_i18n_gettext('day', 'Dayak', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('del', oils_i18n_gettext('del', 'Delaware', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('den', oils_i18n_gettext('den', 'Slave', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dgr', oils_i18n_gettext('dgr', 'Dogrib', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('din', oils_i18n_gettext('din', 'Dinka', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('div', oils_i18n_gettext('div', 'Divehi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('doi', oils_i18n_gettext('doi', 'Dogri', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dra', oils_i18n_gettext('dra', 'Dravidian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dua', oils_i18n_gettext('dua', 'Duala', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dum', oils_i18n_gettext('dum', 'Dutch, Middle (ca. 1050-1350)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dut', oils_i18n_gettext('dut', 'Dutch', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dyu', oils_i18n_gettext('dyu', 'Dyula', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('dzo', oils_i18n_gettext('dzo', 'Dzongkha', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('efi', oils_i18n_gettext('efi', 'Efik', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('egy', oils_i18n_gettext('egy', 'Egyptian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('eka', oils_i18n_gettext('eka', 'Ekajuk', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('elx', oils_i18n_gettext('elx', 'Elamite', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('eng', oils_i18n_gettext('eng', 'English', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('enm', oils_i18n_gettext('enm', 'English, Middle (1100-1500)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('epo', oils_i18n_gettext('epo', 'Esperanto', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-esk', oils_i18n_gettext('-esk', 'Eskimo languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-esp', oils_i18n_gettext('-esp', 'Esperanto', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('est', oils_i18n_gettext('est', 'Estonian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-eth', oils_i18n_gettext('-eth', 'Ethiopic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ewe', oils_i18n_gettext('ewe', 'Ewe', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ewo', oils_i18n_gettext('ewo', 'Ewondo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fan', oils_i18n_gettext('fan', 'Fang', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fao', oils_i18n_gettext('fao', 'Faroese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-far', oils_i18n_gettext('-far', 'Faroese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fat', oils_i18n_gettext('fat', 'Fanti', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fij', oils_i18n_gettext('fij', 'Fijian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fin', oils_i18n_gettext('fin', 'Finnish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fiu', oils_i18n_gettext('fiu', 'Finno-Ugrian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fon', oils_i18n_gettext('fon', 'Fon', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fre', oils_i18n_gettext('fre', 'French', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-fri', oils_i18n_gettext('-fri', 'Frisian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('frm', oils_i18n_gettext('frm', 'French, Middle (ca. 1400-1600)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fro', oils_i18n_gettext('fro', 'French, Old (ca. 842-1400)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fry', oils_i18n_gettext('fry', 'Frisian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ful', oils_i18n_gettext('ful', 'Fula', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('fur', oils_i18n_gettext('fur', 'Friulian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gaa', oils_i18n_gettext('gaa', 'Gã', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-gae', oils_i18n_gettext('-gae', 'Scottish Gaelic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-gag', oils_i18n_gettext('-gag', 'Galician', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-gal', oils_i18n_gettext('-gal', 'Oromo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gay', oils_i18n_gettext('gay', 'Gayo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gba', oils_i18n_gettext('gba', 'Gbaya', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gem', oils_i18n_gettext('gem', 'Germanic (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('geo', oils_i18n_gettext('geo', 'Georgian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ger', oils_i18n_gettext('ger', 'German', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gez', oils_i18n_gettext('gez', 'Ethiopic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gil', oils_i18n_gettext('gil', 'Gilbertese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gla', oils_i18n_gettext('gla', 'Scottish Gaelic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gle', oils_i18n_gettext('gle', 'Irish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('glg', oils_i18n_gettext('glg', 'Galician', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('glv', oils_i18n_gettext('glv', 'Manx', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gmh', oils_i18n_gettext('gmh', 'German, Middle High (ca. 1050-1500)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('goh', oils_i18n_gettext('goh', 'German, Old High (ca. 750-1050)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gon', oils_i18n_gettext('gon', 'Gondi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gor', oils_i18n_gettext('gor', 'Gorontalo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('got', oils_i18n_gettext('got', 'Gothic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('grb', oils_i18n_gettext('grb', 'Grebo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('grc', oils_i18n_gettext('grc', 'Greek, Ancient (to 1453)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gre', oils_i18n_gettext('gre', 'Greek, Modern (1453- )', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('grn', oils_i18n_gettext('grn', 'Guarani', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-gua', oils_i18n_gettext('-gua', 'Guarani', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('guj', oils_i18n_gettext('guj', 'Gujarati', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('gwi', oils_i18n_gettext('gwi', 'Gwich', 'clm', 'value''in'));
INSERT INTO config.language_map (code, value) VALUES ('hai', oils_i18n_gettext('hai', 'Haida', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('hat', oils_i18n_gettext('hat', 'Haitian French Creole', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('hau', oils_i18n_gettext('hau', 'Hausa', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('haw', oils_i18n_gettext('haw', 'Hawaiian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('heb', oils_i18n_gettext('heb', 'Hebrew', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('her', oils_i18n_gettext('her', 'Herero', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('hil', oils_i18n_gettext('hil', 'Hiligaynon', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('him', oils_i18n_gettext('him', 'Himachali', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('hin', oils_i18n_gettext('hin', 'Hindi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('hit', oils_i18n_gettext('hit', 'Hittite', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('hmn', oils_i18n_gettext('hmn', 'Hmong', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('hmo', oils_i18n_gettext('hmo', 'Hiri Motu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('hun', oils_i18n_gettext('hun', 'Hungarian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('hup', oils_i18n_gettext('hup', 'Hupa', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('iba', oils_i18n_gettext('iba', 'Iban', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ibo', oils_i18n_gettext('ibo', 'Igbo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ice', oils_i18n_gettext('ice', 'Icelandic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ido', oils_i18n_gettext('ido', 'Ido', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('iii', oils_i18n_gettext('iii', 'Sichuan Yi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ijo', oils_i18n_gettext('ijo', 'Ijo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('iku', oils_i18n_gettext('iku', 'Inuktitut', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ile', oils_i18n_gettext('ile', 'Interlingue', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ilo', oils_i18n_gettext('ilo', 'Iloko', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ina', oils_i18n_gettext('ina', 'Interlingua (International Auxiliary Language Association)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('inc', oils_i18n_gettext('inc', 'Indic (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ind', oils_i18n_gettext('ind', 'Indonesian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ine', oils_i18n_gettext('ine', 'Indo-European (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('inh', oils_i18n_gettext('inh', 'Ingush', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-int', oils_i18n_gettext('-int', 'Interlingua (International Auxiliary Language Association)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ipk', oils_i18n_gettext('ipk', 'Inupiaq', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ira', oils_i18n_gettext('ira', 'Iranian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-iri', oils_i18n_gettext('-iri', 'Irish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('iro', oils_i18n_gettext('iro', 'Iroquoian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ita', oils_i18n_gettext('ita', 'Italian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('jav', oils_i18n_gettext('jav', 'Javanese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('jpn', oils_i18n_gettext('jpn', 'Japanese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('jpr', oils_i18n_gettext('jpr', 'Judeo-Persian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('jrb', oils_i18n_gettext('jrb', 'Judeo-Arabic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kaa', oils_i18n_gettext('kaa', 'Kara-Kalpak', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kab', oils_i18n_gettext('kab', 'Kabyle', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kac', oils_i18n_gettext('kac', 'Kachin', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kal', oils_i18n_gettext('kal', 'Kalâtdlisut', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kam', oils_i18n_gettext('kam', 'Kamba', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kan', oils_i18n_gettext('kan', 'Kannada', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kar', oils_i18n_gettext('kar', 'Karen', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kas', oils_i18n_gettext('kas', 'Kashmiri', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kau', oils_i18n_gettext('kau', 'Kanuri', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kaw', oils_i18n_gettext('kaw', 'Kawi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kaz', oils_i18n_gettext('kaz', 'Kazakh', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kbd', oils_i18n_gettext('kbd', 'Kabardian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kha', oils_i18n_gettext('kha', 'Khasi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('khi', oils_i18n_gettext('khi', 'Khoisan (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('khm', oils_i18n_gettext('khm', 'Khmer', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kho', oils_i18n_gettext('kho', 'Khotanese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kik', oils_i18n_gettext('kik', 'Kikuyu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kin', oils_i18n_gettext('kin', 'Kinyarwanda', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kir', oils_i18n_gettext('kir', 'Kyrgyz', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kmb', oils_i18n_gettext('kmb', 'Kimbundu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kok', oils_i18n_gettext('kok', 'Konkani', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kom', oils_i18n_gettext('kom', 'Komi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kon', oils_i18n_gettext('kon', 'Kongo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kor', oils_i18n_gettext('kor', 'Korean', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kos', oils_i18n_gettext('kos', 'Kusaie', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kpe', oils_i18n_gettext('kpe', 'Kpelle', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kro', oils_i18n_gettext('kro', 'Kru', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kru', oils_i18n_gettext('kru', 'Kurukh', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kua', oils_i18n_gettext('kua', 'Kuanyama', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kum', oils_i18n_gettext('kum', 'Kumyk', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kur', oils_i18n_gettext('kur', 'Kurdish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-kus', oils_i18n_gettext('-kus', 'Kusaie', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('kut', oils_i18n_gettext('kut', 'Kutenai', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lad', oils_i18n_gettext('lad', 'Ladino', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lah', oils_i18n_gettext('lah', 'Lahnda', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lam', oils_i18n_gettext('lam', 'Lamba', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-lan', oils_i18n_gettext('-lan', 'Occitan (post-1500)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lao', oils_i18n_gettext('lao', 'Lao', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-lap', oils_i18n_gettext('-lap', 'Sami', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lat', oils_i18n_gettext('lat', 'Latin', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lav', oils_i18n_gettext('lav', 'Latvian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lez', oils_i18n_gettext('lez', 'Lezgian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lim', oils_i18n_gettext('lim', 'Limburgish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lin', oils_i18n_gettext('lin', 'Lingala', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lit', oils_i18n_gettext('lit', 'Lithuanian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lol', oils_i18n_gettext('lol', 'Mongo-Nkundu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('loz', oils_i18n_gettext('loz', 'Lozi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ltz', oils_i18n_gettext('ltz', 'Letzeburgesch', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lua', oils_i18n_gettext('lua', 'Luba-Lulua', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lub', oils_i18n_gettext('lub', 'Luba-Katanga', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lug', oils_i18n_gettext('lug', 'Ganda', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lui', oils_i18n_gettext('lui', 'Luiseño', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lun', oils_i18n_gettext('lun', 'Lunda', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('luo', oils_i18n_gettext('luo', 'Luo (Kenya and Tanzania)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('lus', oils_i18n_gettext('lus', 'Lushai', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mac', oils_i18n_gettext('mac', 'Macedonian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mad', oils_i18n_gettext('mad', 'Madurese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mag', oils_i18n_gettext('mag', 'Magahi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mah', oils_i18n_gettext('mah', 'Marshallese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mai', oils_i18n_gettext('mai', 'Maithili', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mak', oils_i18n_gettext('mak', 'Makasar', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mal', oils_i18n_gettext('mal', 'Malayalam', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('man', oils_i18n_gettext('man', 'Mandingo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mao', oils_i18n_gettext('mao', 'Maori', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('map', oils_i18n_gettext('map', 'Austronesian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mar', oils_i18n_gettext('mar', 'Marathi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mas', oils_i18n_gettext('mas', 'Masai', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-max', oils_i18n_gettext('-max', 'Manx', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('may', oils_i18n_gettext('may', 'Malay', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mdr', oils_i18n_gettext('mdr', 'Mandar', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('men', oils_i18n_gettext('men', 'Mende', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mga', oils_i18n_gettext('mga', 'Irish, Middle (ca. 1100-1550)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mic', oils_i18n_gettext('mic', 'Micmac', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('min', oils_i18n_gettext('min', 'Minangkabau', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mis', oils_i18n_gettext('mis', 'Miscellaneous languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mkh', oils_i18n_gettext('mkh', 'Mon-Khmer (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-mla', oils_i18n_gettext('-mla', 'Malagasy', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mlg', oils_i18n_gettext('mlg', 'Malagasy', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mlt', oils_i18n_gettext('mlt', 'Maltese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mnc', oils_i18n_gettext('mnc', 'Manchu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mni', oils_i18n_gettext('mni', 'Manipuri', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mno', oils_i18n_gettext('mno', 'Manobo languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('moh', oils_i18n_gettext('moh', 'Mohawk', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mol', oils_i18n_gettext('mol', 'Moldavian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mon', oils_i18n_gettext('mon', 'Mongolian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mos', oils_i18n_gettext('mos', 'Mooré', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mul', oils_i18n_gettext('mul', 'Multiple languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mun', oils_i18n_gettext('mun', 'Munda (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mus', oils_i18n_gettext('mus', 'Creek', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('mwr', oils_i18n_gettext('mwr', 'Marwari', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('myn', oils_i18n_gettext('myn', 'Mayan languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nah', oils_i18n_gettext('nah', 'Nahuatl', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nai', oils_i18n_gettext('nai', 'North American Indian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nap', oils_i18n_gettext('nap', 'Neapolitan Italian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nau', oils_i18n_gettext('nau', 'Nauru', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nav', oils_i18n_gettext('nav', 'Navajo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nbl', oils_i18n_gettext('nbl', 'Ndebele (South Africa)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nde', oils_i18n_gettext('nde', 'Ndebele (Zimbabwe)  ', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ndo', oils_i18n_gettext('ndo', 'Ndonga', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nds', oils_i18n_gettext('nds', 'Low German', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nep', oils_i18n_gettext('nep', 'Nepali', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('new', oils_i18n_gettext('new', 'Newari', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nia', oils_i18n_gettext('nia', 'Nias', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nic', oils_i18n_gettext('nic', 'Niger-Kordofanian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('niu', oils_i18n_gettext('niu', 'Niuean', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nno', oils_i18n_gettext('nno', 'Norwegian (Nynorsk)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nob', oils_i18n_gettext('nob', 'Norwegian (Bokmål)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nog', oils_i18n_gettext('nog', 'Nogai', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('non', oils_i18n_gettext('non', 'Old Norse', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nor', oils_i18n_gettext('nor', 'Norwegian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nso', oils_i18n_gettext('nso', 'Northern Sotho', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nub', oils_i18n_gettext('nub', 'Nubian languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nya', oils_i18n_gettext('nya', 'Nyanja', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nym', oils_i18n_gettext('nym', 'Nyamwezi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nyn', oils_i18n_gettext('nyn', 'Nyankole', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nyo', oils_i18n_gettext('nyo', 'Nyoro', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('nzi', oils_i18n_gettext('nzi', 'Nzima', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('oci', oils_i18n_gettext('oci', 'Occitan (post-1500)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('oji', oils_i18n_gettext('oji', 'Ojibwa', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ori', oils_i18n_gettext('ori', 'Oriya', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('orm', oils_i18n_gettext('orm', 'Oromo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('osa', oils_i18n_gettext('osa', 'Osage', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('oss', oils_i18n_gettext('oss', 'Ossetic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ota', oils_i18n_gettext('ota', 'Turkish, Ottoman', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('oto', oils_i18n_gettext('oto', 'Otomian languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('paa', oils_i18n_gettext('paa', 'Papuan (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pag', oils_i18n_gettext('pag', 'Pangasinan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pal', oils_i18n_gettext('pal', 'Pahlavi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pam', oils_i18n_gettext('pam', 'Pampanga', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pan', oils_i18n_gettext('pan', 'Panjabi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pap', oils_i18n_gettext('pap', 'Papiamento', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pau', oils_i18n_gettext('pau', 'Palauan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('peo', oils_i18n_gettext('peo', 'Old Persian (ca. 600-400 B.C.)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('per', oils_i18n_gettext('per', 'Persian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('phi', oils_i18n_gettext('phi', 'Philippine (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('phn', oils_i18n_gettext('phn', 'Phoenician', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pli', oils_i18n_gettext('pli', 'Pali', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pol', oils_i18n_gettext('pol', 'Polish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pon', oils_i18n_gettext('pon', 'Ponape', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('por', oils_i18n_gettext('por', 'Portuguese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pra', oils_i18n_gettext('pra', 'Prakrit languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pro', oils_i18n_gettext('pro', 'Provençal (to 1500)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('pus', oils_i18n_gettext('pus', 'Pushto', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('que', oils_i18n_gettext('que', 'Quechua', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('raj', oils_i18n_gettext('raj', 'Rajasthani', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('rap', oils_i18n_gettext('rap', 'Rapanui', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('rar', oils_i18n_gettext('rar', 'Rarotongan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('roa', oils_i18n_gettext('roa', 'Romance (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('roh', oils_i18n_gettext('roh', 'Raeto-Romance', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('rom', oils_i18n_gettext('rom', 'Romani', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('rum', oils_i18n_gettext('rum', 'Romanian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('run', oils_i18n_gettext('run', 'Rundi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('rus', oils_i18n_gettext('rus', 'Russian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sad', oils_i18n_gettext('sad', 'Sandawe', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sag', oils_i18n_gettext('sag', 'Sango (Ubangi Creole)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sah', oils_i18n_gettext('sah', 'Yakut', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sai', oils_i18n_gettext('sai', 'South American Indian (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sal', oils_i18n_gettext('sal', 'Salishan languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sam', oils_i18n_gettext('sam', 'Samaritan Aramaic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('san', oils_i18n_gettext('san', 'Sanskrit', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-sao', oils_i18n_gettext('-sao', 'Samoan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sas', oils_i18n_gettext('sas', 'Sasak', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sat', oils_i18n_gettext('sat', 'Santali', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('scc', oils_i18n_gettext('scc', 'Serbian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sco', oils_i18n_gettext('sco', 'Scots', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('scr', oils_i18n_gettext('scr', 'Croatian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sel', oils_i18n_gettext('sel', 'Selkup', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sem', oils_i18n_gettext('sem', 'Semitic (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sga', oils_i18n_gettext('sga', 'Irish, Old (to 1100)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sgn', oils_i18n_gettext('sgn', 'Sign languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('shn', oils_i18n_gettext('shn', 'Shan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-sho', oils_i18n_gettext('-sho', 'Shona', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sid', oils_i18n_gettext('sid', 'Sidamo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sin', oils_i18n_gettext('sin', 'Sinhalese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sio', oils_i18n_gettext('sio', 'Siouan (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sit', oils_i18n_gettext('sit', 'Sino-Tibetan (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sla', oils_i18n_gettext('sla', 'Slavic (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('slo', oils_i18n_gettext('slo', 'Slovak', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('slv', oils_i18n_gettext('slv', 'Slovenian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sma', oils_i18n_gettext('sma', 'Southern Sami', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sme', oils_i18n_gettext('sme', 'Northern Sami', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('smi', oils_i18n_gettext('smi', 'Sami', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('smj', oils_i18n_gettext('smj', 'Lule Sami', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('smn', oils_i18n_gettext('smn', 'Inari Sami', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('smo', oils_i18n_gettext('smo', 'Samoan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sms', oils_i18n_gettext('sms', 'Skolt Sami', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sna', oils_i18n_gettext('sna', 'Shona', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('snd', oils_i18n_gettext('snd', 'Sindhi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-snh', oils_i18n_gettext('-snh', 'Sinhalese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('snk', oils_i18n_gettext('snk', 'Soninke', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sog', oils_i18n_gettext('sog', 'Sogdian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('som', oils_i18n_gettext('som', 'Somali', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('son', oils_i18n_gettext('son', 'Songhai', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sot', oils_i18n_gettext('sot', 'Sotho', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('spa', oils_i18n_gettext('spa', 'Spanish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('srd', oils_i18n_gettext('srd', 'Sardinian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('srr', oils_i18n_gettext('srr', 'Serer', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ssa', oils_i18n_gettext('ssa', 'Nilo-Saharan (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-sso', oils_i18n_gettext('-sso', 'Sotho', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ssw', oils_i18n_gettext('ssw', 'Swazi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('suk', oils_i18n_gettext('suk', 'Sukuma', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sun', oils_i18n_gettext('sun', 'Sundanese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sus', oils_i18n_gettext('sus', 'Susu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('sux', oils_i18n_gettext('sux', 'Sumerian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('swa', oils_i18n_gettext('swa', 'Swahili', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('swe', oils_i18n_gettext('swe', 'Swedish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-swz', oils_i18n_gettext('-swz', 'Swazi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('syr', oils_i18n_gettext('syr', 'Syriac', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-tag', oils_i18n_gettext('-tag', 'Tagalog', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tah', oils_i18n_gettext('tah', 'Tahitian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tai', oils_i18n_gettext('tai', 'Tai (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-taj', oils_i18n_gettext('-taj', 'Tajik', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tam', oils_i18n_gettext('tam', 'Tamil', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-tar', oils_i18n_gettext('-tar', 'Tatar', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tat', oils_i18n_gettext('tat', 'Tatar', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tel', oils_i18n_gettext('tel', 'Telugu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tem', oils_i18n_gettext('tem', 'Temne', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ter', oils_i18n_gettext('ter', 'Terena', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tet', oils_i18n_gettext('tet', 'Tetum', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tgk', oils_i18n_gettext('tgk', 'Tajik', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tgl', oils_i18n_gettext('tgl', 'Tagalog', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tha', oils_i18n_gettext('tha', 'Thai', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tib', oils_i18n_gettext('tib', 'Tibetan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tig', oils_i18n_gettext('tig', 'Tigré', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tir', oils_i18n_gettext('tir', 'Tigrinya', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tiv', oils_i18n_gettext('tiv', 'Tiv', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tkl', oils_i18n_gettext('tkl', 'Tokelauan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tli', oils_i18n_gettext('tli', 'Tlingit', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tmh', oils_i18n_gettext('tmh', 'Tamashek', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tog', oils_i18n_gettext('tog', 'Tonga (Nyasa)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ton', oils_i18n_gettext('ton', 'Tongan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tpi', oils_i18n_gettext('tpi', 'Tok Pisin', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-tru', oils_i18n_gettext('-tru', 'Truk', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tsi', oils_i18n_gettext('tsi', 'Tsimshian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tsn', oils_i18n_gettext('tsn', 'Tswana', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tso', oils_i18n_gettext('tso', 'Tsonga', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('-tsw', oils_i18n_gettext('-tsw', 'Tswana', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tuk', oils_i18n_gettext('tuk', 'Turkmen', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tum', oils_i18n_gettext('tum', 'Tumbuka', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tup', oils_i18n_gettext('tup', 'Tupi languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tur', oils_i18n_gettext('tur', 'Turkish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tut', oils_i18n_gettext('tut', 'Altaic (Other)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tvl', oils_i18n_gettext('tvl', 'Tuvaluan', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('twi', oils_i18n_gettext('twi', 'Twi', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('tyv', oils_i18n_gettext('tyv', 'Tuvinian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('udm', oils_i18n_gettext('udm', 'Udmurt', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('uga', oils_i18n_gettext('uga', 'Ugaritic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('uig', oils_i18n_gettext('uig', 'Uighur', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ukr', oils_i18n_gettext('ukr', 'Ukrainian', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('umb', oils_i18n_gettext('umb', 'Umbundu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('und', oils_i18n_gettext('und', 'Undetermined', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('urd', oils_i18n_gettext('urd', 'Urdu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('uzb', oils_i18n_gettext('uzb', 'Uzbek', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('vai', oils_i18n_gettext('vai', 'Vai', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ven', oils_i18n_gettext('ven', 'Venda', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('vie', oils_i18n_gettext('vie', 'Vietnamese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('vol', oils_i18n_gettext('vol', 'Volapük', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('vot', oils_i18n_gettext('vot', 'Votic', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('wak', oils_i18n_gettext('wak', 'Wakashan languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('wal', oils_i18n_gettext('wal', 'Walamo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('war', oils_i18n_gettext('war', 'Waray', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('was', oils_i18n_gettext('was', 'Washo', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('wel', oils_i18n_gettext('wel', 'Welsh', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('wen', oils_i18n_gettext('wen', 'Sorbian languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('wln', oils_i18n_gettext('wln', 'Walloon', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('wol', oils_i18n_gettext('wol', 'Wolof', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('xal', oils_i18n_gettext('xal', 'Kalmyk', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('xho', oils_i18n_gettext('xho', 'Xhosa', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('yao', oils_i18n_gettext('yao', 'Yao (Africa)', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('yap', oils_i18n_gettext('yap', 'Yapese', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('yid', oils_i18n_gettext('yid', 'Yiddish', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('yor', oils_i18n_gettext('yor', 'Yoruba', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('ypk', oils_i18n_gettext('ypk', 'Yupik languages', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('zap', oils_i18n_gettext('zap', 'Zapotec', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('zen', oils_i18n_gettext('zen', 'Zenaga', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('zha', oils_i18n_gettext('zha', 'Zhuang', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('znd', oils_i18n_gettext('znd', 'Zande', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('zul', oils_i18n_gettext('zul', 'Zulu', 'clm', 'value'));
INSERT INTO config.language_map (code, value) VALUES ('zun', oils_i18n_gettext('zun', 'Zuni', 'clm', 'value'));

INSERT INTO config.item_form_map (code, value) VALUES ('a', oils_i18n_gettext('a', 'Microfilm', 'cifm', 'value'));
INSERT INTO config.item_form_map (code, value) VALUES ('b', oils_i18n_gettext('b', 'Microfiche', 'cifm', 'value'));
INSERT INTO config.item_form_map (code, value) VALUES ('c', oils_i18n_gettext('c', 'Microopaque', 'cifm', 'value'));
INSERT INTO config.item_form_map (code, value) VALUES ('d', oils_i18n_gettext('d', 'Large print', 'cifm', 'value'));
INSERT INTO config.item_form_map (code, value) VALUES ('f', oils_i18n_gettext('f', 'Braille', 'cifm', 'value'));
INSERT INTO config.item_form_map (code, value) VALUES ('r', oils_i18n_gettext('r', 'Regular print reproduction', 'cifm', 'value'));
INSERT INTO config.item_form_map (code, value) VALUES ('s', oils_i18n_gettext('s', 'Electronic', 'cifm', 'value'));

INSERT INTO config.item_type_map (code, value) VALUES ('a', oils_i18n_gettext('a', 'Language material', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('t', oils_i18n_gettext('t', 'Manuscript language material', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('g', oils_i18n_gettext('g', 'Projected medium', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('k', oils_i18n_gettext('k', 'Two-dimensional nonprojectable graphic', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('r', oils_i18n_gettext('r', 'Three-dimensional artifact or naturally occurring object', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('o', oils_i18n_gettext('o', 'Kit', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('p', oils_i18n_gettext('p', 'Mixed materials', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('e', oils_i18n_gettext('e', 'Cartographic material', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('f', oils_i18n_gettext('f', 'Manuscript cartographic material', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('c', oils_i18n_gettext('c', 'Notated music', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('d', oils_i18n_gettext('d', 'Manuscript notated music', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('i', oils_i18n_gettext('i', 'Nonmusical sound recording', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('j', oils_i18n_gettext('j', 'Musical sound recording', 'citm', 'value'));
INSERT INTO config.item_type_map (code, value) VALUES ('m', oils_i18n_gettext('m', 'Computer file', 'citm', 'value'));

INSERT INTO config.bib_level_map (code, value) VALUES ('a', oils_i18n_gettext('a', 'Monographic component part', 'cblvl', 'value'));
INSERT INTO config.bib_level_map (code, value) VALUES ('b', oils_i18n_gettext('b', 'Serial component part', 'cblvl', 'value'));
INSERT INTO config.bib_level_map (code, value) VALUES ('c', oils_i18n_gettext('c', 'Collection', 'cblvl', 'value'));
INSERT INTO config.bib_level_map (code, value) VALUES ('d', oils_i18n_gettext('d', 'Subunit', 'cblvl', 'value'));
INSERT INTO config.bib_level_map (code, value) VALUES ('i', oils_i18n_gettext('i', 'Integrating resource', 'cblvl', 'value'));
INSERT INTO config.bib_level_map (code, value) VALUES ('m', oils_i18n_gettext('m', 'Monograph/Item', 'cblvl', 'value'));
INSERT INTO config.bib_level_map (code, value) VALUES ('s', oils_i18n_gettext('s', 'Serial', 'cblvl', 'value'));

-- available locales
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('en-US', 'eng', oils_i18n_gettext('en-US', 'American English', 'i18n_l', 'name'),
	oils_i18n_gettext('en-US', 'American English', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('en-CA', 'eng', oils_i18n_gettext('en-CA', 'Canadian English', 'i18n_l', 'name'),
	oils_i18n_gettext('en-CA', 'Canadian English', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('fr-CA', 'fre', oils_i18n_gettext('fr-CA', 'Canadian French', 'i18n_l', 'name'),
	oils_i18n_gettext('fr-CA', 'Canadian French', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('es-US', 'spa', oils_i18n_gettext('es-US', 'American Spanish', 'i18n_l', 'name'),
	oils_i18n_gettext('es-US', 'American Spanish', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('es-MX', 'spa', oils_i18n_gettext('es-MX', 'Mexican Spanish', 'i18n_l', 'name'),
	oils_i18n_gettext('es-MX', 'Mexican Spanish', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('hy-AM', 'arm', oils_i18n_gettext('hy-AM', 'Armenian', 'i18n_l', 'name'),
	oils_i18n_gettext('hy-AM', 'Armenian', 'i18n_l', 'description'));

--005.schema.actors.sql:

-- The PINES levels
INSERT INTO actor.org_unit_type (id, name, opac_label, depth, parent, can_have_users, can_have_vols) VALUES 
    ( 1, oils_i18n_gettext(1, 'Consortium', 'aout', 'name'),
	oils_i18n_gettext(1, 'Everywhere', 'aout', 'opac_label'), 0, NULL, FALSE, FALSE );
INSERT INTO actor.org_unit_type (id, name, opac_label, depth, parent, can_have_users, can_have_vols) VALUES 
    ( 2, oils_i18n_gettext(2, 'System', 'aout', 'name'),
	oils_i18n_gettext(2, 'Local Library System', 'aout', 'opac_label'), 1, 1, FALSE, FALSE );
INSERT INTO actor.org_unit_type (id, name, opac_label, depth, parent) VALUES 
    ( 3, oils_i18n_gettext(3, 'Branch', 'aout', 'name'),
	oils_i18n_gettext(3, 'This Branch', 'aout', 'opac_label'), 2, 2 );
INSERT INTO actor.org_unit_type (id, name, opac_label, depth, parent) VALUES 
    ( 4, oils_i18n_gettext(4, 'Sub-library', 'aout', 'name'),
	oils_i18n_gettext(4, 'This Specialized Library', 'aout', 'opac_label'), 3, 3 );
INSERT INTO actor.org_unit_type (id, name, opac_label, depth, parent) VALUES 
    ( 5, oils_i18n_gettext(5, 'Bookmobile', 'aout', 'name'),
	oils_i18n_gettext(5, 'Your Bookmobile', 'aout', 'opac_label'), 3, 3 );
SELECT SETVAL('actor.org_unit_type_id_seq'::TEXT, 100);

INSERT INTO actor.org_unit (id, parent_ou, ou_type, shortname, name) VALUES 
    (1, NULL, 1, 'CONS', oils_i18n_gettext(1, 'Example Consortium', 'aou', 'name'));
INSERT INTO actor.org_unit (id, parent_ou, ou_type, shortname, name) VALUES 
    (2, 1, 2, 'SYS1', oils_i18n_gettext(2, 'Example System 1', 'aou', 'name'));
INSERT INTO actor.org_unit (id, parent_ou, ou_type, shortname, name) VALUES 
    (3, 1, 2, 'SYS2', oils_i18n_gettext(3, 'Example System 2', 'aou', 'name'));
INSERT INTO actor.org_unit (id, parent_ou, ou_type, shortname, name) VALUES 
    (4, 2, 3, 'BR1', oils_i18n_gettext(4, 'Example Branch 1', 'aou', 'name'));
INSERT INTO actor.org_unit (id, parent_ou, ou_type, shortname, name) VALUES 
    (5, 2, 3, 'BR2', oils_i18n_gettext(5, 'Example Branch 2', 'aou', 'name'));
INSERT INTO actor.org_unit (id, parent_ou, ou_type, shortname, name) VALUES 
    (6, 3, 3, 'BR3', oils_i18n_gettext(6, 'Example Branch 3', 'aou', 'name'));
INSERT INTO actor.org_unit (id, parent_ou, ou_type, shortname, name) VALUES 
    (7, 3, 3, 'BR4', oils_i18n_gettext(7, 'Example Branch 4', 'aou', 'name'));
INSERT INTO actor.org_unit (id, parent_ou, ou_type, shortname, name) VALUES 
    (8, 4, 4, 'SL1', oils_i18n_gettext(8, 'Example Sub-library 1', 'aou', 'name'));
INSERT INTO actor.org_unit (id, parent_ou, ou_type, shortname, name) VALUES 
    (9, 6, 5, 'BM1', oils_i18n_gettext(9, 'Example Bookmobile 1', 'aou', 'name'));
SELECT SETVAL('actor.org_unit_id_seq'::TEXT, 100);

INSERT INTO actor.org_address VALUES (DEFAULT,DEFAULT,DEFAULT,1,'123 Main St.',NULL,'Anywhere',NULL,'GA','US','30303');

UPDATE actor.org_unit SET holds_address = 1, ill_address = 1, billing_address = 1, mailing_address = 1;

--006.data.permissions.sql:
INSERT INTO permission.perm_list VALUES 
    (-1, 'EVERYTHING', NULL);
INSERT INTO permission.perm_list VALUES 
    (2, 'OPAC_LOGIN', NULL);
INSERT INTO permission.perm_list VALUES 
    (4, 'STAFF_LOGIN', NULL);
INSERT INTO permission.perm_list VALUES 
    (5, 'MR_HOLDS', NULL);
INSERT INTO permission.perm_list VALUES 
    (6, 'TITLE_HOLDS', NULL);
INSERT INTO permission.perm_list VALUES 
    (7, 'VOLUME_HOLDS', NULL);
INSERT INTO permission.perm_list VALUES 
    (8, 'COPY_HOLDS', oils_i18n_gettext(8, 'User is allowed to place a hold on a specific copy', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (9, 'REQUEST_HOLDS', NULL);
INSERT INTO permission.perm_list VALUES 
    (10, 'REQUEST_HOLDS_OVERRIDE', NULL);
INSERT INTO permission.perm_list VALUES 
    (11, 'VIEW_HOLD', oils_i18n_gettext(11, 'Allows a user to view another user''s holds', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (13, 'DELETE_HOLDS', NULL);
INSERT INTO permission.perm_list VALUES 
    (14, 'UPDATE_HOLD', oils_i18n_gettext(14, 'Allows a user to update another user''s hold', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (15, 'RENEW_CIRC', NULL);
INSERT INTO permission.perm_list VALUES 
    (16, 'VIEW_USER_FINES_SUMMARY', NULL);
INSERT INTO permission.perm_list VALUES 
    (17, 'VIEW_USER_TRANSACTIONS', NULL);
INSERT INTO permission.perm_list VALUES 
    (18, 'UPDATE_MARC', NULL);
INSERT INTO permission.perm_list VALUES 
    (19, 'CREATE_MARC', oils_i18n_gettext(19, 'User is allowed to create new MARC records', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (20, 'IMPORT_MARC', NULL);
INSERT INTO permission.perm_list VALUES 
    (21, 'CREATE_VOLUME', NULL);
INSERT INTO permission.perm_list VALUES 
    (22, 'UPDATE_VOLUME', NULL);
INSERT INTO permission.perm_list VALUES 
    (23, 'DELETE_VOLUME', NULL);
INSERT INTO permission.perm_list VALUES 
    (25, 'UPDATE_COPY', NULL);
INSERT INTO permission.perm_list VALUES 
    (26, 'DELETE_COPY', NULL);
INSERT INTO permission.perm_list VALUES 
    (27, 'RENEW_HOLD_OVERRIDE', NULL);
INSERT INTO permission.perm_list VALUES 
    (28, 'CREATE_USER', NULL);
INSERT INTO permission.perm_list VALUES 
    (29, 'UPDATE_USER', NULL);
INSERT INTO permission.perm_list VALUES 
    (30, 'DELETE_USER', NULL);
INSERT INTO permission.perm_list VALUES 
    (31, 'VIEW_USER', NULL);
INSERT INTO permission.perm_list VALUES 
    (32, 'COPY_CHECKIN', NULL);
INSERT INTO permission.perm_list VALUES 
    (33, 'CREATE_TRANSIT', NULL);
INSERT INTO permission.perm_list VALUES 
    (34, 'VIEW_PERMISSION', NULL);
INSERT INTO permission.perm_list VALUES 
    (35, 'CHECKIN_BYPASS_HOLD_FULFILL', NULL);
INSERT INTO permission.perm_list VALUES 
    (36, 'CREATE_PAYMENT', NULL);
INSERT INTO permission.perm_list VALUES 
    (37, 'SET_CIRC_LOST', NULL);
INSERT INTO permission.perm_list VALUES 
    (38, 'SET_CIRC_MISSING', NULL);
INSERT INTO permission.perm_list VALUES 
    (39, 'SET_CIRC_CLAIMS_RETURNED', NULL);
INSERT INTO permission.perm_list VALUES 
    (41, 'CREATE_TRANSACTION', oils_i18n_gettext(41, 'User may create new billable transactions', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (43, 'CREATE_BILL', oils_i18n_gettext(43, 'Allows a user to create a new bill on a transaction', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (44, 'VIEW_CONTAINER', oils_i18n_gettext(44, 'Allows a user to view another user''s containers (buckets)', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (45, 'CREATE_CONTAINER', oils_i18n_gettext(45, 'Allows a user to create a new container for another user', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (24, 'CREATE_COPY', oils_i18n_gettext(24, 'User is allowed to create a new copy object', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (47, 'UPDATE_ORG_UNIT', oils_i18n_gettext(47, 'Allows a user to change org unit settings', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (48, 'VIEW_CIRCULATIONS', oils_i18n_gettext(48, 'Allows a user to see what another use has checked out', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (42, 'VIEW_TRANSACTION', oils_i18n_gettext(42, 'User may view another user''s transactions', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (49, 'DELETE_CONTAINER', oils_i18n_gettext(49, 'Allows a user to delete another user container', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (50, 'CREATE_CONTAINER_ITEM', oils_i18n_gettext(50, 'Create a container item for another user', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (51, 'CREATE_USER_GROUP_LINK', oils_i18n_gettext(51, 'User can add other users to permission groups', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (52, 'REMOVE_USER_GROUP_LINK', oils_i18n_gettext(52, 'User can remove other users from permission groups', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (53, 'VIEW_PERM_GROUPS', oils_i18n_gettext(53, 'Allow user to view others'' permission groups', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (54, 'VIEW_PERMIT_CHECKOUT', oils_i18n_gettext(54, 'Allows a user to determine of another user can checkout an item', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (55, 'UPDATE_BATCH_COPY', oils_i18n_gettext(55, 'Allows a user to edit copies in batch', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (56, 'CREATE_PATRON_STAT_CAT', oils_i18n_gettext(56, 'User may create a new patron statistical category', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (57, 'CREATE_COPY_STAT_CAT', oils_i18n_gettext(57, 'User may create a copy stat cat', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (58, 'CREATE_PATRON_STAT_CAT_ENTRY', oils_i18n_gettext(58, 'User may create a new patron stat cat entry', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (59, 'CREATE_COPY_STAT_CAT_ENTRY', oils_i18n_gettext(59, 'User may create a new copy stat cat entry', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (60, 'UPDATE_PATRON_STAT_CAT', oils_i18n_gettext(60, 'User may update a patron stat cat', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (61, 'UPDATE_COPY_STAT_CAT', oils_i18n_gettext(61, 'User may update a copy stat cat', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (62, 'UPDATE_PATRON_STAT_CAT_ENTRY', oils_i18n_gettext(62, 'User may update a patron stat cat entry', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (63, 'UPDATE_COPY_STAT_CAT_ENTRY', oils_i18n_gettext(63, 'User may update a copy stat cat entry', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (65, 'CREATE_COPY_STAT_CAT_ENTRY_MAP', oils_i18n_gettext(65, 'User may link a copy to a stat cat entry', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (64, 'CREATE_PATRON_STAT_CAT_ENTRY_MAP', oils_i18n_gettext(64, 'User may link another user to a stat cat entry', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (66, 'DELETE_PATRON_STAT_CAT', oils_i18n_gettext(66, 'User may delete a patron stat cat', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (67, 'DELETE_COPY_STAT_CAT', oils_i18n_gettext(67, 'User may delete a copy stat cat', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (68, 'DELETE_PATRON_STAT_CAT_ENTRY', oils_i18n_gettext(68, 'User may delete a patron stat cat entry', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (69, 'DELETE_COPY_STAT_CAT_ENTRY', oils_i18n_gettext(69, 'User may delete a copy stat cat entry', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (70, 'DELETE_PATRON_STAT_CAT_ENTRY_MAP', oils_i18n_gettext(70, 'User may delete a patron stat cat entry map', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (71, 'DELETE_COPY_STAT_CAT_ENTRY_MAP', oils_i18n_gettext(71, 'User may delete a copy stat cat entry map', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (72, 'CREATE_NON_CAT_TYPE', oils_i18n_gettext(72, 'Allows a user to create a new non-cataloged item type', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (73, 'UPDATE_NON_CAT_TYPE', oils_i18n_gettext(73, 'Allows a user to update a non cataloged type', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (74, 'CREATE_IN_HOUSE_USE', oils_i18n_gettext(74, 'Allows a user to create a new in-house-use ', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (75, 'COPY_CHECKOUT', oils_i18n_gettext(75, 'Allows a user to check out a copy', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (76, 'CREATE_COPY_LOCATION', oils_i18n_gettext(76, 'Allows a user to create a new copy location', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (77, 'UPDATE_COPY_LOCATION', oils_i18n_gettext(77, 'Allows a user to update a copy location', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (78, 'DELETE_COPY_LOCATION', oils_i18n_gettext(78, 'Allows a user to delete a copy location', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (79, 'CREATE_COPY_TRANSIT', oils_i18n_gettext(79, 'Allows a user to create a transit_copy object for transiting a copy', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (80, 'COPY_TRANSIT_RECEIVE', oils_i18n_gettext(80, 'Allows a user to close out a transit on a copy', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (81, 'VIEW_HOLD_PERMIT', oils_i18n_gettext(81, 'Allows a user to see if another user has permission to place a hold on a given copy', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (82, 'VIEW_COPY_CHECKOUT_HISTORY', oils_i18n_gettext(82, 'Allows a user to view which users have checked out a given copy', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (83, 'REMOTE_Z3950_QUERY', oils_i18n_gettext(83, 'Allows a user to perform z3950 queries against remote servers', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (84, 'REGISTER_WORKSTATION', oils_i18n_gettext(84, 'Allows a user to register a new workstation', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (85, 'VIEW_COPY_NOTES', oils_i18n_gettext(85, 'Allows a user to view all notes attached to a copy', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (86, 'VIEW_VOLUME_NOTES', oils_i18n_gettext(86, 'Allows a user to view all notes attached to a volume', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (87, 'VIEW_TITLE_NOTES', oils_i18n_gettext(87, 'Allows a user to view all notes attached to a title', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (89, 'CREATE_VOLUME_NOTE', oils_i18n_gettext(89, 'Allows a user to create a new volume note', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (88, 'CREATE_COPY_NOTE', oils_i18n_gettext(88, 'Allows a user to create a new copy note', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (90, 'CREATE_TITLE_NOTE', oils_i18n_gettext(90, 'Allows a user to create a new title note', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (91, 'DELETE_COPY_NOTE', oils_i18n_gettext(91, 'Allows a user to delete someone elses copy notes', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (92, 'DELETE_VOLUME_NOTE', oils_i18n_gettext(92, 'Allows a user to delete someone elses volume note', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (93, 'DELETE_TITLE_NOTE', oils_i18n_gettext(93, 'Allows a user to delete someone elses title note', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (94, 'UPDATE_CONTAINER', oils_i18n_gettext(94, 'Allows a user to update another users container', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (95, 'CREATE_MY_CONTAINER', oils_i18n_gettext(95, 'Allows a user to create a container for themselves', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (96, 'VIEW_HOLD_NOTIFICATION', oils_i18n_gettext(96, 'Allows a user to view notifications attached to a hold', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (97, 'CREATE_HOLD_NOTIFICATION', oils_i18n_gettext(97, 'Allows a user to create new hold notifications', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (98, 'UPDATE_ORG_SETTING', oils_i18n_gettext(98, 'Allows a user to update an org unit setting', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (99, 'OFFLINE_UPLOAD', oils_i18n_gettext(99, 'Allows a user to upload an offline script', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (100, 'OFFLINE_VIEW', oils_i18n_gettext(100, 'Allows a user to view uploaded offline script information', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (101, 'OFFLINE_EXECUTE', oils_i18n_gettext(101, 'Allows a user to execute an offline script batch', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (102, 'CIRC_OVERRIDE_DUE_DATE', oils_i18n_gettext(102, 'Allows a user to change set the due date on an item to any date', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (103, 'CIRC_PERMIT_OVERRIDE', oils_i18n_gettext(103, 'Allows a user to bypass the circ permit call for checkout', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (104, 'COPY_IS_REFERENCE.override', oils_i18n_gettext(104, 'Allows a user to override the copy_is_reference event', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (105, 'VOID_BILLING', oils_i18n_gettext(105, 'Allows a user to void a bill', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (106, 'CIRC_CLAIMS_RETURNED.override', oils_i18n_gettext(106, 'Allows a person to check in/out an item that is claims returned', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (107, 'COPY_BAD_STATUS.override', oils_i18n_gettext(107, 'Allows a user to check out an item in a non-circulatable status', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (108, 'COPY_ALERT_MESSAGE.override', oils_i18n_gettext(108, 'Allows a user to check in/out an item that has an alert message', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (109, 'COPY_STATUS_LOST.override', oils_i18n_gettext(109, 'Allows a user to remove the lost status from a copy', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (110, 'COPY_STATUS_MISSING.override', oils_i18n_gettext(110, 'Allows a user to change the missing status on a copy', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (111, 'ABORT_TRANSIT', oils_i18n_gettext(111, 'Allows a user to abort a copy transit if the user is at the transit destination or source', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (112, 'ABORT_REMOTE_TRANIST', oils_i18n_gettext(112, 'Allows a user to abort a copy transit if the user is not at the transit source or dest', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (113, 'VIEW_ZIP_DATA', oils_i18n_gettext(113, 'Allows a user to query the ZIP code data method', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (114, 'CANCEL_HOLDS', oils_i18n_gettext(114, 'Allows a user to cancel holds', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (115, 'CREATE_DUPLICATE_HOLDS', oils_i18n_gettext(115, 'Allows a user to create duplicate holds (two or more holds on the same title)', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (117, 'actor.org_unit.closed_date.update', oils_i18n_gettext(117, 'Allows a user to update a closed date interval for a given location', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (116, 'actor.org_unit.closed_date.delete', oils_i18n_gettext(116, 'Allows a user to remove a closed date interval for a given location', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (118, 'actor.org_unit.closed_date.create', oils_i18n_gettext(118, 'Allows a user to create a new closed date for a location', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (119, 'DELETE_NON_CAT_TYPE', oils_i18n_gettext(119, 'Allows a user to delete a non cataloged type', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (120, 'money.collections_tracker.create', oils_i18n_gettext(120, 'Allows a user to put someone into collections', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (121, 'money.collections_tracker.delete', oils_i18n_gettext(121, 'Allows a user to remove someone from collections', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (122, 'BAR_PATRON', oils_i18n_gettext(122, 'Allows a user to bar a patron', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (123, 'UNBAR_PATRON', oils_i18n_gettext(123, 'Allows a user to un-bar a patron', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (124, 'DELETE_WORKSTATION', oils_i18n_gettext(124, 'Allows a user to remove an existing workstation so a new one can replace it', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (125, 'group_application.user', oils_i18n_gettext(125, 'Allows a user to add/remove users to/from the "User" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (126, 'group_application.user.patron', oils_i18n_gettext(126, 'Allows a user to add/remove users to/from the "Patron" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (127, 'group_application.user.staff', oils_i18n_gettext(127, 'Allows a user to add/remove users to/from the "Staff" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (128, 'group_application.user.staff.circ', oils_i18n_gettext(128, 'Allows a user to add/remove users to/from the "Circulator" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (129, 'group_application.user.staff.cat', oils_i18n_gettext(129, 'Allows a user to add/remove users to/from the "Cataloger" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (130, 'group_application.user.staff.admin.global_admin', oils_i18n_gettext(130, 'Allows a user to add/remove users to/from the "GlobalAdmin" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (131, 'group_application.user.staff.admin.local_admin', oils_i18n_gettext(131, 'Allows a user to add/remove users to/from the "LocalAdmin" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (132, 'group_application.user.staff.admin.lib_manager', oils_i18n_gettext(132, 'Allows a user to add/remove users to/from the "LibraryManager" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (133, 'group_application.user.staff.cat.cat1', oils_i18n_gettext(133, 'Allows a user to add/remove users to/from the "Cat1" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (134, 'group_application.user.staff.supercat', oils_i18n_gettext(134, 'Allows a user to add/remove users to/from the "Supercat" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (135, 'group_application.user.sip_client', oils_i18n_gettext(135, 'Allows a user to add/remove users to/from the "SIP-Client" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (136, 'group_application.user.vendor', oils_i18n_gettext(136, 'Allows a user to add/remove users to/from the "Vendor" group', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (137, 'ITEM_AGE_PROTECTED.override', oils_i18n_gettext(137, 'Allows a user to place a hold on an age-protected item', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (138, 'MAX_RENEWALS_REACHED.override', oils_i18n_gettext(138, 'Allows a user to renew an item past the maximun renewal count', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (139, 'PATRON_EXCEEDS_CHECKOUT_COUNT.override', oils_i18n_gettext(139, 'Allow staff to override checkout count failure', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (140, 'PATRON_EXCEEDS_OVERDUE_COUNT.override', oils_i18n_gettext(140, 'Allow staff to override overdue count failure', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (141, 'PATRON_EXCEEDS_FINES.override', oils_i18n_gettext(141, 'Allow staff to override fine amount checkout failure', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (142, 'CIRC_EXCEEDS_COPY_RANGE.override', oils_i18n_gettext(142, 'Allow staff to override circulation copy range failure', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (143, 'ITEM_ON_HOLDS_SHELF.override', oils_i18n_gettext(143, 'Allow staff to override item on holds shelf failure', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (144, 'COPY_NOT_AVAILABLE.override', oils_i18n_gettext(144, 'Allow staff to force checkout of Missing/Lost type items', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (146, 'HOLD_EXISTS.override', oils_i18n_gettext(146, 'allows users to place multiple holds on a single title', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (147, 'RUN_REPORTS', oils_i18n_gettext(147, 'Allows a users to run reports', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (148, 'SHARE_REPORT_FOLDER', oils_i18n_gettext(148, 'Allows a user to share report his own folders', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (149, 'VIEW_REPORT_OUTPUT', oils_i18n_gettext(149, 'Allow user to view report output', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (150, 'COPY_CIRC_NOT_ALLOWED.override', oils_i18n_gettext(150, 'Allows a user to checkout an item that is marked as non-circ', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (151, 'DELETE_CONTAINER_ITEM', oils_i18n_gettext(151, 'Allows a user to delete an item out of another user''s container', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (152, 'ASSIGN_WORK_ORG_UNIT', oils_i18n_gettext(152, 'Allow a staff member to define where another staff member has their permissions', 'ppl', 'description'));
INSERT INTO permission.perm_list VALUES 
    (153, 'DELETE_RECORD', oils_i18n_gettext(153, 'Allow a staff member to directly remove a bibliographic record', 'ppl', 'description'));

SELECT SETVAL('permission.perm_list_id_seq'::TEXT, (SELECT MAX(id) FROM permission.perm_list));

INSERT INTO permission.perm_list (code) VALUES ('ASSIGN_GROUP_PERM');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_AUDIENCE');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_BIB_LEVEL');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_CIRC_DURATION');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_CIRC_MOD');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_COPY_STATUS');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_HOURS_OF_OPERATION');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_ITEM_FORM');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_ITEM_TYPE');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_LANGUAGE');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_LASSO');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_LASSO_MAP');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_LIT_FORM');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_METABIB_FIELD');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_NET_ACCESS_LEVEL');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_ORG_ADDRESS');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_ORG_TYPE');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_ORG_UNIT');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_ORG_UNIT_CLOSING');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_PERM');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_RELEVANCE_ADJUSTMENT');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_SURVEY');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_VR_FORMAT');
INSERT INTO permission.perm_list (code) VALUES ('CREATE_XML_TRANSFORM');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_AUDIENCE');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_BIB_LEVEL');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_CIRC_DURATION');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_CIRC_MOD');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_COPY_STATUS');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_HOURS_OF_OPERATION');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_ITEM_FORM');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_ITEM_TYPE');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_LANGUAGE');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_LASSO');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_LASSO_MAP');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_LIT_FORM');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_METABIB_FIELD');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_NET_ACCESS_LEVEL');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_ORG_ADDRESS');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_ORG_TYPE');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_ORG_UNIT');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_ORG_UNIT_CLOSING');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_PERM');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_RELEVANCE_ADJUSTMENT');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_SURVEY');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_TRANSIT');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_VR_FORMAT');
INSERT INTO permission.perm_list (code) VALUES ('DELETE_XML_TRANSFORM');
INSERT INTO permission.perm_list (code) VALUES ('REMOVE_GROUP_PERM');
INSERT INTO permission.perm_list (code) VALUES ('TRANSIT_COPY');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_AUDIENCE');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_BIB_LEVEL');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_CIRC_DURATION');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_CIRC_MOD');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_COPY_NOTE');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_COPY_STATUS');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_GROUP_PERM');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_HOURS_OF_OPERATION');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_ITEM_FORM');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_ITEM_TYPE');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_LANGUAGE');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_LASSO');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_LASSO_MAP');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_LIT_FORM');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_METABIB_FIELD');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_NET_ACCESS_LEVEL');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_ORG_ADDRESS');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_ORG_TYPE');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_ORG_UNIT_CLOSING');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_PERM');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_RELEVANCE_ADJUSTMENT');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_SURVEY');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_TRANSIT');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_VOLUME_NOTE');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_VR_FORMAT');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_XML_TRANSFORM');
INSERT INTO permission.perm_list (code) VALUES ('MERGE_BIB_RECORDS');
INSERT INTO permission.perm_list (code) VALUES ('UPDATE_PICKUP_LIB_FROM_HOLDS_SHELF');


INSERT INTO permission.grp_tree (id, name, parent, description, perm_interval, usergroup, application_perm) VALUES
	(1, oils_i18n_gettext(1, 'Users', 'pgt', 'name'), NULL, NULL, '3 years', FALSE, 'group_application.user');
INSERT INTO permission.grp_tree (id, name, parent, description, perm_interval, usergroup, application_perm) VALUES
	(2, oils_i18n_gettext(2, 'Patrons', 'pgt', 'name'), 1, NULL, '3 years', TRUE, 'group_application.user.patron');
INSERT INTO permission.grp_tree (id, name, parent, description, perm_interval, usergroup, application_perm) VALUES
	(3, oils_i18n_gettext(3, 'Staff', 'pgt', 'name'), 1, NULL, '3 years', FALSE, 'group_application.user.staff');
INSERT INTO permission.grp_tree (id, name, parent, description, perm_interval, usergroup, application_perm) VALUES
	(4, oils_i18n_gettext(4, 'Catalogers', 'pgt', 'name'), 3, NULL, '3 years', TRUE, 'group_application.user.staff.cat');
INSERT INTO permission.grp_tree (id, name, parent, description, perm_interval, usergroup, application_perm) VALUES
	(5, oils_i18n_gettext(5, 'Circulators', 'pgt', 'name'), 3, NULL, '3 years', TRUE, 'group_application.user.staff.circ');
INSERT INTO permission.grp_tree (id, name, parent, description, perm_interval, usergroup, application_perm) VALUES
	(10, oils_i18n_gettext(10, 'Local System Administrator', 'pgt', 'name'), 3, 
	oils_i18n_gettext(10, 'System maintenance, configuration, etc.', 'pgt', 'description'), '3 years', TRUE, 'group_application.user.staff.admin.local_admin');

SELECT SETVAL('permission.grp_tree_id_seq'::TEXT, (SELECT MAX(id) FROM permission.grp_tree));

-- XXX Incomplete base permission setup.  A patch would be appreciated.
INSERT INTO permission.grp_perm_map VALUES (57, 2, 15, 0, false);
INSERT INTO permission.grp_perm_map VALUES (109, 2, 95, 0, false);
INSERT INTO permission.grp_perm_map VALUES (1, 1, 2, 0, false);
INSERT INTO permission.grp_perm_map VALUES (12, 1, 5, 0, false);
INSERT INTO permission.grp_perm_map VALUES (13, 1, 6, 0, false);
INSERT INTO permission.grp_perm_map VALUES (51, 1, 32, 0, false);
INSERT INTO permission.grp_perm_map VALUES (111, 1, 95, 0, false);
INSERT INTO permission.grp_perm_map VALUES (11, 3, 4, 0, false);
INSERT INTO permission.grp_perm_map VALUES (14, 3, 7, 2, false);
INSERT INTO permission.grp_perm_map VALUES (16, 3, 9, 0, false);
INSERT INTO permission.grp_perm_map VALUES (19, 3, 15, 0, false);
INSERT INTO permission.grp_perm_map VALUES (20, 3, 16, 0, false);
INSERT INTO permission.grp_perm_map VALUES (21, 3, 17, 0, false);
INSERT INTO permission.grp_perm_map VALUES (116, 3, 18, 0, false);
INSERT INTO permission.grp_perm_map VALUES (117, 3, 20, 0, false);
INSERT INTO permission.grp_perm_map VALUES (118, 3, 21, 2, false);
INSERT INTO permission.grp_perm_map VALUES (119, 3, 22, 2, false);
INSERT INTO permission.grp_perm_map VALUES (120, 3, 23, 2, false);
INSERT INTO permission.grp_perm_map VALUES (121, 3, 25, 2, false);
INSERT INTO permission.grp_perm_map VALUES (26, 3, 27, 0, false);
INSERT INTO permission.grp_perm_map VALUES (27, 3, 28, 0, false);
INSERT INTO permission.grp_perm_map VALUES (28, 3, 29, 0, false);
INSERT INTO permission.grp_perm_map VALUES (29, 3, 30, 0, false);
INSERT INTO permission.grp_perm_map VALUES (44, 3, 31, 0, false);
INSERT INTO permission.grp_perm_map VALUES (31, 3, 33, 0, false);
INSERT INTO permission.grp_perm_map VALUES (32, 3, 34, 0, false);
INSERT INTO permission.grp_perm_map VALUES (33, 3, 35, 0, false);
INSERT INTO permission.grp_perm_map VALUES (41, 3, 36, 0, false);
INSERT INTO permission.grp_perm_map VALUES (45, 3, 37, 0, false);
INSERT INTO permission.grp_perm_map VALUES (46, 3, 38, 0, false);
INSERT INTO permission.grp_perm_map VALUES (47, 3, 39, 0, false);
INSERT INTO permission.grp_perm_map VALUES (122, 3, 41, 0, false);
INSERT INTO permission.grp_perm_map VALUES (123, 3, 43, 0, false);
INSERT INTO permission.grp_perm_map VALUES (60, 3, 44, 0, false);
INSERT INTO permission.grp_perm_map VALUES (110, 3, 45, 0, false);
INSERT INTO permission.grp_perm_map VALUES (124, 3, 8, 2, false);
INSERT INTO permission.grp_perm_map VALUES (125, 3, 24, 2, false);
INSERT INTO permission.grp_perm_map VALUES (126, 3, 19, 0, false);
INSERT INTO permission.grp_perm_map VALUES (61, 3, 47, 2, false);
INSERT INTO permission.grp_perm_map VALUES (95, 3, 48, 0, false);
INSERT INTO permission.grp_perm_map VALUES (17, 3, 11, 0, false);
INSERT INTO permission.grp_perm_map VALUES (62, 3, 42, 0, false);
INSERT INTO permission.grp_perm_map VALUES (63, 3, 49, 0, false);
INSERT INTO permission.grp_perm_map VALUES (64, 3, 50, 0, false);
INSERT INTO permission.grp_perm_map VALUES (127, 3, 53, 0, false);
INSERT INTO permission.grp_perm_map VALUES (65, 3, 54, 0, false);
INSERT INTO permission.grp_perm_map VALUES (128, 3, 55, 2, false);
INSERT INTO permission.grp_perm_map VALUES (67, 3, 56, 2, false);
INSERT INTO permission.grp_perm_map VALUES (68, 3, 57, 2, false);
INSERT INTO permission.grp_perm_map VALUES (69, 3, 58, 2, false);
INSERT INTO permission.grp_perm_map VALUES (70, 3, 59, 2, false);
INSERT INTO permission.grp_perm_map VALUES (71, 3, 60, 2, false);
INSERT INTO permission.grp_perm_map VALUES (72, 3, 61, 2, false);
INSERT INTO permission.grp_perm_map VALUES (73, 3, 62, 2, false);
INSERT INTO permission.grp_perm_map VALUES (74, 3, 63, 2, false);
INSERT INTO permission.grp_perm_map VALUES (81, 3, 72, 2, false);
INSERT INTO permission.grp_perm_map VALUES (82, 3, 73, 2, false);
INSERT INTO permission.grp_perm_map VALUES (83, 3, 74, 2, false);
INSERT INTO permission.grp_perm_map VALUES (84, 3, 75, 0, false);
INSERT INTO permission.grp_perm_map VALUES (85, 3, 76, 2, false);
INSERT INTO permission.grp_perm_map VALUES (86, 3, 77, 2, false);
INSERT INTO permission.grp_perm_map VALUES (89, 3, 79, 0, false);
INSERT INTO permission.grp_perm_map VALUES (90, 3, 80, 0, false);
INSERT INTO permission.grp_perm_map VALUES (91, 3, 81, 0, false);
INSERT INTO permission.grp_perm_map VALUES (92, 3, 82, 0, false);
INSERT INTO permission.grp_perm_map VALUES (98, 3, 83, 0, false);
INSERT INTO permission.grp_perm_map VALUES (115, 3, 84, 0, false);
INSERT INTO permission.grp_perm_map VALUES (100, 3, 85, 0, false);
INSERT INTO permission.grp_perm_map VALUES (101, 3, 86, 0, false);
INSERT INTO permission.grp_perm_map VALUES (102, 3, 87, 0, false);
INSERT INTO permission.grp_perm_map VALUES (103, 3, 89, 2, false);
INSERT INTO permission.grp_perm_map VALUES (104, 3, 88, 2, false);
INSERT INTO permission.grp_perm_map VALUES (108, 3, 94, 0, false);
INSERT INTO permission.grp_perm_map VALUES (112, 3, 96, 0, false);
INSERT INTO permission.grp_perm_map VALUES (113, 3, 97, 0, false);
INSERT INTO permission.grp_perm_map VALUES (130, 3, 99, 1, false);
INSERT INTO permission.grp_perm_map VALUES (131, 3, 100, 1, false);
INSERT INTO permission.grp_perm_map VALUES (22, 4, 18, 0, false);
INSERT INTO permission.grp_perm_map VALUES (24, 4, 20, 0, false);
INSERT INTO permission.grp_perm_map VALUES (38, 4, 21, 2, false);
INSERT INTO permission.grp_perm_map VALUES (34, 4, 22, 2, false);
INSERT INTO permission.grp_perm_map VALUES (39, 4, 23, 2, false);
INSERT INTO permission.grp_perm_map VALUES (35, 4, 25, 2, false);
INSERT INTO permission.grp_perm_map VALUES (129, 4, 26, 2, false);
INSERT INTO permission.grp_perm_map VALUES (15, 4, 8, 2, false);
INSERT INTO permission.grp_perm_map VALUES (40, 4, 24, 2, false);
INSERT INTO permission.grp_perm_map VALUES (23, 4, 19, 0, false);
INSERT INTO permission.grp_perm_map VALUES (66, 4, 55, 2, false);
INSERT INTO permission.grp_perm_map VALUES (134, 10, 51, 1, false);
INSERT INTO permission.grp_perm_map VALUES (75, 10, 66, 2, false);
INSERT INTO permission.grp_perm_map VALUES (76, 10, 67, 2, false);
INSERT INTO permission.grp_perm_map VALUES (77, 10, 68, 2, false);
INSERT INTO permission.grp_perm_map VALUES (78, 10, 69, 2, false);
INSERT INTO permission.grp_perm_map VALUES (79, 10, 70, 2, false);
INSERT INTO permission.grp_perm_map VALUES (80, 10, 71, 2, false);
INSERT INTO permission.grp_perm_map VALUES (87, 10, 78, 2, false);
INSERT INTO permission.grp_perm_map VALUES (105, 10, 91, 1, false);
INSERT INTO permission.grp_perm_map VALUES (106, 10, 92, 1, false);
INSERT INTO permission.grp_perm_map VALUES (107, 10, 93, 0, false);
INSERT INTO permission.grp_perm_map VALUES (114, 10, 98, 1, false);
INSERT INTO permission.grp_perm_map VALUES (132, 10, 101, 1, true);
INSERT INTO permission.grp_perm_map VALUES (136, 10, 102, 1, false);
INSERT INTO permission.grp_perm_map VALUES (137, 10, 103, 1, false);
INSERT INTO permission.grp_perm_map VALUES (97, 5, 41, 0, false);
INSERT INTO permission.grp_perm_map VALUES (96, 5, 43, 0, false);
INSERT INTO permission.grp_perm_map VALUES (93, 5, 48, 0, false);
INSERT INTO permission.grp_perm_map VALUES (94, 5, 53, 0, false);
INSERT INTO permission.grp_perm_map VALUES (133, 5, 102, 0, false);
INSERT INTO permission.grp_perm_map VALUES (138, 5, 104, 1, false);

SELECT SETVAL('permission.grp_perm_map_id_seq'::TEXT, (SELECT MAX(id) FROM permission.grp_perm_map));

-- Admin user account
INSERT INTO actor.usr ( profile, card, usrname, passwd, first_given_name, family_name, dob, master_account, super_user, ident_type, ident_value, home_ou ) VALUES ( 1, 1, 'admin', 'open-ils', 'Administrator', 'System Account', '1979-01-22', TRUE, TRUE, 1, 'identification', 1 );

-- Admin user barcode
INSERT INTO actor.card (usr, barcode) VALUES (1,'101010101010101');
UPDATE actor.usr SET card = (SELECT id FROM actor.card WHERE barcode = '101010101010101') WHERE id = 1;

-- Admin user permissions
INSERT INTO permission.usr_perm_map (usr,perm,depth) VALUES (1,-1,0);

--010.schema.biblio.sql:
INSERT INTO biblio.record_entry VALUES (-1,1,1,1,-1,NOW(),NOW(),FALSE,FALSE,'','AUTOGEN','-1','','FOO');

--040.schema.asset.sql:
INSERT INTO asset.copy_location (id, name,owning_lib) VALUES (1, oils_i18n_gettext(1, 'Stacks', 'acpl', 'name'),1);
SELECT SETVAL('asset.copy_location_id_seq'::TEXT, 100);

INSERT INTO asset.call_number VALUES (-1,1,NOW(),1,NOW(),-1,1,'UNCATALOGED');

-- some more from 002.schema.config.sql:
INSERT INTO config.xml_transform VALUES ( 'marcxml', 'http://www.loc.gov/MARC21/slim', 'marc', '---' );
INSERT INTO config.xml_transform VALUES ( 'mods', 'http://www.loc.gov/mods/', 'mods', '');
INSERT INTO config.xml_transform VALUES ( 'mods3', 'http://www.loc.gov/mods/v3', 'mods3', '');
INSERT INTO config.xml_transform VALUES ( 'mods32', 'http://www.loc.gov/mods/v3', 'mods32', '');

-- circ matrix
INSERT INTO config.circ_matrix_matchpoint (org_unit,grp) VALUES (1,1);
INSERT INTO config.circ_matrix_ruleset (matchpoint,duration_rule,recurring_fine_rule,max_fine_rule) VALUES (1,11,1,1);


-- hold matrix - 110.hold_matrix.sql:
INSERT INTO config.hold_matrix_matchpoint (requestor_grp) VALUES (1);

-- Staged Search (for default matchpoints)
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(1, 'first_word', 1.5);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(1, 'full_match', 20);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(2, 'first_word', 1.5);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(2, 'word_order', 10);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(2, 'full_match', 20);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(3, 'first_word', 1.5);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(3, 'word_order', 10);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(3, 'full_match', 20);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(4, 'first_word', 1.5);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(4, 'word_order', 10);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(4, 'full_match', 20);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(5, 'first_word', 1.5);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(5, 'word_order', 10);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(5, 'full_match', 20);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(6, 'first_word', 1.5);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(6, 'word_order', 10);
INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(6, 'full_match', 20);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(7, 'first_word', 1.5);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(8, 'first_word', 1.5);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(9, 'first_word', 1.5);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(10, 'first_word', 1.5);

INSERT INTO search.relevance_adjustment (field, bump_type, multiplier) VALUES(15, 'word_order', 10);

-- Vandelay (for importing and exporting records) 012.schema.vandelay.sql 
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (1, 'title', oils_i18n_gettext(1, 'vqbrad', 'Title of work', 'description'),'//*[@tag="245"]/*[contains("abcmnopr",@code)]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (2, 'author', oils_i18n_gettext(1, 'vqbrad', 'Author of work', 'description'),'//*[@tag="100" or @tag="110" or @tag="113"]/*[contains("ad",@code)]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (3, 'language', oils_i18n_gettext(3, 'vqbrad', 'Language of work', 'description'),'//*[@tag="240"]/*[@code="l"][1]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (4, 'pagination', oils_i18n_gettext(4, 'vqbrad', 'Pagination', 'description'),'//*[@tag="300"]/*[@code="a"][1]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident, remove ) VALUES (5, 'isbn',oils_i18n_gettext(5, 'vqbrad', 'ISBN', 'description'),'//*[@tag="020"]/*[@code="a"]', TRUE, $r$(?:-|\s.+$)$r$);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident, remove ) VALUES (6, 'issn',oils_i18n_gettext(6, 'vqbrad', 'ISSN', 'description'),'//*[@tag="022"]/*[@code="a"]', TRUE, $r$(?:-|\s.+$)$r$);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (7, 'price',oils_i18n_gettext(7, 'vqbrad', 'Price', 'description'),'//*[@tag="020" or @tag="022"]/*[@code="c"][1]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident ) VALUES (8, 'rec_identifier',oils_i18n_gettext(8, 'vqbrad', 'Accession Number', 'description'),'//*[@tag="001"]', TRUE);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident ) VALUES (9, 'eg_tcn',oils_i18n_gettext(9, 'vqbrad', 'TCN Value', 'description'),'//*[@tag="901"]/*[@code="a"]', TRUE);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident ) VALUES (10, 'eg_tcn_source',oils_i18n_gettext(10, 'vqbrad', 'TCN Source', 'description'),'//*[@tag="901"]/*[@code="b"]', TRUE);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident ) VALUES (11, 'eg_identifier',oils_i18n_gettext(11, 'vqbrad', 'Internal ID', 'description'),'//*[@tag="901"]/*[@code="c"]', TRUE);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (12, 'publisher',oils_i18n_gettext(12, 'vqbrad', 'Publisher', 'description'),'//*[@tag="260"]/*[@code="b"][1]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, remove ) VALUES (13, 'pubdate',oils_i18n_gettext(13, 'vqbrad', 'Publication Date', 'description'),'//*[@tag="260"]/*[@code="c"][1]',$r$\D$r$);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (14, 'edition',oils_i18n_gettext(14, 'vqbrad', 'Edition', 'description'),'//*[@tag="250"]/*[@code="a"][1]');

INSERT INTO vandelay.import_item_attr_definition (
    owner, name, tag, owning_lib, circ_lib, location,
    call_number, circ_modifier, barcode, price, copy_number,
    circulate, ref, holdable, opac_visible, status
) VALUES (
    1,
    'Evergreen 852 export format',
    '852',
    '[@code = "b"][1]',
    '[@code = "b"][2]',
    'c',
    'j',
    'g',
    'p',
    'y',
    't',
    '[@code = "x" and text() = "circulating"]',
    '[@code = "x" and text() = "reference"]',
    '[@code = "x" and text() = "holdable"]',
    '[@code = "x" and text() = "visible"]',
    'z'
);

INSERT INTO vandelay.import_item_attr_definition (
    owner,
    name,
    tag,
    owning_lib,
    location,
    call_number,
    circ_modifier,
    barcode,
    price,
    status
) VALUES (
    1,
    'Unicorn Import format -- 999',
    '999',
    'm',
    'l',
    'a',
    't',
    'i',
    'p',
    'k'
);

INSERT INTO vandelay.authority_attr_definition ( code, description, xpath, ident ) VALUES ('rec_identifier','Identifier','//*[@tag="001"]', TRUE);


