function out = my_08_ROI(myimagefiles)
if nargin == 0
    myimagefiles = spm_select(Inf,'image','Select m0wrp3*.nii wj*.nii image files');
end

CSFcutoff = 0.5;

%csfimagefiles = deblank(myimagefiles(1,:));
%jacimagefiles = myimagefiles(2,:);

csfimagefiles = deblank(myimagefiles{1});
jacimagefiles = myimagefiles{2};

atlaslabelfiles = {'C:\MATLAB\labels_Neuromorphometrics.nii';'C:\MATLAB\labels_Neuromorphometrics_lobes.nii';'C:\MATLAB\labels_Neuromorphometrics_roi.nii'};
outputdir = fileparts(csfimagefiles);

for x=1:size(atlaslabelfiles)
    atlaslabelfile = atlaslabelfiles{x};

    vol_atlaslabel = spm_vol(atlaslabelfile);
    atlaslabelimage = spm_read_vols(vol_atlaslabel);
    labels = unique(atlaslabelimage);
    
    fp_vol = fopen([outputdir '\labeledbrainvol_' num2str(x) '_' datestr(now,'yyyymmdd_HHMMSS') '.txt'],'wt');
    fp_jac = fopen([outputdir '\labeledbrainjac_' num2str(x) '_' datestr(now,'yyyymmdd_HHMMSS') '.txt'],'wt');
    fp_jac_shrinkonly = fopen([outputdir '\labeledbrainjac_shrinkonly_' num2str(x) '_' datestr(now,'yyyymmdd_HHMMSS') '.txt'],'wt');
    
    fprintf(fp_vol,'imagefiles\t');
    fprintf(fp_jac,'Jacobianimagefiles\tCSFImagefiles\t');
    fprintf(fp_jac_shrinkonly,'Jacobianimagefiles\tCSFImagefiles\t');
    for i=1:size(labels,1)
        fprintf(fp_vol,'%s\t',['label' num2str(labels(i)) 'vol']);
        fprintf(fp_jac,'%s\t',['label' num2str(labels(i)) 'jac']);
        fprintf(fp_jac_shrinkonly,'%s\t',['label' num2str(labels(i)) 'jac']);
    end
    fprintf(fp_vol,'\n');
    fprintf(fp_jac,'\n');
    fprintf(fp_jac_shrinkonly,'\n');
    
    for i=1:size(csfimagefiles,1)
        %%% read gray matter images %%%
        csfimagefile = deblank(csfimagefiles(i,:));
        vol_csf = spm_vol(csfimagefile);
        csfimage = spm_read_vols(vol_csf);
        %%% read Jacobian images %%%
        jacimagefile = deblank(jacimagefiles(i,:));
        vol_jac = spm_vol(jacimagefile);
        jacimage = spm_read_vols(vol_jac);    
        labelimage = atlaslabelimage.*(csfimage<=CSFcutoff);
        %numlabels = zeros(size(labels,1),1);
        sumcsf = zeros(size(labels,1),1);
        fprintf(fp_vol,'%s\t',csfimagefile);
        fprintf(fp_jac,'%s\t%s\t',jacimagefile,csfimagefile);
        fprintf(fp_jac_shrinkonly,'%s\t%s\t',jacimagefile,csfimagefile);
        for j=1:size(labels,1)
            %numlabels(j) = sum(sum(sum(labelimage == labels(j))));
            %fprintf(fp_vol,'%f\t',abs(prod(diag(vol_gm.mat(1:3,1:3))))*numlabels(j));
            sumcsf(j) = sum(csfimage(labelimage == labels(j)));
            fprintf(fp_vol,'%f\t',abs(det(vol_csf.mat(1:3,1:3)))*sumcsf(j));
            meanjacobians(j) = mean(jacimage(labelimage == labels(j)));
            fprintf(fp_jac,'%f\t',meanjacobians(j));
            meanjacobians_shrink(j) = mean(jacimage((labelimage == labels(j))&(jacimage < 1)));
            fprintf(fp_jac_shrinkonly,'%f\t',meanjacobians_shrink(j));
        end
        fprintf(fp_vol,'\n');
        fprintf(fp_jac,'\n');
        fprintf(fp_jac_shrinkonly,'\n');
        %%% OPTIONAL write out label images %%%
        [path,name,ext]=spm_fileparts(csfimagefile);
        vol_csf.fname = fullfile(path,[name '_label_csf' num2str(CSFcutoff) ext]);
        vol_csf.pinfo = vol_atlaslabel.pinfo;
        spm_write_vol(vol_csf,labelimage);
    end
    
    fclose(fp_vol);
    fclose(fp_jac);
    fclose(fp_jac_shrinkonly);
end