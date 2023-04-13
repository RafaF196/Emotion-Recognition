
close all

%% Mostra els encerts

correct = zeros(1,8);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        if res(1,npos) == i
            correct(1,i) = correct(1,i) + 1;
        end
    end
end

resc = correct./nt
mean_resc = mean(resc)


%% Mostra els encerts filtrats

correct_f = zeros(1,8);

for i = 1:8
    for j = 1:nt
        npos = (i-1)*nt+j;
        if res_f(1,npos) == i
            correct_f(1,i) = correct_f(1,i) + 1;
        end
    end
end
 
rescf = correct_f./nt
mean_rescf = mean(rescf)


%% Gràfic complet

% Mostrar dades sense filtrar
% res_d = res;
% res_score_d = res_score;

% Mostrar dades filtrades
res_d = res_f;
res_score_d = res_score_f;

xsub = linspace(0,1,8*nt);
xticks = [0 1/8 2/8 3/8 4/8 5/8 6/8 7/8 1];
lcolor = [[130,130,130]; [0,0,255]; [255,255,0]; [0,255,255]; [255,0,0]; [200,0,200]; [0,255,0]; [255,255,255]]./255;
emocio = [" neutral ", " calma ", " alegria ", " tristesa ", " enuig ", " por ", " fàstic ", " sorpresa "];

f1 = figure('Name','Deteccio d´emocions (Global)','NumberTitle','off','Position',[625 50 735 613]);
f1.Color = [0 0 0];
f1.InvertHardcopy = 'off';

for sub = 1:8
    splot(sub) = subplot(8,1,sub);
    ysub = res_score_d(sub,:);
    colorsub = [lcolor(sub,1) lcolor(sub,2) lcolor(sub,3)];
    plot(splot(sub),xsub,ysub,'Color',colorsub,'LineWidth',1.2);
    set(splot(sub),'XTick',xticks,'YTick',[0 1]);
    set(splot(sub),'TickLength',[0 1],'Xticklabel',[],'Yticklabel',[]);
    set(splot(sub),'Color',[0 0 0]);
    set(get(splot(sub),'YLabel'),'String',emocio(sub),'Color',colorsub, ...
        'Rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right');
    grid on;
    ylim([0 1]);
    set(splot(sub),'GridAlpha',0.8);
end

for sub = 1:8
    set(splot(sub),'Position',[0.10 0.95-(sub/8)*0.9 0.87 1/10]);
end


%% Imatge amb resultat

f2 = figure('Name','Deteccio d´emocions (Individual)','NumberTitle','off','Position',[10 50 600 613]);
f2.Color = [0 0 0];
f2.InvertHardcopy = 'off';

num_im_anim = 160;

path = 'C:\Users\Todos\Desktop\Programas RAFA\TFG\source code\face detection\media\images\'; % Path to images folder
folder = ["testm\mantest", "testw\womantest"];
set(groot,'defaultAxesColorOrder',lcolor);

for num_im = 1:ceil(8*nt/num_im_anim):8*nt
    imageName = strcat(path, convertStringsToChars(folder(num_test)), ' (', num2str(num_im), ').jpeg');
    im = imresize(imread(imageName), [380 675]);
    sub21 = subplot(2,1,1);
    imshow(im);
    hold on
    
%   na = mod(num_im,100);
%   nb = floor(num_im/100) + 1;
%   for pts = 1:71
%       plot(B(1,pts,na,nb), B(2,pts,na,nb), 'g*');
%   end
    
    colorrec = [lcolor(res_d(1,num_im),1) lcolor(res_d(1,num_im),2) lcolor(res_d(1,num_im),3)];
    x1 = max(minmaxt(num_im, 1) - 10, 1);
    x2 = min(minmaxt(num_im, 2) + 10, 674);
    y1 = max(minmaxt(num_im, 3) - 10, 1);
    y2 = min(minmaxt(num_im, 4) + 10, 379);
    xrec = [x1, x2, x2, x1, x1, x2];
    yrec = [y1, y1, y2, y2, y1, y1];
    txt = {emocio(res_d(1,num_im))};
    text(x2-5,y2-20,txt,'Fontsize',12,'BackgroundColor',[0 0 0], ...
        'EdgeColor',colorrec,'Color',colorrec,'FontWeight','bold', ...
        'Margin', 2, 'HorizontalAlignment', 'right');
    plot(xrec, yrec, 'Color', [0 0 0], 'LineWidth', 6);
    plot(xrec, yrec, 'Color', colorrec, 'LineWidth', 3);
    hold off
    
    sub22 = subplot(2,1,2);
    for num_bar = 1:8
        bar(num_bar, res_score_d(num_bar,num_im),'BarWidth',0.95,'EdgeAlpha',0.0);
        hold on
    end
    set(sub22,'XTick',[0 9],'YTick',0:0.1:1,'TickLength',[0 1],'Xticklabel',[],'Yticklabel',[]);
    hold off
    grid on;
    set(sub22,'GridAlpha',0.8);
    set(sub22,'Color',[0 0 0]);
    ylim([0 1]);
    
    set(sub21,'Position',[0 0.45 1 0.5]);
    set(sub22,'Position',[0.1 0.1 0.8 0.3]);
    
    drawnow
end
