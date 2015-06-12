

ncols=160;
nrows=160;
dim=ncols*nrows;
lats_min=-39.9375;
lons_min=135.0625;
ds=0.125;
lats=lats_min:ds:lats_min+(nrows-1)*ds; lats=flipud(lats');
lons=lons_min:ds:lons_min+(ncols-1)*ds; lons=lons';

Image=ones(nrows,ncols);

lat_new=lats; lon_new=lons;
mat_2_map(lons,lats,sm,(135.0625:0.125:154.9375),(-39.9375:0.125:-20.0625),[-40 -20],[135 155])
hold on;
title(['Elevatin Std []'] ,'fontsize',14,'fontweight','bold');
caxis([0 250]);
colorbar
print('-dpng','-r300',['ts.png'])
hold off;