function [output1, output2] = my_01_cropimage(myimagefiles)
%% check argument
if nargin == 0
    myimagefiles = spm_select(Inf,'image','Select image files');
end
%% initialization
spm('defaults', 'PET');
job_spm_norm_est.subj.source = '';
job_spm_norm_est.subj.wtsrc = '';                                               
job_spm_norm_est.eoptions.template{1} = fullfile(spm('dir'),'templates','T1.nii');
job_spm_norm_est.eoptions.weight = '';
job_spm_norm_est.eoptions.smosrc = 8;
job_spm_norm_est.eoptions.smoref = 0;
job_spm_norm_est.eoptions.regtype = 'mni';
job_spm_norm_est.eoptions.cutoff = 25;
job_spm_norm_est.eoptions.nits = 0;
job_spm_norm_est.eoptions.reg = 1;

output1 = {};
output2 = {};

%% main loop
for i=1:size(myimagefiles,1)
    imagefile = deblank(myimagefiles(i,:));
    job_spm_norm_est.subj.source{1} = imagefile;
    out = spm_run_normalise_estimate(job_spm_norm_est);
    cropimage_sn(out.params{1});
    
    % Check for existence of "cropped*.nii" files
    directory = fileparts(imagefile);
    croppedFiles = checkFiles(directory, 'cropped*.nii');
    
    if isempty(croppedFiles)
        fprintf('No "cropped*.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "cropped*.nii" file in %s:\n', directory);
        fprintf('%s\n', croppedFiles(1).name);
        
        if i == 1
            output1 = fullfile(directory, croppedFiles(1).name);
        else
            output2 = fullfile(directory, croppedFiles(1).name);
        end
    end
end 
end