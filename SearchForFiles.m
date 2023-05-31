% Select the parent directory using spm_select
%parentDir = spm_select(1, 'dir', 'Select the parent directory');
parentDir = 'C:\forTBM2022\Participants';

% Define the file and directory name patterns
outputFile = 'combined_data_jacobian_shrinkonly_Total.tsv';
filePatterns = {'labeledbrainjac_shrinkonly_Total*.txt', 'labeledbrainjac_shrinkonly_3*.txt'};

pidDirPattern = 'PID_*';
yearDirPattern = '2014_*';

% Initialize variables to store column names and data
columnNames = {};
data = [];

% Search for matching PID directories in the specified parent directory
pidDirs = dir(fullfile(parentDir, pidDirPattern));

% Loop over the found PID directories
for i = 1:numel(pidDirs)
    pidDirPath = fullfile(parentDir, pidDirs(i).name);
    
    % Search for matching year directories within each PID directory
    yearDirs = dir(fullfile(pidDirPath, yearDirPattern));
    
    % Loop over the found year directories
    for j = 1:numel(yearDirs)
        yearDirPath = fullfile(pidDirPath, yearDirs(j).name);
        
        % Loop over the file patterns
        for p = 1:numel(filePatterns)
            filePattern = filePatterns{p};
            
            % Search for matching files within each year directory
            files = dir(fullfile(yearDirPath, filePattern));
            
            % Loop over the found files
            for k = 1:numel(files)
                filePath = fullfile(yearDirPath, files(k).name);
                
                % Read the first row as column names (only once)
                if isempty(columnNames)
                    fin = fopen(filePath, 'r');
                    line1 = fgetl(fin);
                    line2 = fgetl(fin);
                    columnNames = strsplit(line1, '\t');
                    datarow = strsplit(line2, '\t');
                    fclose(fin);

                    fout = fopen(outputFile, 'w');
                    fprintf(fout, '%s\t', "PID");
                    fprintf(fout, '%s\t', columnNames{1:end-1});
                    fprintf(fout, '%s\n', columnNames{end});

                    fprintf(fout, '%s\t', pidDirs(i).name);
                    fprintf(fout, '%s\t', datarow{1:end-1});
                    fprintf(fout, '%s\n', datarow{end});
                    fclose(fout);
                else
                
                    % Read the second row as data
                    fin = fopen(filePath, 'r');
                    line1 = fgetl(fin);
                    line2 = fgetl(fin);
                    datarow = strsplit(line2, '\t');
                    fclose(fin);

                    fout = fopen(outputFile, 'a');
                    fprintf(fout, '%s\t', pidDirs(i).name);
                    fprintf(fout, '%s\t', datarow{1:end-1});
                    fprintf(fout, '%s\n', datarow{end});
                    fclose(fout);
                end
            end
        end
    end
end

disp('Data combined successfully and saved to the output file.');
