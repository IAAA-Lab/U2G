# UML 2 GeoPackage: alternative encoding for the INSPIRE ecosystem

[![CC BY 4.0][cc-by-shield]][cc-by] ![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/IAAA-Lab/U2G)

GeoPackage may serve as an alternative or additional encoding for complex and large INSPIRE data sets.
This Repository contains a [UML-to-GeoPackage encoding rule](GeoPackage/geopackage-encoding-rule.md) based on the results of [Action 2017.2 on alternative encodings](https://webgate.ec.europa.eu/fpfis/wikis/pages/viewpage.action?pageId=277742184).
The documents of this work are based on the repository [INSPIRE-MIF 2017.2](https://github.com/INSPIRE-MIF/2017.2).
This Repository contains an [INSPIRE UML-to-GeoPackage encoding rule](GeoPackage/geopackage-encoding-rule.md) (*status: draft; hierarchies in progress*) and the following application schemas:

| Theme | Application schema | UML Model | GeoPackage file | SQL dump
| ----- | ------------------ | --------- | --------------- | --------
| Administrative Units | Administrative Units | [model](http://inspire.ec.europa.eu/data-model/approved/r4618-ir/html/index.htm?goto=2:1:2:1:7106) |  [au.gpkg](https://github.com/IAAA-Lab/U2G/releases/download/v0.6-beta/inspire-u2g-v0.6-beta.zip) | [au.sql](GeoPackage/annex-I/administrative-units/au.sql)
| Geographical Names | Geographical Names | [model](https://inspire.ec.europa.eu/data-model/approved/r4618-ir/html/index.htm?goto=2:1:6:2:7240) |  [gn.gpkg](https://github.com/IAAA-Lab/U2G/releases/download/v0.6-beta/inspire-u2g-v0.6-beta.zip) | [gn.sql](GeoPackage/annex-I/geographical-names/gn.sql)

## Credits

The work of this Respository is licensed under a [Creative Commons Attribution 4.0 International License][cc-by].

Except where otherwise noted, this content is published under a [CC BY license][cc-by], which means that you can copy, redistribute, remix, transform and build upon the content for any purpose even commercially as long as you give appropriate credit and provide a link to the license.

Recommended attribution:

> "UML 2 GeoPackage: alternative encoding for the INSPIRE ecosystem" by Francisco J. Lopez-Pellicer (IAAA Lab) is licensed under CC BY 4.0. Available at
> <https://github.com/IAAA-Lab/U2G/blob/master/README.md>

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg
[version]: v0.5-beta
