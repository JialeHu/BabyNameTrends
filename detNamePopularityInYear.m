% Name: Jiale Hu
% NCSU Email: jhu15@ncsu.edu
% Date: 11/1/2017
% Lab Section # 205
% Project 3: Baby Names, Fall 2017

function [ popularity ] = detNamePopularityInYear(yearOfBirth,name,gender)
%Determines the occurences (popularity) of a particular name given the
%gender and the year of birth by searching in the input data file.
%   Inputs: yearOfBirth - an integer between [1880 and 2016].
%                  name - a string for the name to search for.
%                gender - a string either 'f', 'F', 'm' or 'M'.
%   Output:  popularity - If name in year of birth input file, then it is
%                         an int32. If name is Not found, then it is an 
%                         empty vector.

file = sprintf('yob%d.txt',yearOfBirth);
    % Determine file name with inputs.
FID = fopen(file,'r');
    % Open the corresponding file.
list = textscan(FID,'%s %s %d','Delimiter',',');
    % Scan the text and store them in a cell array.
fclose(FID);
    % Close the file.

popularity = list{3}(strcmpi(list{1},name) & strcmpi(list{2},gender));
    % Find the popularity of input name (int32).
    
% Set popularity to empty if name was not found.
if isempty(popularity)
    popularity = [];
end

end