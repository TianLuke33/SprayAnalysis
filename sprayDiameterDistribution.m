% This is a code for spray droplets diameters data processing.
% The most basical question for spray research is how many droplets in the
% spray. From here, another question is how many droplets in each diameter
% interval. This code covers these topics.
% The database has 1000 droplets diameter
% author: TianLuke33
% Date: 9_10_2024

% For out put image, so don't have to scream cut
delete(findall(gcf,'type','uicontrol')) % Delete all UI contorls
set(gcf,'color',[1 1 1]); % Set the figure frame color to white
set(gca,'color',[1 1 1]); % Set the axis frame color to white
set(findall(gcf,'type','text'),'FontName','Times',...
'FontSize',TextSize,...
'FontUnits','points') % Set font and font size
set(gcf,'PaperOrientation','portrait',...
'PaperPosition',[0 0 sizex sizey],...
'PaperPositionMode','manual',...
'PaperSize',[sizex sizey],...
'PaperUnits','inches') % Set the size of the figure when printed
set(findall(gcf,'Type','axes'),'FontName','Times',...
'FontSize',TextSize,...
'FontUnits','points',...
'LineWidth',1,...
'TickDir','out') % Set axes fonts as well
set(gcf,'InvertHardCopy','off');% gcf stands for Get Current Figure
% Example of runing the output image
%print(gcf,'-dpng','-r300','OutputImage.png');

%% Load the data for the HW
clear
close all
data = importdata("HW3Data.csv");%load data to matlab
% To have a basical idea for the data, fist find out the biggest size and
% smallest size in the list
maxSize = max(data);% check the biggest size in the list
disp(["Maximum Droplet Size:",num2str(maxSize*10^6)])% conform unit from m to um,28.5241um
minSize = min(data);% check the smallest size in the list
disp(["Minimum Droplet Size:",num2str(minSize*10^6)])%0.37905um

%% a) Plot histograms and probabilities, with 5,10,25,50bins
% In this part, plotting 5,10,25,50 bins with particle diameters. In this
% way the distribution of droplets size can be seen visual. Using two ways
% for plot. One is counts from all the 1000 data. Another one calculate the
% probabilities for each bin. Base on requirement, those two ways can be
% applied in different situation
% Compare the bins number, it is not necessary to have too many. around 15
% is good enough
plotHisCouAndPro(data,10);% Call the function and input the data and number of bins (5,10,25,50)
%% b) Calculate the mean diameters
% Mean diameters can be trick. Based on the spay some time the connection
% between volume and diameter are more useful for analsis
% D_10 is the number mean diameter
data = importdata("HW3Data.csv");
data_um = data*1e6;% Scale data to unit um
D_10 = charDiameter(data_um,1,0);
disp(['number mean diameter,D_10:',num2str(D_10),'um']);
% D_30 is the volume mean diameter
volumedata = data_um .^ 3;
D_30 = charDiameter(data_um,3,0);
disp(['volume mean diameter,D_30:',num2str(D_30),'um']);
% D_32 is the sauter mean diameter
D_32 = charDiameter(data_um,3,2);
disp(['sauter mean diameter,D_32:',num2str(D_32),'um']);
%% c) Plot number and volume probability densities as a function of the particle diameter, include 5,10,25,50 bins. Include95% confidence intervals
volProDen(data,10);
%% d) Rosin-Rammler distribution(aka Weibull distribution)
% distribution can show better continue prediction
RosRamDistribution(data,15)

