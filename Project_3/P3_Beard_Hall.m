function [R0min, Wmin] = P3_Beard_Hall(beta1, beta2, beta3, beta4, speed, L, R0)
%% Function Description
%{
has the form:
[R0min, Wmin] = flat(beta1, beta2, beta3, beta4, speed, L, R0)

Input:
[m]     R0:  is the minimum base circle radius,

[RAD]   beta1:  the angular distance spent on the dwell
[RAD]   beta2:  the angular distance (in radians) spent on the rise
[RAD]   beta3:  the angular distance (in radians) spent on the dwell
[RAD]   beta4:  the angular distance (in radians) spent on fall (respectively)

[RAD/s] speed:  the rotational speed of the cam 
[m]     L:      the lift (stroke) of the follower
[m]     R0:     the base circle radius.

Output: 
[m]      R0min: the minimum acceptable base circle radius that will prevent the cam from being under-cut
[m]      Wmin:  the minimum follower width to allow the follower to always make contact

%}

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

our notes: 
similar to ps4 q6 and q7

%}

%% Code starts here

close all %closes any windows that are open still

%% compatibility checks



%{
%% Creating Figure
    figure('Position', [100, 100, 1200, 600]) %makes the empty figure for the animation
    clf %clears figure if this function is run multiple times in a row
    set(gcf, 'Color', '#D3E2E8'); %makes the background blue
%}

%{ 
creating frames for animation 

    fps = 60; %frames per second [frames/second]
    rad_frame = speed / fps; %rads per frame, replaces astep
    theta2 = theta0:rad_frame:(n*2*pi)+theta0; %start:step:end notation, 0-3 full rotations, in steps of size astep      
    timestep = 1/fps; % fps inverted gives seconds per frame
    time = theta2 ./ speed; %ARRAY, (results in a time value in seconds for plotting angles)
%}

%%  Calculating positions

% Variable legend:
%{
% SCALARS ----------------------------------------------------------------------------
Inputs:
[m]     R0min:  is the minimum base circle radius,

[RAD]   beta1:  the angular distance spent on the dwell
[RAD]   beta2:  the angular distance (in radians) spent on the rise
[RAD]   beta3:  the angular distance (in radians) spent on the dwell
[RAD]   beta4:  the angular distance (in radians) spent on fall (respectively)

[RAD/s] speed:  the rotational speed of the cam 
[m]     L:      the lift (stroke) of the follower
[m]     R0:     the base circle radius.

Outputs:
[m]      R0min: the minimum acceptable base circle radius that will prevent the cam from being under-cut
[m]      Wmin:  the minimum width to allow the follower to always makecontact

% ARRAYS ----------------------------------------------------------------------------   

theta: range of angles for cam rotation
y: follower displacement
x: derivative of y
s: speed of follower, x*theta'
a: second derivative of y

%}

% Plotting Calculations

    % Initialize variables: 
    stepsize = 0.02;

    theta = 0:stepsize:2*pi;
    y = []; % Follower displacement
    x = []; % Contact point coordinates, y'
    s = []; % Speed of follower displacement
    a = []; % second derivative of displacement, y''

    % Dwell 1

    %range of angluar positions between 0 and beta1
    theta1 = 0:stepsize:beta1-stepsize; 
    
    %Set the kinematic quantites equal to 0 at each angular position in theta1
    y = [y zeros(size(theta1))];
    x = [x zeros(size(theta1))];
    s = [s zeros(size(theta1))];
    a = [a zeros(size(theta1))];

    % Harmonic Motion (rise)

    %range of angluar positions between beta1 and beta2
    theta2 = 0:stepsize:beta2-stepsize;
    
    %Calculate the kinematic quantities at each angular position in theta2
    y = [y (L/2)*(1-cos(pi*theta2/beta2))];
    x = [x (L/2)*(pi/beta2)*sin(pi*theta2/beta2)]; %x = y'
    s = [s (L/2)*(pi/beta2)*sin(pi*theta2/beta2)*speed]; %y' * theta'
    a = [a (L/2)*(pi/beta2)^2*cos(pi*theta2/beta2)]; %y''

    % Dwell 2
    
    %range of angluar positions between beta2 and beta3
    theta3 = 0:stepsize:beta3-stepsize;
    
    %Set the kinematic quantites equal to L or 0 at each angular position in
    %theta3
    y = [y L*ones(size(theta3))]; % During this dwell, it'll stay at L.
    x = [x zeros(size(theta3))]; % Zero displacement means 0 speed
    s = [s zeros(size(theta3))]; % During any dwell, the speed should be 0.
    a = [a zeros(size(theta3))]; %seocnd derivative is equal to 0 if first is

    % Cycloidal Motion (fall):

    %range of angluar positions between beta3 and beta4
    theta4 = 0:stepsize:beta4-stepsize;
    
    %Calculate the kinematic quantities at each angular position in theta4
    y = [y (L - L*theta4/beta4 + (L/(2*pi)) * sin(2*pi*theta4/beta4))];
    x = [s (L/beta4)*(cos(2*pi*theta4/beta4)-1)]; % x = y'
    s = [s (L/beta4)*(cos(2*pi*theta4/beta4)-1)*speed];
    a = [a -(L*2*pi)/(beta4)^2*sin(2*pi*theta4/beta4)]; %y''

    % Dwell 3
    
    % Fill the rest of the arrayss with zeros so that the arrays correspond
    % to a full rotation of 2 pi rads
    y(length(theta))=0;
    x(length(theta))=0;
    a(length(theta))=0;
    s(length(theta))=0;

    % Generate cam shape
    R_c = exp(-1i*theta).*(x + 1i*(R0+y));

% Output Calculations

    %minimum base radius
    R0min = -(min(y+a));

    %minimum width
    Wmin = max(x)-min(x);

%% Animation

% Initial plot of cam
figure(1)

%Plot the pivot point...
plot(0,0,'ro') 
hold on 

% Plot the cam
cam = plot(real(R_c),imag(R_c),'linewidth',2);

% Plot the follower
follow = rectangle('Position',[min(x) R0 Wmin 0.2*L],'linewidth',2); % plot follower
hold off

% Set axis boundaries
axis equal
axis([-R0-1.5*L R0+1.5*L -R0-1.5*L R0+1.5*L])

rotnum = 3; % Set rotations
for a = 1:rotnum % for each rotation
    n = 1; %for tracking y positions
    for b = theta % for each angular position
        % Pause a moment
        pause(stepsize/speed)
        
        % Rotate the cam
        set(cam,'XData',real(exp(1i*b)*R_c),'YData',imag(exp(1i*b)*R_c));
        % Show current follower position
        set(follow,'Position',[min(x) R0+y(n) Wmin 0.2*L]);
        % move to next follower position
        n = n + 1;
    end
end

end %function end


