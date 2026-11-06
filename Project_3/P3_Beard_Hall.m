function P3_Beard_Hall(beta1, beta2, beta3, beta4, speed, L, R0)
%% Function Description
%{
has the form:
[R0min, Wmin] = flat(beta1, beta2, beta3, beta4, speed, L, R0)

Input:
[m]     R0min:  is the minimum base circle radius,

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



%% Creating Figure
    figure('Position', [100, 100, 1200, 600]) %makes the empty figure for the animation
    clf %clears figure if this function is run multiple times in a row
    set(gcf, 'Color', '#D3E2E8'); %makes the background blue

%% creating frames for animation 

    fps = 60; %frames per second [frames/second]
    rad_frame = speed / fps; %rads per frame, replaces astep
    theta2 = theta0:rad_frame:(n*2*pi)+theta0; %start:step:end notation, 0-3 full rotations, in steps of size astep      
    timestep = 1/fps; % fps inverted gives seconds per frame
    time = theta2 ./ speed; %ARRAY, (results in a time value in seconds for plotting angles)

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




%}


% Plotting Calculations

% Output Calculations





%% plotting initial frame of orientation 1

    
    % Setting reasonable axes

   
    
    %xmin = 1.2 * (min["all x value arrays, space separated"])
    %xmax = 1.2 * (max[       ])

    %ymin = 1.2 * (min[       ])
    %ymax = 1.2 * (max[       ])


    % limits
    xlim([xmin, xmax]); 
    ylim([ymin, ymax]);
    daspect([1 1 1]);
    
    


%% Frame updates

    for n = 2:length(theta2)
        pause(timestep) %shows previous frame for timestep length



        
    end %update end

end %function end


