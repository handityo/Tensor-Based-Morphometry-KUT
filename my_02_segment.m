function [output1, output2] = my_02_segment(myimagefiles)
%% check argument
if nargin == 0
    myimagefiles = spm_select(Inf,'image','Select image files');
end

% List of open inputs
nrun = 1; % enter the number of runs here

% Configuration for preprocessing
matlabbatch{1}.spm.spatial.preproc.data = {
                                            myimagefiles(1,:)
                                            myimagefiles(2,:)
                                            };
matlabbatch{1}.spm.spatial.preproc.output.GM = [0 0 1];
matlabbatch{1}.spm.spatial.preproc.output.WM = [0 0 1];
matlabbatch{1}.spm.spatial.preproc.output.CSF = [0 0 1];
matlabbatch{1}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{1}.spm.spatial.preproc.output.cleanup = 0;
matlabbatch{1}.spm.spatial.preproc.opts.tpm = {
    'C:\MATLAB\spm8\tpm\grey.nii'
    'C:\MATLAB\spm8\tpm\white.nii'
    'C:\MATLAB\spm8\tpm\csf.nii'
    };
matlabbatch{1}.spm.spatial.preproc.opts.ngaus = [2 2 2 4];
matlabbatch{1}.spm.spatial.preproc.opts.regtype = 'eastern';
matlabbatch{1}.spm.spatial.preproc.opts.warpreg = 1;
matlabbatch{1}.spm.spatial.preproc.opts.warpco = 25;
matlabbatch{1}.spm.spatial.preproc.opts.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.preproc.opts.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.opts.samp = 3;
matlabbatch{1}.spm.spatial.preproc.opts.msk = {''};

% Repeat the job for each run
jobs = repmat({matlabbatch}, 1, nrun);
inputs = cell(0, nrun);

% Run the job
spm('defaults', 'PET');
spm_jobman('serial', jobs, '', inputs{:});

for i=1:size(myimagefiles,1)
    imagefile = deblank(myimagefiles(i,:));
    % Check for existence of "mcropped*.nii" files
    directory = fileparts(imagefile);
    mcroppedFiles = checkFiles(directory, 'mcropped*.nii');

    if isempty(mcroppedFiles)
        fprintf('No "mcropped*.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "mcropped*.nii" file in %s:\n', directory);
        fprintf('%s\n', mcroppedFiles(1).name);
        
        if i == 1
            output1 = fullfile(directory, mcroppedFiles(1).name);
        else
            output2 = fullfile(directory, mcroppedFiles(1).name);
        end
    end
end 