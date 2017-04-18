function VaR = DNVaR(c,position)

%deleta-normal VaR

fields = fieldnames(c);
var = zeros(length(fields),200);
p = zeros(1,length(fields));
%lambda missing

for i = 1: length(fields)
    raw = c.(fields{i});
    raw = table2array(raw);
    r1 = raw(1:end-1,2); %lag price
    r2 = raw(2:end ,2);
    r = log(r1 ./ r2);
    try
        var1 = r(1:200);
    catch ME
        var1 = r;
        var1 = [var1; zeros(200-length(var1),1)];
    end
    var(i,:) = var1;
    p(i) = raw(1,2);
end

lambda = 0.94;

l = (1-lambda) * lambda.^(0:199);
l = ones(78,1) * l;

sig = var .*l * var'/sum(l(1,:));
v = p * position;
w = p' .* position / v;
sigma2 = w' * sig * w;
VaR = -norminv(0.05)*sqrt(sigma2)*v;