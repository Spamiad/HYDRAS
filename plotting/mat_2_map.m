function mat_2_map(lon_smos, lat_smos,data,lon_grid,lat_grid,latlim,lonlim)
%UMB:
%mat_2_map(lon_new,lat_new,Rnew,(-100:0.25:-85),(37:0.25:50),[37 50],[-100 -85])
figure();
hold on;

[lon_smos,lat_smos]=meshgrid(lon_smos,lat_smos);
[lon_m,lat_m]=meshgrid(lon_grid,lat_grid);
data_int=griddata(lat_smos,lon_smos,data,lat_m,lon_m,'nearest');

mapname='Equidistant Cylindrical'; % type m_proj('get') for all projections
title('test' ,'fontsize',14,'fontweight','bold');
m_proj(mapname,'lat',latlim,'long',lonlim);
m_grid('linestyle','none','tickdir','out','linewidth',2);
%m_coast('line','Color','k','LineWidth',1);
m_gshhs_h('line','Color','k','LineWidth',1);
h1 = m_pcolor(lon_m,lat_m,data_int);
shading flat;
hold off;

end
