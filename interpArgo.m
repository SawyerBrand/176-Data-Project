function interpolated = interpArgo(time,depth,variable,nt,nz)
  t = time;
  z_dat = depth;
  var = variable;
  
  % discard profiles with >70% data missing
  z_dat(sum(isnan(var),2)>size(var,2)*0.7,:) = [];
  t(sum(isnan(var),2)>size(var,2)*0.7,:) = [];
  var(sum(isnan(var),2)>size(var,2)*0.7,:) = [];

  % spline interpolate in depth (only in between points, no extrapolation)
  z = linspace(min(min(z_dat)),max(max(z_dat)),nz);
  val_z = nan(size(var,1),nz);
  for i = 1:size(var,1)
    x = z_dat(i,:);
    y = var(i,:);
    x(isnan(y)) = [];
    y(isnan(y)) = [];
    s = spline(x,y,z);
    s(z>max(x)) = nan;
    s(z<min(x)) = nan;
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

