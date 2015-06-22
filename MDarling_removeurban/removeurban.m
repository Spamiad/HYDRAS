

% open copy of pft_surfdata which has urban percentages
% cd('D:\Users\lrains\Documents\Scripts\HYDRAS\trunk\MDarling_removeurban');
% pct_urban = ncread('surfdata.pftdyn_0.125x0.125_MurrayDarlin_hist_simyr2000-2000_c130412_nourb.nc','PCT_URBAN');

cd('D:\Users\lrains\Desktop');
pct_urban = ncread('surfdata_0.125x0.125_MDarlin_urb.nc','PCT_URBAN');


% set to 0
ind = pct_urban > 0;
urban_sum = sum(pct_urban,3);

pct_urban(ind) = 0;


% move urban percentages to glacier class
pct_glacier = ncread('surfdata_0.125x0.125_MurrayDarlin_simyr2000_c150401_nourb.nc','PCT_GLACIER');
pct_glacier = pct_glacier + urban_sum;

% overwrite PCT_URBAN
%ncwrite('surfdata.pftdyn_0.125x0.125_MurrayDarlin_hist_simyr2000-2000_c130412_nourb.nc','PCT_URBAN',pct_urban);
ncwrite('surfdata_0.125x0.125_MDarlin_urb.nc','PCT_URBAN',pct_urban);
ncwrite('surfdata_0.125x0.125_MDarlin_urb.nc','PCT_GLACIER',urban_sum);

