
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
saveplots = true;
if saveplots
  addpath('../expfig/')
end

% import data
fn = 'data/6901814_stations.nc';
data = process_argo2(fn);

%% plot Conservative Temperature
nt = 1000;
dz = 5;
ct_int = interpArgo(data.time,data.z,data.ct,nt,dz);
pden_int = interpArgo(data.time,data.z,data.pden,nt,dz);

nconts = 20;
colmap = 'jet';
tit = 'ARGO float 6901814';
fignum = 1;
plotArgo(ct_int,nconts,colmap,tit,fignum);

major = 24:0.5:28;
minor = 27.1:0.1:27.9;
minor(5) = [];
leg = {['conservative temperature [' char(176) 'C]'], 'potential density'};
addPden(pden_int,major,minor,leg)

if saveplots
  export_fig figs/temperature.png -m2
end

%% plot Absolute salinity
sa_int = interpArgo(data.time,data.z,data.sa,nt,dz);

colmap = 'parula';
tit = 'ARGO float 6901814';
fignum = 2;
plotArgo(sa_int,nconts,colmap,tit,fignum);

leg = {'absolute salinity [g/kg]', 'potential density'};
addPden(pden_int,major,minor,leg)

if saveplots
  export_fig figs/salinity.png -m2
end

%% plot trajecotry / time 
% linearly interpolate coordinates in time
nt = 8000;
[time, ia, ic] = unique(data.time);
lat = data.lat(ia);
lon = data.lon(ia);
lon(lon<0) = lon(lon<0)+360;
tinttraj = linspace(min(data.time),max(data.time),nt);
latint = interp1(time,lat,tinttraj);
lonint = interp1(time,lon,tinttraj);
lonint(lonint>180) = lonint(lonint>180) - 360;

% create world map (need mapping toolbox)
latlim = [-80 -25];
lonlim = [174 -25];
fig1 = figure(3);
set(fig1, 'Position', [0, 0, 1200, 600]);
subplot('Position',[0.1,0.18,0.8,0.6]);
ax1 = worldmap('World');
axesm('robinson','MapLatLimit',latlim,'MapLonLimit',lonlim,...
    'Frame','on','Grid','on','MeridianLabel','on','ParallelLabel','on')
axis tight
load coastlines
cols = hsv(length(tinttraj));
set(gca,'fontsize',25)
title({'ARGO float 6901814 trajectory',' '},'fontsize',28,'interpreter','latex')

% display topography (need etopo for this)
samplefactor = 5;
[Z, refvec] = etopo('etopo1_ice_c_i2.bin', samplefactor, latlim, [-180 180]);
geoshow(Z, refvec, 'DisplayType', 'texturemap');
demcmap(Z, 256);

% plot trjaectory
scatterm(latint,lonint,20,'k','filled')
scatterm(latint,lonint,8,cols,'filled')

% make custom color bar
ax2 = subplot('Position',[0.12 0.15 0.8 0.03]);
colbar = datenum(tinttraj);
colb = pcolor(colbar,1:2,[colbar;colbar]);
set(colb, 'EdgeColor', 'none');
colormap(ax2,hsv(length(tinttraj)))
tticks = {'01-Jul-2013','01-Jan-2014','01-Jul-2014','01-Jan-2015','01-Jul-2015',...
    '01-Jan-2016','01-Jul-2016','01-Jan-2017','01-Jul-2017','01-Jan-2018','01-Jul-2018','01-Jan-2019'};
xticks(datenum(tticks))
xticklabels(tticks)
yticks([])
set(gca,'layer','top','fontsize',15)
xtickangle(45)

if saveplots
  export_fig figs/trajectory.png -m2
end

%% add color scale from trajectory
figure(1)
scatter(datenum(ct_int.t),repmat(min(ct_int.z),length(ct_int.t),1),80,hsv(length(ct_int.t)),'filled')
if saveplots
  export_fig figs/temperature_t.png -m2
end
figure(2)
scatter(datenum(sa_int.t),repmat(min(sa_int.z),length(sa_int.t),1),80,hsv(length(sa_int.t)),'filled')
if saveplots
  export_fig figs/salinity_t.png -m2
end

