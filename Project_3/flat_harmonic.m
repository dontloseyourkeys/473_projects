
% This function [R0_min] = flat_harmonic(L,m,R0,n,speed)
% animates a disk cam driving a radial flat-faced follower in simple
% harmonic motion with no dwells. The function returns R0_min, the minimum
% base radius that avoids cusps on the cam. The input arguments are the
% lift L, the number of times m that the follower is lifted in a single cam
% rotation, the base radius R0, the number n of cam rotations animated, and
% the speed of the cam in rad/s CCW. The runs even if there
% are cusps on the cam (i.e. even if R0 < R0_min).

function [R0_min] = flat_harmonic(L,m,R0,n,speed)
% Function to animate a cam driving a radial flat-faced follower
% Author: Dr. P. Goldsmith
% [R0_min] = flat_harmonic(L,m,R0,n,speed)
% L = lift; 
% R0 = base circle radius
% R0_min = minimum base radius to avoid cusping
% m = number of lifts per cam rotation
% n = number of cam rotations shown in animation
% speed = angular speed of cam in rad/s CCW
% The cam lifts the follower m times for each cam rotation.
% The follower motion is harmonic with no dwell periods.
% The minimum follower width is used in the animation.

step = 0.02; % angle step in radians
x_min = -m*L/2; % minimum x coordinate of contact point 
w = m*L; % minimum follower width
R0_min = L*(m^2/2-1); % minimum base circle radius

a = 0:step:2*pi; % sequence of cam angles for 1 revolution
y = L/2*(1-cos(m*a)); % height of follower above base height
x = m*L/2*sin(m*a); % x coordinate of contact point
R_c = exp(-1i*a).*(x + 1i*(R0+y)); % cam coordinates of cam contour
plot(a,x,a,y)

% Initial plot of cam
figure(1)
plot(0,0,'ro') % pivot point
hold on
cam = plot(real(R_c),imag(R_c),'linewidth',2); % plot cam
follow = rectangle('Position',[x_min R0 w 0.2*L],'linewidth',2); % plot follower
hold off
axis equal
axis([-R0-1.5*L R0+1.5*L -R0-1.5*L R0+1.5*L]) % scale axes for any size cam

% Update the plot
for k = 1:n % for each cam rotation
    for b = a % for each angle
        pause(step/speed)
        set(cam,'XData',real(exp(1i*b)*R_c),'YData',imag(exp(1i*b)*R_c)) % rotate cam
        set(follow,'Position',[x_min R0+L/2*(1-cos(m*b)) w 0.2*L]); % slide follower
    end
end
