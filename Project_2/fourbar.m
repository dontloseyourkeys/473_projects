function fourbar(r1,r2,r3,r4,theta0,speed,n)
%% Function Details

%{

This function fourbar(r1,r2,r3,r4,theta,speed,n) animates n cycles of a fourbar linkage if link 2 is a crank (i.e. can make a full rotation), and prints an error message otherwise.

link 1 is fixed and horizontal, 
link 2 is pinned to the right side of link 1
link 4 is pinned to the left side of link 1.  
The link lengths are r1,r2,r3,r4; 
theta is the initial angle of link 2, and 
speed is the constant angular speed of link 2 in rad/s CCW. 

Animate both possible assemblies of links 3 and 4 simultaneously in separate figure windows. Include short comments in your code explaining what each line does.
The speed of the displayed animation should accurately reflect the input speed value. This can be done by computing all of the mechanism positions to be plotted (for both solutions) and storing them in a matrix prior to executing any plotting commands. The pause() function can be used to pause between plot updates for the correct amount of time (which depends on the angle step size you choose).

%}
close all %closes any windows that are open still

link_lengths = [r1,r2,r3,r4]; % for indexing thru the links
link_sum = sum(link_lengths); 

%Check if any of the link lengths are greater than the sum of the other

%links
for i = 1:4     % for each link, checks whether that link is shorter than the sum of the rest
    if link_lengths(i) >= link_sum - link_lengths(i)
        %Print associated error message and fix
        fprintf(['A mechanism can not be assembled from the provided link lengths.\n' ...
        'Please reduce the length of link %d to less than %.2f\n\n'], (i), sum(link_lengths) - link_lengths(i));
        %Create the empty graph
        title('Mechanism cannot physically be assembled. See command window.');
        pause(3);
        %Stop checking if this error is found
        return
        %break
    end
end

%Check if r2 can fully rotate according to Grashof's law
spql = sort(link_lengths);
%check if the mechanism can rotate
if spql(1) + spql(4) < spql(2) + spql(3)
    %Classify the mechanism
    if r1 == spql(1)
        fprintf('This is a double-crank.\n')
        fprintf('The provided lengths are acceptable.\n\n')
        graph_title = 1; %  double crank

    elseif r2 == spql(1)
        fprintf('This is a crank-rocker with r2 as the crank.\n')
        fprintf('The provided lengths are acceptable.\n\n')
        graph_title = 2; % crank rocker

    else
        %An undesired mechanism results from the provided lengths
        if r3 == spql(1)
            fprintf('This is a double rocker.\n')
            fprintf('Increase r3 to more than %.2f to animate a valid mechanism with R2 as input\n\n', spql(2))
            graph_title = 3; % cant animate
            pause(3)
            return
        else 
            fprintf('This is a crank rocker with r4 as the crank.\n')
            fprintf('Increase r4 to more than %.2f to animate a valid mechanism with R2 as input\n\n', spql(2))
            graph_title = 3; % cant animate
            pause(3)
            return
        end
    end

else
    %An undesired mechanism results from the provided lengths
    %These ones will throw complex number errors
    if spql(1) + spql(4) == spql(2) + spql(3)
        fprintf('This is a change point mechanism.\n')
        graph_title = 4; % changepoint
        %fprintf('Shorten the link of length %.2f to less than %.2f\n\n', spql(4), spql(3)) %TODO is this needed if changepoint works?
    else
        fprintf('This is a triple rocker.\n')
        fprintf('Shorten the link of length %.2f to less than %.2f to animate a valid mechanism with R2 as input\n\n', spql(4), spql(3))
        graph_title = 3; % cant animate
        pause(3)
        return
    end

end

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

%% Calculating link positions

%   Variable legend:
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

%link 2 free end coordinates (crank tip)
x2 = x1 + (r2*cos(theta2));
y2 = r2*sin(theta2);

%span is magnitude of distance from origin to p2, cuts the 4bar mech into 2 triangles
span = sqrt((r1^2 + r2^2) + (2*r1*r2*cos(theta2)));

% find unit vector from 0-p2 aka of span: 
% p2/span = p2_unit_vec
x2_unit_vec = x2 ./span;
y2_unit_vec = y2 ./span;

%calculate b4 (b4 should be an array of scalar magnitudes)
%since r3^2 - (span-b4)^2 = r4^2 -b4^2:
b4 = (r3^2 - r4^2 - span.^ 2) ./ (-2 .* span);

% b4 * p2_unit_vec = x_temp, y_temp (coordinates of p temp) 

% find unit vector normal to span from p4 in both directions, multiply by
% height for both points 


%calculate h_34 (the height shared by the 2 right triangles if you cut the span-r3-r4 triangle in half normal from span)
%pythagoras to find h, which is the shared height between the 2 right angle
%triangles with hypotenuses r4 and r3. b4 is base of triangle bound by r4
%and h_34

%h_34 = sqrt(r4^2 - b4 .^2);
h_34 = sqrt(max(0, r4^2 - b4.^2)); %avoids rounding

