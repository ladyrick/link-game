function isReachable = detect( pics, pos1, pos2, extendedBorder )
%判断是否可以消去.
%   pics是块矩阵，pos1是第一个点的坐标，pos2是第二个点的坐标
%   extendedBorder为可选参数，可以为true或false，默认为false，即不扩展边框

assert(nargin >= 3,'输入参数的数目不足。');
[m,n] = size(pics);
if nargin == 3 || extendedBorder == false
    pics_local = ones(m+2,n+2); %全1封闭边框
else
    pics_local = zeros(m+2,n+2); %全0开放边框
end
pics_local(2:end-1,2:end-1) = pics;
pos1 = pos1 + 1;
pos2 = pos2 + 1;
m = m + 2;
n = n + 2;


for i = pos1(1)-1:-1:1
    if pics_local(i,pos1(2)) > 0
        break;
    elseif isReachableInTwoLines(pics_local,[i,pos1(2)],pos2)
        isReachable = true;
        return;
    end
end

for i = pos1(1)+1:m
    if pics_local(i,pos1(2)) > 0
        break;
    elseif isReachableInTwoLines(pics_local,[i,pos1(2)],pos2)
        isReachable = true;
        return;
    end
end

for i = pos1(2)-1:-1:1
    if pics_local(pos1(1),i) > 0
        break;
    elseif isReachableInTwoLines(pics_local,[pos1(1),i],pos2)
        isReachable = true;
        return;
    end
end

for i = pos1(2)+1:n
    if pics_local(pos1(1),i) > 0
        break;
    elseif isReachableInTwoLines(pics_local,[pos1(1),i],pos2)
        isReachable = true;
        return;
    end
end

% 经过多轮测试均发现无法连接消去，则返回false
isReachable = false;

end

function returnValue = isReachableInTwoLines(pics_local,pos1,pos2)
if pos1(1) == pos2(1) || pos1(2) == pos2(2)
    returnValue = isReachableDirectly(pics_local,pos1,pos2);
    return
end

pos3 = [pos1(1),pos2(2)];
pos4 = [pos2(1),pos1(2)];

returnValue = (pics_local(pos1(1),pos2(2)) == 0 ...
    && isReachableDirectly(pics_local,pos1,pos3) ...
    && isReachableDirectly(pics_local,pos2,pos3)) ...
    || (pics_local(pos2(1),pos1(2)) == 0 ...
    && isReachableDirectly(pics_local,pos1,pos4) ...
    && isReachableDirectly(pics_local,pos2,pos4));

% debug1 = pics_local(pos1(1),pos2(2)) == 0;
% debug2 = isReachableDirectly(pics_local,pos1,pos3);
% debug3 = isReachableDirectly(pics_local,pos2,pos3);
% debug4 = pics_local(pos2(1),pos1(2)) == 0;
% debug5 = isReachableDirectly(pics_local,pos1,pos4);
% debug6 = isReachableDirectly(pics_local,pos2,pos4);

end

function returnValue = isReachableDirectly(pics_local,pos1,pos2)
if pos1(1) == pos2(1) && pos1(2) == pos2(2)
    returnValue = true;
elseif pos1(1) == pos2(1)
    scope = pos1(2):pos2(2);
    for n = scope(2:end-1)
        if pics_local(pos1(1),n) > 0
            returnValue = false;
            return;
        end
    end
    returnValue = true;
elseif pos1(2) == pos2(2)
    scope = pos1(1):pos2(1);
    for n = scope(2:end-1)
        if pics_local(n,pos1(2)) > 0
            returnValue = false;
            return;
        end
    end
    returnValue = true;
else
    error('传入参数错误，两点并不在一条直线上。');
end
end
