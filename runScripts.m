%
file = 'StateStreetNorthAmericanETFs.csv';
disp(['Ticker file is ' file])
a = readtable(file, 'Delimiter', ',', 'Format','%s%s');
tickers = table2array(a(:,1));

startdate = '20120101';
enddate = '20170417';
disp(['Observation start date is ' startdate ', end date is ' enddate])

positions = ones(78,1);
disp('Hypothetical positions are ')
disp(positions')

disp('Retrieving data from Yahoo! Finance...')
c = getYahooData(tickers, startdate,enddate,'yyyymmdd');
VaR2 = WHSVaR(c,positions);
VaR3 = DNVaR(c,positions);
a = ['5% VaR using weighted historical simulation method is ' num2str(VaR2)];
b = ['5% VaR using Delta Normal method is ' num2str(VaR3)];
disp(a)
disp(b)
disp('----------------------------done---------------------------------')