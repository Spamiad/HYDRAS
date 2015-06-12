
file = 'G:\surfdata_0.125x0.125_simyr2000_c150114.nc';


finfo = ncinfo(file);
Variables = struct('Name', {finfo.Variables(1:73).Name});
Variables1 = table({Variables.Name}.', 'VariableNames', {'Name'});

A = table2array(Variables1);


ncid = netcdf.create('MurrayDarlin4.nc','CLASSIC_MODEL');
%ncid = netcdf.open('MurrayDarlin4.nc','NC_WRITE');

% dimensions
lsmlon = netcdf.defDim(ncid,'lsmlon',160);
lsmlat = netcdf.defDim(ncid,'lsmlat',160);
numurbl = netcdf.defDim(ncid,'numurbl',3);
nlevurb = netcdf.defDim(ncid,'nlevurb',5);
numrad = netcdf.defDim(ncid,'numrad',2);
nchar = netcdf.defDim(ncid,'nchar',256);
nlevsoi = netcdf.defDim(ncid,'nlevsoi',10);
time = netcdf.defDim(ncid,'time',12);  % unlimited?
lsmpft = netcdf.defDim(ncid,'lsmpft',17);
natpft = net-cdf.defDim(ncid,'natpft',17);


x1 = 400;
x2 = 549;
y1 = 1100;
y2 = 1249;




for i=1:length(A);
%for i=11:11
 
 if i > 1
  netcdf.reDef(ncid)
 end

 dtype = char({finfo.Variables(i).Datatype});
 if strcmp(dtype,'int32')
  dtype = 'int';
 end

 if i == 1 
  exe = ['vid=','netcdf.defVar(',int2str(ncid),',''mxsoil_color'',''',dtype,''',[])'];
  eval(exe);
  
  % set variable attributes
  attnames = char({finfo.Variables(i).Attributes.Name});
  attvalues = char({finfo.Variables(i).Attributes.Value});
  
  for j=1:length(attnames(:,1))
   aname = attnames(j,:);
   aname = strtrim(aname);
  
   avalue = attvalues(j,:);
   avalue = strtrim(avalue);
  
   exe = ['netcdf.putAtt(',int2str(ncid),',vid,''',aname,''',''',avalue,''')'];
   eval(exe);
  end
  
  tmp = 's1 = ncread(file,''mxsoil_color'')';
  evalc(tmp);
 
  netcdf.endDef(ncid)
  exe = ['netcdf.putVar(',int2str(ncid),',vid,s1)'];
  evalc(exe);  
  continue
 end

if isempty(finfo.Variables(i).Dimensions)
  continue
else
  dimnames = char({finfo.Variables(i).Dimensions.Name});
  for j=1:length(dimnames(:,1))
   if (j == 1); tmp = dimnames(j,:); else tmp = [tmp,' ',dimnames(j,:)]; end   
  end
  dimnames = ['[',tmp,']'];
end

vname = char(A(i));
vname = strtrim(vname);

 % define variable
 exe = ['vid=','netcdf.defVar(',int2str(ncid),',''',vname,''',''',dtype,''',',dimnames,')'];
 eval(exe);
 
 % set variable attributes
 attnames = char({finfo.Variables(i).Attributes.Name});
 attvalues = char({finfo.Variables(i).Attributes.Value});
 
 
 for j=1:length(attnames(:,1))
  aname = attnames(j,:);
  aname = strtrim(aname);
  
  avalue = attvalues(j,:);
  avalue = strtrim(avalue);
  
  exe = ['netcdf.putAtt(',int2str(ncid),',vid,''',aname,''',''',avalue,''')'];
  eval(exe);
 end
 
 
 % read and write data to variable
 %exe = ['s1 = ncread(file,''',vname,''')'];
 %evalc(exe);
 
 Dimensions = {finfo.Variables(i).Dimensions.Length};
 
 if strcmp(vname, 'natpft')
   %s1 = s1(:);
   tmp = ['s1 = ncread(file,''',vname,''',[1],[Inf])'];
 elseif strcmp(vname, 'time')
    tmp = ['s1 = ncread(file,''',vname,''',[1],[Inf])'];
 else   
   if length(Dimensions) == 2
    tmp = ['s1 = ncread(file,''',vname,''',[1080 400],[160 160])'];
   elseif length(Dimensions) == 3
    tmp = ['s1 = ncread(file,''',vname,''',[1080 400 1],[160 160 Inf])'];
   elseif length(Dimensions) == 4
    tmp = ['s1 = ncread(file,''',vname,''',[1080 400 1 1],[160 160 Inf Inf])'];
   end
 end
 
 %s1 = flip(rot90(s1));
 evalc(tmp);
 
 %s1 = flip(rot90(s1,3));
 
 netcdf.endDef(ncid)
 exe = ['netcdf.putVar(',int2str(ncid),',vid,s1)'];
 evalc(exe);
 
 %s1 = flip(rot90(ncread(file,'abm')));
 %s1 = s1(400:549,1100:1249);
 
end


netcdf.close(ncid);