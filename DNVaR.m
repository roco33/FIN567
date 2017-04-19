function VaR = DNVaR(c,position)

%deleta-normal VaR
%use 200 observations, further update needed
%simple estimation with weighted average used to estimate standard
%deviation, Christoffersen Chapter 4; Person Chapter 3

fields = fieldnames(c);
rr = zeros(length(fields),200);
p = zeros(1,length(fields));
%lambda missing

for i = 1: length(fields)
    raw = c.(fields{i});
    raw = table2array(raw);
    r1 = raw(1:end-1,2); %lag price
    r2 = raw(2:end ,2);
    r = (r1 ./ r2)-1;
    try
        rr1 = r(1:200);
    catch ME
        rr1 = r;
        rr1 = [rr1; zeros(200-length(rr1),1)];
    end
    rr(i,:) = rr1;
    p(i) = raw(1,2);
end

lambda = 0.94;

l = (1-lambda) * lambda.^(0:199);
l = ones(78,1) * l;

sig = rr .*l * rr'/sum(l(1,:));
v = p * position;
w = p' .* position / v;
sigma2 = w' * sig * w;
VaR = -norminv(0.05)*sqrt(sigma2)*v;