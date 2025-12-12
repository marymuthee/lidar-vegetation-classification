# Canopy Height Model Derivation and Vegetation Structure Classification Using Airborne LiDAR

## Overview

This project documents an airborne LiDAR–based workflow for deriving Canopy Height Models (CHMs) and classifying vegetation structure into herbaceous cover, shrubs, and trees. The analysis is implemented in R using the `lidR`, `terra`, and `raster` packages and is applied to multiple LiDAR tiles covering the Mineral King area, California.

The workflow demonstrates standard LiDAR processing steps including Digital Surface Model (DSM) generation, Digital Terrain Model (DTM) extraction, CHM computation, and rule-based vegetation classification.

## Data Description

The input data consist of multiple airborne LiDAR point cloud tiles in LAZ format acquired from the USGS LiDAR Point Cloud (LPC) dataset. Each tile contains classified point cloud data, including ground points (classification code 2).

Raster products used or generated include:

- Digital Surface Models (DSM) at 0.3 m resolution  
- Digital Terrain Models (DTM) at 0.3 m resolution  
- Canopy Height Models (CHM), derived as DSM minus DTM  

Each LiDAR tile is processed independently to ensure consistency and manageable memory usage.

## LiDAR Processing Workflow

### Digital Surface Model (DSM)

For each LiDAR tile, a DSM is generated using all available point classes. The `rasterize_canopy()` function from the `lidR` package is used with the pit-free algorithm to reduce interpolation artefacts and represent the upper canopy surface.

### Digital Terrain Model (DTM)

Ground points are extracted by filtering the point cloud using the standard ground classification (Class 2). A DTM is then generated using a Triangulated Irregular Network (TIN) interpolation, which is well suited for terrain modelling in complex landscapes.

### Canopy Height Model (CHM)

The Canopy Height Model is computed by subtracting the DTM from the DSM:

CHM = DSM − DTM

The resulting raster represents vegetation height above ground and forms the basis for subsequent vegetation structure classification.

## Vegetation Structure Classification

Vegetation structure is classified using rule-based reclassification of CHM values. Height thresholds are applied to assign each pixel to one of three vegetation classes:

- Herbaceous vegetation  
- Shrubs  
- Trees  

Thresholds are adjusted slightly between tiles to account for local variability and point density. Reclassification is performed using raster-based rules, and the output is a categorical raster representing vegetation structure.

Pixel counts for each class are visualised using bar plots to provide a simple quantitative summary of class distribution.

## Visualisation and Outputs

For each tile, the workflow produces:

- CHM raster visualisations  
- Classified vegetation structure maps  
- Bar plots showing pixel distribution per vegetation class  

Final classified rasters are exported as GeoTIFF files for use in GIS software or further spatial analysis.

## Computational Considerations

Due to the size of LiDAR datasets, the workflow includes:

- Custom temporary directory configuration to manage disk usage  
- Explicit memory allocation adjustments  
- Tile-by-tile processing to reduce memory overhead  

These steps ensure stable execution on systems with limited internal storage.

## Applications

This workflow supports:

- Forest structure and canopy analysis  
- Vegetation height mapping  
- Ecosystem and habitat assessment  
- Preparation of LiDAR-derived products for ecological or remote sensing studies  

The approach is transferable to other LiDAR datasets with standard classification schemes.

## Author

Mary Muthee  
Geospatial Data Scientist  
Copernicus Master in Digital Earth
