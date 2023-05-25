function [output1, output2, output3] = my_04_normalize(myimagefiles)
%% check argument
if nargin == 0
    myimagefiles = spm_select(Inf,'image','Select base rmcropped image files');
end

% List of open inputs
nrun = 1; % enter the number of runs here

% Configuration for preprocessing
matlabbatch{1}.spm.tools.vbm8.estwrite.data = {myimagefiles(1,:)};
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.tpm = {'C:\MATLAB\spm8\toolbox\Seg\TPM.nii,1'};
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.ngaus = [2 2 2 3 4 2];
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasreg = 0.0001;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasfwhm = Inf;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.affreg = 'eastern';
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.warpreg = 4;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.samp = 3;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.dartelwarp.normhigh.darteltpm = {'C:\MATLAB\spm8\toolbox\vbm8\Template_1_IXI550_MNI152.nii'};
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.sanlm = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.mrf = 0.15;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.cleanup = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.print = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.native = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.modulated = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.dartel = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.native = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.modulated = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.dartel = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.native = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.modulated = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.dartel = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.native = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.affine = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.label.native = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.label.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.label.dartel = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.jacobian.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.warps = [1 1];

% Repeat the job for each run
jobs = repmat({matlabbatch}, 1, nrun);
inputs = cell(0, nrun);

% Run the job
spm('defaults', 'PET');
spm_jobman('serial', jobs, '', inputs{:});

% Filecheck
for i=1:size(myimagefiles,1)
    imagefile = deblank(myimagefiles(i,:));
    % Check for existence of "iy_rrmcropped*.nii" files
    directory = fileparts(imagefile);

    iy_rrmcroppedFiles = checkFiles(directory, 'iy_rrmcropped*.nii');
    if isempty(iy_rrmcroppedFiles)
        fprintf('No "iy_rrmcropped*.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "iy_rrmcropped*.nii" file in %s:\n', directory);
        fprintf('%s\n', iy_rrmcroppedFiles(1).name);
        
        output1 = fullfile(directory, iy_rrmcroppedFiles(1).name);
    end

    y_rrmcroppedFiles = checkFiles(directory, 'y_rrmcropped*.nii');
    if isempty(y_rrmcroppedFiles)
        fprintf('No "y_rrmcropped*.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "y_rrmcropped*.nii" file in %s:\n', directory);
        fprintf('%s\n', y_rrmcroppedFiles(1).name);
        
        output2 = fullfile(directory, y_rrmcroppedFiles(1).name);
    end

    m0wrp3Files = checkFiles(directory, 'm0wrp3*.nii');
    if isempty(iy_rrmcroppedFiles)
        fprintf('No "m0wrp3*.nii" files found in %s.\n', directory);
    else
        fprintf('Found the following "m0wrp3*.nii" file in %s:\n', directory);
        fprintf('%s\n', m0wrp3Files(1).name);
        
        output3 = fullfile(directory, m0wrp3Files(1).name);
    end
end 