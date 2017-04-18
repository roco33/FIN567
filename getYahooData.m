function stock = getYahooData(tickers, startDate, endDate, Format)

%Function inputs are ticker vector, start date string, end date string, and
%date format string. For example, to download the close price of Apple and
%Alphabet for 2015/1/1 to 2016/1/1, getYahooData({'AAPL'; 'GOOGL'}, 
%'20160101', '20170101', 'yyyymmdd')
%This function outputs a structure variable containing tables with ticker
%name.
%Update 1: draw dividend data from website

%standerdize the date inputs
startDate = datenum(startDate, Format);
endDate = datenum(endDate, Format);

%read year, month and date
[y1, m1, d1] = ymd(datetime((startDate), 'ConvertFrom', 'Datenum'));
[y2, m2, d2] = ymd(datetime((endDate), 'ConvertFrom', 'Datenum'));

%write the Yahoo! finance link as strings url1 url2 url3
url1 = 'http://chart.finance.yahoo.com/table.csv?s=';

%create a waite bar showing the working progress of the script
h = waitbar(0, 'Processing...');

%for loop getting data for every ticker in ticker vector
for i = 1: length(tickers)
    %tickers{i}
    %read data from Yahoo! finance
    div = 'd';
    url2 = ['&a=' num2str(m1-1) '&b=' num2str(d1) '&c=' num2str(y1) ...
    '&d=' num2str(m2-1) '&e=' num2str(d2) '&f=' num2str(y2) ...
    '&g=' div '&ignore=.csv'];
    data = webread([url1 tickers{i} url2]);
    %read data and assign values into Matlab table veriable
%    data = table2array(str);
    date = data.Date;
    date = datenum(date, 'yyyy-mm-dd');
    
    
%    c = textscan(str, '%s%f%f%f%f%f%f',...
%    'Delimiter', ',', 'HeaderLines',1);
%    date = datenum(c{1},'yyyy-mm-dd');
    d = zeros(length(date),1);
    stock.(tickers{i}) = table(date,data.AdjClose,d,'VariableNames',...
        {'Date','AdjClose','Dividend'});
    %dividend data
    div = 'v';
    url2 = ['&a=' num2str(m1-1) '&b=' num2str(d1) '&c=' num2str(y1) ...
    '&d=' num2str(m2-1) '&e=' num2str(d2) '&f=' num2str(y2) ...
    '&g=' div '&ignore=.csv'];
%    data = table2array(str);
    data = webread([url1 tickers{i} url2]);
    date2 = data.Date;
%    date = datenum(date, 'yyyy-mm-dd');
%    c = textscan(str, '%s%f', 'Delimiter', ',', 'HeaderLines',1);
    try
        date2 = datenum(date2,'yyyy-mm-dd');
        for j = 1: length(date)
            if ismember(date(j), date2) == 1
                r = find(date2 == date(j));
                stock.(tickers{i}){j,3} = data.Dividends(r);
            end
        end
    catch ME
    end
    waitbar(i/length(tickers),h, ['Processing...' num2str(i)...
        '/' num2str(length(tickers))])
end
close(h)
end
