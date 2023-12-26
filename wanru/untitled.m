% Load the images.

img_dir = 'C:\Users\PKU\Documents'; 
fixedImage = imread(fullfile(img_dir, 'picpick_2023-12-23_183628_1703327788.png')); % The reference image.
movingImage = imread(fullfile(img_dir, 'picpick_2023-12-23_183634_1703327794.png')); % The image to align.

% Convert images to grayscale if they are RGB.
fixedImage = rgb2gray(fixedImage);
movingImage = rgb2gray(movingImage);

% Apply noise reduction.
fixedImageFiltered = imgaussfilt(fixedImage, 2); % Gaussian filter with sigma = 2
movingImageFiltered = imgaussfilt(movingImage, 2); % Gaussian filter with sigma = 2

% Histogram matching (if the images are single-channel, grayscale).
movingImageHistMatched = imhistmatch(movingImageFiltered, fixedImageFiltered);

% Edge enhancement.
fixedImageEdges = edge(fixedImageFiltered, 'sobel');
movingImageEdges = edge(movingImageHistMatched, 'sobel');

% Detect feature points on the edge-enhanced images.
fixedPoints = detectSURFFeatures(fixedImageEdges);
movingPoints = detectSURFFeatures(movingImageEdges);


% Extract feature descriptors.
[fixedFeatures, fixedValidPoints] = extractFeatures(fixedImageGray, fixedPoints);
[movingFeatures, movingValidPoints] = extractFeatures(movingImageGray, movingPoints);

% Match features.
indexPairs = matchFeatures(fixedFeatures, movingFeatures);

% Retrieve the locations of the corresponding points for each image.
fixedMatchedPoints = fixedValidPoints(indexPairs(:,1), :);
movingMatchedPoints = movingValidPoints(indexPairs(:,2), :);

% Estimate the transformation matrix.
tform = estimateGeometricTransform(movingMatchedPoints, fixedMatchedPoints, 'affine');

% Apply the transformation to align the moving image with the fixed image.
alignedImage = imwarp(movingImage, tform, 'OutputView', imref2d(size(fixedImage)));

% % Display the result.
% figure;
% imshowpair(fixedImage, alignedImage, 'montage');

% figure;
% imshowpair(fixedImage,alignedImage,"falsecolor");


% After running estimateGeometricTransform and getting tform
T = tform.T; % The 3x3 transformation matrix

% Decompose the transformation matrix
rotation_elements = [T(1,1), T(1,2); T(2,1), T(2,2)];
translation_elements = [T(3,1), T(3,2)];

% Check for translation
is_translation = all(abs(translation_elements) > eps);

% Calculate the angle of rotation
angle_of_rotation = atan2(T(2,1), T(1,1)) * (180/pi); % Convert to degrees

% Check if there is a significant rotation
is_rotation = abs(angle_of_rotation) > eps;

% Output the results
fprintf('Translation: [%f, %f]\n', T(3,1), T(3,2));
fprintf('Rotation: %f degrees\n', angle_of_rotation);


%% 
figure

% ... (previous code)

% Display the result with false color to visualize differences.
imshowpair(fixedImage, alignedImage, "falsecolor");

% Hold on to the current figure to overlay annotations.
hold on;

% Calculate the center of the image.
imageSize = size(fixedImage);
centerX = imageSize(2) / 2;
centerY = imageSize(1) / 2;

% Draw an arrow for translation if there is significant translation.
if is_translation
    % Determine the end point of the arrow for translation.
    endX = centerX + T(3,1);
    endY = centerY + T(3,2);
    quiver(centerX, centerY, T(3,1), T(3,2), 0, 'y', 'LineWidth', 2, 'MaxHeadSize', 2);
    text(endX, endY, sprintf('Translation: [%0.2f, %0.2f]', T(3,1), T(3,2)), 'Color', 'yellow');
end

% Indicate rotation by drawing an arc if there is significant rotation.
if is_rotation
    % Determine the radius and angles for the arc.
    radius = 20; % Example radius, adjust based on your image size.
    angles = linspace(0, angle_of_rotation, 100) * (pi/180); % Convert to radians.
    
    % Calculate the arc coordinates.
    arcX = centerX + radius * cos(angles);
    arcY = centerY - radius * sin(angles); % Negative because image Y-axis is down.
    
    % Draw the arc.
    plot(arcX, arcY, 'y', 'LineWidth', 2);
    text(centerX + radius, centerY, sprintf('%0.2f degrees', angle_of_rotation), 'Color', 'yellow');
end

% Release the figure hold.
hold off;
