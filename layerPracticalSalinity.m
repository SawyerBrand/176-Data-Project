
close all
clear all

% for saving plots, need expfig package
saveplots = true;
if saveplots
  addpath('../expfig/')
end

fn = 'data/6901814_stations.nc';
savemat = false;
nt = 1000;
dz = 1;

d = create_interpolated(fn,nt,dz,savemat);

%% plot most of column
zmin = 0;
zmax = 1800;
dzlayer = 100;
depths = fliplr(-[zmin:dzlayer:zmax-dzlayer; zmin+dzlayer:dzlayer:zmax]);
nlayers = size(depths,2);
cols = parula(nlayers);
fig1 = figure;
set(fig1,'units','normalized','outerposition',[0 0 1 1])
hold on
lgdtxt = cell(1,nlayers);
minval = inf;
maxval = -inf;
for i = 1:nlayers
    pracSal = mean(d.layermeanSP(:,d.z<=depths(1,i)&d.z>depths(2,i)),2);
    plot(d.time,pracSal,'color',cols(i,:),'linewidth',1)
    lgdtxt{i} = sprintf('%dm to %dm',depths(1,i),depths(2,i));
    if min(pracSal) < minval
        minval = min(pracSal);
    end
    if max(pracSal) > maxval
        maxval = max(pracSal);
    end
end
yl = [minval - 0.1*(maxval-minval) maxval + 0.1*(maxval-minval)];
ylim(yl)
scatter(d.time,repmat(yl(1),length(d.time),1),20,hsv(length(d.time)),'filled')
thedates = {'01-Jan-2013','01-Apr-2013','01-Jul-2013',...
            '01-Oct-2013','01-Jan-2014','01-Apr-2014',...
    '01-Jul-2014','01-Oct-2014','01-Jan-2015','01-Apr-2015',...
    '01-Jul-2015','01-Oct-2015','01-Jan-2016','01-Apr-2016',...
    '01-Jul-2016','01-Oct-2016','01-Jan-2017','01-Apr-2017',...
    '01-Jul-2017','01-Oct-2017','01-Jan-2018','01-Apr-2018',...
    '01-Jul-2018','01-Oct-2018','01-Jan-2019','01-Apr-2019'};
tticks = datetime(thedates);
xticks(tticks)
xticklabels(thedates);
xtickangle(45)
grid on

title('ARGO float 6901814','fontsize',18,'interpreter','latex')
xlabel('time','fontsize',18,'interpreter','latex')
ylabel('layer average practical salinity [psu]','fontsize',18,'interpreter','latex')
lgd = legend(lgdtxt);
set(lgd,'location','northwest','fontsize',11,'interpreter','latex','color','none')
set(gca,'color','none')
if saveplots
    export_fig figs/layerMeanPracSal.png -m2 -transparent
end

% plot upper part with movmean
zmin = 0;
zmax = 300;
dzlayer = 20;
movmeandays = 90; 
depths = fliplr(-[zmin:dzlayer:zmax-dzlayer; zmin+dzlayer:dzlayer:zmax]);
nlayers = size(depths,2);
cols = parula(nlayers);
fig1 = figure;
set(fig1,'units','normalized','outerposition',[0 0 1 1])
hold on
lgdtxt = cell(1,nlayers);
dt = d.time(2)-d.time(1);
movmeannum = round(movmeandays*24/hours(dt));
minval = inf;
maxval = -inf;
for i = 1:nlayers
    pracSal = mean(d.layermeanSP(:,d.z<=depths(1,i)&d.z>depths(2,i)),2);
    pracSal = movmean(pracSal,movmeannum);
    plot(d.time,pracSal,'color',cols(i,:),'linewidth',1)
    lgdtxt{i} = sprintf('%dm to %dm',depths(1,i),depths(2,i));
    if min(pracSal) < minval
        minval = min(pracSal);
    end
    if max(pracSal) > maxval
        maxval = max(pracSal);
    end
end
yl = [minval - 0.1*(maxval-minval) maxval + 0.1*(maxval-minval)];
ylim(yl)
scatter(d.time,repmat(yl(1),length(d.time),1),20,hsv(length(d.time)),'filled')
thedates = {'01-Jan-2013','01-Apr-2013','01-Jul-2013',...
            '01-Oct-2013','01-Jan-2014','01-Apr-2014',...
    '01-Jul-2014','01-Oct-2014','01-Jan-2015','01-Apr-2015',...
    '01-Jul-2015','01-Oct-2015','01-Jan-2016','01-Apr-2016',...
    '01-Jul-2016','01-Oct-2016','01-Jan-2017','01-Apr-2017',...
    '01-Jul-2017','01-Oct-2017','01-Jan-2018','01-Apr-2018',...
    '01-Jul-2018','01-Oct-2018','01-Jan-2019','01-Apr-2019'};
tticks = datetime(thedates);
xticks(tticks)
xticklabels(thedates);
xtickangle(45)
grid on

title(sprintf('ARGO float 6901814 (moving mean: %d days)',movmeandays),...
    'fontsize',18,'interpreter','latex')
xlabel('time','fontsize',18,'interpreter','latex')
ylabel('layer average practical salinity [psu]','fontsize',18,'interpreter','latex')
lgd = legend(lgdtxt);
set(lgd,'location','northwest','fontsize',14,'interpreter','latex','color','none')
set(gca,'color','none')
if saveplots
    export_fig figs/layerMeanPracSal_upper.png -m2 -transparent
end
