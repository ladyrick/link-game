function linkgame( stage )
%连连看外挂
%   stage是关卡状态，可选项为:
%   'still':静止不动
if nargin == 0
    stage = 'still';
end
addpath('tools');

screen = screensnap();
fig = figure;
imshow(screen);
[height,width,~] = size(screen);

% 以下点的坐标均以矩阵坐标为准，非屏幕坐标。
pos1 = fliplr(round(ginput(1)));
pos2 = fliplr(round(ginput(1)));
close(fig);

assert(min([pos1,pos2])>=1 ...
    && max([pos1(1),pos2(1)])<=height ...
    && max([pos1(2),pos2(2)])<=width, ...
    '选点落在屏幕之外。');

% 截取图的左上角和右下角坐标。
poslu = min(pos1,pos2);
posrd = max(pos1,pos2);


% h和w方向的块数
hnpics = input('h = ');
wnpics = input('w = ');
% h和w方向的周期
hpic = (posrd(1) - poslu(1))/hnpics;
wpic = (posrd(2) - poslu(2))/wnpics;

% 黑框描边？没啥卵用其实。
for n = 0:hnpics
    screen(round(poslu(1)+n*hpic),:,:) = 0;
end
for n = 0:wnpics
    screen(:,round(poslu(2)+n*wpic),:) = 0;
end

% 取出各个块，存在一个cell里面。把各个块的坐标也保存在一个cell里面
picscell = cell(hnpics,wnpics);
picsposcell = cell(hnpics,wnpics);
it=1;
% figure;
for n = 1:hnpics
    for m = 1:wnpics
        picscell{n,m} = screen( ...
            round(poslu(1)+(n-1)*hpic):round(poslu(1)+n*hpic), ...
            round(poslu(2)+(m-1)*wpic):round(poslu(2)+m*wpic),:);
        picsposcell{n,m} = [round(poslu(1)+(n-0.5)*hpic),round(poslu(2)+(m-0.5)*wpic)];
%         subplot(hnpics,wnpics,it);imshow(picscell{n,m});
        it = it + 1;
    end
end

% 显示被分割出来的块
% mainscreen = screen(poslu(1):posrd(1),poslu(2):posrd(2),:);
% figure;imshow(mainscreen);

% 识别块，输出为一个矩阵。
save picscell.mat picscell picsposcell;
pics = recognizePics(picscell);

save pics.mat pics

%%
load picscell.mat
load pics.mat
links = tryLinks(pics);
disp(links);
pause(2);
it = 1;
while it <= size(links,1) && links(it,1) ~= 0
    pos1 = picsposcell{links(it,1),links(it,2)};
    pos2 = picsposcell{links(it,3),links(it,4)};
    mousemove(pos1(2),pos1(1));
    mouseclick(1,1);
    pause(0.05);
    mousemove(pos2(2),pos2(1));
    mouseclick(1,1);
    pause(0.05);
    it = it + 1;
end
end
