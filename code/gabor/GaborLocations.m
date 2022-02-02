%%By: Karen Navarro 
%%03/04/2019
%%This code creates a table for the location (in pixels for a screen 1280x1024) 
%%where the gabor will be drawn in each truck image and exports it as a .mat file

%% create variables
ImageNames =["Truck1","Truck2","Truck3","Truck4","Truck5","Truck6",...
    "Truck7","Truck8","Truck9","Truck10","Truck11","Truck12",...
    "Truck13","Truck14","Truck15","Truck16","Truck17"];
trueDirection = [1,1,1,1,2,2,2,1,2,1,1,2,1,2,1,2,2]; % of non-deprived eye (1 = front truck points left)
%% create table
locations =[ImageNames;xLocation;yLocation];
locations= locations'; %Transpose matrix
%% save as a mat file
save('GaborTrucklocations.mat','locations');