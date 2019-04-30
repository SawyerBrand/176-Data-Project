function process_argo(filename)
%this function was made to process an argo float profile (single profile) which was downloaded in the netCDF format

outfile = ['Profile230_6901814.mat'];
%change the name of the outfile for every profile you use

F_Variable   = fullfile(filename); %allows you to open the file
 
% Read the variables in the netcdf (.nc) file and saves them under the struct Data
varnames = {};
ncid = netcdf.open(F_Variable,'NC_NOWRITE');
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);
for i = 1:numvars
   [varnames{i}, xtype, varDimIDs, varAtts] = netcdf.inqVar(ncid,i-1);
   Data.([varnames{i}]) = netcdf.getVar(ncid,i-1);
end
netcdf.close(ncid);

%we want to rename pres, temp, and psal to be easy to call variables under a new struct which is east to access
Final.Pres = Data.PRES(:,1); %chose to use the nonadjusted vairables because they had all values of 99999
Final.Temp = Data.TEMP(:,1);
Final.Sal = Data.PSAL(:,1);

%the following variables are needed to use the specific gsw functions we want to use
size = length(Final.Sal);
Final.Lat(1:size,1:1) = Data.LATITUDE(1,1);
Final.Lon(1:size,1:1) = Data.LONGITUDE(1,1);

%now use the gsw functions to find the new variables we want, also under the same struct 
[Final.SA, Data.Sstar, Data.in_ocean] = gsw_SA_Sstar_from_SP(Final.Sal,Final.Pres,Final.Lon,Final.Lat);
Final.PT = gsw_pt_from_t(Final.SA,Final.Temp,Final.Pres);
Final.CT = gsw_CT_from_pt(Final.SA,Final.PT);

save(outfile)
