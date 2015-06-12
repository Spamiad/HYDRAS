clear; close all; fclose all; clc;

%% Grid info
ncols=160;
nrows=160;
dim=ncols*nrows;
lats_min=-39.9375;
lons_min=135.0625;
ds=0.125;
lat_vic=lats_min:ds:lats_min+(nrows-1)*ds; lat_vic=flipud(lat_vic');
lon_vic=lons_min:ds:lons_min+(ncols-1)*ds; lon_vic=lon_vic';

lats_arr=NaN(dim,1);
lons_arr=NaN(dim,1);
cnt=0;
for i=1:nrows
    for j=1:ncols
      cnt=cnt+1;  
        lats_arr(cnt,1)=lat_vic(i);
        lons_arr(cnt,1)=lon_vic(j);
    end
end
lats_arr=flipud(lats_arr);
lats_im=flipud(reshape(lats_arr,ncols,nrows)');
lons_im=flipud(reshape(lons_arr,ncols,nrows)');

%% Oznet soil moisture station data

filename = 'D:\Users\lrains\Documents\Scripts\stations_latlon.txt';
delimiter = '\t';
formatSpec = '%s%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
id_oz = dataArray{:, 1};
lat_oz = dataArray{:, 2};
lon_oz = dataArray{:, 3};

ozfolder='D:\Users\lrains\Documents\Scripts\oznet_datasets\';
ozfiles = dir(ozfolder);
ozfilelist=char(ozfiles.name); ozfilelist(1:2,:)=[]; 
nozfiles=size(ozfilelist); nozfiles=nozfiles(1); 

station_sm_h=[];
for ioz=1:nozfiles
ozfile=['D:\Users\lrains\Documents\Scripts\oznet_datasets\',ozfilelist(ioz,:)];
newData1 = load('-mat', ozfile);
% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

if ioz==1
    time=datestr(DATETIME,'dd/mm/yyyy HH:MM');
    pos=find( str2num(time(:,7:10))==2006 | str2num(time(:,7:10))==2007 | str2num(time(:,7:10))==2008 | str2num(time(:,7:10))==2009 | str2num(time(:,7:10))==2010);
end

if ioz==3 || ioz==4 || ioz==5 || ioz==6 || ioz==7 || ioz==8 || ioz==9 || ioz==10 || ioz==12 || ioz==15 
    station_sm_h=[station_sm_h; nanmean(reshape(proper_timeseries(pos),2,1826*24))];
else
    dsize=size(DATA,1);
    for is=1:dsize
    station_sm_h=[station_sm_h; nanmean(reshape(DATA(is,pos),2,1826*24))];
    end
end
end

% Aggregate stations within the same VIC pixel
vic_id=[];
station_sm_h_vic=[];
station_list=NaN(49,49);
latlon=NaN(49,2);

cnt=0;
for i=1:dim
    pos=find(abs(lat_oz-lats_arr(i))<=0.125/2 & abs(lon_oz-lons_arr(i))<=0.125/2);
    if length(pos)>0
        cnt=cnt+1;
        
        % latitude and longitude of model cells with in-situ sm data
        latlon(cnt,1)=lats_arr(i);
        latlon(cnt,2)=lons_arr(i);
        
        station_list(cnt,1:length(pos))=pos;
        vic_id=[vic_id; i];
        if length(pos)==1
        station_sm_h_vic=[station_sm_h_vic; station_sm_h(pos,:)];    
        else
        station_sm_h_vic=[station_sm_h_vic; nanmean(station_sm_h(pos,:))];
        end
    end
end
nstations=length(vic_id);


% write all stations, do not aggregate per model cell
cnt = 0;
for i=1:dim
    pos=find(abs(lat_oz-lats_arr(i))<=0.125/2 & abs(lon_oz-lons_arr(i))<=0.125/2);
    if length(pos)>0
        
        for j=1:length(pos)
         cnt=cnt+1;   
        
         % latitude and longitude of model cells with in-situ sm data
         latlon(cnt,1)=lats_arr(i);
         latlon(cnt,2)=lons_arr(i);
        
         station_list(cnt,1:length(pos))=pos;
         %vic_id=[vic_id; i];
          station_sm_h_vic=[station_sm_h_vic; station_sm_h(pos(j),:)];          
        end              
    end
end
nstations=length(vic_id);
%%%%%%%%%%%%%%%%%%%%%%%%


% set data to UTC
station_sm_h_vic = station_sm_h_vic(:,11:43824);

% aggregate to daily data
T = 0:numel(station_sm_h_vic(1,:))-1; % time stamps
interval = 24;

ix = 1+floor((T-T(1))/interval); 
sm_d = NaN(49,1826);

for i=1:49
 sm_d(i,:) = accumarray(ix(:),station_sm_h_vic(i,:));
 sm_d(i,:) = sm_d(i,:) / interval;
 %isequal(V2(1),sum(V(1:interval))) % check
end

save('sm_d_insitu.mat','sm_d')