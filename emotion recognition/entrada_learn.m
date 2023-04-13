
clear
clc

n = 1200; % max = 1200
dbasenum = 2; % images = 1, videos = 2

path = 'C:\Users\Todos\Desktop\Programas RAFA\TFG\source code\face detection\media\'; % Path to media folder
dbase = ["images\", "videos\"];
folder = ["01neutral\", "02calm\", "03happy\", "04sad\", "05angry\", "06fearful\", "07disgust\", "08surprised\"];
emotion = ["neutral", "calm", "happy", "sad", "angry", "fearful", "disgust", "surprised"];

A = zeros(2,71,n,8);
Auni = zeros(2,71,n,8);
num_pics = n;

for num_emo = 1:8
    for i = 1:num_pics
        num_im = (num_emo-1)*num_pics + i;
        textFileName = strcat(path, dbase(dbasenum), folder(num_emo), emotion(num_emo), " (", num2str(i), ").txt");
        fid = fopen(textFileName, "r");
        img_coords = fscanf(fid, "%f", [2 71]);
        fclose(fid);
        
        A(:,:,i,num_emo) = img_coords;
        
        % Unitary coords
        maxX = max(img_coords(1,:));
        maxY = max(img_coords(2,:));
        minX = min(img_coords(1,:));
        minY = min(img_coords(2,:));
        img_coords(1,:) = (img_coords(1,:) - minX)./(maxX - minX);
        img_coords(2,:) = (img_coords(2,:) - minY)./(maxY - minY);
        Auni(:,:,i,num_emo) = img_coords;
        minmaxl(num_im,:) = [minX maxX minY maxY];
    end
end