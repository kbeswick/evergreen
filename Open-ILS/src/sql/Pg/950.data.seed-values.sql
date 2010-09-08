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

INSERT INTO config.metabib_class ( name, label ) VALUES ( 'identifier', oils_i18n_gettext('identifier', 'Identifier', 'cmc', 'name') );
INSERT INTO config.metabib_class ( name, label ) VALUES ( 'keyword', oils_i18n_gettext('keyword', 'Keyword', 'cmc', 'name') );
INSERT INTO config.metabib_class ( name, label ) VALUES ( 'title', oils_i18n_gettext('title', 'Title', 'cmc', 'name') );
INSERT INTO config.metabib_class ( name, label ) VALUES ( 'author', oils_i18n_gettext('author', 'Author', 'cmc', 'name') );
INSERT INTO config.metabib_class ( name, label ) VALUES ( 'subject', oils_i18n_gettext('subject', 'Subject', 'cmc', 'name') );
INSERT INTO config.metabib_class ( name, label ) VALUES ( 'series', oils_i18n_gettext('series', 'Series', 'cmc', 'name') );

-- some more from 002.schema.config.sql:
INSERT INTO config.xml_transform VALUES ( 'marcxml', 'http://www.loc.gov/MARC21/slim', 'marc', '---' );
INSERT INTO config.xml_transform VALUES ( 'mods', 'http://www.loc.gov/mods/', 'mods', '');
INSERT INTO config.xml_transform VALUES ( 'mods3', 'http://www.loc.gov/mods/v3', 'mods3', '');
INSERT INTO config.xml_transform VALUES ( 'mods32', 'http://www.loc.gov/mods/v3', 'mods32', '');
INSERT INTO config.xml_transform VALUES ( 'mods33', 'http://www.loc.gov/mods/v3', 'mods33', '');
INSERT INTO config.xml_transform VALUES ( 'marc21expand880', 'http://www.loc.gov/MARC21/slim', 'marc', '' );

INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath, facet_field ) VALUES 
    (1, 'series', 'seriestitle', oils_i18n_gettext(1, 'Series Title', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:relatedItem[@type="series"]/mods32:titleInfo$$, TRUE );

INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES 
    (2, 'title', 'abbreviated', oils_i18n_gettext(2, 'Abbreviated Title', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:titleInfo[mods32:title and (@type='abbreviated')]$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES 
    (3, 'title', 'translated', oils_i18n_gettext(3, 'Translated Title', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:titleInfo[mods32:title and (@type='translated')]$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES 
    (4, 'title', 'alternative', oils_i18n_gettext(4, 'Alternate Title', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:titleInfo[mods32:title and (@type='alternative')]$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES 
    (5, 'title', 'uniform', oils_i18n_gettext(5, 'Uniform Title', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:titleInfo[mods32:title and (@type='uniform')]$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES 
    (6, 'title', 'proper', oils_i18n_gettext(6, 'Title Proper', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:titleInfo[mods32:title and not (@type)]$$ );

INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath, facet_xpath, facet_field ) VALUES 
    (7, 'author', 'corporate', oils_i18n_gettext(7, 'Corporate Author', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:name[@type='corporate' and mods32:role/mods32:roleTerm[text()='creator']]$$, $$//*[local-name()='namePart']$$, TRUE ); -- /* to fool vim */;
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath, facet_xpath, facet_field ) VALUES 
    (8, 'author', 'personal', oils_i18n_gettext(8, 'Personal Author', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:name[@type='personal' and mods32:role/mods32:roleTerm[text()='creator']]$$, $$//*[local-name()='namePart']$$, TRUE ); -- /* to fool vim */;
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath, facet_xpath, facet_field ) VALUES 
    (9, 'author', 'conference', oils_i18n_gettext(9, 'Conference Author', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:name[@type='conference' and mods32:role/mods32:roleTerm[text()='creator']]$$, $$//*[local-name()='namePart']$$, TRUE ); -- /* to fool vim */;
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath, facet_xpath, facet_field ) VALUES 
    (10, 'author', 'other', oils_i18n_gettext(10, 'Other Author', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:name[@type='personal' and not(mods32:role)]$$, $$//*[local-name()='namePart']$$, TRUE ); -- /* to fool vim */;

INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath, facet_field ) VALUES 
    (11, 'subject', 'geographic', oils_i18n_gettext(11, 'Geographic Subject', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:subject/mods32:geographic$$, TRUE );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath, facet_xpath, facet_field ) VALUES 
    (12, 'subject', 'name', oils_i18n_gettext(12, 'Name Subject', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:subject/mods32:name$$, $$//*[local-name()='namePart']$$, TRUE ); -- /* to fool vim */;
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath, facet_field ) VALUES 
    (13, 'subject', 'temporal', oils_i18n_gettext(13, 'Temporal Subject', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:subject/mods32:temporal$$, TRUE );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath, facet_field ) VALUES 
    (14, 'subject', 'topic', oils_i18n_gettext(14, 'Topic Subject', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:subject/mods32:topic$$, TRUE );
--INSERT INTO config.metabib_field ( id, field_class, name, format, xpath ) VALUES 
--  ( id, field_class, name, xpath ) VALUES ( 'subject', 'genre', 'mods32', $$//mods32:mods/mods32:genre$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES 
    (15, 'keyword', 'keyword', oils_i18n_gettext(15, 'General Keywords', 'cmf', 'label'), 'mods32', $$//mods32:mods/*[not(local-name()='originInfo')]$$ ); -- /* to fool vim */;
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (16, 'subject', 'complete', oils_i18n_gettext(16, 'All Subjects', 'cmf', 'label'), 'mods32', $$//mods32:mods/mods32:subject//text()$$ );

INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (17, 'identifier', 'accession', oils_i18n_gettext(17, 'Accession Number', 'cmf', 'label'), 'marcxml', $$//marc:controlfield[@tag='001']$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (18, 'identifier', 'isbn', oils_i18n_gettext(18, 'ISBN', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='020']/marc:subfield[@code='a' or @code='z']$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (19, 'identifier', 'issn', oils_i18n_gettext(19, 'ISSN', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='022']/marc:subfield[@code='a' or @code='z']$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (20, 'identifier', 'upc', oils_i18n_gettext(20, 'UPC', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='024' and ind1='1']/marc:subfield[@code='a' or @code='z']$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (21, 'identifier', 'ismn', oils_i18n_gettext(21, 'ISMN', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='024' and ind1='2']/marc:subfield[@code='a' or @code='z']$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (22, 'identifier', 'ean', oils_i18n_gettext(22, 'EAN', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='024' and ind1='3']/marc:subfield[@code='a' or @code='z']$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (23, 'identifier', 'isrc', oils_i18n_gettext(23, 'ISRC', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='024' and ind1='0']/marc:subfield[@code='a' or @code='z']$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (24, 'identifier', 'sici', oils_i18n_gettext(24, 'SICI', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='024' and ind1='4']/marc:subfield[@code='a' or @code='z']$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (25, 'identifier', 'bibcn', oils_i18n_gettext(25, 'Local Free-Text Call Number', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='099']//text()$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (26, 'identifier', 'tcn', oils_i18n_gettext(26, 'Title Control Number', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='901']/marc:subfield[@code='a']$$ );
INSERT INTO config.metabib_field ( id, field_class, name, label, format, xpath ) VALUES
    (27, 'identifier', 'bibid', oils_i18n_gettext(27, 'Internal ID', 'cmf', 'label'), 'marcxml', $$//marc:datafield[@tag='901']/marc:subfield[@code='c']$$ );

SELECT SETVAL('config.metabib_field_id_seq'::TEXT, (SELECT MAX(id) FROM config.metabib_field), TRUE);

INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('kw','keyword');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('eg.keyword','keyword');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('dc.publisher','keyword');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('bib.subjecttitle','keyword');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('bib.genre','keyword');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('bib.edition','keyword');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('srw.serverchoice','keyword');

INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('id','identifier');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('dc.identifier','identifier');
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('eg.isbn','identifier', 18);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('eg.issn','identifier', 19);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('eg.upc','identifier', 20);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('eg.callnumber','identifier', 25);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('eg.tcn','identifier', 26);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('eg.bibid','identifier', 27);

INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('au','author');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('name','author');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('creator','author');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('eg.author','author');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('eg.name','author');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('dc.creator','author');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('dc.contributor','author');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('bib.name','author');
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.namepersonal','author',8);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.namepersonalfamily','author',8);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.namepersonalgiven','author',8);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.namecorporate','author',7);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.nameconference','author',9);

INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('ti','title');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('eg.title','title');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('dc.title','title');
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.titleabbreviated','title',2);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.titleuniform','title',5);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.titletranslated','title',3);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.titlealternative','title',4);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.title','title',2);

INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('su','subject');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('eg.subject','subject');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('dc.subject','subject');
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.subjectplace','subject',11);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.subjectname','subject',12);
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.subjectoccupation','subject',16);

INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('se','series');
INSERT INTO config.metabib_search_alias (alias,field_class) VALUES ('eg.series','series');
INSERT INTO config.metabib_search_alias (alias,field_class,field) VALUES ('bib.titleseries','series',1);


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

INSERT INTO config.rule_recurring_fine VALUES 
    (1, oils_i18n_gettext(1, 'default', 'crrf', 'name'), 0.50, 0.10, 0.05, '1 day');
INSERT INTO config.rule_recurring_fine VALUES 
    (2, oils_i18n_gettext(2, '10_cent_per_day', 'crrf', 'name'), 0.50, 0.10, 0.10, '1 day');
INSERT INTO config.rule_recurring_fine VALUES 
    (3, oils_i18n_gettext(3, '50_cent_per_day', 'crrf', 'name'), 0.50, 0.50, 0.50, '1 day');
SELECT SETVAL('config.rule_recurring_fine_id_seq'::TEXT, 100);

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
INSERT INTO config.copy_status (id,name) VALUES (15,oils_i18n_gettext(15, 'On reservation shelf', 'ccs', 'name'));

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
    VALUES ('en-US', 'eng', oils_i18n_gettext('en-US', 'English (US)', 'i18n_l', 'name'),
	oils_i18n_gettext('en-US', 'American English', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('cs-CZ', 'cze', oils_i18n_gettext('cs-CZ', 'Czech', 'i18n_l', 'name'),
	oils_i18n_gettext('cs-CZ', 'Czech', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('en-CA', 'eng', oils_i18n_gettext('en-CA', 'English (Canada)', 'i18n_l', 'name'),
	oils_i18n_gettext('en-CA', 'Canadian English', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('fr-CA', 'fre', oils_i18n_gettext('fr-CA', 'French (Canada)', 'i18n_l', 'name'),
	oils_i18n_gettext('fr-CA', 'Canadian French', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('hy-AM', 'arm', oils_i18n_gettext('hy-AM', 'Armenian', 'i18n_l', 'name'),
	oils_i18n_gettext('hy-AM', 'Armenian', 'i18n_l', 'description'));
--INSERT INTO config.i18n_locale (code,marc_code,name,description)
--    VALUES ('es-US', 'spa', oils_i18n_gettext('es-US', 'Spanish (US)', 'i18n_l', 'name'),
--	oils_i18n_gettext('es-US', 'American Spanish', 'i18n_l', 'description'));
--INSERT INTO config.i18n_locale (code,marc_code,name,description)
--    VALUES ('es-MX', 'spa', oils_i18n_gettext('es-MX', 'Spanish (Mexico)', 'i18n_l', 'name'),
--	oils_i18n_gettext('es-MX', 'Mexican Spanish', 'i18n_l', 'description'));
INSERT INTO config.i18n_locale (code,marc_code,name,description)
    VALUES ('ru-RU', 'rus', oils_i18n_gettext('ru-RU', 'Russian', 'i18n_l', 'name'),
	oils_i18n_gettext('ru-RU', 'Russian', 'i18n_l', 'description'));

-- Z39.50 server attributes

INSERT INTO config.z3950_source (name, label, host, port, db, auth)
	VALUES ('loc', oils_i18n_gettext('loc', 'Library of Congress', 'czs', 'label'), 'z3950.loc.gov', 7090, 'Voyager', FALSE);
INSERT INTO config.z3950_source (name, label, host, port, db, auth)
	VALUES ('oclc', oils_i18n_gettext('oclc', 'OCLC', 'czs', 'label'), 'zcat.oclc.org', 210, 'OLUCWorldCat', TRUE);
INSERT INTO config.z3950_source (name, label, host, port, db, auth)
	VALUES ('biblios', oils_i18n_gettext('biblios','‡biblios.net', 'czs', 'label'), 'z3950.biblios.net', 210, 'bibliographic', FALSE);

INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (1, 'loc','tcn', oils_i18n_gettext(1, 'Title Control Number', 'cza', 'label'), 12, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (2, 'loc', 'isbn', oils_i18n_gettext(2, 'ISBN', 'cza', 'label'), 7, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (3, 'loc', 'lccn', oils_i18n_gettext(3, 'LCCN', 'cza', 'label'), 9, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (4, 'loc', 'author', oils_i18n_gettext(4, 'Author', 'cza', 'label'), 1003, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (5, 'loc', 'title', oils_i18n_gettext(5, 'Title', 'cza', 'label'), 4, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (6, 'loc', 'issn', oils_i18n_gettext(6, 'ISSN', 'cza', 'label'), 8, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (7, 'loc', 'publisher', oils_i18n_gettext(7, 'Publisher', 'cza', 'label'), 1018, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (8, 'loc', 'pubdate', oils_i18n_gettext(8, 'Publication Date', 'cza', 'label'), 31, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (9, 'loc', 'item_type', oils_i18n_gettext(9, 'Item Type', 'cza', 'label'), 1001, 1);

UPDATE config.z3950_attr SET truncation = 1 WHERE source = 'loc';

INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (10, 'oclc', 'tcn', oils_i18n_gettext(10, 'Title Control Number', 'cza', 'label'), 12, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (11, 'oclc', 'isbn', oils_i18n_gettext(11, 'ISBN', 'cza', 'label'), 7, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (12, 'oclc', 'lccn', oils_i18n_gettext(12, 'LCCN', 'cza', 'label'), 9, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (13, 'oclc', 'author', oils_i18n_gettext(13, 'Author', 'cza', 'label'), 1003, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (14, 'oclc', 'title', oils_i18n_gettext(14, 'Title', 'cza', 'label'), 4, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (15, 'oclc', 'issn', oils_i18n_gettext(15, 'ISSN', 'cza', 'label'), 8, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (16, 'oclc', 'publisher', oils_i18n_gettext(16, 'Publisher', 'cza', 'label'), 1018, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (17, 'oclc', 'pubdate', oils_i18n_gettext(17, 'Publication Date', 'cza', 'label'), 31, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (18, 'oclc', 'item_type', oils_i18n_gettext(18, 'Item Type', 'cza', 'label'), 1001, 1);

INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (19, 'biblios','tcn', oils_i18n_gettext(19, 'Title Control Number', 'cza', 'label'), 12, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (20, 'biblios', 'isbn', oils_i18n_gettext(20, 'ISBN', 'cza', 'label'), 7, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (21, 'biblios', 'lccn', oils_i18n_gettext(21, 'LCCN', 'cza', 'label'), 9, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (22, 'biblios', 'author', oils_i18n_gettext(22, 'Author', 'cza', 'label'), 1003, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (23, 'biblios', 'title', oils_i18n_gettext(23, 'Title', 'cza', 'label'), 4, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (24, 'biblios', 'issn', oils_i18n_gettext(24, 'ISSN', 'cza', 'label'), 8, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (25, 'biblios', 'publisher', oils_i18n_gettext(25, 'Publisher', 'cza', 'label'), 1018, 6);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (26, 'biblios', 'pubdate', oils_i18n_gettext(26, 'Publication Date', 'cza', 'label'), 31, 1);
INSERT INTO config.z3950_attr (id, source, name, label, code, format)
	VALUES (27, 'biblios', 'item_type', oils_i18n_gettext(27, 'Item Type', 'cza', 'label'), 1001, 1);

UPDATE config.z3950_attr SET truncation = 1 WHERE source = 'biblios';

SELECT SETVAL('config.z3950_attr_id_seq'::TEXT, 100);

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

INSERT INTO actor.org_address (org_unit, street1, city, state, country, post_code)
SELECT id, '123 Main St.', 'Anywhere', 'GA', 'US', '30303'
FROM actor.org_unit;

UPDATE actor.org_unit SET holds_address = id, ill_address = id, billing_address = id, mailing_address = id;

INSERT INTO config.billing_type (id, name, owner) VALUES
	( 1, oils_i18n_gettext(1, 'Overdue Materials', 'cbt', 'name'), 1);
INSERT INTO config.billing_type (id, name, owner) VALUES
	( 2, oils_i18n_gettext(2, 'Long Overdue Collection Fee', 'cbt', 'name'), 1);
INSERT INTO config.billing_type (id, name, owner) VALUES
	( 3, oils_i18n_gettext(3, 'Lost Materials', 'cbt', 'name'), 1);
INSERT INTO config.billing_type (id, name, owner) VALUES
	( 4, oils_i18n_gettext(4, 'Lost Materials Processing Fee', 'cbt', 'name'), 1);
INSERT INTO config.billing_type (id, name, owner) VALUES
	( 5, oils_i18n_gettext(5, 'System: Deposit', 'cbt', 'name'), 1);
INSERT INTO config.billing_type (id, name, owner) VALUES
	( 6, oils_i18n_gettext(6, 'System: Rental', 'cbt', 'name'), 1);
INSERT INTO config.billing_type (id, name, owner) VALUES
	( 7, oils_i18n_gettext(7, 'Damaged Item', 'cbt', 'name'), 1);
INSERT INTO config.billing_type (id, name, owner) VALUES
	( 8, oils_i18n_gettext(8, 'Damaged Item Processing Fee', 'cbt', 'name'), 1);
INSERT INTO config.billing_type (id, name, owner) VALUES
	( 9, oils_i18n_gettext(9, 'Notification Fee', 'cbt', 'name'), 1);

INSERT INTO config.billing_type (id, name, owner) VALUES ( 101, oils_i18n_gettext(101, 'Misc', 'cbt', 'name'), 1);

SELECT SETVAL('config.billing_type_id_seq'::TEXT, 101);

--006.data.permissions.sql:
INSERT INTO permission.perm_list VALUES 
    (-1, 'EVERYTHING', NULL),
    (2, 'OPAC_LOGIN', oils_i18n_gettext(2, 'Allow a user to log in to the OPAC', 'ppl', 'description')),
    (4, 'STAFF_LOGIN', oils_i18n_gettext(4, 'Allow a user to log in to the staff client', 'ppl', 'description')),
    (5, 'MR_HOLDS', oils_i18n_gettext(5, 'Allow a user to create a metarecord holds', 'ppl', 'description')),
    (6, 'TITLE_HOLDS', oils_i18n_gettext(6, 'Allow a user to place a hold at the title level', 'ppl', 'description')),
    (7, 'VOLUME_HOLDS', oils_i18n_gettext(7, 'Allow a user to place a volume level hold', 'ppl', 'description')),
    (8, 'COPY_HOLDS', oils_i18n_gettext(8, 'Allow a user to place a hold on a specific copy', 'ppl', 'description')),
    (9, 'REQUEST_HOLDS', oils_i18n_gettext(9, 'Allow a user to create holds for another user (if true, we still check to make sure they have permission to make the type of hold they are requesting, for example, COPY_HOLDS)', 'ppl', 'description')),
    (10, 'REQUEST_HOLDS_OVERRIDE', oils_i18n_gettext(10, '* no longer applicable', 'ppl', 'description')),
    (11, 'VIEW_HOLD', oils_i18n_gettext(11, 'Allow a user to view another user''s holds', 'ppl', 'description')),
    (13, 'DELETE_HOLDS', oils_i18n_gettext(13, '* no longer applicable', 'ppl', 'description')),
    (14, 'UPDATE_HOLD', oils_i18n_gettext(14, 'Allow a user to update another user''s hold', 'ppl', 'description')),
    (15, 'RENEW_CIRC', oils_i18n_gettext(15, 'Allow a user to renew items', 'ppl', 'description')),
    (16, 'VIEW_USER_FINES_SUMMARY', oils_i18n_gettext(16, 'Allow a user to view bill details', 'ppl', 'description')),
    (17, 'VIEW_USER_TRANSACTIONS', oils_i18n_gettext(17, 'Allow a user to see another user''s grocery or circulation transactions in the Bills Interface, duplicate of VIEW_TRANSACTION', 'ppl', 'description')),
    (18, 'UPDATE_MARC', oils_i18n_gettext(18, 'Allow a user to edit a MARC record', 'ppl', 'description')),
    (19, 'CREATE_MARC', oils_i18n_gettext(19, 'Allow a user to create new MARC records. IMPORT_MARC is usually needed also.', 'ppl', 'description')),
    (20, 'IMPORT_MARC', oils_i18n_gettext(20, 'Allow a user to import a MARC record from the MARC editor or the Z39.50 interface', 'ppl', 'description')),
    (21, 'CREATE_VOLUME', oils_i18n_gettext(21, 'Allow a user to create a volume', 'ppl', 'description')),
    (22, 'UPDATE_VOLUME', oils_i18n_gettext(22, 'Allow a user to edit volumes - needed for merging records. This is a duplicate of VOLUME_UPDATE, user must have both permissions at appropriate level to merge records.', 'ppl', 'description')),
    (23, 'DELETE_VOLUME', oils_i18n_gettext(23, 'Allow a user to delete a volume', 'ppl', 'description')),
    (24, 'CREATE_COPY', oils_i18n_gettext(24, 'Allow a user to create a new copy object', 'ppl', 'description')),
    (25, 'UPDATE_COPY', oils_i18n_gettext(25, 'Allow a user to edit a copy', 'ppl', 'description')),
    (26, 'DELETE_COPY', oils_i18n_gettext(26, 'Allow a user to delete a copy', 'ppl', 'description')),
    (27, 'RENEW_HOLD_OVERRIDE', oils_i18n_gettext(27, 'Allow a user to continue to renew an item even if it is required for a hold', 'ppl', 'description')),
    (28, 'CREATE_USER', oils_i18n_gettext(28, 'Allow a user to create another user', 'ppl', 'description')),
    (29, 'UPDATE_USER', oils_i18n_gettext(29, 'Allow a user to edit a user''s record', 'ppl', 'description')),
    (30, 'DELETE_USER', oils_i18n_gettext(30, 'Allow a user to delete another user, including all associated transactions', 'ppl', 'description')),
    (31, 'VIEW_USER', oils_i18n_gettext(31, 'Allow a user to view another user''s Patron Record', 'ppl', 'description')),
    (32, 'COPY_CHECKIN', oils_i18n_gettext(32, 'Allow a user to check in a copy', 'ppl', 'description')),
    (33, 'CREATE_TRANSIT', oils_i18n_gettext(33, 'Allow a user to place an item in transit', 'ppl', 'description')),
    (34, 'VIEW_PERMISSION', oils_i18n_gettext(34, 'Allow a user to view user permissions within the user permissions editor', 'ppl', 'description')),
    (35, 'CHECKIN_BYPASS_HOLD_FULFILL', oils_i18n_gettext(35, '* no longer applicable', 'ppl', 'description')),
    (36, 'CREATE_PAYMENT', oils_i18n_gettext(36, 'Allow a user to record payments in the Billing Interface', 'ppl', 'description')),
    (37, 'SET_CIRC_LOST', oils_i18n_gettext(37, 'Allow a user to mark an item as ''lost''', 'ppl', 'description')),
    (38, 'SET_CIRC_MISSING', oils_i18n_gettext(38, 'Allow a user to mark an item as ''missing''', 'ppl', 'description')),
    (39, 'SET_CIRC_CLAIMS_RETURNED', oils_i18n_gettext(39, 'Allow a user to mark an item as ''claims returned''', 'ppl', 'description')),
    (41, 'CREATE_TRANSACTION', oils_i18n_gettext(41, 'Allow a user to create a new billable transaction', 'ppl', 'description')),
    (42, 'VIEW_TRANSACTION', oils_i18n_gettext(42, 'Allow a user may view another user''s transactions', 'ppl', 'description')),
    (43, 'CREATE_BILL', oils_i18n_gettext(43, 'Allow a user to create a new bill on a transaction', 'ppl', 'description')),
    (44, 'VIEW_CONTAINER', oils_i18n_gettext(44, 'Allow a user to view another user''s containers (buckets)', 'ppl', 'description')),
    (45, 'CREATE_CONTAINER', oils_i18n_gettext(45, 'Allow a user to create a new container for another user', 'ppl', 'description')),
    (47, 'UPDATE_ORG_UNIT', oils_i18n_gettext(47, 'Allow a user to change the settings for an organization unit', 'ppl', 'description')),
    (48, 'VIEW_CIRCULATIONS', oils_i18n_gettext(48, 'Allow a user to see what another user has checked out', 'ppl', 'description')),
    (49, 'DELETE_CONTAINER', oils_i18n_gettext(49, 'Allow a user to delete another user''s container', 'ppl', 'description')),
    (50, 'CREATE_CONTAINER_ITEM', oils_i18n_gettext(50, 'Allow a user to create a container item for another user', 'ppl', 'description')),
    (51, 'CREATE_USER_GROUP_LINK', oils_i18n_gettext(51, 'Allow a user to add other users to permission groups', 'ppl', 'description')),
    (52, 'REMOVE_USER_GROUP_LINK', oils_i18n_gettext(52, 'Allow a user to remove other users from permission groups', 'ppl', 'description')),
    (53, 'VIEW_PERM_GROUPS', oils_i18n_gettext(53, 'Allow a user to view other users'' permission groups', 'ppl', 'description')),
    (54, 'VIEW_PERMIT_CHECKOUT', oils_i18n_gettext(54, 'Allow a user to determine whether another user can check out an item.  A staff user who should be able to to check out an item to another patron will need this permission.', 'ppl', 'description')),
    (55, 'UPDATE_BATCH_COPY', oils_i18n_gettext(55, 'Allow a user to edit copies in batch', 'ppl', 'description')),
    (56, 'CREATE_PATRON_STAT_CAT', oils_i18n_gettext(56, 'User may create a new patron statistical category', 'ppl', 'description')),
    (57, 'CREATE_COPY_STAT_CAT', oils_i18n_gettext(57, 'User may create a copy statistical category', 'ppl', 'description')),
    (58, 'CREATE_PATRON_STAT_CAT_ENTRY', oils_i18n_gettext(58, 'User may create an entry in a patron statistical category', 'ppl', 'description')),
    (59, 'CREATE_COPY_STAT_CAT_ENTRY', oils_i18n_gettext(59, 'User may create an entry in a copy statistical category', 'ppl', 'description')),
    (60, 'UPDATE_PATRON_STAT_CAT', oils_i18n_gettext(60, 'User may update a patron statistical category', 'ppl', 'description')),
    (61, 'UPDATE_COPY_STAT_CAT', oils_i18n_gettext(61, 'User may update a copy statistical category', 'ppl', 'description')),
    (62, 'UPDATE_PATRON_STAT_CAT_ENTRY', oils_i18n_gettext(62, 'User may update an entry in a patron statistical category', 'ppl', 'description')),
    (63, 'UPDATE_COPY_STAT_CAT_ENTRY', oils_i18n_gettext(63, 'User may update an entry in a copy statistical category', 'ppl', 'description')),
    (65, 'CREATE_COPY_STAT_CAT_ENTRY_MAP', oils_i18n_gettext(65, 'User may link a copy to an entry in a statistical category', 'ppl', 'description')),
    (64, 'CREATE_PATRON_STAT_CAT_ENTRY_MAP', oils_i18n_gettext(64, 'User may link another user to an entry in a statistical category', 'ppl', 'description')),
    (66, 'DELETE_PATRON_STAT_CAT', oils_i18n_gettext(66, 'User may delete a patron statistical category', 'ppl', 'description')),
    (67, 'DELETE_COPY_STAT_CAT', oils_i18n_gettext(67, 'User may delete a copy statistical category', 'ppl', 'description')),
    (68, 'DELETE_PATRON_STAT_CAT_ENTRY', oils_i18n_gettext(68, 'User may delete an entry from a patron statistical category', 'ppl', 'description')),
    (69, 'DELETE_COPY_STAT_CAT_ENTRY', oils_i18n_gettext(69, 'User may delete an entry from a copy statistical category', 'ppl', 'description')),
    (70, 'DELETE_PATRON_STAT_CAT_ENTRY_MAP', oils_i18n_gettext(70, 'User may delete a patron statistical category entry map', 'ppl', 'description')),
    (71, 'DELETE_COPY_STAT_CAT_ENTRY_MAP', oils_i18n_gettext(71, 'User may delete a copy statistical category entry map', 'ppl', 'description')),
    (72, 'CREATE_NON_CAT_TYPE', oils_i18n_gettext(72, 'Allow a user to create a new non-cataloged item type', 'ppl', 'description')),
    (73, 'UPDATE_NON_CAT_TYPE', oils_i18n_gettext(73, 'Allow a user to update a non-cataloged item type', 'ppl', 'description')),
    (74, 'CREATE_IN_HOUSE_USE', oils_i18n_gettext(74, 'Allow a user to create a new in-house-use ', 'ppl', 'description')),
    (75, 'COPY_CHECKOUT', oils_i18n_gettext(75, 'Allow a user to check out a copy', 'ppl', 'description')),
    (76, 'CREATE_COPY_LOCATION', oils_i18n_gettext(76, 'Allow a user to create a new copy location', 'ppl', 'description')),
    (77, 'UPDATE_COPY_LOCATION', oils_i18n_gettext(77, 'Allow a user to update a copy location', 'ppl', 'description')),
    (78, 'DELETE_COPY_LOCATION', oils_i18n_gettext(78, 'Allow a user to delete a copy location', 'ppl', 'description')),
    (79, 'CREATE_COPY_TRANSIT', oils_i18n_gettext(79, 'Allow a user to create a transit_copy object for transiting a copy', 'ppl', 'description')),
    (80, 'COPY_TRANSIT_RECEIVE', oils_i18n_gettext(80, 'Allow a user to close out a transit on a copy', 'ppl', 'description')),
    (81, 'VIEW_HOLD_PERMIT', oils_i18n_gettext(81, 'Allow a user to see if another user has permission to place a hold on a given copy.  A staff user who should be able to place a hold for another patron will need this permission.', 'ppl', 'description')),
    (82, 'VIEW_COPY_CHECKOUT_HISTORY', oils_i18n_gettext(82, 'Allow a user to view which users have checked out a given copy', 'ppl', 'description')),
    (83, 'REMOTE_Z3950_QUERY', oils_i18n_gettext(83, 'Allow a user to perform Z39.50 queries against remote servers', 'ppl', 'description')),
    (84, 'REGISTER_WORKSTATION', oils_i18n_gettext(84, 'Allow a user to register a new workstation', 'ppl', 'description')),
    (85, 'VIEW_COPY_NOTES', oils_i18n_gettext(85, 'Allow a user to view all notes attached to a copy', 'ppl', 'description')),
    (86, 'VIEW_VOLUME_NOTES', oils_i18n_gettext(86, 'Allow a user to view all notes attached to a volume', 'ppl', 'description')),
    (87, 'VIEW_TITLE_NOTES', oils_i18n_gettext(87, 'Allow a user to view all notes attached to a title', 'ppl', 'description')),
    (88, 'CREATE_COPY_NOTE', oils_i18n_gettext(88, 'Allow a user to create a new copy note', 'ppl', 'description')),
    (89, 'CREATE_VOLUME_NOTE', oils_i18n_gettext(89, 'Allow a user to create a new volume note', 'ppl', 'description')),
    (90, 'CREATE_TITLE_NOTE', oils_i18n_gettext(90, 'Allow a user to create a new title note', 'ppl', 'description')),
    (91, 'DELETE_COPY_NOTE', oils_i18n_gettext(91, 'Allow a user to delete another user''s copy notes', 'ppl', 'description')),
    (92, 'DELETE_VOLUME_NOTE', oils_i18n_gettext(92, 'Allow a user to delete another user''s volume note', 'ppl', 'description')),
    (93, 'DELETE_TITLE_NOTE', oils_i18n_gettext(93, 'Allow a user to delete another user''s title note', 'ppl', 'description')),
    (94, 'UPDATE_CONTAINER', oils_i18n_gettext(94, 'Allow a user to update another user''s container', 'ppl', 'description')),
    (95, 'CREATE_MY_CONTAINER', oils_i18n_gettext(95, 'Allow a user to create a container for themselves', 'ppl', 'description')),
    (96, 'VIEW_HOLD_NOTIFICATION', oils_i18n_gettext(96, 'Allow a user to view notifications attached to a hold', 'ppl', 'description')),
    (97, 'CREATE_HOLD_NOTIFICATION', oils_i18n_gettext(97, 'Allow a user to create new hold notifications', 'ppl', 'description')),
    (98, 'UPDATE_ORG_SETTING', oils_i18n_gettext(98, 'Allow a user to update an organization unit setting', 'ppl', 'description')),
    (99, 'OFFLINE_UPLOAD', oils_i18n_gettext(99, 'Allow a user to upload an offline script', 'ppl', 'description')),
    (100, 'OFFLINE_VIEW', oils_i18n_gettext(100, 'Allow a user to view uploaded offline script information', 'ppl', 'description')),
    (101, 'OFFLINE_EXECUTE', oils_i18n_gettext(101, 'Allow a user to execute an offline script batch', 'ppl', 'description')),
    (102, 'CIRC_OVERRIDE_DUE_DATE', oils_i18n_gettext(102, 'Allow a user to change the due date on an item to any date', 'ppl', 'description')),
    (103, 'CIRC_PERMIT_OVERRIDE', oils_i18n_gettext(103, 'Allow a user to bypass the circulation permit call for check out', 'ppl', 'description')),
    (104, 'COPY_IS_REFERENCE.override', oils_i18n_gettext(104, 'Allow a user to override the copy_is_reference event', 'ppl', 'description')),
    (105, 'VOID_BILLING', oils_i18n_gettext(105, 'Allow a user to void a bill', 'ppl', 'description')),
    (106, 'CIRC_CLAIMS_RETURNED.override', oils_i18n_gettext(106, 'Allow a user to check in or check out an item that has a status of ''claims returned''', 'ppl', 'description')),
    (107, 'COPY_BAD_STATUS.override', oils_i18n_gettext(107, 'Allow a user to check out an item in a non-circulatable status', 'ppl', 'description')),
    (108, 'COPY_ALERT_MESSAGE.override', oils_i18n_gettext(108, 'Allow a user to check in/out an item that has an alert message', 'ppl', 'description')),
    (109, 'COPY_STATUS_LOST.override', oils_i18n_gettext(109, 'Allow a user to remove the lost status from a copy', 'ppl', 'description')),
    (110, 'COPY_STATUS_MISSING.override', oils_i18n_gettext(110, 'Allow a user to change the missing status on a copy', 'ppl', 'description')),
    (111, 'ABORT_TRANSIT', oils_i18n_gettext(111, 'Allow a user to abort a copy transit if the user is at the transit destination or source', 'ppl', 'description')),
    (112, 'ABORT_REMOTE_TRANSIT', oils_i18n_gettext(112, 'Allow a user to abort a copy transit if the user is not at the transit source or dest', 'ppl', 'description')),
    (113, 'VIEW_ZIP_DATA', oils_i18n_gettext(113, 'Allow a user to query the ZIP code data method', 'ppl', 'description')),
    (114, 'CANCEL_HOLDS', oils_i18n_gettext(114, 'Allow a user to cancel holds', 'ppl', 'description')),
    (115, 'CREATE_DUPLICATE_HOLDS', oils_i18n_gettext(115, 'Allow a user to create duplicate holds (two or more holds on the same title)', 'ppl', 'description')),
    (117, 'actor.org_unit.closed_date.update', oils_i18n_gettext(117, 'Allow a user to update a closed date interval for a given location', 'ppl', 'description')),
    (116, 'actor.org_unit.closed_date.delete', oils_i18n_gettext(116, 'Allow a user to remove a closed date interval for a given location', 'ppl', 'description')),
    (118, 'actor.org_unit.closed_date.create', oils_i18n_gettext(118, 'Allow a user to create a new closed date for a location', 'ppl', 'description')),
    (119, 'DELETE_NON_CAT_TYPE', oils_i18n_gettext(119, 'Allow a user to delete a non cataloged type', 'ppl', 'description')),
    (120, 'money.collections_tracker.create', oils_i18n_gettext(120, 'Allow a user to put someone into collections', 'ppl', 'description')),
    (121, 'money.collections_tracker.delete', oils_i18n_gettext(121, 'Allow a user to remove someone from collections', 'ppl', 'description')),
    (122, 'BAR_PATRON', oils_i18n_gettext(122, 'Allow a user to bar a patron', 'ppl', 'description')),
    (123, 'UNBAR_PATRON', oils_i18n_gettext(123, 'Allow a user to un-bar a patron', 'ppl', 'description')),
    (124, 'DELETE_WORKSTATION', oils_i18n_gettext(124, 'Allow a user to remove an existing workstation so a new one can replace it', 'ppl', 'description')),
    (125, 'group_application.user', oils_i18n_gettext(125, 'Allow a user to add/remove users to/from the "User" group', 'ppl', 'description')),
    (126, 'group_application.user.patron', oils_i18n_gettext(126, 'Allow a user to add/remove users to/from the "Patron" group', 'ppl', 'description')),
    (127, 'group_application.user.staff', oils_i18n_gettext(127, 'Allow a user to add/remove users to/from the "Staff" group', 'ppl', 'description')),
    (128, 'group_application.user.staff.circ', oils_i18n_gettext(128, 'Allow a user to add/remove users to/from the "Circulator" group', 'ppl', 'description')),
    (129, 'group_application.user.staff.cat', oils_i18n_gettext(129, 'Allow a user to add/remove users to/from the "Cataloger" group', 'ppl', 'description')),
    (130, 'group_application.user.staff.admin.global_admin', oils_i18n_gettext(130, 'Allow a user to add/remove users to/from the "GlobalAdmin" group', 'ppl', 'description')),
    (131, 'group_application.user.staff.admin.local_admin', oils_i18n_gettext(131, 'Allow a user to add/remove users to/from the "LocalAdmin" group', 'ppl', 'description')),
    (132, 'group_application.user.staff.admin.lib_manager', oils_i18n_gettext(132, 'Allow a user to add/remove users to/from the "LibraryManager" group', 'ppl', 'description')),
    (133, 'group_application.user.staff.cat.cat1', oils_i18n_gettext(133, 'Allow a user to add/remove users to/from the "Cat1" group', 'ppl', 'description')),
    (134, 'group_application.user.staff.supercat', oils_i18n_gettext(134, 'Allow a user to add/remove users to/from the "Supercat" group', 'ppl', 'description')),
    (135, 'group_application.user.sip_client', oils_i18n_gettext(135, 'Allow a user to add/remove users to/from the "SIP-Client" group', 'ppl', 'description')),
    (136, 'group_application.user.vendor', oils_i18n_gettext(136, 'Allow a user to add/remove users to/from the "Vendor" group', 'ppl', 'description')),
    (137, 'ITEM_AGE_PROTECTED.override', oils_i18n_gettext(137, 'Allow a user to place a hold on an age-protected item', 'ppl', 'description')),
    (138, 'MAX_RENEWALS_REACHED.override', oils_i18n_gettext(138, 'Allow a user to renew an item past the maximum renewal count', 'ppl', 'description')),
    (139, 'PATRON_EXCEEDS_CHECKOUT_COUNT.override', oils_i18n_gettext(139, 'Allow staff to override checkout count failure', 'ppl', 'description')),
    (140, 'PATRON_EXCEEDS_OVERDUE_COUNT.override', oils_i18n_gettext(140, 'Allow staff to override overdue count failure', 'ppl', 'description')),
    (141, 'PATRON_EXCEEDS_FINES.override', oils_i18n_gettext(141, 'Allow staff to override fine amount checkout failure', 'ppl', 'description')),
    (142, 'CIRC_EXCEEDS_COPY_RANGE.override', oils_i18n_gettext(142, 'Allow staff to override circulation copy range failure', 'ppl', 'description')),
    (143, 'ITEM_ON_HOLDS_SHELF.override', oils_i18n_gettext(143, 'Allow staff to override item on holds shelf failure', 'ppl', 'description')),
    (144, 'COPY_NOT_AVAILABLE.override', oils_i18n_gettext(144, 'Allow staff to force checkout of Missing/Lost type items', 'ppl', 'description')),
    (146, 'HOLD_EXISTS.override', oils_i18n_gettext(146, 'Allow a user to place multiple holds on a single title', 'ppl', 'description')),
    (147, 'RUN_REPORTS', oils_i18n_gettext(147, 'Allow a user to run reports', 'ppl', 'description')),
    (148, 'SHARE_REPORT_FOLDER', oils_i18n_gettext(148, 'Allow a user to share report his own folders', 'ppl', 'description')),
    (149, 'VIEW_REPORT_OUTPUT', oils_i18n_gettext(149, 'Allow a user to view report output', 'ppl', 'description')),
    (150, 'COPY_CIRC_NOT_ALLOWED.override', oils_i18n_gettext(150, 'Allow a user to checkout an item that is marked as non-circ', 'ppl', 'description')),
    (151, 'DELETE_CONTAINER_ITEM', oils_i18n_gettext(151, 'Allow a user to delete an item out of another user''s container', 'ppl', 'description')),
    (152, 'ASSIGN_WORK_ORG_UNIT', oils_i18n_gettext(152, 'Allow a staff member to define where another staff member has their permissions', 'ppl', 'description')),
    (153, 'CREATE_FUNDING_SOURCE', oils_i18n_gettext(153, 'Allow a user to create a new funding source', 'ppl', 'description')),
    (154, 'DELETE_FUNDING_SOURCE', oils_i18n_gettext(154, 'Allow a user to delete a funding source', 'ppl', 'description')),
    (155, 'VIEW_FUNDING_SOURCE', oils_i18n_gettext(155, 'Allow a user to view a funding source', 'ppl', 'description')),
    (156, 'UPDATE_FUNDING_SOURCE', oils_i18n_gettext(156, 'Allow a user to update a funding source', 'ppl', 'description')),
    (157, 'CREATE_FUND', oils_i18n_gettext(157, 'Allow a user to create a new fund', 'ppl', 'description')),
    (158, 'DELETE_FUND', oils_i18n_gettext(158, 'Allow a user to delete a fund', 'ppl', 'description')),
    (159, 'VIEW_FUND', oils_i18n_gettext(159, 'Allow a user to view a fund', 'ppl', 'description')),
    (160, 'UPDATE_FUND', oils_i18n_gettext(160, 'Allow a user to update a fund', 'ppl', 'description')),
    (161, 'CREATE_FUND_ALLOCATION', oils_i18n_gettext(161, 'Allow a user to create a new fund allocation', 'ppl', 'description')),
    (162, 'DELETE_FUND_ALLOCATION', oils_i18n_gettext(162, 'Allow a user to delete a fund allocation', 'ppl', 'description')),
    (163, 'VIEW_FUND_ALLOCATION', oils_i18n_gettext(163, 'Allow a user to view a fund allocation', 'ppl', 'description')),
    (164, 'UPDATE_FUND_ALLOCATION', oils_i18n_gettext(164, 'Allow a user to update a fund allocation', 'ppl', 'description')),
    (165, 'GENERAL_ACQ', oils_i18n_gettext(165, 'Lowest level permission required to access the ACQ interface', 'ppl', 'description')),
    (166, 'CREATE_PROVIDER', oils_i18n_gettext(166, 'Allow a user to create a new provider', 'ppl', 'description')),
    (167, 'DELETE_PROVIDER', oils_i18n_gettext(167, 'Allow a user to delate a provider', 'ppl', 'description')),
    (168, 'VIEW_PROVIDER', oils_i18n_gettext(168, 'Allow a user to view a provider', 'ppl', 'description')),
    (169, 'UPDATE_PROVIDER', oils_i18n_gettext(169, 'Allow a user to update a provider', 'ppl', 'description')),
    (170, 'ADMIN_FUNDING_SOURCE', oils_i18n_gettext(170, 'Allow a user to create/view/update/delete a funding source', 'ppl', 'description')),
    (171, 'ADMIN_FUND', oils_i18n_gettext(171, '(Deprecated) Allow a user to create/view/update/delete a fund', 'ppl', 'description')),
    (172, 'MANAGE_FUNDING_SOURCE', oils_i18n_gettext(172, 'Allow a user to view/credit/debit a funding source', 'ppl', 'description')),
    (173, 'MANAGE_FUND', oils_i18n_gettext(173, 'Allow a user to view/credit/debit a fund', 'ppl', 'description')),
    (174, 'CREATE_PICKLIST', oils_i18n_gettext(174, 'Allows a user to create a picklist', 'ppl', 'description')),
    (175, 'ADMIN_PROVIDER', oils_i18n_gettext(175, 'Allow a user to create/view/update/delete a provider', 'ppl', 'description')),
    (176, 'MANAGE_PROVIDER', oils_i18n_gettext(176, 'Allow a user to view and purchase from a provider', 'ppl', 'description')),
    (177, 'VIEW_PICKLIST', oils_i18n_gettext(177, 'Allow a user to view another users picklist', 'ppl', 'description')),
    (178, 'DELETE_RECORD', oils_i18n_gettext(178, 'Allow a staff member to directly remove a bibliographic record', 'ppl', 'description')),
    (179, 'ADMIN_CURRENCY_TYPE', oils_i18n_gettext(179, 'Allow a user to create/view/update/delete a currency_type', 'ppl', 'description')),
    (180, 'MARK_BAD_DEBT', oils_i18n_gettext(180, 'Allow a user to mark a transaction as bad (unrecoverable) debt', 'ppl', 'description')),
    (181, 'VIEW_BILLING_TYPE', oils_i18n_gettext(181, 'Allow a user to view billing types', 'ppl', 'description')),
    (182, 'MARK_ITEM_AVAILABLE', oils_i18n_gettext(182, 'Allow a user to mark an item status as ''available''', 'ppl', 'description')),
    (183, 'MARK_ITEM_CHECKED_OUT', oils_i18n_gettext(183, 'Allow a user to mark an item status as ''checked out''', 'ppl', 'description')),
    (184, 'MARK_ITEM_BINDERY', oils_i18n_gettext(184, 'Allow a user to mark an item status as ''bindery''', 'ppl', 'description')),
    (185, 'MARK_ITEM_LOST', oils_i18n_gettext(185, 'Allow a user to mark an item status as ''lost''', 'ppl', 'description')),
    (186, 'MARK_ITEM_MISSING', oils_i18n_gettext(186, 'Allow a user to mark an item status as ''missing''', 'ppl', 'description')),
    (187, 'MARK_ITEM_IN_PROCESS', oils_i18n_gettext(187, 'Allow a user to mark an item status as ''in process''', 'ppl', 'description')),
    (188, 'MARK_ITEM_IN_TRANSIT', oils_i18n_gettext(188, 'Allow a user to mark an item status as ''in transit''', 'ppl', 'description')),
    (189, 'MARK_ITEM_RESHELVING', oils_i18n_gettext(189, 'Allow a user to mark an item status as ''reshelving''', 'ppl', 'description')),
    (190, 'MARK_ITEM_ON_HOLDS_SHELF', oils_i18n_gettext(190, 'Allow a user to mark an item status as ''on holds shelf''', 'ppl', 'description')),
    (191, 'MARK_ITEM_ON_ORDER', oils_i18n_gettext(191, 'Allow a user to mark an item status as ''on order''', 'ppl', 'description')),
    (192, 'MARK_ITEM_ILL', oils_i18n_gettext(192, 'Allow a user to mark an item status as ''inter-library loan''', 'ppl', 'description')),
    (193, 'group_application.user.staff.acq', oils_i18n_gettext(193, 'Allows a user to add/remove/edit users in the "ACQ" group', 'ppl', 'description')),
    (194, 'CREATE_PURCHASE_ORDER', oils_i18n_gettext(194, 'Allows a user to create a purchase order', 'ppl', 'description')),
    (195, 'VIEW_PURCHASE_ORDER', oils_i18n_gettext(195, 'Allows a user to view a purchase order', 'ppl', 'description')),
    (196, 'IMPORT_ACQ_LINEITEM_BIB_RECORD', oils_i18n_gettext(196, 'Allows a user to import a bib record from the acq staging area (on-order record) into the ILS bib data set', 'ppl', 'description')),
    (197, 'RECEIVE_PURCHASE_ORDER', oils_i18n_gettext(197, 'Allows a user to mark a purchase order, lineitem, or individual copy as received', 'ppl', 'description')),
    (198, 'VIEW_ORG_SETTINGS', oils_i18n_gettext(198, 'Allows a user to view all org settings at the specified level', 'ppl', 'description')),
    (199, 'CREATE_MFHD_RECORD', oils_i18n_gettext(199, 'Allows a user to create a new MFHD record', 'ppl', 'description')),
    (200, 'UPDATE_MFHD_RECORD', oils_i18n_gettext(200, 'Allows a user to update an MFHD record', 'ppl', 'description')),
    (201, 'DELETE_MFHD_RECORD', oils_i18n_gettext(201, 'Allows a user to delete an MFHD record', 'ppl', 'description')),
    (202, 'ADMIN_ACQ_FUND', oils_i18n_gettext(202, 'Allow a user to create/view/update/delete a fund', 'ppl', 'description')),
    (203, 'group_application.user.staff.acq_admin', oils_i18n_gettext(203, 'Allows a user to add/remove/edit users in the "Acquisitions Administrators" group', 'ppl', 'description')),
    (204,'ASSIGN_GROUP_PERM', oils_i18n_gettext(204,'FIXME: Need description for ASSIGN_GROUP_PERM', 'ppl', 'description')),
    (205,'CREATE_AUDIENCE', oils_i18n_gettext(205,'FIXME: Need description for CREATE_AUDIENCE', 'ppl', 'description')),
    (206,'CREATE_BIB_LEVEL', oils_i18n_gettext(206,'FIXME: Need description for CREATE_BIB_LEVEL', 'ppl', 'description')),
    (207,'CREATE_CIRC_DURATION', oils_i18n_gettext(207,'FIXME: Need description for CREATE_CIRC_DURATION', 'ppl', 'description')),
    (208,'CREATE_CIRC_MOD', oils_i18n_gettext(208,'FIXME: Need description for CREATE_CIRC_MOD', 'ppl', 'description')),
    (209,'CREATE_COPY_STATUS', oils_i18n_gettext(209,'FIXME: Need description for CREATE_COPY_STATUS', 'ppl', 'description')),
    (210,'CREATE_HOURS_OF_OPERATION', oils_i18n_gettext(210,'FIXME: Need description for CREATE_HOURS_OF_OPERATION', 'ppl', 'description')),
    (211,'CREATE_ITEM_FORM', oils_i18n_gettext(211,'FIXME: Need description for CREATE_ITEM_FORM', 'ppl', 'description')),
    (212,'CREATE_ITEM_TYPE', oils_i18n_gettext(212,'FIXME: Need description for CREATE_ITEM_TYPE', 'ppl', 'description')),
    (213,'CREATE_LANGUAGE', oils_i18n_gettext(213,'FIXME: Need description for CREATE_LANGUAGE', 'ppl', 'description')),
    (214,'CREATE_LASSO', oils_i18n_gettext(214,'FIXME: Need description for CREATE_LASSO', 'ppl', 'description')),
    (215,'CREATE_LASSO_MAP', oils_i18n_gettext(215,'FIXME: Need description for CREATE_LASSO_MAP', 'ppl', 'description')),
    (216,'CREATE_LIT_FORM', oils_i18n_gettext(216,'FIXME: Need description for CREATE_LIT_FORM', 'ppl', 'description')),
    (217,'CREATE_METABIB_FIELD', oils_i18n_gettext(217,'FIXME: Need description for CREATE_METABIB_FIELD', 'ppl', 'description')),
    (218,'CREATE_NET_ACCESS_LEVEL', oils_i18n_gettext(218,'FIXME: Need description for CREATE_NET_ACCESS_LEVEL', 'ppl', 'description')),
    (219,'CREATE_ORG_ADDRESS', oils_i18n_gettext(219,'FIXME: Need description for CREATE_ORG_ADDRESS', 'ppl', 'description')),
    (220,'CREATE_ORG_TYPE', oils_i18n_gettext(220,'FIXME: Need description for CREATE_ORG_TYPE', 'ppl', 'description')),
    (221,'CREATE_ORG_UNIT', oils_i18n_gettext(221,'FIXME: Need description for CREATE_ORG_UNIT', 'ppl', 'description')),
    (222,'CREATE_ORG_UNIT_CLOSING', oils_i18n_gettext(222,'FIXME: Need description for CREATE_ORG_UNIT_CLOSING', 'ppl', 'description')),
    (223,'CREATE_PERM', oils_i18n_gettext(223,'FIXME: Need description for CREATE_PERM', 'ppl', 'description')),
    (224,'CREATE_RELEVANCE_ADJUSTMENT', oils_i18n_gettext(224,'FIXME: Need description for CREATE_RELEVANCE_ADJUSTMENT', 'ppl', 'description')),
    (225,'CREATE_SURVEY', oils_i18n_gettext(225,'FIXME: Need description for CREATE_SURVEY', 'ppl', 'description')),
    (226,'CREATE_VR_FORMAT', oils_i18n_gettext(226,'FIXME: Need description for CREATE_VR_FORMAT', 'ppl', 'description')),
    (227,'CREATE_XML_TRANSFORM', oils_i18n_gettext(227,'FIXME: Need description for CREATE_XML_TRANSFORM', 'ppl', 'description')),
    (228,'DELETE_AUDIENCE', oils_i18n_gettext(228,'FIXME: Need description for DELETE_AUDIENCE', 'ppl', 'description')),
    (229,'DELETE_BIB_LEVEL', oils_i18n_gettext(229,'FIXME: Need description for DELETE_BIB_LEVEL', 'ppl', 'description')),
    (230,'DELETE_CIRC_DURATION', oils_i18n_gettext(230,'FIXME: Need description for DELETE_CIRC_DURATION', 'ppl', 'description')),
    (231,'DELETE_CIRC_MOD', oils_i18n_gettext(231,'FIXME: Need description for DELETE_CIRC_MOD', 'ppl', 'description')),
    (232,'DELETE_COPY_STATUS', oils_i18n_gettext(232,'FIXME: Need description for DELETE_COPY_STATUS', 'ppl', 'description')),
    (233,'DELETE_HOURS_OF_OPERATION', oils_i18n_gettext(233,'FIXME: Need description for DELETE_HOURS_OF_OPERATION', 'ppl', 'description')),
    (234,'DELETE_ITEM_FORM', oils_i18n_gettext(234,'FIXME: Need description for DELETE_ITEM_FORM', 'ppl', 'description')),
    (235,'DELETE_ITEM_TYPE', oils_i18n_gettext(235,'FIXME: Need description for DELETE_ITEM_TYPE', 'ppl', 'description')),
    (236,'DELETE_LANGUAGE', oils_i18n_gettext(236,'FIXME: Need description for DELETE_LANGUAGE', 'ppl', 'description')),
    (237,'DELETE_LASSO', oils_i18n_gettext(237,'FIXME: Need description for DELETE_LASSO', 'ppl', 'description')),
    (238,'DELETE_LASSO_MAP', oils_i18n_gettext(238,'FIXME: Need description for DELETE_LASSO_MAP', 'ppl', 'description')),
    (239,'DELETE_LIT_FORM', oils_i18n_gettext(239,'FIXME: Need description for DELETE_LIT_FORM', 'ppl', 'description')),
    (240,'DELETE_METABIB_FIELD', oils_i18n_gettext(240,'FIXME: Need description for DELETE_METABIB_FIELD', 'ppl', 'description')),
    (241,'DELETE_NET_ACCESS_LEVEL', oils_i18n_gettext(241,'FIXME: Need description for DELETE_NET_ACCESS_LEVEL', 'ppl', 'description')),
    (242,'DELETE_ORG_ADDRESS', oils_i18n_gettext(242,'FIXME: Need description for DELETE_ORG_ADDRESS', 'ppl', 'description')),
    (243,'DELETE_ORG_TYPE', oils_i18n_gettext(243,'FIXME: Need description for DELETE_ORG_TYPE', 'ppl', 'description')),
    (244,'DELETE_ORG_UNIT', oils_i18n_gettext(244,'FIXME: Need description for DELETE_ORG_UNIT', 'ppl', 'description')),
    (245,'DELETE_ORG_UNIT_CLOSING', oils_i18n_gettext(245,'FIXME: Need description for DELETE_ORG_UNIT_CLOSING', 'ppl', 'description')),
    (246,'DELETE_PERM', oils_i18n_gettext(246,'FIXME: Need description for DELETE_PERM', 'ppl', 'description')),
    (247,'DELETE_RELEVANCE_ADJUSTMENT', oils_i18n_gettext(247,'FIXME: Need description for DELETE_RELEVANCE_ADJUSTMENT', 'ppl', 'description')),
    (248,'DELETE_SURVEY', oils_i18n_gettext(248,'FIXME: Need description for DELETE_SURVEY', 'ppl', 'description')),
    (249,'DELETE_TRANSIT', oils_i18n_gettext(249,'FIXME: Need description for DELETE_TRANSIT', 'ppl', 'description')),
    (250,'DELETE_VR_FORMAT', oils_i18n_gettext(250,'FIXME: Need description for DELETE_VR_FORMAT', 'ppl', 'description')),
    (251,'DELETE_XML_TRANSFORM', oils_i18n_gettext(251,'FIXME: Need description for DELETE_XML_TRANSFORM', 'ppl', 'description')),
    (252,'REMOVE_GROUP_PERM', oils_i18n_gettext(252,'FIXME: Need description for REMOVE_GROUP_PERM', 'ppl', 'description')),
    (253,'TRANSIT_COPY', oils_i18n_gettext(253,'FIXME: Need description for TRANSIT_COPY', 'ppl', 'description')),
    (254,'UPDATE_AUDIENCE', oils_i18n_gettext(254,'FIXME: Need description for UPDATE_AUDIENCE', 'ppl', 'description')),
    (255,'UPDATE_BIB_LEVEL', oils_i18n_gettext(255,'FIXME: Need description for UPDATE_BIB_LEVEL', 'ppl', 'description')),
    (256,'UPDATE_CIRC_DURATION', oils_i18n_gettext(256,'FIXME: Need description for UPDATE_CIRC_DURATION', 'ppl', 'description')),
    (257,'UPDATE_CIRC_MOD', oils_i18n_gettext(257,'FIXME: Need description for UPDATE_CIRC_MOD', 'ppl', 'description')),
    (258,'UPDATE_COPY_NOTE', oils_i18n_gettext(258,'FIXME: Need description for UPDATE_COPY_NOTE', 'ppl', 'description')),
    (259,'UPDATE_COPY_STATUS', oils_i18n_gettext(259,'FIXME: Need description for UPDATE_COPY_STATUS', 'ppl', 'description')),
    (260,'UPDATE_GROUP_PERM', oils_i18n_gettext(260,'FIXME: Need description for UPDATE_GROUP_PERM', 'ppl', 'description')),
    (261,'UPDATE_HOURS_OF_OPERATION', oils_i18n_gettext(261,'FIXME: Need description for UPDATE_HOURS_OF_OPERATION', 'ppl', 'description')),
    (262,'UPDATE_ITEM_FORM', oils_i18n_gettext(262,'FIXME: Need description for UPDATE_ITEM_FORM', 'ppl', 'description')),
    (263,'UPDATE_ITEM_TYPE', oils_i18n_gettext(263,'FIXME: Need description for UPDATE_ITEM_TYPE', 'ppl', 'description')),
    (264,'UPDATE_LANGUAGE', oils_i18n_gettext(264,'FIXME: Need description for UPDATE_LANGUAGE', 'ppl', 'description')),
    (265,'UPDATE_LASSO', oils_i18n_gettext(265,'FIXME: Need description for UPDATE_LASSO', 'ppl', 'description')),
    (266,'UPDATE_LASSO_MAP', oils_i18n_gettext(266,'FIXME: Need description for UPDATE_LASSO_MAP', 'ppl', 'description')),
    (267,'UPDATE_LIT_FORM', oils_i18n_gettext(267,'FIXME: Need description for UPDATE_LIT_FORM', 'ppl', 'description')),
    (268,'UPDATE_METABIB_FIELD', oils_i18n_gettext(268,'FIXME: Need description for UPDATE_METABIB_FIELD', 'ppl', 'description')),
    (269,'UPDATE_NET_ACCESS_LEVEL', oils_i18n_gettext(269,'FIXME: Need description for UPDATE_NET_ACCESS_LEVEL', 'ppl', 'description')),
    (270,'UPDATE_ORG_ADDRESS', oils_i18n_gettext(270,'FIXME: Need description for UPDATE_ORG_ADDRESS', 'ppl', 'description')),
    (271,'UPDATE_ORG_TYPE', oils_i18n_gettext(271,'FIXME: Need description for UPDATE_ORG_TYPE', 'ppl', 'description')),
    (272,'UPDATE_ORG_UNIT_CLOSING', oils_i18n_gettext(272,'FIXME: Need description for UPDATE_ORG_UNIT_CLOSING', 'ppl', 'description')),
    (273,'UPDATE_PERM', oils_i18n_gettext(273,'FIXME: Need description for UPDATE_PERM', 'ppl', 'description')),
    (274,'UPDATE_RELEVANCE_ADJUSTMENT', oils_i18n_gettext(274,'FIXME: Need description for UPDATE_RELEVANCE_ADJUSTMENT', 'ppl', 'description')),
    (275,'UPDATE_SURVEY', oils_i18n_gettext(275,'FIXME: Need description for UPDATE_SURVEY', 'ppl', 'description')),
    (276,'UPDATE_TRANSIT', oils_i18n_gettext(276,'FIXME: Need description for UPDATE_TRANSIT', 'ppl', 'description')),
    (277,'UPDATE_VOLUME_NOTE', oils_i18n_gettext(277,'FIXME: Need description for UPDATE_VOLUME_NOTE', 'ppl', 'description')),
    (278,'UPDATE_VR_FORMAT', oils_i18n_gettext(278,'FIXME: Need description for UPDATE_VR_FORMAT', 'ppl', 'description')),
    (279,'UPDATE_XML_TRANSFORM', oils_i18n_gettext(279,'FIXME: Need description for UPDATE_XML_TRANSFORM', 'ppl', 'description')),
    (280,'MERGE_BIB_RECORDS', oils_i18n_gettext(280,'Allow a user to merge bibliographic records and associated assets', 'ppl', 'description')),
    (281,'UPDATE_PICKUP_LIB_FROM_HOLDS_SHELF', oils_i18n_gettext(281,'FIXME: Need description for UPDATE_PICKUP_LIB_FROM_HOLDS_SHELF', 'ppl', 'description')),
    (282,'CREATE_ACQ_FUNDING_SOURCE', oils_i18n_gettext(282,'FIXME: Need description for CREATE_ACQ_FUNDING_SOURCE', 'ppl', 'description')),
    (283,'CREATE_AUTHORITY_IMPORT_IMPORT_FIELD_DEF', oils_i18n_gettext(283,'FIXME: Need description for CREATE_AUTHORITY_IMPORT_IMPORT_FIELD_DEF', 'ppl', 'description')),
    (284,'CREATE_AUTHORITY_IMPORT_QUEUE', oils_i18n_gettext(284,'FIXME: Need description for CREATE_AUTHORITY_IMPORT_QUEUE', 'ppl', 'description')),
    (285,'CREATE_AUTHORITY_RECORD_NOTE', oils_i18n_gettext(285,'FIXME: Need description for CREATE_AUTHORITY_RECORD_NOTE', 'ppl', 'description')),
    (286,'CREATE_BIB_IMPORT_FIELD_DEF', oils_i18n_gettext(286,'FIXME: Need description for CREATE_BIB_IMPORT_FIELD_DEF', 'ppl', 'description')),
    (287,'CREATE_BIB_IMPORT_QUEUE', oils_i18n_gettext(287,'FIXME: Need description for CREATE_BIB_IMPORT_QUEUE', 'ppl', 'description')),
    (288,'CREATE_LOCALE', oils_i18n_gettext(288,'FIXME: Need description for CREATE_LOCALE', 'ppl', 'description')),
    (289,'CREATE_MARC_CODE', oils_i18n_gettext(289,'FIXME: Need description for CREATE_MARC_CODE', 'ppl', 'description')),
    (290,'CREATE_TRANSLATION', oils_i18n_gettext(290,'FIXME: Need description for CREATE_TRANSLATION', 'ppl', 'description')),
    (291,'DELETE_ACQ_FUNDING_SOURCE', oils_i18n_gettext(291,'FIXME: Need description for DELETE_ACQ_FUNDING_SOURCE', 'ppl', 'description')),
    (292,'DELETE_AUTHORITY_IMPORT_IMPORT_FIELD_DEF', oils_i18n_gettext(292,'FIXME: Need description for DELETE_AUTHORITY_IMPORT_IMPORT_FIELD_DEF', 'ppl', 'description')),
    (293,'DELETE_AUTHORITY_IMPORT_QUEUE', oils_i18n_gettext(293,'FIXME: Need description for DELETE_AUTHORITY_IMPORT_QUEUE', 'ppl', 'description')),
    (294,'DELETE_AUTHORITY_RECORD_NOTE', oils_i18n_gettext(294,'FIXME: Need description for DELETE_AUTHORITY_RECORD_NOTE', 'ppl', 'description')),
    (295,'DELETE_BIB_IMPORT_IMPORT_FIELD_DEF', oils_i18n_gettext(295,'FIXME: Need description for DELETE_BIB_IMPORT_IMPORT_FIELD_DEF', 'ppl', 'description')),
    (296,'DELETE_BIB_IMPORT_QUEUE', oils_i18n_gettext(296,'FIXME: Need description for DELETE_BIB_IMPORT_QUEUE', 'ppl', 'description')),
    (297,'DELETE_LOCALE', oils_i18n_gettext(297,'FIXME: Need description for DELETE_LOCALE', 'ppl', 'description')),
    (298,'DELETE_MARC_CODE', oils_i18n_gettext(298,'FIXME: Need description for DELETE_MARC_CODE', 'ppl', 'description')),
    (299,'DELETE_TRANSLATION', oils_i18n_gettext(299,'FIXME: Need description for DELETE_TRANSLATION', 'ppl', 'description')),
    (300,'UPDATE_ACQ_FUNDING_SOURCE', oils_i18n_gettext(300,'FIXME: Need description for UPDATE_ACQ_FUNDING_SOURCE', 'ppl', 'description')),
    (301,'UPDATE_AUTHORITY_IMPORT_IMPORT_FIELD_DEF', oils_i18n_gettext(301,'FIXME: Need description for UPDATE_AUTHORITY_IMPORT_IMPORT_FIELD_DEF', 'ppl', 'description')),
    (302,'UPDATE_AUTHORITY_IMPORT_QUEUE', oils_i18n_gettext(302,'FIXME: Need description for UPDATE_AUTHORITY_IMPORT_QUEUE', 'ppl', 'description')),
    (303,'UPDATE_AUTHORITY_RECORD_NOTE', oils_i18n_gettext(303,'FIXME: Need description for UPDATE_AUTHORITY_RECORD_NOTE', 'ppl', 'description')),
    (304,'UPDATE_BIB_IMPORT_IMPORT_FIELD_DEF', oils_i18n_gettext(304,'FIXME: Need description for UPDATE_BIB_IMPORT_IMPORT_FIELD_DEF', 'ppl', 'description')),
    (305,'UPDATE_BIB_IMPORT_QUEUE', oils_i18n_gettext(305,'FIXME: Need description for UPDATE_BIB_IMPORT_QUEUE', 'ppl', 'description')),
    (306,'UPDATE_LOCALE', oils_i18n_gettext(306,'FIXME: Need description for UPDATE_LOCALE', 'ppl', 'description')),
    (307,'UPDATE_MARC_CODE', oils_i18n_gettext(307,'FIXME: Need description for UPDATE_MARC_CODE', 'ppl', 'description')),
    (308,'UPDATE_TRANSLATION', oils_i18n_gettext(308,'FIXME: Need description for UPDATE_TRANSLATION', 'ppl', 'description')),
    (309,'VIEW_ACQ_FUNDING_SOURCE', oils_i18n_gettext(309,'FIXME: Need description for VIEW_ACQ_FUNDING_SOURCE', 'ppl', 'description')),
    (310,'VIEW_AUTHORITY_RECORD_NOTES', oils_i18n_gettext(310,'FIXME: Need description for VIEW_AUTHORITY_RECORD_NOTES', 'ppl', 'description')),
    (311,'CREATE_IMPORT_ITEM', oils_i18n_gettext(311,'FIXME: Need description for CREATE_IMPORT_ITEM', 'ppl', 'description')),
    (312,'CREATE_IMPORT_ITEM_ATTR_DEF', oils_i18n_gettext(312,'FIXME: Need description for CREATE_IMPORT_ITEM_ATTR_DEF', 'ppl', 'description')),
    (313,'CREATE_IMPORT_TRASH_FIELD', oils_i18n_gettext(313,'FIXME: Need description for CREATE_IMPORT_TRASH_FIELD', 'ppl', 'description')),
    (314,'DELETE_IMPORT_ITEM', oils_i18n_gettext(314,'FIXME: Need description for DELETE_IMPORT_ITEM', 'ppl', 'description')),
    (315,'DELETE_IMPORT_ITEM_ATTR_DEF', oils_i18n_gettext(315,'FIXME: Need description for DELETE_IMPORT_ITEM_ATTR_DEF', 'ppl', 'description')),
    (316,'DELETE_IMPORT_TRASH_FIELD', oils_i18n_gettext(316,'FIXME: Need description for DELETE_IMPORT_TRASH_FIELD', 'ppl', 'description')),
    (317,'UPDATE_IMPORT_ITEM', oils_i18n_gettext(317,'FIXME: Need description for UPDATE_IMPORT_ITEM', 'ppl', 'description')),
    (318,'UPDATE_IMPORT_ITEM_ATTR_DEF', oils_i18n_gettext(318,'FIXME: Need description for UPDATE_IMPORT_ITEM_ATTR_DEF', 'ppl', 'description')),
    (319,'UPDATE_IMPORT_TRASH_FIELD', oils_i18n_gettext(319,'FIXME: Need description for UPDATE_IMPORT_TRASH_FIELD', 'ppl', 'description')),

-- ORG UNIT Settings
    (320,'UPDATE_ORG_UNIT_SETTING_ALL', oils_i18n_gettext(320,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING_ALL', 'ppl', 'description')),
    (321,'UPDATE_ORG_UNIT_SETTING.circ.lost_materials_processing_fee', oils_i18n_gettext(321,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.lost_materials_processing_fee', 'ppl', 'description')),
    (322,'UPDATE_ORG_UNIT_SETTING.cat.default_item_price', oils_i18n_gettext(322,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.cat.default_item_price', 'ppl', 'description')),
    (323,'UPDATE_ORG_UNIT_SETTING.auth.opac_timeout', oils_i18n_gettext(323,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.auth.opac_timeout', 'ppl', 'description')),
    (324,'UPDATE_ORG_UNIT_SETTING.auth.staff_timeout', oils_i18n_gettext(324,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.auth.staff_timeout', 'ppl', 'description')),
    (325,'UPDATE_ORG_UNIT_SETTING.org.bounced_emails', oils_i18n_gettext(325,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.org.bounced_emails', 'ppl', 'description')),
    (326,'UPDATE_ORG_UNIT_SETTING.circ.hold_expire_alert_interval', oils_i18n_gettext(326,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.hold_expire_alert_interval', 'ppl', 'description')),
    (327,'UPDATE_ORG_UNIT_SETTING.circ.hold_expire_interval', oils_i18n_gettext(327,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.hold_expire_interval', 'ppl', 'description')),
    (328,'UPDATE_ORG_UNIT_SETTING.credit.payments.allow', oils_i18n_gettext(328,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.credit.payments.allow', 'ppl', 'description')),
    (329,'UPDATE_ORG_UNIT_SETTING.circ.void_overdue_on_lost', oils_i18n_gettext(329,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.void_overdue_on_lost', 'ppl', 'description')),
    (330,'UPDATE_ORG_UNIT_SETTING.circ.hold_stalling.soft', oils_i18n_gettext(330,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.hold_stalling.soft', 'ppl', 'description')),
    (331,'UPDATE_ORG_UNIT_SETTING.circ.hold_boundary.hard', oils_i18n_gettext(331,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.hold_boundary.hard', 'ppl', 'description')),
    (332,'UPDATE_ORG_UNIT_SETTING.circ.hold_boundary.soft', oils_i18n_gettext(332,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.hold_boundary.soft', 'ppl', 'description')),
    (333,'UPDATE_ORG_UNIT_SETTING.opac.barcode_regex', oils_i18n_gettext(333,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.opac.barcode_regex', 'ppl', 'description')),
    (334,'UPDATE_ORG_UNIT_SETTING.global.password_regex', oils_i18n_gettext(334,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.global.password_regex', 'ppl', 'description')),
    (335,'UPDATE_ORG_UNIT_SETTING.circ.item_checkout_history.max', oils_i18n_gettext(335,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.item_checkout_history.max', 'ppl', 'description')),
    (336,'UPDATE_ORG_UNIT_SETTING.circ.reshelving_complete.interval', oils_i18n_gettext(336,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.reshelving_complete.interval', 'ppl', 'description')),
    (337,'UPDATE_ORG_UNIT_SETTING.circ.selfcheck.patron_login_timeout', oils_i18n_gettext(337,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.selfcheck.patron_login_timeout', 'ppl', 'description')),
    (338,'UPDATE_ORG_UNIT_SETTING.circ.selfcheck.alert_on_checkout_event', oils_i18n_gettext(338,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.selfcheck.alert_on_checkout_event', 'ppl', 'description')),
    (339,'UPDATE_ORG_UNIT_SETTING.circ.selfcheck.require_patron_password', oils_i18n_gettext(339,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.circ.selfcheck.require_patron_password', 'ppl', 'description')),
    (340,'UPDATE_ORG_UNIT_SETTING.global.juvenile_age_threshold', oils_i18n_gettext(340,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.global.juvenile_age_threshold', 'ppl', 'description')),
    (341,'UPDATE_ORG_UNIT_SETTING.cat.bib.keep_on_empty', oils_i18n_gettext(341,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.cat.bib.keep_on_empty', 'ppl', 'description')),
    (342,'UPDATE_ORG_UNIT_SETTING.cat.bib.alert_on_empty', oils_i18n_gettext(342,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.cat.bib.alert_on_empty', 'ppl', 'description')),
    (343,'UPDATE_ORG_UNIT_SETTING.patron.password.use_phone', oils_i18n_gettext(343,'FIXME: Need description for UPDATE_ORG_UNIT_SETTING.patron.password.use_phone', 'ppl', 'description')),

-- perm to override max claims returned
    (344,'SET_CIRC_CLAIMS_RETURNED.override', oils_i18n_gettext(344,'Allows staff to override the max claims returned value for a patron', 'ppl', 'description')),
    (345,'UPDATE_PATRON_CLAIM_RETURN_COUNT', oils_i18n_gettext(345,'Allows staff to manually change a patron''s claims returned count', 'ppl', 'description')),

    (346,'UPDATE_BILL_NOTE', oils_i18n_gettext(346,'Allows staff to edit the note for a bill on a transaction', 'ppl', 'description')),
    (347,'UPDATE_PAYMENT_NOTE', oils_i18n_gettext(347,'Allows staff to edit the note for a payment on a transaction', 'ppl', 'description')),
    (348, 'UPDATE_RECORD', oils_i18n_gettext(348, 'Allow a user to update and undelete records.', 'ppl', 'description')),
    (349, 'UPDATE_PATRON_CLAIM_NEVER_CHECKED_OUT_COUNT', oils_i18n_gettext(349,'Allows staff to manually change a patron''s claims never checkout out count', 'ppl', 'description')),
    (350, 'ADMIN_COPY_LOCATION_ORDER', oils_i18n_gettext(350, 'Allow a user to create/view/update/delete a copy location order', 'ppl', 'description')),

-- additional permissions
    (351, 'HOLD_LOCAL_AVAIL_OVERRIDE', oils_i18n_gettext(351, 'Allow a user to place a hold despite the availability of a local copy', 'ppl', 'description')),

    (352, 'ADMIN_BOOKING_RESOURCE', oils_i18n_gettext(352, 'Enables the user to create/update/delete booking resources', 'ppl', 'description')),
    (353, 'ADMIN_BOOKING_RESOURCE_TYPE', oils_i18n_gettext(353, 'Enables the user to create/update/delete booking resource types', 'ppl', 'description')),
    (354, 'ADMIN_BOOKING_RESOURCE_ATTR', oils_i18n_gettext(354, 'Enables the user to create/update/delete booking resource attributes', 'ppl', 'description')),
    (355, 'ADMIN_BOOKING_RESOURCE_ATTR_MAP', oils_i18n_gettext(355, 'Enables the user to create/update/delete booking resource attribute maps', 'ppl', 'description')),
    (356, 'ADMIN_BOOKING_RESOURCE_ATTR_VALUE', oils_i18n_gettext(356, 'Enables the user to create/update/delete booking resource attribute values', 'ppl', 'description')),
    (357, 'ADMIN_BOOKING_RESERVATION', oils_i18n_gettext(357, 'Enables the user to create/update/delete booking reservations', 'ppl', 'description')),
    (358, 'ADMIN_BOOKING_RESERVATION_ATTR_VALUE_MAP', oils_i18n_gettext(358, 'Enables the user to create/update/delete booking reservation attribute value maps', 'ppl', 'description')),
    (359, 'HOLD_ITEM_CHECKED_OUT.override', oils_i18n_gettext(359, 'Allows a user to place a hold on an item that they already have checked out', 'ppl', 'description')),
    (360, 'RETRIEVE_RESERVATION_PULL_LIST', oils_i18n_gettext(360, 'Allows a user to retrieve a booking reservation pull list', 'ppl', 'description')),
    (361, 'CAPTURE_RESERVATION', oils_i18n_gettext(361, 'Allows a user to capture booking reservations', 'ppl', 'description')),
    (362, 'MERGE_USERS', oils_i18n_gettext(362, 'Allows user records to be merged', 'ppl', 'description')),
    (363, 'ALLOW_ALT_TCN', oils_i18n_gettext(363, 'Allows staff to import a record using an alternate TCN to avoid conflicts', 'ppl', 'description')),
    (364, 'ADMIN_TRIGGER_EVENT_DEF', oils_i18n_gettext(364, 'Allow a user to administer trigger event definitions', 'ppl', 'description')),
    (365, 'ADMIN_ACQ_CANCEL_CAUSE', oils_i18n_gettext(365, 'Allow a user to create/update/delete reasons for order cancellations', 'ppl', 'description')),
    (366, 'ADMIN_TRIGGER_CLEANUP', oils_i18n_gettext(366, 'Allow a user to create, delete, and update trigger cleanup entries', 'ppl', 'description')),
    (367, 'CREATE_TRIGGER_CLEANUP', oils_i18n_gettext(367, 'Allow a user to create trigger cleanup entries', 'ppl', 'description')),
    (368, 'DELETE_TRIGGER_CLEANUP', oils_i18n_gettext(368, 'Allow a user to delete trigger cleanup entries', 'ppl', 'description')),
    (369, 'UPDATE_TRIGGER_CLEANUP', oils_i18n_gettext(369, 'Allow a user to update trigger cleanup entries', 'ppl', 'description')),
    (370, 'CREATE_TRIGGER_EVENT_DEF', oils_i18n_gettext(370, 'Allow a user to create trigger event definitions', 'ppl', 'description')),
    (371, 'DELETE_TRIGGER_EVENT_DEF', oils_i18n_gettext(371, 'Allow a user to delete trigger event definitions', 'ppl', 'description')),
    (372, 'UPDATE_TRIGGER_EVENT_DEF', oils_i18n_gettext(372, 'Allow a user to update trigger event definitions', 'ppl', 'description')),
    (373, 'VIEW_TRIGGER_EVENT_DEF', oils_i18n_gettext(373, 'Allow a user to view trigger event definitions', 'ppl', 'description')),
    (374, 'ADMIN_TRIGGER_HOOK', oils_i18n_gettext(374, 'Allow a user to create, update, and delete trigger hooks', 'ppl', 'description')),
    (375, 'CREATE_TRIGGER_HOOK', oils_i18n_gettext(375, 'Allow a user to create trigger hooks', 'ppl', 'description')),
    (376, 'DELETE_TRIGGER_HOOK', oils_i18n_gettext(376, 'Allow a user to delete trigger hooks', 'ppl', 'description')),
    (377, 'UPDATE_TRIGGER_HOOK', oils_i18n_gettext(377, 'Allow a user to update trigger hooks', 'ppl', 'description')),
    (378, 'ADMIN_TRIGGER_REACTOR', oils_i18n_gettext(378, 'Allow a user to create, update, and delete trigger reactors', 'ppl', 'description')),
    (379, 'CREATE_TRIGGER_REACTOR', oils_i18n_gettext(379, 'Allow a user to create trigger reactors', 'ppl', 'description')),
    (380, 'DELETE_TRIGGER_REACTOR', oils_i18n_gettext(380, 'Allow a user to delete trigger reactors', 'ppl', 'description')),
    (381, 'UPDATE_TRIGGER_REACTOR', oils_i18n_gettext(381, 'Allow a user to update trigger reactors', 'ppl', 'description')),
    (382, 'ADMIN_TRIGGER_TEMPLATE_OUTPUT', oils_i18n_gettext(382, 'Allow a user to delete trigger template output', 'ppl', 'description')),
    (383, 'DELETE_TRIGGER_TEMPLATE_OUTPUT', oils_i18n_gettext(383, 'Allow a user to delete trigger template output', 'ppl', 'description')),
    (384, 'ADMIN_TRIGGER_VALIDATOR', oils_i18n_gettext(384, 'Allow a user to create, update, and delete trigger validators', 'ppl', 'description')),
    (385, 'CREATE_TRIGGER_VALIDATOR', oils_i18n_gettext(385, 'Allow a user to create trigger validators', 'ppl', 'description')),
    (386, 'DELETE_TRIGGER_VALIDATOR', oils_i18n_gettext(386, 'Allow a user to delete trigger validators', 'ppl', 'description')),
    (387, 'UPDATE_TRIGGER_VALIDATOR', oils_i18n_gettext(387, 'Allow a user to update trigger validators', 'ppl', 'description')),
    (388, 'UPDATE_ORG_UNIT_SETTING.circ.block_renews_for_holds', oils_i18n_gettext(388, 'Allow a user to enable blocking of renews on items that could fulfill holds', 'ppl', 'description')),
    (389, 'ACQ_XFER_MANUAL_DFUND_AMOUNT', oils_i18n_gettext(389, 'Allow a user to transfer different amounts of money out of one fund and into another', 'ppl', 'description')),
    (390, 'OVERRIDE_HOLD_HAS_LOCAL_COPY', oils_i18n_gettext( 390, 'Allow a user to override the circ.holds.hold_has_copy_at.block setting', 'ppl', 'description' ))
    ,(391, 'UPDATE_PICKUP_LIB_FROM_TRANSIT', oils_i18n_gettext( 391, 'Allow a user to change the pickup and transit destination for a captured hold item already in transit', 'ppl', 'description' ))
    ,(392, 'COPY_NEEDED_FOR_HOLD.override', oils_i18n_gettext( 392, 'Allow a user to force renewal of an item that could fulfill a hold request', 'ppl', 'description' ))
    ,(393, 'MERGE_AUTH_RECORDS', oils_i18n_gettext( 393, 'Allow a user to merge authority records together', 'ppl', 'description' ))
;

SELECT SETVAL('permission.perm_list_id_seq'::TEXT, 1000);

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
	(6, oils_i18n_gettext(6, 'Acquisitions', 'pgt', 'name'), 3, NULL, '3 years', TRUE, 'group_application.user.staff.acq');
INSERT INTO permission.grp_tree (id, name, parent, description, perm_interval, usergroup, application_perm) VALUES
	(7, oils_i18n_gettext(7, 'Acquisitions Administrator', 'pgt', 'name'), 3, NULL, '3 years', TRUE, 'group_application.user.staff.acq_admin');
INSERT INTO permission.grp_tree (id, name, parent, description, perm_interval, usergroup, application_perm) VALUES
	(10, oils_i18n_gettext(10, 'Local System Administrator', 'pgt', 'name'), 3, 
	oils_i18n_gettext(10, 'System maintenance, configuration, etc.', 'pgt', 'description'), '3 years', TRUE, 'group_application.user.staff.admin.local_admin');

SELECT SETVAL('permission.grp_tree_id_seq'::TEXT, (SELECT MAX(id) FROM permission.grp_tree));

INSERT INTO permission.grp_penalty_threshold (grp,org_unit,penalty,threshold)
    VALUES (1,1,1,10.0);
INSERT INTO permission.grp_penalty_threshold (grp,org_unit,penalty,threshold)
    VALUES (1,1,2,10.0);
INSERT INTO permission.grp_penalty_threshold (grp,org_unit,penalty,threshold)
    VALUES (1,1,3,10.0);

SELECT SETVAL('permission.grp_penalty_threshold_id_seq'::TEXT, (SELECT MAX(id) FROM permission.grp_penalty_threshold));

-- XXX Incomplete base permission setup.  A patch would be appreciated.
-- Add basic user permissions to the Users group
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (1, (SELECT id FROM permission.perm_list WHERE code = 'OPAC_LOGIN'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (1, (SELECT id FROM permission.perm_list WHERE code = 'MR_HOLDS'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (1, (SELECT id FROM permission.perm_list WHERE code = 'TITLE_HOLDS'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (1, (SELECT id FROM permission.perm_list WHERE code = 'COPY_CHECKIN'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (1, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_MY_CONTAINER'), 0, false);

-- Add basic patron permissions to the Patrons group
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (2, (SELECT id FROM permission.perm_list WHERE code = 'RENEW_CIRC'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (2, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_MY_CONTAINER'), 0, false);

-- Add basic staff permissions to the Staff group
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'STAFF_LOGIN'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VOLUME_HOLDS'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'COPY_HOLDS'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'REQUEST_HOLDS'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_HOLD'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'RENEW_CIRC'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_USER_FINES_SUMMARY'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_USER_TRANSACTIONS'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_MARC'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_MARC'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'IMPORT_MARC'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_VOLUME'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_VOLUME'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_VOLUME'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_COPY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_COPY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'RENEW_HOLD_OVERRIDE'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_USER'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_USER'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_USER'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_USER'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_TRANSIT'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_PERMISSION'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CHECKIN_BYPASS_HOLD_FULFILL'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_PAYMENT'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'SET_CIRC_LOST'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'SET_CIRC_MISSING'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'SET_CIRC_CLAIMS_RETURNED'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_TRANSACTION'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_TRANSACTION'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_BILL'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_CONTAINER'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_CONTAINER'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_ORG_UNIT'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_CIRCULATIONS'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_CONTAINER'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_CONTAINER_ITEM'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_PERM_GROUPS'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_PERMIT_CHECKOUT'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_BATCH_COPY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_PATRON_STAT_CAT'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_COPY_STAT_CAT'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_PATRON_STAT_CAT_ENTRY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_COPY_STAT_CAT_ENTRY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_PATRON_STAT_CAT'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_COPY_STAT_CAT'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_PATRON_STAT_CAT_ENTRY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_COPY_STAT_CAT_ENTRY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_NON_CAT_TYPE'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_NON_CAT_TYPE'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_IN_HOUSE_USE'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'COPY_CHECKOUT'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_COPY_LOCATION'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_COPY_LOCATION'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_COPY_TRANSIT'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'COPY_TRANSIT_RECEIVE'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_HOLD_PERMIT'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_COPY_CHECKOUT_HISTORY'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'REMOTE_Z3950_QUERY'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'REGISTER_WORKSTATION'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_COPY_NOTES'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_VOLUME_NOTES'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_TITLE_NOTES'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_COPY_NOTE'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_VOLUME_NOTE'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_CONTAINER'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_HOLD_NOTIFICATION'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_HOLD_NOTIFICATION'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'OFFLINE_UPLOAD'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'OFFLINE_VIEW'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_BILLING_TYPE'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (3, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_ORG_SETTINGS'), 1, false);

-- Add basic cataloguing permissions to the Catalogers group
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'COPY_HOLDS'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_MARC'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_MARC'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'IMPORT_MARC'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_VOLUME'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_VOLUME'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_VOLUME'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_COPY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_COPY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_COPY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_BATCH_COPY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_MFHD_RECORD'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_MFHD_RECORD'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_MFHD_RECORD'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_RECORD'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (4, (SELECT id FROM permission.perm_list WHERE code = 'MERGE_AUTH_RECORDS'), 1, false);

-- Add basic circulation permissions to the Circulators group
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (5, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_TRANSACTION'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (5, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_BILL'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (5, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_CIRCULATIONS'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (5, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_PERM_GROUPS'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (5, (SELECT id FROM permission.perm_list WHERE code = 'CIRC_OVERRIDE_DUE_DATE'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (5, (SELECT id FROM permission.perm_list WHERE code = 'COPY_IS_REFERENCE.override'), 1, false);

-- Add basic sys admin permissions to the Local System Administrator group
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_USER_GROUP_LINK'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_PATRON_STAT_CAT'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_COPY_STAT_CAT'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_PATRON_STAT_CAT_ENTRY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_COPY_STAT_CAT_ENTRY'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_PATRON_STAT_CAT_ENTRY_MAP'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_COPY_STAT_CAT_ENTRY_MAP'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_COPY_LOCATION'), 2, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_COPY_NOTE'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_VOLUME_NOTE'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'DELETE_TITLE_NOTE'), 0, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_ORG_SETTING'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'OFFLINE_EXECUTE'), 1, true);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'CIRC_OVERRIDE_DUE_DATE'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'CIRC_PERMIT_OVERRIDE'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'RUN_REPORTS'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'SHARE_REPORT_FOLDER'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (10, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_REPORT_OUTPUT'), 1, false);

-- Add trigger administration permissions to the Local System Administrator group
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable)
    SELECT 10, id, 1, false FROM permission.perm_list
        WHERE code LIKE 'ADMIN_TRIGGER%'
            OR code LIKE 'CREATE_TRIGGER%'
            OR code LIKE 'DELETE_TRIGGER%'
            OR code LIKE 'UPDATE_TRIGGER%'
;
-- View trigger permissions are required at a consortial level for initial setup
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable)
    SELECT 10, id, 0, false FROM permission.perm_list WHERE code LIKE 'VIEW_TRIGGER%';

-- Add basic acquisitions permissions to the Acquisitions group
SELECT SETVAL('permission.grp_perm_map_id_seq'::TEXT, (SELECT MAX(id) FROM permission.grp_perm_map));
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (6, (SELECT id FROM permission.perm_list WHERE code = 'GENERAL_ACQ'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (6, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_PICKLIST'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (6, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_PICKLIST'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (6, (SELECT id FROM permission.perm_list WHERE code = 'CREATE_PURCHASE_ORDER'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (6, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_PURCHASE_ORDER'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (6, (SELECT id FROM permission.perm_list WHERE code = 'RECEIVE_PURCHASE_ORDER'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (6, (SELECT id FROM permission.perm_list WHERE code = 'VIEW_PROVIDER'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (6, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_COPY'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (6, (SELECT id FROM permission.perm_list WHERE code = 'UPDATE_VOLUME'), 1, false);

-- Add acquisitions administration permissions to the Acquisitions group
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (7, (SELECT id FROM permission.perm_list WHERE code = 'ADMIN_PROVIDER'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (7, (SELECT id FROM permission.perm_list WHERE code = 'ADMIN_FUNDING_SOURCE'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (7, (SELECT id FROM permission.perm_list WHERE code = 'ADMIN_ACQ_FUND'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (7, (SELECT id FROM permission.perm_list WHERE code = 'ADMIN_FUND'), 1, false);
INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (7, (SELECT id FROM permission.perm_list WHERE code = 'ADMIN_CURRENCY_TYPE'), 1, false);

INSERT INTO permission.grp_perm_map (grp, perm, depth, grantable) VALUES (1, (SELECT id FROM permission.perm_list WHERE code = 'HOLD_ITEM_CHECKED_OUT.override'), 0, false);

-- Admin user account
INSERT INTO actor.usr ( profile, card, usrname, passwd, first_given_name, family_name, dob, master_account, super_user, ident_type, ident_value, home_ou ) VALUES ( 1, 1, 'admin', 'open-ils', 'Administrator', 'System Account', '1979-01-22', TRUE, TRUE, 1, 'identification', 1 );

-- Admin user barcode
INSERT INTO actor.card (usr, barcode) VALUES (1,'101010101010101');
UPDATE actor.usr SET card = (SELECT id FROM actor.card WHERE barcode = '101010101010101') WHERE id = 1;

-- Admin user permissions
INSERT INTO permission.usr_perm_map (usr,perm,depth) VALUES (1,-1,0);

-- Set a work_ou for the Administrator user
INSERT INTO permission.usr_work_ou_map (usr, work_ou) VALUES (1, 1);

--010.schema.biblio.sql:
INSERT INTO biblio.record_entry VALUES (-1,1,1,1,-1,NOW(),NOW(),FALSE,FALSE,'','AUTOGEN','-1','<record xmlns="http://www.loc.gov/MARC21/slim"/>','FOO');

--040.schema.asset.sql:
INSERT INTO asset.copy_location (id, name,owning_lib) VALUES (1, oils_i18n_gettext(1, 'Stacks', 'acpl', 'name'),1);
SELECT SETVAL('asset.copy_location_id_seq'::TEXT, 100);

INSERT INTO asset.call_number VALUES (-1,1,NOW(),1,NOW(),-1,1,'UNCATALOGED');

-- circ matrix
INSERT INTO config.circ_matrix_matchpoint (org_unit,grp,duration_rule,recurring_fine_rule,max_fine_rule) VALUES (1,1,11,1,1);


-- hold matrix - 110.hold_matrix.sql:
INSERT INTO config.hold_matrix_matchpoint (requestor_grp) VALUES (1);


-- User setting types
INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES ('opac.default_font', TRUE, 'OPAC Font Size', 'OPAC Font Size', 'string');

INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES ('opac.default_search_depth', TRUE, 'OPAC Search Depth', 'OPAC Search Depth', 'integer');

INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES ('opac.default_search_location', TRUE, 'OPAC Search Location', 'OPAC Search Location', 'integer');

INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES ('opac.hits_per_page', TRUE, 'Hits per Page', 'Hits per Page', 'string');

INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES ('opac.hold_notify', TRUE, 'Hold Notification Format', 'Hold Notification Format', 'string');

INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES ('staff_client.catalog.record_view.default', TRUE, 'Default Record View', 'Default Record View', 'string');

INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES ('staff_client.copy_editor.templates', TRUE, 'Copy Editor Template', 'Copy Editor Template', 'object');

INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES ('circ.holds_behind_desk', FALSE, 'Hold is behind Circ Desk', 'Hold is behind Circ Desk', 'bool');


-- org_unit setting types
INSERT into config.org_unit_setting_type
( name, label, description, datatype ) VALUES

( 'auth.opac_timeout',
  'OPAC Inactivity Timeout (in seconds)',
  null,
  'integer' ),

( 'auth.staff_timeout',
  'Staff Login Inactivity Timeout (in seconds)',
  null,
  'integer' ),

( 'circ.lost_materials_processing_fee',
  'Lost Materials Processing Fee',
  null,
  'currency' ),

( 'cat.default_item_price',
  'Default Item Price',
  null,
  'currency' ),

( 'org.bounced_emails',
  'Sending email address for patron notices',
  null,
  'string' ),

( 'circ.hold_expire_alert_interval',
  'Holds: Expire Alert Interval',
  'Amount of time before a hold expires at which point the patron should be alerted',
  'interval' ),

( 'circ.hold_expire_interval',
  'Holds: Expire Interval',
  'Amount of time after a hold is placed before the hold expires.  Example "100 days"',
  'interval' ),

( 'credit.payments.allow',
  'Allow Credit Card Payments',
  'If enabled, patrons will be able to pay fines accrued at this location via credit card',
  'bool' ),

( 'global.default_locale',
  'Global Default Locale',
  null,
  'string' ),

( 'circ.void_overdue_on_lost',
  'Void overdue fines when items are marked lost',
  null,
  'bool' ),

( 'circ.hold_stalling.soft',
  'Holds: Soft stalling interval',
  'How long to wait before allowing remote items to be opportunisticaly captured for a hold.  Example "5 days"',
  'interval' ),

( 'circ.hold_stalling_hard',
  'Holds: Hard stalling interval',
  '',
  'interval' ),

( 'circ.hold_boundary.hard',
  'Holds: Hard boundary',
  null,
  'integer' ),

( 'circ.hold_boundary.soft',
  'Holds: Soft boundary',
  null,
  'integer' ),

( 'opac.barcode_regex',
  'Patron barcode format',
  'Regular expression defining the patron barcode format',
  'string' ),

( 'global.password_regex',
  'Password format',
  'Regular expression defining the password format',
  'string' ),

( 'circ.item_checkout_history.max',
  'Maximum previous checkouts displayed',
  'This is maximum number of previous circulations the staff client will display when investigating item details',
  'integer' ),

( 'circ.reshelving_complete.interval',
  'Change reshelving status interval',
  'Amount of time to wait before changing an item from "reshelving" status to "available".  Examples "1 day", "6 hours"',
  'interval' ),

( 'circ.holds.default_estimated_wait_interval',
  'Holds: Default Estimated Wait',
  'When predicting the amount of time a patron will be waiting for a hold to be fulfilled, this is the default estimated length of time to assume an item will be checked out.',
  'interval' ),

( 'circ.holds.min_estimated_wait_interval',
  'Holds: Minimum Estimated Wait',
  'When predicting the amount of time a patron will be waiting for a hold to be fulfilled, this is the minimum estimated length of time to assume an item will be checked out.',
  'interval' ),

( 'circ.selfcheck.patron_login_timeout',
  'Selfcheck: Patron Login Timeout (in seconds)',
  'Number of seconds of inactivity before the patron is logged out of the selfcheck interfacer',
  'integer' ),

( 'circ.selfcheck.alert.popup',
  'Selfcheck: Pop-up alert for errors',
  'If true, checkout/renewal errors will cause a pop-up window in addition to the on-screen message',
  'bool' ),

( 'circ.selfcheck.require_patron_password',
  'Selfcheck: Require patron password',
  'If true, patrons will be required to enter their password in addition to their username/barcode to log into the selfcheck interface',
  'bool' ),

( 'global.juvenile_age_threshold',
  'Juvenile Age Threshold',
  'The age at which a user is no long considered a juvenile.  For example, "18 years".',
  'interval' ),

( 'cat.bib.keep_on_empty',
  'Retain empty bib records',
  'Retain a bib record even when all attached copies are deleted',
  'bool' ),

( 'cat.bib.alert_on_empty',
  'Alert on empty bib records',
  'Alert staff when the last copy for a record is being deleted',
  'bool' ),

( 'patron.password.use_phone',
  'Patron: password from phone #',
  'Use the last 4 digits of the patrons phone number as the default password when creating new users',
  'bool' ),

( 'circ.charge_on_damaged',
  'Charge item price when marked damaged',
  'Charge item price when marked damaged',
  'bool' ),

( 'circ.charge_lost_on_zero',
  'Charge lost on zero',
  '',
  'bool' ),

( 'circ.damaged_item_processing_fee',
  'Charge processing fee for damaged items',
  'Charge processing fee for damaged items',
  'currency' ),

( 'circ.void_lost_on_checkin',
  'Circ: Void lost item billing when returned',
  'Void lost item billing when returned',
  'bool' ),

( 'circ.max_accept_return_of_lost',
  'Circ: Void lost max interval',
  'Items that have been lost this long will not result in voided billings when returned.  E.g. ''6 months''',
  'interval' ),

( 'circ.void_lost_proc_fee_on_checkin',
  'Circ: Void processing fee on lost item return',
  'Void processing fee when lost item returned',
  'bool' ),

( 'circ.restore_overdue_on_lost_return',
  'Circ: Restore overdues on lost item return',
  'Restore overdue fines on lost item return',
  'bool' ),

( 'circ.lost_immediately_available',
  'Circ: Lost items usable on checkin',
  'Lost items are usable on checkin instead of going ''home'' first',
  'bool' ),

( 'circ.holds_fifo',
  'Holds: FIFO',
  'Force holds to a more strict First-In, First-Out capture',
  'bool' ),

( 'opac.allow_pending_address',
  'OPAC: Allow pending addresses',
  'If enabled, patrons can create and edit existing addresses.  Addresses are kept in a pending state until staff approves the changes',
  'bool' ),

( 'ui.circ.show_billing_tab_on_bills',
  'Show billing tab first when bills are present',
  'If enabled and a patron has outstanding bills and the alert page is not required, show the billing tab by default, instead of the checkout tab, when a patron is loaded',
  'bool' ),

( 'ui.general.idle_timeout',
    'GUI: Idle timeout',
    'If you want staff client windows to be minimized after a certain amount of system idle time, set this to the number of seconds of idle time that you want to allow before minimizing (requires staff client restart).',
    'integer' ),

( 'ui.circ.in_house_use.entry_cap',
  'GUI: Record In-House Use: Maximum # of uses allowed per entry.',
  'The # of uses entry in the Record In-House Use interface may not exceed the value of this setting.',
  'integer' ),

( 'ui.circ.in_house_use.entry_warn',
  'GUI: Record In-House Use: # of uses threshold for Are You Sure? dialog.',
  'In the Record In-House Use interface, a submission attempt will warn if the # of uses field exceeds the value of this setting.',
  'integer' ),

( 'acq.default_circ_modifier',
  'Default circulation modifier',
  null,
  'string' ),

( 'acq.tmp_barcode_prefix',
  'Temporary barcode prefix',
  null,
  'string' ),

( 'acq.tmp_callnumber_prefix',
  'Temporary call number prefix',
  null,
  'string' ),

( 'ui.circ.patron_summary.horizontal',
  'Patron circulation summary is horizontal',
  null,
  'bool' ),

( 'ui.staff.require_initials',
  oils_i18n_gettext('ui.staff.require_initials', 'GUI: Require staff initials for entry/edit of item/patron/penalty notes/messages.', 'coust', 'label'),
  oils_i18n_gettext('ui.staff.require_initials', 'Appends staff initials and edit date into note content.', 'coust', 'description'),
  'bool' ),

( 'ui.general.button_bar',
  'Button bar',
  null,
  'bool' ),

( 'circ.hold_shelf_status_delay',
  'Hold Shelf Status Delay',
  'The purpose is to provide an interval of time after an item goes into the on-holds-shelf status before it appears to patrons that it is actually on the holds shelf.  This gives staff time to process the item before it shows as ready-for-pickup.',
  'interval' ),

( 'circ.patron_invalid_address_apply_penalty',
  'Invalid patron address penalty',
  'When set, if a patron address is set to invalid, a penalty is applied.',
  'bool' ),

( 'circ.checkout_fills_related_hold',
  'Checkout Fills Related Hold',
  'When a patron checks out an item and they have no holds that directly target the item, the system will attempt to find a hold for the patron that could be fulfilled by the checked out item and fulfills it',
  'bool'),

( 'circ.selfcheck.auto_override_checkout_events',
  'Selfcheck override events list',
  'List of checkout/renewal events that the selfcheck interface should automatically override instead instead of alerting and stopping the transaction',
  'array' ),

( 'circ.staff_client.do_not_auto_attempt_print',
  'Disable Automatic Print Attempt Type List',
  'Disable automatic print attempts from staff client interfaces for the receipt types in this list.  Possible values: "Checkout", "Bill Pay", "Hold Slip", "Transit Slip", and "Hold/Transit Slip".  This is different from the Auto-Print checkbox in the pertinent interfaces in that it disables automatic print attempts altogether, rather than encouraging silent printing by suppressing the print dialog.  The Auto-Print checkbox in these interfaces have no effect on the behavior for this setting.  In the case of the Hold, Transit, and Hold/Transit slips, this also suppresses the alert dialogs that precede the print dialog (the ones that offer Print and Do Not Print as options).',
  'array' ),

( 'ui.patron.default_inet_access_level',
  'Default level of patrons'' internet access',
  null,
  'integer' ),

( 'circ.max_patron_claim_return_count',
    'Max Patron Claims Returned Count',
    'When this count is exceeded, a staff override is required to mark the item as claims returned',
    'integer' ),

( 'circ.obscure_dob',
    'Obscure the Date of Birth field',
    'When true, the Date of Birth column in patron lists will default to Not Visible, and in the Patron Summary sidebar the value will display as <Hidden> unless the field label is clicked.',
    'bool' ),

( 'circ.auto_hide_patron_summary',
    'GUI: Toggle off the patron summary sidebar after first view.',
    'When true, the patron summary sidebar will collapse after a new patron sub-interface is selected.',
    'bool' ),

( 'credit.processor.default',
    'Credit card processing: Name default credit processor',
    'This might be "AuthorizeNet", "PayPal", etc.',
    'string' ),

( 'credit.processor.authorizenet.enabled',
    'Credit card processing: Enable AuthorizeNet payments',
    '',
    'bool' ),

( 'credit.processor.authorizenet.login',
    'Credit card processing: AuthorizeNet login',
    '',
    'string' ),

( 'credit.processor.authorizenet.password',
    'Credit card processing: AuthorizeNet password',
    '',
    'string' ),

( 'credit.processor.authorizenet.server',
    'Credit card processing: AuthorizeNet server',
    'Required if using a developer/test account with AuthorizeNet',
    'string' ),

( 'credit.processor.authorizenet.testmode',
    'Credit card processing: AuthorizeNet test mode',
    '',
    'bool' ),

( 'credit.processor.paypal.enabled',
    'Credit card processing: Enable PayPal payments',
    '',
    'bool' ),
( 'credit.processor.paypal.login',
    'Credit card processing: PayPal login',
    '',
    'string' ),
( 'credit.processor.paypal.password',
    'Credit card processing: PayPal password',
    '',
    'string' ),
( 'credit.processor.paypal.signature',
    'Credit card processing: PayPal signature',
    '',
    'string' ),
( 'credit.processor.paypal.testmode',
    'Credit card processing: PayPal test mode',
    '',
    'bool' ),

( 'ui.admin.work_log.max_entries',
    oils_i18n_gettext('ui.admin.work_log.max_entries', 'GUI: Work Log: Maximum Actions Logged', 'coust', 'label'),
    oils_i18n_gettext('ui.admin.work_log.max_entries', 'Maximum entries for "Most Recent Staff Actions" section of the Work Log interface.', 'coust', 'description'),
  'interval' ),

( 'ui.admin.patron_log.max_entries',
    oils_i18n_gettext('ui.admin.patron_log.max_entries', 'GUI: Work Log: Maximum Patrons Logged', 'coust', 'label'),
    oils_i18n_gettext('ui.admin.patron_log.max_entries', 'Maximum entries for "Most Recently Affected Patrons..." section of the Work Log interface.', 'coust', 'description'),
  'interval' ),

( 'lib.courier_code',
    oils_i18n_gettext('lib.courier_code', 'Courier Code', 'coust', 'label'),
    oils_i18n_gettext('lib.courier_code', 'Courier Code for the library.  Available in transit slip templates as the %courier_code% macro.', 'coust', 'description'),
    'string'),

( 'circ.block_renews_for_holds',
    oils_i18n_gettext('circ.block_renews_for_holds', 'Holds: Block Renewal of Items Needed for Holds', 'coust', 'label'),
    oils_i18n_gettext('circ.block_renews_for_holds', 'When an item could fulfill a hold, do not allow the current patron to renew', 'coust', 'description'),
    'bool' ),

( 'circ.password_reset_request_per_user_limit',
    oils_i18n_gettext('circ.password_reset_request_per_user_limit', 'Circulation: Maximum concurrently active self-serve password reset requests per user', 'coust', 'label'),
    oils_i18n_gettext('circ.password_reset_request_per_user_limit', 'When a user has more than this number of concurrently active self-serve password reset requests for their account, prevent the user from creating any new self-serve password reset requests until the number of active requests for the user drops back below this number.', 'coust', 'description'),
    'string'),

( 'circ.password_reset_request_time_to_live',
    oils_i18n_gettext('circ.password_reset_request_time_to_live', 'Circulation: Self-serve password reset request time-to-live', 'coust', 'label'),
    oils_i18n_gettext('circ.password_reset_request_time_to_live', 'Length of time (in seconds) a self-serve password reset request should remain active.', 'coust', 'description'),
    'string'),

( 'circ.password_reset_request_throttle',
    oils_i18n_gettext('circ.password_reset_request_throttle', 'Circulation: Maximum concurrently active self-serve password reset requests', 'coust', 'label'),
    oils_i18n_gettext('circ.password_reset_request_throttle', 'Prevent the creation of new self-serve password reset requests until the number of active requests drops back below this number.', 'coust', 'description'),
    'string')
;

-- 0234.data.org-setting-ui.circ.suppress_checkin_popups.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'ui.circ.suppress_checkin_popups',
        oils_i18n_gettext(
            'ui.circ.suppress_checkin_popups', 
            'Circ: Suppress popup-dialogs during check-in.', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'ui.circ.suppress_checkin_popups', 
            'Circ: Suppress popup-dialogs during check-in.', 
            'coust', 
            'description'),
        'bool'
);

-- 0239.data.org-setting-format.date.time.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'format.date',
        oils_i18n_gettext(
            'format.date',
            'GUI: Format Dates with this pattern.', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'format.date',
            'GUI: Format Dates with this pattern (examples: "yyyy-MM-dd" for "2010-04-26", "MMM d, yyyy" for "Apr 26, 2010")', 
            'coust', 
            'description'),
        'string'
), (
        'format.time',
        oils_i18n_gettext(
            'format.time',
            'GUI: Format Times with this pattern.', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'format.time',
            'GUI: Format Times with this pattern (examples: "h:m:s.SSS a z" for "2:07:20.666 PM Eastern Daylight Time", "HH:mm" for "14:07")', 
            'coust', 
            'description'),
        'string'
);

-- 0247.data.org-setting-cat.bib.delete_on_no_copy_via_acq_lineitem_cancel.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'cat.bib.delete_on_no_copy_via_acq_lineitem_cancel',
        oils_i18n_gettext(
            'cat.bib.delete_on_no_copy_via_acq_lineitem_cancel',
            'CAT: Delete bib if all copies are deleted via Acquisitions lineitem cancellation.', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'cat.bib.delete_on_no_copy_via_acq_lineitem_cancel',
            'CAT: Delete bib if all copies are deleted via Acquisitions lineitem cancellation.', 
            'coust', 
            'description'),
        'bool'
);

-- 0250.data.org-setting-url.remote_column_settings.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'url.remote_column_settings',
        oils_i18n_gettext(
            'url.remote_column_settings',
            'GUI: URL for remote directory containing list column settings.', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'url.remote_column_settings',
            'GUI: URL for remote directory containing list column settings.  The format and naming convention for the files found in this directory match those in the local settings directory for a given workstation.  An administrator could create the desired settings locally and then copy all the tree_columns_for_* files to the remote directory.', 
            'coust', 
            'description'),
        'string'
);
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'gui.disable_local_save_columns',
        oils_i18n_gettext(
            'gui.disable_local_save_columns',
            'GUI: Disable the ability to save list column configurations locally.', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'gui.disable_local_save_columns',
            'GUI: Disable the ability to save list column configurations locally.  If set, columns may still be manipulated, however, the changes do not persist.  Also, existing local configurations are ignored if this setting is true.', 
            'coust', 
            'description'),
        'bool'
);

-- 0290.data.org-setting-password-reset-request.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'circ.password_reset_request_requires_matching_email',
        oils_i18n_gettext(
            'circ.password_reset_request_requires_matching_email',
            'Circulation: Require matching email address for password reset requests', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'circ.password_reset_request_requires_matching_email',
            'Circulation: Require matching email address for password reset requests', 
            'coust', 
            'description'),
        'bool'
);

-- 0305.data.org-setting-circ.holds.expired_patron_block.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'circ.holds.expired_patron_block',
        oils_i18n_gettext(
            'circ.holds.expired_patron_block',
            'Circulation: Block hold request if hold recipient privileges have expired', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'circ.holds.expired_patron_block',
            'Circulation: Block hold request if hold recipient privileges have expired', 
            'coust', 
            'description'),
        'bool'
);

-- 0323.data.booking.elbow_room.sql
INSERT INTO config.org_unit_setting_type
    (name, label, description, datatype) VALUES (
        'circ.booking_reservation.default_elbow_room',
        oils_i18n_gettext(
            'circ.booking_reservation.default_elbow_room',
            'Booking: Elbow room',
            'coust',
            'label'
        ),
        oils_i18n_gettext(
            'circ.booking_reservation.default_elbow_room',
            'Elbow room specifies how far in the future you must make a reservation on an item if that item will have to transit to reach its pickup location.  It secondarily defines how soon a reservation on a given item must start before the check-in process will opportunistically capture it for the reservation shelf.',
            'coust',
            'label'
        ),
        'interval'
    );

-- *** Has to go below coust definition to satisfy referential integrity ***
-- In booking, elbow room defines:
--  a) how far in the future you must make a reservation on a given item if
--      that item will have to transit somewhere to fulfill the reservation.
--  b) how soon a reservation must be starting for the reserved item to
--      be op-captured by the checkin interface.
INSERT INTO actor.org_unit_setting (org_unit, name, value) VALUES (
    (SELECT id FROM actor.org_unit WHERE parent_ou IS NULL),
    'circ.booking_reservation.default_elbow_room',
    '"1 day"'
);

-- Org_unit_setting_type(s) that need an fm_class:
INSERT into config.org_unit_setting_type
( name, label, description, datatype, fm_class ) VALUES
( 'acq.default_copy_location',
  'Default copy location',
  null,
  'link',
  'acpl' );

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
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (1, 'title', oils_i18n_gettext(1, 'Title of work', 'vqbrad', 'description'),'//*[@tag="245"]/*[contains("abcmnopr",@code)]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (2, 'author', oils_i18n_gettext(2, 'Author of work', 'vqbrad', 'description'),'//*[@tag="100" or @tag="110" or @tag="113"]/*[contains("ad",@code)]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (3, 'language', oils_i18n_gettext(3, 'Language of work', 'vqbrad', 'description'),'//*[@tag="240"]/*[@code="l"][1]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (4, 'pagination', oils_i18n_gettext(4, 'Pagination', 'vqbrad', 'description'),'//*[@tag="300"]/*[@code="a"][1]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident, remove ) VALUES (5, 'isbn',oils_i18n_gettext(5, 'ISBN', 'vqbrad', 'description'),'//*[@tag="020"]/*[@code="a"]', TRUE, $r$(?:-|\s.+$)$r$);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident, remove ) VALUES (6, 'issn',oils_i18n_gettext(6, 'ISSN', 'vqbrad', 'description'),'//*[@tag="022"]/*[@code="a"]', TRUE, $r$(?:-|\s.+$)$r$);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (7, 'price',oils_i18n_gettext(7, 'Price', 'vqbrad', 'description'),'//*[@tag="020" or @tag="022"]/*[@code="c"][1]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident ) VALUES (8, 'rec_identifier',oils_i18n_gettext(8, 'Accession Number', 'vqbrad', 'description'),'//*[@tag="001"]', TRUE);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident ) VALUES (9, 'eg_tcn',oils_i18n_gettext(9, 'TCN Value', 'vqbrad', 'description'),'//*[@tag="901"]/*[@code="a"]', TRUE);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident ) VALUES (10, 'eg_tcn_source',oils_i18n_gettext(10, 'TCN Source', 'vqbrad', 'description'),'//*[@tag="901"]/*[@code="b"]', TRUE);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, ident ) VALUES (11, 'eg_identifier',oils_i18n_gettext(11, 'Internal ID', 'vqbrad', 'description'),'//*[@tag="901"]/*[@code="c"]', TRUE);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (12, 'publisher',oils_i18n_gettext(12, 'Publisher', 'vqbrad', 'description'),'//*[@tag="260"]/*[@code="b"][1]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath, remove ) VALUES (13, 'pubdate',oils_i18n_gettext(13, 'Publication Date', 'vqbrad', 'description'),'//*[@tag="260"]/*[@code="c"][1]',$r$\D$r$);
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (14, 'edition',oils_i18n_gettext(14, 'Edition', 'vqbrad', 'description'),'//*[@tag="250"]/*[@code="a"][1]');
INSERT INTO vandelay.bib_attr_definition ( id, code, description, xpath ) VALUES (15, 'item_barcode',oils_i18n_gettext(15, 'Item Barcode', 'vqbrad', 'description'),'//*[@tag="852"]/*[@code="p"][1]');
SELECT SETVAL('vandelay.bib_attr_definition_id_seq'::TEXT, 100);

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

INSERT INTO vandelay.authority_attr_definition (id, code, description, xpath, ident ) VALUES (1, 'rec_identifier',oils_i18n_gettext(1, 'Identifier', 'vqarad', 'description'),'//*[@tag="001"]', TRUE);
SELECT SETVAL('vandelay.authority_attr_definition_id_seq'::TEXT, 100);


INSERT INTO container.copy_bucket_type (code,label) VALUES ('misc', oils_i18n_gettext('misc', 'Miscellaneous', 'ccpbt', 'label'));
INSERT INTO container.copy_bucket_type (code,label) VALUES ('staff_client', oils_i18n_gettext('staff_client', 'General Staff Client container', 'ccpbt', 'label'));
INSERT INTO container.copy_bucket_type (code,label) VALUES ( 'circ_history', 'Circulation History' );
INSERT INTO container.call_number_bucket_type (code,label) VALUES ('misc', oils_i18n_gettext('misc', 'Miscellaneous', 'ccnbt', 'label'));
INSERT INTO container.biblio_record_entry_bucket_type (code,label) VALUES ('misc', oils_i18n_gettext('misc', 'Miscellaneous', 'cbrebt', 'label'));
INSERT INTO container.biblio_record_entry_bucket_type (code,label) VALUES ('staff_client', oils_i18n_gettext('staff_client', 'General Staff Client container', 'cbrebt', 'label'));
INSERT INTO container.biblio_record_entry_bucket_type (code,label) VALUES ('bookbag', oils_i18n_gettext('bookbag', 'Book Bag', 'cbrebt', 'label'));
INSERT INTO container.biblio_record_entry_bucket_type (code,label) VALUES ('reading_list', oils_i18n_gettext('reading_list', 'Reading List', 'cbrebt', 'label'));

INSERT INTO container.user_bucket_type (code,label) VALUES ('misc', oils_i18n_gettext('misc', 'Miscellaneous', 'cubt', 'label'));
INSERT INTO container.user_bucket_type (code,label) VALUES ('folks', oils_i18n_gettext('folks', 'Friends', 'cubt', 'label'));
INSERT INTO container.user_bucket_type (code,label) VALUES ('folks:pub_book_bags.view', oils_i18n_gettext('folks:pub_book_bags.view', 'List Published Book Bags', 'cubt', 'label'));
INSERT INTO container.user_bucket_type (code,label) VALUES ('folks:pub_book_bags.add', oils_i18n_gettext('folks:pub_book_bags.add', 'Add to Published Book Bags', 'cubt', 'label'));
INSERT INTO container.user_bucket_type (code,label) VALUES ('folks:circ.view', oils_i18n_gettext('folks:circ.view', 'View Circulations', 'cubt', 'label'));
INSERT INTO container.user_bucket_type (code,label) VALUES ('folks:circ.renew', oils_i18n_gettext('folks:circ.renew', 'Renew Circulations', 'cubt', 'label'));
INSERT INTO container.user_bucket_type (code,label) VALUES ('folks:circ.checkout', oils_i18n_gettext('folks:circ.checkout', 'Checkout Items', 'cubt', 'label'));
INSERT INTO container.user_bucket_type (code,label) VALUES ('folks:hold.view', oils_i18n_gettext('folks:hold.view', 'View Holds', 'cubt', 'label'));
INSERT INTO container.user_bucket_type (code,label) VALUES ('folks:hold.cancel', oils_i18n_gettext('folks:hold.cancel', 'Cancel Holds', 'cubt', 'label'));


----------------------------------
-- MARC21 record structure data --
----------------------------------

-- Record type map
INSERT INTO config.marc21_rec_type_map (code, type_val, blvl_val) VALUES ('BKS','at','acdm');
INSERT INTO config.marc21_rec_type_map (code, type_val, blvl_val) VALUES ('SER','a','bsi');
INSERT INTO config.marc21_rec_type_map (code, type_val, blvl_val) VALUES ('VIS','gkro','abcdmsi');
INSERT INTO config.marc21_rec_type_map (code, type_val, blvl_val) VALUES ('MIX','p','cdi');
INSERT INTO config.marc21_rec_type_map (code, type_val, blvl_val) VALUES ('MAP','ef','abcdmsi');
INSERT INTO config.marc21_rec_type_map (code, type_val, blvl_val) VALUES ('SCO','cd','abcdmsi');
INSERT INTO config.marc21_rec_type_map (code, type_val, blvl_val) VALUES ('REC','ij','abcdmsi');
INSERT INTO config.marc21_rec_type_map (code, type_val, blvl_val) VALUES ('COM','m','abcdmsi');


------ Physical Characteristics

-- Map
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('a','Map');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('a','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Atlas');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Diagram');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Map');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('k',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Profile');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Model');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Remote-sensing image');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Section');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('y',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'View');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('a','d','3','1','Color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'One color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multicolored');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('a','e','4','1','Physical medium');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Paper');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Wood');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Stone');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Metal');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Synthetics');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Skins');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Textile');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Plaster');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Flexible base photographic medium, positive');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Flexible base photographic medium, negative');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Non-flexible base photographic medium, positive');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('t',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Non-flexible base photographic medium, negative');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('y',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other photographic medium');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('a','f','5','1','Type of reproduction');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Facsimile');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('a','g','6','1','Production/reproduction details');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Photocopy, blueline print');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Photocopy');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Pre-production');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('a','h','7','1','Positive/negative');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Positive');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Negative');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');

-- Electronic Resource
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('c','Electronic Resource');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Tape Cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Chip cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Computer optical disk cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Tape cassette');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Tape reel');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic disk');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magneto-optical disk');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Optical disk');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Remote');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','d','3','1','Color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'One color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Black-and-white');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multicolored');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Gray scale');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','e','4','1','Dimensions');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'3 1/2 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'12 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'4 3/4 in. or 12 cm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1 1/8 x 2 3/8 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'3 7/8 x 2 1/2 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'5 1/4 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('v',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'8 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','f','5','1','Sound');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES (' ',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'No sound (Silent)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','g','6','3','Image bit depth');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('---',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('mmm',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multiple');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('nnn',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','h','9','1','File formats');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'One file format');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multiple file formats');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','i','10','1','Quality assurance target(s)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Absent');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Present');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','j','11','1','Antecedent/Source');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'File reproduced from original');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'File reproduced from microform');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'File reproduced from electronic resource');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'File reproduced from an intermediate (not microform)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','k','12','1','Level of compression');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Uncompressed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Lossless');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Lossy');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('c','l','13','1','Reformatting quality');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Access');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Preservation');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Replacement');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');

-- Globe
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('d','Globe');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('d','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Celestial globe');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Planetary or lunar globe');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Terrestrial globe');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Earth moon globe');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('d','d','3','1','Color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'One color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multicolored');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('d','e','4','1','Physical medium');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Paper');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Wood');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Stone');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Metal');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Synthetics');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Skins');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Textile');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Plaster');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('d','f','5','1','Type of reproduction');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Facsimile');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');

-- Tactile Material
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('f','Tactile Material');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('f','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Moon');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Braille');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Combination');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Tactile, with no writing system');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('f','d','3','2','Class of braille writing');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Literary braille');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Format code braille');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mathematics and scientific braille');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Computer braille');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Music braille');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multiple braille types');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('f','e','4','1','Level of contraction');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Uncontracted');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Contracted');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Combination');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('f','f','6','3','Braille music format');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Bar over bar');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Bar by bar');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Line over line');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Paragraph');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Single line');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Section by section');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Line by line');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Open score');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Spanner short form scoring');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Short form scoring');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('k',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Outline');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('l',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Vertical score');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('f','g','9','1','Special physical characteristics');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Print/braille');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Jumbo or enlarged braille');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');

-- Projected Graphic
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('g','Projected Graphic');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('g','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Film cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Filmstrip');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Film filmstrip type');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Filmstrip roll');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Slide');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('t',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Transparency');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('g','d','3','1','Color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Black-and-white');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multicolored');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Hand-colored');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('g','e','4','1','Base of emulsion');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Glass');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Synthetics');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Safety film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('k',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Film base, other than safety film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed collection');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Paper');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('g','f','5','1','Sound on medium or separate');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound on medium');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound separate from medium');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('g','g','6','1','Medium for sound');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Optical sound track on motion picture film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic sound track on motion picture film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic audio tape in cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound disc');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic audio tape on reel');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic audio tape in cassette');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Optical and magnetic sound track on film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videotape');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videodisc');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('g','h','7','1','Dimensions');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Standard 8 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Super 8 mm./single 8 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'9.5 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'16 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'28 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'35 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'70 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'2 x 2 in. (5 x 5 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('k',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'2 1/4 x 2 1/4 in. (6 x 6 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'4 x 5 in. (10 x 13 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('t',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'5 x 7 in. (13 x 18 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('v',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'8 x 10 in. (21 x 26 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('w',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'9 x 9 in. (23 x 23 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('x',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'10 x 10 in. (26 x 26 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('y',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'7 x 7 in. (18 x 18 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('g','i','8','1','Secondary support material');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Cardboard');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Glass');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Synthetics');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'metal');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Metal and glass');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('k',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Synthetics and glass');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed collection');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');

-- Microform
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('h','Microform');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('h','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Aperture card');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Microfilm cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Microfilm cassette');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Microfilm reel');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Microfiche');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Microfiche cassette');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Microopaque');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('h','d','3','1','Positive/negative');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Positive');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Negative');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('h','e','4','1','Dimensions');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'8 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'16 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'35 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'70mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'105 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('l',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'3 x 5 in. (8 x 13 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'4 x 6 in. (11 x 15 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'6 x 9 in. (16 x 23 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'3 1/4 x 7 3/8 in. (9 x 19 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('h','f','5','4','Reduction ratio range/Reduction ratio');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Low (1-16x)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Normal (16-30x)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'High (31-60x)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Very high (61-90x)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Ultra (90x-)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('v',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Reduction ratio varies');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('h','g','9','1','Color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Black-and-white');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multicolored');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('h','h','10','1','Emulsion on film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Silver halide');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Diazo');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Vesicular');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('h','i','11','1','Quality assurance target(s)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1st gen. master');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Printing master');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Service copy');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed generation');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('h','j','12','1','Base of film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Safety base, undetermined');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Safety base, acetate undetermined');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Safety base, diacetate');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('l',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Nitrate base');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed base');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Safety base, polyester');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Safety base, mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('t',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Safety base, triacetate');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');

-- Non-projected Graphic
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('k','Non-projected Graphic');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('k','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Collage');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Drawing');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Painting');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Photo-mechanical print');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Photonegative');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Photoprint');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Picture');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Print');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('l',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Technical drawing');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Chart');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Flash/activity card');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('k','d','3','1','Color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'One color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Black-and-white');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multicolored');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Hand-colored');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('k','e','4','1','Primary support material');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Canvas');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Bristol board');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Cardboard/illustration board');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Glass');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Synthetics');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Skins');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Textile');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Metal');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed collection');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Paper');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Plaster');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Hardboard');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Porcelain');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Stone');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('t',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Wood');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('k','f','5','1','Secondary support material');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Canvas');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Bristol board');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Cardboard/illustration board');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Glass');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Synthetics');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Skins');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Textile');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Metal');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed collection');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Paper');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Plaster');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Hardboard');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Porcelain');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Stone');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('t',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Wood');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');

-- Motion Picture
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('m','Motion Picture');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('m','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Film cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Film cassette');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Film reel');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('m','d','3','1','Color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Black-and-white');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multicolored');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Hand-colored');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('m','e','4','1','Motion picture presentation format');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Standard sound aperture, reduced frame');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Nonanamorphic (wide-screen)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'3D');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Anamorphic (wide-screen)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other-wide screen format');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Standard. silent aperture, full frame');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('m','f','5','1','Sound on medium or separate');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound on medium');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound separate from medium');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('m','g','6','1','Medium for sound');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Optical sound track on motion picture film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic sound track on motion picture film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic audio tape in cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound disc');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic audio tape on reel');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic audio tape in cassette');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Optical and magnetic sound track on film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videotape');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videodisc');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('m','h','7','1','Dimensions');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Standard 8 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Super 8 mm./single 8 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'9.5 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'16 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'28 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'35 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'70 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('m','i','8','1','Configuration of playback channels');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('k',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Monaural');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multichannel, surround or quadraphonic');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Stereophonic');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('m','j','9','1','Production elements');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Work print');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Trims');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Outtakes');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Rushes');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixing tracks');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Title bands/inter-title rolls');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Production rolls');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');

-- Remote-sensing Image
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('r','Remote-sensing Image');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('r','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('r','d','3','1','Altitude of sensor');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Surface');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Airborne');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Spaceborne');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('r','e','4','1','Attitude of sensor');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Low oblique');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'High oblique');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Vertical');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('r','f','5','1','Cloud cover');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('0',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'0-09%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('1',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'10-19%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('2',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'20-29%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('3',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'30-39%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('4',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'40-49%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('5',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'50-59%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('6',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'60-69%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('7',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'70-79%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('8',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'80-89%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('9',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'90-100%');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('r','g','6','1','Platform construction type');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Balloon');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Aircraft-low altitude');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Aircraft-medium altitude');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Aircraft-high altitude');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Manned spacecraft');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unmanned spacecraft');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Land-based remote-sensing device');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Water surface-based remote-sensing device');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Submersible remote-sensing device');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('r','h','7','1','Platform use category');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Meteorological');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Surface observing');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Space observing');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed uses');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('r','i','8','1','Sensor type');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Active');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Passive');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('r','j','9','2','Data type');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('aa',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Visible light');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('da',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Near infrared');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('db',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Middle infrared');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('dc',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Far infrared');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('dd',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Thermal infrared');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('de',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Shortwave infrared (SWIR)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('df',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Reflective infrared');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('dv',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Combinations');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('dz',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other infrared data');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('ga',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sidelooking airborne radar (SLAR)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('gb',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Synthetic aperture radar (SAR-single frequency)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('gc',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'SAR-multi-frequency (multichannel)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('gd',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'SAR-like polarization');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('ge',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'SAR-cross polarization');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('gf',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Infometric SAR');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('gg',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Polarmetric SAR');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('gu',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Passive microwave mapping');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('gz',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other microwave data');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('ja',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Far ultraviolet');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('jb',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Middle ultraviolet');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('jc',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Near ultraviolet');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('jv',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Ultraviolet combinations');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('jz',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other ultraviolet data');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('ma',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multi-spectral, multidata');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('mb',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multi-temporal');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('mm',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Combination of various data types');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('nn',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('pa',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sonar-water depth');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('pb',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sonar-bottom topography images, sidescan');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('pc',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sonar-bottom topography, near-surface');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('pd',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sonar-bottom topography, near-bottom');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('pe',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Seismic surveys');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('pz',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other acoustical data');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('ra',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Gravity anomales (general)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('rb',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Free-air');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('rc',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Bouger');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('rd',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Isostatic');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('sa',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic field');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('ta',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Radiometric surveys');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('uu',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('zz',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');

-- Sound Recording
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('s','Sound Recording');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('s','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound disc');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Cylinder');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound-track film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Roll');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound cassette');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('t',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound-tape reel');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('w',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Wire recording');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('s','d','3','1','Speed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'16 rpm');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'33 1/3 rpm');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'45 rpm');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'78 rpm');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'8 rpm');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1.4 mps');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'120 rpm');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'160 rpm');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('k',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'15/16 ips');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('l',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1 7/8 ips');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'3 3/4 ips');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'7 1/2 ips');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'15 ips');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'30 ips');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('s','e','4','1','Configuration of playback channels');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Monaural');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Quadraphonic');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Stereophonic');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('s','f','5','1','Groove width or pitch');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Microgroove/fine');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Coarse/standard');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('s','g','6','1','Dimensions');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'3 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'5 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'7 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'10 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'12 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'16 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'4 3/4 in. (12 cm.)');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'3 7/8 x 2 1/2 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'5 1/4 x 3 7/8 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'2 3/4 x 4 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('s','h','7','1','Tape width');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('l',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1/8 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1/4in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1/2 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('s','i','8','1','Tape configuration ');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Full (1) track');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Half (2) track');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Quarter (4) track');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'8 track');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'12 track');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'16 track');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('s','m','12','1','Special playback');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'NAB standard');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'CCIR standard');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Dolby-B encoded, standard Dolby');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'dbx encoded');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Digital recording');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Dolby-A encoded');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Dolby-C encoded');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'CX encoded');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('s','n','13','1','Capture and storage');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Acoustical capture, direct storage');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Direct storage, not acoustical');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Digital storage');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Analog electrical storage');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');

-- Videorecording
INSERT INTO config.marc21_physical_characteristic_type_map (ptype_key, label) VALUES ('v','Videorecording');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('v','b','1','1','SMD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videocartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videodisc');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videocassette');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videoreel');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unspecified');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('v','d','3','1','Color');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Black-and-white');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multicolored');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('v','e','4','1','Videorecording format');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Beta');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'VHS');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'U-matic');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'EIAJ');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Type C');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Quadruplex');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Laserdisc');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'CED');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Betacam');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('j',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Betacam SP');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('k',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Super-VHS');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'M-II');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'D-2');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'8 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Hi-8 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('v',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'DVD');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('v','f','5','1','Sound on medium or separate');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound on medium');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound separate from medium');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('v','g','6','1','Medium for sound');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Optical sound track on motion picture film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('b',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic sound track on motion picture film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('c',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic audio tape in cartridge');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('d',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Sound disc');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('e',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic audio tape on reel');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('f',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Magnetic audio tape in cassette');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('g',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Optical and magnetic sound track on motion picture film');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('h',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videotape');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('i',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Videodisc');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('v','h','7','1','Dimensions');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('a',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'8 mm.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1/4 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('o',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1/2 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('p',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'1 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'2 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('r',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'3/4 in.');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');
INSERT INTO config.marc21_physical_characteristic_subfield_map (ptype_key,subfield,start_pos,length,label) VALUES ('v','i','8','1','Configuration of playback channel');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('k',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Mixed');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('m',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Monaural');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('n',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Not applicable');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('q',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Multichannel, surround or quadraphonic');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('s',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Stereophonic');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('u',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Unknown');
INSERT INTO config.marc21_physical_characteristic_value_map (value,ptype_subfield,label) VALUES ('z',CURRVAL('config.marc21_physical_characteristic_subfield_map_id_seq'),'Other');

