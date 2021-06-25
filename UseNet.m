load NetCI.mat
warning off
close all
df1=uigetdir('selector');
fname1=dir([df1 '\*.png']);
file_name1={fname1.name};
answer1 = questdlg('Would you like to save result?', ...
	'Saving Menu', ...
	'OK! Choose a folder to save','Cancel','OK! Choose a folder to save');
switch (answer1)
    case 'Cancel'
%         warndlg('Processing without saving result','Warning');
dirsave=0;
    case 'OK! Choose a folder to save'
dirsave=uigetdir('selector');
end
re=strings(length(fname1),1);
sname1=strings(length(fname1),1);
for i=1:length(fname1)
name=file_name1{i};
sname1(i)=cellstr(name(1:end-4));
I=imread([df1 '\' file_name1{i}]);
% folder='NamLy N2';
% file='Pic_NamLy-N2B-1_4-Z-PSDM';
% I = imread(['E:\Project\Investigate loss factor\Database\LossFactor\3 cau\' folder '\' file '.png']);
inputSize = net.Layers(1).InputSize;
I = imresize(I,inputSize(1:2));
I=im2double(I);
label = classify(net,I);
% figure('Name', char(sname1(i)));
imshow(I)
title(string(label))
re(i)=label;
end
if dirsave~=0
    writematrix(re,[dirsave '\' 'resultCNN.xlsx'],'Sheet','Sheet1','Range','B2');
    writecell(cellstr(sname1),[dirsave '\' 'resultCNN.xlsx'],'Sheet','Sheet1','Range','A2');
winopen(dirsave)
end
% I = imresize(picnew,siz);
% I=im2double(I);
% label = classify(net,I);