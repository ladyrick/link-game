function linkgame( stage )
%���������
%   stage�ǹؿ�״̬����ѡ��Ϊ:
%   'still':��ֹ����
if nargin == 0
    stage = 'still';
end
addpath('tools');

screen = screensnap();

fig = figure;
imshow(screen);
[height,width,~] = size(screen);

% ���µ��������Ծ�������Ϊ׼������Ļ���ꡣ
pos1 = fliplr(round(ginput(1)));
pos2 = fliplr(round(ginput(1)));

assert(min([pos1,pos2])>=1 ...
    && max([pos1(1),pos2(1)])<=height ...
    && max([pos1(2),pos2(2)])<=width, ...
    'ѡ��������Ļ֮�⡣');

% ��ȡͼ�����ϽǺ����½����ꡣ
poslu = min(pos1,pos2);
posrd = max(pos1,pos2);
screen(poslu(1),poslu(2),:) = 0;
screen(posrd(1),posrd(2),:) = 0;

set(get(fig,'currentobject'),'cdata',screen);

mainscreen = screen(poslu(1):posrd(1),poslu(2):posrd(2),:);
imshow(mainscreen);



end
