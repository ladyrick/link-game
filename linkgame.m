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

assert(min([pos1,pos2])>=1 ...
    && max([pos1(1),pos2(1)])<=height ...
    && max([pos1(2),pos2(2)])<=width, ...
    '选点落在屏幕之外。');

% 截取图的左上角和右下角坐标。
poslu = min(pos1,pos2);
posrd = max(pos1,pos2);
screen(poslu(1),poslu(2),:) = 0;
screen(posrd(1),posrd(2),:) = 0;

set(get(fig,'currentobject'),'cdata',screen);

mainscreen = screen(poslu(1):posrd(1),poslu(2):posrd(2),:);
imshow(mainscreen);



end
