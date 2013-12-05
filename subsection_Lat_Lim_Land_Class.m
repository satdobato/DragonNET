%
% Subsection of the Land Class values for given grid limit
% Created by: Nabin Malakar
% Dec 4, 2013

% This file will create the land class usage in DC area.
% part of the DRAGON NET project.
% Generates plots and 
% Land_Class_EASM_2009_DC.mat
clear all
dist_lim = 0.05;      %initial radius
% latarr=36.525:0.05:41.475;  %(100 elements)
% lonarr=-80.475:.05:-73.525; %(140 elements)
% %For plots
Lat_min = 36.525;
Lat_max = 41.5;
Lon_min = -80.50;
Lon_max = -73.525; %made a typo here!  
latv = Lat_min:dist_lim:Lat_max;
lonv = Lon_min:dist_lim:Lon_max;


latlim =([Lat_min Lat_max]);
lonlim =([Lon_min Lon_max]);

%% Nope, We are not interpolating the data into new resolution. 
% We need to find indices
load('Land_Class_EASM_2009.mat')
load('latv_landclass.mat')
load('lonv_landclass.mat')
% Loaded the provided values

% Create new grids for the latv and longv landclass data
[newLat,newLon] = ndgrid(latv_landclass, lonv_landclass);
inLandClass = zeros(size(newLat));

% find the range of lat/ long coordinates
iwantlat = find(latv_landclass >= Lat_min & latv_landclass <= Lat_max);
iwantlon = find(lonv_landclass >= Lon_min & lonv_landclass <= Lon_max );

LatVec = latv_landclass(iwantlat);
LonVec = lonv_landclass(iwantlon);

iwant = find(newLat >= Lat_min & newLat <= Lat_max & newLon >= Lon_min & newLon <= Lon_max );

 
figure
for jj = 1:size(Land_Class_EASM_2009,3)
inLandClass = double(Land_Class_EASM_2009(:,:,jj));
% newLandClass = zeros(length(iwantlat),length(iwantlon));
newLandClass = inLandClass(iwant);
inewLC = reshape(newLandClass,length(iwantlat),length(iwantlon));
newLC(:,:,jj) = inewLC;

imagesc(inewLC)
pause(0.5)
clf
end
 
'done!'
% save Land_Class_EASM_2009_DC.mat LatVec LonVec newLC
save Land_Class_EASM_2009_DC.mat  newLC

%   newLC      100x140x18            1696464  double              
 
%% Plot to check
clear all
load('Land_Class_EASM_2009_DC.mat')
 plotOK = 1
if plotOK
% latarr=36.525:0.05:41.475;  %(100 elements)
% lonarr=-80.475:.05:-73.525; %(140 elements)
% [box_lat,box_lon] = ndgrid(LatVec,LonVec);
close all
latarr=36.525:0.05:41.475;  %(100 elements)
lonarr=-80.475:.05:-73.525; %(140 elements)

[box_lat,box_lon] = ndgrid(latarr,lonarr);


latlim =([36.525 41.475]);
lonlim =([-80.475 -73.525]);

figure;
for jj = 1:size(newLC,3)
    fig_title = ['Land Class Layer ', num2str(jj)];

     ax = worldmap(latlim, lonlim);
    states = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
    geoshow(ax, states, 'Facecolor', [1 1 0.9]);
    surfacem(box_lat,box_lon,flipud(newLC(:,:,jj))); % somehow flipud!
    
    h1=gca;
%     set(h1,'CLimMode','Manual','CLim',[0, 1]);
    h2=colorbar('vert','FontSize',12);
    title(fig_title,'FontSize',14);
 pause    
end
end






