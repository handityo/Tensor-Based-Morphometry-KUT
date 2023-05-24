function [output1, output2] = my_03_overlay(myimagefiles)
%% check argument
if nargin == 0
    myimagefiles = spm_select(Inf,'image','Select image files');
end

% List of open inputs
nrun = 1; % enter the number of runs here

% Configuration for preprocessing
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.data = {
                                                             {
                                                                myimagefiles(1,:)
                                                                myimagefiles(2,:)
                                                             }
                                                             }';
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.eoptions.sep = 4;
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.eoptions.rtm = 1;
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.eoptions.interp = 2;
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.eoptions.weight = 1;
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.eoptions.halfway = 1;
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.roptions.which = [2 1];
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.roptions.mask = 1;
matlabbatch{1}.spm.tools.vbm8.tools.realign.estwrite.roptions.prefix = 'r';

% Repeat the job for each run
jobs = repmat({matlabbatch}, 1, nrun);
inputs = cell(0, nrun);

% Run the job
spm('defaults', 'PET');
spm_jobman('serial', jobs, '', inputs{:});

% Filecheck
for i=1:size(myimagefiles,1)
    imagefile = deblank(myimagefiles(i,:));
    % Check for existence of "rmcropped*.nii" files
    directory = fileparts(imagefile);
    rmcroppedFiles = checkFiles(directory, 'rmcropped*.nii');

    if isempty(rmcroppedFiles)
        fprintf('No "rmcropped*.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "rmcropped*.nii" file in %s:\n', directory);
        fprintf('%s\n', rmcroppedFiles(1).name);
        
        if i == 1
            output1 = fullfile(directory, rmcroppedFiles(1).name);
        else
            output2 = fullfile(directory, rmcroppedFiles(1).name);
        end
    end
end 