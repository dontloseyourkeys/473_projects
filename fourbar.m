function fourbar(r1,r2,r3,r4,theta,speed,n)
%% Function Details
%{
TODO explain function here
%}

%test 
%second test


%{
D2L instructions:
Write a function fourbar(r1,r2,r3,r4,theta,speed,n) that animates n cycles of a fourbar linkage if link 2 is a crank (i.e. can make a full rotation), and prints an error message otherwise.

Assume that:
link 1 is fixed and horizontal, 
link 2 is pinned to the right side of link 1, and 
link 4 is pinned to the left side of link 1.  
The link lengths are r1,r2,r3,r4; 
theta is the initial angle of link 2, and 
speed is the constant angular speed of link 2 in rad/s CCW. 

Animate both possible assemblies of links 3 and 4 simultaneously in separate figure windows. Include short comments in your code explaining what each line does.
The speed of the displayed animation should accurately reflect the input speed value. This can be done by computing all of the mechanism positions to be plotted (for both solutions) and storing them in a matrix prior to executing any plotting commands. The pause() function can be used to pause between plot updates for the correct amount of time (which depends on the angle step size you choose).


%}

%% TODOS
%{
todos go here

%}


%% Creating Figure
    figure('Position', [100, 100, 800, 800]) %makes the empty figure for the animation
    clf %clears figure if this function is run multiple times in a row
    set(gcf, 'Color', '#D3E2E8'); %makes the background blue

%% Error Checks
%{
TODO: write in bounding kinematic conditions for the mechanism here in
comment form


%]








%% creating frames for animation 

    fps = 60; %frames per second [frames/second]

    rad_frame = speed / fps; %rads per frame, replaces astep

    theta = 0:rad_frame:num_rotations*2*pi; %start:step:end notation, 0-3 full rotations, in steps of size astep      

    timestep = 1/fps; % fps inverted gives seconds per frame
    time = theta ./ speed; %ARRAY, (results in a time value in seconds for plotting angles)



%% Calculating link positions

%{
Variable legend:

SCALAR


ARRAY


%}
% SCALARS ----------------------------------------------------------------------------



% ARRAYS ----------------------------------------------------------------------------    


%% plotting initial frame

hold on %allows everything here to be added to same figure

% TODO set titles here

% TODO set axes limits here

    %TODO define xmin, xmax, ymin, ymax

    xlim([xmin, xmax]);
    ylim([ymin, ymax]);

pause(1)    %added 1s pause to better show initial frame and allow data to load
hold off

%% frame updates 

    for n = 2:length(theta)
        pause(timestep) %shows previous frame for timestep length
        

        %objects update:
        %set(objectHandle,'XData',[xstart ymiddle xend],'YData',[ystart ymiddle yend]);
        %%syntax, can add more points in square brackets 
      

    end