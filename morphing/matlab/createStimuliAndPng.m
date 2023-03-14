%% Create png images that will be later morphed
% tbUse BCBLViennaSoft;
clear all

res  = 1024;
numImages = 100;
langs = {'JP'};  % {'ES','AT'};
imnames = {'RW'}; % {'RW','PW'};
numImages = 100;

oPath = fullfile(bvRP,'local','PNGs','orig');

% Create equivalent chequerboard
% 10 pairs per 1024
pairs    = 10;
sizeSide = 51;
CB       = ones(res,res);
CB(1:(end-4),1:(end-4)) = checkerboard(sizeSide, pairs)>0.5;
CB((end-3):(end),:) = CB(1:4,:);
CB(:,(end-3):(end)) = CB(:,1:4);
CB = uint8(CB*255);

for lang=langs; for imname=imnames
    bName = fullfile(bvRP,'morphing','DATA','retWordsMagno');
    origName = [lang{:} '_' imname{:} '_' num2str(res) 'x' num2str(res) 'x' num2str(numImages) '.mat']; 
    origPath = fullfile(bName, origName);
    
    % Read each file
    stim = load(origPath).images{1};
    
    % Check the resolution is the same just in case
    assert(res==size(stim,1))
    
    for ns = 1:size(stim,4)
      pngPath = fullfile(oPath,sprintf([lang{:} '_' imname{:} '_' num2str(res) 'x' num2str(res) '_%02d.png'],ns));   
      sqstim = squeeze(stim(:,:,1,ns));
      imwrite(sqstim,pngPath);
    end
    
    % Save one CB for this as well, easier to script later
    CBpath = fullfile(oPath, sprintf([lang{:} '_CB_' num2str(res) 'x' num2str(res) '.png']));
    assert(isequal(size(sqstim),size(CB)))
    imwrite(CB, CBpath);
end; end


% Now use the morphing/autoimagemorph/autoimagemorph.py code to generate the
% morphed images, and select the 10 and 20 intermediate step morphed images 

%% Create the resxresx3x100 images
bName = fullfile(bvRP,'morphing','DATA','retWordsMagno');
Example_file_name =  fullfile(bName,'JP_RW_1024x1024x100.mat');
A = load(Example_file_name);

for lang=langs; for imname=imnames; for step=1:29
    % Read all the images
    ims = dir(fullfile(bvRP,'local','PNGs','new', ...
                       ['NEW_' lang{:} '_' imname{:} '_' num2str(res) 'x' ...
                       num2str(res) '_*_step-' num2str(step) '.png']));
    % Create empty matrix and fill it with the png-s
    imagesFile = uint8(zeros(size(A.images{1})));
    for jj=1:100
        % 100 is in the 10th position, but we don't care, they are random
        imagesFile(:,:,:,jj) = imread(fullfile(ims(jj).folder, ims(jj).name));
    end
    % Generate file name
    destName = [lang{:} '_' imname{:} num2str(step) '_' num2str(res) 'x' ...
                num2str(res) 'x' num2str(numImages) '.mat']; 
    destPath = fullfile(bName, destName);
    % saving
    images      = cell(1,1);
    images{1}   = imagesFile; 
    save(destPath, 'images')
       
end; end; end

%% Visualize the 100 images
for step=1:29
    destName = [lang{:} '_' imname{:} num2str(step) '_' num2str(res) 'x' ...
        num2str(res) 'x' num2str(numImages) '.mat'];
    destPath = fullfile(bName, destName);
    im=load(destPath);
    figure(step);
    imshow(im.images{1}(:,:,:,5))
end

%% Create the sitmuli bars
% Now we need to create the bar stimuli using python again
% use morphing/CreateStimulusRetStim.py




%% Visualize the bar stimuli

destNameCB = 'AT_CB_tr-0.8_duration-300sec_size-1024pix_maxEcc-9deg_barWidth-2deg.mat';
imCB = load(destNameCB);
figure(1);
imshow(imCB.stimulus.images(:,:,20))


destName10 = 'AT_RW10_tr-0.8_duration-300sec_size-1024pix_maxEcc-9deg_barWidth-2deg.mat';
im10 = load(destName10);
figure(10);
imshow(im10.stimulus.images(:,:,20))

destName20 = 'AT_RW20_tr-0.8_duration-300sec_size-1024pix_maxEcc-9deg_barWidth-2deg.mat';
im20=load(destName20);
figure(20);
imshow(im20.stimulus.images(:,:,20))

destNameRW = 'AT_RW_tr-0.8_duration-300sec_size-1024pix_maxEcc-9deg_barWidth-2deg.mat';
imRW=load(destNameRW);
figure(30);
imshow(imRW.stimulus.images(:,:,20))

