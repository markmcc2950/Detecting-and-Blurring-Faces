run('vlfeat-0.9.20-bin/toolbox/vl_setup');

%img1 = im2single(imread('red_head.png'));
%iteration = 1;
% img1 = im2single(imread('dude.png'));
%iteration = 2;
img1 = im2single(imread('bunny.png'));
iteration = 3;
% img1 = im2single(imread('mikey.jpg'));
% iteration = 4;

img2 = im2single(imread('beach_party.png'));
% img2 = im2single(imread('br1.jpg'));
% img2 = im2single(imread('br2.jpg'));

%% SIFT feature extraction
I1 = rgb2gray(img1);
I2 = rgb2gray(img2);

[f1, d1] = vl_sift(I1);
[f2, d2] = vl_sift(I2);

d1 = double(d1);
d2 = double(d2);

%plot_sift(img1, f1, d1);
%plot_sift(img2, f2, d2);

[matches, scores] = vl_ubcmatch(d1, d2);
%plot_match(img1, img2, f1, f2, matches);

% Extract the coordinates of the matches on the second image
p2 = floor(f2(1:2, matches(2, 1:size(matches,2))));

% Approximate the middle of feature box
p2x = sum(p2(1,:))/size(p2,2);
p2y = sum(p2(2,:))/size(p2,2);

% Show location of "middle" on image
figure, imshow(img2);
hold on
vl_plotframe(f2(:, matches(2, :)));
plot(p2x,p2y, 'r*');


k = 1; % Threshold radius for outliers
min_x = max(size(img2));
max_x = 0;
min_y = min_x;
max_y = 0;

% Calculate standard deviation of x and y
std_x = std(p2(1,:));
std_y = std(p2(2,:));

% Sort x's and y's from smallest to largest to find min and max's
xs = sort(p2(1,:));
ys = sort(p2(2,:));
for i = 1:size(xs,2)
    if (xs(i) >= (p2x - std(p2(1,:)*k)) && xs(i) < min_x)
        min_x = xs(i);
    end
    if (xs(i) <= (p2x + std(p2(1,:)*k)) && xs(i) > max_x)
        max_x = xs(i); 
    end
    if (ys(i) >= (p2y - std(p2(2,:)*k)) && ys(i) < min_y)
        min_y = ys(i);
    end
    if (ys(i) <= (p2y + std(p2(2,:)*k)) && ys(i) > max_y)
        max_y = ys(i); 
    end
end
% View box edges around feature points
plot(min_x,min_y, 'r+', min_x, max_y, 'r+', max_x, max_y, 'r+', max_x, min_y, 'r+');
x_box = [min_x max_x];
y_box = [min_y max_y];

% Set up variables for gaussian filter
sigma = 1;
img3 = img2;

% Calculate box intervals from distance between box and image boundary
n = 10;
comparison = [min_x, min_y, size(img2, 2) - max_x, size(img2, 1) - max_y];
comparison = min(comparison);
range = comparison/n;

for i = 1:n
    % Increase bounds of box with each iteration
    k = floor((i-1)*range);
    % Extract image from box
    patch = img3((min_y - k):(max_y + k + 1), (min_x - k):(max_x + k+ 1), :);
    % Filter image
    img3 = imgaussfilt(img3, (sigma + 0.1*i));
    % Replace box into image
    img3((min_y - k):(max_y + k + 1), (min_x - k):(max_x + k+ 1), :) = patch;
    figure, imshow(img3);
end

% Output image after n intervals
imwrite(img3, sprintf('filtered%d.png', iteration));

%% Discard Code
% padding = 20;
% left = img2(:, 1:min_x,:);
% top = img2(1:min_y, min_x-padding:max_x+padding,:);
% bottom = img2(max_y:size(img2,1)-1, min_x-padding:max_x+padding,:);
% right = img2(:, max_x:size(img2,2)-1,:);
% 
% img_filtered1 = imgaussfilt(left, 5);
% img_filtered2 = imgaussfilt(top, 5);
% img_filtered3 = imgaussfilt(bottom, 5);
% img_filtered4 = imgaussfilt(right, 5);
% canvas = zeros(size(img2));
% 
% 
% canvas(:, 1:min_x,:) = img_filtered1;
% canvas(:, max_x:size(img2,2)-1,:) = img_filtered4;
% canvas(1:min_y, min_x:max_x,:) = img_filtered2(:, padding:size(img_filtered2,2)-(padding+1), :);
% canvas(max_y:size(img2,1)-1, min_x:max_x,:) = img_filtered3(:, padding:size(img_filtered2,2)-(padding+1), :);

