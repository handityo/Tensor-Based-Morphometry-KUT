function TBMAllSPM8(myimagefiles)

% Record the start time
startTime = clock;

%---

%% Get Nifti image and reorient
[input00, input01] = my_run_mricron(myimagefiles);

%% Crop the image
cropimageinput = [input00; input01];
[input10, input11] = my_01_cropimage(cropimageinput);

%% Segmentation
segmentinput = [input10; input11];
[input20, input21] = my_02_segment(segmentinput);

%% Image Overlay
overlayinput = [input20; input21];
[input30, input31] = my_03_overlay(overlayinput);

%% - 3D to 4D
convert3D4Dinput = [input30; input31];
my_035_3Dto4D(convert3D4Dinput);

%% Normalization
normalizeinput = input30;
[input40, input41, input42] = my_04_normalize(normalizeinput);

%% Apply Deformation
deformationinput = input40;
input50 = my_05_deformation(deformationinput);

%% ANTs using synbatchmake_maskfile.m
antinput = {input30; input31; input50};
input60 = my_06_ants(antinput);

%% Apply deformation jacobian
deformjacinput = {input41; input60};
input70 = my_07_deformjac(deformjacinput);

%% ROI analysis
roiinput = {input42; input70};
my_08_ROI(roiinput);


%--

% Record the end time
endTime = clock;

% Calculate the elapsed time in seconds
elapsedTime = etime(endTime, startTime);

% Display the elapsed time
fprintf('Elapsed time: %.2f seconds\n', elapsedTime);