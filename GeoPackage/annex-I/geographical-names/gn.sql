PRAGMA application_id=1196444487;
PRAGMA user_version=10201;
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE gpkg_spatial_ref_sys (
  srs_name TEXT NOT NULL,
  srs_id INTEGER NOT NULL PRIMARY KEY,
  organization TEXT NOT NULL,
  organization_coordsys_id INTEGER NOT NULL,
  definition  TEXT NOT NULL,
  description TEXT
, "definition_12_063" TEXT NOT NULL DEFAULT '');
INSERT INTO gpkg_spatial_ref_sys VALUES('Undefined cartesian SRS',-1,'NONE',-1,'undefined','undefined cartesian coordinate reference system','undefined');
INSERT INTO gpkg_spatial_ref_sys VALUES('Undefined geographic SRS',0,'NONE',0,'undefined','undefined geographic coordinate reference system','undefined');
INSERT INTO gpkg_spatial_ref_sys VALUES('WGS 84 geodetic',4326,'EPSG',4326,'GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]]','longitude/latitude coordinates in decimal degrees on the WGS 84 spheroid','GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]]');
CREATE TABLE gpkg_contents (
  table_name TEXT NOT NULL PRIMARY KEY,
  data_type TEXT NOT NULL,
  identifier TEXT UNIQUE,
  description TEXT DEFAULT '',
  last_change DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  min_x DOUBLE,
  min_y DOUBLE,
  max_x DOUBLE,
  max_y DOUBLE,
  srs_id INTEGER,
  CONSTRAINT fk_gc_r_srs_id FOREIGN KEY (srs_id) REFERENCES gpkg_spatial_ref_sys(srs_id)
);
INSERT INTO gpkg_contents VALUES('GN_NamedPlace','features','Geographical Names::NamedPlace','Any real world entity referred to by one or several proper nouns.','2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,0);
INSERT INTO gpkg_contents VALUES('GN_PronunciationOfName','attributes','Geographical Names::PronunciationOfName',replace('Proper, correct or standard (standard within the linguistic community concerned) pronunciation of a name.\n\nSOURCE Adapted from [UNGEGN Manual 2006].','\n',char(10)),'2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('GN_SpellingOfName','attributes','Geographical Names::SpellingOfName',replace('Proper way of writing a name.\n\nSOURCE Adapted from [UNGEGN Manual 2006].\n\nNOTE Proper spelling means the writing of a name with the correct capitalisation and the correct letters and diacritics present in an accepted standard order.','\n',char(10)),'2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('GN_GeographicalName','attributes','Geographical Names::GeographicalName','Proper noun applied to a real world entity.','2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('GN_NamedPlaceTypeValue','attributes','Geographical Names::NamedPlaceTypeValue','The type of a named place.','2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('BASE_Identifier','attributes','Base Types::Identifier',replace('External unique object identifier published by the responsible body, which may be used by external applications to reference the spatial object.\n\nNOTE1 External object identifiers are distinct from thematic object identifiers.\n\nNOTE 2 The voidable version identifier attribute is not part of the unique identifier of a spatial object and may be used to distinguish two versions of the same spatial object.\n\nNOTE 3 The unique identifier will not change during the life-time of a spatial object.','\n',char(10)),'2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('GMD_LocalisedCharacterString','attributes','Cultural and linguistic adapdability::LocalisedCharacterString','','2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('GN_NamedPlace_localType','attributes',NULL,'','2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('GN_NamedPlace_name','attributes',NULL,'','2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('GN_NamedPlace_relatedSpatialObject','attributes',NULL,'','2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('GN_NamedPlace_type','attributes',NULL,'','2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_contents VALUES('GN_GeographicalName_spelling','attributes',NULL,'','2019-12-21T17:11:47.823Z',NULL,NULL,NULL,NULL,NULL);
CREATE TABLE gpkg_extensions (
  table_name TEXT,
  column_name TEXT,
  extension_name TEXT NOT NULL,
  definition TEXT NOT NULL,
  scope TEXT NOT NULL,
  CONSTRAINT ge_tce UNIQUE (table_name, column_name, extension_name)
);
INSERT INTO gpkg_extensions VALUES('gpkg_metadata',NULL,'gpkg_metadata','http://www.geopackage.org/spec/#extension_metadata','read-write');
INSERT INTO gpkg_extensions VALUES('gpkg_metadata_reference',NULL,'gpkg_metadata','http://www.geopackage.org/spec/#extension_metadata','read-write');
INSERT INTO gpkg_extensions VALUES('gpkg_data_columns',NULL,'gpkg_schema','http://www.geopackage.org/spec/#extension_schema','read-write');
INSERT INTO gpkg_extensions VALUES('gpkg_data_column_constraints',NULL,'gpkg_schema','http://www.geopackage.org/spec/#extension_schema','read-write');
INSERT INTO gpkg_extensions VALUES(NULL,NULL,'gpkg_crs_wkt','http://www.geopackage.org/spec/#extension_crs_wkt','read-write');
INSERT INTO gpkg_extensions VALUES('gpkgext_relations',NULL,'gpkg_related_tables','http://www.geopackage.org/18-000.html','read-write');
INSERT INTO gpkg_extensions VALUES('GN_NamedPlace_inspireId',NULL,'gpkg_related_tables','http://www.geopackage.org/18-000.html','read-write');
INSERT INTO gpkg_extensions VALUES('GN_NamedPlace_localType',NULL,'gpkg_related_tables','http://www.geopackage.org/18-000.html','read-write');
INSERT INTO gpkg_extensions VALUES('GN_NamedPlace_name',NULL,'gpkg_related_tables','http://www.geopackage.org/18-000.html','read-write');
INSERT INTO gpkg_extensions VALUES('GN_NamedPlace_relatedSpatialObject',NULL,'gpkg_related_tables','http://www.geopackage.org/18-000.html','read-write');
INSERT INTO gpkg_extensions VALUES('GN_NamedPlace_type',NULL,'gpkg_related_tables','http://www.geopackage.org/18-000.html','read-write');
INSERT INTO gpkg_extensions VALUES('GN_GeographicalName_spelling',NULL,'gpkg_related_tables','http://www.geopackage.org/18-000.html','read-write');
CREATE TABLE gpkg_metadata (
  id INTEGER CONSTRAINT m_pk PRIMARY KEY ASC NOT NULL,
  md_scope TEXT NOT NULL DEFAULT 'dataset',
  md_standard_uri TEXT NOT NULL,
  mime_type TEXT NOT NULL DEFAULT 'text/xml',
  metadata TEXT NOT NULL DEFAULT ''
);
INSERT INTO gpkg_metadata VALUES(1,'attribute','http://www.isotc211.org/2005/gmd','text/xml',replace('<?xml version="1.0" encoding="UTF-8"?>\012<RE_RegisterItem xmlns:gmd="http://www.isotc211.org/2005/gmd"\012                 xmlns:gco="http://www.isotc211.org/2005/gco"\012                 xmlns:xlink="http://www.w3.org/1999/xlink"\012                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\012                 xmlns="http://www.isotc211.org/2005/grg"\012                 xsi:schemaLocation="http://www.isotc211.org/2005/grg http://standards.iso.org/iso/19135/-2/reg/1.0/registration.xsd">\012   <itemIdentifier gco:nilReason="inapplicable"/>\012   <name>\012      <gco:CharacterString>Unknown</gco:CharacterString>\012   </name>\012   <status>\012      <RE_ItemStatus>valid</RE_ItemStatus>\012   </status>\012   <definition>\012      <gco:CharacterString>The correct value for the specific spatial object is not known to, and not computable by, the data provider. However, a correct value may exist.</gco:CharacterString>\012   </definition>\012   <description>\012      <gco:CharacterString>EXAMPLE When the "elevation of the water body above the sea level" of a certain lake has not been measured, then the reason for a void value of this property would be ''Unknown''.\n \nNOTE ''Unknown'' is applied on an object-by-object basis in a spatial data set.</gco:CharacterString>\012   </description>\012   <additionInformation xlink:href="http://inspire.ec.europa.eu/codelist/VoidReasonValue/Unknown"/>\012   <itemClass>\012      <RE_ItemClass>\012         <name>\012            <gco:CharacterString>CodeListValue</gco:CharacterString>\012         </name>\012         <technicalStandard gco:nilReason="inapplicable"/>\012         <alternativeNames gco:nilReason="inapplicable"/>\012         <describedItem gco:nilReason="inapplicable"/>\012      </RE_ItemClass>\012   </itemClass>\012</RE_RegisterItem>','\012',char(10)));
INSERT INTO gpkg_metadata VALUES(2,'attributeType','http://www.isotc211.org/2005/gmd','text/xml',replace('<?xml version="1.0" encoding="UTF-8"?>\012<RE_RegisterItem xmlns:gmd="http://www.isotc211.org/2005/gmd"\012                 xmlns:gco="http://www.isotc211.org/2005/gco"\012                 xmlns:xlink="http://www.w3.org/1999/xlink"\012                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\012                 xmlns="http://www.isotc211.org/2005/grg"\012                 xsi:schemaLocation="http://www.isotc211.org/2005/grg http://standards.iso.org/iso/19135/-2/reg/1.0/registration.xsd">\012   <itemIdentifier gco:nilReason="inapplicable"/>\012   <name>\012      <gco:CharacterString>Unpopulated</gco:CharacterString>\012   </name>\012   <status>\012      <RE_ItemStatus>valid</RE_ItemStatus>\012   </status>\012   <definition>\012      <gco:CharacterString>The characteristic is not part of the dataset maintained by the data provider. However, the characteristic may exist in the real world.</gco:CharacterString>\012   </definition>\012   <description>\012      <gco:CharacterString>EXAMPLE When the &amp;quot;elevation of the water body above the sea level” has not been included in a dataset containing lake spatial objects, then the reason for a void value of this property would be &amp;apos;Unpopulated’.\n \nNOTE The characteristic receives this value for all objects in the spatial data set.</gco:CharacterString>\012   </description>\012   <additionInformation xlink:href="http://inspire.ec.europa.eu/codelist/VoidReasonValue/Unpopulated"/>\012   <itemClass>\012      <RE_ItemClass>\012         <name>\012            <gco:CharacterString>CodeListValue</gco:CharacterString>\012         </name>\012         <technicalStandard gco:nilReason="inapplicable"/>\012         <alternativeNames gco:nilReason="inapplicable"/>\012         <describedItem gco:nilReason="inapplicable"/>\012      </RE_ItemClass>\012   </itemClass>\012</RE_RegisterItem>','\012',char(10)));
INSERT INTO gpkg_metadata VALUES(3,'attribute','http://www.isotc211.org/2005/gmd','text/xml',replace('<?xml version="1.0" encoding="UTF-8"?>\n<RE_RegisterItem xmlns:gmd="http://www.isotc211.org/2005/gmd"\n                 xmlns:gco="http://www.isotc211.org/2005/gco"\n                 xmlns:xlink="http://www.w3.org/1999/xlink"\n                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n                 xmlns="http://www.isotc211.org/2005/grg"\n                 xsi:schemaLocation="http://www.isotc211.org/2005/grg http://standards.iso.org/iso/19135/-2/reg/1.0/registration.xsd">\n   <itemIdentifier gco:nilReason="inapplicable"/>\n   <name>\n      <gco:CharacterString>Withheld</gco:CharacterString>\n   </name>\n   <status>\n      <RE_ItemStatus>valid</RE_ItemStatus>\n   </status>\n   <definition>\n      <gco:CharacterString>The characteristic may exist, but is confidential and not divulged by the data provider.</gco:CharacterString>\n   </definition>\n   <description gco:nilReason="missing"/>\n   <additionInformation xlink:href="http://inspire.ec.europa.eu/codelist/VoidReasonValue/Withheld"/>\n   <itemClass>\n      <RE_ItemClass>\n         <name>\n            <gco:CharacterString>CodeListValue</gco:CharacterString>\n         </name>\n         <technicalStandard gco:nilReason="inapplicable"/>\n         <alternativeNames gco:nilReason="inapplicable"/>\n         <describedItem gco:nilReason="inapplicable"/>\n      </RE_ItemClass>\n   </itemClass>\n</RE_RegisterItem>','\n',char(10)));
INSERT INTO gpkg_metadata VALUES(4,'attributeType','http://www.isotc211.org/2005/gmd','text/xml',replace('<?xml version="1.0" encoding="UTF-8"?>\n<RE_RegisterItem xmlns:gmd="http://www.isotc211.org/2005/gmd"\n                 xmlns:gco="http://www.isotc211.org/2005/gco"\n                 xmlns:xlink="http://www.w3.org/1999/xlink"\n                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n                 xmlns="http://www.isotc211.org/2005/grg"\n                 xsi:schemaLocation="http://www.isotc211.org/2005/grg http://standards.iso.org/iso/19135/-2/reg/1.0/registration.xsd">\n   <itemIdentifier gco:nilReason="inapplicable"/>\n   <name>\n      <gco:CharacterString>Withheld</gco:CharacterString>\n   </name>\n   <status>\n      <RE_ItemStatus>valid</RE_ItemStatus>\n   </status>\n   <definition>\n      <gco:CharacterString>The characteristic may exist, but is confidential and not divulged by the data provider.</gco:CharacterString>\n   </definition>\n   <description gco:nilReason="missing"/>\n   <additionInformation xlink:href="http://inspire.ec.europa.eu/codelist/VoidReasonValue/Withheld"/>\n   <itemClass>\n      <RE_ItemClass>\n         <name>\n            <gco:CharacterString>CodeListValue</gco:CharacterString>\n         </name>\n         <technicalStandard gco:nilReason="inapplicable"/>\n         <alternativeNames gco:nilReason="inapplicable"/>\n         <describedItem gco:nilReason="inapplicable"/>\n      </RE_ItemClass>\n   </itemClass>\n</RE_RegisterItem>','\n',char(10)));
CREATE TABLE gpkg_metadata_reference (
  reference_scope TEXT NOT NULL,
  table_name TEXT,
  column_name TEXT,
  row_id_value INTEGER,
  timestamp DATETIME NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  md_file_id INTEGER NOT NULL,
  md_parent_id INTEGER,
  CONSTRAINT crmr_mfi_fk FOREIGN KEY (md_file_id) REFERENCES gpkg_metadata(id),
  CONSTRAINT crmr_mpi_fk FOREIGN KEY (md_parent_id) REFERENCES gpkg_metadata(id)
);
CREATE TABLE gpkg_data_columns (
  table_name TEXT NOT NULL,
  column_name TEXT NOT NULL,
  name TEXT,
  title TEXT,
  description TEXT,
  mime_type TEXT,
  constraint_name TEXT,
  CONSTRAINT pk_gdc PRIMARY KEY (table_name, column_name),
  CONSTRAINT gdc_tn UNIQUE (table_name, name)
);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','beginLifespanVersion','beginLifespanVersion',NULL,'Date and time at which this version of the spatial object was inserted or changed in the spatial data set.',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','endLifespanVersion','endLifespanVersion',NULL,'Date and time at which this version of the spatial object was superseded or retired in the spatial data set.',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','geometry','geometry',NULL,replace('Geometry associated to the named place. This data specification does not restrict the geometry types.\n\nNOTE 1 The most common geometry types for a named place are a reference point (modelled as GM_Point), a more precise geometry of the footprint (typically modelled as GM_Curve or GM_Surface), or a bounding box (to be modelled as a GM_Surface).\n\nNOTE 2 If the geometry depicts the spatial footprint of the named place, a reference point and a bounding box could be derived from it. However, this specification does not require the explicit provision of any specific type of geometry such as bounding boxes or reference points.\n\nNOTE 3 To avoid any misunderstanding, note that null geometry is not allowed by this specification.\n\nNOTE 4 3D geometries are not really required for Geographical Names, but the model allows for it, so a data provider may publish it.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','leastDetailedViewingResolution_equivalentScale_denominator','leastDetailedViewingResolution_equivalentScale_denominator',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','leastDetailedViewingResolution_distance','leastDetailedViewingResolution_distance',NULL,replace('Resolution, expressed as the inverse of an indicative scale or a ground distance, above which the named place and its associated name(s) should no longer be displayed in a basic viewing service.\n\nNOTE 1This information may be used to determine if the names of the named place should be displayed at a given scale of display, only in the context of basic viewing services intending to show the content of the data set containing names. Even if this information is a valuable one for mapping in general, it is only approximate; cartographic services intending to produce high quality maps should certainly rely on other criteria and techniques for selecting names for the map.\n\nNOTE 2 Even if this attribute is "voidable" for practical reasons linked to its availability in data sources, this information may be of first importance for viewing services. There are great chances that viewing services will inefficiently manage named places having this attribute void.\n\nEXAMPLES The following examples use the equivalentScale attribute of MD_Resolution to express the attribute value.\n\n- Names of important cities in Europe may be displayed at all viewing scales greater than 1/5,000,000. In this case, the value of the attribute is 5,000,000\n\n- Names of small hamlets may only be displayed from all viewing scale greater than 1/25,000. In this case, the value of the attribute is 25,000\n\n- Names of countries may be displayed at any small scale. In this case, this attribute is not filled.\n\nNOTE 3 If the data set contain multiple representations of the same real world entity represented at different levels of detail, the scale ranges defined by the attributes leastDetailedViewingResolution and mostDetailedViewingResolution should not overlap, in order to avoid displaying the same names several times.\n\nNOTE 4 The geometry of the named place should have a level of detail (i.e. resolution, granularity, precision, etc.) roughly compatible with its associated viewing scales.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','mostDetailedViewingResolution_equivalentScale_denominator','mostDetailedViewingResolution_equivalentScale_denominator',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','mostDetailedViewingResolution_distance','mostDetailedViewingResolution_distance',NULL,replace('Resolution, expressed as the inverse of an indicative scale or a ground distance, below which the named place and its associated name(s) should no longer be displayed in a basic viewing service.\n\nNOTE See Description of leastDetailedViewingResolution\n\nEXAMPLES The following examples use the equivalentScale attribute of MD_Resolution to express the attribute value.\n\n- Names of wide areas like mountain ranges may not be displayed at all in viewing scales greater than 1/100,000. In this case, the value of the attribute is 100,000\n\n- Names of small hamlets may be displayed at any large scale. In this case, this attribute is not filled.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','leastDetailedViewingResolution_distance_uom','leastDetailedViewingResolution_distance_uom',NULL,replace('Resolution, expressed as the inverse of an indicative scale or a ground distance, above which the named place and its associated name(s) should no longer be displayed in a basic viewing service.\n\nNOTE 1This information may be used to determine if the names of the named place should be displayed at a given scale of display, only in the context of basic viewing services intending to show the content of the data set containing names. Even if this information is a valuable one for mapping in general, it is only approximate; cartographic services intending to produce high quality maps should certainly rely on other criteria and techniques for selecting names for the map.\n\nNOTE 2 Even if this attribute is "voidable" for practical reasons linked to its availability in data sources, this information may be of first importance for viewing services. There are great chances that viewing services will inefficiently manage named places having this attribute void.\n\nEXAMPLES The following examples use the equivalentScale attribute of MD_Resolution to express the attribute value.\n\n- Names of important cities in Europe may be displayed at all viewing scales greater than 1/5,000,000. In this case, the value of the attribute is 5,000,000\n\n- Names of small hamlets may only be displayed from all viewing scale greater than 1/25,000. In this case, the value of the attribute is 25,000\n\n- Names of countries may be displayed at any small scale. In this case, this attribute is not filled.\n\nNOTE 3 If the data set contain multiple representations of the same real world entity represented at different levels of detail, the scale ranges defined by the attributes leastDetailedViewingResolution and mostDetailedViewingResolution should not overlap, in order to avoid displaying the same names several times.\n\nNOTE 4 The geometry of the named place should have a level of detail (i.e. resolution, granularity, precision, etc.) roughly compatible with its associated viewing scales.','\n',char(10)),NULL,'gml_uomidentifier');
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','mostDetailedViewingResolution_distance_uom','mostDetailedViewingResolution_distance_uom',NULL,replace('Resolution, expressed as the inverse of an indicative scale or a ground distance, below which the named place and its associated name(s) should no longer be displayed in a basic viewing service.\n\nNOTE See Description of leastDetailedViewingResolution\n\nEXAMPLES The following examples use the equivalentScale attribute of MD_Resolution to express the attribute value.\n\n- Names of wide areas like mountain ranges may not be displayed at all in viewing scales greater than 1/100,000. In this case, the value of the attribute is 100,000\n\n- Names of small hamlets may be displayed at any large scale. In this case, this attribute is not filled.','\n',char(10)),NULL,'gml_uomidentifier');
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','inspireId','inspireId',NULL,replace('External object identifier of the spatial object.\n\nNOTE An external object identifier is a unique object identifier published by the responsible body, which may be used by external applications to reference the spatial object. The identifier is an identifier of the spatial object, not an identifier of the real-world phenomenon.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_PronunciationOfName','pronunciationSoundLink','pronunciationSoundLink',NULL,replace('Proper, correct or standard (standard within the linguistic community concerned) pronunciation of a name, expressed by a link to any sound file.\n\nSOURCE Adapted from [UNGEGN Manual 2006].','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_PronunciationOfName','pronunciationIPA','pronunciationIPA',NULL,replace('Proper, correct or standard (standard within the linguistic community concerned) pronunciation of a name, expressed in International Phonetic Alphabet (IPA).\n\nSOURCE Adapted from [UNGEGN Manual 2006].','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_PronunciationOfName','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_SpellingOfName','text','text',NULL,'Way the name is written.',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_SpellingOfName','script','script',NULL,replace('Set of graphic symbols (for example an alphabet) employed in writing the name, expressed using the four letters codes defined in ISO 15924, where applicable.\n\nSOURCE Adapted from [UNGEGN Glossary 2007].\n\nEXAMPLES Cyrillic, Greek, Roman/Latin scripts.\n\nNOTE 1The four letter codes for Latin (Roman), Cyrillic and Greek script are "Latn", "Cyrl" and "Grek", respectively.\n\nNOTE 2 In rare cases other codes could be used (for other scripts than Latin, Greek and Cyrillic). However, this should mainly apply for historical names in historical scripts.\n\nNOTE 3 This attribute is of first importance in the multi-scriptual context of Europe.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_SpellingOfName','transliterationScheme','transliterationScheme',NULL,replace('Method used for the names conversion between different scripts.\n\nSOURCE Adapted from [UNGEGN Glossary 2007].\n\nNOTE 1 This attribute should be filled for any transliterated spellings. If the transliteration scheme used is recorded in codelists maintained by ISO or UN, those codes should be preferred.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_SpellingOfName','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName','language','language',NULL,replace('Language of the name, given as a three letters code, in accordance with either ISO 639-3 or ISO 639-5.\n\nNOTE 1More precisely, this definition refers to the language used by the community that uses the name.\n\nNOTE 2 The code "mul" for "multilingual" should not be used in general. However it can be used in rare cases like official names composed of two names in different languages. For example, "Vitoria-Gasteiz" is such a multilingual official name in Spain.\n\nNOTE 3 Even if this attribute is "voidable" for pragmatic reasons, it is of first importance in several use cases in the multi-language context of Europe.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName','nativeness','nativeness',NULL,'Information enabling to acknowledge if the name is the one that is/was used in the area where the spatial object is situated at the instant when the name is/was in use.',NULL,'gn_nativenessvalue');
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName','nameStatus','nameStatus',NULL,replace('Qualitative information enabling to discern which credit should be given to the name with respect to its standardisation and/or its topicality.\n\nNOTE The Geographical Names application schema does not explicitly make a preference between different names (e.g. official endonyms) of a specific real world entity. The necessary information for making the preference (e.g. the linguistic status of the administrative or geographic area in question), for a certain use case, must be obtained from other data or information sources. For example, the status of the language of the name may be known through queries on the geometries of named places against the geometry of administrative units recorded in a certain source with the language statuses information.','\n',char(10)),NULL,'gn_namestatusvalue');
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName','sourceOfName','sourceOfName',NULL,replace('Original data source from which the geographical name is taken from and integrated in the data set providing/publishing it. For some named spatial objects it might refer again to the publishing data set if no other information is available.\n\nEXAMPLES Gazetteer, geographical names data set.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName','pronunciation_pronunciationSoundLink','pronunciation_pronunciationSoundLink',NULL,replace('Proper, correct or standard (standard within the linguistic community concerned) pronunciation of a name, expressed by a link to any sound file.\n\nSOURCE Adapted from [UNGEGN Manual 2006].','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName','pronunciation_pronunciationIPA','pronunciation_pronunciationIPA',NULL,replace('Proper, correct or standard (standard within the linguistic community concerned) pronunciation of a name, expressed in International Phonetic Alphabet (IPA).\n\nSOURCE Adapted from [UNGEGN Manual 2006].','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName','grammaticalGender','grammaticalGender',NULL,replace('Class of nouns reflected in the behaviour of associated words.\n\nNOTE the attribute has cardinality [0..1] and is voidable, which means that:\n\n<ul>\n\n<li>in case the concept of grammatical gender has no sense for a given name (i.e. the attribute is not applicable), the attribute should not be provided.</li>\n\n<li>in case the concept of grammatical gender has some sense for the name but is unknown, the attribute should be provided but <i>void</i>.  </li>\n\n</ul>','\n',char(10)),NULL,'gn_grammaticalgendervalue');
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName','grammaticalNumber','grammaticalNumber',NULL,replace('Grammatical category of nouns that expresses count distinctions.\n\nNOTE the attribute has cardinality [0..1] and is voidable, which means that:\n\n<ul>\n\n<li>in case the concept of grammatical number has no sense for a given name (i.e. the attribute is not applicable), the attribute should not be provided.</li>\n\n<li>in case the concept of grammatical number has some sense for the name but is unknown, the attribute should be provided but <i>void</i>.</li>\n\n</ul>','\n',char(10)),NULL,'gn_grammaticalnumbervalue');
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlaceTypeValue','value','value',NULL,NULL,NULL,'gn_namedplacetypevalue');
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlaceTypeValue','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('BASE_Identifier','localId','localId',NULL,replace('A local identifier, assigned by the data provider. The local identifier is unique within the namespace, that is no other spatial object carries the same unique identifier.\n\nNOTE It is the responsibility of the data provider to guarantee uniqueness of the local identifier within the namespace.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('BASE_Identifier','namespace','namespace',NULL,replace('Namespace uniquely identifying the data source of the spatial object.\n\nNOTE The namespace value will be owned by the data provider of the spatial object and will be registered in the INSPIRE External Object Identifier Namespaces Register.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('BASE_Identifier','versionId','versionId',NULL,replace('The identifier of the particular version of the spatial object, with a maximum length of 25 characters. If the specification of a spatial object type with an external object identifier includes life-cycle information, the version identifier is used to distinguish between the different versions of a spatial object. Within the set of all versions of a spatial object, the version identifier is unique.\n\nNOTE The maximum length has been selected to allow for time stamps based on ISO 8601, for example, "2007-02-12T12:12:12+05:30" as the version identifier.\n\nNOTE 2 The property is void, if the spatial data set does not distinguish between different versions of the spatial object. It is missing, if the spatial object type does not support any life-cycle information.','\n',char(10)),NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('BASE_Identifier','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GMD_LocalisedCharacterString','text','text',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GMD_LocalisedCharacterString','languageCode','languageCode',NULL,NULL,NULL,'gmd_languagecode');
INSERT INTO gpkg_data_columns VALUES('GMD_LocalisedCharacterString','country','country',NULL,NULL,NULL,'gmd_countrycode');
INSERT INTO gpkg_data_columns VALUES('GMD_LocalisedCharacterString','characterSetCode','characterSetCode',NULL,NULL,NULL,'gmd_md_charactersetcode');
INSERT INTO gpkg_data_columns VALUES('GMD_LocalisedCharacterString','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_localType','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_localType','base_id','base_id',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_localType','related_id','related_id',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_name','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_name','base_id','base_id',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_name','related_id','related_id',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_relatedSpatialObject','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_relatedSpatialObject','base_id','base_id',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_relatedSpatialObject','related_id','related_id',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_type','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_type','base_id','base_id',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_NamedPlace_type','related_id','related_id',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName_spelling','id','id','Id','Id',NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName_spelling','base_id','base_id',NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_columns VALUES('GN_GeographicalName_spelling','related_id','related_id',NULL,NULL,NULL,NULL);
CREATE TABLE gpkg_data_column_constraints (
  constraint_name TEXT NOT NULL,
  constraint_type TEXT NOT NULL, /* 'range' | 'enum' | 'glob' */
  value TEXT,
  min NUMERIC,
  min_is_inclusive BOOLEAN, /* 0 = false, 1 = true */
  max NUMERIC,
  max_is_inclusive BOOLEAN, /* 0 = false, 1 = true */
  description TEXT,
  CONSTRAINT gdcc_ntv UNIQUE (constraint_name, constraint_type, value)
);
INSERT INTO gpkg_data_column_constraints VALUES('gn_grammaticalnumbervalue','enum','singular',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/GrammaticalNumberValue/singular');
INSERT INTO gpkg_data_column_constraints VALUES('gn_grammaticalnumbervalue','enum','plural',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/GrammaticalNumberValue/plural');
INSERT INTO gpkg_data_column_constraints VALUES('gn_grammaticalnumbervalue','enum','dual',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/GrammaticalNumberValue/dual');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namestatusvalue','enum','official',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NameStatusValue/official');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namestatusvalue','enum','standardised',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NameStatusValue/standardised');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namestatusvalue','enum','historical',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NameStatusValue/historical');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namestatusvalue','enum','other',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NameStatusValue/other');
INSERT INTO gpkg_data_column_constraints VALUES('gn_nativenessvalue','enum','endonym',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NativenessValue/endonym');
INSERT INTO gpkg_data_column_constraints VALUES('gn_nativenessvalue','enum','exonym',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NativenessValue/exonym');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namedplacetypevalue','enum','administrativeUnit',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NamedPlaceTypeValue/administrativeUnit');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namedplacetypevalue','enum','building',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NamedPlaceTypeValue/building');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namedplacetypevalue','enum','hydrography',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NamedPlaceTypeValue/hydrography');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namedplacetypevalue','enum','landcover',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NamedPlaceTypeValue/landcover');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namedplacetypevalue','enum','landform',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NamedPlaceTypeValue/landform');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namedplacetypevalue','enum','populatedPlace',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NamedPlaceTypeValue/populatedPlace');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namedplacetypevalue','enum','protectedSite',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NamedPlaceTypeValue/protectedSite');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namedplacetypevalue','enum','transportNetwork',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NamedPlaceTypeValue/transportNetwork');
INSERT INTO gpkg_data_column_constraints VALUES('gn_namedplacetypevalue','enum','other',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/NamedPlaceTypeValue/other');
INSERT INTO gpkg_data_column_constraints VALUES('gn_grammaticalgendervalue','enum','masculine',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/GrammaticalGenderValue/masculine');
INSERT INTO gpkg_data_column_constraints VALUES('gn_grammaticalgendervalue','enum','feminine',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/GrammaticalGenderValue/feminine');
INSERT INTO gpkg_data_column_constraints VALUES('gn_grammaticalgendervalue','enum','neuter',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/GrammaticalGenderValue/neuter');
INSERT INTO gpkg_data_column_constraints VALUES('gn_grammaticalgendervalue','enum','common',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/GrammaticalGenderValue/common');
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Afrikaans',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Albanian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Arabic',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Basque',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Belarusian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Bulgarian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Catalan',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Chinese',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Croatian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Czech',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Danish',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Dutch',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','English',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Estonian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Faeroese',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','French',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','French(Canadian)',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/LanguageCode/French(Canadian)');
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Finnish',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','German',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Greek',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Hawaian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Hebrew',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Hungarian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Icelandic',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Indonesian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Italian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Japanese',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Korean',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Latvian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Lithuanian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Malaysian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Norwegian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Polish',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Portuguese',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Romanian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Russian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Serbian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Slovak',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Slovenian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Spanish',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Swahili',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Swedish',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Turkish',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_languagecode','enum','Ukranian',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','ucs2',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','ucs4',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','utf7',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','utf8',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','utf16',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part1',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part2',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part3',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part4',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part5',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part6',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part7',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part8',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part9',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part10',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part11',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','(reservedforfutureuse)',NULL,NULL,NULL,NULL,'http://inspire.ec.europa.eu/codelist/MD_CharacterSetCode/(reservedforfutureuse)');
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part13',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part14',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part15',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','8859part16',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','jis',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','shiftJIS',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','eucJP',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','usAscii',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','ebcdic',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','eucKR',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','big5',NULL,NULL,NULL,NULL,NULL);
INSERT INTO gpkg_data_column_constraints VALUES('gmd_md_charactersetcode','enum','GB2312',NULL,NULL,NULL,NULL,NULL);
CREATE TABLE gpkg_geometry_columns (
  table_name TEXT NOT NULL,
  column_name TEXT NOT NULL,
  geometry_type_name TEXT NOT NULL,
  srs_id INTEGER NOT NULL,
  z TINYINT NOT NULL,
  m TINYINT NOT NULL,
  CONSTRAINT pk_geom_cols PRIMARY KEY (table_name, column_name),
  CONSTRAINT uk_gc_table_name UNIQUE (table_name),
  CONSTRAINT fk_gc_tn FOREIGN KEY (table_name) REFERENCES gpkg_contents(table_name),
  CONSTRAINT fk_gc_srs FOREIGN KEY (srs_id) REFERENCES gpkg_spatial_ref_sys (srs_id)
);
INSERT INTO gpkg_geometry_columns VALUES('GN_NamedPlace','geometry','GEOMETRY',0,2,2);
CREATE TABLE IF NOT EXISTS "GN_NamedPlace" (
  "beginLifespanVersion" DATETIME,
  "endLifespanVersion" DATETIME,
  "geometry" GEOMETRY NOT NULL,
  "leastDetailedViewingResolution_equivalentScale_denominator" INTEGER,
  "leastDetailedViewingResolution_distance" TEXT,
  "mostDetailedViewingResolution_equivalentScale_denominator" INTEGER,
  "mostDetailedViewingResolution_distance" TEXT,
  "leastDetailedViewingResolution_distance_uom" TEXT,
  "mostDetailedViewingResolution_distance_uom" TEXT,
  "inspireId" INTEGER,
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);
CREATE TABLE IF NOT EXISTS "GN_PronunciationOfName" (
  "pronunciationSoundLink" TEXT,
  "pronunciationIPA" TEXT,
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);
CREATE TABLE IF NOT EXISTS "GN_SpellingOfName" (
  "text" TEXT NOT NULL,
  "script" TEXT,
  "transliterationScheme" TEXT,
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);
CREATE TABLE IF NOT EXISTS "GN_GeographicalName" (
  "language" TEXT,
  "nativeness" TEXT,
  "nameStatus" TEXT,
  "sourceOfName" TEXT,
  "pronunciation_pronunciationSoundLink" TEXT,
  "pronunciation_pronunciationIPA" TEXT,
  "grammaticalGender" TEXT,
  "grammaticalNumber" TEXT,
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);
CREATE TABLE IF NOT EXISTS "GN_NamedPlaceTypeValue" (
  "value" TEXT NOT NULL,
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);
CREATE TABLE IF NOT EXISTS "BASE_Identifier" (
  "localId" TEXT NOT NULL,
  "namespace" TEXT NOT NULL,
  "versionId" TEXT,
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);
CREATE TABLE IF NOT EXISTS "GMD_LocalisedCharacterString" (
  "text" TEXT NOT NULL,
  "languageCode" TEXT NOT NULL,
  "country" TEXT,
  "characterSetCode" TEXT,
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);
CREATE TABLE IF NOT EXISTS 'gpkgext_relations' (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  base_table_name TEXT NOT NULL,
  base_primary_column TEXT NOT NULL DEFAULT 'id',
  related_table_name TEXT NOT NULL,
  related_primary_column TEXT NOT NULL DEFAULT 'id',
  relation_name TEXT NOT NULL,
  mapping_table_name TEXT NOT NULL UNIQUE
 );
INSERT INTO gpkgext_relations VALUES(1,'GN_NamedPlace','id','BASE_Identifier','id','ATTRIBUTES','GN_NamedPlace_inspireId');
INSERT INTO gpkgext_relations VALUES(2,'GN_NamedPlace','id','GMD_LocalisedCharacterString','id','ATTRIBUTES','GN_NamedPlace_localType');
INSERT INTO gpkgext_relations VALUES(3,'GN_NamedPlace','id','GN_GeographicalName','id','ATTRIBUTES','GN_NamedPlace_name');
INSERT INTO gpkgext_relations VALUES(4,'GN_NamedPlace','id','BASE_Identifier','id','ATTRIBUTES','GN_NamedPlace_relatedSpatialObject');
INSERT INTO gpkgext_relations VALUES(5,'GN_NamedPlace','id','GN_NamedPlaceTypeValue','id','ATTRIBUTES','GN_NamedPlace_type');
INSERT INTO gpkgext_relations VALUES(6,'GN_GeographicalName','id','GN_SpellingOfName','id','ATTRIBUTES','GN_GeographicalName_spelling');
CREATE TABLE IF NOT EXISTS "GN_NamedPlace_localType" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "base_id" INTEGER NOT NULL,
  "related_id" INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS "GN_NamedPlace_name" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "base_id" INTEGER NOT NULL,
  "related_id" INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS "GN_NamedPlace_relatedSpatialObject" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "base_id" INTEGER NOT NULL,
  "related_id" INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS "GN_NamedPlace_type" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "base_id" INTEGER NOT NULL,
  "related_id" INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS "GN_GeographicalName_spelling" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "base_id" INTEGER NOT NULL,
  "related_id" INTEGER NOT NULL
);
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('gpkgext_relations',6);
CREATE VIEW st_spatial_ref_sys AS
  SELECT
    srs_name,
    srs_id,
    organization,
    organization_coordsys_id,
    definition,
    description
  FROM gpkg_spatial_ref_sys;
CREATE VIEW spatial_ref_sys AS
  SELECT
    srs_id AS srid,
    organization AS auth_name,
    organization_coordsys_id AS auth_srid,
    definition AS srtext
  FROM gpkg_spatial_ref_sys;
CREATE VIEW st_geometry_columns AS
  SELECT
    table_name,
    column_name,
    "ST_" || geometry_type_name AS geometry_type_name,
    g.srs_id,
    srs_name
  FROM gpkg_geometry_columns as g JOIN gpkg_spatial_ref_sys AS s
  WHERE g.srs_id = s.srs_id;
CREATE VIEW geometry_columns AS
  SELECT
    table_name AS f_table_name,
    column_name AS f_geometry_column,
    (CASE geometry_type_name 
    	WHEN 'GEOMETRY' THEN 0 
    	WHEN 'POINT' THEN 1 
    	WHEN 'LINESTRING' THEN 2 
    	WHEN 'POLYGON' THEN 3 
    	WHEN 'MULTIPOINT' THEN 4 
    	WHEN 'MULTILINESTRING' THEN 5 
    	WHEN 'MULTIPOLYGON' THEN 6 
    	WHEN 'GEOMETRYCOLLECTION' THEN 7 
    	WHEN 'CIRCULARSTRING' THEN 8 
    	WHEN 'COMPOUNDCURVE' THEN 9 
    	WHEN 'CURVEPOLYGON' THEN 10 
    	WHEN 'MULTICURVE' THEN 11 
    	WHEN 'MULTISURFACE' THEN 12 
    	WHEN 'CURVE' THEN 13 
    	WHEN 'SURFACE' THEN 14 
    	WHEN 'POLYHEDRALSURFACE' THEN 15 
    	WHEN 'TIN' THEN 16 
    	WHEN 'TRIANGLE' THEN 17 
    	ELSE 0 END) AS geometry_type,
    2 + (CASE z WHEN 1 THEN 1 WHEN 2 THEN 1 ELSE 0 END) + (CASE m WHEN 1 THEN 1 WHEN 2 THEN 1 ELSE 0 END) AS coord_dimension,
    srs_id AS srid
  FROM gpkg_geometry_columns;
CREATE VIEW 'GN_NamedPlace_inspireId' (base_id, related_id) AS 
SELECT id, inspireId FROM GN_NamedPlace
WHERE inspireId IS NOT NULL;
COMMIT;

