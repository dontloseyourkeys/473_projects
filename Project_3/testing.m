function [R0min, Wmin] = testing(beta1, beta2, beta3, beta4, speed, L, R0)

%% Function Instructions:
%{
The example file knife.m takes a series of inputs, 
and animates a cam with a centered knife-edge follower going through a dwell, 
a harmonic rise, a dwell, and a cycloidal return. 

The example file flat_harmonic.m animates a flat-face follower following a 
simple harmonic motion with no dwells.

The goal of this project is animate a flat-faced follower following a dwell,
harmonic rise, dwell, and cycloidal return (i.e. the same follower motion as
knife.m but with a flat-faced follower). Your code should also output a value
R0_min, which will be the minimum acceptable base circle radius that will 
prevent the cam from being under-cut. Your function should have the form:

[R0min, Wmin] = flat(beta1, beta2, beta3, beta4, speed, L, R0)

where

Variables:

R0min is the minimum base circle radius,
beta1 through beta4 are the angular distance (in radians) spent on the dwell, rise, dwell, and fall (respectively),
speed is the rotational speed of the cam (in rad/s),
L is the lift (stroke) of the follower,
R0 is the base circle radius.

Important Notes:

knife.m plots graphs of the displacement and velocity of the follower. Your function does not need to include these.
Your code must return the minimum base radius and minimum follower width as outputs.
The animation should be clear, and the file name should be P4_name1_name2.m.
%}

%% KNIFE CODE

assert((beta1>=0 && beta2>=0 && beta3>=0 && beta4>=0 && L>=0 && R0>=0), ...
    'Angles, Rise, and Base Circle Radius cannot be negative!')

% We also need to make sure that the motions can all occur in one rotation:
assert((sum([beta1 beta2 beta3 beta4]) <= 2*pi), ...
    'Motion must occur in one rotation of the cam')


%% Create essential variables:

% Set stepsize:
stepsize = 0.02;

% The first thing we need to do is set up a nice big vector of the
% displacement and speed at each value of theta. There are a few ways to do
% this, but what I opted for was to create the displacement and speed
% values for each section of movement, and concatenate them together. I
% felt that this method made it easier to see what was happening.

% Initialize variables:
theta = 0:stepsize:2*pi;
y = []; % Follower displacement
x = []; % Contact point coordinates, y'
s = []; % Speed of follower displacement
a = []; % second derivative of displacement, y''

% Dwell 1
theta1 = 0:stepsize:beta1-stepsize;

y = [y zeros(size(theta1))];
x = [x zeros(size(theta1))];
s = [s zeros(size(theta1))];
a = [a zeros(size(theta1))];

% You'll notice that we went from 0 to beta1-stepsize. This is because,
% when we stack the values of y together, the angle beta1 in dwell 1 is the
% same as the angle 0 in the rising motion. This would result in
% representing that angle twice, and our y, and dy arrays would be too
% long.

% Harmonic Motion (rise)
theta2 = 0:stepsize:beta2-stepsize;

y = [y (L/2)*(1-cos(pi*theta2/beta2))];
x = [x (L/2)*(pi/beta2)*sin(pi*theta2/beta2)]; %x = y'
a = [a (L/2)*(pi/beta2)^2*cos(pi*theta2/beta2)]; %y''
s = [s (L*pi/(2*(beta2))*sin(pi*theta2/beta2))*speed]; %y' * theta'

% Dwell 2
theta3 = 0:stepsize:beta3-stepsize;

y = [y L*ones(size(theta3))]; % During this dwell, it'll stay at y-L.
x = [x zeros(size(theta3))]; % Zero displacement means 0 speed
a = [a zeros(size(theta3))]; 
s = [s zeros(size(theta3))];  % During any dwell, the speed should be 0.

% Cycloidal Motion (fall):
theta4 = 0:stepsize:beta4-stepsize;

y = [y (L - L*theta4/beta4 + (L/(2*pi)) * sin(2*pi*theta4/beta4))];
x = [s (L/beta4)*(cos(2*pi*theta4/beta4)-1)]; % x = y'
a = [a -(L*2*pi)/(beta4)^2*sin((2*pi*theta4)/beta4)]; %y'', may be wrong
s = [s (L/beta4)*(cos(2*pi*theta4/beta4)-1)*speed];

% Dwell 3
% Now we want to fill the rest of the vectors y and s with zeros so that
% that they are the same length as theta:
y(length(theta))=0;
x(length(theta))=0;
a(length(theta))=0;
s(length(theta))=0;

% Generate the shape of the cam. Basically, value of theta, we will draw
% the contact point at (R0+y), then rotate it theta radians around the
% origin. We'll be animating it in the positive theta (CCW) direction, so
% it makes sense to plot it in the negative theta (CW) direction.

R_c = exp(-1i*theta).*(x + 1i*(R0+y));

%plot cam angles for one revolution
%plot(theta,x,theta,y)
%determine minimum base radius
R0min = -min((y+a));

%determine minimum follower width
Wmin = max(x)-min(x);

%% Animation:

% Initial plot of cam
figure(1)

%Plot the pivot point...
plot(0,0,'ro') 
% ...and don't delete it.
hold on 
% Plot the cam
cam = plot(real(R_c),imag(R_c),'linewidth',2);

% Plot the follower. Generally, you don't want your mechanism to go
% off-screen, but for the follower, it's implied to be attached to
% something, so it makes sense that it does.
follow = rectangle('Position',[min(x) R0 Wmin 0.2*L],'linewidth',2); % plot follower
hold off

% Always make sure your axes are sensible
axis equal
axis([-R0-1.5*L R0+1.5*L -R0-1.5*L R0+1.5*L])

rotnum = 1; % Rotating 3 times
for a = 1:rotnum % for each rotation
    for b = theta % for each angle
        % Pause a moment
        pause(stepsize/speed)
        
        % Rotate the cam a little, and move the follower
        set(cam,'XData',real(exp(1i*b)*R_c),'YData',imag(exp(1i*b)*R_c));
        set(follow,'Position',[min(x) R0+L/2*(1-cos(b)) Wmin 0.2*L]); % slide follower
    end
end
