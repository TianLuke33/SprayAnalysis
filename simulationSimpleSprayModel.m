% This is a code create a similation for simple spray model. Will apply
% ode45()function from Matlab
% The code can be used to similate droplet's position, velocity, and
% diameter
% Author: Tianluke33
% Date: 10_14_2024
%% Part a
% assume a stream of monodisperse n-heptane drops is created from a
% vibrating orifice drop denerator. 
% Given: d_0=100um, m=1mg/s, rho_l=688kg/m^3, mu_l=0.4*10^-3Pa*s, sigma=0.02N/m
% Find: the appropriate frequency and expected final drop size.
clc;
clear;
d_0 = 0.0001;% the exit orifice diameter[m]
m = 1*10^-6;% the mass flow rate[kg/s]
rho_l = 688;% Density of the fluid[kg/m^3]
mu_l = 0.4*10^-3;% Dynamic viscosity of the fluid[Pa*s]
sigma = 0.02;% Surface tension of the fluid [N/m]
Re = 4*m/(pi*mu_l*d_0);% Jet Reynold's number
Oh = mu_l/(sqrt(rho_l*sigma*d_0));% Ohnesorge numbers
lambda = sqrt(2)*pi*d_0*sqrt(1+3*Oh);% wavelength
U_0 = m/(rho_l*(pi*(d_0^2)/4));
f = U_0/lambda; % the appropriate frequency
D = (3*pi/sqrt(2))^(1/3)*d_0*(1+3*Oh)^(1/6);

