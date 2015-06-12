

cd('F:\Users\lrains\Model_Output')

load('sm.mat');
load('sm_d_insitu.mat');
sm_d = sm_d / 100;

load('latlon_insitu');

% subset soil layer
sm = squeeze(sm(:,:,1,:));
sm = rot90(sm,1);

% extract in-situ locations from model output
lats_min= -39.9375;
lats_max= -20.0625;
lons_min= 135.0625;

sm_m = NaN(49,1826);

for i=1:49
 x = (latlon(i,2) - lons_min) / 0.125;
 y = (abs(latlon(i,1)) - abs(lats_max)) / 0.125;
 
 sm_m(i,:) = sm(x,y,:);
end

hold all
plot(sm_m(13,:));
plot(sm_d(13,:));

corr = NaN(49,1);
for i=1:49
 corr(i) = nancorr(sm_m(i,:),sm_d(i,:));
end
