

cd('C:\PhD\HYDRAS\trunk\MDarlin_domainmask');

mask = ncread('domain.lnd_MurrayDarlin.150326.nc','mask');
lat = ncread('domain.lnd_MurrayDarlin.150326.nc','yc');
lon = ncread('domain.lnd_MurrayDarlin.150326.nc','xc');


filename = 'C:\PhD\HYDRAS\trunk\MDarlin_domainmask\MDBgrid.txt';
delimiter = '\t';
formatSpec = '%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
MDBgrid = [dataArray{1:end-1}];
clearvars filename delimiter formatSpec fileID dataArray ans;


% create mask
grid = zeros(160,160,1,'double');
grid(:,:) = NaN;
 for i=1:160
  for j=1:160
   
   for k=1:length(MDBgrid)
    if lat(1,i) == MDBgrid(k,2) && lon(j,1) == MDBgrid(k,3)
     grid(i,j) = 1; 
    end
   end
         
  end
 end
 
 grid_out = int32(grid);
 mask_out = mask.*grid_out;
 grid_out = fliplr(grid_out);
 
 
mask2 = rot90(grid_out,1);
grid3 = int32(grid2);
mask3 = mask2.*grid3;
mask3 = fliplr(mask3);

ncwrite('domain.lnd_MurrayDarlin.150326.nc','mask',grid_out);