%% Part b
% Construct and solve ODE to predict the drop motion after leaving the
% orific
% Assume gravity and drag are the only force acting on the drop
% Assume no evaporation happens in this part. So d_0 stay the same
clc;
clear;
d_1 = 1.5*10^-6;% the initial drop diameter for 1 figure[um]
rho_g = 1.2;% Density of the gas[kg/m^3]
mu_g = 1.8*10^-5;% Dynamic viscosity of the gas[Pa*s]
g = 9.8;% gravity acceleration[m/s^2]
% y_1: x position
% y_2: x velocity
% y_3: y position
% y_4: y velocity
mu_l = 0.4e-3;% Dynamic viscosity of the liquid[Pa*s]
rho_l = 688;% Density of the liquid[kg/m^3]
tspan_1 = [0 50e-6];% time range from 0 to 50us
y0=[0,20,0,0];% initial conditions
% ode45() function uses a variable step size Runge-Kutta method to solve ordinary differential equations.
% @(t,y): This defines an anonymous function that takes t (time) and y (state vector) as inputs.
% odefun(t, y, rho_g, rho_l, d_1, mu_g, mu_l, g): This is your ODE function where you calculate the derivatives of y. It takes parameters rho_g, rho_l, d_1, mu_g, mu_l, and g in addition to t and y
% tspan_1: A vector specifying the time interval over which you want to solve the ODE, e.g., [0 10].
% y0: The initial condition for y at the start of the time interval.
[t,y] = ode45(@(t,y) odefun(t,y,rho_g,rho_l,d_1,mu_g,mu_l,g),tspan_1,y0);
figure;
subplot(2,2,1);
plot(t*1000000,y(:,1)*1000000);
xlabel('time, t[\mus]')
ylabel('x-position[\mum]')
xlim([0,50]);
hold on;
subplot(2,2,2);
plot(t*1000000,y(:,2));
xlabel('time, t[\mus]')
ylabel('x-velocity[m/s]')
xlim([0,50]);
subplot(2,2,3);
plot(t*1000000,y(:,3)*1000000);
xlabel('time, t[\mus]')
ylabel('y-position[\mum]')
xlim([0,50]);
subplot(2,2,4);
plot(t*1000000,y(:,4)*1000000);
xlabel('time, t[\mus]')
ylabel('y-velocity[\mum/s]')
xlim([0,50]);
TextSize = 14;
sizex = 7.5;
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
print(gcf,'-dpng','-r300','OutputImagePartb.png');
hold off;
%% Second image for part b)
clc;
clear;
d_2 = 1.5e-3;% the initial drop diameter for 1 figure[mm]
rho_g = 1.2;% Density of the gas[kg/m^3]
mu_g = 1.8*10^-5;% Dynamic viscosity of the gas[Pa*s]
g = 9.8;% gravity acceleration[m/s^2]
mu_l = 0.4e-3;% Dynamic viscosity of the liquid[Pa*s]
rho_l = 688;% Density of the liquid[kg/m^3]
tspan_2 =  [0 5];% time range from 0 to 5s
y0=[0,20,0,0];
[t,y] = ode45(@(t,y) odefun(t,y,rho_g,rho_l,d_2,mu_g,mu_l,g),tspan_2,y0);
figure;
subplot(2,2,1);
plot(t,y(:,1));
xlabel('time, t[\mus]')
ylabel('x-position[\mum]')
xlim([0,5]);
hold on;
subplot(2,2,2);
plot(t,y(:,2));
xlabel('time, t[\mus]')
ylabel('x-velocity[m/s]')
xlim([0,5]);
subplot(2,2,3);
plot(t,y(:,3));
xlabel('time, t[\mus]')
ylabel('y-position[\mum]')
xlim([0,5]);
subplot(2,2,4);
plot(t,y(:,4));
xlabel('time, t[\mus]')
ylabel('y-velocity[\mum/s]')
xlim([0,5]);
TextSize = 14;
sizex = 7.5;
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
print(gcf,'-dpng','-r300','OutputImagePartb2.png');
hold off;
%% Part c
% Apply the simple spray from part(a).
% Assume initially injected in the horizontal
% Plot drop x- and y-positions and velocities from 0 to 200ms after
% injection
clc;
clear;
d_0 = 1.8919e-4;% the original drop diameter[m]
rho_l = 688;% Density of the fluid[kg/m^3]
mu_l = 0.4*10^-3;% Dynamic viscosity of the fluid[Pa*s]
rho_g = 1.2;% Density of the gas[kg/m^3]
mu_g = 1.8*10^-5;% Dynamic viscosity of the gas[Pa*s]
g = 9.8;% gravity acceleration[m/s^2]
tspan = [0 200e-3];
y0 = [0,0.1851,0,0];
[t,y] = ode45(@(t,y) odefun(t,y,rho_g,rho_l,d_0,mu_g,mu_l,g),tspan,y0);
figure;
subplot(2,2,1);
plot(t*1000,y(:,1)*1000);
xlabel('time, t[ms]')
ylabel('x-position[mm]')
xlim([0,200]);
hold on;
subplot(2,2,2);
plot(t*1000,y(:,2));
xlabel('time, t[ms]')
ylabel('x-velocity[m/s]')
xlim([0,200]);
subplot(2,2,3);
plot(t*1000,y(:,3)*1000);
xlabel('time, t[ms]')
ylabel('y-position[mm]')
xlim([0,200]);
subplot(2,2,4);
plot(t*1000,y(:,4));
xlabel('time, t[ms]')
ylabel('y-velocity[m/s]')
xlim([0,200]);
TextSize = 14;
sizex = 7.5;
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
print(gcf,'-dpng','-r300','OutputImagePartc.png');
hold off;
%% Bonus
% Assume n-heptane drops are initially at T_d=69C and surrounding air at
% T_0 = 500C
% Drop diameter change due to evaporation
% Plot images with evaporation affections
clc;
clear;
rho_l = 688;% Density of the fluid[kg/m^3]
mu_l = 0.4*10^-3;% Dynamic viscosity of the fluid[Pa*s]
rho_g = 1.2;% Density of the gas[kg/m^3]
mu_g = 1.8*10^-5;% Dynamic viscosity of the gas[Pa*s]
g = 9.8;% gravity acceleration[m/s^2]
c_pg = 1671;% specific heat capacity[J/Kg*K]
k_g = 0.0349;% the thermal conductivity[J/m*s*K]
h_fg = 339000;% latent heat[J/kg]
T_0 = 500;% surrounding air temperature
T_d = 69;% drops temperature
tspan = [0 200e-3];
y0 = [0,0.1851,0,0,1.8919e-4];
[t,y] = ode45(@(t,y) evaodefun(t,y,rho_g,rho_l,mu_g,mu_l,g,c_pg,k_g,h_fg,T_0,T_d),tspan,y0);
figure;
subplot(3,2,1);
plot(t*1000,y(:,1)*1000);
xlabel('time, t[ms]')
ylabel('x-position[mm]')
xlim([0,200]);
hold on;
subplot(3,2,2);
plot(t*1000,y(:,2));
xlabel('time, t[ms]')
ylabel('x-velocity[m/s]')
xlim([0,150]);
subplot(3,2,3);
plot(t*1000,y(:,3)*1000);
xlabel('time, t[ms]')
ylabel('y-position[mm]')
xlim([0,150]);
subplot(3,2,4);
plot(t*1000,y(:,4));
xlabel('time, t[ms]')
ylabel('y-velocity[m/s]')
xlim([0,150]);
subplot(3,2,5);
plot(t*1000,y(:,5)*1000000);
xlabel('time, t[ms]')
ylabel('droplet diameter[\mum]')
xlim([0,150]);
TextSize = 14;
sizex = 7.5;
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
print(gcf,'-dpng','-r300','OutputImageBonus.png');
hold off;
%% Functions
function dydt = odefun(t,y,rho_g,rho_l,d_0,mu_g,mu_l,g)
    V_rel = sqrt((y(2)^2)+(y(4)^2));% total velocity of the drop
    Re = (rho_g*abs(V_rel)*d_0)/mu_g;
    C_d = corrDrag(Re);
    dydt = zeros(4,1);
    dydt(1) = y(2);
    dydt(3) = y(4);
    dydt(2) = -(3/4)*C_d*(rho_g/rho_l)*y(2)*abs(V_rel)/d_0;
    dydt(4) = -(rho_l-rho_g)/rho_l*g-(3/4)*C_d*(rho_g/rho_l)*y(4)*abs(V_rel)/d_0;
end

function dydt = evaodefun(t,y,rho_g,rho_l,mu_g,mu_l,g,c_pg,k_g,h_fg,T_0,T_d)
    V_rel = sqrt((y(2)^2)+(y(4)^2));% total velocity of the drop
    Re = (rho_g*abs(V_rel)*y(5))/mu_g;
    C_d = corrDrag(Re);
    B_q = c_pg*(T_0-T_d)/h_fg;
    dydt = zeros(5,1);
    dydt(1) = y(2);
    dydt(3) = y(4);
    dydt(2) = -(3/4)*C_d*(rho_g/rho_l)*y(2)*abs(V_rel)/y(5);
    dydt(4) = -(rho_l-rho_g)/rho_l*g-(3/4)*C_d*(rho_g/rho_l)*y(4)*abs(V_rel)/y(5);
    dydt(5) = -((4*k_g)/(rho_l*c_pg))*log(B_q+1)/y(5);
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



