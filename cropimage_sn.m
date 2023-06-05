function cropimage_sn(snfile)
%% check argument
if nargin == 0
    snfile = spm_select;
end
%% initialization
bb_template = [0 0 0;91 0 0;91 109 0; 0 109 0;0 0 91;91 0 91;91 109 91;0 109 91];
sn = load(snfile);
transformedcoordinates = sn.Affine*[bb_template ones(8,1)]';
transformedcoordinates = transformedcoordinates(1:3,:)';
mx = max(transformedcoordinates);
mn = min(transformedcoordinates);
mn(mn<1) = 1;
bb = [round(mn);min([round(mx);sn.VF.dim])];
img = spm_read_vols(sn.VF);
img_cropped = img(bb(1,1):bb(2,1),bb(1,2):bb(2,2),bb(1,3):bb(2,3));
sn.VF.dim = size(img_cropped);
[path,name,ext] = spm_fileparts(sn.VF.fname);
sn.VF.fname = fullfile(path,['cropped_' name ext]);
%% for origin setting
vs = sn.VF.mat\eye(4);
vs(1:3,4) = vs(1:3,4) - (bb(1,:)-[1 1 1])';
sn.VF.mat = inv(vs);
%% for AC setting
% ACvox = sn.Affine*[46 64 37 1]';% [46 67 34 1]'; AC defined visually 
% ACvox = ACvox(1:3);
% vs = sn.VF.mat\eye(4);
% vs(1:3,4) = ACvox;
% sn.VF.mat = inv(vs);
%% write volume
spm_write_vol(sn.VF,img_cropped);
