# Tensor-Based-Morphometry-KUT
Repository to store the m-files needed to do TBM process

before start, you will need several tools to be downloaded/installed
- mricron https://www.nitrc.org/projects/mricron/
- SPM8 https://www.fil.ion.ucl.ac.uk/spm/software/spm8/
- VBM8 http://www.neuro.uni-jena.de/vbm8/ https://neuro-jena.github.io/software.html
- ANTs1.9 https://sourceforge.net/projects/advants/files/ANTS/ANTS_Latest/

After downloading the necessary files:
- Install the ANTs (run as admin)
- extract the SPM8
- extract VBM8 and put it inside spm8\toolbox\
- we need dcm2nii, thus copy/move it and its dependencies to the same directory

Each process stage and configuration can be known by the file name:
- 00 mricron : create NIFTI file and reorient the image into nearest orthogonal
- 01 cropimage : crop only the head, remove other region if exist, such as neck
- 02 segment : segment the brain image into gray matter, white matter, and cerebro spinal fluid
- 03 overlay : overlay and realign the two images (old brain vs new brain)
- 04 normalization : normalize the realigend image to get the deformation field image
- 05 deformation : apply the deformation field into a default masking image
- 06 ANTs : calculate the deformation jacobian from old brain to new brain
- 07 deformation jac : apply the deformation filed from 04 to the deformation jacobian 06
- 08 ROI analysis : calculate the region of interest for its changes
