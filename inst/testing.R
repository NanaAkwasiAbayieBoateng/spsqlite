# Short script for testing functionalities
# to be deleted later
# Spatialite api
# http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.2.0.html#p5

library(RSQLite)
library(spsqlite)
con <- invisible(dbConnect(RSQLite::SQLite(),dbname="inst/examples/test-2.3.sqlite",loadable.extensions = TRUE))
initSpatialExtension(con)

# List Tables
dbListTables(con)

# Show the structure of Towns (point-shape)
dbGetQuery(con,"SELECT * FROM Towns LIMIT 2")
# Notice how the geometry is coded as raw bits

# Now query the same but format the geometry using spatialite functions (X,Y)
dbGetQuery(con,"SELECT Name, X(Geometry) AS Longitude, Y(Geometry) AS Latitude, SRID(Geometry) as SRID, GeometryType(Geometry) FROM Towns LIMIT 2")

# Calculate the length im m of the biggest 5 Highways
dbGetQuery(con,"SELECT Name, Length(Geometry) as length FROM HighWays ORDER BY length DESC LIMIT 5")

# Or the total area of all regions in Italy
dbGetQuery(con,"SELECT Name, Sum(Area(Geometry))  FROM Regions")

# It is also possible to open spatialobjects with rgdal given that spatiallite is enabled
library(rgdal)

ogrListLayers("data/test-2.3.sqlite")
ogrInfo("data/test-2.3.sqlite","Towns")
OGRSpatialRef("data/test-2.3.sqlite","Towns")

towns <- readOGR(dsn = "data/test-2.3.sqlite",layer = "Towns")

# Strangley writing does not work for me ?
towns_big <- subset(towns,Peoples>500000)
writeOGR(obj = towns_big,dsn = "data/test-2.3.sqlite",layer = "towns_big",driver = "SQLite",overwrite_layer = TRUE,dataset_options=c("SPATIALITE=yes"))
