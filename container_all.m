%before running this, make sure that the folders are clean from any other
%files. only folder and DICOM

%only work if the folder only have two subfolder, 2014 and 2021

% get all folders containing the data, PID folders
PIDinputdirs = spm_select(Inf, 'dir', 'Select input directories PID');

%for each PID folder, search subfolder with 2014 and 2021 name
for pid=1:size(PIDinputdirs)
    parentdir = PIDinputdirs(pid,:);

    newdir2014 = dir(fullfile(parentdir, '2014*'));
    newdir2021 = dir(fullfile(parentdir, '2022*'));

    inputdir2014 = fullfile(parentdir, newdir2014.name);
    inputdir2021 = fullfile(parentdir, newdir2021.name);

    inputdir = [inputdir2014; inputdir2021];
    TBMAllSPM8(inputdir);
end