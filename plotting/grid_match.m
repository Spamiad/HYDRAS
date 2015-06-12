
function  [idx dist_x dist_y]=grid_match(lat_smos,lon_smos,lat_vic,lon_vic)


%idx
%idy
%dist_x
%dist_y
     [lon_vic,lat_vic]=meshgrid(lon_vic,lat_vic);
for i=1:length(lat_smos)
    for j=1:length(lon_smos)
        idx{i,j}=[];        
        dist_x{i,j}=[];
        dist_y{i,j}=[];
    end
end
     
for i=2:length(lat_smos)-1        % Iterates each SMOS grid cell
    for j=2:length(lon_smos)-1        % Find VIC cells within SMOS working area (WA) of 25x25km
        
        lat=lat_smos(i); lon=lon_smos(j);
        lat_pri=lat+(lat_smos(i-1)-lat)/2;
        lat_pos=lat-(lat-lat_smos(i+1))/2;
        lon_pri=lon-(lon-lon_smos(j-1))/2;
        lon_pos=lon+(lon_smos(j+1)-lon)/2;
        index = find( (lon_vic>=lon_pri) & (lon_vic<=lon_pos) & ...
                      (lat_vic>=lat_pri) & (lat_vic<=lat_pos)  );
        idx{i,j}   =index;              
        adistx=[];
        adisty=[];
        for i_vic = 1:length(index)
             distx = m_lldist([lat, lat],[lon,lon_vic(index(i_vic))])./1000;
             disty = m_lldist([lat, lat_vic(index(i_vic))],[lon,lon_vic(index(i_vic))])./1000;
             adistx=[adistx, distx.*sign(lon-lon_vic(index(i_vic)))];
             adisty=[adisty, disty.*sign(lat- lat_vic(index(i_vic)))];
        end
        dist_x{i,j}=adistx;
        dist_y{i,j}=adisty;
    end
end

