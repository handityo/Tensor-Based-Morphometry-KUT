function my_035_3Dto4D(myimagefiles)
%% check argument
if nargin == 0
    myimagefiles = spm_select(Inf,'image','Select image files');
end

% List of open inputs
nrun = 1; % enter the number of runs here

% Configuration for preprocessing
matlabbatch{1}.spm.util.cat.vols = {
                                        myimagefiles(1,:)
                                        myimagefiles(2,:)
                                    };
matlabbatch{1}.spm.util.cat.name = '4D.nii';
matlabbatch{1}.spm.util.cat.dtype = 4;

% Repeat the job for each run
jobs = repmat({matlabbatch}, 1, nrun);
inputs = cell(0, nrun);

% Run the job
spm('defaults', 'PET');
spm_jobman('serial', jobs, '', inputs{:});


