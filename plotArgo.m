function plotArgo(intp,nconts,cmap,tit,fignum)

  [tt, zz] = meshgrid(intp.t,intp.z);
  val = intp.val;

  fig1 = figure(fignum);
  eval(['colormap(' cmap '(' num2str(500) '));'])
  cmp = jet(nconts+1);
  set(fig1,'units','normalized','outerposition',[0 0 1 1])
  hold on
 % h = pcolor(datenum(tt),zz,val');
  %set(h, 'EdgeColor', 'none');
  contourf(datenum(tt),zz,val',nconts,'color',[0.5 0.5 0.5])
  tticks = datenum({'01-Jul-2013','01-Jan-2014','01-Jul-2014','01-Jan-2015','01-Jul-2015',...
    '01-Jan-2016','01-Jul-2016','01-Jan-2017','01-Jul-2017','01-Jan-2018','01-Jul-2018','01-Jan-2019'});
  xticks(tticks)
  datetick('x', 'dd-mmm-yyyy',  'keepticks');
  xtickangle(45)
  colorbar
  xlim(datenum([min(intp.t) max(intp.t)]))
  ylim([min(intp.z) max(intp.z)])
  caxis([min(min(val)) max(max(val))])
  set(gca,'fontsize',15)
  title(tit,'fontsize',20)
  ylabel('depth [m]','fontsize',20)
  xlabel('time','fontsize',20)
  set(gca, 'Layer','top')
end

