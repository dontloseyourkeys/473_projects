function fourbar(r1,r2,r3,r4,theta,speed,n)
%% Function Details
%{
TODO explain function here
%}

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

link_lengths = [r1,r2,r3,r4];
link_sum = sum(link_lengths);

%Check if any of the link lengths are greater than the sum of the other
%links
for i = 1:4
    if link_lengths(i) >= link_sum - link_lengths(i)
        %Print associated error message and fix
        fprintf(['A mechanism can not be assembled from the provided link lengths.\n' ...
        'Please reduce the length of link %d to less than %.2f\n'], (i), sum(link_lengths) - link_lengths(i));
        %Create the empty graph
        title('Mechanism can not be assembled. See command window.');
        pause(5);
        %Stop checking if this error is found
        break
    end
end

%Check if r2 can fully rotate according to Grashof's law
spql = sort(link_lengths);
%check if the mechanism can rotate
if spql(1) + spql(4) < spql(2) + spql(3)
    %Classify the mechanism
    if r1 == spql(1)
        fprintf('This is a double-crank\n')
        fprintf('The provided lengths are acceptable.\n')
    elseif r2 == spql(1)
        fprintf('This is a crank-rocker with r2 as the crank\n')
        fprintf('The provided lengths are acceptable.\n')
    else
        %An undesired mechanism results from the provided lengths
        if r3 == spql(1)
            fprintf('This is a double rocker.\n')
            fprintf('Increase r3.\n')
        else 
            fprintf('This is a crank rocker with r4 as the crank.\n.')
            fprintf('Increase r4.\n')
        end
    end
else
    %An undesired mechanism results from the provided lengths
    if spql(1) + spql(4) == spql(2) + spql(3)
        fprintf('This is a change point mechanism.\n')
    else
        fprintf('This is a triple rocker.\n')
    end
    fprintf('Shorten the link of length %.2f.\n', spql(4))
end

%{
thetaValues = theta + (0:2*pi*n) ;

%% Creating Figure
    figure('Position', [100, 100, 800, 800]) %makes the empty figure for the animation
    clf %clears figure if this function is run multiple times in a row
    set(gcf, 'Color', '#D3E2E8'); %makes the background blue

%% Error Checks
%{
TODO: write in bounding kinematic conditions for the mechanism here in
comment form


%}








%% creating frames for animation 

    fps = 60; %frames per second [frames/second]

    rad_frame = speed / fps; %rads per frame, replaces astep

    %theta = 0:rad_frame:num_rotations*2*pi; %start:step:end notation, 0-3 full rotations, in steps of size astep      

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


    % plot object handles
    % rocker = plot([x0 x3(1)],[y0 y3(1)],'-o','linewidth',2, 'Color', 'b'); %plot obejct for rocker arm, spans from p0-p3
    % crank = plot([x1 x2(1)],[y1 y2(1)],'-o','linewidth',2, 'Color', 'r'); %plot object that sets initial location of the crank, spans p0-p2
    % ground = line([0 r1],[0 0],'linewidth', 2,'color','#0C8A11',
    %'LineStyle', '--'); %plot object for ground, does not need updating per frame
    % slider object
    %slider = patch(x_slider(:, 1), y_slider(:, 1), 'r', 'LineWidth', 1.5); % semicolon takes all 4 column vals, row 1



hold off

pause(1)    %added 1s pause to better show initial frame and allow data to load
hold off

%% frame updates 

    for n = 2:length(theta)
        pause(timestep) %shows previous frame for timestep length
        

        %objects update:
        %set(objectHandle,'XData',[xstart ymiddle xend],'YData',[ystart ymiddle yend]);
        %%syntax, can add more points in square brackets 
      
%}
    end