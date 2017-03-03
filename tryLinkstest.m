function tryLinkstest()
blocks = ceil(randperm(128)/4);
pics = zeros(8,16);
for m = 1:8*16
    pics(m) = blocks(m);
end

disp(pics)

[cleared,links] = tryLinks(pics)




end

function [ cleared, links ] = tryLinks( pics )
if all(pics == 0)
    cleared = true;
    links = [];
    return;
end

[h,w] = size(pics);

links_longest = [];

for mn1 = 1:h*w-1
    n1 = ceil(mn1/h);
    m1 = mn1 - (n1-1)*h;
    if pics(m1,n1) > 0
        for mn2 = mn1+1:h*w
            n2 = ceil(mn2/h);
            m2 = mn2 - (n2-1)*h;
            if pics(m1,n1) == pics(m2,n2) && detect(pics,[m1,n1],[m2,n2])
%                 disp([m1,n1,m2,n2]);
                pics_ = pics;
                pics_(m1,n1) = 0;
                pics_(m2,n2) = 0;
                t = pics_(:,n1);
                
                % fall down
                pics_(:,n1) = [t(t==0);t(t>0)];
                t = pics_(:,n2);
                pics_(:,n2) = [t(t==0);t(t>0)];
                [cleared_, links_] = tryLinks(pics_);
                
                
                if cleared_
                    cleared = true;
                    links = [m1,n1,m2,n2;links_];
                    return;
%                 elseif size(links_,2) > size(links_longest,2)
%                     links_longest = [m1,n1,m2,n2;links_];
                end
            end
        end
    end
end

cleared = false;
links = links_longest;

end

