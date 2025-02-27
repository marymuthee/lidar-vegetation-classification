#we first set the working directory
#a woking directory enables us to easily access our files
#and also ensures any output is saved to the directory directly
setwd("E:/Doug/Mineral King boundary shapefile")

#we get the working directory. Ensures that we are inside that folder
getwd()

#lists all files inside the directory
dir()

#save temporary files on external device to save on space
Sys.setenv(TMPDIR = "E:/temp")  #sefines the external path
.libPaths(c("C:/Users/PC/Documents/R/win-library/4.1", "C:/Program Files/R/R-4.1.1/library")) #ensures that the libraries path is maintaned
unlockBinding("tempdir", baseenv()) #we unlock the temporary directory(default one so as to change it)
assign("tempdir", function() Sys.getenv("TMPDIR"), envir = baseenv()) #we change the default temporary directory to an external one
lockBinding("tempdir", baseenv()) #we close the path
tempdir()  #we get the new temporary directory path -to confirm if it s well set
memory.limit(size = 16000)  # I increased the limit size for my case (since it give me an error on space limit)

#how to install the libraries or packages
#install.packages('lidR')

#activate libraries
library(lidR)  #for processing lidar data
library(terra)  #for processing raster layers- new package
library(raster) #for processing raster layers- old package


#import data
#readLAS is a function under lidR package that is used to import the point cloud data
las634<-readLAS("USGS_LPC_CA_SierraNevada_B22_11SLA5634.laz")
las635<-readLAS("USGS_LPC_CA_SierraNevada_B22_11SLA5635 (2).laz")
las734<-readLAS("USGS_LPC_CA_SierraNevada_B22_11SLA5734.laz")
las735<-readLAS("USGS_LPC_CA_SierraNevada_B22_11SLA5735.laz")
dsm634<-rast("DSM634_0.3m.tif")
dtm634<-rast("DTM634_0.3m.tif")
chm635<-rast("CHM635.tif")
chm634<-rast("CHM634.tif")
chm734<-rast("CHM734.tif")
chm735<-rast("CHM735.tif")


######LAYER 634
# Check available classes
unique(las634$Classification)

#generate DSM using all the classes
dsm634<- rasterize_canopy(las634, res = 0.3, pitfree())

#generate DTM
# Load and filter ground points (Class 2)
las634_ground <- filter_poi(las634, Classification == 2)

# Generate DTM using TIN (recommended)
dtm634 <- rasterize_terrain(las634_ground, res = 0.3, tin())

#generate Canopy height Model(CHM)
chm634<-dsm634-dtm634

#convert to Raster Layer for plotting purpose
raster_chm634<-raster(chm634)
plot(raster_chm634)

#export the CHM
writeRaster(chm634, "CHM634.tif", overwrite = TRUE)



########LAS 635
# Check available classes
unique(las635$Classification)

#generate DSM using all the classes
dsm635<- rasterize_canopy(las635, res = 0.3, pitfree())
writeRaster(dsm635, "DSM635.tif", overwrite = TRUE)
#generate DTM
# Load and filter ground points (Class 1)
las635_ground <- filter_poi(las635, Classification == 2)

# Generate DTM using TIN (recommended)
dtm635 <- rasterize_terrain(las635_ground, res = 0.3, tin())
writeRaster(dtm635, "DTM635.tif", overwrite = TRUE)

#generate Canopy height Model(CHM)
chm635<-dsm635-dtm635

#export the CHM
writeRaster(chm635, "CHM635.tif", overwrite = TRUE)

#convert to Raster Layer for plotting purpose
raster_chm635<-raster(chm635)
plot(raster_chm635)


######LAYER 734
# Check available classes
unique(las734$Classification)

#generate DSM using all the classes
dsm734<- rasterize_canopy(las734, res = 0.3, pitfree())
writeRaster(dsm734, "DSM734.tif", overwrite = TRUE)
#generate DTM
# Load and filter ground points (Class 1)
las734_ground <- filter_poi(las734, Classification == 2)

