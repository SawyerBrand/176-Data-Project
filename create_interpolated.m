function intdat = create_interpolated(fn,nt,dz,savemat)
%CREATE_INTERPOLATED get data onto evenly spaced grid
%   input:
%     - fn: file name of netcdf argo data file
%     - nt: number of time steps to interpolate onto
%     - dz: depth step size in meters, for interpolation
%     - savemat: whether to save data into a matfile

    % add path for TEOS routines
    addpath(genpath('../GSW/'));

    % import data
    data = process_argo2(fn);

    % interpolate basic data
    salnint = interpArgo(data.time,data.z,data.SP,nt,dz);
    tempint = interpArgo(data.time,data.z,data.T,nt,dz);
    presint = interpArgo(data.time,data.z,data.P,nt,dz);

    [time, ia, ~] = unique(data.time);
    lat = data.lat(ia);
    lon = data.lon(ia);
    lon(lon<0) = lon(lon<0)+360;
    tinttraj = linspace(min(data.time),max(data.time),nt);
    latint = interp1(time,lat,tinttraj);
    lonint = interp1(time,lon,tinttraj);
    lonint(lonint>180) = lonint(lonint>180) - 360;

    % create interpolated data struct
    intdat.time = salnint.t';
    intdat.lat = latint';
    intdat.lon = lonint';
    intdat.z = salnint.z;
    intdat.dz = dz;
    intdat.SP = salnint.val;
    intdat.T = tempint.val;
    intdat.P = presint.val;
    [intdat.sa, intdat.sstar, intdat.in_ocean] = ...
        gsw_SA_Sstar_from_SP(intdat.SP, intdat.P, intdat.lon, intdat.lat);
    intdat.pt = gsw_pt_from_t(intdat.sa, intdat.T, intdat.P, 0);
    intdat.ct = gsw_CT_from_t(intdat.sa, intdat.T, intdat.P);
    intdat.pden = gsw_rho(intdat.sa, intdat.ct, 0);
    intdat.rho = gsw_rho(intdat.sa, intdat.ct, intdat.P);
    layermeanSA = (intdat.sa(:,1:end-1) + intdat.sa(:,2:end)) ./ 2;
    layermeanP = (intdat.P(:,1:end-1) + intdat.P(:,2:end)) ./ 2;
    layermeanT = (intdat.T(:,1:end-1) + intdat.T(:,2:end)) ./ 2;
    layermeanRho = (intdat.rho(:,1:end-1) + intdat.rho(:,2:end)) ./ 2;
    intdat.cp = gsw_cp_t_exact(layermeanSA,layermeanT,layermeanP);
    intdat.layerHeat = layermeanRho .* intdat.cp .* (layermeanT+273.15) .* dz; % [J / m^2]

    if savemat
        save datainterpolated intdat
    end

end

