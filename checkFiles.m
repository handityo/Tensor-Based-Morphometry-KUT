function files = checkFiles(directory, pattern)
% Get files matching the specified pattern in the directory
files = dir(fullfile(directory, pattern));

end