# Generate DTM using TIN (recommended)
dtm734 <- rasterize_terrain(las734_ground, res = 0.3, tin())
writeRaster(dtm734, "DTM734.tif", overwrite = TRUE)
#generate Canopy height Model(CHM)
chm734<-dsm734-dtm734
#export the CHM
writeRaster(chm734, "CHM734.tif", overwrite = TRUE)

#convert to Raster Layer for plotting purpose
library(raster)
raster_chm734<-raster(chm734)
plot(raster_chm734)


######735
######LAYER 734
# Check available classes
unique(las735$Classification)

#generate DSM using all the classes
dsm735<- rasterize_canopy(las735, res = 0.3, pitfree())
writeRaster(dsm735, "DSM735.tif", overwrite = TRUE)
#generate DTM
# Load and filter ground points (Class 2)
las735_ground <- filter_poi(las735, Classification == 2)

# Generate DTM using TIN 
dtm735 <- rasterize_terrain(las735_ground, res = 0.3, tin())
writeRaster(dtm735, "DTM735.tif", overwrite = TRUE)
#generate Canopy height Model(CHM)
chm735<-dsm735-dtm735
#export the CHM
writeRaster(chm735, "CHM735.tif", overwrite = TRUE)

#convert to Raster Layer for plotting purpose
library(raster)
raster_chm735<-raster(chm735)
plot(raster_chm735)


####perfoming vegetation classification
##634 layer
#define the new classification classes
reclass_df <- c(-Inf, 1, 0,  # Values less than 1 -> 0
               1, 3, 1,     # Values from 1 to 3 -> 1
               3, Inf, 2)   # Values greater than 3 -> 2


# Now we will create a matrix by specifying the columns
reclass_m <- matrix(reclass_df,
                    ncol = 3,
                    byrow = TRUE)


# Reclassify our data.
#conver the chm634 from SPatRaster to Raster layer
chm634_raster<-raster(chm634)
chm634_classfied <- reclassify(chm634_raster,reclass_m)


#plot a bar graph to show distribution of pixels in each class
#basically helps to identify the class with many pixels represnted
barplot(chm634_classfied, 
        main = "Number of pixels in each values",
        xlab = "Classes",
        ylab = "No of Pixels")


#adding the custom labels
# Adjust margins to create space on the right for the legend
par(mar = c(5, 4, 4, 6))  # Increase right margin (last value)

# Plot the raster without the legend
plot(chm634_classfied,
     legend = FALSE,
     col = c("grey", "red", "green"),
     axes = FALSE,
     main = "Classified Canopy Height Model")

# Define colors
chm_colors <- c("grey", "red", "green")

# Add the legend outside the plot area
legend("topright",
       inset = c(-0.2, 0),   # Negative x-inset moves legend outside right border
       legend = c("Herbaceous", "Shrubs", "Trees"),
       fill = chm_colors,
       border = FALSE,
       bty = "n",           # No border
       xpd = TRUE           # Allow plotting outside the plot area
)


writeRaster(chm634_classfied,'chm634_classified.tif')


##635 layer
#define the new classification classes
reclass_df <- c(-Inf, 0.75, 0,  # Values less than 1 -> 0
                0.75, 3, 1,     # Values from 1 to 3 -> 1
                3, Inf, 2)   # Values greater than 3 -> 2


# Now we will create a matrix by specifying the columns
reclass_m <- matrix(reclass_df,
                    ncol = 3,
                    byrow = TRUE)


# Reclassify our data.
#conver the chm634 from SPatRaster to Raster layer
chm635_raster<-raster(chm635)
chm635_classfied <- reclassify(chm635_raster,reclass_m)


#plot a bar graph to show distribution of pixels in each class
#basically helps to identify the class with many pixels represnted
barplot(chm635_classfied, 
        main = "Number of pixels in each values",
        xlab = "Classes",
        ylab = "No of Pixels")


#adding the custom labels
# Adjust margins to create space on the right for the legend
par(mar = c(5, 4, 4, 6))  # Increase right margin (last value)

