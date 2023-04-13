
nt = 100; % max = 100
dbasenum = 2; % images = 1, videos = 2
num_test = 1; % man = 1, woman = 2

path = 'C:\Users\Todos\Desktop\Programas RAFA\TFG\source code\face detection\media\'; % Path to media folder
dbase = ["images\", "videos\"];
folder = ["testm\mantest", "testw\womantest"];

B = zeros(2,71,nt,8);
Buni = zeros(2,71,nt,8);
num_pics = nt;
minmax = zeros(8*nt,4);

for num_emo = 1:8
    for i = 1:num_pics
        num_im = (num_emo-1)*100 + i;
        textFileName = strcat(path, dbase(dbasenum), folder(num_test), " (", num2str(num_im), ").txt");
        fid = fopen(textFileName, "r");
        img_coords = fscanf(fid, "%f", [2 71]);
        fclose(fid);
        
        B(:,:,i,num_emo) = img_coords;
        
        % Unitary coords
        maxX = max(img_coords(1,:));
        maxY = max(img_coords(2,:));
        minX = min(img_coords(1,:));
        minY = min(img_coords(2,:));
        img_coords(1,:) = (img_coords(1,:) - minX)./(maxX - minX);
        img_coords(2,:) = (img_coords(2,:) - minY)./(maxY - minY);
        Buni(:,:,nt,num_emo) = img_coords;
        minmaxt(num_im,:) = [minX maxX minY maxY];
    end
end