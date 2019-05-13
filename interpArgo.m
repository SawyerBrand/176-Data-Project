function interpolated = interpArgo(time,depth,variable,nt,dz)
  t = time;
  z_dat = depth;
  var = variable;
  
  % discard profiles with >70% data missing
  z_dat(sum(isnan(var),2)>size(var,2)*0.7,:) = [];
  t(sum(isnan(var),2)>size(var,2)*0.7,:) = [];
  var(sum(isnan(var),2)>size(var,2)*0.7,:) = [];

  % spline interpolate in depth (only in between points, no extrapolation)
  z = -(0:dz:-min(min(z_dat)));
  val_z = nan(size(var,1),length(z));
  for i = 1:size(var,1)
    x = z_dat(i,:);
    y = var(i,:);
    x(isnan(y)) = [];
    y(isnan(y)) = [];
    s = spline(x,y,z);
    s(z>0) = nan;
    s(z<min(x)) = nan;
     % no good data above 10 meters depth, so make it uniform
    [~,zi] = min(abs(z+10));
    s(z>-10) = s(zi);
    val_z(i,:) = s;
  end

  % discard time series for each depth where >30% of data missing
  z(sum(isnan(val_z),1)>size(val_z,1)*0.3) = [];
  val_z(:,sum(isnan(val_z),1)>size(val_z,1)*0.3) = [];

  % interpolate in time
  t_int = linspace(min(t),max(t),nt);
  val = nan(nt,size(val_z,2));

  for i = 1:size(val_z,2)
    x = datenum(t);
    y = val_z(:,i);
    x(isnan(y)) = [];
    y(isnan(y)) = [];
    s = spline(x,y,datenum(t_int));
    val(:,i) = s;
  end
  
  interpolated.t = t_int;
  interpolated.z = z;
  interpolated.val = val;

end

