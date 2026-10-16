function P1b_AugustBeard_EthanHall(r1,r2,r3, r4, r5, speed) %= [outputs]?
%If you're reading this it saved properly 
% btw, top line always needs to be function handle but also nice!

%% Function Details
%{
This function creates 2 plots:
- Plot 1 is an animation of an inverted slider crank mechanism
- Plot 2 is a graph of rocker angle over time (TODO measured from horizontal or vertical? also not yet implemented)

This function takes 6 numerical input variables:

R1:    [m]      Length of ground link
R2:    [m]      Length of crank link
R3:    [m]      Length of slider coupled link
R5:    [m]      Length of
R5:    [m]      Length of TODO ADD THESE
Speed: [RAD/s]  Crank Speed
%}


%% Instuctions P1A: 
%{
Name: P1b_name1_name2(r1,r2,r3,r4,r5,speed),

Goal: modify P1A to to create a quick return planing machine
Function form: P1b_name1_name2(r1,r2,r3,r4,r5,speed),
Sample test inputs: P1b_name1_name2(5,4,13,6,10,1)
Input guide: 
o	R1 is the length of a fixed horizontal ground link
o	R2 is the crank length
o	r3 is the rocker length
o	r4 is the length of the rod connecting the new slider to the rocker of the inverted slider crank
o	 r5 is the horizontal distance from the rocker pin joint to the vertical path of the second slider's pin joint.
o	speed is the crank speed in rad/s.

P1B: reuse same code but modify to have the following:
-	offset
-	 link that connects the output rocker to a second slider that reciprocates vertically
-	No need to plot rocker angle against time for P1B, so only one output plot needed

%}


    
%{ 
%% sample function calls for pasting


P1a_test(5,3,2,2) %function call for invalid geometry of link lengths

P1a_test(5,3,10,2) %function call for valid inverted crank link lengths

P1a_AugustBeard_EthanHall(3,6,10,2) %function call for valid inverted double crank link lengths


P1b_AugustBeard_EthanHall(5,4,13,6,10,1) %tests with example's numbers

P1a_AugustBeard_EthanHall(5,3,10,0.5) %function call for valid inverted crank link lengths

%}
    

