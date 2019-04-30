
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Argo Project                         %%%%%
%%%%% UCSD / SIO 176                       %%%%%
%%%%% observational Physical Oceanography  %%%%%
%%%%% Philipp Arndt                        %%%%%
%%%%% April 2019                           %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all 
clear all

% add path for TEOS routines
addpath(genpath('../GSW/'));

% for saving plots, need expfig package
saveplots = false;
if saveplots
  addpath('../expfig/')
end

% import data
fn = '6901814_stations.nc';
data = process_argo2(fn);

%% plot Conservative Temperature
nt = 1000;
nz = 600;
ct_int = interpArgo(data.time,data.z,data.ct,nt,nz);
pden_int = interpArgo(data.time,data.z,data.pden,nt,nz);

nconts = 20;
colmap = 'jet';
tit = 'ARGO float 6901814';
plotArgo(ct_int,nconts,colmap,tit);

major = 24:0.5:28;
minor = 27.1:0.1:27.9;
minor(5) = [];
leg = {['conservative temperature [' char(176) 'C]'], 'potential density'};
addPden(pden_int,major,minor,leg)

if saveplots
  export_fig temperature.png -m2
end

%% plot Absolute salinity
sa_int = interpArgo(data.time,data.z,data.sa,nt,nz);

colmap = 'parula';
tit = 'ARGO float 6901814';
plotArgo(sa_int,nconts,colmap,tit);

leg = {'absolute salinity [g/kg]', 'potential density'};
addPden(pden_int,major,minor,leg)

if saveplots
  export_fig salinity.png -m2
end