%% e) Calculate D_32 with optimum X,q
X = 20.3902;
q = 4.9627;
D_32 = X/gamma(1-1/q)
%% Functions and notes
function plotHisCouAndPro(data, bin)
    data_um = data*1e6; % Change the units from meter to um
    average = mean(data_um); 
    BinEdges = linspace(min(data_um),max(data_um),bin+1);
    binCenter = (BinEdges(1:end-1)+BinEdges(2:end))/2;% find out the center of each bin
    [counts,edges]=histcounts(data_um,bin);
    pCounts = counts./sum(counts);
    
    figure;
    subplot(1,2,1);
    histogram('BinEdges',edges,'BinCounts',counts)
    hold on
    % Add in mean diameter as text
    ylim = get(gca,'ylim');
    xlim = get(gca,'xlim');
    text (xlim(2)-0.35*xlim(2),ylim(2)-0.05*ylim(2),sprintf('$$\\bar{x} =$$ %.3f $$\\mu$$m',average),'Interpreter','latex','fontsize',14);
    title(sprintf ('Particle Diameter Histogram $$n_ { bins } =$$ %i',bin ) ,'Interpreter','latex')
    xlabel('Drop Diameter[um]');
    ylabel('Count');

    subplot(1,2,2);
    histogram('BinEdges',edges,'BinCounts',pCounts)
    % Add in mean diameter as text
    ylim = get(gca,'ylim');
    xlim = get(gca,'xlim');
    text (xlim(2)-0.35*xlim(2),ylim(2)-0.05*ylim(2),sprintf('$$\\bar{x} =$$ %.3f $$\\mu$$m',average),'Interpreter','latex','fontsize',14);
    title(sprintf ('Particle Diameter Histogram $$n_ { bins } =$$ %i',bin ) ,'Interpreter','latex')
    xlabel('Drop Diameter[um]');
    ylabel('Probability [%]');
    TextSize = 14;
    sizex = 15;
    sizey = 7.5;
    delete(findall(gcf,'type','uicontrol')) % Delete all UI contorls
    set(gcf,'color',[1 1 1]); % Set the figure frame color to white
    set(gca,'color',[1 1 1]); % Set the axis frame color to white
    set(findall(gcf,'type','text'),'FontName','Times',...
    'FontSize',TextSize,...
    'FontUnits','points') % Set font and font size
    set(gcf,'PaperOrientation','portrait',...
    'PaperPosition',[0 0 sizex sizey],...
    'PaperPositionMode','manual',...
    'PaperSize',[sizex sizey],...
    'PaperUnits','inches') % Set the size of the figure when printed
    set(findall(gcf,'Type','axes'),'FontName','Times',...
    'FontSize',TextSize,...
    'FontUnits','points',...
    'LineWidth',1,...
    'TickDir','out') % Set axes fonts as well
    set(gcf,'InvertHardCopy','off');
    %print(gcf,'-dpng','-r300','Histogram %i bins.png',bin);
    saveas(gcf,sprintf ('Histogram %i bins.png',bin));
    hold off;
end

function D_mn = charDiameter(X,m,n)
    % Function to calculate characteristic diameter function
    X_m = X.^m;
    X_n = X.^n;
    S_m = sum(X_m);
    S_n = sum(X_n);
    D_mn = (S_m/S_n)^(1/(m-n));
end

