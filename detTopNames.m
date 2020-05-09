% Name: Jiale Hu
% NCSU Email: jhu15@ncsu.edu
% Date: 11/1/2017
% Lab Section # 205
% Project 3: Baby Names, Fall 2017

function [ topNames ] = detTopNames(yearOfBirth,top)
%Determines the top girl and boy names in a particular year.
%by getting that info from the input data file for that year.
%   Inputs: yearOfBirth - an integer between [1880 and 2016].
%                   top - an integer betwenn [0 and 100].
%   Output:    topNames - a cell array with top rows and two columes, the
%                         first colume is the top girl names as char array,
%                         the second colume is the top boy names as char
%                         arrays.

file = sprintf('yob%d.txt',yearOfBirth);
    % Determine file name with inputs.
FID = fopen(file,'r');
    % Open the corresponding file.
list = textscan(FID,'%s %s %d','Delimiter',',');
    % Using textscan to store the content in cell array list.
fclose(FID);
    % Close the file.
    
names = list{:,1};    
    % Get a cell array of names from list.
gender = cell2mat(list{:,2});    
    % Get a string array of gender from list.
 
nameF = names(gender == 'F');
    % Get a cell array containing all female names.
nameM = names(gender == 'M');
    % Get a cell array containing all male names.
 
% Preallocate cell arrays of female and male names.
topF = cell(top,1);
topM = cell(top,1);
% For loop assigning desired number of top names to the cell arrays.
for i = 1:top
    topF(i,1) = nameF(i);
    topM(i,1) = nameM(i);
end
 
% Contcanenate cell arrays of female and male names to get topNames.
topNames = [topF,topM];

end