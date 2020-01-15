# INSPIRE UML-to-GeoPackage encoding rule <!-- omit in toc -->

![Development version][development-shield]

**Note:** This document must be considered as a development document only endorsed by the authors.

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
    - [Application Schemas](#application-schemas)
    - [Types](#types)
      - [Feature types](#feature-types)
      - [Data Types](#data-types)
      - [ISO 19103](#iso-19103)
        - [Basic types](#basic-types)
        - [Properties with a `uom` attribute](#properties-with-a-uom-attribute)
      - [ISO 19107 - Geometry types](#iso-19107---geometry-types)
      - [ISO 19108 - Temporal types](#iso-19108---temporal-types)
      - [ISO 19115 - Metadata types](#iso-19115---metadata-types)
      - [ISO 19139 - Metadata XML implementation types](#iso-19139---metadata-xml-implementation-types)
      - [Other types](#other-types)
      - [Flattening of nested structures](#flattening-of-nested-structures)
      - [Replace abstract types in properties by Identifier](#replace-abstract-types-in-properties-by-identifier)
      - [Union Types](#union-types)
      - [Enumerations and Code lists](#enumerations-and-code-lists)
      - [Voidable](#voidable)
    - [Alternate Structures for specific types or type hierarchies](#alternate-structures-for-specific-types-or-type-hierarchies)
      - [Simplified Localized Character String](#simplified-localized-character-string)
      - [Simplified Geographic Name](#simplified-geographic-name)
      - [Simplified Citation](#simplified-citation)
    - [Properties](#properties)
      - [Extract primitive array](#extract-primitive-array)
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
GDAL (C/C++/Python) and NGA GeoPackage Libraries (Java/Objective-C/JavaScript) and SDK (Android/iOS/Web) can be used for storing and access data from GeoPackages in Desktop, server and mobile environments.

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

For each theme to be covered, an empty **GeoPackage template** is provided.
The *GeoPackage template* is a *GeoPackage* instantiated with the schema for a specific INSPIRE theme.

These can reside in subfolders in the same repository as this general encoding rule, but can also be maintained in other places.

### Technical Issues

This encoding rule addresses specific technical issues that have been problematic when using the default encoding:

- Most GIS software cannot fully make use of non-simple attributes and nested structures for styling, processing and filtering;
- Multiple values per (complex) properties cannot be used fully in ArcGIS and other GIS tools;
- References to other features often cannot be resolved by GIS tools; Properties of referenced features cannot be used in styling or for filtering;
- Abstract geometry types for an object mean that a wide range of different geometries can be used for any single feature class;
- Mixed geometry types in a FeatureCollection are usually not supported.

### Technical Requirements

The encoding uses the [OGC® GeoPackage Encoding Standard - with Corrigendum version 1.2.1](https://www.geopackage.org/spec121/) with the following extensions:

- [GeoPackage Non-Linear Geometry Types](http://www.geopackage.org/spec121/#extension_geometry_types)
- [Metadata](http://www.geopackage.org/spec121/#extension_metadata)
- [Schema][gpkg-ext-schema]
- [Related Tables Extension][gpkg-ext-related]
- [WKT for Coordinate Reference Systems](http://www.geopackage.org/spec121/#extension_crs_wkt)

### Technical Limitations

TIN and 3D geometries are not supported yet, however they can be stored as `BLOB`.

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
- [OGC GeoPackage Related Tables Extension][geopackage-related]
- [INSPIRE Drafting Team Data Specifications. D2.7: Guidelines for the encoding of spatial data, Version 3.3](http://inspire.ec.europa.eu/documents/guidelines-encoding-spatial-data)

## Terms and Definitions

Terms and Definitions can be found in the [Glossary](https://github.com/INSPIRE-MIF/2017.2/blob/master/glossary.md) document.

## Compliance Encoding Rule

### Schema Conversion Rule

INSPIRE defines the conceptual model using UML.
The default encoding rule maps this UML model to XML Schema.

In the GeoPackage encoding rule, we take a two-step approach, where we apply model transformations on the level of the conceptual model to transform INSPIRE constructs into conceptual GeoPackage constructs, and then we materialize these into a *GeoPackage template* per theme.

Theme-specific GeoPackage Encoding Rules may provide a formal definition of the encoded data structures as normative SQL statements and abstract test suites.

Executable test suites may use these to test the correctness of data elements (tables, columns, or values) and SQL constructs (views, constraints, or triggers).

For GeoPackage, SQL queries to GeoPackage metadata tables (e.g. `gpkg_contents`, `gpkg_spatial_ref_sys`) can be used to perform simple validation on GeoPackages.  

#### Application Schemas

![Implemented][implemented-shield]

A `GeoPackage file` may encode one or more `<<applicationSchema>>` packages related to a spatial data theme.

Deriving a `GeoPackage file` from application schemas implies the creation of SQL statements for `feature tables`, `attribute tables`, `user-defined mapping tables or views` and related metadata.

The application schemas to be encoded may include references to types, enumerations and code lists defined in other packages in attributes and navigable associations, which in turn may include additional references.
The process of inclusion of references is recursive and requires a stop criteria.
The logical boundary of the encoding of an application schema is defined by the set of `<<featureTypes>>` defined in other packages that can be reached from items defined in the application schema.
This criterium defines a tangible boundary where the GeoPackage file makes sense as transport file of a dataset defined by one or more application schema.

Given a package `A` with the stereotype `<<applicationSchema>>`, its encoding as `GeoPackage file` must include:

- Concrete spatial object types.
- Concrete data types.
- Enumerations and code lists.
- Types, enumerations and code lists reachable recursively except those that can only be reached through a `<<featureType>>` defined in an `<<applicationSchema>>` different from `A`.

References to `<<featureTypes>>` in the logical boundary are replaced by the type `Identifier`.
This approach is similar to the role of `XLink` in the `GML` specification to implement referencing.

**Model transformation rule:**
> Given a set `root` of `<<applicationSchema>>` packages, this rule determines which types are candidates to be encoded in a `GeoPackage file`.
>
> 1. Let `GeoPackage` be the set that contains all `<<featureType>>`, `<<dataType>>`, `<<union>>`, `<<codeList>>` and `<<enumeration>>` found in packages of  `root`.
> 2. Let `Boundary` be an empty set.
> 3. Let `Frontier` be the set of the types referenced by means of attributes and associations, local or inherited, of elements of the set of `GeoPackage` not included in the set `GeoPackage`.
> 4. If `Frontier` is not empty:
>
>    1. Add the elements of the `Frontier` bearing the stereotype `<<featureType>>` to `Boundary`.
>    2. Add the remaining elements of `Frontier` to `GeoPackage`.
>    3. Go to step `3`.
>
> 5. For each `item` in `GeoPackage` do:
>
>    1. Replace each reference of `item` to a type in `Frontier`  by the type `Identifier`.
> 6. The set `GeoPackage` contains the items to be encoded using this rule.

#### Types

##### Feature types

![Implemented][implemented-shield]

The GeoPackage encoding standard mandates in Requirement [30](https://www.geopackage.org/spec/#r30) that `feature tables` (or views) shall only have a single geometry column.
This is advantageous because allowing multiple (or none) geometries per feature table would compromise GeoPackage's position in the GIS application ecosystem.
However, there are features types in INSPIRE models with none or multiple geometries.

Therefore, all concrete types that have the stereotype `<<featureType>>` can be converted to GeoPackage content with the following considerations:

- Where a class has one attribute with a geometry type and a maximum multiplicity of `1`, the class will be mapped to a `feature table` and the type of this attribute will be mapped to a GeoPackage geometry type ([ISO 19107 - Geometry types](#iso-19107---geometry-types)).
- Where a class has no geometry attributes (for example `Addresses::ThoroughfareName`), the class will be mapped to a `attribute table` (see [Data types](#data-types)). A GeoPackage `feature table` shall have one geometry column.
- Where a class has several attributes with a geometry type, all with a maximum multiplicity of `1`, and only one is not `<<voidable>>`, the class will be mapped to a `feature table`, all `<<voidable>>` geometry attributes are moved to new `feature type` classes named as the name of the original class plus an underscore (`_`) plus the name of the attribute (e.g. `CadastralParcel_referencePoint`, `Borehole_downholeGeometry`) and an 1:1 association role is added between each new class and the original. [1]
- Otherwise, i.e. a class has more than one non voidable geometry attribute or the maximum multiplicity is greater than `1`, a theme-specific profile has to define which geometry attribute is the _default_ geometry and how to map the additional geometry attributes. A GeoPackage `feature table` shall have only one explicit geometry column.

![Implementation note][note-shield]

[1] Since a GeoPackage is a relational database, it is recommended for associating values relating to the same feature in different `feature tables` the use of the same row `id` to link them.

##### Data Types

![Implemented][implemented-shield]

All concrete types that have the stereotype `<<dataType>>` can be converted to GeoPackage content with the following considerations:

- Where a class has no geometry attributes (for example `Addresses::ThoroughfareNameValue`), the class will be mapped to a GeoPackage `attribute table` if, after applying the all the encoding rules, the class is yet used as type in some property, i.e. the class participates in at least one `relation table` derived from a property.
- Otherwise, the rules for [Feature types](#feature-types) must be applied because `attribute tables` are intended for data that do not have an explicit geometry attribute.

##### ISO 19103

###### Basic types

![In progress][in-progress-shield]

All property types are transformed to the simple types that GeoPackage knows about.
The exact mapping from the UML model to the [GeoPackage datatypes](https://www.geopackage.org/spec121/#table_column_data_types) is outlined in the following table:

**Table: ISO 19103 to GeoPackage datatype mapping.**

| UML Model property type | GeoPackage datatype | SQLite storage class | Conversion Notes |
| ------ | ----- | ----- | ----- |
| `CharacterString` | `TEXT` | `TEXT` | Unicode [1]
| `URI` | `TEXT` | `TEXT` | Unicode
| `Boolean` | `BOOLEAN` | `INTEGER` | 0 for false and 1 for true
| `Integer` | `INTEGER` | `INTEGER` |
| `Real` | `REAL` | `REAL` |  
| `Number` | `REAL`| `REAL`| Alternative encoding [2]
| `Decimal` | `REAL` | `REAL` |
| `Date` | `DATE` | `TEXT` | ISO8601 date strings `YYYY-MM-DD`. |
| `DateTime` | `DATETIME` | `TEXT` | ISO-8601 date/time in UTC strings `YYYY-MM-DDTHH:MM:SS.SSSZ` |
| `UnitOfMeasure` | `TEXT` | `TEXT` | Constraint enum [3]

[1] SQLite stores all text as Unicode characters encoded using either UTF-8 or UTF-16 encoding.
The SQLite API contains functions which allow passing and retrieving text using either UTF-8 or UTF-16 encoding.
These functions can be freely mixed and proper conversions are performed transparently when necessary.

[2] Implementers may use `TEXT` if a dataset needs it; values stored in SQLite as `TEXT` can be used in [SQL `CAST` expressions](https://www.sqlite.org/lang_expr.html#castexpr) to convert them into `INTEGER` and `REAL` values. If the text:

- Looks like an integer and the value is small enough to fit in a 64-bit signed integer, then the result will be `INTEGER`.
- Looks like floating point (there is a decimal point and/or an exponent) and can be losslessly converted back and forth between IEEE 754 64-bit float and a 51-bit signed integer, then the result is `INTEGER`.
- Any other case yields the closest `REAL` result.

Any UML Model property whose  `Integer` or `Real` values may overflow the limits of the respective SQLite storage class (i.e. `INTEGER`, `REAL`) should be mapped to `TEXT`, with specific rules being defined on a case-by-case basis in each theme profile.

[3] The syntax and value space is the same of `gml:UomIdentifier`.
The legal values of the new property are the literals of the data column constraint enum `GML_UomIdentifier`.
This restriction may be enforced by SQL triggers or by code in applications that update GeoPackage data values.

Any other UML Model property type is to be mapped to `TEXT`, with specific rules being defined on a case-by-case basis in each theme profile.

###### Properties with a `uom` attribute

![Implemented][implemented-shield]

The unit of measurement attribute (`uom`) on any property `x` has to be retained.

It is transformed to a new property with the name `x_uom` that will be mapped to a column of type `TEXT` with the enum constraint `GML_UomIdentifier`.

##### ISO 19107 - Geometry types

![Implemented][implemented-shield]

ISO 19107 defines a set of Geometry types, which need to be mapped to the types available in GeoPackage.

In a GeoPackage, features are geolocated using a geometry subset of the [SQL/MM (ISO 13249-3)](https://www.iso.org/standard/53698.html).

The supported geometry model is as follows:

- `GEOMETRY` (abstract) subtypes are `POINT`, `CURVE` (abstract), `SURFACE` (abstract) and `GEOMCOLLECTION`.
- `CURVE` (abstract) subtypes are `LINESTRING`, `CIRCULARSTRING` and `COMPOUNDCURVE`.
- `SURFACE` (abstract) subtype is `CURVEPOLYGON`.
- `CURVEPOLYGON` subtype is `POLYGON`.
- `GEOMETRYCOLLECTION` subtypes are `MULTIPOINT`, `MULTICURVE` and `MULTISURFACE`.
- `MULTICURVE` subtype is `MULTILINESTRING`.
- `MULTISURFACE` subtype is `MULTIPOLYGON`.

The correspondence of concepts of this geometry subset with concepts of the geometry model of ISO 19107 are described in [ISO 19125-1:2004](https://www.iso.org/standard/40114.html).

The tables below contain a the mapping of ISO 19107 used in INSPIRE UML models.

**Table: ISO 19107 types used in models and its standard GeoPackage datatype mapping.**

| ISO 19107 type | GeoPackage datatype |
| ------ | ----- |
| `GM_Curve` | `CURVE` |
| `GM_MultiCurve` | `MULTICURVE` |
| `GM_MultiSurface` | `MULTISURFACE` |
| `GM_Object` | `GEOMETRY` |
| `GM_Point` | `POINT` |
| `GM_MultiPoint` | `MULTIPOINT` |
| `GM_Polygon` | `POLYGON` |
| `GM_Surface` | `SURFACE` |

**Table: ISO 19107 types used in models with non standard datatype mapping.**

| Application Schema | ISO 19107 type | GeoPackage datatype | Conversion Notes |
| -----| ------ | ----- | ----- |
| Building 3D | `GM_Solid` | `BLOB` | Add the column `geometrySolid_content_type`. Store the 3D data in the column of type `BLOB` and specify the format in `geometrySolid_content_type`. [1]
| ElevationTIN | `GM_Tin` | `BLOB` | Store the TIN encoded in WKB. [2]
| Environmental Monitoring Facility | `GM_Boundary` | `POLYGON` | Used as type in `EnvironmentalMonitoringActivity.boundingBox`
| Hydro - Physical Waters, Hydrogeology | `GM_Primitive` | `GEOMETRY` | Restricted to `POINT`, `CURVE` or `SURFACE` and their subtypes.

[1] The GeoPackage specification does not support 3D data, but it is a established practice in GeoPackage to store any kind of content along its content type.
The proposed mapping may imply the use of an `attribute table` instead of a `feature table` if the feature type has no additional geometry columns.

[2] The GeoPackage specification does not mention Triangle (`GM_Triangle`), PolyhedralSurface (`GM_PolyhedralSurface`) or TIN (`GM_Tin`).
However the GeoPackage geometry blob format is based on ISO WKB, and hence can represent these geometric objects.
It is assumable that a future GeoPackage extension may include them as supported geometry types.
The proposed mapping may imply the use of an `attribute table` instead of a `feature table` if the feature type has no additional geometry columns.

![Implementation note][note-shield]

If a specific dataset requires a geometry type that cannot be mapped to an instantiable type in the GeoPackage geometry model (either the [Core model](https://www.geopackage.org/spec121/#core_geometry_model_figure) or an extension such as the [Non-linear geometry type extension](https://www.geopackage.org/spec121/#extension_geometry_types)) and a standard encoding for the geometry is available, use the same strategy applied for `GM_Solid` for such dataset.

In the GeoPackage 1.2.1 specification, Requirement [32](https://www.geopackage.org/spec121/#r32) `feature table` geometry columns shall contains geometries of the type or assignable for the type specified for the column in the `gpkg_geometry_columns` table.
However, it is under consideration for the GeoPackage 1.3 specification (see [here](https://www.geopackage.org/spec/#r32)) that `feature table` geometry columns shall contains only geometries of the type specified for the column in the `gpkg_geometry_columns` table.
There will be two exceptions:

- `GEOMETRY`, then the feature table geometry column may contain geometries of any allowed geometry type.
- `GEOMETRYCOLLECTION` then the feature table geometry column may contain zero or more geometries of any allowed geometry type.

This future change, when officially adopted, may lead to changes in this encoding rule.

##### ISO 19108 - Temporal types

![Pending][pending-shield]

For types from ISO 19108 used in INSPIRE schemas, suitable mappings need to be found on a case-by-case basis.

##### ISO 19115 - Metadata types

![Pending][pending-shield]

For types from ISO 19115 used in INSPIRE schemas, suitable mappings need to be found on a case-by-case basis.

**Table: ISO 19115 to GeoPackage datatype mapping.**

| ISO 19115 type | Attribute |  GeoPackage datatype | Constraints | Conversion Notes |
| ------ | --- | ----- | ----- | ---- |
| `URL` | | `TEXT`  |  |

##### ISO 19139 - Metadata XML implementation types

![In progress][in-progress-shield]

**Table: ISO 19139 to GeoPackage datatype mapping.**

| ISO 19139 type | Attribute |  GeoPackage datatype | Constraints | Conversion Notes |
| ------ | --- | ----- | ----- | ---- |
| `URI` | | `TEXT`  |  |

##### Other types

![In progress][in-progress-shield]

**Table: Other types to GeoPackage datatype mapping.**

|  Type |  GeoPackage datatype | Constraints | Conversion Notes |
| ------ | ----- | ----- | ---- |
| `Short` | `INTEGER`  |  |
| `Long` | `INTEGER`  |  |

##### Flattening of nested structures

[![MT001][mt001-shield]][mt001] ![Implemented][implemented-shield]

The complex structure of model elements are reduced by applying a recursive flattening method.
The principle of the flattening is to derive a flat model structure by moving the nested child elements to its parent.
The elements are renamed to represent the former element path in the name of the resulting element and to avoid naming conflicts.
The cardinality of the derived elements should be calculated from the cardinalities of the former element path.
The remaining properties of the original element must be copied to the derived elements.

This model transformation rule does not handle cardinalities greater than 1.

**Model transformation rule:**
> This rule flatten properties with maximum occurrence of 1 which whose type has not been already mapped to a GeoPackage type (e.g. ISO 19107 geometric types), it is not a `<<union>>`, `<<codeList>>` or `<<enumeration>>`, or is the base type `Identifer`.
>
> Recursively go down through the complex model structure as follows.
Given a candidate property `x` of type `B` in a class `A` that can be flattened, it is replaced by the properties of the class `B` as follows:
>
> - Each property `y` of `B` is copied into class `A` and then:
>   - The new property is renamed to `x_y`.
>   - The minimum multiplicity mew property is the minimum of the minimum multiplicities of `x` and `y`.
>   - The remaining characteristics of the property `x` are copied to the new property.
> - Finally, the property `x` is removed from type `A`.
>
> This process is performed recursively until the rule can no longer be applied.

##### Replace abstract types in properties by Identifier

![Implemented][implemented-shield]

Where an abstract `<<featureType>>` with multiple concrete sub-types is used as a property type, the property is renamed to provide a hint and the type is replaced by `Identifier`.
This approach is similar to the role of `XLink` in the `GML` specification to implement referencing.

**Model transformation rule:**
> This rule modifies properties that references an abstract `<<featureType>>`.
>
> - For each property `x` of `A` whose type is an abstract `<<featureType>>` `B`.
>   - The property `x` type is changed to `Identifier`.
>   - The property `x` is renamed to `x_B`.

##### Union Types

![Implemented][implemented-shield]

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

##### Enumerations and Code lists

[![MT008][mt008-shield]][mt008] ![Implemented][implemented-shield]

The use of enumeration values and references to code lists are common in the INSPIRE data specifications.
An enumeration is a fixed list of possible values.
A code list is a extendable list of possible values.
They are represented using properties whose type is the class with the stereotype `<<enumeration>>` and `<<codeList>>`.

The [schema extension][gpkg-ext-schema] provides a means to describe the columns of tables in a GeoPackage with more detail than can be captured by the SQL table definition directly.
The `gpkg_data_columns` table contains descriptive information about columns in tables.
The `gpkg_data_column_constraints` table contains data to specify restrictions on basic data type column values.

This encoding rule uses the above extension and creates a column enum constraint associated to each list in the conceptual model, records its allowed values as column constraints, provides a link to an external definition, and uses human readable values in property values.

**Model transformation rule:**
> This rule transforms classes with the stereotype `<<codeList>>` or `<<enumeration>>` to GeoPackage data column constraints table of type `enum`.
>
> Given a class with the stereotype `<<enumeration>>`, a row is added to the `gpkg_data_column_constraints` for each possible value of the code list.
> This row contains:
>
> - In the column `constraint_name`, the name of the class in lowercase.
> - In the column `constraint_type`, the string `"enum"`.
> - In the column `value`, the value.
> - In the column `description`, a URI that points to a description of the value, usually `"http://inspire.ec.europa.eu/enumeration/<class_name>/<value>"`.
>
> Given a class with the stereotype `<<codeList>>`, a row is added to the `gpkg_data_column_constraints` for each possible value of the code list.
> This row contains:
>
> - In the column `constraint_name`, the name of the class in lowercase.
> - In the column `constraint_type`, the string `"enum"`.
> - In the column `value`, the value.
> - In the column `description`, a URI that points to a description of the value, usually `"http://inspire.ec.europa.eu/codelist/<class_name>/<value>"`.
>
> Given a property with maximum cardinality of 1 that references an enumeration or code list.
>
> - The type of the property is mapped to `TEXT`.
> - The corresponding row of the `gpkg_data_columns` that describes the column that implements such property (identified by the coordinates `table_name`, `column_name`) has in the column `constraint_name` the name of the enumeration or the code list in lowercase.
>
> The encoding of higher cardinalities is discussed in [extract primitive array](#extract-primitive-array).

![Implementation note][note-shield]

This rule extends [MT008 - Simplified Codelist Reference][mt008] to enumerations.

##### Voidable

![Implemented][implemented-shield]

If a property has exactly a cardinality of `1` but has the stereotype `<<voidable>>`, it is mapped to a `column` that allows `null` values.

Remaining uses of the stereotype `<<voidable>>` in properties are ignored.

Authoritative descriptions of the reasons for void values in the INSPIRE Registry ([VoidReasonValue code list](http://inspire.ec.europa.eu/codelist/VoidReasonValue)) are encoded using the metadata extension as follows:

**Table: Records in gpkg_metadata.**

| `id` | `md_scope` | `md_standard_uri` | `mime_type` | `metadata` |
| -- | -- | -- | -- | -- |
| `1` | `attribute` | `http://www.isotc211.org/2005/gmd` | `text/xml` | Content of `http://inspire.ec.europa.eu/codelist/VoidReasonValue/Unknown/Unknown.en.iso19135xml`  
| `2` | `attributeType` | `http://www.isotc211.org/2005/gmd` | `text/xml`| Content of `http://inspire.ec.europa.eu/codelist/VoidReasonValue/Unpopulated/Unpopulated.en.iso19135xml`
| `3` | `attribute`  | `http://www.isotc211.org/2005/gmd`| `text/xml` | Content of `http://inspire.ec.europa.eu/codelist/VoidReasonValue/Withheld/Withheld.en.iso19135xml`  
| `4` | `attributeType` | `http://www.isotc211.org/2005/gmd` | `text/xml` | Content of `http://inspire.ec.europa.eu/codelist/VoidReasonValue/Withheld/Withheld.en.iso19135xml`

#### Alternate Structures for specific types or type hierarchies

##### Simplified Localized Character String

![Implemented][implemented-shield]

The package _Cultural and linguistic adaptability_ of ISO 19139 is an informative package (i.e. concepts are not implementable as-is) that defines types for representing localized texts (`LocalisedChacterString`, `PT_FreeText`, `PT_Locale`, `PT_LocaleContainer`).

The [GeoJSON encoding rule regarding to ISO 19103 basic types](https://github.com/INSPIRE-MIF/2017.2/blob/master/GeoJSON/geojson-encoding-rule.md#iso-19103---basic-types) maps `LocalisedChacterString` value to a string and keeps `languageCode`as a separate property.

The GeoPackage encoding rule proposes a simplified way to representing localized texts similar but more expressive with the new `<<type>>` `SimpleLocalisedCharacterString` that has two properties:

- a property that holds the text of type `CharacterString`.
- a property named `locale` of type `<<codelist>>` `Locale`.

The value space of `Locale` is defined by `PT_Locale`. The recommended syntax is a URI or the string `language[_country][.characterEncoding]` similar to POSIX locales.
`characterEncoding` should be considered optional and, if used, it should be the same as the encoding of the GeoPackage (UTF-8 or UTF-16).

The new type `SimpleLocalisedCharacterString` should replace the use of `LocalisedChacterString` and `PT_FreeText`.
When the new type replaces the use of `PT_FreeText` in an attribute, the upper bound of the attribute must be set to unbounded, so we can capture the intended purpose of the association `textGroup`.

##### Simplified Geographic Name

[![MT005][mt005-shield]][mt005] ![Implemented][implemented-shield]

Geographical Names are re-used throughout more than 20 INSPIRE themes overall.
For many existing data sets, the `<<data type>>` `GeographicalName`  is over specified, with very little information being unique to each instance.

`GeographicalName` is easy to implement in GeoPackage after applying [Flattening of nested structures](#flattening-of-nested-structures).
However, the one-to-many relationship of `GeographicalName` and `SpellingOfName`, where is the key `text` property, may cause usability problems.
`SpellingOfName` has tree properties, the `text` which is the way the name is written, the `<<voidable>>` `script` which is the set of graphic symbols employed in writing the name, and the `<<voidable>>` optional `transliterationScheme`.

GeoPackage uses Unicode for storing text, so the `script` value is implicitly encoded in the `text` for most of the cases (see [comparison of ISO 15924 script codes and Unicode](https://en.wikipedia.org/wiki/Script_(Unicode))).
The `transliterationScheme` is only relevant in a linguistic context.

The general transformation rule [MT005 Simplified Geographical Name][mt005] proposes a simplified alternative representation for `GeographicalNames` when it is used by other INSPIRE themes. This transformation only retains two properties: `language` and `spelling.text`.

The simplified geographical name adds minimal information with the new `<<datatype>>` `SimpleGeographicalName` that has two properties:

- `spelling_text: CharacterString`, which is encoded in Unicode.
- `language: <<voidable>> CharacterString [0..1]`.

The rationale for adopting for the GeoPackage encoding this model transformation is to ease the use of names.

**Model transformation rule:**
> This rule replaces the uses of the class `GeographicalName` in application schemas different from Geographical Names.
>
> - Create the `<<dataType>>` `SimpleGeographicalName` in the package `Base Types 2`.
> - Substitute existing uses of `GeographicalName`  in application schemas different from Geographical Names.

![Implementation note][note-shield]

If an implementer requires more information, it may:

- document defaults in the dataset metadata if it is homogeneous.
- extend the type `SimpleGeographicalName` with additional columns mapped to existing properties of the original `GeographicalName` type if it is heterogeneous.

##### Simplified Citation

[![MT007][mt007-shield]][mt007] ![Implemented][implemented-shield]

Citations are used in many different places throughout the INSPIRE data specifications.
ISO 19115 defines [CI_Citation](https://inspire.ec.europa.eu/data-model/approved/r4618-ir/html/index.htm?goto=1:3:13:15:2739), which has a very deep structure.
INSPIRE introduced two base types to simplify citations, [LegislationCitation and DocumentCitation](https://inspire.ec.europa.eu/data-model/approved/r4618-ir/html/index.htm?goto=3:2:2:9161).

`CI_Citation`, `LegislationCitation` and `DocumentCitation` are easy to implement in GeoPackage after applying [Flattening of nested structures](#flattening-of-nested-structures) and [Extract primitive array](#extract-primitive-array).

The general transformation rule [MT007 Simple Citation][mt007]  proposes a simplified alternative representation for `CI_Citation`, `LegislationCitation` and `DocumentCitation`.

The rationale of [MT007 Simple Citation][mt007] is the overhead generated by deep structure of the citation structures.

The simplified citation is based on a link to an external publication and adds minimal information as the new `<<datatype>>` `SimpleCitation` with five properties:

- `name: CharacterString`, the official name of the document
- `type: SimpleCitationType`, which is one of `CI_Citation`, `LegislationCitation` and `DocumentCitation` and indicates what kind of citation is represented
- `level: LegislationLevelValue [0..1]`, the level at which the legislative document is adopted
- `date: Date [0..1]`, date of creation, publication or revision of the document
- `link: URL [0..1]`, link to an online version of the document

The rationale for adopting for the GeoPackage encoding this model transformation is the unification of the citation structures.

**Model transformation rule:**
> This rule replaces the classes `CI_Citation`, `LegislationCitation` and `DocumentCitation` by the class `SimpleCitation`.
>
> - Create the `<<dataType>>` `SimpleCitation` in the package `Base Types 2`.
> - Substitute existing uses of `CI_Citation`, `LegislationCitation` and `DocumentCitation` by `SimpleCitation`.

**Instance transformation rule:**
> The `type` value in an instance must be consistent with the replaced original type.

![Implementation note][note-shield]

If an implementer requires more citation information, it may:

- extend the type `SimpleCitation` with additional columns mapped to existing properties of the original citation types.
- implement `CI_Citation`, `LegislationCitation` and `DocumentCitation` and create a relation from the `SimpleCitation` to the corresponding citation.

#### Properties

![Implemented][implemented-shield]

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

##### Extract primitive array

[![MT002][mt002-shield]][mt002] ![Implemented][implemented-shield]

The values of a simple high-cardinality property can be encoded by concatenating the values ​​in a string separated by a delimiter.

**Model transformation rule:**
> This rule transforms properties with maximum occurrence greater than 1 that has a known mapping to any GeoPackage data type except `BLOB` or geometry type.
>
> Given a candidate property `x` of type `B` in a class `A`, it is updated as follows:
>
> - The type of the property `x` is updated to `TEXT`.
> - The maximum multiplicity is updated to 1.
> - Remove of the property `x`, if exists, any `GeoPackage data column constraint` associated.
> - The name of the property `x` is pluralized (e.g. `type` to `types`, `activity` to `activities`).

**Instance transformation rule:**
> Values are encoded as a JSON array.
> The SQLite [json1 extension](https://www.sqlite.org/json1.html) allows applications to manage JSON content stored in a GeoPackage.

![Implementation note][note-shield]

The pluralization of the name of the property is a marker to remember the expected content.

Content constraints in extracted primitive arrays may be implemented with SQL triggers in **Extended GeoPackages**.

#### Association Roles

![Implemented][implemented-shield]

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

![Implemented][implemented-shield]

This rule can be used to modify the names of specific model elements in the application schema.

The name of the `feature table` is the name of the type (e.g. `AdministrativeUnit`).

The name of the `attribute table` is the name of the type (e.g. `SpellingOfName`).

The name of the `constraint enum` is the name of the code list or the enumeration (e.g. `AdministrativeHierarchyLevel`).

The name of the `relation table` is as follows:

- If the relation is not mandatory for both sides, the name is the name of one of the types of the relation (e.g. `AdministrativeBoundary_upperLevelUnit`) plus an underscore (`_`) plus the name of the role on that side of the relation (`admUnit`).
- If the relation is mandatory only for one side, this side provides the name of the relation (e.g `Condominium_admUnit`).
- If the relation is mandatory for both sides, the name is the roles of the relation separated by an underscore (`_`) (e.g. `boundary_admUnit`).

These names may be prefixed to avoid name collision when multiple application schemas are stored in the same GeoPackage. The prefix is the namespace prefix to be used as short form of the XML namespace of the application schema in uppercase, with hyphens (`-`) replaced by underscores (`_`) plus an underscore added at the end (e.g. `TN_RO_` is the prefix for contents from the application schema `Transport Network Roads` because `tn-ro` is its namespace prefix).

Other entities encoded in the GeoPackage that have an implementation in a well known XML namespace may use a similar strategy (e.g. `GMD_` for contents that have an implementation in _Geographic MetaData_ (`gmd`)) .

### Dataset Encoding Rule

This section describes additional rules when a specific dataset is encoded into the model converted to GeoPackage.

#### Character Encoding

![Tested][tested-shield]

The character encoding of all `TEXT` encoding in GeoPackage shall be UTF-8 or UTF-16.

SQLite stores all text as Unicode characters encoded using either UTF-8 or UTF-16 encoding.
The SQLite API contains functions which allow passing and retrieving text using either UTF-8 or UTF-16 encoding.
These functions can be freely mixed and proper conversions are performed transparently when necessary.

#### Coordinate Reference Systems

![Tested][tested-shield]

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

![Tested][tested-shield]

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

![Tested][tested-shield]

Feature tables and views with 0 rows must be dropped.
The dependent attribute tables and views must be also dropped.

This implies also to remove rows that reference them in `gpkg_contents`, `gpkg_geometry_columns`, `gpkg_data_columns`, `gpkg_metadata_reference`, `gpkgext_relations` and `gpkg_extensions`.

### Unpopulated Many-to-many Relations

![Tested][tested-shield]

Table relations tagged in `gpkg_metadata_reference` as `unpopulated` at `table` level must be dropped.

This implies also to remove rows that reference them in `gpkg_contents`, `gpkg_data_columns`, `gpkg_metadata_reference`, `gpkgext_relations` and `gpkg_extensions`.

### Unpopulated Columns

![Tested][tested-shield]

Columns tagged in `gpkg_metadata_reference` as `unpopulated` at `column` level must be dropped.

This implies also to remove rows that reference them in `gpkg_data_columns` and `gpkg_metadata_reference`.

### Implicit One-to-one Relations to Data Types

![Tested][tested-shield]

This rule is performed iteratively until no more candidates can be transformed.

The steps are:

1. Candidates are table relations that in the dataset behaves effectively as a 0:1 or 1:1 relationship instead of 1:N or N:M where one side was a `<<dataType>>` in the conceptual model and it is a simple table (henceforth, source table).
2. Source tables are flattened following the [Flattening types](#flattening-types) rule as if the maximum cardinality of the relation is `1`.
The description of the columns affected in `gpkg_data_columns` is updated with to reflect the new `table_name` and new `column_name`.
Content is copied from the columns of source table to the columns target table using the mapping information of the table relation.
3. Candidates are now table relations that in the dataset behaves effectively as a 0:1 or 1:1 relationship instead of 1:N or N:M where one side was a `<<dataType>>` in the conceptual model and it is now a simple table after a flattening.
4. If there are candidates, go to the step `2`.
5. Otherwise, there are no more tables that can be flattened. Next the candidate relations and source tables used during the iterations must be dropped if they only participated in the flattened relations.
This implies also to remove rows that reference them in `gpkg_contents`, `gpkg_data_columns`, `gpkgext_relations` and `gpkg_extensions`.

[development-shield]: https://img.shields.io/badge/-development%20version-red?style=flat
[implemented-shield]: https://img.shields.io/badge/status-implemented-brightgreen
[tested-shield]: https://img.shields.io/badge/status-tested-brightgreen
[in-progress-shield]: https://img.shields.io/badge/status-in%20progress-yellow
[pending-shield]: https://img.shields.io/badge/status-pending-red
[note-shield]: https://img.shields.io/badge/-Implementation%20note:-important

[mt001-shield]: https://img.shields.io/badge/MT001-Flattening%20of%20nested%20structures-blue
[mt002-shield]: https://img.shields.io/badge/MT002-Extract%20primitive%20array-blue
[mt005-shield]: https://img.shields.io/badge/MT005-Simple%20geographic%20name-blue
[mt007-shield]: https://img.shields.io/badge/MT007-Simple%20citation-blue
[mt008-shield]: https://img.shields.io/badge/MT008-Simplified%20codelist%20reference-blue

[mt001]: https://github.com/INSPIRE-MIF/2017.2/blob/master/model-transformations/GeneralFlattening.md
[mt002]: https://github.com/INSPIRE-MIF/2017.2/blob/master/model-transformations/ExtractPrimitiveArray.md
[mt005]: https://github.com/INSPIRE-MIF/2017.2/blob/master/model-transformations/SimpleGeographicName.md
[mt007]: https://github.com/INSPIRE-MIF/2017.2/blob/master/model-transformations/SimpleCitation.md
[mt008]: https://github.com/INSPIRE-MIF/2017.2/blob/master/model-transformations/SimpleCodelistReference.md

[gpkg-ext-schema]: http://www.geopackage.org/spec121/#extension_schema
[gpkg-ext-related]: http://docs.opengeospatial.org/is/18-000/18-000.html