# Plot the raster without the legend
plot(chm635_classfied,
     legend = FALSE,
     col = c("grey", "red", "green"),
     axes = FALSE,
     main = "Classified Canopy Height Model")

# Define colors
chm_colors <- c("grey", "red", "green")

# Add the legend outside the plot area
legend("topright",
       inset = c(-0.2, 0),   # Negative x-inset moves legend outside right border
       legend = c("Herbaceous", "Shrubs", "Trees"),
       fill = chm_colors,
       border = FALSE,
       bty = "n",           # No border
       xpd = TRUE           # Allow plotting outside the plot area
)


writeRaster(chm635_classfied,'chm635_classified.tif')


##734 layer
#define the new classification classes
reclass_df <- c(-Inf, 1, 0,  # Values less than 1 -> 0
                1, 3, 1,     # Values from 1 to 3 -> 1
                3, Inf, 2)   # Values greater than 3 -> 2


# Now we will create a matrix by specifying the columns
reclass_m <- matrix(reclass_df,
                    ncol = 3,
                    byrow = TRUE)


# Reclassify our data.
#conver the chm634 from SPatRaster to Raster layer
chm734_raster<-raster(chm734)
chm734_classfied <- reclassify(chm734_raster,reclass_m)


#plot a bar graph to show distribution of pixels in each class
#basically helps to identify the class with many pixels represnted
barplot(chm734_classfied, 
        main = "Number of pixels in each values",
        xlab = "Classes",
        ylab = "No of Pixels")


#adding the custom labels
# Adjust margins to create space on the right for the legend
par(mar = c(5, 4, 4, 6))  # Increase right margin (last value)

# Plot the raster without the legend
plot(chm734_classfied,
     legend = FALSE,
     col = c("grey", "red", "green"),
     axes = FALSE,
     main = "Classified Canopy Height Model")

# Define colors
chm_colors <- c("grey", "red", "green")

# Add the legend outside the plot area
legend("topright",
       inset = c(-0.2, 0),   # Negative x-inset moves legend outside right border
       legend = c("Herbaceous", "Shrubs", "Trees"),
       fill = chm_colors,
       border = FALSE,
       bty = "n",           # No border
       xpd = TRUE           # Allow plotting outside the plot area
)


writeRaster(chm734_classfied,'chm734_classified.tif')

##735 layer
#define the new classification classes
reclass_df <- c(-Inf, 1, 0,  # Values less than 1 -> 0
                1, 3, 1,     # Values from 1 to 3 -> 1
                3, Inf, 2)   # Values greater than 3 -> 2


# Now we will create a matrix by specifying the columns
reclass_m <- matrix(reclass_df,
                    ncol = 3,
                    byrow = TRUE)


# Reclassify our data.
#conver the chm634 from SPatRaster to Raster layer
chm735_raster<-raster(chm735)
chm735_classfied <- reclassify(chm735_raster,reclass_m)


#plot a bar graph to show distribution of pixels in each class
#basically helps to identify the class with many pixels represnted
barplot(chm735_classfied, 
        main = "Number of pixels in each values",
        xlab = "Classes",
        ylab = "No of Pixels")


#adding the custom labels
# Adjust margins to create space on the right for the legend
par(mar = c(5, 4, 4, 6))  # Increase right margin (last value)

# Plot the raster without the legend
plot(chm735_classfied,
     legend = FALSE,
     col = c("grey", "red", "green"),
     axes = FALSE,
     main = "Classified Canopy Height Model")

# Define colors
chm_colors <- c("grey", "red", "green")

# Add the legend outside the plot area
legend("topright",
       inset = c(-0.2, 0),   # Negative x-inset moves legend outside right border
       legend = c("Herbaceous", "Shrubs", "Trees"),
       fill = chm_colors,
       border = FALSE,
       bty = "n",           # No border
       xpd = TRUE           # Allow plotting outside the plot area
)


writeRaster(chm735_classfied,'chm735_classified.tif')
