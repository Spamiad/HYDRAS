

% Precip
cd('Z:\Model\CESM_run\Input\clmforc\atm_forcing.datm7.cruncep_qianFill.0.5d.V4.c130305\Precip6Hrly');
files = dir('Rainf_WFDEI_*.nc');


for file = files'    
 newname = strcat('clmforc.cruncep.V4.c2011.0.5d.Prec.',file.name(17:20),'-',file.name(21:22),'.nc');    
 % movefile(file.name, newname)   
 
  dos(['rename "' file.name '" "' newname '"']); % (1)
end


% Solar
cd('Z:\Model\CESM_run\Input\clmforc\atm_forcing.datm7.cruncep_qianFill.0.5d.V4.c130305\Solar6Hrly');
files = dir('RAD_WFDEI_*.nc');


for file = files'    
 newname = strcat('clmforc.cruncep.V4.c2011.0.5d.Solr.',file.name(11:14),'-',file.name(15:16),'.nc');    
 % movefile(file.name, newname)   
 
  dos(['rename "' file.name '" "' newname '"']); % (1)
end