%% Number of rotations

    %num_rotations = input('Enter the number of full rotations to
    %animate:%'); %when uncommented, accepts a number input to do more or
    %less than 3 rotations

    num_rotations = 3; %sets number of full rotations to be animated, currently in use

 %% Creating/Clearing figures
    
    figure('Position', [100, 100, 800, 800]) %makes the empty figure for the animation
    clf %clears figure if this function is run multiple times in a row
    set(gcf, 'Color', '#D3E2E8'); %makes the background blue
                                   

%% Check for assembly and full crank rotation
%{
To be assembled and to fully rotate:
    (r3>= r1 + r2) must be true, or else the slider can't slide enough                          %TODO this sounds stupid
    If (r2 > r1) then it is double crank case
%}

if r3<r1 + r2               
   fprintf(['<strong>The crank cannot rotate fully because of incompatible lengths:</strong>\n' ...
       'Link lengths: \n' ...
       'R1, ground: %.2f \n' ...
       'R2, crank: %.2f  \n' ...
       'R3, rocker: %.2f\n' ...
       'To fix the issue, either <strong>decrease r3</strong> or <strong>increase r1 or r2</strong>\n\n'], r1, r2, r3);
        
    title(['Crank cannot rotate: Change parameters']);
else

    if r2>r1
        fprintf(['<strong>This is an inverted double slider crank</strong>\n' ...
            '<strong>R1</strong>, Green ground: %.2f \n' ...
            '<strong>R2</strong>, Red crank: %.2f \n' ...
            '<strong>R3</strong>, Blue crank: %.2f\n' ...
            '<strong>Now playing animation...</strong>\n'], r1, r2, r3);
        
        graph_title = 2; %'double'

    else 
        fprintf(['<strong>This is an inverted crank rocker</strong>\n' ...
            '<strong>R1</strong>, Green ground: %.2f \n' ...
            '<strong>R2</strong>, Red crank: %.2f \n' ...
            '<strong>R3</strong>, Blue rocker: %.2f\n' ...
            '<strong>Now playing animation...</strong>\n'], r1, r2, r3);

        graph_title = 3; %'rocker'

    end
    fprintf('\n\n') % prints newlines


%% creating frames for animation 


%    astep = 0.05; %defines angle in rad r2 rotates per frame, smaller is smoother animation but more laggy **TODO change this to based on fps
%   speed [rad/s]

    fps = 60; %frames per second [frames/second]

    rad_frame = speed / fps; %rads per frame, replaces astep

    theta = 0:rad_frame:num_rotations*2*pi; %start:step:end notation, 0-3 full rotations, in steps of size astep      

    timestep = 1/fps; % fps inverted gives seconds per frame
    time = theta ./ speed; %ARRAY, (results in a time value in seconds for plotting angles)


%% Calculating positions of links:
    %{
    variable legend: 
    
    Given inputs: 
    SCALAR  r1: length of fixed horizontal ground link      
    SCALAR  r2: crank length                            
    SCALAR  r3: rocker length
    SCALAR  speed: crank speed in rad/s

    Defined within function:
    
    
    SCALAR: x0, y0, x1, y1 (unchanging with time)
    
    ARRAY   theta: the angle of rotation of crank arm in rad
    ARRAY   x2, y2, x3, y3
    ARRAY xspan_r2s, span_r2s (these lengths changes frame to frame)
    %}

% SCALARS ----------------------------------------------------------------------------

%slider calculations TODO change to absolute size to show scale?

    w = 0.2 * r2; % scales width of slider based on crank length
    h = 0.1 * r2; % scales height of slider based on crank length
   
% Point 0 is at origin and has follower (usually rocker) connected
    x0 = 0; 
    y0 = 0;

% Point 1 x and y position has crank connected
    x1 = r1;  % Located at x0 + r1, which is always horisontal in this part bc no offset
    y1 = 0; % p1 values broken and changing????     TODO array vs scalar
     
% ARRAYS ----------------------------------------------------------------------------    
%Point 2 x and y corresponds to the end of the rotating crank
    x2 = x1 + (r2 * cos(theta)); %x coord of crank tip p2
    y2 = r2 * sin(theta); %y coord of crank tip p2

    
    %Slider Triangle                        TODO(acos of xspan_r2s/span_r2s can be used to find rocker angle from horisontal) 

    %the length from the right side of ground plus the x span of the crank, horisontal component of triangle bound by the slider
    % xspan_r2s = (r1 + x2);  is now redundant?
    span_r2s = hypot(y2, x2); %uses dedicated hypotenus command to find the length from the rocker hinge point to the slider


%Point 3 is tip of follower link
    x3 = (x2 .* r3 ./ span_r2s);
    y3 = (x3 .* y2 ./ x2); %same with this


% Rocker angle, phi: %TODO check angle quadrant
    %phi = asin(y3 / r3);    %ARRAY
    phi = atan2(y3, x3);
    

% slider parameters, defined wrt origin but use relative to p2
    x_swrto = [-w/2;  w/2;  w/2; -w/2]; %x vals of slider wrt origin 
    y_swrto = [-h/2; -h/2;  h/2;  h/2]; %y vals of slider wrt origin

% rotates coordinates of sliders based on phi, rocker angle
    x_rot = x_swrto .* cos(phi) - y_swrto .* sin(phi);
    y_rot = x_swrto .* sin(phi) + y_swrto .* cos(phi);

% moves slider to p2
    x_slider = x2 + x_rot;
    y_slider = y2 + y_rot;

%% new for p1b

x4 = r5; %adding placeholder values to get the links made. in reality, P4 should be from 
y4 = y2; %this is correct, it should go to x=the offset to the horisontal 


%blue slider, rotated 90
w_b = h; % 0.1 * r2
h_b = w; % 0.2 * r2

x4_left = x4 - (w_b / 2); %sets left side of blue slider such that it is centered around x = r5 
y4_bottom_1 = y4(1) - (h_b / 2);
    

%% plotting and updating the figure

ax1 = subplot(3, 1, [1 2]); %subplot for the animation, 2 rows, 1 column, editing subplot 1
hold on %allows everything here to be added to same figure

%sets title according to flag
%if graph_title == 1 %'cant_rotate'
 %  title(['Crank cannot rotate: Change parameters']);

if graph_title == 2 %'double'
   title('Animation of Inverted Slider Double Crank Mechanism');

elseif graph_title == 3 %'rocker'
   title('Animation of Inverted Slider Crank-Rocker Mechanism');

end

% Setting reasonable axes
   axis equal % sets axes to equal
        
   
        
        % finds appropriate window bounds
        xmin = 1.2 * min([-r1 min([x3]) r5]);      % 120% safety margin on leftmost position of the crank
        xmax = 1.2 * max([r1 max([x3]) r5]);     % 120% safety margin on extended position of crank, to be changed
        ymin = 1.2 * min([y3]);               % takes smallest of (lowest crank position or offset), subtracts half r3 for margin
        ymax = 1.2 * max([y3]);               % same as ymin but in positive direction
         
        %axis([xmin, xmax, ymin, ymax])
        xlim([xmin, xmax]);
        ylim([ymin, ymax]);

% Initial frame

    %plot object handles

        ground = line([0 r1],[0 0],'linewidth', 2,'color','#0C8A11', 'LineStyle', '--'); %plot object for ground, does not need updating per frame
        wall = line([r5 r5],[ymin ymax],'linewidth', 2,'color','#E7B0FF', 'LineStyle', '-'); %plot object for ground, does not need updating per frame
        
        rocker = plot([x0 x3(1) x4(1)],[y0 y3(1) y4(1)],'-o','linewidth',2, 'Color', 'b'); %plot obejct for rocker arm, spans from p0-p3
        crank = plot([x1 x2(1)],[y1 y2(1)],'-o','linewidth',2, 'Color', 'r'); %plot object that sets initial location of the crank, spans p0-p2
      


    % Red slider object
        slider_r = patch(x_slider(:, 1), y_slider(:, 1), 'r', 'LineWidth', 1.5); % semicolon takes all 4 column vals, row 1
        slider_b = rectangle('Position', [x4_left, y4_bottom_1, w_b, h_b], 'FaceColor', 'b', 'EdgeColor', 'k', 'LineWidth', 1.5);

        %slider_b = rectangle('Position',[r4(1)-0.1*r3 r1-0.1*r3 0.2*r3
        %0.2*r3],'linewidth',2); % tried their notation, didnt go well
hold off

%% Plot 2: time graph
ax2 = subplot(3, 1, 3); %subplot for the angle/time graph, 3 rows, 1 column, editing subplot 3

hold on;
yyaxis left %adds left axis stuff and plots relative to that

    xlabel('Time (s)');
    ylabel('Angle (rad)');
    grid on
    
    ylim([(1.2 * min(phi)), (1.2 * max(phi))]); %sets y limits to 1.2 times extreme vals
    
    rad_lims = ylim;


if graph_title == 2 %'double'
title('Crank Angle vs Time'); %TODO adjust visually so this ranges from 0 - 2pi 

elseif graph_title == 3 %'rocker'
   title('Rocker Angle vs Time');
end

    plot(time, phi, 'linewidth', 2, 'Color', 'k');  %draws the graph
    phi_mark = plot(time(1), phi(1), 'bo', 'MarkerFaceColor', 'b'); %adds a marker to the time graph for current angle at current time

 yyaxis right
 ylabel('Angle (deg)');
 ylim(rad2deg(rad_lims));

hold off;

pause(1)    %added 1s pause to better show initial frame and allow data to load
    
%% Frame updates

    for n = 2:length(theta)
        pause(timestep) %shows previous frame for timestep length
    
        %sets objects to next position
        set(rocker,'XData',[x0 x3(n) x4],'YData',[y0 y3(n) y4(n)]);
        set(crank,'XData',[x1 x2(n)],'YData',[y1 y2(n)]);
        set(phi_mark, 'XData', time(n), 'YData', phi(n));

        set(slider_r, 'XData', x_slider(:, n), 'YData', y_slider(:, n));
        set(slider_b, 'Position', [x4_left, y4(n) - (h_b / 2), w_b, h_b]);
    
%debug print for each frame TODO remove eventually
        %disp(phi(n))
        %fprintf(' x1: %.2f, y1: %.2f  x2: %.2f, y2: %.2f  x3: %.2f, y3: %.2f  | theta: %.2f\n', x1, y1, x2(n), y2(n), x3(n), y3(n), theta(n)); 
    end
end
