% This is a code create for simulate the spray drop with winds and other
% force affect. Focus on drop breakup processing
% Then compare the simulation with experiment data
% Author: Tianluke33
% Date: 11_6_2024
%% Part a
% Simulation for drop fall with V_rel speed air flow from left to right
% Original diameter is D_0. Then drop turn into ellipse with D_c as long
% size. Simulate D_c/D_0 while time moving until 15ms
% Predict the cross-stream diameter of the deformed drop(D_c) as a function
% of time
% O'Rourke and Amsden proposed the Taylor Analogy Breakup(TAB) model.We
% replace the x in their equation into (D_c-D_0)/2 and get the equation
% applied in this part. D_0 is the original drop diamete.
clc;
clear;
C_2 = 2/3;% TAB constant
D_cD_0 = readtable('KrzeczkowskiFig10Data.csv');
D_0 = 5.6e-3;% Original Diameter [mm]
y0 = [D_0,0];% initial conditionds
v_rel = 23;% relative gas velocity [m/s]
rho_l = 1002;% Density of the droplet[kg/m^3]
mu_l = 0.892e-3;% Dynamic viscosity of the droplet[Pa*s]
sigma = 0.072;% Surface tension of the droplet[N/m]
rho_g = 1.234;% Assume density of the gas [kg/m^3]
tspan_1 = [0 15e-3];
[t,y] = ode45(@(t,y) tabode(t,y,mu_l,rho_l,D_0,sigma,rho_g,v_rel,C_2), tspan_1,y0);
figure;
plot(t*1000,(y(:,1)/D_0));
hold on;
scatter(D_cD_0.t*1000,D_cD_0.dcdo)
%scatter((D_cD_0(:,1).*1000),D_cD_0(:,2),50)
xlabel('time, t[ms]')
ylabel('d_c/d_0')
%ylabel('$\frac{d_c}{d_0}$','Interpreter','latex')
xlim([0,15]);
TextSize = 14;
sizex = 7.5;
sizey = 7.5;
title('Crop cross-stream diameter, D_c, predicted by TAB model for the conditions of Krzeczkowski')
legend('TAB model','Experiment')
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
print(gcf,'-dpng','-r300','OutputImageParta.png');
hold off;

%% Part b
% For part B, simulate with TAB for high and low Weber number cases. High
% We = 101, low We = 13.5 mediam We = 53
% Break times are 4.2ms(101), 6.5ms(53), 6.6ms(13.5) when d_c/d_0=1.5
% Or when d_c/d_0=1.6, 9ms(13.5) 11.5ms(53), 8ms(101)
clc;
clear;
C_2 = 2/3;% TAB constant
We_h = 101;% high We number for Fighre 11, time is [0,15] ms
D0_h = 5.6e-3;% Original Diameter for high We number[mm]
v_relh = 32;% relative gas velocity for high We number, [m/s]
D_cD_0h = readtable('KrzeczkowskiFig11Data.csv');

We_l = 13.5;% low We number for Figure 8, time is [0,30] ms
D0_l = 3.1e-3;% Original Diameter for low We number[mm]
v_rell = 15.7;% relative gas velocity for low We number, [m/s]
D_cD_0l = readtable('KrzeczkowskiFig8Data.csv');

y0 = [D0_l,0];% initial conditionds
rho_l = 1002;% Density of the droplet[kg/m^3]
mu_l = 0.892e-3;% Dynamic viscosity of the droplet[Pa*s]
sigma = 0.072;% Surface tension of the droplet[N/m]
rho_g = 1.234;% Assume density of the gas [kg/m^3]
tspan_h = [0 15e-3];
tspan_l = [0 30e-3];
%T_ini = 1.6;% the initiation time Hsiang and Faeth suggested
%T = t*v_rel*(rho_g^0.5)/((rho_l^0.5)*D_0);% time is non-dimensionalized
[t,y] = ode45(@(t,y) tabode(t,y,mu_l,rho_l,D0_l,sigma,rho_g,v_rell,C_2), tspan_l,y0);

figure;
plot(t*1000,(y(:,1)/D0_l));
hold on;
scatter(D_cD_0l.t*1000,D_cD_0l.dcdo)
%scatter((D_cD_0(:,1).*1000),D_cD_0(:,2),50)
xlabel('time, t[ms]')
ylabel('d_c/d_0')
%ylabel('$\frac{d_c}{d_0}$','Interpreter','latex')
xlim([0,30]);
TextSize = 14;
sizex = 7.5;
sizey = 7.5;
title('Low We case')
legend('TAB model','Experiment')
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
print(gcf,'-dpng','-r300','OutputImagePartbLow.png');
hold off;
%% Part c
% In this part we consider gas velocity decrease over time as reality
% Assume gravity and drag act on drop, applying Newton's second law to ODE
% equations
clc;
clear;
C_2 = 2/3;% TAB constant
D_cD_0 = readtable('KrzeczkowskiFig8Data.csv');
D_0 = 3.1e-3;% Original Diameter [mm]
y0 = [D_0,0];% initial conditionds
v_rel = 15.7;% relative gas velocity [m/s]
y0drag = [D_0,0,0,v_rel,0,0];% initial conditionds for drag case
rho_l = 1002;% Density of the droplet[kg/m^3]
mu_l = 0.892e-3;% Dynamic viscosity of the droplet[Pa*s]
sigma = 0.072;% Surface tension of the droplet[N/m]
rho_g = 1.234;% Assume density of the gas [kg/m^3]
tspan_1 = [0 30e-3];
[t1,y1] = ode45(@(t1,y1) tabode(t1,y1,mu_l,rho_l,D_0,sigma,rho_g,v_rel,C_2), tspan_1,y0);
mu_g = 1.8e-5;% assume dynamic viscosity of the air [Pa*s]
g = 9.81;% gravity number [m/s^2]
[t2,y2] = ode45(@(t2,y2) dragode(t2,y2,g,mu_l,mu_g,rho_l,D_0,sigma,rho_g,v_rel,C_2), tspan_1,y0drag);
figure;
plot(t1*1000,(y1(:,1)/D_0),t2*1000,(y2(:,1)/D_0));
hold on;
scatter(D_cD_0.t*1000,D_cD_0.dcdo)
xlabel('time, t[ms]')
ylabel('d_c/d_0')
%ylabel('$\frac{d_c}{d_0}$','Interpreter','latex')
xlim([0,30]);
TextSize = 14;
sizex = 7.5;
sizey = 7.5;
title('Crop cross-stream diameter')
legend('TAB model','TAB with drag','Experiment')
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
print(gcf,'-dpng','-r300','OutputImagePartc3.png');
hold off;


