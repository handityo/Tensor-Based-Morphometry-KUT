% Record the start time
startTime = clock;

%---

% Get Nifti image and reorient
[input00, input01] = my_run_mricron();

% Crop the image
cropimageinput = [input00; input01];
[input10, input11] = my_01_cropimage(cropimageinput);

% Segmentation
segmentinput = [input10; input11];
[input20, input21] = my_02_segment(segmentinput);

% Image Overlay
overlayinput = [input20; input21];
[input30, input31] = my_03_overlay(overlayinput);

% - 3D to 4D
convert3D4Dinput = [input30; input31];
my_035_3Dto4D(convert3D4Dinput);

% Normalization
normalizeinput = input30;
input40 = my_04_normalize(normalizeinput);

% Apply Deformation
deformationinput = input40;
input50 = my_05_deformation(deformationinput);

% ANTs using synbatchmake_maskfile.m


%--

% Record the end time
endTime = clock;

% Calculate the elapsed time in seconds
elapsedTime = etime(endTime, startTime);

% Display the elapsed time
fprintf('Elapsed time: %.2f seconds\n', elapsedTime);