function [output] = my_07_deformjac(myimagefiles)
%% check argument
if nargin == 0
    myimagefiles = spm_select(Inf,'image','Select y_rrmcropped and j*jacobian image files');
end

%fieldfile = deblank(myimagefiles(1,:));
%imagefile = deblank(myimagefiles(2,:));

fieldfile = deblank(myimagefiles{1});
imagefile = deblank(myimagefiles{2});

directory = fileparts(fieldfile);

% List of open inputs
nrun = 1; % enter the number of runs here

% Configuration for preprocessing
matlabbatch{1}.spm.tools.vbm8.tools.defs2.field = {fieldfile};
matlabbatch{1}.spm.tools.vbm8.tools.defs2.images = {{imagefile}};
matlabbatch{1}.spm.tools.vbm8.tools.defs2.interp = 1;
matlabbatch{1}.spm.tools.vbm8.tools.defs2.modulate = 0;

% Repeat the job for each run
jobs = repmat({matlabbatch}, 1, nrun);
inputs = cell(0, nrun);

% Run the job
spm('defaults', 'PET');
spm_jobman('serial', jobs, '', inputs{:});

wmaskfile = checkFiles(directory, 'wj*jacobian.nii');
if isempty(wmaskfile)
        fprintf('No "wj*jacobian.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "wj*jacobian.nii" file in %s:\n', directory);
        fprintf('%s\n', wmaskfile.name);
        output = fullfile(directory, wmaskfile.name);
end