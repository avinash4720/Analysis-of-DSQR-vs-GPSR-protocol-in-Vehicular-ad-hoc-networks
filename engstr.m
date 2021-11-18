function [y]=engstr(x)
    a=@(x) [x*10.^(-3*floor(log10(abs(x))/3))  3*floor(log10(abs(x))/3)];

end