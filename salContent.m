
close all
clear all

% for saving plots, need expfig package
saveplots = true;
if saveplots
  addpath('../expfig/')
end

fn = 'data/6901814_stations.nc';
savemat = true;
nt = 500;
dz = 5;

d = create_interpolated(fn,nt,dz,savemat);


%% plot
zmin = 0;
zmax = 1800;
dzlayer = 100;
depths = fliplr(-[zmin:dzlayer:zmax-dzlayer; zmin+dzlayer:dzlayer:zmax]);
nlayers = size(depths,2);
salLayers = nan(nlayers,1);
cols = jet(nlayers);
fig1 = figure;
set(fig1,'units','normalized','outerposition',[0 0 1 1])
hold on
lgdtxt = cell(1,nlayers);
for i = 1:nlayers
    salt = sum(d.sa(:,d.z<=depths(1,i)&d.z>depths(2,i)),2);
    plot(d.time,salt,'color',cols(i,:),'linewidth',1)
    lgdtxt{i} = sprintf('%dm to %dm',depths(1,i),depths(2,i));
end
title('ARGO float 6901814','fontsize',18,'interpreter','latex')
xlabel('time','fontsize',14,'interpreter','latex')
ylabel('depth-integrated absolute salinity [k/kg]','fontsize',14,'interpreter','latex')
lgd = legend(lgdtxt);
set(lgd,'location','northwest','fontsize',10,'interpreter','latex')

if saveplots
    export_fig figs/saltcontent.png -m2
end  