function volProDen(data,bin)
    % To calculate volume probability densities(f_3), we need number probability
    % density(f_0) firstly
    data_um = data*1e6;% change units to um
    BinEdges = linspace(min(data_um),max(data_um),bin+1);
    binCenter = (BinEdges(1:end-1)+BinEdges(2:end))/2;% find out the center of each bin
    [counts,edges]=histcounts(data_um,bin);% find out the center of each bin
    pCounts = counts./sum(counts);% Compute probability for each bin
    pdfC = pCounts/(edges(2)-edges(1)); %the number probability density can be get for each bin
    pdfV = pdfC.*(binCenter.^3)/sum(pdfC.*(binCenter.^3)*(edges(2)-edges(1)));
    Neg = poissinv(0.025,counts)./trapz(binCenter,counts); % lower 2.5% limit
    Pos = poissinv(0.975,counts)./trapz(binCenter,counts); % upper 97.5% limit
    Negv = poissinv(0.025,counts).*binCenter.^3/trapz(binCenter,counts.*binCenter.^3); % lower 2.5% limit
    Posv = poissinv(0.975,counts).*binCenter.^3/trapz(binCenter,counts.*binCenter.^3); % upper 97.5% limit
    
    figure;
    subplot(1,2,1);
    histogram('BinEdges',edges,'BinCounts',pdfC)
    hold on;
    
    er = errorbar(binCenter,pdfC,pdfC-Neg,Pos-pdfC);
    er.Color = [0 0 0];
    er.LineStyle ='none';
    title(sprintf ('Particle Number Probability Density $$n_{bins} =$$ %i',bin),"Interpreter","latex");
    xlabel('Diameter,[$\mu$m]','Interpreter','latex');
    ylabel('Number Probability Density, $(f_0(D))$, $\left[\frac{1}{\mu m}\right]$','Interpreter','latex');
    legend('Histogram','Confidence intervals');

    subplot(1,2,2);
    histogram('BinEdges',edges,'BinCounts',pdfV)
    hold on;
    
    er = errorbar(binCenter,pdfV,pdfV-Negv,Posv-pdfV);
    er.Color = [0 0 0];
    er.LineStyle ='none';
    title(sprintf ('Particle Volume Probability Density $$n_{bins} =$$ %i',bin),"Interpreter","latex");
    xlabel('Diameter,[$\mu$m]','Interpreter','latex');
    ylabel('Volume Probability Density, $(f_0(D))$, $\left[\frac{1}{\mu m}\right]$','Interpreter','latex');
    legend('Histogram','Confidence intervals');
    TextSize = 14;
    sizex = 15;
    sizey = 7.5;
    delete(findall(gcf,'type','uicontrol')) % Delete all UI contorls
    set(gcf,'color',[1 1 1]); % Set the figure frame color to white
    set(gca,'color',[1 1 1]); % Set the axis frame color to white
    set(findall(gcf,'type','text'),'FontName','Times',...
    'FontSize',TextSize,...
    'FontUnits','points') % Set font and font size
    set(gcf,'PaperOrientation','portrait',...
    'PaperPosition',[0 0 sizex sizey],...
    'PaperPositionMode','manual',...
    'PaperSize',[sizex sizey],...
    'PaperUnits','inches') % Set the size of the figure when printed
    set(findall(gcf,'Type','axes'),'FontName','Times',...
    'FontSize',TextSize,...
    'FontUnits','points',...
    'LineWidth',1,...
    'TickDir','out') % Set axes fonts as well
    set(gcf,'InvertHardCopy','off');
    %print(gcf,'-dpng','-r300','Histogram %i bins.png',bin);
    saveas (gcf,sprintf('Probability Density %i bins.png',bin));
    hold off;

end

d=nan(1,n);% initialize n values
pd =pd./max(pd);%normalized pd so the max value is 1
nsamp = 0;% start at 0
while nsamp <=  n
    dsamp = min(X)+rand(1)*(max(X)-min(X));
    idx = find(dsamp>=X(1:end-1)&dsamp<X(2:end));
    Num =rand(1);
    if Num<=pd(idx)
        nsamp = nsamp +1;
        d(samp)=dsamp;
    end
end

