function links = tryLinks(pics)
load pics.mat
[h,w] = size(pics);
links = zeros(h*w/2,4);
it = 1;
while it <= h*w/2
    hasLink = false;
    for m = 1:h*w-1
        if pics(m) == 0
            continue;
        else
            for n = m+1:h*w
%                 disp([mod(m-1,h)+1,ceil(m/h)]);
%                 disp([mod(n-1,h)+1,ceil(n/h)]);
                if pics(m) == pics(n) && detect(pics,[mod(m-1,h)+1,ceil(m/h)],[mod(n-1,h)+1,ceil(n/h)],true)
                    links(it,:) = [mod(m-1,h)+1,ceil(m/h),mod(n-1,h)+1,ceil(n/h)];
                    it = it + 1;
                    pics(m) = 0;
                    pics(n) = 0;
                    hasLink = true;
                    break;
                end
            end
            if hasLink
                break;
            end
        end
    end
    if ~hasLink
        warning('无块可消，进入死锁状态');
        break;
    end
end
end
