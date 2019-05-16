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
![conservative temperature plot](https://github.com/SawyerBrand/176-Data-Project/blob/master/figs/temperature_t.png)

plot for absolute salinity (color-time scale corresponds to trajectory below)
![absolute salinity plot](https://github.com/SawyerBrand/176-Data-Project/blob/master/figs/salinity_t.png)

local map of the float's trajectory with same color-time scale as shown on the other plots
![float trajectory](https://github.com/SawyerBrand/176-Data-Project/blob/master/figs/trajectory.png)


### Heat Content:

Heat Content Time Series:
![heat_image](https://user-images.githubusercontent.com/40899724/57598616-bcd87000-7508-11e9-9b16-e77b14ee5074.png)

![HeatContent2018](https://user-images.githubusercontent.com/40899724/57817253-656a1800-7733-11e9-952a-c530bbe85e75.jpg)

Above created using argo_process2.m and heat_variability.m

![HeatPhilipp](https://github.com/SawyerBrand/176-Data-Project/blob/master/figs/heatcontent.png)


![HeatPhilippUpper](https://github.com/SawyerBrand/176-Data-Project/blob/master/figs/heatcontent_upper.png)


### Salt Content:

![SaltContent2018](https://user-images.githubusercontent.com/40899724/57817263-7155da00-7733-11e9-8e62-a39dc6c8a0d3.jpg)



![fullAbsSalinity](https://user-images.githubusercontent.com/40899724/57817271-79ae1500-7733-11e9-82d7-91af934483e9.jpg)


