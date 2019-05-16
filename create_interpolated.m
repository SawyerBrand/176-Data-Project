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
    
    % heat and salinity
    layermeanSA = (intdat.sa(:,1:end-1) + intdat.sa(:,2:end)) ./ 2;
    layermeanP = (intdat.P(:,1:end-1) + intdat.P(:,2:end)) ./ 2;
    layermeanT = (intdat.T(:,1:end-1) + intdat.T(:,2:end)) ./ 2;
    layermeanRho = (intdat.rho(:,1:end-1) + intdat.rho(:,2:end)) ./ 2;
    layermeanCT = (intdat.ct(:,1:end-1) + intdat.ct(:,2:end)) ./ 2;
    intdat.layermeanSP = (intdat.SP(:,1:end-1) + intdat.SP(:,2:end)) ./ 2;
    intdat.layerSP = layermeanRho .* intdat.layermeanSP .* dz ./ 1000; % [kg]
    intdat.cp = gsw_cp_t_exact(layermeanSA,layermeanT,layermeanP);
    intdat.layerHeat = layermeanRho .* intdat.cp .* (layermeanCT+273.15) .* dz; % [J / m^2]
    
    % mixed layer depth
    dT = 0.1; % 0.1 deg C from surface isotherm
    Tmin = intdat.T(:,1) - dT; % minimum T threshold
    Tmax = intdat.T(:,1) + dT; % maximum T threshold
    dRho = 0.03; % 0.03 kg m^-3 potential density from surface isopycnal
    Rhomin = intdat.pden(:,1) - dRho;
    Rhomax = intdat.pden(:,1) + dRho;
    intdat.MLdepth_T = nan(size(intdat.T,1),1);
    intdat.MLdepth_rho = nan(size(intdat.T,1),1);
    % loop through times
    for i = 1:size(intdat.T,1)-1
        % loop through depth until the end of the mixed layer
        endT = false;
        endRho = false;
        for j = 1:size(intdat.T,2)-1
            % check if temperature becomes smaller than minimum or 
            % larger than maximum threshold
            if (intdat.T(i,j+1) < Tmin(i) && intdat.T(i,j) > Tmin(i)) || ...
               (intdat.T(i,j+1) > Tmax(i) && intdat.T(i,j) < Tmax(i))
                intdat.MLdepth_T(i) = intdat.z(j);
                endT = true;
            end
            % do the same for density
            if (intdat.pden(i,j+1) < Rhomin(i) && intdat.pden(i,j) > Rhomin(i)) || ...
               (intdat.pden(i,j+1) > Rhomax(i) && intdat.pden(i,j) < Rhomax(i))
                intdat.MLdepth_rho(i) = intdat.z(j);
                endRho = true;
            end
            % break out of loop if we got to both
            if endT && endRho
                break
            end
        end
    end

    if savemat
        save('data/datainterpolated.mat','intdat')
    end

end