%% Bonus
% Ethanol drops test case similation
% Applying the data collected from lab

clc;
clear;
C_2 = 1;% TAB constant
D_cD_0 = readtable('FlockVxVyDcData.csv');
xy = readtable('FlockXYData.csv');
D_0 = 2.3e-3;% Original Diameter [mm]
y0 = [D_0,0];% initial conditionds
v_rel = 16;% relative gas velocity [m/s]
y0drag = [D_0,0,7.7e-3,0,12.1e-3,-1.77,v_rel];% initial conditionds for drag case
rho_l = 789;% Density of the droplet[kg/m^3]
mu_l = 1.2e-3;% Dynamic viscosity of the droplet[Pa*s]
sigma = 0.0223;% Surface tension of the droplet[N/m]
rho_g = 1.234;% Assume density of the gas [kg/m^3]
tspan_1 = [0 6e-3];
[t1,y1] = ode45(@(t1,y1) tabode(t1,y1,mu_l,rho_l,D_0,sigma,rho_g,v_rel,C_2), tspan_1,y0);
mu_g = 1.8e-5;% assume dynamic viscosity of the air [Pa*s]
g = -9.81;% gravity number [m/s^2]
[t2,y2] = ode45(@(t2,y2) dragode(t2,y2,g,mu_l,mu_g,rho_l,D_0,sigma,rho_g,v_rel,C_2), tspan_1,y0drag);
figure;
subplot(3,1,1)
plot(t1*1000,(y1(:,1)/D_0),t2*1000,(y2(:,1)/D_0));
hold on;
scatter(D_cD_0.t*1000,D_cD_0.Dc/D_0)
xlabel('time, t[ms]')
ylabel('d_c/d_0')
%ylabel('$\frac{d_c}{d_0}$','Interpreter','latex')
xlim([-2,6]);
title('Crop cross-stream diameter')
legend('TAB model','TAB with drag','Experiment')
hold off;
subplot(3,1,2)
plot(y2(:,3)*1000,y2(:,5)*1000)
hold on;
scatter(xy.x*1000,xy.y*1000)
xlabel('x-position [mm]')
ylabel('y-position [mm]')

legend('TAB with drag','Experiment')
hold off;
subplot(3,1,3)
plot(t2*1000,y2(:,4),t2*1000,y2(:,6));
hold on;
scatter(D_cD_0.t*1000,D_cD_0.vx)
scatter(D_cD_0.t*1000,D_cD_0.vy)
xlabel('time, t[ms]')
ylabel('drop velocity [m/s]')
xlim([-2,6]);
hold off;
TextSize = 14;
sizex = 7.5;
sizey = 22.5;

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
print(gcf,'-dpng','-r300','OutputImageBonus.png');
hold off;

%% Function
function dydt = tabode(t,y,mu_l,rho_l,D_0,sigma,rho_g,v_rel,C_2)
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = -20*(mu_l/(rho_l*(D_0^2)))*y(2)-64*sigma/(rho_l*(D_0^3))*(y(1)-D_0)+2*C_2*(rho_g*(v_rel^2))/(rho_l*D_0);
end

function dydt = dragode(t,y,g,mu_l,mu_g,rho_l,D_0,sigma,rho_g,v_rel,C_2)
    Re = (rho_g*(abs(v_rel))*y(1))/mu_g;
    C_dsp = corrDrag(Re);
    C_ddi = 1.1+(64/(pi*Re));
    f = 1-((D_0/y(1))^6);
    C_d = (f*(C_ddi))+((1-f)*C_dsp);
    dydt = zeros(7,1);
    dydt(1) = y(2);
    dydt(3) = y(4);
    dydt(5) = y(6);
    dydt(7) = 0;
    dydt(4) = -(3/4)*C_d*(rho_g/rho_l)*(y(4)-y(7))*abs(y(4)-y(7))*((y(1)^2)/((D_0)^3));
    dydt(6) = -((rho_l-rho_g)/rho_l)*g-(3/4)*C_d*(rho_g/rho_l)*y(6)*abs(0)*((y(1)^2)/((D_0)^3));
    dydt(2) = -20*(mu_l/(rho_l*(D_0^2)))*y(2)-64*sigma/(rho_l*(D_0^3))*(y(1)-D_0)+2*C_2*(rho_g*((y(4)-y(7))^2))/(rho_l*D_0);
end

% Function corrDrag() is used to choose the classical correlations for the
% drag coeddicient of a sphere based on Jet Reynolds
function C_d = corrDrag(Re)
    if Re < 2
        C_d = 24/Re;
    elseif Re < 1000
         C_d = 18.5/(Re^0.6);
    else
        C_d = 0.44;
    end
end
