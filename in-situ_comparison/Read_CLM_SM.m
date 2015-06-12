

cd('Z:/Model/CESM_run/Output/short/lnd/hist');
dirlist = dir('Z:/Model/CESM_run/Output/short/lnd/hist/MD*');

sm = ncread(dirlist(1).name,'H2OSOI');

for i = 2:length(dirlist)
  tmp = ncread(dirlist(i).name,'H2OSOI');
  sm = cat(4, sm, tmp);
end

% read surface dataset
cd('Z:\Model\Model_Inputdata\');
%sm = ncread('surfdata_0.125x0.125_MurrayDarlin_simyr2000_c150401.nc','MONTHLY_LAI');
sm = ncread('surfdata_0.125x0.125_MurrayDarlin_simyr2000_c150401.nc','STD_ELEV');
sm = sm(:,:,12,7);

sm = sm(:,:,1);

%dirlist = dir('Z:/Model/CESM_run/Output/short/lnd/hist/MD*');

lat = ncread('surfdata_0.125x0.125_MurrayDarlin_simyr2000_c150401.nc','LATIXY');
lon = ncread('surfdata_0.125x0.125_MurrayDarlin_simyr2000_c150401.nc','LONGXY');

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
 
 grid2 = flipud(grid);
 %grid2 = flip(grid2);
 
% top soil layer
sm1 = squeeze(sm(:,:,1,:)); 
sm2 = squeeze(sm(:,:,2,:)); 
sm3 = squeeze(sm(:,:,3,:)); 

sm5 = squeeze(sm(:,:,5,:)); 
sm8 = squeeze(sm(:,:,8,:)); 

%
sm = rot90(sm,1);
sm = sm.*grid2;

grid3 = int32(grid2);
sm = sm.*grid2;

createfigure(sm,'LAI Pft 17, July')

% rotate sm array
for i=1:length(sm)
 tmp = sm(:,:,i);
 tmp =rot90(tmp,1);
 %tmp = flipud(tmp);
 %tmp = fliplr(tmp);
 tmp = tmp.*grid;
 sm(:,:) = tmp;
end

% rotate sm array
for i=1:length(sm8)
 tmp = sm8(:,:,i);
 %tmp = flipud(tmp);
 %tmp = fliplr(tmp);
 
 tmp = rot90(tmp,1);
 tmp = tmp.*grid2;
 sm8(:,:,i) = tmp;
end

% rotate sm array
for i=1:length(sm2)
 tmp = sm2(:,:,i);
 tmp = flipud(tmp);
 tmp = fliplr(tmp);
 tmp = tmp.*grid2;
 sm2(:,:,i) = tmp;
end

% rotate sm array
for i=1:length(sm3)
 tmp = sm3(:,:,i);
 tmp = flipud(tmp);
 tmp = fliplr(tmp);
 tmp = tmp.*grid2;
 sm3(:,:,i) = tmp;
end

% rotate sm array
for i=1:length(sm5)
 tmp = sm5(:,:,i);
 tmp = flipud(tmp);
 tmp = fliplr(tmp);
 tmp = tmp.*grid2;
 sm5(:,:,i) = tmp;
end

% rotate sm array
for i=1:length(sm8)
 tmp = sm8(:,:,i);
 tmp = flipud(tmp);
 tmp = fliplr(tmp);
 tmp = tmp.*grid2;
 sm8(:,:,i) = tmp;
end

sm1x = sm1(11:135,21:150,:);

% spatial statistics
sm1_med = median(sm1,3);
sm1_min = min(sm1,[],3);
sm1_max = max(sm1,[],3);

sm1_std = std(sm1,0,3);

createfigure(flipud(sm1x_med),'Median')
createfigure(flipud(sm1x_min),'Min')
createfigure(flipud(sm1x_max),'Max')

% watershed average time series, top 3 layers
sm1_m = squeeze(nanmean(sm1,2));
sm1_m = squeeze(nanmean(sm1_m,1));
sm2_m = squeeze(nanmean(sm2,2));
sm2_m = squeeze(nanmean(sm2_m,1));
sm3_m = squeeze(nanmean(sm3,2));
sm3_m = squeeze(nanmean(sm3_m,1));
sm5_m = squeeze(nanmean(sm5,2));
sm5_m = squeeze(nanmean(sm5_m,1));
sm8_m = squeeze(nanmean(sm8,2));
sm8_m = squeeze(nanmean(sm8_m,1));

%hold all
t = datetime(2006,1,01) + caldays(1:1826);
plot(t,sm1_m,t,sm2_m,t,sm3_m,t,sm5_m,t,sm8_m,'LineWidth',0.9)
title('Average SM [%] 2006 - 2010')
