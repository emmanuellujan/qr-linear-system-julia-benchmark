[sizes, times] = benchmark();
dlmwrite('matlab-blackslash.csv',[sizes, times],'precision',15)
%dlmwrite('matlab-qr.csv',[sizes, times],'precision',15)
function [sizes, times] = benchmark()
    rows = 1000:1000:5000;
    cols = 30:10:100;
    num_sizes = size(rows, 2) * size(cols, 2);
    nexp = 100;
    sizes = zeros(num_sizes, 1);
    times = zeros(num_sizes, 1);
    i = 1;
    for r = rows
        for c = cols
            i, r, c
            s = 0.0;
            for e = 1:nexp
                A = randn(r, c);
                B = randn(r, 1);
                tic;
                %[qq,rr] = qr(A);
                %rr\qq.'*B;
                A \ B;
                s = s + toc;
            end
            sizes(i) = r * c;
            times(i) = s / nexp;
            i = i + 1;
        end
    end 
end
