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
  
2nd May, 2019:
Played around a bit with making better-looking trajectory. We can now infer time and location of the float directly from the plots!

2019-05-13: Added a script that interpolates all data onto an even grid with user-specified layer depth, and includes heat content for each layer. 
  
plot for conservative temperature (color-time scale corresponds to trajectory below)
![conservative temperature plot](https://github.com/SawyerBrand/176-Data-Project/blob/master/temperature_t.png)

plot for absolute salinity (color-time scale corresponds to trajectory below)
![absolute salinity plot](https://github.com/SawyerBrand/176-Data-Project/blob/master/salinity_t.png)

local map of the float's trajectory with same color-time scale as shown on the other plots
![float trajectory](https://github.com/SawyerBrand/176-Data-Project/blob/master/trajectory.png)


### Heat Content:

Heat Content Time Series:
![heat_image](https://user-images.githubusercontent.com/40899724/57598616-bcd87000-7508-11e9-9b16-e77b14ee5074.png)

0-400m Heat Content Time Series:
![0-400m Heat](https://user-images.githubusercontent.com/40899724/57598598-b0541780-7508-11e9-94f1-a806dcb1fbcd.png)

400-1200m Heat Content Time Series:
![400-1200m Heat](https://user-images.githubusercontent.com/40899724/57598604-b5b16200-7508-11e9-81a8-94133bb4ac8c.png)

1200m and below Heat Content Time Series:
![1200m Heat](https://user-images.githubusercontent.com/40899724/57598609-b813bc00-7508-11e9-8730-aa81c3047b35.png)

Above created using argo_process2.m and heat_variability.m


