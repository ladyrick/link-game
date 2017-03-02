function pics = recognizePics(picscell)

load('picscell.mat');
[h,w] = size(picscell);
pics = zeros(h,w);

% it = 1;
% for m = 1:h
%     for n = 1:w
%         subplot(h,w,it);imshow(picscell{m,n});
%         it = it + 1;
%     end
% end

% 每个pic的大小
[h_,w_,~] = size(picscell{1,1});
indexh = round([h_*0.25,h_*0.5,h_*0.75]);
indexw = round([w_*0.25,w_*0.5,w_*0.75]);

features = cell(h*w,1);
it = 0;
for m = 1:h
    for n = 1:w
        if size(picscell{m,n},3) == 3
            p = rgb2gray(picscell{m,n});
        else
            p = picscell{m,n};
        end
        matched = false;
        for k = 1:it
            if matchFeature(p,features{k},indexh,indexw)
                pics(m,n) = k;
                matched = true;
                break;
            end
        end
        
        if matched
            continue;
        else
            feature = p(indexh,indexw);
            it = it + 1;
            features{it} = feature;
            pics(m,n) = it;
        end
    end
end
end

function matched = matchFeature(p,feature,indexh,indexw)
matched = false;
[h,w] = size(p);
for m = 1-indexh(1):h - indexh(end)
    for n = 1-indexw(1):w - indexw(end)
        tf = p(m+indexh,n+indexw);
        if all(tf == feature)
            matched = true;
            return;
        end
    end
end
end
