%program to compute theta-s diagram
function TS_diag(theta,s,p)
%% generating background density contours
theta=theta(:);
s=s(:);
smin=min(s)-0.01.*min(s);
smax=max(s)+0.01.*max(s);
thetamin=min(theta)-0.1*max(theta);
thetamax=max(theta)+0.1*max(theta);
xdim=round((smax-smin)./0.1+1);
ydim=round((thetamax-thetamin)+1);
dens=zeros(ydim,xdim);
thetai=((1:ydim)-1)*1+thetamin;
si=((1:xdim)-1)*0.1+smin;
disp(xdim);disp(ydim);
for j=1:ydim
    for i=1:xdim
        dens(j,i)=gsw_rho(si(i),thetai(j),p(j));
    end
end
dens=dens-1000;
[c,h]=contour(si,thetai,dens,'k');
clabel(c,h,'LabelSpacing',1000);
title('Argentine Basin (April 2018 - April 2019): Conservative Temp / Absolute Salinity')
xlabel('Absolute Salinity (g/kg)','FontWeight','bold','FontSize',12)
ylabel('\Theta (^oC)','FontWeight','bold','FontSize',12)
%% plotting scatter plot of theta and s;
hold on;
scatter(s,theta,'.');
clear s theta;
