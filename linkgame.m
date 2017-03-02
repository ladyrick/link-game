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
close(fig);

assert(min([pos1,pos2])>=1 ...
    && max([pos1(1),pos2(1)])<=height ...
    && max([pos1(2),pos2(2)])<=width, ...
    'ѡ��������Ļ֮�⡣');

% ��ȡͼ�����ϽǺ����½����ꡣ
poslu = min(pos1,pos2);
posrd = max(pos1,pos2);


% h��w����Ŀ���
hnpics = input('h = ');
wnpics = input('w = ');
% h��w���������
hpic = (posrd(1) - poslu(1))/hnpics;
wpic = (posrd(2) - poslu(2))/wnpics;

% �ڿ���ߣ�ûɶ������ʵ��
for n = 0:hnpics
    screen(round(poslu(1)+n*hpic),:,:) = 0;
end
for n = 0:wnpics
    screen(:,round(poslu(2)+n*wpic),:) = 0;
end

% ȡ�������飬����һ��cell���档�Ѹ����������Ҳ������һ��cell����
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

% ��ʾ���ָ�����Ŀ�
% mainscreen = screen(poslu(1):posrd(1),poslu(2):posrd(2),:);
% figure;imshow(mainscreen);

% ʶ��飬���Ϊһ������
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