-- Fixed Field position data -- 0-based!
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Alph', '006', 'SER', 16, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Alph', '008', 'SER', 33, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '006', 'BKS', 5, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '006', 'COM', 5, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '006', 'REC', 5, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '006', 'SCO', 5, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '006', 'SER', 5, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '006', 'VIS', 5, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '008', 'BKS', 22, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '008', 'COM', 22, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '008', 'REC', 22, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '008', 'SCO', 22, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '008', 'SER', 22, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Audn', '008', 'VIS', 22, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('BLvl', 'ldr', 'BKS', 7, 1, 'm');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('BLvl', 'ldr', 'COM', 7, 1, 'm');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('BLvl', 'ldr', 'MAP', 7, 1, 'm');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('BLvl', 'ldr', 'MIX', 7, 1, 'c');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('BLvl', 'ldr', 'REC', 7, 1, 'm');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('BLvl', 'ldr', 'SCO', 7, 1, 'm');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('BLvl', 'ldr', 'SER', 7, 1, 's');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('BLvl', 'ldr', 'VIS', 7, 1, 'm');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Biog', '006', 'BKS', 17, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Biog', '008', 'BKS', 34, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Conf', '006', 'BKS', 7, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Conf', '006', 'SER', 8, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Conf', '008', 'BKS', 24, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Conf', '008', 'SER', 25, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctrl', 'ldr', 'BKS', 8, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctrl', 'ldr', 'COM', 8, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctrl', 'ldr', 'MAP', 8, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctrl', 'ldr', 'MIX', 8, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctrl', 'ldr', 'REC', 8, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctrl', 'ldr', 'SCO', 8, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctrl', 'ldr', 'SER', 8, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctrl', 'ldr', 'VIS', 8, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctry', '008', 'BKS', 15, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctry', '008', 'COM', 15, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctry', '008', 'MAP', 15, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctry', '008', 'MIX', 15, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctry', '008', 'REC', 15, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctry', '008', 'SCO', 15, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctry', '008', 'SER', 15, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ctry', '008', 'VIS', 15, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date1', '008', 'BKS', 7, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date1', '008', 'COM', 7, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date1', '008', 'MAP', 7, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date1', '008', 'MIX', 7, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date1', '008', 'REC', 7, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date1', '008', 'SCO', 7, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date1', '008', 'SER', 7, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date1', '008', 'VIS', 7, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date2', '008', 'BKS', 11, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date2', '008', 'COM', 11, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date2', '008', 'MAP', 11, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date2', '008', 'MIX', 11, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date2', '008', 'REC', 11, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date2', '008', 'SCO', 11, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date2', '008', 'SER', 11, 4, '9');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Date2', '008', 'VIS', 11, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Desc', 'ldr', 'BKS', 18, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Desc', 'ldr', 'COM', 18, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Desc', 'ldr', 'MAP', 18, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Desc', 'ldr', 'MIX', 18, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Desc', 'ldr', 'REC', 18, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Desc', 'ldr', 'SCO', 18, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Desc', 'ldr', 'SER', 18, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Desc', 'ldr', 'VIS', 18, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('DtSt', '008', 'BKS', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('DtSt', '008', 'COM', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('DtSt', '008', 'MAP', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('DtSt', '008', 'MIX', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('DtSt', '008', 'REC', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('DtSt', '008', 'SCO', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('DtSt', '008', 'SER', 6, 1, 'c');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('DtSt', '008', 'VIS', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('ELvl', 'ldr', 'BKS', 17, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('ELvl', 'ldr', 'COM', 17, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('ELvl', 'ldr', 'MAP', 17, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('ELvl', 'ldr', 'MIX', 17, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('ELvl', 'ldr', 'REC', 17, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('ELvl', 'ldr', 'SCO', 17, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('ELvl', 'ldr', 'SER', 17, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('ELvl', 'ldr', 'VIS', 17, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Fest', '006', 'BKS', 13, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Fest', '008', 'BKS', 30, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '006', 'BKS', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '006', 'MAP', 12, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '006', 'MIX', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '006', 'REC', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '006', 'SCO', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '006', 'SER', 6, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '006', 'VIS', 12, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '008', 'BKS', 23, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '008', 'MAP', 29, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '008', 'MIX', 23, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '008', 'REC', 23, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '008', 'SCO', 23, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '008', 'SER', 23, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Form', '008', 'VIS', 29, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '006', 'BKS', 11, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '006', 'COM', 11, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '006', 'MAP', 11, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '006', 'SER', 11, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '006', 'VIS', 11, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '008', 'BKS', 28, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '008', 'COM', 28, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '008', 'MAP', 28, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '008', 'SER', 28, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('GPub', '008', 'VIS', 28, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ills', '006', 'BKS', 1, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Ills', '008', 'BKS', 18, 4, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Indx', '006', 'BKS', 14, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Indx', '006', 'MAP', 14, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Indx', '008', 'BKS', 31, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Indx', '008', 'MAP', 31, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Lang', '008', 'BKS', 35, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Lang', '008', 'COM', 35, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Lang', '008', 'MAP', 35, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Lang', '008', 'MIX', 35, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Lang', '008', 'REC', 35, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Lang', '008', 'SCO', 35, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Lang', '008', 'SER', 35, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Lang', '008', 'VIS', 35, 3, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('LitF', '006', 'BKS', 16, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('LitF', '008', 'BKS', 33, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('MRec', '008', 'BKS', 38, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('MRec', '008', 'COM', 38, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('MRec', '008', 'MAP', 38, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('MRec', '008', 'MIX', 38, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('MRec', '008', 'REC', 38, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('MRec', '008', 'SCO', 38, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('MRec', '008', 'SER', 38, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('MRec', '008', 'VIS', 38, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('S/L', '006', 'SER', 17, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('S/L', '008', 'SER', 34, 1, '0');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('TMat', '006', 'VIS', 16, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('TMat', '008', 'VIS', 33, 1, ' ');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Type', 'ldr', 'BKS', 6, 1, 'a');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Type', 'ldr', 'COM', 6, 1, 'm');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Type', 'ldr', 'MAP', 6, 1, 'e');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Type', 'ldr', 'MIX', 6, 1, 'p');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Type', 'ldr', 'REC', 6, 1, 'i');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Type', 'ldr', 'SCO', 6, 1, 'c');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Type', 'ldr', 'SER', 6, 1, 'a');
INSERT INTO config.marc21_ff_pos_map (fixed_field, tag, rec_type,start_pos, length, default_val) VALUES ('Type', 'ldr', 'VIS', 6, 1, 'g');

-- Trigger Event Definitions -------------------------------------------------

-- Sample Overdue Notice --

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, delay, delay_field, group_field, max_delay, template) 
    VALUES (1, 'f', 1, '7 Day Overdue Email Notification', 'checkout.due', 'CircIsOverdue', 'SendEmail', '7 days', 'due_date', 'usr', '8 days', 
$$
[%- USE date -%]
[%- user = target.0.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Overdue Notification

Dear [% user.family_name %], [% user.first_given_name %]
Our records indicate the following items are overdue.

[% FOR circ IN target %]
    Title: [% circ.target_copy.call_number.record.simple_record.title %] 
    Barcode: [% circ.target_copy.barcode %] 
    Due: [% date.format(helpers.format_date(circ.due_date), '%Y-%m-%d') %]
    Item Cost: [% helpers.get_copy_price(circ.target_copy) %]
    Total Owed For Transaction: [% circ.billable_transaction.summary.total_owed %]
    Library: [% circ.circ_lib.name %]
[% END %]

$$);

INSERT INTO action_trigger.environment (event_def, path) VALUES 
    (1, 'target_copy.call_number.record.simple_record'),
    (1, 'usr'),
    (1, 'billable_transaction.summary'),
    (1, 'circ_lib.billing_address');

-- Sample Mark Long-Overdue Item Lost --

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, delay, delay_field) 
    VALUES (2, 'f', 1, '90 Day Overdue Mark Lost', 'checkout.due', 'CircIsOverdue', 'MarkItemLost', '90 days', 'due_date');

-- Sample Auto Mark Lost Notice --

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, group_field, template) 
    VALUES (3, 'f', 1, '90 Day Overdue Mark Lost Notice', 'lost.auto', 'NOOP_True', 'SendEmail', 'usr',
$$
[%- USE date -%]
[%- user = target.0.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Overdue Items Marked Lost

Dear [% user.family_name %], [% user.first_given_name %]
The following items are 90 days overdue and have been marked LOST.

[% FOR circ IN target %]
    Title: [% circ.target_copy.call_number.record.simple_record.title %] 
    Barcode: [% circ.target_copy.barcode %] 
    Due: [% date.format(helpers.format_date(circ.due_date), '%Y-%m-%d') %]
    Item Cost: [% helpers.get_copy_price(circ.target_copy) %]
    Total Owed For Transaction: [% circ.billable_transaction.summary.total_owed %]
    Library: [% circ.circ_lib.name %]
[% END %]

$$);


INSERT INTO action_trigger.environment (event_def, path) VALUES 
    (3, 'target_copy.call_number.record.simple_record'),
    (3, 'usr'),
    (3, 'billable_transaction.summary'),
    (3, 'circ_lib.billing_address');

-- Sample Purchase Order HTML Template --

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, template) 
    VALUES (4, 't', 1, 'PO HTML', 'format.po.html', 'NOOP_True', 'ProcessTemplate', 
$$
[%- USE date -%]
[%-
    # find a lineitem attribute by name and optional type
    BLOCK get_li_attr;
        FOR attr IN li.attributes;
            IF attr.attr_name == attr_name;
                IF !attr_type OR attr_type == attr.attr_type;
                    attr.attr_value;
                    LAST;
                END;
            END;
        END;
    END
-%]

<h2>Purchase Order [% target.id %]</h2>
<br/>
date <b>[% date.format(date.now, '%Y%m%d') %]</b>
<br/>

<style>
    table td { padding:5px; border:1px solid #aaa;}
    table { width:95%; border-collapse:collapse; }
    #vendor-notes { padding:5px; border:1px solid #aaa; }
</style>
<table id='vendor-table'>
  <tr>
    <td valign='top'>Vendor</td>
    <td>
      <div>[% target.provider.name %]</div>
      <div>[% target.provider.addresses.0.street1 %]</div>
      <div>[% target.provider.addresses.0.street2 %]</div>
      <div>[% target.provider.addresses.0.city %]</div>
      <div>[% target.provider.addresses.0.state %]</div>
      <div>[% target.provider.addresses.0.country %]</div>
      <div>[% target.provider.addresses.0.post_code %]</div>
    </td>
    <td valign='top'>Ship to / Bill to</td>
    <td>
      <div>[% target.ordering_agency.name %]</div>
      <div>[% target.ordering_agency.billing_address.street1 %]</div>
      <div>[% target.ordering_agency.billing_address.street2 %]</div>
      <div>[% target.ordering_agency.billing_address.city %]</div>
      <div>[% target.ordering_agency.billing_address.state %]</div>
      <div>[% target.ordering_agency.billing_address.country %]</div>
      <div>[% target.ordering_agency.billing_address.post_code %]</div>
    </td>
  </tr>
</table>

<br/><br/>
<fieldset id='vendor-notes'>
    <legend>Notes to the Vendor</legend>
    <ul>
    [% FOR note IN target.notes %]
        [% IF note.vendor_public == 't' %]
            <li>[% note.value %]</li>
        [% END %]
    [% END %]
    </ul>
</fieldset>
<br/><br/>

<table>
  <thead>
    <tr>
      <th>PO#</th>
      <th>ISBN or Item #</th>
      <th>Title</th>
      <th>Quantity</th>
      <th>Unit Price</th>
      <th>Line Total</th>
      <th>Notes</th>
    </tr>
  </thead>
  <tbody>

  [% subtotal = 0 %]
  [% FOR li IN target.lineitems %]

  <tr>
    [% count = li.lineitem_details.size %]
    [% price = li.estimated_unit_price %]
    [% litotal = (price * count) %]
    [% subtotal = subtotal + litotal %]
    [% isbn = PROCESS get_li_attr attr_name = 'isbn' %]
    [% ident = PROCESS get_li_attr attr_name = 'identifier' %]

    <td>[% target.id %]</td>
    <td>[% isbn || ident %]</td>
    <td>[% PROCESS get_li_attr attr_name = 'title' %]</td>
    <td>[% count %]</td>
    <td>[% price %]</td>
    <td>[% litotal %]</td>
    <td>
        <ul>
        [% FOR note IN li.lineitem_notes %]
            [% IF note.vendor_public == 't' %]
                <li>[% note.value %]</li>
            [% END %]
        [% END %]
        </ul>
    </td>
  </tr>
  [% END %]
  <tr>
    <td/><td/><td/><td/>
    <td>Sub Total</td>
    <td>[% subtotal %]</td>
  </tr>
  </tbody>
</table>

<br/>

Total Line Item Count: [% target.lineitems.size %]
$$);

INSERT INTO action_trigger.environment (event_def, path) VALUES 
    (4, 'lineitems.lineitem_details.fund'),
    (4, 'lineitems.lineitem_details.location'),
    (4, 'lineitems.lineitem_details.owning_lib'),
    (4, 'ordering_agency.mailing_address'),
    (4, 'ordering_agency.billing_address'),
    (4, 'provider.addresses'),
    (4, 'lineitems.attributes'),
    (4, 'lineitems.lineitem_notes'),
    (4, 'notes');


INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, delay, delay_field, group_field, template)
    VALUES (5, 'f', 1, 'Hold Ready for Pickup Email Notification', 'hold.available', 'HoldIsAvailable', 'SendEmail', '30 minutes', 'shelf_time', 'usr',
$$
[%- USE date -%]
[%- user = target.0.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Hold Available Notification

Dear [% user.family_name %], [% user.first_given_name %]
The item(s) you requested are available for pickup from the Library.

[% FOR hold IN target %]
    Title: [% hold.current_copy.call_number.record.simple_record.title %]
    Author: [% hold.current_copy.call_number.record.simple_record.author %]
    Call Number: [% hold.current_copy.call_number.label %]
    Barcode: [% hold.current_copy.barcode %]
    Library: [% hold.pickup_lib.name %]
[% END %]

$$);


INSERT INTO action_trigger.hook (
        key,
        core_type,
        description,
        passive
    ) VALUES (
        'hold_request.shelf_expires_soon',
        'ahr',
        'A hold on the shelf will expire there soon.',
        TRUE
    );

INSERT INTO action_trigger.environment (event_def, path) VALUES
    (5, 'current_copy.call_number.record.simple_record'),
    (5, 'usr'),
    (5, 'pickup_lib.billing_address');


INSERT INTO action_trigger.event_definition (
        id,
        active,
        owner,
        name,
        hook,
        validator,
        reactor,
        delay,
        delay_field,
        group_field,
        template
    ) VALUES (
        7,
        FALSE,
        1,
        'Hold Expires from Shelf Soon',
        'hold_request.shelf_expires_soon',
        'HoldIsAvailable',
        'SendEmail',
        '- 1 DAY',
        'shelf_expire_time',
        'usr',
$$
[%- USE date -%]
[%- user = target.0.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Hold Available Notification

Dear [% user.family_name %], [% user.first_given_name %]
You requested holds on the following item(s), which are available for
pickup, but these holds will soon expire.

[% FOR hold IN target %]
    [%- data = helpers.get_copy_bib_basics(hold.current_copy.id) -%]
    Title: [% data.title %]
    Author: [% data.author %]
    Library: [% hold.pickup_lib.name %]
[% END %]
$$
);


INSERT INTO action_trigger.environment (
        event_def,
        path
    ) VALUES
    ( 7, 'current_copy'),
    ( 7, 'pickup_lib.billing_address'),
    ( 7, 'usr');

-- long wait hold request notifications

INSERT INTO action_trigger.hook (
        key,
        core_type,
        description,
        passive
    ) VALUES (
        'hold_request.long_wait',
        'ahr',
        'A patron has been waiting on a hold to be fulfilled for a long time.',
        TRUE
    );

INSERT INTO action_trigger.event_definition (
        id,
        active,
        owner,
        name,
        hook,
        validator,
        reactor,
        delay,
        delay_field,
        group_field,
        template
    ) VALUES (
        9,
        FALSE,
        1,
        'Hold waiting for pickup for long time',
        'hold_request.long_wait',
        'NOOP_True',
        'SendEmail',
        '6 MONTHS',
        'request_time',
        'usr',
$$
[%- USE date -%]
[%- user = target.0.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Long Wait Hold Notification

Dear [% user.family_name %], [% user.first_given_name %]

You requested hold(s) on the following item(s), but unfortunately
we have not been able to fulfill your request after a considerable
length of time.  If you would still like to recieve these items,
no action is required.

[% FOR hold IN target %]
    Title: [% hold.bib_rec.bib_record.simple_record.title %]
    Author: [% hold.bib_rec.bib_record.simple_record.author %]
[% END %]
$$
);

INSERT INTO action_trigger.environment (event_def, path)
    VALUES
        (9, 'pickup_lib'),
        (9, 'usr'),
        (9, 'bib_rec.bib_record.simple_record');

-- trigger data related to acq user requests

INSERT INTO action_trigger.hook (key,core_type,description,passive) VALUES (
        'aur.ordered',
        'aur', 
        oils_i18n_gettext(
            'aur.ordered',
            'A patron acquisition request has been marked On-Order.',
            'ath',
            'description'
        ), 
        TRUE
    ), (
        'aur.received', 
        'aur', 
        oils_i18n_gettext(
            'aur.received', 
            'A patron acquisition request has been marked Received.',
            'ath',
            'description'
        ),
        TRUE
    ), (
        'aur.cancelled',
        'aur',
        oils_i18n_gettext(
            'aur.cancelled',
            'A patron acquisition request has been marked Cancelled.',
            'ath',
            'description'
        ),
        TRUE
    ), (
        'aur.created',
        'aur',
        oils_i18n_gettext(
            'aur.created',
            'A patron has made an acquisitions request.',
            'ath',
            'description'
        ),
        TRUE
    ), (
        'aur.rejected',
        'aur',
        oils_i18n_gettext(
            'aur.rejected',
            'A patron acquisition request has been rejected.',
            'ath',
            'description'
        ),
        TRUE
    )
;

INSERT INTO action_trigger.validator (module,description) VALUES (
        'Acq::UserRequestOrdered',
        oils_i18n_gettext(
            'Acq::UserRequestOrdered',
            'Tests to see if the corresponding Line Item has a state of "on-order".',
            'atval',
            'description'
        )
    ), (
        'Acq::UserRequestReceived',
        oils_i18n_gettext(
            'Acq::UserRequestReceived',
            'Tests to see if the corresponding Line Item has a state of "received".',
            'atval',
            'description'
        )
    ), (
        'Acq::UserRequestCancelled',
        oils_i18n_gettext(
            'Acq::UserRequestCancelled',
            'Tests to see if the corresponding Line Item has a state of "cancelled".',
            'atval',
            'description'
        )
    )
;

INSERT INTO action_trigger.event_definition (
        id,
        active,
        owner,
        name,
        hook,
        validator,
        reactor,
        template
    ) VALUES (
        15,
        FALSE,
        1,
        'Email Notice: Patron Acquisition Request marked On-Order.',
        'aur.ordered',
        'Acq::UserRequestOrdered',
        'SendEmail',
$$
[%- USE date -%]
[%- SET li = target.lineitem; -%]
[%- SET user = target.usr -%]
[%- SET title = helpers.get_li_attr("title", "", li.attributes) -%]
[%- SET author = helpers.get_li_attr("author", "", li.attributes) -%]
[%- SET edition = helpers.get_li_attr("edition", "", li.attributes) -%]
[%- SET isbn = helpers.get_li_attr("isbn", "", li.attributes) -%]
[%- SET publisher = helpers.get_li_attr("publisher", "", li.attributes) -%]
[%- SET pubdate = helpers.get_li_attr("pubdate", "", li.attributes) -%]

To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Acquisition Request Notification

Dear [% user.family_name %], [% user.first_given_name %]
Our records indicate the following acquisition request has been placed on order.

Title: [% title %]
[% IF author %]Author: [% author %][% END %]
[% IF edition %]Edition: [% edition %][% END %]
[% IF isbn %]ISBN: [% isbn %][% END %]
[% IF publisher %]Publisher: [% publisher %][% END %]
[% IF pubdate %]Publication Date: [% pubdate %][% END %]
Lineitem ID: [% li.id %]
$$
    ), (
        16,
        FALSE,
        1,
        'Email Notice: Patron Acquisition Request marked Received.',
        'aur.received',
        'Acq::UserRequestReceived',
        'SendEmail',
$$
[%- USE date -%]
[%- SET li = target.lineitem; -%]
[%- SET user = target.usr -%]
[%- SET title = helpers.get_li_attr("title", "", li.attributes) %]
[%- SET author = helpers.get_li_attr("author", "", li.attributes) %]
[%- SET edition = helpers.get_li_attr("edition", "", li.attributes) %]
[%- SET isbn = helpers.get_li_attr("isbn", "", li.attributes) %]
[%- SET publisher = helpers.get_li_attr("publisher", "", li.attributes) -%]
[%- SET pubdate = helpers.get_li_attr("pubdate", "", li.attributes) -%]

To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Acquisition Request Notification

Dear [% user.family_name %], [% user.first_given_name %]
Our records indicate the materials for the following acquisition request have been received.

Title: [% title %]
[% IF author %]Author: [% author %][% END %]
[% IF edition %]Edition: [% edition %][% END %]
[% IF isbn %]ISBN: [% isbn %][% END %]
[% IF publisher %]Publisher: [% publisher %][% END %]
[% IF pubdate %]Publication Date: [% pubdate %][% END %]
Lineitem ID: [% li.id %]
$$
    ), (
        17,
        FALSE,
        1,
        'Email Notice: Patron Acquisition Request marked Cancelled.',
        'aur.cancelled',
        'Acq::UserRequestCancelled',
        'SendEmail',
$$
[%- USE date -%]
[%- SET li = target.lineitem; -%]
[%- SET user = target.usr -%]
[%- SET title = helpers.get_li_attr("title", "", li.attributes) %]
[%- SET author = helpers.get_li_attr("author", "", li.attributes) %]
[%- SET edition = helpers.get_li_attr("edition", "", li.attributes) %]
[%- SET isbn = helpers.get_li_attr("isbn", "", li.attributes) %]
[%- SET publisher = helpers.get_li_attr("publisher", "", li.attributes) -%]
[%- SET pubdate = helpers.get_li_attr("pubdate", "", li.attributes) -%]

To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Acquisition Request Notification

Dear [% user.family_name %], [% user.first_given_name %]
Our records indicate the following acquisition request has been cancelled.

Title: [% title %]
[% IF author %]Author: [% author %][% END %]
[% IF edition %]Edition: [% edition %][% END %]
[% IF isbn %]ISBN: [% isbn %][% END %]
[% IF publisher %]Publisher: [% publisher %][% END %]
[% IF pubdate %]Publication Date: [% pubdate %][% END %]
Lineitem ID: [% li.id %]
$$
    ), (
        18,
        FALSE,
        1,
        'Email Notice: Acquisition Request created.',
        'aur.created',
        'NOOP_True',
        'SendEmail',
$$
[%- USE date -%]
[%- SET user = target.usr -%]
[%- SET title = target.title -%]
[%- SET author = target.author -%]
[%- SET isxn = target.isxn -%]
[%- SET publisher = target.publisher -%]
[%- SET pubdate = target.pubdate -%]

To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Acquisition Request Notification

Dear [% user.family_name %], [% user.first_given_name %]
Our records indicate that you have made the following acquisition request:

Title: [% title %]
[% IF author %]Author: [% author %][% END %]
[% IF edition %]Edition: [% edition %][% END %]
[% IF isbn %]ISXN: [% isxn %][% END %]
[% IF publisher %]Publisher: [% publisher %][% END %]
[% IF pubdate %]Publication Date: [% pubdate %][% END %]
$$
    ), (
        19,
        FALSE,
        1,
        'Email Notice: Acquisition Request Rejected.',
        'aur.rejected',
        'NOOP_True',
        'SendEmail',
$$
[%- USE date -%]
[%- SET user = target.usr -%]
[%- SET title = target.title -%]
[%- SET author = target.author -%]
[%- SET isxn = target.isxn -%]
[%- SET publisher = target.publisher -%]
[%- SET pubdate = target.pubdate -%]
[%- SET cancel_reason = target.cancel_reason.description -%]

To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Acquisition Request Notification

Dear [% user.family_name %], [% user.first_given_name %]
Our records indicate the following acquisition request has been rejected for this reason: [% cancel_reason %]

Title: [% title %]
[% IF author %]Author: [% author %][% END %]
[% IF edition %]Edition: [% edition %][% END %]
[% IF isbn %]ISBN: [% isbn %][% END %]
[% IF publisher %]Publisher: [% publisher %][% END %]
[% IF pubdate %]Publication Date: [% pubdate %][% END %]
$$
    )
;

INSERT INTO action_trigger.environment (
        event_def,
        path
    ) VALUES 
        ( 15, 'lineitem' ),
        ( 15, 'lineitem.attributes' ),
        ( 15, 'usr' ),

        ( 16, 'lineitem' ),
        ( 16, 'lineitem.attributes' ),
        ( 16, 'usr' ),

        ( 17, 'lineitem' ),
        ( 17, 'lineitem.attributes' ),
        ( 17, 'usr' ),

        ( 18, 'usr' ),
        ( 19, 'usr' ),
        ( 19, 'cancel_reason' )
    ;

INSERT INTO action_trigger.hook (key,core_type,description) VALUES ('password.reset_request','aupr','Patron has requested a self-serve password reset');
INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, delay, template) 
    VALUES (20, 'f', 1, 'Password reset request notification', 'password.reset_request', 'NOOP_True', 'SendEmail', '00:00:01',
$$
[%- USE date -%]
[%- user = target.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || user.home_ou.email || default_sender %]
Subject: [% user.home_ou.name %]: library account password reset request
  
You have received this message because you, or somebody else, requested a reset
of your library system password. If you did not request a reset of your library
system password, just ignore this message and your current password will
continue to work.

If you did request a reset of your library system password, please perform
the following steps to continue the process of resetting your password:

1. Open the following link in a web browser: https://[% params.hostname %]/opac/password/[% params.locale || 'en-US' %]/[% target.uuid %]
The browser displays a password reset form.

2. Enter your new password in the password reset form in the browser. You must
enter the password twice to ensure that you do not make a mistake. If the
passwords match, you will then be able to log in to your library system account
with the new password.

$$);
INSERT INTO action_trigger.environment ( event_def, path) VALUES
    ( 20, 'usr' );
INSERT INTO action_trigger.environment ( event_def, path) VALUES
    ( 20, 'usr.home_ou' );


INSERT INTO action_trigger.hook (key, core_type, description, passive)
    VALUES (
        'format.acqcle.html',
        'acqcle',
        'Formats claim events into a voucher',
        TRUE
    );

INSERT INTO action_trigger.event_definition (
        id, active, owner, name, hook, group_field,
        validator, reactor, granularity, template
    ) VALUES (
        21,
        TRUE,
        1,
        'Claim Voucher',
        'format.acqcle.html',
        'claim',
        'NOOP_True',
        'ProcessTemplate',
        'print-on-demand',
$$
[%- USE date -%]
[%- SET claim = target.0.claim -%]
<!-- This will need refined/prettified. -->
<div class="acq-claim-voucher">
    <h2>Claim: [% claim.id %] ([% claim.type.code %])</h2>
    <h3>Against: [%- helpers.get_li_attr("title", "", claim.lineitem_detail.lineitem.attributes) -%]</h3>
    <ul>
        [% FOR event IN target %]
        <li>
            Event type: [% event.type.code %]
            [% IF event.type.library_initiated %](Library initiated)[% END %]
            <br />
            Event date: [% event.event_date %]<br />
            Order date: [% event.claim.lineitem_detail.lineitem.purchase_order.order_date %]<br />
            Expected receive date: [% event.claim.lineitem_detail.lineitem.expected_recv_time %]<br />
            Initiated by: [% event.creator.family_name %], [% event.creator.first_given_name %] [% event.creator.second_given_name %]<br />
            Barcode: [% event.claim.lineitem_detail.barcode %]; Fund:
            [% event.claim.lineitem_detail.fund.code %]
            ([% event.claim.lineitem_detail.fund.year %])
        </li>
        [% END %]
    </ul>
</div>
$$
);

INSERT INTO action_trigger.environment (event_def, path) VALUES
    (21, 'claim'),
    (21, 'claim.type'),
    (21, 'claim.lineitem_detail'),
    (21, 'claim.lineitem_detail.fund'),
    (21, 'claim.lineitem_detail.lineitem.attributes'),
    (21, 'claim.lineitem_detail.lineitem.purchase_order'),
    (21, 'creator'),
    (21, 'type')
;


INSERT INTO action_trigger.hook (key, core_type, description, passive)
    VALUES (
        'format.acqinv.html',
        'acqinv',
        'Formats invoices into a voucher',
        TRUE
    );

INSERT INTO action_trigger.event_definition (
        id, active, owner, name, hook,
        validator, reactor, granularity, template
    ) VALUES (
        22,
        TRUE,
        1,
        'Invoice',
        'format.acqinv.html',
        'NOOP_True',
        'ProcessTemplate',
        'print-on-demand',
$$
[% FILTER collapse %]
[%- SET invoice = target -%]
<!-- This lacks totals, info about funds (for invoice entries,
    funds are per-LID!), and general refinement -->
<div class="acq-invoice-voucher">
    <h1>Invoice</h1>
    <div>
        <strong>No.</strong> [% invoice.inv_ident %]
        [% IF invoice.inv_type %]
            / <strong>Type:</strong>[% invoice.inv_type %]
        [% END %]
    </div>
    <div>
        <dl>
            [% BLOCK ent_with_address %]
            <dt>[% ent_label %]: [% ent.name %] ([% ent.code %])</dt>
            <dd>
                [% IF ent.addresses.0 %]
                    [% SET addr = ent.addresses.0 %]
                    [% addr.street1 %]<br />
                    [% IF addr.street2 %][% addr.street2 %]<br />[% END %]
                    [% addr.city %],
                    [% IF addr.county %] [% addr.county %], [% END %]
                    [% IF addr.state %] [% addr.state %] [% END %]
                    [% IF addr.post_code %][% addr.post_code %][% END %]<br />
                    [% IF addr.country %] [% addr.country %] [% END %]
                [% END %]
                <p>
                    [% IF ent.phone %] Phone: [% ent.phone %]<br />[% END %]
                    [% IF ent.fax_phone %] Fax: [% ent.fax_phone %]<br />[% END %]
                    [% IF ent.url %] URL: [% ent.url %]<br />[% END %]
                    [% IF ent.email %] E-mail: [% ent.email %] [% END %]
                </p>
            </dd>
            [% END %]
            [% INCLUDE ent_with_address
                ent = invoice.provider
                ent_label = "Provider" %]
            [% INCLUDE ent_with_address
                ent = invoice.shipper
                ent_label = "Shipper" %]
            <dt>Receiver</dt>
            <dd>
                [% invoice.receiver.name %] ([% invoice.receiver.shortname %])
            </dd>
            <dt>Received</dt>
            <dd>
                [% helpers.format_date(invoice.recv_date) %] by
                [% invoice.recv_method %]
            </dd>
            [% IF invoice.note %]
                <dt>Note</dt>
                <dd>
                    [% invoice.note %]
                </dd>
            [% END %]
        </dl>
    </div>
    <ul>
        [% FOR entry IN invoice.entries %]
            <li>
                [% IF entry.lineitem %]
                    Title: [% helpers.get_li_attr(
                        "title", "", entry.lineitem.attributes
                    ) %]<br />
                    Author: [% helpers.get_li_attr(
                        "author", "", entry.lineitem.attributes
                    ) %]
                [% END %]
                [% IF entry.purchase_order %]
                    (PO: [% entry.purchase_order.name %])
                [% END %]<br />
                Invoice item count: [% entry.inv_item_count %]
                [% IF entry.phys_item_count %]
                    / Physical item count: [% entry.phys_item_count %]
                [% END %]
                <br />
                [% IF entry.cost_billed %]
                    Cost billed: [% entry.cost_billed %]
                    [% IF entry.billed_per_item %](per item)[% END %]
                    <br />
                [% END %]
                [% IF entry.actual_cost %]
                    Actual cost: [% entry.actual_cost %]<br />
                [% END %]
                [% IF entry.amount_paid %]
                    Amount paid: [% entry.amount_paid %]<br />
                [% END %]
                [% IF entry.note %]Note: [% entry.note %][% END %]
            </li>
        [% END %]
        [% FOR item IN invoice.items %]
            <li>
                [% IF item.inv_item_type %]
                    Item Type: [% item.inv_item_type %]<br />
                [% END %]
                [% IF item.title %]Title/Description:
                    [% item.title %]<br />
                [% END %]
                [% IF item.author %]Author: [% item.author %]<br />[% END %]
                [% IF item.purchase_order %]PO: [% item.purchase_order %]<br />[% END %]
                [% IF item.note %]Note: [% item.note %]<br />[% END %]
                [% IF item.cost_billed %]
                    Cost billed: [% item.cost_billed %]<br />
                [% END %]
                [% IF item.actual_cost %]
                    Actual cost: [% item.actual_cost %]<br />
                [% END %]
                [% IF item.amount_paid %]
                    Amount paid: [% item.amount_paid %]<br />
                [% END %]
            </li>
        [% END %]
    </ul>
</div>
[% END %]
$$
);


INSERT INTO action_trigger.environment (event_def, path) VALUES
    (22, 'provider'),
    (22, 'provider.addresses'),
    (22, 'shipper'),
    (22, 'shipper.addresses'),
    (22, 'receiver'),
    (22, 'entries'),
    (22, 'entries.purchase_order'),
    (22, 'entries.lineitem'),
    (22, 'entries.lineitem.attributes'),
    (22, 'items')
;

SELECT SETVAL('action_trigger.event_definition_id_seq'::TEXT, 100);

-- Org Unit Settings for configuring org unit weights and org unit max-loops for hold targeting

INSERT INTO config.org_unit_setting_type (name, label, description, datatype) VALUES (
    'circ.holds.org_unit_target_weight',
    'Holds: Org Unit Target Weight',
    'Org Units can be organized into hold target groups based on a weight.  Potential copies from org units with the same weight are chosen at random.',
    'integer'
);

INSERT INTO config.org_unit_setting_type (name, label, description, datatype) VALUES (
    'circ.holds.target_holds_by_org_unit_weight',
    'Holds: Use weight-based hold targeting',
    'Use library weight based hold targeting',
    'bool'
);

INSERT INTO config.org_unit_setting_type (name, label, description, datatype) VALUES (
    'circ.holds.max_org_unit_target_loops',
    'Holds: Maximum library target attempts',
    'When this value is set and greater than 0, the system will only attempt to find a copy at each possible branch the configured number of times',
    'integer'
);


-- Org setting for overriding the circ lib of a precat copy
INSERT INTO config.org_unit_setting_type (name, label, description, datatype) VALUES (
    'circ.pre_cat_copy_circ_lib',
    'Pre-cat Item Circ Lib',
    'Override the default circ lib of "here" with a pre-configured circ lib for pre-cat items.  The value should be the "shortname" (aka policy name) of the org unit',
    'string'
);

-- Circ auto-renew interval setting
INSERT INTO config.org_unit_setting_type (name, label, description, datatype) VALUES (
    'circ.checkout_auto_renew_age',
    'Checkout auto renew age',
    'When an item has been checked out for at least this amount of time, an attempt to check out the item to the patron that it is already checked out to will simply renew the circulation',
    'interval'
);

-- Setting for behind the desk hold pickups
INSERT INTO config.org_unit_setting_type (name, label, description, datatype) VALUES (
    'circ.holds.behind_desk_pickup_supported',
    'Holds: Behind Desk Pickup Supported',
    'If a branch supports both a public holds shelf and behind-the-desk pickups, set this value to true.  This gives the patron the option to enable behind-the-desk pickups for their holds',
    'bool'
);

-- 0227.data.org-setting-acq.holds.allow_holds_from_purchase_request.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'acq.holds.allow_holds_from_purchase_request',
        oils_i18n_gettext(
            'acq.holds.allow_holds_from_purchase_request', 
            'Allows patrons to create automatic holds from purchase requests.', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'acq.holds.allow_holds_from_purchase_request', 
            'Allows patrons to create automatic holds from purchase requests.', 
            'coust', 
            'description'),
        'bool'
);

-- Hold cancel action/trigger hooks

INSERT INTO action_trigger.hook (key,core_type,description) VALUES (
    'hold_request.cancel.expire_no_target',
    'ahr',
    'A hold is cancelled because no copies were found'
);

INSERT INTO action_trigger.hook (key,core_type,description) VALUES (
    'hold_request.cancel.expire_holds_shelf',
    'ahr',
    'A hold is cancelled becuase it was on the holds shelf too long'
);

INSERT INTO action_trigger.hook (key,core_type,description) VALUES (
    'hold_request.cancel.staff',
    'ahr',
    'A hold is cancelled becuase it was cancelled by staff'
);

INSERT INTO action_trigger.hook (key,core_type,description) VALUES (
    'hold_request.cancel.patron',
    'ahr',
    'A hold is cancelled by the patron'
);



-- hold targeter skip me
INSERT INTO config.org_unit_setting_type (name, label, description, datatype) VALUES (
    'circ.holds.target_skip_me',
    'Skip For Hold Targeting',
    'When true, don''t target any copies at this org unit for holds',
    'bool'
);


-- in-db indexing normalizers
INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'NACO Normalize',
	'Apply NACO normalization rules to the extracted text.  See http://www.loc.gov/catdir/pcc/naco/normrule-2.html for details.',
	'naco_normalize',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Normalize date range',
	'Split date ranges in the form of "XXXX-YYYY" into "XXXX YYYY" for proper index.',
	'split_date_range',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'NACO Normalize -- retain first comma',
	'Apply NACO normalization rules to the extracted text, retaining the first comma.  See http://www.loc.gov/catdir/pcc/naco/normrule-2.html for details.',
	'naco_normalize_keep_comma',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Strip Diacritics',
	'Convert text to NFD form and remove non-spacing combining marks.',
	'remove_diacritics',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Remove Parenthesized Substring',
	'Remove any parenthesized substrings from the extracted text, such as the agency code preceding authority record control numbers in subfield 0.',
	'remove_paren_substring',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Up-case',
	'Convert text upper case.',
	'uppercase',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Down-case',
	'Convert text lower case.',
	'lowercase',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Extract Dewey-like number',
	'Extract a string of numeric characters that resembles a DDC number.',
	'call_number_dewey',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Left truncation',
	'Discard the specified number of characters from the left side of the string.',
	'left_trunc',
	1
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Right truncation',
	'Include only the specified number of characters from the left side of the string.',
	'right_trunc',
	1
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'First word',
	'Include only the first space-separated word of a string.',
	'first_word',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'ISBN 10/13 conversion',
	'Translate ISBN10 to ISBN13 and vice versa.',
	'translate_isbn1013',
	0
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Replace',
	'Replace all occurances of first parameter in the string with the second parameter.',
	'replace',
	2
);

INSERT INTO config.index_normalizer (name, description, func, param_count) VALUES (
	'Trim Surrounding Space',
	'Trim leading and trailing spaces from extracted text.',
	'btrim',
	0
);

-- make use of the index normalizers

INSERT INTO config.metabib_field_index_norm_map (field,norm)
    SELECT  m.id,
            i.id
      FROM  config.metabib_field m,
        config.index_normalizer i
      WHERE i.func IN ('naco_normalize','split_date_range')
            AND m.id NOT IN (18, 19);

INSERT INTO config.metabib_field_index_norm_map (field,norm,pos)
    SELECT  m.id,
            i.id,
            2
      FROM  config.metabib_field m,
            config.index_normalizer i
      WHERE i.func IN ('translate_isbn1013')
            AND m.id IN (18);

INSERT INTO config.metabib_field_index_norm_map (field,norm,params)
    SELECT  m.id,
            i.id,
            $$["-",""]$$
      FROM  config.metabib_field m,
            config.index_normalizer i
      WHERE i.func IN ('replace')
            AND m.id IN (19);

INSERT INTO config.metabib_field_index_norm_map (field,norm,params)
    SELECT  m.id,
            i.id,
            $$[" ",""]$$
      FROM  config.metabib_field m,
            config.index_normalizer i
      WHERE i.func IN ('replace')
            AND m.id IN (19);


-- claims returned mark item missing 
INSERT INTO
    config.org_unit_setting_type ( name, label, description, datatype )
    VALUES (
        'circ.claim_return.mark_missing',
        'Claim Return: Mark copy as missing', 
        'When a circ is marked as claims-returned, also mark the copy as missing',
        'bool'
    );

-- claims never checked out mark item missing 
INSERT INTO
    config.org_unit_setting_type ( name, label, description, datatype )
    VALUES (
        'circ.claim_never_checked_out.mark_missing',
        'Claim Never Checked Out: Mark copy as missing', 
        'When a circ is marked as claims-never-checked-out, mark the copy as missing',
        'bool'
    );

-- mark damaged void overdue setting
INSERT INTO
    config.org_unit_setting_type ( name, label, description, datatype )
    VALUES (
        'circ.damaged.void_ovedue',
        'Mark item damaged voids overdues',
        'When an item is marked damaged, overdue fines on the most recent circulation are voided.',
        'bool'
    );

-- hold cancel display limits
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
    VALUES (
        'circ.holds.canceled.display_count',
        'Holds: Canceled holds display count',
        'How many canceled holds to show in patron holds interfaces',
        'integer'
    );

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
    VALUES (
        'circ.holds.canceled.display_age',
        'Holds: Canceled holds display age',
        'Show all canceled holds that were canceled within this amount of time',
        'interval'
    );

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
    VALUES (
        'circ.holds.uncancel.reset_request_time',
        'Holds: Reset request time on un-cancel',
        'When a holds is uncanceled, reset the request time to push it to the end of the queue',
        'bool'
    );

INSERT INTO config.org_unit_setting_type (name, label, description, datatype)
    VALUES (
        'circ.holds.default_shelf_expire_interval',
        'Default hold shelf expire interval',
        '',
        'interval'
);


-- Sample Pre-due Notice --

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, delay, delay_field, group_field, max_delay, template) 
    VALUES (6, 'f', 1, '3 Day Courtesy Notice', 'checkout.due', 'CircIsOpen', 'SendEmail', '-3 days', 'due_date', 'usr', '-2 days',
$$
[%- USE date -%]
[%- user = target.0.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Courtesy Notice

Dear [% user.family_name %], [% user.first_given_name %]
As a reminder, the following items are due in 3 days.

[% FOR circ IN target %]
    Title: [% circ.target_copy.call_number.record.simple_record.title %] 
    Barcode: [% circ.target_copy.barcode %] 
    Due: [% date.format(helpers.format_date(circ.due_date), '%Y-%m-%d') %]
    Item Cost: [% helpers.get_copy_price(circ.target_copy) %]
    Library: [% circ.circ_lib.name %]
    Library Phone: [% circ.circ_lib.phone %]
[% END %]

$$);

INSERT INTO action_trigger.environment (event_def, path) VALUES 
    (6, 'target_copy.call_number.record.simple_record'),
    (6, 'usr'),
    (6, 'circ_lib.billing_address');

-- Additional A/T Reactors

INSERT INTO action_trigger.reactor (module,description) VALUES
(   'ApplyPatronPenalty',
    oils_i18n_gettext(
        'ApplyPatronPenalty',
        'Applies the conifigured penalty to a patron.  Required named environment variables are "user", which refers to the user object, and "context_org", which refers to the org_unit object that acts as the focus for the penalty.',
        'atreact',
        'description'
    )
);

INSERT INTO action_trigger.reactor (module,description) VALUES
(   'SendFile',
    oils_i18n_gettext(
        'SendFile',
        'Build and transfer a file to a remote server.  Required parameter "remote_host" specifying target server.  Optional parameters: remote_user, remote_password, remote_account, port, type (FTP, SFTP or SCP), and debug.',
        'atreact',
        'description'
    )
);


INSERT INTO config.org_unit_setting_type (name, label, description, datatype, fm_class)
    VALUES (
        'circ.claim_return.copy_status', 
        'Claim Return Copy Status', 
        'Claims returned copies are put into this status.  Default is to leave the copy in the Checked Out status',
        'link', 
        'ccs' 
    );

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) 
    VALUES ( 
        'circ.max_fine.cap_at_price',
        oils_i18n_gettext('circ.max_fine.cap_at_price', 'Circ: Cap Max Fine at Item Price', 'coust', 'label'),
        oils_i18n_gettext('circ.max_fine.cap_at_price', 'This prevents the system from charging more than the item price in overdue fines', 'coust', 'description'),
        'bool' 
    );

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype, fm_class ) 
    VALUES ( 
        'circ.holds.clear_shelf.copy_status',
        oils_i18n_gettext('circ.holds.clear_shelf.copy_status', 'Holds: Clear shelf copy status', 'coust', 'label'),
        oils_i18n_gettext('circ.holds.clear_shelf.copy_status', 'Any copies that have not been put into reshelving, in-transit, or on-holds-shelf (for a new hold) during the clear shelf process will be put into this status.  This is basically a purgatory status for copies waiting to be pulled from the shelf and processed by hand', 'coust', 'description'),
        'link',
        'ccs'
    );

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
    VALUES ( 
        'circ.selfcheck.workstation_required',
        oils_i18n_gettext('circ.selfcheck.workstation_required', 'Selfcheck: Workstation Required', 'coust', 'label'),
        oils_i18n_gettext('circ.selfcheck.workstation_required', 'All selfcheck stations must use a workstation', 'coust', 'description'),
        'bool'
    ), (
        'circ.selfcheck.patron_password_required',
        oils_i18n_gettext('circ.selfcheck.patron_password_required', 'Selfcheck: Require Patron Password', 'coust', 'label'),
        oils_i18n_gettext('circ.selfcheck.patron_password_required', 'Patron must log in with barcode and password at selfcheck station', 'coust', 'description'),
        'bool'
    );

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
    VALUES ( 
        'circ.selfcheck.alert.sound',
        oils_i18n_gettext('circ.selfcheck.alert.sound', 'Selfcheck: Audio Alerts', 'coust', 'label'),
        oils_i18n_gettext('circ.selfcheck.alert.sound', 'Use audio alerts for selfcheck events', 'coust', 'description'),
        'bool'
    );

-- self-check checkout receipt

INSERT INTO action_trigger.hook (key, core_type, description, passive) 
    VALUES (
        'format.selfcheck.checkout',
        'circ',
        'Formats circ objects for self-checkout receipt',
        TRUE
    );

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, group_field, granularity, template )
    VALUES (
        10,
        TRUE,
        1,
        'Self-Checkout Receipt',
        'format.selfcheck.checkout',
        'NOOP_True',
        'ProcessTemplate',
        'usr',
        'print-on-demand',
$$
[%- USE date -%]
[%- SET user = target.0.usr -%]
[%- SET lib = target.0.circ_lib -%]
[%- SET lib_addr = target.0.circ_lib.billing_address -%]
[%- SET hours = lib.hours_of_operation -%]
<div>
    <style> li { padding: 8px; margin 5px; }</style>
    <div>[% date.format %]</div>
    <div>[% lib.name %]</div>
    <div>[% lib_addr.street1 %] [% lib_addr.street2 %]</div>
    <div>[% lib_addr.city %], [% lib_addr.state %] [% lb_addr.post_code %]</div>
    <div>[% lib.phone %]</div>
    <br/>

    [% user.family_name %], [% user.first_given_name %]
    <ol>
    [% FOR circ IN target %]
        [%-
            SET idx = loop.count - 1;
            SET udata =  user_data.$idx
        -%]
        <li>
            <div>[% helpers.get_copy_bib_basics(circ.target_copy.id).title %]</div>
            <div>Barcode: [% circ.target_copy.barcode %]</div>
            [% IF user_data.renewal_failure %]
                <div style='color:red;'>Renewal Failed</div>
            [% ELSE %]
                <div>Due Date: [% date.format(helpers.format_date(circ.due_date), '%Y-%m-%d') %]</div>
            [% END %]
        </li>
    [% END %]
    </ol>
    
    <div>
        Library Hours
        [%- BLOCK format_time; date.format(time _ ' 1/1/1000', format='%I:%M %p'); END -%]
        <div>
            Monday 
            [% PROCESS format_time time = hours.dow_0_open %] 
            [% PROCESS format_time time = hours.dow_0_close %] 
        </div>
        <div>
            Tuesday 
            [% PROCESS format_time time = hours.dow_1_open %] 
            [% PROCESS format_time time = hours.dow_1_close %] 
        </div>
        <div>
            Wednesday 
            [% PROCESS format_time time = hours.dow_2_open %] 
            [% PROCESS format_time time = hours.dow_2_close %] 
        </div>
        <div>
            Thursday
            [% PROCESS format_time time = hours.dow_3_open %] 
            [% PROCESS format_time time = hours.dow_3_close %] 
        </div>
        <div>
            Friday
            [% PROCESS format_time time = hours.dow_4_open %] 
            [% PROCESS format_time time = hours.dow_4_close %] 
        </div>
        <div>
            Saturday
            [% PROCESS format_time time = hours.dow_5_open %] 
            [% PROCESS format_time time = hours.dow_5_close %] 
        </div>
        <div>
            Sunday 
            [% PROCESS format_time time = hours.dow_6_open %] 
            [% PROCESS format_time time = hours.dow_6_close %] 
        </div>
    </div>
</div>
$$
);


INSERT INTO action_trigger.environment ( event_def, path) VALUES
    ( 10, 'target_copy'),
    ( 10, 'circ_lib.billing_address'),
    ( 10, 'circ_lib.hours_of_operation'),
    ( 10, 'usr');


-- items out selfcheck receipt

INSERT INTO action_trigger.hook (key, core_type, description, passive) 
    VALUES (
        'format.selfcheck.items_out',
        'circ',
        'Formats items out for self-checkout receipt',
        TRUE
    );

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, group_field, granularity, template )
    VALUES (
        11,
        TRUE,
        1,
        'Self-Checkout Items Out Receipt',
        'format.selfcheck.items_out',
        'NOOP_True',
        'ProcessTemplate',
        'usr',
        'print-on-demand',
$$
[%- USE date -%]
[%- SET user = target.0.usr -%]
<div>
    <style> li { padding: 8px; margin 5px; }</style>
    <div>[% date.format %]</div>
    <br/>

    [% user.family_name %], [% user.first_given_name %]
    <ol>
    [% FOR circ IN target %]
        <li>
            <div>[% helpers.get_copy_bib_basics(circ.target_copy.id).title %]</div>
            <div>Barcode: [% circ.target_copy.barcode %]</div>
            <div>Due Date: [% date.format(helpers.format_date(circ.due_date), '%Y-%m-%d') %]</div>
        </li>
    [% END %]
    </ol>
</div>
$$
);


INSERT INTO action_trigger.environment ( event_def, path) VALUES
    ( 11, 'target_copy'),
    ( 11, 'circ_lib.billing_address'),
    ( 11, 'circ_lib.hours_of_operation'),
    ( 11, 'usr');

INSERT INTO action_trigger.hook (key, core_type, description, passive) 
    VALUES (
        'format.selfcheck.holds',
        'ahr',
        'Formats holds for self-checkout receipt',
        TRUE
    );

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, group_field, granularity, template )
    VALUES (
        12,
        TRUE,
        1,
        'Self-Checkout Holds Receipt',
        'format.selfcheck.holds',
        'NOOP_True',
        'ProcessTemplate',
        'usr',
        'print-on-demand',
$$
[%- USE date -%]
[%- SET user = target.0.usr -%]
<div>
    <style> li { padding: 8px; margin 5px; }</style>
    <div>[% date.format %]</div>
    <br/>

    [% user.family_name %], [% user.first_given_name %]
    <ol>
    [% FOR hold IN target %]
        [%-
            SET idx = loop.count - 1;
            SET udata =  user_data.$idx
        -%]
        <li>
            <div>Title: [% hold.bib_rec.bib_record.simple_record.title %]</div>
            <div>Author: [% hold.bib_rec.bib_record.simple_record.author %]</div>
            <div>Pickup Location: [% hold.pickup_lib.name %]</div>
            <div>Status: 
                [%- IF udata.ready -%]
                    Ready for pickup
                [% ELSE %]
                    #[% udata.queue_position %] of [% udata.potential_copies %] copies.
                [% END %]
            </div>
        </li>
    [% END %]
    </ol>
</div>
$$
);


INSERT INTO action_trigger.environment ( event_def, path) VALUES
    ( 12, 'bib_rec.bib_record.simple_record'),
    ( 12, 'pickup_lib'),
    ( 12, 'usr');

-- fines receipt

INSERT INTO action_trigger.hook (key, core_type, description, passive) 
    VALUES (
        'format.selfcheck.fines',
        'au',
        'Formats fines for self-checkout receipt',
        TRUE
    );

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, granularity, template )
    VALUES (
        13,
        TRUE,
        1,
        'Self-Checkout Fines Receipt',
        'format.selfcheck.fines',
        'NOOP_True',
        'ProcessTemplate',
        'print-on-demand',
$$
[%- USE date -%]
[%- SET user = target -%]
<div>
    <style> li { padding: 8px; margin 5px; }</style>
    <div>[% date.format %]</div>
    <br/>

    [% user.family_name %], [% user.first_given_name %]
    <ol>
    [% FOR xact IN user.open_billable_transactions_summary %]
        <li>
            <div>Details: 
                [% IF xact.xact_type == 'circulation' %]
                    [%- helpers.get_copy_bib_basics(xact.circulation.target_copy).title -%]
                [% ELSE %]
                    [%- xact.last_billing_type -%]
                [% END %]
            </div>
            <div>Total Billed: [% xact.total_owed %]</div>
            <div>Total Paid: [% xact.total_paid %]</div>
            <div>Balance Owed : [% xact.balance_owed %]</div>
        </li>
    [% END %]
    </ol>
</div>
$$
);

INSERT INTO action_trigger.hook (key, core_type, description, passive) 
    VALUES (
        'format.acqli.html',
        'jub',
        'Formats lineitem worksheet for titles received',
        TRUE
    );

INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, granularity, template)
    VALUES (
        14,
        TRUE,
        1,
        'Lineitem Worksheet',
        'format.acqli.html',
        'NOOP_True',
        'ProcessTemplate',
        'print-on-demand',
$$
[%- USE date -%]
[%- SET li = target; -%]
<div class="wrapper">
    <div class="summary" style='font-size:110%; font-weight:bold;'>

        <div>Title: [% helpers.get_li_attr("title", "", li.attributes) %]</div>
        <div>Author: [% helpers.get_li_attr("author", "", li.attributes) %]</div>
        <div class="count">Item Count: [% li.lineitem_details.size %]</div>
        <div class="lineid">Lineitem ID: [% li.id %]</div>

        [% IF li.distribution_formulas.size > 0 %]
            [% SET forms = [] %]
            [% FOREACH form IN li.distribution_formulas; forms.push(form.formula.name); END %]
            <div>Distribution Formulas: [% forms.join(',') %]</div>
        [% END %]

        [% IF li.lineitem_notes.size > 0 %]
            Lineitem Notes:
            <ul>
                [%- FOR note IN li.lineitem_notes -%]
                    <li>
                    [% IF note.alert_text %]
                        [% note.alert_text.code -%] 
                        [% IF note.value -%]
                            : [% note.value %]
                        [% END %]
                    [% ELSE %]
                        [% note.value -%] 
                    [% END %]
                    </li>
                [% END %]
            </ul>
        [% END %]
    </div>
    <br/>
    <table>
        <thead>
            <tr>
                <th>Branch</th>
                <th>Barcode</th>
                <th>Call Number</th>
                <th>Fund</th>
                <th>Shelving Location</th>
                <th>Recd.</th>
                <th>Notes</th>
            </tr>
        </thead>
        <tbody>
        [% FOREACH detail IN li.lineitem_details.sort('owning_lib') %]
            [% 
                IF copy.eg_copy_id;
                    SET copy = copy.eg_copy_id;
                    SET cn_label = copy.call_number.label;
                ELSE; 
                    SET copy = detail; 
                    SET cn_label = detail.cn_label;
                END 
            %]
            <tr>
                <!-- acq.lineitem_detail.id = [%- detail.id -%] -->
                <td style='padding:5px;'>[% detail.owning_lib.shortname %]</td>
                <td style='padding:5px;'>[% IF copy.barcode   %]<span class="barcode"  >[% detail.barcode   %]</span>[% END %]</td>
                <td style='padding:5px;'>[% IF cn_label %]<span class="cn_label" >[% cn_label  %]</span>[% END %]</td>
                <td style='padding:5px;'>[% IF detail.fund %]<span class="fund">[% detail.fund.code %] ([% detail.fund.year %])</span>[% END %]</td>
                <td style='padding:5px;'>[% copy.location.name %]</td>
                <td style='padding:5px;'>[% IF detail.recv_time %]<span class="recv_time">[% detail.recv_time %]</span>[% END %]</td>
                <td style='padding:5px;'>[% detail.note %]</td>
            </tr>
        [% END %]
        </tbody>
    </table>
</div>
$$
);


INSERT INTO action_trigger.environment (event_def, path) VALUES
    ( 14, 'attributes' ),
    ( 14, 'lineitem_notes' ),
    ( 14, 'lineitem_notes.alert_text' ),
    ( 14, 'distribution_formulas.formula' ),
    ( 14, 'lineitem_details' ),
    ( 14, 'lineitem_details.owning_lib' ),
    ( 14, 'lineitem_details.fund' ),
    ( 14, 'lineitem_details.location' ),
    ( 14, 'lineitem_details.eg_copy_id' ),
    ( 14, 'lineitem_details.eg_copy_id.call_number' ),
    ( 14, 'lineitem_details.eg_copy_id.location' )
;

INSERT INTO action_trigger.environment ( event_def, path) VALUES
    ( 13, 'open_billable_transactions_summary.circulation' );


INSERT INTO action_trigger.validator (module, description) 
    VALUES (
        'Acq::PurchaseOrderEDIRequired',
        oils_i18n_gettext(
            'Acq::PurchaseOrderEDIRequired',
            'Purchase order is delivered via EDI',
            'atval',
            'description'
        )
    );

INSERT INTO action_trigger.reactor (module, description)
    VALUES (
        'GeneratePurchaseOrderJEDI',
        oils_i18n_gettext(
            'GeneratePurchaseOrderJEDI',
            'Creates purchase order JEDI (JSON EDI) for subsequent EDI processing',
            'atreact',
            'description'
        )
    );


INSERT INTO action_trigger.event_definition (id, active, owner, name, hook, validator, reactor, cleanup_success, cleanup_failure, delay, delay_field, group_field, template) 
    VALUES (23, true, 1, 'PO JEDI', 'acqpo.activated', 'Acq::PurchaseOrderEDIRequired', 'GeneratePurchaseOrderJEDI', NULL, NULL, '00:05:00', NULL, NULL,
$$[%- USE date -%]
[%# start JEDI document -%]
[%- BLOCK big_block -%]
{
   "recipient":"[% target.provider.san %]",
   "sender":"[% target.ordering_agency.mailing_address.san %]",
   "body": [{
     "ORDERS":[ "order", {
        "po_number":[% target.id %],
        "date":"[% date.format(date.now, '%Y%m%d') %]",
        "buyer":[{
            [%- IF target.provider.edi_default.vendcode -%]
                "id":"[% target.ordering_agency.mailing_address.san _ ' ' _ target.provider.edi_default.vendcode %]", 
                "id-qualifier": 91
            [%- ELSE -%]
                "id":"[% target.ordering_agency.mailing_address.san %]"
            [%- END  -%]
        }],
        "vendor":[ 
            [%- # target.provider.name (target.provider.id) -%]
            "[% target.provider.san %]",
            {"id-qualifier": 92, "id":"[% target.provider.id %]"}
        ],
        "currency":"[% target.provider.currency_type %]",
        "items":[
        [% FOR li IN target.lineitems %]
        {
            "identifiers":[   [%-# li.isbns = helpers.get_li_isbns(li.attributes) %]
            [% FOR isbn IN helpers.get_li_isbns(li.attributes) -%]
                [% IF isbn.length == 13 -%]
                {"id-qualifier":"EN","id":"[% isbn %]"},
                [% ELSE -%]
                {"id-qualifier":"IB","id":"[% isbn %]"},
                [%- END %]
            [% END %]
                {"id-qualifier":"SA","id":"[% li.id %]"}
            ],
            "price":[% li.estimated_unit_price || '0.00' %],
            "desc":[
                {"BTI":"[% helpers.get_li_attr('title',     '', li.attributes) %]"}, 
                {"BPU":"[% helpers.get_li_attr('publisher', '', li.attributes) %]"},
                {"BPD":"[% helpers.get_li_attr('pubdate',   '', li.attributes) %]"},
                {"BPH":"[% helpers.get_li_attr('pagination','', li.attributes) %]"}
            ],
            "quantity":[% li.lineitem_details.size %]
        }[% UNLESS loop.last %],[% END %]
        [%-# TODO: lineitem details (later) -%]
        [% END %]
        ],
        "line_items":[% target.lineitems.size %]
     }]  [% # close ORDERS array %]
   }]    [% # close  body  array %]
}
[% END %]
[% tempo = PROCESS big_block; helpers.escape_json(tempo) %]
$$
);

INSERT INTO action_trigger.environment (event_def, path) VALUES 
  (23, 'lineitems.attributes'), 
  (23, 'lineitems.lineitem_details'), 
  (23, 'lineitems.lineitem_notes'), 
  (23, 'ordering_agency.mailing_address'), 
  (23, 'provider'),
  (23, 'provider.edi_default');

INSERT INTO
    config.org_unit_setting_type (name, label, description, datatype)
    VALUES (
        'notice.telephony.callfile_lines',
        'Telephony: Arbitrary line(s) to include in each notice callfile',
        $$
        This overrides lines from opensrf.xml.
        Line(s) must be valid for your target server and platform
        (e.g. Asterisk 1.4).
        $$,
        'string'
    );

INSERT INTO action_trigger.reactor (module, description) VALUES (
    'AstCall', 'Possibly place a phone call with Asterisk'
);

INSERT INTO
    action_trigger.event_definition (
        id, active, owner, name, hook, validator, reactor,
        cleanup_success, cleanup_failure, delay, delay_field, group_field,
        max_delay, granularity, usr_field, opt_in_setting, template
    ) VALUES (
        24,
        FALSE,
        1,
        'Telephone Overdue Notice',
        'checkout.due', 'NOOP_True', 'AstCall',
        DEFAULT, DEFAULT, '5 seconds', 'due_date', 'usr',
        DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        $$
[% phone = target.0.usr.day_phone | replace('[\s\-\(\)]', '') -%]
[% IF phone.match('^[2-9]') %][% country = 1 %][% ELSE %][% country = '' %][% END -%]
Channel: [% channel_prefix %]/[% country %][% phone %]
Context: overdue-test
MaxRetries: 1
RetryTime: 60
WaitTime: 30
Extension: 10
Archive: 1
Set: eg_user_id=[% target.0.usr.id %]
Set: items=[% target.size %]
Set: titlestring=[% titles = [] %][% FOR circ IN target %][% titles.push(circ.target_copy.call_number.record.simple_record.title) %][% END %][% titles.join(". ") %]
$$
    );

INSERT INTO
    action_trigger.environment (id, event_def, path)
    VALUES
        (DEFAULT, 24, 'target_copy.call_number.record.simple_record'),
        (DEFAULT, 24, 'usr')
    ;

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
    VALUES ( 
        'circ.offline.username_allowed',
        oils_i18n_gettext('circ.offline.username_allowed', 'Offline: Patron Usernames Allowed', 'coust', 'label'),
        oils_i18n_gettext('circ.offline.username_allowed', 'During offline circulations, allow patrons to identify themselves with usernames in addition to barcode.  For this setting to work, a barcode format must also be defined', 'coust', 'description'),
        'bool'
    );

-- 0285.data.history_format.sql

INSERT INTO action_trigger.hook (key,core_type,description,passive) VALUES (
        'circ.format.history.email',
        'circ', 
        oils_i18n_gettext(
            'circ.format.history.email',
            'An email has been requested for a circ history.',
            'ath',
            'description'
        ), 
        FALSE
    )
    ,(
        'circ.format.history.print',
        'circ', 
        oils_i18n_gettext(
            'circ.format.history.print',
            'A circ history needs to be formatted for printing.',
            'ath',
            'description'
        ), 
        FALSE
    )
    ,(
        'ahr.format.history.email',
        'ahr', 
        oils_i18n_gettext(
            'ahr.format.history.email',
            'An email has been requested for a hold request history.',
            'ath',
            'description'
        ), 
        FALSE
    )
    ,(
        'ahr.format.history.print',
        'ahr', 
        oils_i18n_gettext(
            'ahr.format.history.print',
            'A hold request history needs to be formatted for printing.',
            'ath',
            'description'
        ), 
        FALSE
    )

;

INSERT INTO action_trigger.event_definition (
        id,
        active,
        owner,
        name,
        hook,
        validator,
        reactor,
        group_field,
        granularity,
        template
    ) VALUES (
        25,
        TRUE,
        1,
        'circ.history.email',
        'circ.format.history.email',
        'NOOP_True',
        'SendEmail',
        'usr',
        NULL,
$$
[%- USE date -%]
[%- SET user = target.0.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Circulation History

    [% FOR circ IN target %]
            [% helpers.get_copy_bib_basics(circ.target_copy.id).title %]
            Barcode: [% circ.target_copy.barcode %]
            Checked Out: [% date.format(helpers.format_date(circ.xact_start), '%Y-%m-%d') %]
            Due Date: [% date.format(helpers.format_date(circ.due_date), '%Y-%m-%d') %]
            Returned: [% date.format(helpers.format_date(circ.checkin_time), '%Y-%m-%d') %]
    [% END %]
$$
    )
    ,(
        26,
        TRUE,
        1,
        'circ.history.print',
        'circ.format.history.print',
        'NOOP_True',
        'ProcessTemplate',
        'usr',
        'print-on-demand',
$$
[%- USE date -%]
<div>
    <style> li { padding: 8px; margin 5px; }</style>
    <div>[% date.format %]</div>
    <br/>

    [% user.family_name %], [% user.first_given_name %]
    <ol>
    [% FOR circ IN target %]
        <li>
            <div>[% helpers.get_copy_bib_basics(circ.target_copy.id).title %]</div>
            <div>Barcode: [% circ.target_copy.barcode %]</div>
            <div>Checked Out: [% date.format(helpers.format_date(circ.xact_start), '%Y-%m-%d') %]</div>
            <div>Due Date: [% date.format(helpers.format_date(circ.due_date), '%Y-%m-%d') %]</div>
            <div>Returned: [% date.format(helpers.format_date(circ.checkin_time), '%Y-%m-%d') %]</div>
        </li>
    [% END %]
    </ol>
</div>
$$
    )
    ,(
        27,
        TRUE,
        1,
        'ahr.history.email',
        'ahr.format.history.email',
        'NOOP_True',
        'SendEmail',
        'usr',
        NULL,
$$
[%- USE date -%]
[%- SET user = target.0.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Hold Request History

    [% FOR hold IN target %]
            [% helpers.get_copy_bib_basics(hold.current_copy.id).title %]
            Requested: [% date.format(helpers.format_date(hold.request_time), '%Y-%m-%d') %]
            [% IF hold.fulfillment_time %]Fulfilled: [% date.format(helpers.format_date(hold.fulfillment_time), '%Y-%m-%d') %][% END %]
    [% END %]
$$
    )
    ,(
        28,
        TRUE,
        1,
        'ahr.history.print',
        'ahr.format.history.print',
        'NOOP_True',
        'ProcessTemplate',
        'usr',
        'print-on-demand',
$$
[%- USE date -%]
<div>
    <style> li { padding: 8px; margin 5px; }</style>
    <div>[% date.format %]</div>
    <br/>

    [% user.family_name %], [% user.first_given_name %]
    <ol>
    [% FOR hold IN target %]
        <li>
            <div>[% helpers.get_copy_bib_basics(hold.current_copy.id).title %]</div>
            <div>Requested: [% date.format(helpers.format_date(hold.request_time), '%Y-%m-%d') %]</div>
            [% IF hold.fulfillment_time %]<div>Fulfilled: [% date.format(helpers.format_date(hold.fulfillment_time), '%Y-%m-%d') %]</div>[% END %]
        </li>
    [% END %]
    </ol>
</div>
$$
    )

;

INSERT INTO action_trigger.environment (
        event_def,
        path
    ) VALUES 
         ( 25, 'target_copy')
        ,( 25, 'usr' )
        ,( 26, 'target_copy' )
        ,( 26, 'usr' )
        ,( 27, 'current_copy' )
        ,( 27, 'usr' )
        ,( 28, 'current_copy' )
        ,( 28, 'usr' )
;

-- 0289.data.payment_receipt_format.sql
-- 0326.data.payment_receipt_format.sql

INSERT INTO action_trigger.hook (key,core_type,description,passive) VALUES (
        'money.format.payment_receipt.email',
        'mp', 
        oils_i18n_gettext(
            'money.format.payment_receipt.email',
            'An email has been requested for a payment receipt.',
            'ath',
            'description'
        ), 
        FALSE
    )
    ,(
        'money.format.payment_receipt.print',
        'mp', 
        oils_i18n_gettext(
            'money.format.payment_receipt.print',
            'A payment receipt needs to be formatted for printing.',
            'ath',
            'description'
        ), 
        FALSE
    )
;

INSERT INTO action_trigger.event_definition (
        id,
        active,
        owner,
        name,
        hook,
        validator,
        reactor,
        group_field,
        granularity,
        template
    ) VALUES (
        29,
        TRUE,
        1,
        'money.payment_receipt.email',
        'money.format.payment_receipt.email',
        'NOOP_True',
        'SendEmail',
        'xact.usr',
        NULL,
$$
[%- USE date -%]
[%- SET user = target.0.xact.usr -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Payment Receipt

[% date.format -%]
[%- SET xact_mp_hash = {} -%]
[%- FOR mp IN target %][%# Template is hooked around payments, but let us make the receipt focused on transactions -%]
    [%- SET xact_id = mp.xact.id -%]
    [%- IF ! xact_mp_hash.defined( xact_id ) -%][%- xact_mp_hash.$xact_id = { 'xact' => mp.xact, 'payments' => [] } -%][%- END -%]
    [%- xact_mp_hash.$xact_id.payments.push(mp) -%]
[%- END -%]
[%- FOR xact_id IN xact_mp_hash.keys.sort -%]
    [%- SET xact = xact_mp_hash.$xact_id.xact %]
Transaction ID: [% xact_id %]
    [% IF xact.circulation %][% helpers.get_copy_bib_basics(xact.circulation.target_copy).title %]
    [% ELSE %]Miscellaneous
    [% END %]
    Line item billings:
        [%- SET mb_type_hash = {} -%]
        [%- FOR mb IN xact.billings %][%# Group billings by their btype -%]
            [%- IF mb.voided == 'f' -%]
                [%- SET mb_type = mb.btype.id -%]
                [%- IF ! mb_type_hash.defined( mb_type ) -%][%- mb_type_hash.$mb_type = { 'sum' => 0.00, 'billings' => [] } -%][%- END -%]
                [%- IF ! mb_type_hash.$mb_type.defined( 'first_ts' ) -%][%- mb_type_hash.$mb_type.first_ts = mb.billing_ts -%][%- END -%]
                [%- mb_type_hash.$mb_type.last_ts = mb.billing_ts -%]
                [%- mb_type_hash.$mb_type.sum = mb_type_hash.$mb_type.sum + mb.amount -%]
                [%- mb_type_hash.$mb_type.billings.push( mb ) -%]
            [%- END -%]
        [%- END -%]
        [%- FOR mb_type IN mb_type_hash.keys.sort -%]
            [%- IF mb_type == 1 %][%-# Consolidated view of overdue billings -%]
                $[% mb_type_hash.$mb_type.sum %] for [% mb_type_hash.$mb_type.billings.0.btype.name %] 
                    on [% mb_type_hash.$mb_type.first_ts %] through [% mb_type_hash.$mb_type.last_ts %]
            [%- ELSE -%][%# all other billings show individually %]
                [% FOR mb IN mb_type_hash.$mb_type.billings %]
                    $[% mb.amount %] for [% mb.btype.name %] on [% mb.billing_ts %] [% mb.note %]
                [% END %]
            [% END %]
        [% END %]
    Line item payments:
        [% FOR mp IN xact_mp_hash.$xact_id.payments %]
            Payment ID: [% mp.id %]
                Paid [% mp.amount %] via [% SWITCH mp.payment_type -%]
                    [% CASE "cash_payment" %]cash
                    [% CASE "check_payment" %]check
                    [% CASE "credit_card_payment" %]credit card (
                        [%- SET cc_chunks = mp.credit_card_payment.cc_number.replace(' ','').chunk(4); -%]
                        [%- cc_chunks.slice(0, -1+cc_chunks.max).join.replace('\S','X') -%] 
                        [% cc_chunks.last -%]
                        exp [% mp.credit_card_payment.expire_month %]/[% mp.credit_card_payment.expire_year -%]
                    )
                    [% CASE "credit_payment" %]credit
                    [% CASE "forgive_payment" %]forgiveness
                    [% CASE "goods_payment" %]goods
                    [% CASE "work_payment" %]work
                [%- END %] on [% mp.payment_ts %] [% mp.note %]
        [% END %]
[% END %]
$$
    )
    ,(
        30,
        TRUE,
        1,
        'money.payment_receipt.print',
        'money.format.payment_receipt.print',
        'NOOP_True',
        'ProcessTemplate',
        'xact.usr',
        'print-on-demand',
$$
[%- USE date -%][%- SET user = target.0.xact.usr -%]
<div style="li { padding: 8px; margin 5px; }">
    <div>[% date.format %]</div><br/>
    <ol>
    [% SET xact_mp_hash = {} %]
    [% FOR mp IN target %][%# Template is hooked around payments, but let us make the receipt focused on transactions %]
        [% SET xact_id = mp.xact.id %]
        [% IF ! xact_mp_hash.defined( xact_id ) %][% xact_mp_hash.$xact_id = { 'xact' => mp.xact, 'payments' => [] } %][% END %]
        [% xact_mp_hash.$xact_id.payments.push(mp) %]
    [% END %]
    [% FOR xact_id IN xact_mp_hash.keys.sort %]
        [% SET xact = xact_mp_hash.$xact_id.xact %]
        <li>Transaction ID: [% xact_id %]
            [% IF xact.circulation %][% helpers.get_copy_bib_basics(xact.circulation.target_copy).title %]
            [% ELSE %]Miscellaneous
            [% END %]
            Line item billings:<ol>
                [% SET mb_type_hash = {} %]
                [% FOR mb IN xact.billings %][%# Group billings by their btype %]
                    [% IF mb.voided == 'f' %]
                        [% SET mb_type = mb.btype.id %]
                        [% IF ! mb_type_hash.defined( mb_type ) %][% mb_type_hash.$mb_type = { 'sum' => 0.00, 'billings' => [] } %][% END %]
                        [% IF ! mb_type_hash.$mb_type.defined( 'first_ts' ) %][% mb_type_hash.$mb_type.first_ts = mb.billing_ts %][% END %]
                        [% mb_type_hash.$mb_type.last_ts = mb.billing_ts %]
                        [% mb_type_hash.$mb_type.sum = mb_type_hash.$mb_type.sum + mb.amount %]
                        [% mb_type_hash.$mb_type.billings.push( mb ) %]
                    [% END %]
                [% END %]
                [% FOR mb_type IN mb_type_hash.keys.sort %]
                    <li>[% IF mb_type == 1 %][%# Consolidated view of overdue billings %]
                        $[% mb_type_hash.$mb_type.sum %] for [% mb_type_hash.$mb_type.billings.0.btype.name %] 
                            on [% mb_type_hash.$mb_type.first_ts %] through [% mb_type_hash.$mb_type.last_ts %]
                    [% ELSE %][%# all other billings show individually %]
                        [% FOR mb IN mb_type_hash.$mb_type.billings %]
                            $[% mb.amount %] for [% mb.btype.name %] on [% mb.billing_ts %] [% mb.note %]
                        [% END %]
                    [% END %]</li>
                [% END %]
            </ol>
            Line item payments:<ol>
                [% FOR mp IN xact_mp_hash.$xact_id.payments %]
                    <li>Payment ID: [% mp.id %]
                        Paid [% mp.amount %] via [% SWITCH mp.payment_type -%]
                            [% CASE "cash_payment" %]cash
                            [% CASE "check_payment" %]check
                            [% CASE "credit_card_payment" %]credit card (
                                [%- SET cc_chunks = mp.credit_card_payment.cc_number.replace(' ','').chunk(4); -%]
                                [%- cc_chunks.slice(0, -1+cc_chunks.max).join.replace('\S','X') -%] 
                                [% cc_chunks.last -%]
                                exp [% mp.credit_card_payment.expire_month %]/[% mp.credit_card_payment.expire_year -%]
                            )
                            [% CASE "credit_payment" %]credit
                            [% CASE "forgive_payment" %]forgiveness
                            [% CASE "goods_payment" %]goods
                            [% CASE "work_payment" %]work
                        [%- END %] on [% mp.payment_ts %] [% mp.note %]
                    </li>
                [% END %]
            </ol>
        </li>
    [% END %]
    </ol>
</div>
$$
    )
;

INSERT INTO action_trigger.environment (
        event_def,
        path
    ) VALUES -- for fleshing mp objects
         ( 29, 'xact')
        ,( 29, 'xact.usr')
        ,( 29, 'xact.grocery' )
        ,( 29, 'xact.circulation' )
        ,( 29, 'xact.summary' )
        ,( 29, 'credit_card_payment')
        ,( 29, 'xact.billings')
        ,( 29, 'xact.billings.btype')
        ,( 30, 'xact')
        ,( 30, 'xact.usr')
        ,( 30, 'xact.grocery' )
        ,( 30, 'xact.circulation' )
        ,( 30, 'xact.summary' )
        ,( 30, 'credit_card_payment')
        ,( 30, 'xact.billings')
        ,( 30, 'xact.billings.btype')
;

-- 0294.data.bre_format.sql

INSERT INTO container.biblio_record_entry_bucket_type( code, label ) VALUES (
    'temp',
    oils_i18n_gettext(
        'temp',
        'Temporary bucket which gets deleted after use.',
        'cbrebt',
        'label'
    )
);

INSERT INTO action_trigger.cleanup ( module, description ) VALUES (
    'DeleteTempBiblioBucket',
    oils_i18n_gettext(
        'DeleteTempBiblioBucket',
        'Deletes a cbreb object used as a target if it has a btype of "temp"',
        'atclean',
        'description'
    )
);

INSERT INTO action_trigger.hook (key,core_type,description,passive) VALUES (
        'biblio.format.record_entry.email',
        'cbreb', 
        oils_i18n_gettext(
            'biblio.format.record_entry.email',
            'An email has been requested for one or more biblio record entries.',
            'ath',
            'description'
        ), 
        FALSE
    )
    ,(
        'biblio.format.record_entry.print',
        'cbreb', 
        oils_i18n_gettext(
            'biblio.format.record_entry.print',
            'One or more biblio record entries need to be formatted for printing.',
            'ath',
            'description'
        ), 
        FALSE
    )
;

INSERT INTO action_trigger.event_definition (
        id,
        active,
        owner,
        name,
        hook,
        validator,
        reactor,
        cleanup_success,
        cleanup_failure,
        group_field,
        granularity,
        template
    ) VALUES (
        31,
        TRUE,
        1,
        'biblio.record_entry.email',
        'biblio.format.record_entry.email',
        'NOOP_True',
        'SendEmail',
        'DeleteTempBiblioBucket',
        'DeleteTempBiblioBucket',
        'owner',
        NULL,
$$
[%- USE date -%]
[%- SET user = target.0.owner -%]
To: [%- params.recipient_email || user.email %]
From: [%- params.sender_email || default_sender %]
Subject: Bibliographic Records

    [% FOR cbreb IN target %]
    [% FOR cbrebi IN cbreb.items %]
        Bib ID# [% cbrebi.target_biblio_record_entry.id %] ISBN: [% crebi.target_biblio_record_entry.simple_record.isbn %]
        Title: [% cbrebi.target_biblio_record_entry.simple_record.title %]
        Author: [% cbrebi.target_biblio_record_entry.simple_record.author %]
        Publication Year: [% cbrebi.target_biblio_record_entry.simple_record.pubdate %]

    [% END %]
    [% END %]
$$
    )
    ,(
        32,
        TRUE,
        1,
        'biblio.record_entry.print',
        'biblio.format.record_entry.print',
        'NOOP_True',
        'ProcessTemplate',
        'DeleteTempBiblioBucket',
        'DeleteTempBiblioBucket',
        'owner',
        'print-on-demand',
$$
[%- USE date -%]
<div>
    <style> li { padding: 8px; margin 5px; }</style>
    <ol>
    [% FOR cbreb IN target %]
    [% FOR cbrebi IN cbreb.items %]
        <li>Bib ID# [% cbrebi.target_biblio_record_entry.id %] ISBN: [% crebi.target_biblio_record_entry.simple_record.isbn %]<br />
            Title: [% cbrebi.target_biblio_record_entry.simple_record.title %]<br />
            Author: [% cbrebi.target_biblio_record_entry.simple_record.author %]<br />
            Publication Year: [% cbrebi.target_biblio_record_entry.simple_record.pubdate %]
        </li>
    [% END %]
    [% END %]
    </ol>
</div>
$$
    )
;

INSERT INTO action_trigger.environment (
        event_def,
        path
    ) VALUES -- for fleshing cbreb objects
         ( 31, 'owner' )
        ,( 31, 'items' )
        ,( 31, 'items.target_biblio_record_entry' )
        ,( 31, 'items.target_biblio_record_entry.simple_record' )
        ,( 31, 'items.target_biblio_record_entry.call_numbers' )
        ,( 31, 'items.target_biblio_record_entry.fixed_fields' )
        ,( 31, 'items.target_biblio_record_entry.notes' )
        ,( 31, 'items.target_biblio_record_entry.full_record_entries' )
        ,( 32, 'owner' )
        ,( 32, 'items' )
        ,( 32, 'items.target_biblio_record_entry' )
        ,( 32, 'items.target_biblio_record_entry.simple_record' )
        ,( 32, 'items.target_biblio_record_entry.call_numbers' )
        ,( 32, 'items.target_biblio_record_entry.fixed_fields' )
        ,( 32, 'items.target_biblio_record_entry.notes' )
        ,( 32, 'items.target_biblio_record_entry.full_record_entries' )
;

-- Org unit settings for fund spending limits

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
VALUES (
    'acq.fund.balance_limit.warn',
    oils_i18n_gettext('acq.fund.balance_limit.warn', 'Fund Spending Limit for Warning', 'coust', 'label'),
    oils_i18n_gettext('acq.fund.balance_limit.warn', 'When the amount remaining in the fund, including spent money and encumbrances, goes below this percentage, attempts to spend from the fund will result in a warning to the staff.', 'coust', 'descripton'),
    'integer'
);

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
VALUES (
    'acq.fund.balance_limit.block',
    oils_i18n_gettext('acq.fnd.balance_limit.block', 'Fund Spending Limit for Block', 'coust', 'label'),
    oils_i18n_gettext('acq.fund.balance_limit.block', 'When the amount remaining in the fund, including spent money and encumbrances, goes below this percentage, attempts to spend from the fund will be blocked.', 'coust', 'description'),
    'integer'
);

INSERT INTO acq.invoice_item_type (code,name) VALUES ('TAX',oils_i18n_gettext('TAX', 'Tax', 'aiit', 'name'));
INSERT INTO acq.invoice_item_type (code,name) VALUES ('PRO',oils_i18n_gettext('PRO', 'Processing Fee', 'aiit', 'name'));
INSERT INTO acq.invoice_item_type (code,name) VALUES ('SHP',oils_i18n_gettext('SHP', 'Shipping Charge', 'aiit', 'name'));
INSERT INTO acq.invoice_item_type (code,name) VALUES ('HND',oils_i18n_gettext('HND', 'Handling Charge', 'aiit', 'name'));
INSERT INTO acq.invoice_item_type (code,name) VALUES ('ITM',oils_i18n_gettext('ITM', 'Non-library Item', 'aiit', 'name'));
INSERT INTO acq.invoice_item_type (code,name) VALUES ('SUB',oils_i18n_gettext('SUB', 'Searial Subscription', 'aiit', 'name'));

INSERT INTO acq.invoice_method (code,name) VALUES ('EDI',oils_i18n_gettext('EDI', 'EDI', 'acqim', 'name'));
INSERT INTO acq.invoice_method (code,name) VALUES ('PPR',oils_i18n_gettext('PPR', 'Paper', 'acqit', 'name'));

INSERT INTO acq.cancel_reason ( id, org_unit, label, description ) VALUES (
    1, 1, 'invalid_isbn', oils_i18n_gettext( 1, 'ISBN is unrecognizable', 'acqcr', 'label' ));
INSERT INTO acq.cancel_reason ( id, org_unit, label, description ) VALUES (
    2, 1, 'postpone', oils_i18n_gettext( 2, 'Title has been postponed', 'acqcr', 'label' ));
INSERT INTO acq.cancel_reason ( id, org_unit, label, description, keep_debits ) VALUES (
    3, 1, 'delivered_but_lost',
	oils_i18n_gettext( 2, 'Delivered but not received; presumed lost', 'acqcr', 'label' ), TRUE );

INSERT INTO acq.cancel_reason (keep_debits, id, org_unit, label, description) VALUES 
('t',(  1+1000), 1, 'Added',     'The information is to be or has been added.'),
('f',(  2+1000), 1, 'Deleted',   'The information is to be or has been deleted.'),
('t',(  3+1000), 1, 'Changed',   'The information is to be or has been changed.'),
('t',(  4+1000), 1, 'No action',                  'This line item is not affected by the actual message.'),
('t',(  5+1000), 1, 'Accepted without amendment', 'This line item is entirely accepted by the seller.'),
('t',(  6+1000), 1, 'Accepted with amendment',    'This line item is accepted but amended by the seller.'),
('f',(  7+1000), 1, 'Not accepted',               'This line item is not accepted by the seller.'),
('t',(  8+1000), 1, 'Schedule only', 'Code specifying that the message is a schedule only.'),
('t',(  9+1000), 1, 'Amendments',    'Code specifying that amendments are requested/notified.'),
('f',( 10+1000), 1, 'Not found',   'This line item is not found in the referenced message.'),
('t',( 11+1000), 1, 'Not amended', 'This line is not amended by the buyer.'),
('t',( 12+1000), 1, 'Line item numbers changed', 'Code specifying that the line item numbers have changed.'),
('t',( 13+1000), 1, 'Buyer has deducted amount', 'Buyer has deducted amount from payment.'),
('t',( 14+1000), 1, 'Buyer claims against invoice', 'Buyer has a claim against an outstanding invoice.'),
('t',( 15+1000), 1, 'Charge back by seller', 'Factor has been requested to charge back the outstanding item.'),
('t',( 16+1000), 1, 'Seller will issue credit note', 'Seller agrees to issue a credit note.'),
('t',( 17+1000), 1, 'Terms changed for new terms', 'New settlement terms have been agreed.'),
('t',( 18+1000), 1, 'Abide outcome of negotiations', 'Factor agrees to abide by the outcome of negotiations between seller and buyer.'),
('t',( 19+1000), 1, 'Seller rejects dispute', 'Seller does not accept validity of dispute.'),
('t',( 20+1000), 1, 'Settlement', 'The reported situation is settled.'),
('t',( 21+1000), 1, 'No delivery', 'Code indicating that no delivery will be required.'),
('t',( 22+1000), 1, 'Call-off delivery', 'A request for delivery of a particular quantity of goods to be delivered on a particular date (or within a particular period).'),
('t',( 23+1000), 1, 'Proposed amendment', 'A code used to indicate an amendment suggested by the sender.'),
('t',( 24+1000), 1, 'Accepted with amendment, no confirmation required', 'Accepted with changes which require no confirmation.'),
('t',( 25+1000), 1, 'Equipment provisionally repaired', 'The equipment or component has been provisionally repaired.'),
('t',( 26+1000), 1, 'Included', 'Code indicating that the entity is included.'),
('t',( 27+1000), 1, 'Verified documents for coverage', 'Upon receipt and verification of documents we shall cover you when due as per your instructions.'),
('t',( 28+1000), 1, 'Verified documents for debit',    'Upon receipt and verification of documents we shall authorize you to debit our account with you when due.'),
('t',( 29+1000), 1, 'Authenticated advice for coverage',      'On receipt of your authenticated advice we shall cover you when due as per your instructions.'),
('t',( 30+1000), 1, 'Authenticated advice for authorization', 'On receipt of your authenticated advice we shall authorize you to debit our account with you when due.'),
('t',( 31+1000), 1, 'Authenticated advice for credit',        'On receipt of your authenticated advice we shall credit your account with us when due.'),
('t',( 32+1000), 1, 'Credit advice requested for direct debit',           'A credit advice is requested for the direct debit.'),
('t',( 33+1000), 1, 'Credit advice and acknowledgement for direct debit', 'A credit advice and acknowledgement are requested for the direct debit.'),
('t',( 34+1000), 1, 'Inquiry',     'Request for information.'),
('t',( 35+1000), 1, 'Checked',     'Checked.'),
('t',( 36+1000), 1, 'Not checked', 'Not checked.'),
('f',( 37+1000), 1, 'Cancelled',   'Discontinued.'),
('t',( 38+1000), 1, 'Replaced',    'Provide a replacement.'),
('t',( 39+1000), 1, 'New',         'Not existing before.'),
('t',( 40+1000), 1, 'Agreed',      'Consent.'),
('t',( 41+1000), 1, 'Proposed',    'Put forward for consideration.'),
('t',( 42+1000), 1, 'Already delivered', 'Delivery has taken place.'),
('t',( 43+1000), 1, 'Additional subordinate structures will follow', 'Additional subordinate structures will follow the current hierarchy level.'),
('t',( 44+1000), 1, 'Additional subordinate structures will not follow', 'No additional subordinate structures will follow the current hierarchy level.'),
('t',( 45+1000), 1, 'Result opposed',         'A notification that the result is opposed.'),
('t',( 46+1000), 1, 'Auction held',           'A notification that an auction was held.'),
('t',( 47+1000), 1, 'Legal action pursued',   'A notification that legal action has been pursued.'),
('t',( 48+1000), 1, 'Meeting held',           'A notification that a meeting was held.'),
('t',( 49+1000), 1, 'Result set aside',       'A notification that the result has been set aside.'),
('t',( 50+1000), 1, 'Result disputed',        'A notification that the result has been disputed.'),
('t',( 51+1000), 1, 'Countersued',            'A notification that a countersuit has been filed.'),
('t',( 52+1000), 1, 'Pending',                'A notification that an action is awaiting settlement.'),
('f',( 53+1000), 1, 'Court action dismissed', 'A notification that a court action will no longer be heard.'),
('t',( 54+1000), 1, 'Referred item, accepted', 'The item being referred to has been accepted.'),
('f',( 55+1000), 1, 'Referred item, rejected', 'The item being referred to has been rejected.'),
('t',( 56+1000), 1, 'Debit advice statement line',  'Notification that the statement line is a debit advice.'),
('t',( 57+1000), 1, 'Credit advice statement line', 'Notification that the statement line is a credit advice.'),
('t',( 58+1000), 1, 'Grouped credit advices',       'Notification that the credit advices are grouped.'),
('t',( 59+1000), 1, 'Grouped debit advices',        'Notification that the debit advices are grouped.'),
('t',( 60+1000), 1, 'Registered', 'The name is registered.'),
('f',( 61+1000), 1, 'Payment denied', 'The payment has been denied.'),
('t',( 62+1000), 1, 'Approved as amended', 'Approved with modifications.'),
('t',( 63+1000), 1, 'Approved as submitted', 'The request has been approved as submitted.'),
('f',( 64+1000), 1, 'Cancelled, no activity', 'Cancelled due to the lack of activity.'),
('t',( 65+1000), 1, 'Under investigation', 'Investigation is being done.'),
('t',( 66+1000), 1, 'Initial claim received', 'Notification that the initial claim was received.'),
('f',( 67+1000), 1, 'Not in process', 'Not in process.'),
('f',( 68+1000), 1, 'Rejected, duplicate', 'Rejected because it is a duplicate.'),
('f',( 69+1000), 1, 'Rejected, resubmit with corrections', 'Rejected but may be resubmitted when corrected.'),
('t',( 70+1000), 1, 'Pending, incomplete', 'Pending because of incomplete information.'),
('t',( 71+1000), 1, 'Under field office investigation', 'Investigation by the field is being done.'),
('t',( 72+1000), 1, 'Pending, awaiting additional material', 'Pending awaiting receipt of additional material.'),
('t',( 73+1000), 1, 'Pending, awaiting review', 'Pending while awaiting review.'),
('t',( 74+1000), 1, 'Reopened', 'Opened again.'),
('t',( 75+1000), 1, 'Processed by primary, forwarded to additional payer(s)',   'This request has been processed by the primary payer and sent to additional payer(s).'),
('t',( 76+1000), 1, 'Processed by secondary, forwarded to additional payer(s)', 'This request has been processed by the secondary payer and sent to additional payer(s).'),
('t',( 77+1000), 1, 'Processed by tertiary, forwarded to additional payer(s)',  'This request has been processed by the tertiary payer and sent to additional payer(s).'),
('t',( 78+1000), 1, 'Previous payment decision reversed', 'A previous payment decision has been reversed.'),
('t',( 79+1000), 1, 'Not our claim, forwarded to another payer(s)', 'A request does not belong to this payer but has been forwarded to another payer(s).'),
('t',( 80+1000), 1, 'Transferred to correct insurance carrier', 'The request has been transferred to the correct insurance carrier for processing.'),
('t',( 81+1000), 1, 'Not paid, predetermination pricing only', 'Payment has not been made and the enclosed response is predetermination pricing only.'),
('t',( 82+1000), 1, 'Documentation claim', 'The claim is for documentation purposes only, no payment required.'),
('t',( 83+1000), 1, 'Reviewed', 'Assessed.'),
('f',( 84+1000), 1, 'Repriced', 'This price was changed.'),
('t',( 85+1000), 1, 'Audited', 'An official examination has occurred.'),
('t',( 86+1000), 1, 'Conditionally paid', 'Payment has been conditionally made.'),
('t',( 87+1000), 1, 'On appeal', 'Reconsideration of the decision has been applied for.'),
('t',( 88+1000), 1, 'Closed', 'Shut.'),
('t',( 89+1000), 1, 'Reaudited', 'A subsequent official examination has occurred.'),
('t',( 90+1000), 1, 'Reissued', 'Issued again.'),
('t',( 91+1000), 1, 'Closed after reopening', 'Reopened and then closed.'),
('t',( 92+1000), 1, 'Redetermined', 'Determined again or differently.'),
('t',( 93+1000), 1, 'Processed as primary',   'Processed as the first.'),
('t',( 94+1000), 1, 'Processed as secondary', 'Processed as the second.'),
('t',( 95+1000), 1, 'Processed as tertiary',  'Processed as the third.'),
('t',( 96+1000), 1, 'Correction of error', 'A correction to information previously communicated which contained an error.'),
('t',( 97+1000), 1, 'Single credit item of a group', 'Notification that the credit item is a single credit item of a group of credit items.'),
('t',( 98+1000), 1, 'Single debit item of a group',  'Notification that the debit item is a single debit item of a group of debit items.'),
('t',( 99+1000), 1, 'Interim response', 'The response is an interim one.'),
('t',(100+1000), 1, 'Final response',   'The response is an final one.'),
('t',(101+1000), 1, 'Debit advice requested', 'A debit advice is requested for the transaction.'),
('t',(102+1000), 1, 'Transaction not impacted', 'Advice that the transaction is not impacted.'),
('t',(103+1000), 1, 'Patient to be notified',                    'The action to take is to notify the patient.'),
('t',(104+1000), 1, 'Healthcare provider to be notified',        'The action to take is to notify the healthcare provider.'),
('t',(105+1000), 1, 'Usual general practitioner to be notified', 'The action to take is to notify the usual general practitioner.'),
('t',(106+1000), 1, 'Advice without details', 'An advice without details is requested or notified.'),
('t',(107+1000), 1, 'Advice with details', 'An advice with details is requested or notified.'),
('t',(108+1000), 1, 'Amendment requested', 'An amendment is requested.'),
('t',(109+1000), 1, 'For information', 'Included for information only.'),
('f',(110+1000), 1, 'Withdraw', 'A code indicating discontinuance or retraction.'),
('t',(111+1000), 1, 'Delivery date change', 'The action / notiification is a change of the delivery date.'),
('f',(112+1000), 1, 'Quantity change',      'The action / notification is a change of quantity.'),
('t',(113+1000), 1, 'Resale and claim', 'The identified items have been sold by the distributor to the end customer, and compensation for the loss of inventory value is claimed.'),
('t',(114+1000), 1, 'Resale',           'The identified items have been sold by the distributor to the end customer.'),
('t',(115+1000), 1, 'Prior addition', 'This existing line item becomes available at an earlier date.');

-- We won't necessarily use all of these, but they are here for completeness.
-- Source is the EDI spec 6063 codelist, eg: http://www.stylusstudio.com/edifact/D04B/6063.htm
-- Values are the EDI code value + 1200

INSERT INTO acq.cancel_reason (org_unit, keep_debits, id, label, description) VALUES 
(1, 't', 1201, 'Discrete quantity', 'Individually separated and distinct quantity.'),
(1, 't', 1202, 'Charge', 'Quantity relevant for charge.'),
(1, 't', 1203, 'Cumulative quantity', 'Quantity accumulated.'),
(1, 't', 1204, 'Interest for overdrawn account', 'Interest for overdrawing the account.'),
(1, 't', 1205, 'Active ingredient dose per unit', 'The dosage of active ingredient per unit.'),
(1, 't', 1206, 'Auditor', 'The number of entities that audit accounts.'),
(1, 't', 1207, 'Branch locations, leased', 'The number of branch locations being leased by an entity.'),
(1, 't', 1208, 'Inventory quantity at supplier''s subject to inspection by', 'customer Quantity of goods which the customer requires the supplier to have in inventory and which may be inspected by the customer if desired.'),
(1, 't', 1209, 'Branch locations, owned', 'The number of branch locations owned by an entity.'),
(1, 't', 1210, 'Judgements registered', 'The number of judgements registered against an entity.'),
(1, 't', 1211, 'Split quantity', 'Part of the whole quantity.'),
(1, 't', 1212, 'Despatch quantity', 'Quantity despatched by the seller.'),
(1, 't', 1213, 'Liens registered', 'The number of liens registered against an entity.'),
(1, 't', 1214, 'Livestock', 'The number of animals kept for use or profit.'),
(1, 't', 1215, 'Insufficient funds returned cheques', 'The number of cheques returned due to insufficient funds.'),
(1, 't', 1216, 'Stolen cheques', 'The number of stolen cheques.'),
(1, 't', 1217, 'Quantity on hand', 'The total quantity of a product on hand at a location. This includes as well units awaiting return to manufacturer, units unavailable due to inspection procedures and undamaged stock available for despatch, resale or use.'),
(1, 't', 1218, 'Previous quantity', 'Quantity previously referenced.'),
(1, 't', 1219, 'Paid-in security shares', 'The number of security shares issued and for which full payment has been made.'),
(1, 't', 1220, 'Unusable quantity', 'Quantity not usable.'),
(1, 't', 1221, 'Ordered quantity', '[6024] The quantity which has been ordered.'),
(1, 't', 1222, 'Quantity at 100%', 'Equivalent quantity at 100% purity.'),
(1, 't', 1223, 'Active ingredient', 'Quantity at 100% active agent content.'),
(1, 't', 1224, 'Inventory quantity at supplier''s not subject to inspection', 'by customer Quantity of goods which the customer requires the supplier to have in inventory but which will not be checked by the customer.'),
(1, 't', 1225, 'Retail sales', 'Quantity of retail point of sale activity.'),
(1, 't', 1226, 'Promotion quantity', 'A quantity associated with a promotional event.'),
(1, 't', 1227, 'On hold for shipment', 'Article received which cannot be shipped in its present form.'),
(1, 't', 1228, 'Military sales quantity', 'Quantity of goods or services sold to a military organization.'),
(1, 't', 1229, 'On premises sales',  'Sale of product in restaurants or bars.'),
(1, 't', 1230, 'Off premises sales', 'Sale of product directly to a store.'),
(1, 't', 1231, 'Estimated annual volume', 'Volume estimated for a year.'),
(1, 't', 1232, 'Minimum delivery batch', 'Minimum quantity of goods delivered at one time.'),
(1, 't', 1233, 'Maximum delivery batch', 'Maximum quantity of goods delivered at one time.'),
(1, 't', 1234, 'Pipes', 'The number of tubes used to convey a substance.'),
(1, 't', 1235, 'Price break from', 'The minimum quantity of a quantity range for a specified (unit) price.'),
(1, 't', 1236, 'Price break to', 'Maximum quantity to which the price break applies.'),
(1, 't', 1237, 'Poultry', 'The number of domestic fowl.'),
(1, 't', 1238, 'Secured charges registered', 'The number of secured charges registered against an entity.'),
(1, 't', 1239, 'Total properties owned', 'The total number of properties owned by an entity.'),
(1, 't', 1240, 'Normal delivery', 'Quantity normally delivered by the seller.'),
(1, 't', 1241, 'Sales quantity not included in the replenishment', 'calculation Sales which will not be included in the calculation of replenishment requirements.'),
(1, 't', 1242, 'Maximum supply quantity, supplier endorsed', 'Maximum supply quantity endorsed by a supplier.'),
(1, 't', 1243, 'Buyer', 'The number of buyers.'),
(1, 't', 1244, 'Debenture bond', 'The number of fixed-interest bonds of an entity backed by general credit rather than specified assets.'),
(1, 't', 1245, 'Debentures filed against directors', 'The number of notices of indebtedness filed against an entity''s directors.'),
(1, 't', 1246, 'Pieces delivered', 'Number of pieces actually received at the final destination.'),
(1, 't', 1247, 'Invoiced quantity', 'The quantity as per invoice.'),
(1, 't', 1248, 'Received quantity', 'The quantity which has been received.'),
(1, 't', 1249, 'Chargeable distance', '[6110] The distance between two points for which a specific tariff applies.'),
(1, 't', 1250, 'Disposition undetermined quantity', 'Product quantity that has not yet had its disposition determined.'),
(1, 't', 1251, 'Inventory category transfer', 'Inventory that has been moved from one inventory category to another.'),
(1, 't', 1252, 'Quantity per pack', 'Quantity for each pack.'),
(1, 't', 1253, 'Minimum order quantity', 'Minimum quantity of goods for an order.'),
(1, 't', 1254, 'Maximum order quantity', 'Maximum quantity of goods for an order.'),
(1, 't', 1255, 'Total sales', 'The summation of total quantity sales.'),
(1, 't', 1256, 'Wholesaler to wholesaler sales', 'Sale of product to other wholesalers by a wholesaler.'),
(1, 't', 1257, 'In transit quantity', 'A quantity that is en route.'),
(1, 't', 1258, 'Quantity withdrawn', 'Quantity withdrawn from a location.'),
(1, 't', 1259, 'Numbers of consumer units in the traded unit', 'Number of units for consumer sales in a unit for trading.'),
(1, 't', 1260, 'Current inventory quantity available for shipment', 'Current inventory quantity available for shipment.'),
(1, 't', 1261, 'Return quantity', 'Quantity of goods returned.'),
(1, 't', 1262, 'Sorted quantity', 'The quantity that is sorted.'),
(1, 'f', 1263, 'Sorted quantity rejected', 'The sorted quantity that is rejected.'),
(1, 't', 1264, 'Scrap quantity', 'Remainder of the total quantity after split deliveries.'),
(1, 'f', 1265, 'Destroyed quantity', 'Quantity of goods destroyed.'),
(1, 't', 1266, 'Committed quantity', 'Quantity a party is committed to.'),
(1, 't', 1267, 'Estimated reading quantity', 'The value that is estimated to be the reading of a measuring device (e.g. meter).'),
(1, 't', 1268, 'End quantity', 'The quantity recorded at the end of an agreement or period.'),
(1, 't', 1269, 'Start quantity', 'The quantity recorded at the start of an agreement or period.'),
(1, 't', 1270, 'Cumulative quantity received', 'Cumulative quantity of all deliveries of this article received by the buyer.'),
(1, 't', 1271, 'Cumulative quantity ordered', 'Cumulative quantity of all deliveries, outstanding and scheduled orders.'),
(1, 't', 1272, 'Cumulative quantity received end of prior year', 'Cumulative quantity of all deliveries of the product received by the buyer till end of prior year.'),
(1, 't', 1273, 'Outstanding quantity', 'Difference between quantity ordered and quantity received.'),
(1, 't', 1274, 'Latest cumulative quantity', 'Cumulative quantity after complete delivery of all scheduled quantities of the product.'),
(1, 't', 1275, 'Previous highest cumulative quantity', 'Cumulative quantity after complete delivery of all scheduled quantities of the product from a prior schedule period.'),
(1, 't', 1276, 'Adjusted corrector reading', 'A corrector reading after it has been adjusted.'),
(1, 't', 1277, 'Work days', 'Number of work days, e.g. per respective period.'),
(1, 't', 1278, 'Cumulative quantity scheduled', 'Adding the quantity actually scheduled to previous cumulative quantity.'),
(1, 't', 1279, 'Previous cumulative quantity', 'Cumulative quantity prior the actual order.'),
(1, 't', 1280, 'Unadjusted corrector reading', 'A corrector reading before it has been adjusted.'),
(1, 't', 1281, 'Extra unplanned delivery', 'Non scheduled additional quantity.'),
(1, 't', 1282, 'Quantity requirement for sample inspection', 'Required quantity for sample inspection.'),
(1, 't', 1283, 'Backorder quantity', 'The quantity of goods that is on back-order.'),
(1, 't', 1284, 'Urgent delivery quantity', 'Quantity for urgent delivery.'),
(1, 'f', 1285, 'Previous order quantity to be cancelled', 'Quantity ordered previously to be cancelled.'),
(1, 't', 1286, 'Normal reading quantity', 'The value recorded or read from a measuring device (e.g. meter) in the normal conditions.'),
(1, 't', 1287, 'Customer reading quantity', 'The value recorded or read from a measuring device (e.g. meter) by the customer.'),
(1, 't', 1288, 'Information reading quantity', 'The value recorded or read from a measuring device (e.g. meter) for information purposes.'),
(1, 't', 1289, 'Quality control held', 'Quantity of goods held pending completion of a quality control assessment.'),
(1, 't', 1290, 'As is quantity', 'Quantity as it is in the existing circumstances.'),
(1, 't', 1291, 'Open quantity', 'Quantity remaining after partial delivery.'),
(1, 't', 1292, 'Final delivery quantity', 'Quantity of final delivery to a respective order.'),
(1, 't', 1293, 'Subsequent delivery quantity', 'Quantity delivered to a respective order after it''s final delivery.'),
(1, 't', 1294, 'Substitutional quantity', 'Quantity delivered replacing previous deliveries.'),
(1, 't', 1295, 'Redelivery after post processing', 'Quantity redelivered after post processing.'),
(1, 'f', 1296, 'Quality control failed', 'Quantity of goods which have failed quality control.'),
(1, 't', 1297, 'Minimum inventory', 'Minimum stock quantity on which replenishment is based.'),
(1, 't', 1298, 'Maximum inventory', 'Maximum stock quantity on which replenishment is based.'),
(1, 't', 1299, 'Estimated quantity', 'Quantity estimated.'),
(1, 't', 1300, 'Chargeable weight', 'The weight on which charges are based.'),
(1, 't', 1301, 'Chargeable gross weight', 'The gross weight on which charges are based.'),
(1, 't', 1302, 'Chargeable tare weight', 'The tare weight on which charges are based.'),
(1, 't', 1303, 'Chargeable number of axles', 'The number of axles on which charges are based.'),
(1, 't', 1304, 'Chargeable number of containers', 'The number of containers on which charges are based.'),
(1, 't', 1305, 'Chargeable number of rail wagons', 'The number of rail wagons on which charges are based.'),
(1, 't', 1306, 'Chargeable number of packages', 'The number of packages on which charges are based.'),
(1, 't', 1307, 'Chargeable number of units', 'The number of units on which charges are based.'),
(1, 't', 1308, 'Chargeable period', 'The period of time on which charges are based.'),
(1, 't', 1309, 'Chargeable volume', 'The volume on which charges are based.'),
(1, 't', 1310, 'Chargeable cubic measurements', 'The cubic measurements on which charges are based.'),
(1, 't', 1311, 'Chargeable surface', 'The surface area on which charges are based.'),
(1, 't', 1312, 'Chargeable length', 'The length on which charges are based.'),
(1, 't', 1313, 'Quantity to be delivered', 'The quantity to be delivered.'),
(1, 't', 1314, 'Number of passengers', 'Total number of passengers on the conveyance.'),
(1, 't', 1315, 'Number of crew', 'Total number of crew members on the conveyance.'),
(1, 't', 1316, 'Number of transport documents', 'Total number of air waybills, bills of lading, etc. being reported for a specific conveyance.'),
(1, 't', 1317, 'Quantity landed', 'Quantity of goods actually arrived.'),
(1, 't', 1318, 'Quantity manifested', 'Quantity of goods contracted for delivery by the carrier.'),
(1, 't', 1319, 'Short shipped', 'Indication that part of the consignment was not shipped.'),
(1, 't', 1320, 'Split shipment', 'Indication that the consignment has been split into two or more shipments.'),
(1, 't', 1321, 'Over shipped', 'The quantity of goods shipped that exceeds the quantity contracted.'),
(1, 't', 1322, 'Short-landed goods', 'If quantity of goods actually landed is less than the quantity which appears in the documentation. This quantity is the difference between these quantities.'),
(1, 't', 1323, 'Surplus goods', 'If quantity of goods actually landed is more than the quantity which appears in the documentation. This quantity is the difference between these quantities.'),
(1, 'f', 1324, 'Damaged goods', 'Quantity of goods which have deteriorated in transport such that they cannot be used for the purpose for which they were originally intended.'),
(1, 'f', 1325, 'Pilferage goods', 'Quantity of goods stolen during transport.'),
(1, 'f', 1326, 'Lost goods', 'Quantity of goods that disappeared in transport.'),
(1, 't', 1327, 'Report difference', 'The quantity concerning the same transaction differs between two documents/messages and the source of this difference is a typing error.'),
(1, 't', 1328, 'Quantity loaded', 'Quantity of goods loaded onto a means of transport.'),
(1, 't', 1329, 'Units per unit price', 'Number of units per unit price.'),
(1, 't', 1330, 'Allowance', 'Quantity relevant for allowance.'),
(1, 't', 1331, 'Delivery quantity', 'Quantity required by buyer to be delivered.'),
(1, 't', 1332, 'Cumulative quantity, preceding period, planned', 'Cumulative quantity originally planned for the preceding period.'),
(1, 't', 1333, 'Cumulative quantity, preceding period, reached', 'Cumulative quantity reached in the preceding period.'),
(1, 't', 1334, 'Cumulative quantity, actual planned',            'Cumulative quantity planned for now.'),
(1, 't', 1335, 'Period quantity, planned', 'Quantity planned for this period.'),
(1, 't', 1336, 'Period quantity, reached', 'Quantity reached during this period.'),
(1, 't', 1337, 'Cumulative quantity, preceding period, estimated', 'Estimated cumulative quantity reached in the preceding period.'),
(1, 't', 1338, 'Cumulative quantity, actual estimated',            'Estimated cumulative quantity reached now.'),
(1, 't', 1339, 'Cumulative quantity, preceding period, measured', 'Surveyed cumulative quantity reached in the preceding period.'),
(1, 't', 1340, 'Cumulative quantity, actual measured', 'Surveyed cumulative quantity reached now.'),
(1, 't', 1341, 'Period quantity, measured',            'Surveyed quantity reached during this period.'),
(1, 't', 1342, 'Total quantity, planned', 'Total quantity planned.'),
(1, 't', 1343, 'Quantity, remaining', 'Quantity remaining.'),
(1, 't', 1344, 'Tolerance', 'Plus or minus tolerance expressed as a monetary amount.'),
(1, 't', 1345, 'Actual stock',          'The stock on hand, undamaged, and available for despatch, sale or use.'),
(1, 't', 1346, 'Model or target stock', 'The stock quantity required or planned to have on hand, undamaged and available for use.'),
(1, 't', 1347, 'Direct shipment quantity', 'Quantity to be shipped directly to a customer from a manufacturing site.'),
(1, 't', 1348, 'Amortization total quantity',     'Indication of final quantity for amortization.'),
(1, 't', 1349, 'Amortization order quantity',     'Indication of actual share of the order quantity for amortization.'),
(1, 't', 1350, 'Amortization cumulated quantity', 'Indication of actual cumulated quantity of previous and actual amortization order quantity.'),
(1, 't', 1351, 'Quantity advised',  'Quantity advised by supplier or shipper, in contrast to quantity actually received.'),
(1, 't', 1352, 'Consignment stock', 'Quantity of goods with an external customer which is still the property of the supplier. Payment for these goods is only made to the supplier when the ownership has been transferred between the trading partners.'),
(1, 't', 1353, 'Statistical sales quantity', 'Quantity of goods sold in a specified period.'),
(1, 't', 1354, 'Sales quantity planned',     'Quantity of goods required to meet future demands. - Market intelligence quantity.'),
(1, 't', 1355, 'Replenishment quantity',     'Quantity required to maintain the requisite on-hand stock of goods.'),
(1, 't', 1356, 'Inventory movement quantity', 'To specify the quantity of an inventory movement.'),
(1, 't', 1357, 'Opening stock balance quantity', 'To specify the quantity of an opening stock balance.'),
(1, 't', 1358, 'Closing stock balance quantity', 'To specify the quantity of a closing stock balance.'),
(1, 't', 1359, 'Number of stops', 'Number of times a means of transport stops before arriving at destination.'),
(1, 't', 1360, 'Minimum production batch', 'The quantity specified is the minimum output from a single production run.'),
(1, 't', 1361, 'Dimensional sample quantity', 'The quantity defined is a sample for the purpose of validating dimensions.'),
(1, 't', 1362, 'Functional sample quantity', 'The quantity defined is a sample for the purpose of validating function and performance.'),
(1, 't', 1363, 'Pre-production quantity', 'Quantity of the referenced item required prior to full production.'),
(1, 't', 1364, 'Delivery batch', 'Quantity of the referenced item which constitutes a standard batch for deliver purposes.'),
(1, 't', 1365, 'Delivery batch multiple', 'The multiples in which delivery batches can be supplied.'),
(1, 't', 1366, 'All time buy',             'The total quantity of the referenced covering all future needs. Further orders of the referenced item are not expected.'),
(1, 't', 1367, 'Total delivery quantity',  'The total quantity required by the buyer to be delivered.'),
(1, 't', 1368, 'Single delivery quantity', 'The quantity required by the buyer to be delivered in a single shipment.'),
(1, 't', 1369, 'Supplied quantity',  'Quantity of the referenced item actually shipped.'),
(1, 't', 1370, 'Allocated quantity', 'Quantity of the referenced item allocated from available stock for delivery.'),
(1, 't', 1371, 'Maximum stackability', 'The number of pallets/handling units which can be safely stacked one on top of another.'),
(1, 't', 1372, 'Amortisation quantity', 'The quantity of the referenced item which has a cost for tooling amortisation included in the item price.'),
(1, 't', 1373, 'Previously amortised quantity', 'The cumulative quantity of the referenced item which had a cost for tooling amortisation included in the item price.'),
(1, 't', 1374, 'Total amortisation quantity', 'The total quantity of the referenced item which has a cost for tooling amortisation included in the item price.'),
(1, 't', 1375, 'Number of moulds', 'The number of pressing moulds contained within a single piece of the referenced tooling.'),
(1, 't', 1376, 'Concurrent item output of tooling', 'The number of related items which can be produced simultaneously with a single piece of the referenced tooling.'),
(1, 't', 1377, 'Periodic capacity of tooling', 'Maximum production output of the referenced tool over a period of time.'),
(1, 't', 1378, 'Lifetime capacity of tooling', 'Maximum production output of the referenced tool over its productive lifetime.'),
(1, 't', 1379, 'Number of deliveries per despatch period', 'The number of deliveries normally expected to be despatched within each despatch period.'),
(1, 't', 1380, 'Provided quantity', 'The quantity of a referenced component supplied by the buyer for manufacturing of an ordered item.'),
(1, 't', 1381, 'Maximum production batch', 'The quantity specified is the maximum output from a single production run.'),
(1, 'f', 1382, 'Cancelled quantity', 'Quantity of the referenced item which has previously been ordered and is now cancelled.'),
(1, 't', 1383, 'No delivery requirement in this instruction', 'This delivery instruction does not contain any delivery requirements.'),
(1, 't', 1384, 'Quantity of material in ordered time', 'Quantity of the referenced material within the ordered time.'),
(1, 'f', 1385, 'Rejected quantity', 'The quantity of received goods rejected for quantity reasons.'),
(1, 't', 1386, 'Cumulative quantity scheduled up to accumulation start date', 'The cumulative quantity scheduled up to the accumulation start date.'),
(1, 't', 1387, 'Quantity scheduled', 'The quantity scheduled for delivery.'),
(1, 't', 1388, 'Number of identical handling units', 'Number of identical handling units in terms of type and contents.'),
(1, 't', 1389, 'Number of packages in handling unit', 'The number of packages contained in one handling unit.'),
(1, 't', 1390, 'Despatch note quantity', 'The item quantity specified on the despatch note.'),
(1, 't', 1391, 'Adjustment to inventory quantity', 'An adjustment to inventory quantity.'),
(1, 't', 1392, 'Free goods quantity',    'Quantity of goods which are free of charge.'),
(1, 't', 1393, 'Free quantity included', 'Quantity included to which no charge is applicable.'),
(1, 't', 1394, 'Received and accepted',  'Quantity which has been received and accepted at a given location.'),
(1, 'f', 1395, 'Received, not accepted, to be returned',  'Quantity which has been received but not accepted at a given location and which will consequently be returned to the relevant party.'),
(1, 'f', 1396, 'Received, not accepted, to be destroyed', 'Quantity which has been received but not accepted at a given location and which will consequently be destroyed.'),
(1, 't', 1397, 'Reordering level', 'Quantity at which an order may be triggered to replenish.'),
(1, 't', 1399, 'Inventory withdrawal quantity', 'Quantity which has been withdrawn from inventory since the last inventory report.'),
(1, 't', 1400, 'Free quantity not included', 'Free quantity not included in ordered quantity.'),
(1, 't', 1401, 'Recommended overhaul and repair quantity', 'To indicate the recommended quantity of an article required to support overhaul and repair activities.'),
(1, 't', 1402, 'Quantity per next higher assembly', 'To indicate the quantity required for the next higher assembly.'),
(1, 't', 1403, 'Quantity per unit of issue', 'Provides the standard quantity of an article in which one unit can be issued.'),
(1, 't', 1404, 'Cumulative scrap quantity',  'Provides the cumulative quantity of an item which has been identified as scrapped.'),
(1, 't', 1405, 'Publication turn size', 'The quantity of magazines or newspapers grouped together with the spine facing alternate directions in a bundle.'),
(1, 't', 1406, 'Recommended maintenance quantity', 'Recommended quantity of an article which is required to meet an agreed level of maintenance.'),
(1, 't', 1407, 'Labour hours', 'Number of labour hours.'),
(1, 't', 1408, 'Quantity requirement for maintenance and repair of', 'equipment Quantity of the material needed to maintain and repair equipment.'),
(1, 't', 1409, 'Additional replenishment demand quantity', 'Incremental needs over and above normal replenishment calculations, but not intended to permanently change the model parameters.'),
(1, 't', 1410, 'Returned by consumer quantity', 'Quantity returned by a consumer.'),
(1, 't', 1411, 'Replenishment override quantity', 'Quantity to override the normal replenishment model calculations, but not intended to permanently change the model parameters.'),
(1, 't', 1412, 'Quantity sold, net', 'Net quantity sold which includes returns of saleable inventory and other adjustments.'),
(1, 't', 1413, 'Transferred out quantity',   'Quantity which was transferred out of this location.'),
(1, 't', 1414, 'Transferred in quantity',    'Quantity which was transferred into this location.'),
(1, 't', 1415, 'Unsaleable quantity',        'Quantity of inventory received which cannot be sold in its present condition.'),
(1, 't', 1416, 'Consumer reserved quantity', 'Quantity reserved for consumer delivery or pickup and not yet withdrawn from inventory.'),
(1, 't', 1417, 'Out of inventory quantity',  'Quantity of inventory which was requested but was not available.'),
(1, 't', 1418, 'Quantity returned, defective or damaged', 'Quantity returned in a damaged or defective condition.'),
(1, 't', 1419, 'Taxable quantity',           'Quantity subject to taxation.'),
(1, 't', 1420, 'Meter reading', 'The numeric value of measure units counted by a meter.'),
(1, 't', 1421, 'Maximum requestable quantity', 'The maximum quantity which may be requested.'),
(1, 't', 1422, 'Minimum requestable quantity', 'The minimum quantity which may be requested.'),
(1, 't', 1423, 'Daily average quantity', 'The quantity for a defined period divided by the number of days of the period.'),
(1, 't', 1424, 'Budgeted hours',     'The number of budgeted hours.'),
(1, 't', 1425, 'Actual hours',       'The number of actual hours.'),
(1, 't', 1426, 'Earned value hours', 'The number of earned value hours.'),
(1, 't', 1427, 'Estimated hours',    'The number of estimated hours.'),
(1, 't', 1428, 'Level resource task quantity', 'Quantity of a resource that is level for the duration of the task.'),
(1, 't', 1429, 'Available resource task quantity', 'Quantity of a resource available to complete a task.'),
(1, 't', 1430, 'Work time units',   'Quantity of work units of time.'),
(1, 't', 1431, 'Daily work shifts', 'Quantity of work shifts per day.'),
(1, 't', 1432, 'Work time units per shift', 'Work units of time per work shift.'),
(1, 't', 1433, 'Work calendar units',       'Work calendar units of time.'),
(1, 't', 1434, 'Elapsed duration',   'Quantity representing the elapsed duration.'),
(1, 't', 1435, 'Remaining duration', 'Quantity representing the remaining duration.'),
(1, 't', 1436, 'Original duration',  'Quantity representing the original duration.'),
(1, 't', 1437, 'Current duration',   'Quantity representing the current duration.'),
(1, 't', 1438, 'Total float time',   'Quantity representing the total float time.'),
(1, 't', 1439, 'Free float time',    'Quantity representing the free float time.'),
(1, 't', 1440, 'Lag time',           'Quantity representing lag time.'),
(1, 't', 1441, 'Lead time',          'Quantity representing lead time.'),
(1, 't', 1442, 'Number of months', 'The number of months.'),
(1, 't', 1443, 'Reserved quantity customer direct delivery sales', 'Quantity of products reserved for sales delivered direct to the customer.'),
(1, 't', 1444, 'Reserved quantity retail sales', 'Quantity of products reserved for retail sales.'),
(1, 't', 1445, 'Consolidated discount inventory', 'A quantity of inventory supplied at consolidated discount terms.'),
(1, 't', 1446, 'Returns replacement quantity',    'A quantity of goods issued as a replacement for a returned quantity.'),
(1, 't', 1447, 'Additional promotion sales forecast quantity', 'A forecast of additional quantity which will be sold during a period of promotional activity.'),
(1, 't', 1448, 'Reserved quantity', 'Quantity reserved for specific purposes.'),
(1, 't', 1449, 'Quantity displayed not available for sale', 'Quantity displayed within a retail outlet but not available for sale.'),
(1, 't', 1450, 'Inventory discrepancy', 'The difference recorded between theoretical and physical inventory.'),
(1, 't', 1451, 'Incremental order quantity', 'The incremental quantity by which ordering is carried out.'),
(1, 't', 1452, 'Quantity requiring manipulation before despatch', 'A quantity of goods which needs manipulation before despatch.'),
(1, 't', 1453, 'Quantity in quarantine',              'A quantity of goods which are held in a restricted area for quarantine purposes.'),
(1, 't', 1454, 'Quantity withheld by owner of goods', 'A quantity of goods which has been withheld by the owner of the goods.'),
(1, 't', 1455, 'Quantity not available for despatch', 'A quantity of goods not available for despatch.'),
(1, 't', 1456, 'Quantity awaiting delivery', 'Quantity of goods which are awaiting delivery.'),
(1, 't', 1457, 'Quantity in physical inventory',      'A quantity of goods held in physical inventory.'),
(1, 't', 1458, 'Quantity held by logistic service provider', 'Quantity of goods under the control of a logistic service provider.'),
(1, 't', 1459, 'Optimal quantity', 'The optimal quantity for a given purpose.'),
(1, 't', 1460, 'Delivery quantity balance', 'The difference between the scheduled quantity and the quantity delivered to the consignee at a given date.'),
(1, 't', 1461, 'Cumulative quantity shipped', 'Cumulative quantity of all shipments.'),
(1, 't', 1462, 'Quantity suspended', 'The quantity of something which is suspended.'),
(1, 't', 1463, 'Control quantity', 'The quantity designated for control purposes.'),
(1, 't', 1464, 'Equipment quantity', 'A count of a quantity of equipment.'),
(1, 't', 1465, 'Factor', 'Number by which the measured unit has to be multiplied to calculate the units used.'),
(1, 't', 1466, 'Unsold quantity held by wholesaler', 'Unsold quantity held by the wholesaler.'),
(1, 't', 1467, 'Quantity held by delivery vehicle', 'Quantity of goods held by the delivery vehicle.'),
(1, 't', 1468, 'Quantity held by retail outlet', 'Quantity held by the retail outlet.'),
(1, 'f', 1469, 'Rejected return quantity', 'A quantity for return which has been rejected.'),
(1, 't', 1470, 'Accounts', 'The number of accounts.'),
(1, 't', 1471, 'Accounts placed for collection', 'The number of accounts placed for collection.'),
(1, 't', 1472, 'Activity codes', 'The number of activity codes.'),
(1, 't', 1473, 'Agents', 'The number of agents.'),
(1, 't', 1474, 'Airline attendants', 'The number of airline attendants.'),
(1, 't', 1475, 'Authorised shares',  'The number of shares authorised for issue.'),
(1, 't', 1476, 'Employee average',   'The average number of employees.'),
(1, 't', 1477, 'Branch locations',   'The number of branch locations.'),
(1, 't', 1478, 'Capital changes',    'The number of capital changes made.'),
(1, 't', 1479, 'Clerks', 'The number of clerks.'),
(1, 't', 1480, 'Companies in same activity', 'The number of companies doing business in the same activity category.'),
(1, 't', 1481, 'Companies included in consolidated financial statement', 'The number of companies included in a consolidated financial statement.'),
(1, 't', 1482, 'Cooperative shares', 'The number of cooperative shares.'),
(1, 't', 1483, 'Creditors',   'The number of creditors.'),
(1, 't', 1484, 'Departments', 'The number of departments.'),
(1, 't', 1485, 'Design employees', 'The number of employees involved in the design process.'),
(1, 't', 1486, 'Physicians', 'The number of medical doctors.'),
(1, 't', 1487, 'Domestic affiliated companies', 'The number of affiliated companies located within the country.'),
(1, 't', 1488, 'Drivers', 'The number of drivers.'),
(1, 't', 1489, 'Employed at location',     'The number of employees at the specified location.'),
(1, 't', 1490, 'Employed by this company', 'The number of employees at the specified company.'),
(1, 't', 1491, 'Total employees',    'The total number of employees.'),
(1, 't', 1492, 'Employees shared',   'The number of employees shared among entities.'),
(1, 't', 1493, 'Engineers',          'The number of engineers.'),
(1, 't', 1494, 'Estimated accounts', 'The estimated number of accounts.'),
(1, 't', 1495, 'Estimated employees at location', 'The estimated number of employees at the specified location.'),
(1, 't', 1496, 'Estimated total employees',       'The total estimated number of employees.'),
(1, 't', 1497, 'Executives', 'The number of executives.'),
(1, 't', 1498, 'Agricultural workers',   'The number of agricultural workers.'),
(1, 't', 1499, 'Financial institutions', 'The number of financial institutions.'),
(1, 't', 1500, 'Floors occupied', 'The number of floors occupied.'),
(1, 't', 1501, 'Foreign related entities', 'The number of related entities located outside the country.'),
(1, 't', 1502, 'Group employees',    'The number of employees within the group.'),
(1, 't', 1503, 'Indirect employees', 'The number of employees not associated with direct production.'),
(1, 't', 1504, 'Installers',    'The number of employees involved with the installation process.'),
(1, 't', 1505, 'Invoices',      'The number of invoices.'),
(1, 't', 1506, 'Issued shares', 'The number of shares actually issued.'),
(1, 't', 1507, 'Labourers',     'The number of labourers.'),
(1, 't', 1508, 'Manufactured units', 'The number of units manufactured.'),
(1, 't', 1509, 'Maximum number of employees', 'The maximum number of people employed.'),
(1, 't', 1510, 'Maximum number of employees at location', 'The maximum number of people employed at a location.'),
(1, 't', 1511, 'Members in group', 'The number of members within a group.'),
(1, 't', 1512, 'Minimum number of employees at location', 'The minimum number of people employed at a location.'),
(1, 't', 1513, 'Minimum number of employees', 'The minimum number of people employed.'),
(1, 't', 1514, 'Non-union employees', 'The number of employees not belonging to a labour union.'),
(1, 't', 1515, 'Floors', 'The number of floors in a building.'),
(1, 't', 1516, 'Nurses', 'The number of nurses.'),
(1, 't', 1517, 'Office workers', 'The number of workers in an office.'),
(1, 't', 1518, 'Other employees', 'The number of employees otherwise categorised.'),
(1, 't', 1519, 'Part time employees', 'The number of employees working on a part time basis.'),
(1, 't', 1520, 'Accounts payable average overdue days', 'The average number of days accounts payable are overdue.'),
(1, 't', 1521, 'Pilots', 'The number of pilots.'),
(1, 't', 1522, 'Plant workers', 'The number of workers within a plant.'),
(1, 't', 1523, 'Previous number of accounts', 'The number of accounts which preceded the current count.'),
(1, 't', 1524, 'Previous number of branch locations', 'The number of branch locations which preceded the current count.'),
(1, 't', 1525, 'Principals included as employees', 'The number of principals which are included in the count of employees.'),
(1, 't', 1526, 'Protested bills', 'The number of bills which are protested.'),
(1, 't', 1527, 'Registered brands distributed', 'The number of registered brands which are being distributed.'),
(1, 't', 1528, 'Registered brands manufactured', 'The number of registered brands which are being manufactured.'),
(1, 't', 1529, 'Related business entities', 'The number of related business entities.'),
(1, 't', 1530, 'Relatives employed', 'The number of relatives which are counted as employees.'),
(1, 't', 1531, 'Rooms',        'The number of rooms.'),
(1, 't', 1532, 'Salespersons', 'The number of salespersons.'),
(1, 't', 1533, 'Seats',        'The number of seats.'),
(1, 't', 1534, 'Shareholders', 'The number of shareholders.'),
(1, 't', 1535, 'Shares of common stock', 'The number of shares of common stock.'),
(1, 't', 1536, 'Shares of preferred stock', 'The number of shares of preferred stock.'),
(1, 't', 1537, 'Silent partners', 'The number of silent partners.'),
(1, 't', 1538, 'Subcontractors',  'The number of subcontractors.'),
(1, 't', 1539, 'Subsidiaries',    'The number of subsidiaries.'),
(1, 't', 1540, 'Law suits',       'The number of law suits.'),
(1, 't', 1541, 'Suppliers',       'The number of suppliers.'),
(1, 't', 1542, 'Teachers',        'The number of teachers.'),
(1, 't', 1543, 'Technicians',     'The number of technicians.'),
(1, 't', 1544, 'Trainees',        'The number of trainees.'),
(1, 't', 1545, 'Union employees', 'The number of employees who are members of a labour union.'),
(1, 't', 1546, 'Number of units', 'The quantity of units.'),
(1, 't', 1547, 'Warehouse employees', 'The number of employees who work in a warehouse setting.'),
(1, 't', 1548, 'Shareholders holding remainder of shares', 'Number of shareholders owning the remainder of shares.'),
(1, 't', 1549, 'Payment orders filed', 'Number of payment orders filed.'),
(1, 't', 1550, 'Uncovered cheques', 'Number of uncovered cheques.'),
(1, 't', 1551, 'Auctions', 'Number of auctions.'),
(1, 't', 1552, 'Units produced', 'The number of units produced.'),
(1, 't', 1553, 'Added employees', 'Number of employees that were added to the workforce.'),
(1, 't', 1554, 'Number of added locations', 'Number of locations that were added.'),
(1, 't', 1555, 'Total number of foreign subsidiaries not included in', 'financial statement The total number of foreign subsidiaries not included in the financial statement.'),
(1, 't', 1556, 'Number of closed locations', 'Number of locations that were closed.'),
(1, 't', 1557, 'Counter clerks', 'The number of clerks that work behind a flat-topped fitment.'),
(1, 't', 1558, 'Payment experiences in the last 3 months', 'The number of payment experiences received for an entity over the last 3 months.'),
(1, 't', 1559, 'Payment experiences in the last 12 months', 'The number of payment experiences received for an entity over the last 12 months.'),
(1, 't', 1560, 'Total number of subsidiaries not included in the financial', 'statement The total number of subsidiaries not included in the financial statement.'),
(1, 't', 1561, 'Paid-in common shares', 'The number of paid-in common shares.'),
(1, 't', 1562, 'Total number of domestic subsidiaries not included in', 'financial statement The total number of domestic subsidiaries not included in the financial statement.'),
(1, 't', 1563, 'Total number of foreign subsidiaries included in financial statement', 'The total number of foreign subsidiaries included in the financial statement.'),
(1, 't', 1564, 'Total number of domestic subsidiaries included in financial statement', 'The total number of domestic subsidiaries included in the financial statement.'),
(1, 't', 1565, 'Total transactions', 'The total number of transactions.'),
(1, 't', 1566, 'Paid-in preferred shares', 'The number of paid-in preferred shares.'),
(1, 't', 1567, 'Employees', 'Code specifying the quantity of persons working for a company, whose services are used for pay.'),
(1, 't', 1568, 'Active ingredient dose per unit, dispensed', 'The dosage of active ingredient per dispensed unit.'),
(1, 't', 1569, 'Budget', 'Budget quantity.'),
(1, 't', 1570, 'Budget, cumulative to date', 'Budget quantity, cumulative to date.'),
(1, 't', 1571, 'Actual units', 'The number of actual units.'),
(1, 't', 1572, 'Actual units, cumulative to date', 'The number of cumulative to date actual units.'),
(1, 't', 1573, 'Earned value', 'Earned value quantity.'),
(1, 't', 1574, 'Earned value, cumulative to date', 'Earned value quantity accumulated to date.'),
(1, 't', 1575, 'At completion quantity, estimated', 'The estimated quantity when a project is complete.'),
(1, 't', 1576, 'To complete quantity, estimated', 'The estimated quantity required to complete a project.'),
(1, 't', 1577, 'Adjusted units', 'The number of adjusted units.'),
(1, 't', 1578, 'Number of limited partnership shares', 'Number of shares held in a limited partnership.'),
(1, 't', 1579, 'National business failure incidences', 'Number of firms in a country that discontinued with a loss to creditors.'),
(1, 't', 1580, 'Industry business failure incidences', 'Number of firms in a specific industry that discontinued with a loss to creditors.'),
(1, 't', 1581, 'Business class failure incidences', 'Number of firms in a specific class that discontinued with a loss to creditors.'),
(1, 't', 1582, 'Mechanics', 'Number of mechanics.'),
(1, 't', 1583, 'Messengers', 'Number of messengers.'),
(1, 't', 1584, 'Primary managers', 'Number of primary managers.'),
(1, 't', 1585, 'Secretaries', 'Number of secretaries.'),
(1, 't', 1586, 'Detrimental legal filings', 'Number of detrimental legal filings.'),
(1, 't', 1587, 'Branch office locations, estimated', 'Estimated number of branch office locations.'),
(1, 't', 1588, 'Previous number of employees', 'The number of employees for a previous period.'),
(1, 't', 1589, 'Asset seizers', 'Number of entities that seize assets of another entity.'),
(1, 't', 1590, 'Out-turned quantity', 'The quantity discharged.'),
(1, 't', 1591, 'Material on-board quantity, prior to loading', 'The material in vessel tanks, void spaces, and pipelines prior to loading.'),
(1, 't', 1592, 'Supplier estimated previous meter reading', 'Previous meter reading estimated by the supplier.'),
(1, 't', 1593, 'Supplier estimated latest meter reading',   'Latest meter reading estimated by the supplier.'),
(1, 't', 1594, 'Customer estimated previous meter reading', 'Previous meter reading estimated by the customer.'),
(1, 't', 1595, 'Customer estimated latest meter reading',   'Latest meter reading estimated by the customer.'),
(1, 't', 1596, 'Supplier previous meter reading',           'Previous meter reading done by the supplier.'),
(1, 't', 1597, 'Supplier latest meter reading',             'Latest meter reading recorded by the supplier.'),
(1, 't', 1598, 'Maximum number of purchase orders allowed', 'Maximum number of purchase orders that are allowed.'),
(1, 't', 1599, 'File size before compression', 'The size of a file before compression.'),
(1, 't', 1600, 'File size after compression', 'The size of a file after compression.'),
(1, 't', 1601, 'Securities shares', 'Number of shares of securities.'),
(1, 't', 1602, 'Patients',         'Number of patients.'),
(1, 't', 1603, 'Completed projects', 'Number of completed projects.'),
(1, 't', 1604, 'Promoters',        'Number of entities who finance or organize an event or a production.'),
(1, 't', 1605, 'Administrators',   'Number of administrators.'),
(1, 't', 1606, 'Supervisors',      'Number of supervisors.'),
(1, 't', 1607, 'Professionals',    'Number of professionals.'),
(1, 't', 1608, 'Debt collectors',  'Number of debt collectors.'),
(1, 't', 1609, 'Inspectors',       'Number of individuals who perform inspections.'),
(1, 't', 1610, 'Operators',        'Number of operators.'),
(1, 't', 1611, 'Trainers',         'Number of trainers.'),
(1, 't', 1612, 'Active accounts',  'Number of accounts in a current or active status.'),
(1, 't', 1613, 'Trademarks used',  'Number of trademarks used.'),
(1, 't', 1614, 'Machines',         'Number of machines.'),
(1, 't', 1615, 'Fuel pumps',       'Number of fuel pumps.'),
(1, 't', 1616, 'Tables available', 'Number of tables available for use.'),
(1, 't', 1617, 'Directors',        'Number of directors.'),
(1, 't', 1618, 'Freelance debt collectors', 'Number of debt collectors who work on a freelance basis.'),
(1, 't', 1619, 'Freelance salespersons',    'Number of salespersons who work on a freelance basis.'),
(1, 't', 1620, 'Travelling employees',      'Number of travelling employees.'),
(1, 't', 1621, 'Foremen', 'Number of workers with limited supervisory responsibilities.'),
(1, 't', 1622, 'Production workers', 'Number of employees engaged in production.'),
(1, 't', 1623, 'Employees not including owners', 'Number of employees excluding business owners.'),
(1, 't', 1624, 'Beds', 'Number of beds.'),
(1, 't', 1625, 'Resting quantity', 'A quantity of product that is at rest before it can be used.'),
(1, 't', 1626, 'Production requirements', 'Quantity needed to meet production requirements.'),
(1, 't', 1627, 'Corrected quantity', 'The quantity has been corrected.'),
(1, 't', 1628, 'Operating divisions', 'Number of divisions operating.'),
(1, 't', 1629, 'Quantitative incentive scheme base', 'Quantity constituting the base for the quantitative incentive scheme.'),
(1, 't', 1630, 'Petitions filed', 'Number of petitions that have been filed.'),
(1, 't', 1631, 'Bankruptcy petitions filed', 'Number of bankruptcy petitions that have been filed.'),
(1, 't', 1632, 'Projects in process', 'Number of projects in process.'),
(1, 't', 1633, 'Changes in capital structure', 'Number of modifications made to the capital structure of an entity.'),
(1, 't', 1634, 'Detrimental legal filings against directors', 'The number of legal filings that are of a detrimental nature that have been filed against the directors.'),
(1, 't', 1635, 'Number of failed businesses of directors', 'The number of failed businesses with which the directors have been associated.'),
(1, 't', 1636, 'Professor', 'The number of professors.'),
(1, 't', 1637, 'Seller',    'The number of sellers.'),
(1, 't', 1638, 'Skilled worker', 'The number of skilled workers.'),
(1, 't', 1639, 'Trademark represented', 'The number of trademarks represented.'),
(1, 't', 1640, 'Number of quantitative incentive scheme units', 'Number of units allocated to a quantitative incentive scheme.'),
(1, 't', 1641, 'Quantity in manufacturing process', 'Quantity currently in the manufacturing process.'),
(1, 't', 1642, 'Number of units in the width of a layer', 'Number of units which make up the width of a layer.'),
(1, 't', 1643, 'Number of units in the depth of a layer', 'Number of units which make up the depth of a layer.'),
(1, 't', 1644, 'Return to warehouse', 'A quantity of products sent back to the warehouse.'),
(1, 't', 1645, 'Return to the manufacturer', 'A quantity of products sent back from the manufacturer.'),
(1, 't', 1646, 'Delta quantity', 'An increment or decrement to a quantity.'),
(1, 't', 1647, 'Quantity moved between outlets', 'A quantity of products moved between outlets.'),
(1, 't', 1648, 'Pre-paid invoice annual consumption, estimated', 'The estimated annual consumption used for a prepayment invoice.'),
(1, 't', 1649, 'Total quoted quantity', 'The sum of quoted quantities.'),
(1, 't', 1650, 'Requests pertaining to entity in last 12 months', 'Number of requests received in last 12 months pertaining to the entity.'),
(1, 't', 1651, 'Total inquiry matches', 'Number of instances which correspond with the inquiry.'),
(1, 't', 1652, 'En route to warehouse quantity',   'A quantity of products that is en route to a warehouse.'),
(1, 't', 1653, 'En route from warehouse quantity', 'A quantity of products that is en route from a warehouse.'),
(1, 't', 1654, 'Quantity ordered but not yet allocated from stock', 'A quantity of products which has been ordered but which has not yet been allocated from stock.'),
(1, 't', 1655, 'Not yet ordered quantity', 'The quantity which has not yet been ordered.'),
(1, 't', 1656, 'Net reserve power', 'The reserve power available for the net.'),
(1, 't', 1657, 'Maximum number of units per shelf', 'Maximum number of units of a product that can be placed on a shelf.'),
(1, 't', 1658, 'Stowaway', 'Number of stowaway(s) on a conveyance.'),
(1, 't', 1659, 'Tug', 'The number of tugboat(s).'),
(1, 't', 1660, 'Maximum quantity capability of the package', 'Maximum quantity of a product that can be contained in a package.'),
(1, 't', 1661, 'Calculated', 'The calculated quantity.'),
(1, 't', 1662, 'Monthly volume, estimated', 'Volume estimated for a month.'),
(1, 't', 1663, 'Total number of persons', 'Quantity representing the total number of persons.'),
(1, 't', 1664, 'Tariff Quantity', 'Quantity of the goods in the unit as required by Customs for duty/tax/fee assessment. These quantities may also be used for other fiscal or statistical purposes.'),
(1, 't', 1665, 'Deducted tariff quantity',   'Quantity deducted from tariff quantity to reckon duty/tax/fee assessment bases.'),
(1, 't', 1666, 'Advised but not arrived',    'Goods are advised by the consignor or supplier, but have not yet arrived at the destination.'),
(1, 't', 1667, 'Received but not available', 'Goods have been received in the arrival area but are not yet available.'),
(1, 't', 1668, 'Goods blocked for transshipment process', 'Goods are physically present, but can not be ordered because they are scheduled for a transshipment process.'),
(1, 't', 1669, 'Goods blocked for cross docking process', 'Goods are physically present, but can not be ordered because they are scheduled for a cross docking process.'),
(1, 't', 1670, 'Chargeable number of trailers', 'The number of trailers on which charges are based.'),
(1, 't', 1671, 'Number of packages for a set', 'Number of packages used to pack the individual items in a grouping of merchandise that is sold together as a single trade item.'),
(1, 't', 1672, 'Number of items in a set', 'The number of individual items in a grouping of merchandise that is sold together as a single trade item.'),
(1, 't', 1673, 'Order sizing factor', 'A trade item specification other than gross, net weight, or volume for a trade item or a transaction, used for order sizing and pricing purposes.'),
(1, 't', 1674, 'Number of different next lower level trade items', 'Value indicates the number of differrent next lower level trade items contained in a complex trade item.'),
(1, 't', 1675, 'Agreed maximum buying quantity', 'The agreed maximum quantity of the trade item that may be purchased.'),
(1, 't', 1676, 'Agreed minimum buying quantity', 'The agreed minimum quantity of the trade item that may be purchased.'),
(1, 't', 1677, 'Free quantity of next lower level trade item', 'The numeric quantity of free items in a combination pack. The unit of measure used for the free quantity of the next lower level must be the same as the unit of measure of the Net Content of the Child Trade Item.'),
(1, 't', 1678, 'Marine Diesel Oil bunkers on board, on arrival',     'Number of Marine Diesel Oil (MDO) bunkers on board when the vessel arrives in the port.'),
(1, 't', 1679, 'Marine Diesel Oil bunkers, loaded',                  'Number of Marine Diesel Oil (MDO) bunkers taken on in the port.'),
(1, 't', 1680, 'Intermediate Fuel Oil bunkers on board, on arrival', 'Number of Intermediate Fuel Oil (IFO) bunkers on board when the vessel arrives in the port.'),
(1, 't', 1681, 'Intermediate Fuel Oil bunkers, loaded',              'Number of Intermediate Fuel Oil (IFO) bunkers taken on in the port.'),
(1, 't', 1682, 'Bunker C bunkers on board, on arrival',              'Number of Bunker C, or Number 6 fuel oil bunkers on board when the vessel arrives in the port.'),
(1, 't', 1683, 'Bunker C bunkers, loaded', 'Number of Bunker C, or Number 6 fuel oil bunkers, taken on in the port.'),
(1, 't', 1684, 'Number of individual units within the smallest packaging', 'unit Total number of individual units contained within the smallest unit of packaging.'),
(1, 't', 1685, 'Percentage of constituent element', 'The part of a product or material that is composed of the constituent element, as a percentage.'),
(1, 't', 1686, 'Quantity to be decremented (LPCO)', 'Quantity to be decremented from the allowable quantity on a License, Permit, Certificate, or Other document (LPCO).'),
(1, 't', 1687, 'Regulated commodity count', 'The number of regulated items.'),
(1, 't', 1688, 'Number of passengers, embarking', 'The number of passengers going aboard a conveyance.'),
(1, 't', 1689, 'Number of passengers, disembarking', 'The number of passengers disembarking the conveyance.'),
(1, 't', 1690, 'Constituent element or component quantity', 'The specific quantity of the identified constituent element.')
;
-- ZZZ, 'Mutually defined', 'As agreed by the trading partners.'),


INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
    VALUES (
        'circ.holds.hold_has_copy_at.alert',
        oils_i18n_gettext('circ.holds.hold_has_copy_at.alert', 'Holds: Has Local Copy Alert', 'coust', 'label'),
        oils_i18n_gettext('circ.holds.hold_has_copy_at.alert', 'If there is an available copy at the requesting library that could fulfill a hold during hold placement time, alert the patron', 'coust', 'description'),
        'bool'
    ),(
        'circ.holds.hold_has_copy_at.block',
        oils_i18n_gettext('circ.holds.hold_has_copy_at.block', 'Holds: Has Local Copy Block', 'coust', 'label'),
        oils_i18n_gettext('circ.holds.hold_has_copy_at.block', 'If there is an available copy at the requesting library that could fulfill a hold during hold placement time, do not allow the hold to be placed', 'coust', 'description'),
        'bool'
    );

INSERT INTO config.global_flag (name, label) -- defaults to enabled=FALSE
    VALUES (
        'ingest.disable_authority_linking',
        oils_i18n_gettext(
            'ingest.disable_authority_linking',
            'Authority Automation: Disable bib-authority link tracking',
            'cgf', 
            'label'
        )
    );

INSERT INTO config.global_flag (name, label) -- defaults to enabled=FALSE
    VALUES (
        'ingest.disable_authority_auto_update',
        oils_i18n_gettext(
            'ingest.disable_authority_auto_update',
            'Authority Automation: Disable automatic authority updating (requires link tracking)',
            'cgf', 
            'label'
        )
    );

INSERT INTO config.global_flag (name, label) -- defaults to enabled=FALSE
    VALUES (
        'cat.bib.use_id_for_tcn',
        oils_i18n_gettext(
            'cat.bib.use_id_for_tcn',
            'Cat: Use Internal ID for TCN Value',
            'cgf', 
            'label'
        )
    );

INSERT INTO config.global_flag (name,label,enabled)
    VALUES (
        'history.circ.retention_age',
        oils_i18n_gettext('history.circ.retention_age', 'Historical Circulation Retention Age', 'cgf', 'label'),
        TRUE
    ),(
        'history.circ.retention_count',
        oils_i18n_gettext('history.circ.retention_count', 'Historical Circulations per Copy', 'cgf', 'label'),
        TRUE
    );

INSERT INTO config.global_flag (name, label) -- defaults to enabled=FALSE
    VALUES (
        'cat.maintain_control_numbers',
        oils_i18n_gettext(
            'cat.maintain_control_numbers',
            'Cat: Maintain 001/003/035 according to the MARC21 specification',
            'cgf', 
            'label'
        )
    );

INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES (
        'history.circ.retention_age',
        TRUE,
        oils_i18n_gettext('history.circ.retention_age','Historical Circulation Retention Age','cust','label'),
        oils_i18n_gettext('history.circ.retention_age','Historical Circulation Retention Age','cust','description'),
        'interval'
    ),(
        'history.circ.retention_start',
        FALSE,
        oils_i18n_gettext('history.circ.retention_start','Historical Circulation Retention Start Date','cust','label'),
        oils_i18n_gettext('history.circ.retention_start','Historical Circulation Retention Start Date','cust','description'),
        'date'
    );

INSERT INTO config.usr_setting_type (name,opac_visible,label,description,datatype)
    VALUES (
        'history.hold.retention_age',
        TRUE,
        oils_i18n_gettext('history.hold.retention_age','Historical Hold Retention Age','cust','label'),
        oils_i18n_gettext('history.hold.retention_age','Historical Hold Retention Age','cust','description'),
        'interval'
    ),(
        'history.hold.retention_start',
        TRUE,
        oils_i18n_gettext('history.hold.retention_start','Historical Hold Retention Start Date','cust','label'),
        oils_i18n_gettext('history.hold.retention_start','Historical Hold Retention Start Date','cust','description'),
        'interval'
    ),(
        'history.hold.retention_count',
        TRUE,
        oils_i18n_gettext('history.hold.retention_count','Historical Hold Retention Count','cust','label'),
        oils_i18n_gettext('history.hold.retention_count','Historical Hold Retention Count','cust','description'),
        'integer'
    );

-- 0281.data.persistent-login-interval.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype )
VALUES (
    'auth.persistent_login_interval',
    oils_i18n_gettext('auth.persistent_login_interval', 'Persistent Login Duration', 'coust', 'label'),
    oils_i18n_gettext('auth.persistent_login_interval', 'How long a persistent login lasts.  E.g. ''2 weeks''', 'coust', 'description'),
    'interval'
);

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'cat.marc_control_number_identifier',
        oils_i18n_gettext(
            'cat.marc_control_number_identifier', 
            'Cat: Defines the control number identifier used in 003 and 035 fields.', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'cat.marc_control_number_identifier', 
            'Cat: Defines the control number identifier used in 003 and 035 fields.', 
            'coust', 
            'description'),
        'string'
);

-- 0311.data.query-seed-datatypes.sql
-- Define the most common datatypes in query.datatype.  Note that none of
-- these stock datatypes specifies a width or precision.

INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (1, 'SMALLINT', true);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (2, 'INTEGER', true);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (3, 'BIGINT', true);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (4, 'DECIMAL', true);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (5, 'NUMERIC', true);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (6, 'REAL', true);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (7, 'DOUBLE PRECISION', true);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (8, 'SERIAL', true);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (9, 'BIGSERIAL', true);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (10, 'MONEY', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (11, 'VARCHAR', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (12, 'CHAR', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (13, 'TEXT', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (14, '"char"', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (15, 'NAME', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (16, 'BYTEA', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (17, 'TIMESTAMP WITHOUT TIME ZONE', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (18, 'TIMESTAMP WITH TIME ZONE', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (19, 'DATE', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (20, 'TIME WITHOUT TIME ZONE', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (21, 'TIME WITH TIME ZONE', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (22, 'INTERVAL', false);
 
INSERT INTO query.datatype (id, datatype_name, is_numeric )
  VALUES (23, 'BOOLEAN', false);

INSERT INTO config.usr_setting_type (name, opac_visible, label, description, datatype) 
    VALUES (
        'opac.default_sort',
        TRUE,
        oils_i18n_gettext(
            'opac.default_sort',
            'OPAC Default Search Sort',
            'cust',
            'label'
        ),
        oils_i18n_gettext(
            'opac.default_sort',
            'OPAC Default Search Sort',
            'cust',
            'description'
        ),
        'string'
    );

INSERT INTO config.org_unit_setting_type (name, label, description, datatype) 
    VALUES (
        'circ.selfcheck.block_checkout_on_copy_status',
        oils_i18n_gettext(
            'circ.selfcheck.block_checkout_on_copy_status',
            'Selfcheck: Block copy checkout status',
            'coust',
            'label'
        ),
        oils_i18n_gettext(
            'circ.selfcheck.block_checkout_on_copy_status',
            'List of copy status IDs that will block checkout even if the generic COPY_NOT_AVAILABLE event is overridden',
            'coust',
            'description'
        ),
        'array'
    );

-- 0359.data.setting-prev-iss-copy-loc.sql

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype, fm_class )
VALUES (
    'serial.prev_issuance_copy_location',
    oils_i18n_gettext(
        'serial.prev_issuance_copy_location',
        'Serials: Previous Issuance Copy Location',
        'coust',
        'label'
    ),
    oils_i18n_gettext(
        'serial.prev_issuance_copy_location',
        'When a serial issuance is received, copies (units) of the previous issuance will be automatically moved into the configured shelving location',
        'coust',
        'descripton'
        ),
    'link',
    'acpl'
);

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype, fm_class )
VALUES (
    'cat.default_classification_scheme',
    oils_i18n_gettext(
        'cat.default_classification_scheme',
        'Cataloging: Default Classification Scheme',
        'coust',
        'label'
    ),
    oils_i18n_gettext(
        'cat.default_classification_scheme',
        'Defines the default classification scheme for new call numbers: 1 = Generic; 2 = Dewey; 3 = LC',
        'coust',
        'descripton'
        ),
    'link',
    'acnc'
);


-- 0355.data.missing_pieces_format.sql

INSERT INTO action_trigger.hook (key,core_type,description,passive) VALUES 
    (   'circ.format.missing_pieces.slip.print',
        'circ', 
        oils_i18n_gettext(
            'circ.format.missing_pieces.slip.print',
            'A missing pieces slip needs to be formatted for printing.',
            'ath',
            'description'
        ), 
        FALSE
    )
    ,(  'circ.format.missing_pieces.letter.print',
        'circ', 
        oils_i18n_gettext(
            'circ.format.missing_pieces.letter.print',
            'A missing pieces patron letter needs to be formatted for printing.',
            'ath',
            'description'
        ), 
        FALSE
    )
;

INSERT INTO action_trigger.event_definition (
        id,
        active,
        owner,
        name,
        hook,
        validator,
        reactor,
        group_field,
        granularity,
        template
    ) VALUES (
        33,
        TRUE,
        1,
        'circ.missing_pieces.slip.print',
        'circ.format.missing_pieces.slip.print',
        'NOOP_True',
        'ProcessTemplate',
        'usr',
        'print-on-demand',
$$
[%- USE date -%]
[%- SET user = target.0.usr -%]
<div style="li { padding: 8px; margin 5px; }">
    <div>[% date.format %]</div><br/>
    Missing pieces for:
    <ol>
    [% FOR circ IN target %]
        <li>Barcode: [% circ.target_copy.barcode %] Transaction ID: [% circ.id %] Due: [% circ.due_date.format %]<br />
            [% helpers.get_copy_bib_basics(circ.target_copy.id).title %]
        </li>
    [% END %]
    </ol>
</div>
$$
    )
    ,(
        34,
        TRUE,
        1,
        'circ.missing_pieces.letter.print',
        'circ.format.missing_pieces.letter.print',
        'NOOP_True',
        'ProcessTemplate',
        'usr',
        'print-on-demand',
$$
[%- USE date -%]
[%- SET user = target.0.usr -%]
[% date.format %]
Dear [% user.prefix %] [% user.first_given_name %] [% user.family_name %],

We are missing pieces for the following returned items:
[% FOR circ IN target %]
Barcode: [% circ.target_copy.barcode %] Transaction ID: [% circ.id %] Due: [% circ.due_date.format %]
[% helpers.get_copy_bib_basics(circ.target_copy.id).title %]
[% END %]

Please return these pieces as soon as possible.

Thanks!

Library Staff
$$
    )
;

INSERT INTO action_trigger.environment (
        event_def,
        path
    ) VALUES -- for fleshing circ objects
         ( 33, 'usr')
        ,( 33, 'target_copy')
        ,( 33, 'target_copy.circ_lib')
        ,( 33, 'target_copy.circ_lib.mailing_address')
        ,( 33, 'target_copy.circ_lib.billing_address')
        ,( 33, 'target_copy.call_number')
        ,( 33, 'target_copy.call_number.owning_lib')
        ,( 33, 'target_copy.call_number.owning_lib.mailing_address')
        ,( 33, 'target_copy.call_number.owning_lib.billing_address')
        ,( 33, 'circ_lib')
        ,( 33, 'circ_lib.mailing_address')
        ,( 33, 'circ_lib.billing_address')
        ,( 34, 'usr')
        ,( 34, 'target_copy')
        ,( 34, 'target_copy.circ_lib')
        ,( 34, 'target_copy.circ_lib.mailing_address')
        ,( 34, 'target_copy.circ_lib.billing_address')
        ,( 34, 'target_copy.call_number')
        ,( 34, 'target_copy.call_number.owning_lib')
        ,( 34, 'target_copy.call_number.owning_lib.mailing_address')
        ,( 34, 'target_copy.call_number.owning_lib.billing_address')
        ,( 34, 'circ_lib')
        ,( 34, 'circ_lib.mailing_address')
        ,( 34, 'circ_lib.billing_address')
;

-- 0373.data.org-setting-opac.org_unit_hiding.depth.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'opac.org_unit_hiding.depth',
        oils_i18n_gettext(
            'opac.org_unit_hiding.depth',
            'OPAC: Org Unit Hiding Depth', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'opac.org_unit_hiding.depth',
            'This will hide certain org units in the public OPAC if the Original Location (url param "ol") for the OPAC inherits this setting.  This setting specifies an org unit depth, that together with the OPAC Original Location determines which section of the Org Hierarchy should be visible in the OPAC.  For example, a stock Evergreen installation will have a 3-tier hierarchy (Consortium/System/Branch), where System has a depth of 1 and Branch has a depth of 2.  If this setting contains a depth of 1 in such an installation, then every library in the System in which the Original Location belongs will be visible, and everything else will be hidden.  A depth of 0 will effectively make every org visible.  The embedded OPAC in the staff client ignores this setting.', 
            'coust', 
            'description'),
        'integer'
);

INSERT INTO config.org_unit_setting_type (name, label, description, datatype)
    VALUES
        ('circ.holds.alert_if_local_avail',
         oils_i18n_gettext('circ.holds.alert_if_local_avail',
             'Holds: Local available alert', 'coust', 'label'),
         oils_i18n_gettext('circ.holds.alert_if_local_avail',
            'If local copy is available, alert the person making the hold', 'coust', 'description'),
         'bool'),

        ('circ.holds.deny_if_local_avail',
         oils_i18n_gettext('circ.holds.deny_if_local_avail',
            'Holds: Local available block', 'coust', 'label'),
         oils_i18n_gettext('circ.holds.deny_if_local_avail',
            'If local copy is available, deny the creation of the hold', 'coust', 'description'),
         'bool'),

        ('circ.holds.clear_shelf.no_capture_holds',
        oils_i18n_gettext( 'circ.holds.clear_shelf.no_capture_holds',
            'Holds: Bypass hold capture during clear shelf process', 'coust', 'label'),
        oils_i18n_gettext( 'circ.holds.clear_shelf.no_capture_holds',
            'During the clear shelf process, avoid capturing new holds on cleared items.', 'coust', 'description'),
        'bool')
;

-- 0379.data.org-setting-circ.missing_pieces.copy_status.sql
INSERT INTO config.org_unit_setting_type ( name, label, description, datatype, fm_class ) VALUES (
        'circ.missing_pieces.copy_status',
        oils_i18n_gettext(
            'circ.missing_pieces.copy_status',
            'Circulation: Item Status for Missing Pieces', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'circ.missing_pieces.copy_status',
            'This is the Item Status to use for items that have been marked or scanned as having Missing Pieces.  In absense of this setting, the Damaged status is used.',
            'coust', 
            'description'),
        'link',
        'ccs'
);

-- 0380.data.spine_label.sql Add spine label preferences
INSERT INTO config.org_unit_setting_type (name, label, description, datatype)
    VALUES
        ('cat.label.font.size',
            oils_i18n_gettext('cat.label.font.size',
                'Cataloging: Spine and pocket label font size', 'coust', 'label'),
            oils_i18n_gettext('cat.label.font.size',
                'Set the default font size for spine and pocket labels', 'coust', 'description'),
            'integer'
        )
        ,('cat.label.font.family',
            oils_i18n_gettext('cat.label.font.family',
                'Cataloging: Spine and pocket label font family', 'coust', 'label'),
            oils_i18n_gettext('cat.label.font.family',
                'Set the preferred font family for spine and pocket labels. You can specify a list of fonts, separated by commas, in order of preference; the system will use the first font it finds with a matching name. For example, "Arial, Helvetica, serif".',
                'coust', 'description'),
            'string'
        )
        ,('cat.spine.line.width',
            oils_i18n_gettext('cat.spine.line.width',
                'Cataloging: Spine label line width', 'coust', 'label'),
            oils_i18n_gettext('cat.spine.line.width',
                'Set the default line width for spine labels in number of characters. This specifies the boundary at which lines must be wrapped.',
                'coust', 'description'),
            'integer'
        )
        ,('cat.spine.line.height',
            oils_i18n_gettext('cat.spine.line.height',
                'Cataloging: Spine label maximum lines', 'coust', 'label'),
            oils_i18n_gettext('cat.spine.line.height',
                'Set the default maximum number of lines for spine labels.',
                'coust', 'description'),
            'integer'
        )
        ,('cat.spine.line.margin',
            oils_i18n_gettext('cat.spine.line.margin',
                'Cataloging: Spine label left margin', 'coust', 'label'),
            oils_i18n_gettext('cat.spine.line.margin',
                'Set the left margin for spine labels in number of characters.',
                'coust', 'description'),
            'integer'
        )
        ,('cat.label.font.weight',
            oils_i18n_gettext('cat.label.font.weight',
                'Cataloging: Spine and pocket label font weight', 'coust', 'label'),
            oils_i18n_gettext('cat.label.font.weight',
                'Set the preferred font weight for spine and pocket labels. You can specify "normal", "bold", "bolder", or "lighter".',
                'coust', 'description'),
            'string'
        )
;

INSERT INTO actor.org_unit_setting (org_unit, name, value) VALUES
    (1, 'cat.spine.line.margin', 0)
    ,(1, 'cat.spine.line.height', 9)
    ,(1, 'cat.spine.line.width', 8)
    ,(1, 'cat.label.font.family', '"monospace"')
    ,(1, 'cat.label.font.size', 10)
    ,(1, 'cat.label.font.weight', '"normal"')
;

-- 0383.data.org-setting-circ.do_not_tally_claims_returned.sql

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'circ.do_not_tally_claims_returned',
        oils_i18n_gettext(
            'circ.do_not_tally_claims_returned',
            'Circulation: Do not include outstanding Claims Returned circulations in lump sum tallies in Patron Display.', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'circ.do_not_tally_claims_returned',
            'In the Patron Display interface, the number of total active circulations for a given patron is presented in the Summary sidebar and underneath the Items Out navigation button.  This setting will prevent Claims Returned circulations from counting toward these tallies.',
            'coust', 
            'description'),
        'bool'
);

-- 0384.data.hold_pull_list_template.sql

INSERT INTO action_trigger.hook (key,core_type,description,passive) 
    VALUES (   
        'ahr.format.pull_list',
        'ahr', 
        oils_i18n_gettext(
            'ahr.format.pull_list',
            'Format holds pull list for printing',
            'ath',
            'description'
        ), 
        FALSE
    );

INSERT INTO action_trigger.event_definition (
        id,
        active,
        owner,
        name,
        hook,
        validator,
        reactor,
        group_field,
        granularity,
        template
    ) VALUES (
        35,
        TRUE,
        1,
        'Holds Pull List',
        'ahr.format.pull_list',
        'NOOP_True',
        'ProcessTemplate',
        'pickup_lib',
        'print-on-demand',
$$
[%- USE date -%]
<style>
    table { border-collapse: collapse; } 
    td { padding: 5px; border-bottom: 1px solid #888; } 
    th { font-weight: bold; }
</style>
[% 
    # Sort the holds into copy-location buckets
    # In the main print loop, sort each bucket by callnumber before printing
    SET holds_list = [];
    SET loc_data = [];
    SET current_location = target.0.current_copy.location.id;
    FOR hold IN target;
        IF current_location != hold.current_copy.location.id;
            SET current_location = hold.current_copy.location.id;
            holds_list.push(loc_data);
            SET loc_data = [];
        END;
        SET hold_data = {
            'hold' => hold,
            'callnumber' => hold.current_copy.call_number.label
        };
        loc_data.push(hold_data);
    END;
    holds_list.push(loc_data)
%]
<table>
    <thead>
        <tr>
            <th>Title</th>
            <th>Author</th>
            <th>Shelving Location</th>
            <th>Call Number</th>
            <th>Barcode</th>
            <th>Patron</th>
        </tr>
    </thead>
    <tbody>
    [% FOR loc_data IN holds_list  %]
        [% FOR hold_data IN loc_data.sort('callnumber') %]
            [% 
                SET hold = hold_data.hold;
                SET copy_data = helpers.get_copy_bib_basics(hold.current_copy.id);
            %]
            <tr>
                <td>[% copy_data.title | truncate %]</td>
                <td>[% copy_data.author | truncate %]</td>
                <td>[% hold.current_copy.location.name %]</td>
                <td>[% hold.current_copy.call_number.label %]</td>
                <td>[% hold.current_copy.barcode %]</td>
                <td>[% hold.usr.card.barcode %]</td>
            </tr>
        [% END %]
    [% END %]
    <tbody>
</table>
$$
);

INSERT INTO action_trigger.environment (
        event_def,
        path
    ) VALUES
        (35, 'current_copy.location'),
        (35, 'current_copy.call_number'),
        (35, 'usr.card'),
        (35, 'pickup_lib')
;

-- 0386.data.org-setting-patron-clone-copy-addr.sql

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'circ.patron_edit.clone.copy_address',
        oils_i18n_gettext(
            'circ.patron_edit.clone.copy_address',
            'Patron Registration: Cloned patrons get address copy',
            'coust', 
            'label'
        ),
        oils_i18n_gettext(
            'circ.patron_edit.clone.copy_address',
            'In the Patron editor, copy addresses from the cloned user instead of linking directly to the address',
            'coust', 
            'description'
        ),
        'bool'
);

-- 0388.data.org-setting-ui.patron.editor_defaults.sql

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype, fm_class ) VALUES (
        'ui.patron.default_ident_type',
        oils_i18n_gettext(
            'ui.patron.default_ident_type',
            'GUI: Default Ident Type for Patron Registration', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'ui.patron.default_ident_type',
            'This is the default Ident Type for new users in the patron editor.',
            'coust', 
            'description'),
        'link',
        'cit'
);

INSERT INTO config.org_unit_setting_type ( name, label, description, datatype ) VALUES (
        'ui.patron.default_country',
        oils_i18n_gettext(
            'ui.patron.default_country',
            'GUI: Default Country for New Addresses in Patron Editor', 
            'coust', 
            'label'),
        oils_i18n_gettext(
            'ui.patron.default_country',
            'This is the default Country for new addresses in the patron editor.',
            'coust', 
            'description'),
        'string'
);


