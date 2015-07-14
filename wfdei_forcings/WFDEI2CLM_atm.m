
% script for converting WFDEI forcing data to CLM 4.5 compatible netcdf
% file


% open CLM CRUNCEP forcing file as template
% template = 'C:\Users\Dommi\Desktop\WFDEI_sample\Rainf_WFDEI_CRU\clmforc.cruncep.V4.c2011.0.5d.Prec.2010-12.nc';
% temp_info = ncinfo(template);
% ncid = netcdf.open(template);

% datatest =
% tmp = ncread('F:\Users\lrains\CLM_Forcings\CRUNCEP_Forcing_sample\clmforc.cruncep.V4.c2011.0.5d.TPQWL.2010-12.nc','PSRF');
% cd('C:\Users\Dommi\Desktop\WFDEI_sample\Rainf_WFDEI_CRU');

cd('F:\Users\lrains\CLM_Forcings\WFDEI_Forcing\__WFDEI_CLM\_extracted\PSurf_Qair_Wind_LW_WFDEI');

%cd('C:\Users\Dommi\Desktop\water_dl\wfdei');

% loop over all files in directory
files1 = dir('Wind_WFDEI_*.nc');   % wind
files2 = dir('Qair_WFDEI_*.nc');   % specific humidity
files3 = dir('Psurf_WFDEI_*.nc');  % pressure
files4 = dir('Tair_WFDEI_*.nc');   % temperature
files5 = dir('LWdown_WFDEI_*.nc'); % Longwave

% filen1 = files1(1).name;

i=0;

for file = files1'
    filen1 = file.name;
    
    i=i+1;
    filen2 = files2(i).name;
    filen3 = files3(i).name;
    filen4 = files4(i).name;
    filen5 = files5(i).name;
    
    % open netcdf
    data1 = ncread(filen1,'Wind');
    data2 = ncread(filen2,'Qair');
    data3 = ncread(filen3,'PSurf');
    data4 = ncread(filen4,'Tair');
    data5 = ncread(filen5,'LWdown');
    
   
    data1l = data1(1:360,:,:);
    data1r = data1(361:720,:,:);
    data1 = cat(1,data1r,data1l);
    
    data2l = data2(1:360,:,:);
    data2r = data2(361:720,:,:);
    data2 = cat(1,data2r,data2l);
    
    data3l = data3(1:360,:,:);
    data3r = data3(361:720,:,:);
    data3 = cat(1,data3r,data3l);
    
    data4l = data4(1:360,:,:);
    data4r = data4(361:720,:,:);
    data4 = cat(1,data4r,data4l);
    
    data5l = data5(1:360,:,:);
    data5r = data5(361:720,:,:);
    data5 = cat(1,data5r,data5l);
    
    
      
    ind = data1 == 100000002004087730000.000000;
    data1(ind) = 100;
    
    ind = isnan(data2);
    data2(ind) = 0.01; 
    
    ind = data3 == 100000002004087730000.0;
    data3(ind) = 50000; 
    
    ind = data4 == 100000002004087730000.0;
    data4(ind) = 270;        
    
    ind = isnan(data5);
    data5(ind) = 250;    
    
    % create time attribute value
    tattrib = ['days since ',filen1(12:15),'-',filen1(16:17),'-01 ','00:00:00'];
    
    tlength = size(data2);
    tlength = tlength(3);
    
    % time = linspace(1, tlength, tlength);
    % time = time -1;
    % time = time * 3;
    % time = time + 6;
    
    time = linspace(1, tlength, tlength);
    time = time / 8;
    time = time - (0.125 / 2);
    
    latitude  = linspace(1, 360, 360);
    latitude  = (latitude / 2) - 90.25;
    longitude = linspace(1, 720, 720);
    longitude = (longitude / 2);% - 180.25;  
    
    latitude  = single(latitude);
    longitude = single(longitude);
    
    % create output netcdf
    fileout = strcat('TPQWL_WFDEI ',filen1(11:end-3),'_CLM.nc');
    ncid = netcdf.create(fileout,'NC_WRITE');
    
    tid    = netcdf.defDim(ncid,'time',tlength);
    latid  = netcdf.defDim(ncid,'lat',360);
    lonid  = netcdf.defDim(ncid,'lon',720);
    
    varid1 = netcdf.defVar(ncid,'WIND','float',[lonid,latid,tid]);   % W
    varid2 = netcdf.defVar(ncid,'QBOT','float',[lonid,latid,tid]);   % Q
    varid3 = netcdf.defVar(ncid,'PSRF','float',[lonid,latid,tid]);   % P
    varid4 = netcdf.defVar(ncid,'TBOT','float',[lonid,latid,tid]);   % Temp
    varid5 = netcdf.defVar(ncid,'FLDS','float',[lonid,latid,tid]);   % LW
    
    timev = netcdf.defVar(ncid,'time','float',tid);
    latv  = netcdf.defVar(ncid,'lat','float',latid);
    lonv  = netcdf.defVar(ncid,'lon','float',lonid);
     
    netcdf.putAtt(ncid,timev,'units',tattrib);
    netcdf.putAtt(ncid,timev,'calendar','gregorian');
    
    % units for forcing variables
    netcdf.putAtt(ncid,varid1,'units','m/s');
    netcdf.putAtt(ncid,varid2,'units','kg/kg');
    netcdf.putAtt(ncid,varid3,'units','Pa');
    netcdf.putAtt(ncid,varid4,'units','K');
    netcdf.putAtt(ncid,varid5,'units','W/m**2');    
          
    netcdf.endDef(ncid);
    netcdf.putVar(ncid,timev,time);
    netcdf.putVar(ncid,latv,latitude);
    netcdf.putVar(ncid,lonv,longitude);

    netcdf.putVar(ncid,varid1,data1); 
    netcdf.putVar(ncid,varid2,data2);
    netcdf.putVar(ncid,varid3,data3);
    netcdf.putVar(ncid,varid4,data4);
    netcdf.putVar(ncid,varid5,data5);
    
    netcdf.close(ncid);
end