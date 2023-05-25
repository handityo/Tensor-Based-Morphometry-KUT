function [output] = my_05_deformation(myimagefiles)
%% check argument
if nargin == 0
    myimagefiles = spm_select(Inf,'image','Select iy_rrmcropped image files');
end

imagefile = deblank(myimagefiles(1,:));
directory = fileparts(imagefile);
sourceFile = 'C:\MATLAB\mask_ICV.nii';  % Specify the path of the source file
targetDirectory = directory;  % Specify the path of the target directory

copyfile(sourceFile, targetDirectory);
maskfile = checkFiles(targetDirectory, 'mask_ICV.nii');
mask = '';

if isempty(maskfile)
        fprintf('No "mask_ICV.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "mask_ICV.nii" file in %s:\n', directory);
        fprintf('%s\n', maskfile.name);
        mask = fullfile(directory, maskfile.name);
        fprintf('%s\n', mask);
end


% List of open inputs
nrun = 1; % enter the number of runs here

% Configuration for preprocessing
matlabbatch{1}.spm.tools.vbm8.tools.defs2.field = {imagefile};
matlabbatch{1}.spm.tools.vbm8.tools.defs2.images = {{mask}};
matlabbatch{1}.spm.tools.vbm8.tools.defs2.interp = 1;
matlabbatch{1}.spm.tools.vbm8.tools.defs2.modulate = 0;

% Repeat the job for each run
jobs = repmat({matlabbatch}, 1, nrun);
inputs = cell(0, nrun);

% Run the job
spm('defaults', 'PET');
spm_jobman('serial', jobs, '', inputs{:});

wmaskfile = checkFiles(targetDirectory, 'wmask_ICV.nii');
if isempty(wmaskfile)
        fprintf('No "wmask_ICV.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "wmask_ICV.nii" file in %s:\n', directory);
        fprintf('%s\n', wmaskfile.name);
        output = fullfile(directory, wmaskfile.name);
end