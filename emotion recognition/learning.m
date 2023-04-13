%% Angles combinats sense contorn + HOGs

y = zeros(1,8*n);
for i = 1:8
    for j = 1:n
        npos = (i-1)*n+j;
        y(1,npos) = i;     
    end
end
 
x8 = horzcat(x6,x5b);

% Opcio 1
pred1 = TreeBagger(100,x8,y,'Options','UseParallel');

% Opcio 2
% pred2 = fitcknn(x8,y,'NumNeighbors',5,'Standardize',1);

% Opcio 3
% x8red = x8(1:4:end,1:3:end);
% yred = y(1,1:4:end);
% pred3 = fitcdiscr(x8red,yred);

%% Histogrames de Gradients Orientats localitzats

num_char = (71-15)*36;

x7 = zeros(8*n,num_char);
y = zeros(1,8*n);

for i = 1:8
    for j = 1:n
        npos = (i-1)*n+j;
        y(1,npos) = i;
        
        %Caracteristiques
        imName = strcat(path, convertStringsToChars(dbase(1)), convertStringsToChars(folder(i)), ...
                        convertStringsToChars(emotion(i)), ' (', num2str(j), ').jpeg');
        im = imresize(imread(imName), [380 675]);
        
        xi_piece = zeros(71-15, 36);
        for k = 16:71
            xpiece = A(1,k,j,i) - 3;
            ypiece = A(2,k,j,i) - 3;
            im_piece = imcrop(im, [xpiece ypiece 6 6]);
            xi_piece(k-15, :) = extractHOGFeatures(im_piece,'CellSize',[3 3]);
        end
        
        xi = reshape(xi_piece, [1 56*36]);
        x7(npos,:) = xi;
    end
end

pred = TreeBagger(25,x7,y);


%% Histogrames de Gradients Orientats (HOGs)

num_char = 2916;

x6 = zeros(8*n,num_char);
y = zeros(1,8*n);

for i = 1:8
    for j = 1:n
        npos = (i-1)*n+j;
        y(1,npos) = i;
        
        %Caracteristiques
        imName = strcat(path, convertStringsToChars(dbase(1)), convertStringsToChars(folder(i)), ...
                        convertStringsToChars(emotion(i)), ' (', num2str(j), ').jpeg');
        im = imresize(imread(imName), [380 675]);
        x1 = max(minmaxl(npos, 1), 1);
        x2 = min(minmaxl(npos, 2), 674);
        y1 = max(minmaxl(npos, 3), 1);
        y2 = min(minmaxl(npos, 4), 379);
        im = imresize(imcrop(im, [x1 y1 x2-x1 y2-y1]), [100 100]);
        xi = extractHOGFeatures(im,'CellSize',[10 10]);

        x6(npos,:) = xi;
    end
end

pred = TreeBagger(25,x6,y);


%% Angles combinats sense contorn

kkv = 7; % min = 1
num_char = (71-15)*(kkv*kkv);

x5b = zeros(8*n,num_char);
y = zeros(1,8*n);

for i = 1:8
    for j = 1:n
        npos = (i-1)*n+j;
        y(1,npos) = i;
        
        %Caracteristiques
        xi = zeros(1,(71-15-kkv)*(kkv-1));
        for k = 16:71
            for kk = 1:kkv
                for kkk = 1:kkv
                    firstv = k - kk;
                    secondv = k + kkk;
                    if firstv < 1
                        firstv = firstv + 71-15;
                    end
                    if secondv > 71
                        secondv = secondv - 71+15;
                    end
                    a = [A(1,k,j,i) - A(1,firstv,j,i), A(2,k,j,i) - A(2,firstv,j,i)];
                    b = [A(1,k,j,i) - A(1,secondv,j,i), A(2,k,j,i) - A(2,secondv,j,i)];
                    ab = a(1)*b(1) + a(2)*b(2);
                    mod_a = sqrt(a(1)*a(1)+a(2)*a(2));
                    mod_b = sqrt(b(1)*b(1)+b(2)*b(2));
                    theta = acosd(ab/(mod_a*mod_b));
                    xi(1,kkk + (kk-1)*kkv + (k-1-15)*kkv*kkv) = theta;
                end
            end
        end
        
        x5b(npos,:) = xi;
    end
