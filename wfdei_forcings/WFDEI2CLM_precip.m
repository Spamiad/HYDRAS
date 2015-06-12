
% script for converting WFDEI forcing data to CLM 4.5 compatible netcdf
% file


% open CLM CRUNCEP forcing file as template
% template = 'C:\Users\Dommi\Desktop\WFDEI_sample\Rainf_WFDEI_CRU\clmforc.cruncep.V4.c2011.0.5d.Prec.2010-12.nc';
% temp_info = ncinfo(template);
% ncid = netcdf.open(template);

% datatest =
% ncread('C:\Users\Dommi\Desktop\WFDEI_sample\Rainf_WFDEI_CRU\clmforc.cruncep.V4.c2011.0.5d.Prec.2010-12.nc','PRECTmms');
% cd('C:\Users\Dommi\Desktop\WFDEI_sample\Rainf_WFDEI_CRU');
cd('F:\Users\lrains\CLM_Forcings\WFDEI_Forcing\__WFDEI_CLM\_extracted\Rainf_Snowf_WFDEI_CRU');

i=0;

% loop over all files in directory
files1 = dir('Rainf*.nc');
files2 = dir('Snowf*.nc');
% file = files(1).name;

for file = files1'
    filen1 = file.name;
    
    i=i+1;
    filen2 = files2(i).name;
    
    % open netcdf
    data1 = ncread(filen1,'Rainf');
    data2 = ncread(filen2,'Snowf');
        
    ind = data1 == 100000002004087730000.000000;
    data1(ind) = 0;
        
    ind = data2 == 100000002004087730000.000000;
    data2(ind) = 0;    
    
    data = data1 + data2;
    
    % create time attribute value
    tattrib = ['hours since ',filen1(17:20),'-',filen1(21:22),'-01 ','00:00:00'];
    
    tlength = size(data1);
    tlength = tlength(3);
    
    time = linspace(1, tlength, tlength);
    time = time -1;
    time = time * 3;
    
    time = int16(time);
    
    latitude  = linspace(1, 360, 360);
    latitude  = (latitude / 2) - 90.25;
    longitude = linspace(1, 720, 720);
    longitude = (longitude / 2) - 180.25;  
    
    latitude  = single(latitude);
    longitude = single(longitude);
    
    % create output netcdf
    fileout = strcat(filen1(1:end-3),'_CLM.nc');
    ncid = netcdf.create(fileout,'NC_WRITE');
    
    tid    = netcdf.defDim(ncid,'time',tlength);
    latid  = netcdf.defDim(ncid,'lat',360);
    lonid  = netcdf.defDim(ncid,'lon',720);
    
    varid = netcdf.defVar(ncid,'PRECTmms','float',[lonid,latid,tid]);
    
    timev = netcdf.defVar(ncid,'time','float',tid);
    latv = netcdf.defVar(ncid,'lat','float',latid);
    lonv = netcdf.defVar(ncid,'lon','float',lonid);
    
    netcdf.putAtt(ncid,timev,'units',tattrib)
    netcdf.putAtt(ncid,timev,'calendar','gregorian');
    
    % units for forcing variables
    netcdf.putAtt(ncid,varid,'units','mm H2O / sec');
        
    netcdf.endDef(ncid);
    netcdf.putVar(ncid,timev,time);
    netcdf.putVar(ncid,latv,latitude);
    netcdf.putVar(ncid,lonv,longitude);
    netcdf.putVar(ncid,varid,data); 
    
    netcdf.close(ncid);
end