# INSPIRE UML-to-GeoPackage encoding rule <!-- omit in toc -->

**Note:** This encoding rule is a work in progress.

## Table of Contents <!-- omit in toc -->

- [Preface](#preface)
- [Introduction](#introduction)
- [Scope](#scope)
  - [Use Cases](#use-cases)
  - [Coverage of INSPIRE Themes](#coverage-of-inspire-themes)
  - [Technical Issues](#technical-issues)
  - [Technical Requirements](#technical-requirements)
  - [Technical Limitations](#technical-limitations)
  - [Cross-cutting INSPIRE Requirements for Encoding Rules](#cross-cutting-inspire-requirements-for-encoding-rules)
- [Normative References](#normative-references)
- [Terms and Definitions](#terms-and-definitions)
- [Compliance Encoding Rule](#compliance-encoding-rule)
  - [Schema Conversion Rule](#schema-conversion-rule)
    - [Types](#types)
      - [Feature types](#feature-types)
      - [Data Types](#data-types)
      - [ISO 19103](#iso-19103)
        - [Basic types](#basic-types)
        - [Properties with a uom attribute](#properties-with-a-uom-attribute)
      - [ISO 19107 - Geometry types](#iso-19107---geometry-types)
      - [ISO 19108 - Temporal types](#iso-19108---temporal-types)
      - [ISO 19115 - Metadata types](#iso-19115---metadata-types)
      - [ISO 19139 - Metadata XML implementation types](#iso-19139---metadata-xml-implementation-types)
      - [Flattening types](#flattening-types)
      - [Abstract Types as property types](#abstract-types-as-property-types)
      - [Union Types](#union-types)
      - [Enumerations](#enumerations)
      - [Code Lists](#code-lists)
      - [Voidable](#voidable)
    - [Properties](#properties)
      - [Arrays](#arrays)
    - [Association Roles](#association-roles)
    - [Naming modification](#naming-modification)
  - [Dataset Encoding Rule](#dataset-encoding-rule)
    - [Character Encoding](#character-encoding)
    - [Coordinate Reference Systems](#coordinate-reference-systems)
    - [Void values information](#void-values-information)
- [Flattened Dataset Encoding Rule](#flattened-dataset-encoding-rule)
  - [Unpopulated Features](#unpopulated-features)
  - [Unpopulated Many-to-many Relations](#unpopulated-many-to-many-relations)
  - [Unpopulated Columns](#unpopulated-columns)
  - [Implicit One-to-one Relations to Data Types](#implicit-one-to-one-relations-to-data-types)

## Preface

This document is based on an outcome of *[Action 2017.2](https://webgate.ec.europa.eu/fpfis/wikis/display/InspireMIG/Action+2017.2+on+alternative+encodings+for+INSPIRE+data) on alternative encodings for INSPIRE data*.
Specifically, it is based on [the initial template](https://github.com/INSPIRE-MIF/2017.2/blob/master/template/template.md) for proposing new encodings and the ongoing work in the [INSPIRE UML-to-GeoJSON encoding rule](https://github.com/INSPIRE-MIF/2017.2/blob/master/GeoJSON/geojson-encoding-rule.md).

## Introduction

A **GeoPackage** is an open, standards-based, platform-independent, portable, self-describing, compact format for transferring geospatial information within a a [SQLite](https://www.sqlite.org/) database.
The [GeoPackage Encoding Standard](https://www.opengeospatial.org/standards/geopackage) describes a set of conventions for storing the following within a [SQLite](https://www.sqlite.org/) database:

- vector features
- tile matrix sets of imagery and raster maps at various scales
- attributes (non-spatial data)
- extensions
  
The *GeoPackage Encoding Standard* has been developed by the Open Geospatial Consortium.
The current version is [1.2.1](https://www.geopackage.org/spec121/) (2018-09-06).
The *GeoPackage Encoding Standard* standard defines the schema for a GeoPackage, including table definitions, integrity assertions, format limitations, and content constraints.
The required and supported content of a GeoPackage is entirely defined in the standard.
These capabilities are built on a common base and the extension mechanism provides implementers a way to include additional functionality in their GeoPackages.

Since a GeoPackage is a database container, it supports direct use.
This means that the data in a GeoPackage can be accessed and updated in a *native* storage format without intermediate format translations.
GeoPackages that comply with the requirements in the standard and do not implement vendor-specific extensions are interoperable across all enterprise and personal computing environments.

Within INSPIRE, this encoding rule can be used to encode large datasets from several, complex themes without information loss in a single, portable file.
Any tool able to access to SQLite database can access and update attribute data within a GeoPackage.
ArcGIS, QGIS, FME, GeoTools are desktop and server tools that implement the GeoPackage Encoding Standard and provide access to GeoPackages.
GDAL (C/C++/Python) and NGA GeoPackage Libraries (Java/Objective-C/JavaScript) and SDK (Android/iOS/Web) can be used for storing and access data from GeoPackages in Destop, server and mobile environments.

## Scope

This sections describes the scope of the INSPIRE UML-to-GeoPackage encoding rule.

This encoding rule has two parts:

- The **Compliance encoding rule**, intended for INSPIRE compliance.
- The **Flattened Dataset encoding rule**, intended for data usability.

The **Compliance encoding rule** can be used for:

- Creating a GeoPackage file with a INSPIRE schema for being used as template for implementers ([Schema Conversion Rule](#schema-conversion-rule)).
- Encoding a dataset in a GeoPackage file using such template ([Dataset Encoding Rule](#dataset-encoding-rule)).

The **Flattened Dataset encoding rule** can be used for flattening a dataset encoded with the **Compliance encoding rule** without loss of relevant information.

### Use Cases

The **Compliance encoding rule** specifically addresses INSPIRE compliance.
This rule intended to ease INSPIRE data compliance checking procedures.

The **Flattened Dataset encoding rule** specifically addresses data usability in desktop client software, such as ArcMap and QGIS.
This rule optimizes usage of a INSPIRE dataset for mapping and geoprocessing in such applications.

### Coverage of INSPIRE Themes

For each theme to be covered, a specific **GeoPackage Encoding Rule** and an empty **GeoPackage template** is provided.
The *GeoPackage template* is a *GeoPackage* instantiated with the schema for a specific INSPIRE theme.

These can reside in subfolders in the same repository as this general encoding rule, but can also be maintained in other places.

### Technical Issues

This encoding rule addresses specific technical issues that have been problematic when using the default encoding:

- Most GIS software cannot fully make use of non-simple attributes and nested structures for styling, processing and filtering;
- Multiple values per (complex) properties cannot be used fully in ArcGIS and other GIS tools;
- References to other features often cannot be resolved by GIS tools; Propertes of referenced features cannot be used in styling or for filtering;
- Abstract geometry types for an object mean that a wide range of different geometries can be used for any single feature class;
- Mixed geometry types in a FeatureCollection are usually not supported.

### Technical Requirements

The encoding uses the [OGC® GeoPackage Encoding Standard - with Corrigendum version 1.2.1](https://www.geopackage.org/spec121/) with the following extensions:

- [GeoPackage Non-Linear Geometry Types](http://www.geopackage.org/spec121/#extension_geometry_types)
- [Metadata](http://www.geopackage.org/spec121/#extension_metadata)
- [Schema](http://www.geopackage.org/spec121/#extension_schema)
- [Related Tables Extension](http://docs.opengeospatial.org/is/18-000/18-000.html)
- [WKT for Coordinate Refernece Systems](http://www.geopackage.org/spec121/#extension_crs_wkt)

### Technical Limitations

There are not extensions for 3D geometries.
Raster ([native, as tile matrix](https://www.geopackage.org/spec121/#tiles)) and coverage ([extension](http://docs.opengeospatial.org/is/17-066r1/17-066r1.html)) data support has not been tested yet.

### Cross-cutting INSPIRE Requirements for Encoding Rules

The Implementing Rules on interoperability of spatial data sets and services (Commission Regulation (EU) No 1089/2010) lays down the following requirements for encoding rules:

> **Article 7 -- Encoding**
>
> 1. Every encoding rule used to encode spatial data shall conform to EN ISO 19118.
> In particular, it shall specify schema conversion rules for all spatial object types and all attributes and association roles and the output data structure used.
> 2. Every encoding rule used to encode spatial data shall be made available.

D2.7 specifies more detailed requirements and recommendations for encoding rules.
The following list lists the requirements from that document and shows which ones are also met in this encoding rule:

> - Requirement 12: ... documents shall be required to be encoded using UTF-8 as character encoding.

D2.7 also contains a relevant recommendation:

> - Recommendation 3: Encoding rules should be based on international, preferably open, standards.

## Normative References

This section contains references to standards documents and related resources.

- [OGC® GeoPackage Encoding Standard - with Corrigendum version 1.2.1](https://www.geopackage.org/spec121/)
- [OGC GeoPackge Related Tables Extension](http://docs.opengeospatial.org/is/18-000/18-000.html)
- [INSPIRE Drafting Team Data Specifications. D2.7: Guidelines for the encoding of spatial data, Version 3.3](http://inspire.ec.europa.eu/documents/guidelines-encoding-spatial-data)

## Terms and Definitions

Terms and Definitions can be found in the [Glossary](https://github.com/INSPIRE-MIF/2017.2/blob/master/glossary.md) document.

## Compliance Encoding Rule

### Schema Conversion Rule

INSPIRE defines the conceptual model using UML.

The default encoding rule maps this UML model to XML Schema.

For GeoPackage, SQL queries to GeoPackage metadata tables (e.g. `gpkg_contents`, `gpkg_spatial_ref_sys`) can be used to perform simple validation on GeoPackages.  

Theme-specific GeoPackage Encoding Rules may provide a formal definition of the encoded data structures as normative SQL statements and abstract test suites.
Executable test suites will use these to test the correctness of data elements (tables, columns, or values) and SQL constructs (views, constraints, or triggers).

In this encoding rule, we take a two-step approach, where we apply model transformations on the level of the conceptual model to transform INSPIRE constructs into conceptual GeoPackage constructs, and then we materialize these into a *GeoPackage template* per theme.

#### Types

##### Feature types

The conversion rules of types that have the `<<featureType>>` sterotype are as follows:

- If the type has only one geometry type property, the geometry type can be mapped to a GeoPackage geometry type, and the property a has maximum multiplicity of `1`  (for example `AdministrativeUnits::AdministrativeUnit`), then the type is converted to a `GeoPackage feature`. <!-- Status: implemented as `simple Feature Type stereotype to GeoPackage Feature` -->
- If the type has no geometry type properties (for example `Addresses::ThoroughfareName`), then the type is converted to a `GeoPackage attribute`. <!-- Status: implemented as `Feature Type stereotype without geometry to GeoPackage Attribute` -->
- Otherwise, the type conversion must be specified on a case-by-case basis in each theme profile.

##### Data Types
<!-- Status: implemented -->

The conversion rules of types that have the `<<dataType>>` sterotype are as follows:

- If the type has only one geometry type property, the geometry type can be mapped to a GeoPackage geometry type, and the property a has maximum multiplicity of `1`  (for example `Addresses::GeographicPosition`), then the type is converted to a `GeoPackage feature`. <!-- Status: implemented as `Data Type stereotype to GeoPackage Attribute` -->
- If the type has no geometry type properties (for example `GeographicalNames::GeographicalName`), then the type is converted to a `GeoPackage attribute`. <!-- Status: implemented as `simple feature-like Data Type stereotype to GeoPackage Feature` -->
- Otherwise, the type conversion must be specified on a case-by-case basis in each theme profile.

##### ISO 19103

###### Basic types
<!-- Status: implemented as `general rule ISO-19103 Basic Types` -->

All property types are transformed to the simple types that GeoPackage knows about.
The exact mapping from the UML model to the [GeoPackage datatypes](https://www.geopackage.org/spec121/#table_column_data_types) is outlined in the following table:

**Table: ISO 19103 to GeoPackage datatype mapping.**

| UML Model property type | GeoPackage datatype | SQLite storage class | Conversion Notes |
| ------ | ----- | ----- | ----- |
| `CharacterString` | `TEXT` | `TEXT` | Unicode [1]
| `Boolean` | `BOOLEAN` | `INTEGER` | 0 for false and 1 for true |
| `Number` | `TEXT`| `TEXT`| Abstract base type for all number [2]
| `Integer` | `INTEGER` | `INTEGER` | 64-bit signed integer  |
| `Real` | `REAL` | `REAL` | 64-bit IEEE floating point number  |
| `Decimal` | `TEXT` | `TEXT` | Number with a decimal point and/or an exponent [2] |
| `DateTime` | `DATETIME` | `TEXT` | ISO-8601 date/time in UTC strings `YYYY-MM-DDTHH:MM:SS.SSSZ` |
| `Date` | `DATE` | `TEXT` | ISO8601 date strings `YYYY-MM-DD`. |

[1] SQLite stores all text as Unicode characters encoded using either UTF-8 or UTF-16 encoding.
The SQLite API contains functions which allow passing and retrieving text using either UTF-8 or UTF-16 encoding.
These functions can be freely mixed and proper conversions are performed transparently when necessary.

[2] Implementers may use `INTEGER` or `REAL` if a dataset needs it; otherwise may apply the rules for a direct use (see [3]).

[3] *Direct use scenario*: `Decimal` values stored in SQLite as `TEXT` can be used in [SQL `CAST` expressions](https://www.sqlite.org/lang_expr.html#castexpr) to convert them into `INTEGER` and `REAL` values. If the text:

- Looks like an integer and the value is small enough to fit in a 64-bit signed integer, then the result will be `INTEGER`.
- Looks like floating point (there is a decimal point and/or an exponent) and can be losslessly converted back and forth between IEEE 754 64-bit float and a 51-bit signed integer, then the result is `INTEGER`.
- Any other case yields the closest `REAL` result.

Any UML Model property whose  `Integer` or `Real` values may overflow the limits of the respective SQLite storage class (i.e. `INTEGER`, `REAL`) should be mapped to `TEXT`, with specific rules being defined on a case-by-case basis in each theme profile.

Any other UML Model property type is to be mapped to `TEXT`, with specific rules being defined on a case-by-case basis in each theme profile.

###### Properties with a `uom` attribute
<!-- Status: uom is added as a separate property` -->

The unit of measurement attribute (`uom`) on any property `x` has to be retained.

It is transformed to a new property of the type `TEXT` with the name `x_uom`.

The syntax and value space of the new property is the same of `gml:UomIdentifier`.
The legal values of the new property are the literals of the data column constraint enum `GML_UomIdentifier`.
This restriction may be enforced by SQL triggers or by code in applications that update GeoPackage data values.


##### ISO 19107 - Geometry types
<!-- Status: implemented as `general rule ISO-19107 Geometry Types` -->

ISO 19107 defines a set of Geometry types, which need to be mapped to the types available in GeoPackage.

**Table: ISO 19107 to GeoPackage datatype mapping.**

| ISO 19107 type | GeoPackage datatype | Conversion Notes |
| ------ | ----- | ----- |
| `GM_Aggregate` | `GEOMETRYCOLLECTION` | Core model
| `GM_Curve` | `CURVE` | Non-linear geometry type extension
| `GM_LineString`| `LINESTRING` | Core model
| `GM_MultiCurve` | `MULTICURVE` | Non-linear geometry type extension
| `GM_MultiLineString` | `MULTILINESTRING` | Core model
| `GM_MultiPoint` | `MULTIPOINT` | Core model
| `GM_MultiPrimitive` | `GEOMETRYCOLLECTION` | Core model
| `GM_MultiSurface` | `MULTISURFACE` | Non-linear geometry type extension | `GM_Object` | `GEOMETRY` | Core model
| `GM_Point` | `POINT` | Core model
| `GM_Polygon` | `POLYGON` | Core model
| `GM_Primitive` | `GEOMETRY` | Core model
| `GM_Surface` | `SURFACE` | Non-linear geometry type extension
| `GM_Triangle` | `POLYGON` | Core model

**Note**: The table is not yet complete.

implementers may constraint to a non-abstract subclass of the corresponding GeoPackage datatype if this datatype is abstact:

- `GEOMETRY` (abstract) subtypes are `POINT`, `CURVE` (abstract), `SURFACE` (abstract) and `GEOMCOLLECTION`.
- `CURVE` (abstract) subtypes are `LINESTRING`, `CIRCULARSTRING` and `COMPOUNDCURVE`.
- `SURFACE` (abstract) subtype is `CURVEPOLYGON`.
- `CURVEPOLYGON` subtype is `POLYGON`.
- `GEOMETRYCOLLECTION` subtypes are `MULTIPOINT`, `MULTICURVE` (abstract) and `MULTISURFACE` (abstract).
- `MULTICURVE` (abstract) subtype is `MULTILINESTRING`.
- `MULTISURFACE` (abstract) subtype is `MULTIPOLYGON`.

A data set cannot use the GeoPackage encoding rule as an alternative encoding rule if requres a geometry type that cannot be mapped to a type in the GeoPackage geometry model (either the [Core model](https://www.geopackage.org/spec121/#core_geometry_model_figure) or an extension such as the [Non-linear geometry type extension](https://www.geopackage.org/spec121/#extension_geometry_types)).

##### ISO 19108 - Temporal types
<!-- Status: pending -->

For types from ISO 19108 used in INSPIRE schemas, suitable mappings need to be found on a case-by-case basis.

##### ISO 19115 - Metadata types
<!-- Status: pending -->

For types from ISO 19115 used in INSPIRE schemas, suitable mappings need to be found on a case-by-case basis.

##### ISO 19139 - Metadata XML implementation types
<!-- Status: implemented as `general rule ISO-19139 Metadata XML Implementation Types` -->
| ISO 19139 type | Attribute |  GeoPackage datatype | Constraints | Conversion Notes |
| ------ | --- | ----- | ----- | ---- |
| `LocalisedCharacterString` | _Content_ | `TEXT` | | If stored standalone uses a column named `text`.
| | `locale` | | | Type `PT_Locale` flattened in `LocalisedCharacterString` but attributes keep the name unchanged
| `PT_Locale` | `languageCode` | `TEXT` | `NOT NULL`, Enum constraint `GMD_LanguageCode`
| |`characterSetCode` | `TEXT`| Enum constraint `MD_CharacterSetCode`
| |`country` | `TEXT`| Enum constraint `GMD_CountryCode`
| `URI` | | `TEXT` |  |

##### Flattening types
<!-- Status: implemented as `flatten Data Types with upper cardinality of 1 but Identifier` -->

This rule flattens complex model structures.

This enconding rule is appled to all `DataType` types (`B`) that are used as value type by the property `x` of a other type (`A`) but the data type `Identifier`.

The property `x` in `A` is replaced with the content of `B`, i.e the type `B` is flattened when:

- the value type of property `x` of type `A` is `B`.
- the maximum multiplicity of the property `x` is `1`.
- the maximum multiplicity of the properties of the type `B` is `1`.

The process is as follows:

- Each property `y` of `B` is copied into type `A` and then:
  - It is renamed to `x_y`.
  - Its minimun multiplicity is the minimum of `x` and `y`.
  - The remaining characteristics of `x` are copied to it.
- Next, the property `x` is removed from type `A`.

This rule is also applied to the type `PT_Locale` so `languageCode`, `characterSetCode`, and `country` are added as separate properties.

##### Abstract Types as property types

Where an abstract type with multiple concrete sub-types is used as a property type, a suitable choice of a concrete subtype should be made on a case-by-case basis.

As an example, limiting the potential geometry types in this way can make processing easier.

##### Union Types
<!-- Status: implemented as `flatten union types` -->

This rule flattens `union` types.

A `union` type is structured data type without identity where exactly one of the properties of the type is present in any instance.

The property `x` in `A` is replaced with the properties of the `union` `B`, i.e the `union` type `B` is flattened when:

- the value type of property `x` of type `A` is `B`.
- the maximum multiplicity of the property `x` is `1`.

The process is as follows:

- Each property of type `B` (i.e. `y`) is copied into type `A` and then:
  - Its renamed to `x_y`.
  - Its minimum multiplicity is set to `0`.
  - The remaining characteristics of `x` are copied to it.
- Next, the property `x` is removed from type `A`.

The restriction that exactly one of the properties of the type is present in any instance may be may be enforced by code in applications that update GeoPackage data values.

##### Enumerations
<!-- Status: implemented as `general rule Enumeration Types` -->

All types that have the stereotype `<<enumeration>>` are converted to `GeoPackage data column constraints of type enum`.

The [schema extension](https://www.geopackage.org/spec121/#extension_schema) provides a means to describe the columns of tables in a GeoPackage with more detail than can be captured by the SQL table definition directly.

Any UML Model property whose type is an enumeration  with maximum cardinality of '1' should be mapped to a `TEXT` column with an enumeration constraint.

Greater cardinalities are discussed in the section about arrays.

The restriction is of the column is specified in the table `gpkg_data_columns`.
The values are specified in the table `gpkg_data_column_constraints`.

The following table shows how to encode UML model enumeration literals as `gpkg_data_column_constraints` rows.

**Table: Mapping to Data Columns Constraints Table.**

| UML Model concept | Colum Name | Colum Type | Column Description | Conversion Notes
| ----------------- | ---------- | ---------- | ------------------ | ---
| Enumeration       | `constraint_name` | `TEXT` | Name of constraint (lowercase) | Enumeration name in lowercase
|                   | `constraint_type` | `TEXT` | `enum` |
| Enumeration literal | `value` | `TEXT`      | Case sensitive value |
|                   | `description` | `TEXT`  |  Describes the enumeration literal | The URI of the enumeration value in the INSPIRE Registry

**Example:** The example shows the SQL statements that encodes the `TechnicalStatusValue` enumeration used as type of the property `technicalStatus` of the feature type `AdmnistrativeBoundary`, and its literal values. The URI of the enumeration value in the INSPIRE Enumeration Registry can be derived from the names of the enumeration and the enumeration literal.

```sql
CREATE TABLE AdministrativeBoundary(..., technicalStatus TEXT default 'edgeMatched');
INSERT INTO gpkg_data_column_constraints(constraint_name, constraint_type, value, description)
    VALUES ('technicalstatusvalue',
            'enum',
            'edgeMatched',
            'http://inspire.ec.europa.eu/enumeration/TechnicalStatusValue/edgeMatched');
INSERT INTO gpkg_data_column_constraints(constraint_name, constraint_type, value, description)
    VALUES ('technicalstatusvalue',
            'enum',
            'notEdgeMatched',
            'http://inspire.ec.europa.eu/enumeration/TechnicalStatusValue/notEdgeMatched');
INSERT INTO gpkg_data_columns(table_name, column_name, constraint_name)
    VALUES ('AdministrativeBoundary',
            'technicalStatus',
            'technicalstatusvalue');
```

If required, specific rules being defined on a case-by-case basis in each theme profile.

##### Code Lists
<!-- Status: implemented as `general rule CodeList Types` -->

The general rule for the stereotype `<<codeList>>` is the same as the enumerations rule.

If required, specific rules being defined on a case-by-case basis in each theme profile.

##### Voidable
<!-- Status: implemented as `voidable properties have a min cardinality of 0` -->

If a property has exactly a cardinality of `1` but has the stereotype `<<voidable>>`, it is mapped to a `column` that allows `null` values.

Remaining uses of the stereotype `<<voidable>>` in properties are ignored.

<!-- Status: implemented as `load authoritative descriptions of the reasons for void values as metadata` -->
Authoritative descriptions of the reasons for void values in the INSPIRE Registry ([VoidReasonValue code list](http://inspire.ec.europa.eu/codelist/VoidReasonValue)) are encoded using the metadata extension as follows:

**Table: Records in gpkg_metadata.**

| `id` | `md_scope` | `md_standard_uri` | `mime_type` | `metadata` |
| -- | -- | -- | -- | -- |
| `1` | `attribute` | `http://www.isotc211.org/2005/gmd` | `text/xml` | Content of `http://inspire.ec.europa.eu/codelist/VoidReasonValue/Unknown/Unknown.en.iso19135xml`  
| `2` | `attributeType` | `http://www.isotc211.org/2005/gmd` | `text/xml`| Content of `http://inspire.ec.europa.eu/codelist/VoidReasonValue/Unpopulated/Unpopulated.en.iso19135xml`
| `3` | `attribute`  | `http://www.isotc211.org/2005/gmd`| `text/xml` | Content of `http://inspire.ec.europa.eu/codelist/VoidReasonValue/Withheld/Withheld.en.iso19135xml`  
| `4` | `attributeType` | `http://www.isotc211.org/2005/gmd` | `text/xml` | Content of `http://inspire.ec.europa.eu/codelist/VoidReasonValue/Withheld/Withheld.en.iso19135xml`

#### Properties
<!-- Status: implemented as `properties with maximum cardinality 1 to columns` -->

If a property has an maximum cardinality of `1`, it is mapped to a `column`.
The column name is the same as the property.
The column will allow `null` values if and only if if the minimum cardinality of the property is `0` or it the property is `<<voidable>>`.

If a property has a cardinality greater than `1`, a suitable mapping needs to be found on a case-by-case basis.

If a property represents values from code lists and enumerations the type of the column is `TEXT`,
and the values from the code lists and enumerations are encoded using the literal of the value.

Allowed values are encoded as a `GeoPackage data column constraints of type enum`.

**Example:** The example shows the SQL statements that encodes that an `AdministrativeBounday` has a `technicalStatus` property with the value `notEdgeMatched` that is a value of the `TechnicalStatusValue` enumeration registered in the INSPIRE Enumeration Registry.

```sql
INSERT INTO gpkg_data_column_constraints(constraint_name, constraint_type, value, description)
    VALUES ('technicalstatusvalue',
            'enum',
            'notEdgeMatched',
            'http://inspire.ec.europa.eu/enumeration/TechnicalStatusValue/notEdgeMatched');
INSERT INTO gpkg_data_columns(table_name, column_name, constraint_name)
    VALUES ('AdministrativeBoundary',
            'technicalStatus',
            'technicalstatusvalue');
INSERT INTO AdministrativeBoundary(..., technicalStatus)
    VALUES (..., 'notEdgeMatched');
```

##### Arrays
<!-- Status: pending -->

Property types for properties with a cardinality greater than `1` and a simple property type (e.g. String, Integer, Float, ...) may use arrays of these simple types.

<!-- Status: pending -->

Property types for properties with a cardinality greater than `1` and an enumeration or codelist are implemented similar to `N:M` association roles.

<!-- Status: implemented as `create supporting Attribute tables for Enumerations and Codelists involved in arrays` -->
For each distinct enumeration or codelist involved in an array in the model is created a supporting `Attributes` table named as the enumeration or codelist with the following structure:

**Table: Structure of a supporting Attribute table for an enumeration or codelist.**

| Column name | Type | Description | Null | Constraint
| ----------- | ---- | ----------- | ---- | ---------  
| `id`| `INTEGER` | Autoincrement primary key | no | PK
| `value` | `TEXT` | Enumeration or codelist literal | no | ENUM

The literal values of  the `value` column are constrained by the corresponding `GeoPackage data column constraint of type enum`.

#### Association Roles
<!-- Status: general rule for association roles and arrays -->

`N:M` association roles are implemented as `GeoPackage Related Tables`.
The mapping table of an `N:M` association role is implemented as a table.

The mapping table of `1:N`, `N:1` and `1:1` association roles is implemented as a view.
The `base_id` of the mapping table is the `id` column of the parent member of the association.
The `related_id` of the mapping table is a column of type `INTEGER` with the name of the child property of the relationship on the child member of the association.

For example:

```sql
CREATE VIEW 'AU_AdministrativeBoundary_inspireId' (base_id, related_id) AS
SELECT id, inspireId FROM AU_AdministrativeBoundary;
```

Creates the mapping table of the `1:1` relationship between `AdministrativeBoundary` and `Inspire`.

#### Naming modification
<!-- Status: implemented as `default application schema prefixes` -->

This rule can be used to modify the names of specific model elements in the application schema.

The name of the `feature table` is the name of the type (e.g. `AdministrativeUnit`).

The name of the `attribute table` is the name of the type (e.g. `SpellingOfName`).

The name of the `constraint enum` is the name of the code list or the enumeration (e.g. `AdministrativeHierarchyLevel`).

The name of the `relation table` is as follows:

- If the relation is not mandatory for both sides, the name is the name of one of the types of the relation (e.g. `AdministrativeBoundary_upperLevelUnit`) plus an underscore (`_`) plus the name of the role on that side of the relation (`admUnit`).
- If the relation is mandatory only for one side, this side provides the name of the relation (e.g `Condominium_admUnit`).
- If the relation is mandatory for both sides, the name is the roles of the relation separated by an underscore (`_`) (e.g. `boundary_admUnit`).

These names may be prefixed to avoid name colision when multiple application schemas are stored in the same GeoPackage. The prefix is the namespace prefix to be used as short form of the XML namespace of the application schema in uppercase, with hyphens (`-`) replaced by underscores (`_`) plus an underscore added at the end (e.g. `TN_RO_` is the prefix for contents from the application schema `Transport Network Roads` because `tn-ro` is its namespace prefix).

Other entities encoded in the GeoPacckage that have an inmplementation in a well known XML namespace may use a similar strategy (e.g. `GMD_` for contents that have an implementation in _Geographic MetaData_ (`gmd`)) .

### Dataset Encoding Rule

This section describes additional rules when a specific dataset is encoded into the model converted to GeoPackage.

#### Character Encoding
<!-- Status: data insertion rule -->

The character encoding of all `TEXT` encoding in GeoPackage shall be UTF-8 or UTF-16.

SQLite stores all text as Unicode characters encoded using either UTF-8 or UTF-16 encoding.
The SQLite API contains functions which allow passing and retrieving text using either UTF-8 or UTF-16 encoding.
These functions can be freely mixed and proper conversions are performed transparently when necessary.

#### Coordinate Reference Systems
<!-- Status: data insertion rule -->

A GeoPackage shall include a `gpkg_spatial_ref_sys` table that contains CRS definitions to relate data in user tables to location on the earth.
The CRS definitions conforms to:

- [OpenGIS® 01-009 Implementation Specification: Coordinate Transformation Services Revision 1.0](http://portal.opengeospatial.org/files/?artifact_id=999) (a.k.a WKT1) (column `definition` specified in [1.1.2. Spatial Reference Systems](https://www.geopackage.org/spec121/#spatial_ref_sys))
- [OGC® 12-063r5 Geographic information - Well-known text representation of coordinate reference systems](http://docs.opengeospatial.org/is/12-063r5/12-063r5.html) (a.k.a WKT2) (column `definition_12_063` specified in [F.10. WKT for Coordinate Reference Systems](https://www.geopackage.org/spec121/#extension_crs_wkt))

The `gpkg_spatial_ref_sys` table contain at a minimum the WGS-84 as defined by [EPSG:4326](https://spatialreference.org/ref/epsg/wgs-84/) and two additional reference systems for undefined Cartesian and geographic coordinate reference systems.

The [INSPIRE Data Specification on Coordinate Reference Systems – Technical Guidelines D2.8.1](https://inspire.ec.europa.eu/documents/Data_Specifications/INSPIRE_DataSpecification_RS_v3.2.pdf) proposes the use of coordinate reference system parameters and identifiers shall be managed in one or several common registers for coordinate reference systems. Only identifiers contained in a common register shall be used for referring to the coordinate reference systems. Additionally, lists in Table 1 a list of coordinate reference systems registered in the [EPGS Geodetic Parameter Registry](http://www.epsg-registry.org/) that shall be used for referring to the coordinate reference systems used in a dataset.

The following table explains how to encode default CRS from the Table 1 in the `gpkg_spatial_ref_sys` table.

**Table: Mapping to `gpkg_spatial_ref_sys`.**

| Column Name | Column Type | Column Description | Value from Table 1 |
| --- | --- | --- | --- |
| `srs_name` | `TEXT` | Human readable name of this SRS | Text from `Short name`
| `srs_id` | `INTEGER` | Unique identifier for each SRS within a GeoPackage | Any value (e.g. EPSG numeric ID)
| `organization` | `TEXT` | Case-insensitive name of the defining organization | `"EPSG"`
| `organization_coordsys_id` | `INTEGER` | Numeric ID of the SRS assigned by the organization | EPSG numeric ID
| `definition` | `TEXT` | WKT representation | WKT1 representation of the SRS
| `description` | `TEXT` | Human readable description of this SRS | Text from `Coordinate reference system`
| `definition_12_062` | `TEXT` | WKT representation | WKT2 representation of the SRS

WKT1 and WKT2 representations can be obtained with the use of tools such as [`gdalsrsinfo`](https://gdal.org/programs/gdalsrsinfo.html).

The `gpkg_spatial_ref_sys` table of an INSPIRE GeoPackage may contain all the default CRS from the Table 1.

#### Void values information
<!-- Status: data insertion rule -->

Void reason value information may be encoded as metadata and related to specific features in a GeoPackage.

The first component of GeoPackage metadata is the `gpkg_metadata` table that MAY contain metadata in MIME encodings structured in accordance with any authoritative metadata specification. The GeoPackage interpretation of what constitutes "metadata" is a broad one. We can use the second component of GeoPackage metadata, the `gpkg_metadata_reference` table, to link metadata in the `gpkg_metadata` table to columns and row/columns in table.

implementers must provide authoritative descriptions of the reasons of `null` values in when a correct value may exists as follows:

**Table: Records in gpkg_metadata_reference giving a reason and scope.**

| Reason | Scope | `reference_scope` | `table_name` | `column_name` | `row_id` | `md_file_id`
| -- | -- | -- | -- | -- | -- | --
| `Unknown` |  `attribute` | `row/col` | *table name* | *column name* | *row id* | `1`  
| `Unpopulated` | `attributeType` | `column` | *table name* | *column name* | `NULL` |  `2`
| `Unpopulated` | `attributeType` | `table` | *related table name* |  `NULL` | `NULL` |  `2`
| `Withheld` | `attribute`  | `row/col` | *table name* | *column name* | *row id* | `3`  
| `Withheld` | `attributeType` | `column` | *table name* | *column name* | `NULL` | `4`

**Example:**.
`Unpopulated` is encoded in `gpkg_metadata` in the row with `id` `2`.
The dataset `A` does not maintain information about the lifecycle of the feature type `AdministrativeBoundary` and hence the values of `endLifespanVersion` columns are `null` values. As `endLifespanVersion` is `<<voidable>>` and optional, we can use `gpkg_metadata_reference` to state without ambiguity that the dataset `A` does not contain information about the `endLifespanVersion.

```sql
INSERT INTO gpkg_metadata_reference VALUES (
  'column',
  'AdministrativeBoundary',
  'endLifespanVersion',
  NULL,
  '2019-11-17T14:49:32.932Z',
  2,
  null
)
```

The dataset `B` maintains information about the lifecycle of the feature type `AdministrativeBoundary` and hence the values of `endLifespanVersion` columns are normally not `null`. As `endLifespanVersion` is `<<voidable>>` and optional, we can use `gpkg_metadata_reference` to state without ambiguity when a `null` value means that we don't know the end data of the administrative boundary with `id` `15`.

```sql
INSERT INTO gpkg_metadata_reference VALUES (
  'row/col',
  'AdministrativeBoundary',
  'endLifespanVersion',
  15,
  '2019-11-17T14:49:32.932Z',
  1,
  null
)
```

## Flattened Dataset Encoding Rule

**Note**: The content of this section is unstable.

This section describes additional rules that allows to transform a specific dataset encoded with the rules of the previous section into a flattened version.

### Unpopulated Features

Feature tables and views with 0 rows must be dropped.
The dependent attribute tables and views must be also dropped.

This implies also to remove rows that reference them in `gpkg_contents`, `gpkg_geometry_columns`, `gpkg_data_columns`, `gpkg_metadata_reference`, `gpkgext_relations` and `gpkg_extensions`.

### Unpopulated Many-to-many Relations

Table relations tagged in `gpkg_metadata_reference` as `unpopulated` at `table` level must be dropped.

This implies also to remove rows that reference them in `gpkg_contents`, `gpkg_data_columns`, `gpkg_metadata_reference`, `gpkgext_relations` and `gpkg_extensions`.

### Unpopulated Columns

Columns tagged in `gpkg_metadata_reference` as `unpopulated` at `column` level must be dropped.

This implies also to remove rows that reference them in `gpkg_data_columns` and `gpkg_metadata_reference`.

### Implicit One-to-one Relations to Data Types

This rule is performed iterativelly until no more candidates can be transformed.

The steps are:

1. Candidates are table relations that in the dataset behaves effectively as a 0:1 or 1:1 relationship instead of 1:N or N:M where one side was a `<<dataType>>` in the conceptual model and it is a simple table (henceforth, source table).
1. Source tables are flattened following the [Flattening types](#flattening-types) rule as if the maximum cardinality of the relation is `1`.
The description of the columns affected in `gpkg_data_columns` is updated with to reflect the new `table_name` and new `column_name`.
Content is copied from the columns of source table to the columns target table using the mapping information of the table relation.
1. Candidates are now table relations that in the dataset behaves effectively as a 0:1 or 1:1 relationship instead of 1:N or N:M where one side was a `<<dataType>>` in the conceptual model and it is now a simple table after a flattening.
1. If there are candidates, go to the step `2`.
1. Otherwise, there are no more tables that can be flattened. Next the candidate relations and source tables used during the iterations must be dropped if they only participated in the flattened relations.
This implies also to remove rows that reference them in `gpkg_contents`, `gpkg_data_columns`, `gpkgext_relations` and `gpkg_extensions`.
