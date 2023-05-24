function [output1, output2] = my_run_mricron()
    % Use spm_select to get input directories
    dirs = spm_select(2, 'dir', 'Select input directories');
    
    % Check if two directories are selected
    if size(dirs, 1) ~= 2
        error('Please select exactly two input directories.');
    end
    
    % Set the directory where "dcm2nii.exe" is located
    exeDir = '.\mricron-old\';
    
    % Set the arguments
    arg5 = deblank(dirs(1, :)); 
    arg6 = deblank(dirs(2, :)); 

    inputDirs = {arg5, arg6}; % Store the input directories in a cell array

    output1 = '';
    output2 = '';

    for i = 1:numel(inputDirs)
        % Create the command string
        command = sprintf('%sdcm2nii.exe -r y -x y -g n "%s"', exeDir, inputDirs{i});
        
        % Attempt to run the executable
        try
            fprintf('Running dcm2nii.exe for input directory %d...\n', i);
            system(command);
            fprintf('dcm2nii.exe completed successfully for input directory %d.\n', i);
            
            % Check for existence of "o*.nii.gz" files
            files = checkFiles(inputDirs{i});
            
            % Store the filename in the respective output variable if found
            if ~isempty(files)
                if i == 1
                    output1 = fullfile(inputDirs{i}, files(1).name);
                else
                    output2 = fullfile(inputDirs{i}, files(1).name);
                end
            end
        catch ME
            fprintf('An error occurred while running dcm2nii.exe for input directory %d:\n%s\n', i, ME.message);
        end
    end
end

function files = checkFiles(directory)
    % Get all .nii.gz files in the directory
    files = dir(fullfile(directory, 'o*.nii'));
    
    % Check if any files exist
    if isempty(files)
        fprintf('No "o*.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "o*.nii" files in %s:\n', directory);
        for i = 1:numel(files)
            fprintf('%s\n', files(i).name);
        end
    end
end
