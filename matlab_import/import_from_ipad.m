%% Rich Stoner, 2011
% import json file from responseApp ipad app into matlab
clear all
clc

% set this filename
json_filename = 'Rich.stoner-exp-2011-09-13-14-52-32.json';
json_str = fileread(json_filename);

% parsed using third party library
[dataset] = parse_json(json_str);
array_list = dataset{1,1};

% distribute into individual arrays
description = {};   % cell array
timestamp = [];     % standard array of doubles

for i = 1:length(array_list)

%     uncomment to display 
%     disp(sprintf('%s\t%s ms', array_list{1,i}{1,1}, array_list{1,i}{1,2}));

    description{i} = array_list{1,i}{1,1};
    timestamp(i) = str2double(array_list{1,i}{1,2});
end

