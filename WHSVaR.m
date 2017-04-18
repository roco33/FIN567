function VaR = WHSVaR(c, positions)

%historical simulation VaR

fields = fieldnames(c);
VaR = [];

% for i = 1: length(fields)
%     raw = c.(fields{i});
%     raw = table2array(raw);
%     r1 = raw(1:end-1, 2); %lag price
%     r2 = raw(2:end, 2);
%     r = r1 ./ r2 -1;
%     lambda = 0.99;
%     n1 = (1-lambda)/(1-lambda^length(r));
%     n = lambda.^(0:length(r)-1)' * n1;
%     a = sortrows([r n]);
%     s = 0;
%     j = 1;
%     while s < 0.05
%         s = s + a(j,2);
%         j = j+1;
%     end
%     s1 = s - a(j-1,2);
%     az = a(j-2,1) + (a(j-1,1)-a(j-2,1))*(0.05-s1)/(s-s1);
%     Var = -az*raw(1,2)*positions(i);
%     if Var < 0
%         Var = 0;
%     end
%     VaR = [VaR Var];
% end
% 
% VaR = sum(VaR);

data = zeros(200, 78);

for i = 1: length(fields)
    a = ones(200,1);
    raw = c.(fields{i});
    raw = table2array(raw);
    raw = raw(:,2);
    try
        a = raw(1:200,1);
    catch ME
        a(1:length(raw)) = raw;
    end
    data(1:length(a),i) = a;
end
p = data * positions;
p1 = p(1:end-1,:);
p2 = p(2:end, :);
r = p1 ./ p2 -1;
lambda = 0.99;
n1 = (1-lambda)/(1-lambda^length(r));
n = lambda.^(0:length(r)-1)' * n1;
a = sortrows([r n]);
s = 0;
j = 1;
while s < 0.05
    s = s + a(j,2);
    j = j+1;
end
s1 = s - a(j-1,2);
az = a(j-2,1) + (a(j-1,1)-a(j-2,1))*(0.05-s1)/(s-s1);
Var = -az*p(1,:)*positions(i);
if Var < 0
    Var = 0;
end

VaR = Var;