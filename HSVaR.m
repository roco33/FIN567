function VaR = HSVaR(c, positions)

%historical simulation VaR

fields = fieldnames(c);
VaR = [];

for i = 1: length(fields)
    raw = c.(fields{i});
    raw = table2array(raw);
    r1 = raw(1:end-1, 2); %lag price
    r2 = raw(2:end, 2);
    r = r1 ./ r2 -1;
    Var = -quantile(r, 0.05)*raw(1,2)*positions(i);
    VaR = [VaR Var];
end

VaR = sum(VaR);