end

pred = TreeBagger(25,x5b,y);


%% Angles combinats

kkv = 6; % min = 1
num_char = 71*(kkv*kkv);

x5 = zeros(8*n,num_char);
y = zeros(1,8*n);

for i = 1:8
    for j = 1:n
        npos = (i-1)*n+j;
        y(1,npos) = i;
        
        %Caracteristiques
        xi = zeros(1,(71-kkv)*(kkv-1));
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
                    a = [A(1,k,j,i) - A(1,firstv,j,i), A(2,k,j,i) - A(2,firstv,j,i)];
                    b = [A(1,k,j,i) - A(1,secondv,j,i), A(2,k,j,i) - A(2,secondv,j,i)];
                    ab = a(1)*b(1) + a(2)*b(2);
                    mod_a = sqrt(a(1)*a(1)+a(2)*a(2));
                    mod_b = sqrt(b(1)*b(1)+b(2)*b(2));
                    theta = acosd(ab/(mod_a*mod_b));
                    xi(1,kkk + (kk-1)*kkv + (k-1)*kkv*kkv) = theta;
                end
            end
        end
        
        x5(npos,:) = xi;
    end
end

pred = TreeBagger(25,x5,y);


%% Angles consecutius

num_char = 69;

x4 = zeros(8*n,num_char);
y = zeros(1,8*n);

for i = 1:8
    for j = 1:n
        npos = (i-1)*n+j;
        y(1,npos) = i;
        
        %Caracteristiques
        xi = zeros(1,69);
        for k = 1:69
            a = [A(1,k,j,i) - A(1,k+1,j,i), A(2,k,j,i) - A(2,k+1,j,i)];
            b = [A(1,k,j,i) - A(1,k+2,j,i), A(2,k,j,i) - A(2,k+2,j,i)];
            ab = a(1)*b(1) + a(2)*b(2);
            mod_a = sqrt(a(1)*a(1)+a(2)*a(2));
            mod_b = sqrt(b(1)*b(1)+b(2)*b(2));
            theta = acosd(ab/(mod_a*mod_b));
            xi(k) = theta;
        end
        
        x4(npos,:) = xi;
    end
end

pred = TreeBagger(25,x4,y);


%% Vectors consecutius

num_char = 70*2;

x3 = zeros(8*n,num_char);
y = zeros(1,8*n);

for i = 1:8
    for j = 1:n
        npos = (i-1)*n+j;
        y(1,npos) = i;
        
        %Caracteristiques
        xi = zeros(1,70*2);
        for k = 1:70
            distx = Auni(1,k+1,j,i) - Auni(1,k,j,i);
            disty = Auni(2,k+1,j,i) - Auni(2,k,j,i);
            dist = sqrt(distx*distx + disty*disty);
            angle = atan2(disty,distx);
            xi(k) = dist;
            xi(70+k) = angle;
        end
        
        x3(npos,:) = xi;
    end
end

pred = TreeBagger(25,x3,y);


%% Coordenades unitaries

num_char = 71*2;

x2 = zeros(8*n,num_char);
y = zeros(1,8*n);

for i = 1:8
    for j = 1:n
        npos = (i-1)*n+j;
        y(1,npos) = i;
        
        %Caracteristiques
        xi = cat(2,Auni(1,:,j,i),Auni(2,:,j,i));
        
        x2(npos,:) = xi;
    end
end

pred = TreeBagger(25,x2,y);


%% Coordenades absolutes

num_char = 71*2;

x1 = zeros(8*n,num_char);
y = zeros(1,8*n);

for i = 1:8
    for j = 1:n
        npos = (i-1)*n+j;
        y(1,npos) = i;
        
        %Caracteristiques
        xi = cat(2,A(1,:,j,i),A(2,:,j,i));
        
        x(npos,:) = xi;
    end
end

pred = TreeBagger(25,x1,y);
