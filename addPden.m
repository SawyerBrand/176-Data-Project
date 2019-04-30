function  addPden(intp,major,minor,leg)

  % hold on
  [tt, zz] = meshgrid(intp.t,intp.z);
  val = intp.val - 1000;
  [C,h] = contour(datenum(tt),zz,val',major,'k-');
  clabel(C,h,'FontSize',14,'Color','k')
  contour(datenum(tt),zz,val',minor,'k:');
  lgd = legend(leg);
  set(lgd,'fontsize',16,'location','southwest')

end

