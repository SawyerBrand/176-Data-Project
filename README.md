# 176-Data-Project
Code used for the SIO 176 data project


30th April, 2019:
process_argo.m was used to process the netCDF files of the ARGO float. The processed files are available in zip form here in the github. 

30th April, 2019:
wrote some code to generate basic plots (due 5/2)
generate_basic_plots.m 
  uses:
  6901814_stations.nc (raw data)
  process_argo2.m (sorry I re-wrote your function because I didn't want to read in a ton of files separately)
  interpArgo.m (interpolates data in depth and time onto a regularly-spaced grid)
  plotArgo.m (creates a filled contour plot based on the interpolation grid)
  addPden.m (adds contour lines for potential density)
  
plot for conservative temperature:
![conservative temperature plot](https://github.com/SawyerBrand/176-Data-Project/blob/master/temperature.png)


plot for absolute salinity:
![absolute salinity plot](https://github.com/SawyerBrand/176-Data-Project/blob/master/salinity.png)

local map of the float's trajectory
![float trajectory](https://github.com/SawyerBrand/176-Data-Project/blob/master/argo_path.png)
