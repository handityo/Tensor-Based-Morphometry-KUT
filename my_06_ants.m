function [output] = my_06_ants(myimagefiles)
%% check argument
if nargin == 0
    myimagefiles = spm_select(Inf,'image','Select rmcropped image files');
end

%imagefiles1 = myimagefiles(1,:);
%imagefiles2 = myimagefiles(2,:);
%maskfiles = myimagefiles(3,:);

imagefiles1 = myimagefiles{1};
imagefiles2 = myimagefiles{2};
maskfiles = myimagefiles{3};

if isempty(imagefiles1) || isempty(imagefiles2) || isempty(maskfiles)
    error('images are not selected appropriately');
end

directory = fileparts(deblank(imagefiles1));

[path1,name1,ext1] = spm_fileparts(deblank(imagefiles1));
file1 = fullfile(path1,[name1 ext1]);
[path2,name2,ext2] = spm_fileparts(deblank(imagefiles2));
file2 = fullfile(path2,[name2 ext2]);
[path_mask,name_mask,ext_mask] = spm_fileparts(deblank(maskfiles));
maskfile = fullfile(path_mask,[name_mask ext_mask]);
outputfile = [directory '\1st_' name1 '_to_2nd_' name2 '_'];
outputfile_warped = [directory '\2nd_' name2 '_to_1st_' name1];
[path,name] = fileparts(outputfile);

command1 = sprintf('ANTS 3 -m CC[%s,%s,1,4] -t SyN[0.1] -r Gauss[3,0] -i 100x100 -o %s --number-of-affine-iterations 0 -x %s\n', file1, file2, outputfile, maskfile);
command2 = sprintf('WarpImageMultiTransform 3 %s %s -R %s %s\n',file2,[outputfile_warped '.nii'],file1,[outputfile 'Warp.nii.gz']);
command3 = sprintf('ANTSJacobian 3 %s %s 0\n',[outputfile 'Warp.nii.gz'],fullfile(path,['j_' name]));
command4 = sprintf('ANTSJacobian 3 %s %s 1\n',[outputfile 'Warp.nii.gz'],fullfile(path,['j_' name]));

system(command1);
system(command2);
system(command3);
system(command4);

jacobiannii = checkFiles(directory, 'j_*_jacobian.nii');
if isempty(jacobiannii)
    fprintf('No "j_*_jacobian.nii" files found in %s.\n', directory);
    jacobianniigz = checkFiles(directory, 'j_*_jacobian.nii.gz');
    if isempty(jacobianniigz)
        fprintf('No "j_*_jacobian.nii.z" files found in %s.\n', directory);
                
    else
        fprintf('Found the following "j_*_jacobian.nii.gz" file in %s:\n', directory);
        fprintf('%s\n', jacobianniigz.name);
                
        % Use gunzip to decompress the .nii.gz file
        gunzip(fullfile(jacobianniigz.folder, jacobianniigz.name));
    end 
else
    fprintf('Found the following "j_*_jacobian.nii" file in %s:\n', directory);
    fprintf('%s\n', jacobiannii.name);
    output = fullfile(directory, jacobiannii.name);
end

jacobiannii = checkFiles(directory, 'j_*_jacobian.nii');
if isempty(jacobiannii)
    fprintf('No "j_*_jacobian.nii" files found in %s.\n', directory);
else
    fprintf('Found the following "j_*_jacobian.nii" file in %s:\n', directory);
    fprintf('%s\n', jacobiannii.name);
    output = fullfile(directory, jacobiannii.name);
end


