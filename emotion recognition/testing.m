%% Angles combinats sense contorn + HOGs

kkv = 7;
res = zeros(1,8*nt);
res_score = zeros(8,8*nt);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        impos = (i-1)*100+j;
        
        %Caracteristiques
        imName = strcat(path, 'images\', convertStringsToChars(folder(num_test)), ' (', num2str(impos), ').jpeg');
        im = imresize(imread(imName), [380 675]);
        x1 = max(minmaxt(impos, 1), 1);
        x2 = min(minmaxt(impos, 2), 674);
        y1 = max(minmaxt(impos, 3), 1);
        y2 = min(minmaxt(impos, 4), 379);
        im = imresize(imcrop(im, [x1 y1 x2-x1 y2-y1]), [100 100]);
        xtp1 = extractHOGFeatures(im,'CellSize',[10 10]);
        
        xtp2 = zeros(1,(71-15-kkv)*(kkv-1));
        for k = 16:71
            for kk = 1:kkv
                for kkk = 1:kkv
                    firstv = k - kk;
                    secondv = k + kkk;
                    if firstv < 1
                        firstv = firstv + 71 -15;
                    end
                    if secondv > 71
                        secondv = secondv - 71 +15;
                    end
                    a = [B(1,k,j,i) - B(1,firstv,j,i), B(2,k,j,i) - B(2,firstv,j,i)];
                    b = [B(1,k,j,i) - B(1,secondv,j,i), B(2,k,j,i) - B(2,secondv,j,i)];
                    ab = a(1)*b(1) + a(2)*b(2);
                    mod_a = sqrt(a(1)*a(1)+a(2)*a(2));
                    mod_b = sqrt(b(1)*b(1)+b(2)*b(2));
                    theta = acosd(ab/(mod_a*mod_b));
                    xtp2(1,kkk + (kk-1)*kkv + (k-1-15)*kkv*kkv) = theta;
                end
            end
        end
        
        xt = cat(2,xtp1,xtp2);
        xt = double(xt);
        
        if exist('pred1','var')
            [label, res_score(:,npos)] = predict(pred1,xt);
            res(1,npos) = double(label{1}) - 48;
        end
        
        if exist('pred2','var')
            [label, res_score(:,npos)] = predict(pred2,xt);
            res(1,npos) = label;
        end
        
        if exist('pred3','var')
            xtred = xt(1,1:3:end);
            [label, res_score(:,npos)] = predict(pred3,xtred);
            res(1,npos) = label;
        end
    end
end


%% Histogrames de Gradients Orientats localitzats

res = zeros(1,8*nt);
res_score = zeros(8,8*nt);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        impos = (i-1)*100+j;
        
        %Caracteristiques
        imName = strcat(path, 'images\', convertStringsToChars(folder(num_test)), ' (', num2str(impos), ').jpeg');
        im = imresize(imread(imName), [380 675]);
        
        xt_piece = zeros(71-15, 36);
        for k = 16:71
            xpiece = B(1,k,j,i) - 3;
            ypiece = B(2,k,j,i) - 3;
            im_piece = imcrop(im, [xpiece ypiece 6 6]);
            xt_piece(k-15, :) = extractHOGFeatures(im_piece,'CellSize',[3 3]);
        end
        xt = reshape(xt_piece, [1 56*36]);
        
        xt = double(xt);
        [label, res_score(:,npos)] = predict(pred,xt);
        res(1,npos) = double(label{1}) - 48;
    end
end


%% Histogrames de Gradients Orientats (HOGs)

res = zeros(1,8*nt);
res_score = zeros(8,8*nt);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        impos = (i-1)*100+j;
        
        %Caracteristiques
        imName = strcat(path, 'images\', convertStringsToChars(folder(num_test)), ' (', num2str(impos), ').jpeg');
        im = imresize(imread(imName), [380 675]);
        x1 = max(minmaxt(impos, 1), 1);
        x2 = min(minmaxt(impos, 2), 674);
        y1 = max(minmaxt(impos, 3), 1);
        y2 = min(minmaxt(impos, 4), 379);
        im = imresize(imcrop(im, [x1 y1 x2-x1 y2-y1]), [100 100]);
        xt = extractHOGFeatures(im,'CellSize',[10 10]);

        xt = double(xt);
        [label, res_score(:,npos)] = predict(pred,xt);
        res(1,npos) = double(label{1}) - 48;
    end
end


%% Angles combinats sense contorn

kkv = 7;
res = zeros(1,8*nt);
res_score = zeros(8,8*nt);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        
        %Caracteristiques
        xt = zeros(1,(71-15-kkv)*(kkv-1));
        for k = 16:71
            for kk = 1:kkv
                for kkk = 1:kkv
                    firstv = k - kk;
                    secondv = k + kkk;
                    if firstv < 1
                        firstv = firstv + 71 -15;
                    end
                    if secondv > 71
                        secondv = secondv - 71 +15;
                    end
                    a = [B(1,k,j,i) - B(1,firstv,j,i), B(2,k,j,i) - B(2,firstv,j,i)];
                    b = [B(1,k,j,i) - B(1,secondv,j,i), B(2,k,j,i) - B(2,secondv,j,i)];
                    ab = a(1)*b(1) + a(2)*b(2);
                    mod_a = sqrt(a(1)*a(1)+a(2)*a(2));
                    mod_b = sqrt(b(1)*b(1)+b(2)*b(2));
                    theta = acosd(ab/(mod_a*mod_b));
                    xt(1,kkk + (kk-1)*kkv + (k-1-15)*kkv*kkv) = theta;
                end
            end
        end
        
        xt = double(xt);
        [label, res_score(:,npos)] = predict(pred,xt);
        res(1,npos) = double(label{1}) - 48;
    end
end


%% Angles combinats

res = zeros(1,8*nt);
res_score = zeros(8,8*nt);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        
        %Caracteristiques
        xt = zeros(1,(71-kkv)*(kkv-1));
        for k = 1:71
            for kk = 1:kkv
                for kkk = 1:kkv
                    firstv = k - kk;
                    secondv = k + kkk;
                    if firstv < 1
                        firstv = firstv + 71;
                    end
                    if secondv > 71
                        secondv = secondv - 71;
                    end
                    a = [B(1,k,j,i) - B(1,firstv,j,i), B(2,k,j,i) - B(2,firstv,j,i)];
                    b = [B(1,k,j,i) - B(1,secondv,j,i), B(2,k,j,i) - B(2,secondv,j,i)];
                    ab = a(1)*b(1) + a(2)*b(2);
                    mod_a = sqrt(a(1)*a(1)+a(2)*a(2));
                    mod_b = sqrt(b(1)*b(1)+b(2)*b(2));
                    theta = acosd(ab/(mod_a*mod_b));
                    xt(1,kkk + (kk-1)*kkv + (k-1)*kkv*kkv) = theta;
                end
            end
        end
        
        xt = double(xt);
        [label, res_score(:,npos)] = predict(pred,xt);
        res(1,npos) = double(label{1}) - 48;
    end
end


%% Angles consecutius

res = zeros(1,8*nt);
res_score = zeros(8,8*nt);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        
        %Caracteristiques
        xt = zeros(1,69);
        for k = 1:69
            a = [B(1,k,j,i) - B(1,k+1,j,i), B(2,k,j,i) - B(2,k+1,j,i)];
            b = [B(1,k,j,i) - B(1,k+2,j,i), B(2,k,j,i) - B(2,k+2,j,i)];
            ab = a(1)*b(1) + a(2)*b(2);
            mod_a = sqrt(a(1)*a(1)+a(2)*a(2));
            mod_b = sqrt(b(1)*b(1)+b(2)*b(2));
            theta = acosd(ab/(mod_a*mod_b));
            xt(k) = theta;
        end
        
        xt = double(xt);
        [label, res_score(:,npos)] = predict(pred,xt);
        res(1,npos) = double(label{1}) - 48; 
    end
end


%% Vectors consecutius

res = zeros(1,8*nt);
res_score = zeros(8,8*nt);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        
        %Caracteristiques
        xt = zeros(1,70*2);
        for k = 1:70
            distx = Buni(1,k+1,j,i) - Buni(1,k,j,i);
            disty = Buni(2,k+1,j,i) - Buni(2,k,j,i);
            dist = sqrt(distx*distx + disty*disty);
            angle = atan2(disty,distx);
            xt(k) = dist;
            xt(70+k) = angle;
        end
        
        xt = double(xt);
        [label, res_score(:,npos)] = predict(pred,xt);
        res(1,npos) = double(label{1}) - 48;
    end
end


%% Coordenades unitaries

res = zeros(1,8*nt);
res_score = zeros(8,8*nt);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        
        %Caracteristiques
        xt = cat(2,Buni(1,:,j,i),Buni(2,:,j,i));
        
        xt = double(xt);
        [label, res_score(:,npos)] = predict(pred,xt);
        res(1,npos) = double(label{1}) - 48;
    end
end


%% Coordenades absolutes

res = zeros(1,8*nt);
res_score = zeros(8,8*nt);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        
        %Caracteristiques
        xt = cat(2,B(1,:,j,i),B(2,:,j,i));
        
        xt = double(xt);
        [label, res_score(:,npos)] = predict(pred,xt);
        res(1,npos) = double(label{1}) - 48;
    end
end