%finding temp point that is on span that is where the 2 right triangle split is
x_temp = b4 .* x2_unit_vec;
y_temp = b4 .* y2_unit_vec;


%rotating unit vector to be 90deg from span in both directions
x2_norm_vec = -y2_unit_vec;
y2_norm_vec = x2_unit_vec;

%plots vector point from P_temp to p3, 
x3 = (h_34 .* x2_norm_vec) + x_temp;
y3 = (h_34 .* y2_norm_vec) + y_temp;

%these need the normal vector to be inverted, so using negatives of the
%above
x3Alt = (h_34 .* -x2_norm_vec) + x_temp;
y3Alt = (h_34 .* -y2_norm_vec) + y_temp;


%% plotting initial frame of orientation 1

% Setting reasonable axes for both plots
xmin = 1.2 * min([x0 min(x2) min(x2) min(x3Alt)]); %120% safety margin on leftmost position of link 4
xmax = 1.2 * max([max(x2) max(x2) max(x3Alt)]); %120% safety margin on rightmost position of link 2

if xmin == 0 %Manually sets bound if x0 is the min
    xmin = -(xmax-(r1+r2));
end

ymin = 1.2*min([min(y2) min(y3) min(y3Alt)]); %120% safety margin on highest position of link 2 or link 4
ymax = 1.2*max([max(y2) max(y3) max(y3Alt)]); %120% safety margin on lowest position of link 2 or link 

%% frame 1, left plot
ax1 = subplot(1, 2, 1); %left subplot for the animation
hold on %allows everything here to be added to same figure

% picks a title for the plots
if graph_title == 1
   title('Double Crank: Assembly 1');

elseif graph_title == 2
   title('Crank Rocker: Assembly 1');

elseif graph_title ==3 
   title('Change link parameters: see console');

elseif graph_title == 4; % changepoint
   title('Changepoint Mechanism: Assembly 1');
end

    xlim([xmin, xmax]); %limits for left plot
    ylim([ymin, ymax]);
    daspect([1 1 1]);

    % plot object handles for orientation 1
    link4 = plot([x0 x3(1)],[y0 y3(1)],'-o','linewidth',2, 'Color', 'r'); %plot obejct for rocker arm, spans from p0-p3
    link2 = plot([x1 x2(1)],[y1 y2(1)],'-o','linewidth',2, 'Color', 'b'); %plot object that sets initial location of the crank, spans p0-p2
    link3 = plot([x2(1) x3(1)],[y2(1) y3(1)],'-o','linewidth',2, 'Color', 'r');
    ground = line([0 r1],[0 0],'linewidth', 2,'color','#0C8A11','LineStyle', '--'); %plot object for ground, does not need updating per frame
    
    hold off

%% Frame 1, right plot (alternate orientation)
ax2 = subplot(1, 2, 2); %right subplot for the animation

hold on %allows everything here to be added to same figure

if graph_title == 1
   title('Double Crank: Assembly 2');


elseif graph_title == 2
   title('Crank Rocker: Assembly 2');

elseif graph_title == 3 
   title('Change link parameters: see console');

elseif graph_title == 4; % changepoint
   title('Changepoint Mechanism: Assembly 2');

end

    %axes limits reused for both
    xlim([xmin, xmax]); 
    ylim([ymin, ymax]);
    daspect([1 1 1]);

    %plot object handles for orientation 2
    ground = line([0 r1],[0 0],'linewidth', 2,'color','#0C8A11','LineStyle', '--'); %plot object for ground, does not need updating per frame
    link2Alt = plot([x1 x2(1)],[y1 y2(1)],'-o','linewidth',2, 'Color', 'b'); %plot object that sets initial location of the crank, spans p0-p2
    link4Alt = plot([x0 x3Alt(1)],[y0 y3Alt(1)],'-o','linewidth',2, 'Color', 'r'); %plot obejct for rocker arm, spans from p0-p3
    link3Alt = plot([x2(1) x3Alt(1)],[y2(1) y3Alt(1)],'-o','linewidth',2, 'Color', 'r');

    hold off

pause(1)    %added 1s pause to better show initial frame and allow data to load


%% Frame updates for both plots
     
    for n = 2:length(theta2)
        pause(timestep) %shows previous frame for timestep length
                
        %sets objects to next position
        set(link4,'XData',[x0 x3(n)],'YData',[y0 y3(n)]);   %error in cases
        
        set(link2,'XData',[x1 x2(n)],'YData',[y1 y2(n)]);
            
        set(link3,'XData',[x2(n) x3(n)],'YData',[y2(n) y3(n)]);

        set(link2Alt,'XData',[x1 x2(n)],'YData',[y1 y2(n)]);

        set(link3Alt,'XData',[x2(n) x3Alt(n)],'YData',[y2(n) y3Alt(n)]);

        set(link4Alt,'XData',[x0 x3Alt(n)],'YData',[y0 y3Alt(n)]);   %error in cases

    end %update end

end %function end