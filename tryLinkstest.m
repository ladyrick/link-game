function tryLinkstest()
blocks = ceil(randperm(128)/4);
pics = zeros(8,16);
for m = 1:8*16
    pics(m) = blocks(m);
end

disp(pics)
        







end

function [ cleared, links ] = tryLinks( pics )


[h,w] = size(pics);

links_longest = [];
links_length = 0;

for m1 = 1:h
for n1 = 1:w
for m2 = 1:h
for n2 = 1:w
    if pics(m1,n1) == pics(m2,n2) && detect(pics,[m1,n1],[m2,n2])
        pics_ = pics;
        pics_(m1,n1) = 0;
        pics_(m2,n2) = 0;
        [cleared_, links_] = tryLinks(pics_);
        if cleared_
            cleared = true;
            links = [m1,n1,m2,n2;links_];
            return;
        elseif size(links_,2) > links_length
            links_longest = [m1,n1,m2,n2;links_];
        end
    end
end
end
end
end

cleared = false;
links = links_longest;

end

