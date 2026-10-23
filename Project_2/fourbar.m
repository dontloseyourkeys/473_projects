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
        fprintf('This is a double-crank.\n')
        fprintf('The provided lengths are acceptable.\n')
    elseif r2 == spql(1)
        fprintf('This is a crank-rocker with r2 as the crank.\n')
        fprintf('The provided lengths are acceptable.\n')
    else
        %An undesired mechanism results from the provided lengths
        if r3 == spql(1)
            fprintf('This is a double rocker.\n')
            fprintf('Increase r3 to more than %.2f.\n', spql(2))
        else 
            fprintf('This is a crank rocker with r4 as the crank.\n.')
            fprintf('Increase r4 to more than %.2f.\n', spql(2))
        end
    end
else
    %An undesired mechanism results from the provided lengths
    if spql(1) + spql(4) == spql(2) + spql(3)
        fprintf('This is a change point mechanism.\n')
    else
        fprintf('This is a triple rocker.\n')
    end
    fprintf('Shorten the link of length %.2f. to less than %.2f\n', spql(4), spql(3))
end




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
%{
r1
r2
r3
r4
speed
ground coordinates x0, y0 and x1, y1
%}
% ARRAYS ----------------------------------------------------------------------------    
%{
theta
phi (angle between links 3 and 4)
alpha (angle of link 4)
alphaALT (angle of link 4 in second orientation)
span (3rd side of triangle made by links 1 and 2)
link 2 free end coordinates x2, y2
link 4 free end coordinates for each orienation
x3, y3, x3ALT, y3ALT
%}

%Calculations
%ground coordinates
x0 = 0;
y0 = 0;
x1 = r1;
y1 = 0;

%theta array
thetaValues = theta + (0:2*pi*n) ;

%link 2 free end coordinates
x2 = x1 + (r2*cos(thetaValues));
y2 = r2*sin(thetaValues);
%span
span = sqrt(r1^2 + r2^2 - (2*r1*r2*cos(thetaValues)));
%phi
phi = acos(((r4^2+r3^2)-span.^2)/(2*r3*r4)); %Will be the same for both orientations
%alpha and alphaALT
alpha = (asin(r2.*sin(thetaValues)./span)) + (asin(r3.*sin(phi)./span));
alphaALT = (asin(r2*sin(thetaValues)/span)) - (asin(r3*sin(phi)/span));
%Link 4 free-end coordinates for both assembly orientations
x3 = r4*cos(alpha);
y3 = r4*sin(alpha);
x3Alt = r4*cos(alphaALT);
y3Alt = r4*sin(alphaALT);


%% plotting initial frame of orientation 1
ax1 = subplot(3, 1, [1 2]); %subplot for the animation, 2 rows, 1 column, editing subplot 1
hold on %allows everything here to be added to same figure

% TODO set titles here

% TODO set axes limits here

    %TODO define xmin, xmax, ymin, ymax
    xmin = 1.2*min(x3); %120% safety margin on leftmost position of link 4
    xmax = 1.2*max(x2); %120% safety margin on rightmost position of link 2
    %disp([xmin xmax])
    ymin = 1.2*min([min(y2) min(y3)]); %120% safety margin on highest position of link 2 or link 4
    ymax = 1.2*max([max(y2) max(y3)]); %120% safety margin on lowest position of link 2 or link 
    xlim([xmin, xmax]);
    ylim([ymin, ymax]);


    % plot object handles for orientation 1
    link4 = plot([x0 x3(1)],[y0 y3(1)],'-o','linewidth',2, 'Color', 'r'); %plot obejct for rocker arm, spans from p0-p3
    link2 = plot([x1 x2(1)],[y1 y2(1)],'-o','linewidth',2, 'Color', 'b'); %plot object that sets initial location of the crank, spans p0-p2
    link3 = plot([x2(1) x3(1)],[y2(1) y3(1)],'-o','linewidth',2, 'Color', 'r');
    ground = line([0 r1],[0 0],'linewidth', 2,'color','#0C8A11','LineStyle', '--'); %plot object for ground, does not need updating per frame
 

hold off

pause(1)    %added 1s pause to better show initial frame and allow data to load
hold off

%% frame updates 

    for n = 2:length(theta)
        pause(timestep) %shows previous frame for timestep length
        

        %objects update:
        %set(objectHandle,'XData',[xstart ymiddle xend],'YData',[ystart ymiddle yend]);
        %%syntax, can add more points in square brackets 
      

    end