function f = RosRamDistribution(data,bin)
    % Define a function that calculates the negative log-likelihood
    % To calculate volume probability densities(f_3), we need number probability
    % density(f_0) firstly
    data_um = data*1e6;% change units to um
    [counts,edges]=histcounts(data_um,bin);
    binCenter = (edges(1:end-1)+edges(2:end))/2;% find out the center of each bin
    [counts,edges]=histcounts(data_um,bin);% find out the center of each bin
    pCounts = counts./sum(counts);% Compute probability for each bin
    pdfC = pCounts/(edges(2)-edges(1)); %the number probability density can be get for each bin
    pdfV = pdfC.*(binCenter.^3)/sum(pdfC.*(binCenter.^3)*(edges(2)-edges(1)));
    Neg = poissinv(0.025,counts)./trapz(binCenter,counts); % lower 2.5% limit
    Pos = poissinv(0.975,counts)./trapz(binCenter,counts); % upper 97.5% limit
    Negv = poissinv(0.025,counts).*binCenter.^3/trapz(binCenter,counts.*binCenter.^3); % lower 2.5% limit
    Posv = poissinv(0.975,counts).*binCenter.^3/trapz(binCenter,counts.*binCenter.^3); % upper 97.5% limit
    [phat,pci] = mle(data_um,'pdf',@(x,a,b)weib(x,a,b),'Start',[20,6],'Options',statset('FunValCheck','off','MaxIter',200),...
    'LowerBound',[1 1],'UpperBound',[100 100]);
    X = phat(1);
    q = phat(2);
    x = linspace(0,30,1000);
    p = weib(x,X,q);
    pv = vweib(x,X,q);

    figure;
    subplot(1,2,1);
    histogram('BinEdges',edges,'BinCounts',pdfC)
    hold on;
    er = errorbar(binCenter,pdfC,pdfC-Neg,Pos-pdfC);
    er.Color = [0 0 0];
    er.LineStyle ='none';
    plot(x,p,'r')
    ylim = get(gca,'ylim');
    xlim = get(gca,'xlim');
    title(sprintf('Particle Number Probability Density $$n_{bins} =$$ %i',bin),"Interpreter","latex");
    xlabel('Diameter,[$\mu$m]','Interpreter','latex');
    ylabel('Number Probability Density, $(f_0(D))$, $\left[\frac{1}{\mu m}\right]$','Interpreter','latex');
    axis([xlim,0,0.1])
    legend('$f_0(D)$','',sprintf('Weibull Fit(X = %.3f,q = %.3f)',phat(1),phat(2)),'Location','northwest','Interpreter','latex')

    subplot(1,2,2);
    histogram('BinEdges',edges,'BinCounts',pdfV)
    hold on;
    
    er = errorbar(binCenter,pdfV,pdfV-Negv,Posv-pdfV);
    er.Color = [0 0 0];
    er.LineStyle ='none';
    plot(x,pv,'r')
    title(sprintf('Particle Volume Probability Density $$n_{bins} =$$ %i',bin),"Interpreter","latex");
    xlabel('Diameter,[$\mu$m]','Interpreter','latex');
    ylabel('Volume Probability Density, $(f_0(D))$, $\left[\frac{1}{\mu m}\right]$','Interpreter','latex');
    legend('$f_3 (D)$','',sprintf('Weibull Fit(X = %.3f,q = %.3f)',phat(1) ,phat(2)),'Location','northwest','Interpreter','latex')
    TextSize = 14;
    sizex = 15;
    sizey = 7.5;
    delete(findall(gcf,'type','uicontrol')) % Delete all UI contorls
    set(gcf,'color',[1 1 1]); % Set the figure frame color to white
    set(gca,'color',[1 1 1]); % Set the axis frame color to white
    set(findall(gcf,'type','text'),'FontName','Times',...
    'FontSize',TextSize,...
    'FontUnits','points') % Set font and font size
    set(gcf,'PaperOrientation','portrait',...
    'PaperPosition',[0 0 sizex sizey],...
    'PaperPositionMode','manual',...
    'PaperSize',[sizex sizey],...
    'PaperUnits','inches') % Set the size of the figure when printed
    set(findall(gcf,'Type','axes'),'FontName','Times',...
    'FontSize',TextSize,...
    'FontUnits','points',...
    'LineWidth',1,...
    'TickDir','out') % Set axes fonts as well
    set(gcf,'InvertHardCopy','off');
    %print(gcf,'-dpng','-r300','Histogram %i bins.png',bin);
    saveas (gcf,sprintf('Volume Probability Density %i bins.png',bin));
    hold off;
end

% The following code is used to get counts, can be replaced by hiscounts()
% function
data_sort = sort(data_um);
    data_matrix = cell(1,bin);
    k=1;
    for n = 1:(length(edges)-1)
        for m = k:length(data)
            if data_sort(m)<=edges(n+1)
                data_matrix{n}(end+1) = data_sort(m);
                k=k+1;
            else
                break;
            end
        end
    end
    for n = 1:(length(edges)-1)
        t = tinv([0.025 0.975],length(data_matrix{n}));
        CI(end+1) = t(2)*(std_data/sqrt(length(data_matrix{n})));
    end

function p = weib (x,a,b) % Weibull number PDF
    y = linspace (0 ,1000 ,1000000) ;
    p_0 = b/(a^b)*(y).^(b -4) .* exp (-(y/a).^b);
    P = trapz (y, p_0 );
    A = 1/P;
    p = A*b/(a^b)*(x) .^(b -4) .* exp (-(x/a).^b);
end

function p = vweib (x,a,b) % Weibull volume PDF
    p = b/a*(x/a) .^(b -1) .* exp (-(x/a).^b);
end