
close all
clear all

% for saving plots, need expfig package
saveplots = true;
if saveplots
  addpath('../expfig/')
end

fn = 'data/6901814_stations.nc';
savemat = false;
nt = 500;
dz = 5;

d = create_interpolated(fn,nt,dz,savemat);

%% plot Mixed Layer depth

movmeandays = 90;
dt = d.time(2)-d.time(1);
movmeannum = round(movmeandays*24/hours(dt));

fig1 = figure;
set(fig1,'units','normalized','outerposition',[0 0 1 1])
hold on
zT = d.MLdepth_T;
zT2 = movmean(d.MLdepth_T,movmeannum);
zR = d.MLdepth_rho;
zR2 = movmean(d.MLdepth_rho,movmeannum);
plot(d.time,zT,'color',[0.6 0.6 1],...
    'linewidth',1,'linestyle','--')
plot(d.time,zT2,'color',[0 0 0.6],...
    'linewidth',3,'linestyle','-')
plot(d.time,zR,'color',[1 0.6 0.6],...
    'linewidth',1,'linestyle','--')
plot(d.time,zR2,'color',[0.6 0 0],...
    'linewidth',3,'linestyle','-')
yl = [1.1*min([zT;zT2;zR;zR2]) 0];
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
ylabel('mixed layer depth $z^{(ML)}$ [m]','fontsize',18,'interpreter','latex')
movtxt = sprintf(' %d-day moving mean',movmeandays);
l1 = '$\vert T^{(surf)}-T(z^{(ML)}) \vert < 0.1^\circ$ C';
l2 = '$\vert \sigma_0^{(surf)}-\sigma_0(z^{(ML)}) \vert = 0.03$ kg m$^{-3}$';
lgd = legend(l1, ['temperature mixed layer' movtxt], l2, ['potential density mixed layer' movtxt]);
set(lgd,'location','southeast','fontsize',14,'interpreter','latex','color','none')
set(gca,'color','none')
if saveplots
    export_fig figs/MLdepth.png -m2 -transparent
end
