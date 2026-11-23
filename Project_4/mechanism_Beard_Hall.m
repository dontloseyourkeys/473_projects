function [] = mechanism_Beard_Hall(initX, initY, finalX, finalY, speed)
%% Function Description
%{
This function mechanism_Beard_Hall takes inputs ______ and animates a
hydraulic robotic claw arm that can move an object.


initX, initY: the initial x and y positions for the object to be moved
finalX, finalY: the position the object should be moved to.
speed: the animation speed, rads/s of ___(whatever we consider the base link)____
%}


close all %closes any windows that are open still

%mechanism_Beard_Hall(beta1, beta2, beta3, beta4, speed, L, R0)

% TODO remove before submission but these are placeholders so we can easily
% test
if nargin < 4
        initX = 2;
        initY = 8;
        finalX = 5;
        finalY = 3;
        speed = 2;
    end

%TODO 
%{ 
TODO: add a paragraph explaining how to use the program, a 2 explaining 
how to use the program, along with any relevant background, such as how you
decided on any constant parameters (e.g. "we measured the link lengths from
this bench press on campus; see attached photo"). You may want some parameters
(e.g. some link lengths) to be input by the user, but you could provide default 
values. You get to decide.

Grades based off of:
- originality
- technical difficulty
- execution
- clarity of animation and how to use it
- good documentation

=======

%}

%{
This is an open-ended design project that builds on the expertise you 
gained in the first two projects. The goal is to use Matlab to animate a 
compound mechanism, meaning a mechanism containing at least 2 closed kinematic chains. 
Simple examples include exercise mechanisms (squat press, bench press, shoulder press, elliptical trainer) such as those found in the outdoor fitness park behind the Olympic Oval. Each of these compound mechanisms has a mobility of one. Another example would be the front end loader mechanism on page 25 of the Lecture 1 slides, which has a mobility of 2. 

You can decide which inputs the user can specify and how they should specify these. 
For example, for the front end loader, the user could specify the starting 
bucket position and bucket angle and the final bucket position and angle, and the code could smoothly animate the mechanism's motion from the start to the finish and back, as well as plotting the displacement of the two control pistons versus time.

The header comment of the m-file should contain a paragraph or 2 explaining 
how to use the program, along with any relevant background, such as how you decided on any constant parameters (e.g. "we measured the link lengths from this bench press on campus; see attached photo"). You may want some parameters (e.g. some link lengths) to be input by the user, but you could provide default values. You get to decide.

The project grade will be based on originality, 
technical difficulty, execution, clarity 
(of the animation and its operation), and documentation. 
You will demonstrate and explain your project to the TA or instructor at a tutorial.

List of Topics and Sub-Modules for Project 4

%}

%=============================================================================
%% inputs and constraints

    % initX and initY, coordinates for the object to be moved from

    % finalX and finalY, coordinates for the object to be moved to

    % All coordinate inputs must fall within a semicircle with a radius of the arm's
    % maximum length, ie sum of hardcoded lengths for link 1 and link 2, and
    % both y coordinate inputs must be positive (might be a good idea to
    % have an offset equal to half the height of the movable object for
    % simple math)

%% plot elements:

    %{
    variable legend: 
    
    Given inputs: 
    initX, initY:   the initial x and y positions for the object to be moved
    finalX, finalY: the position the object should be moved to.
    speed:          the animation speed, rads/s of ___(whatever we consider the base link)____
    
        

    Defined within function:

    SCALAR  link1:  fixed length of link 1
    SCALAR  link2:  fixed length of link 2
    
    SCALAR  x0, y0: (fixed origin of link 1)
    

    ARRAY: x1, y1 (end of link 1, changing) 

    %}

% ground, both for the mechanism and maybe the lower limit of where the
% object can be moved to

% link 1, attached to ground

% link 2, attached to end of link 1, other end will be the bucket/claw/etc

% crank 1, input for link 1 angular position, slides along link 1 and is
% fixed to ground

% crank 2, input for link 2 angular position, slides along link 2 and is
% fixed to link 1

% movable object

% grabbing mechanism

% maybe some visual indicators of the initial and final positions (we could have pale dotted objects represent these positions and have the object itself in a brighter solid line colour)

%initialize fixed parameters
link1 = 10; 
crank1 = link1*0.25; 
crank1X = link1* 0.1; %X offset from origin
link2 = 10;
crank2 = link2*0.25;
crank2offset = 0.1*link1; %will be a small distance from the end of link 1

maxReach = link1 + link2;

%arrays
link1Angles = [pi/2, 0, 0]; %will contain default, init, and final positions
link2Angles = [0, 0, 0];
crank1Angles = [link1Angles(1) + asin(crank1X*sin(link1Angles(1))/crank1),0,0];
crank2Angles = [0,0,0]; %calculated relative to link 1 rather than ground?

if any([initX, finalX] < -maxReach | [initY, finalY] < 0) || ...
        any(hypot([initX, finalX], [initY, finalY]) > maxReach)
    error('Target coordinates must lie within the upper reachable semicircle.');
end

%default position       %TODO are these for the moveable object?
dPos = [0; link1 - link2];
%initial position based on inputs

%final position based on inputs
fPos = [finalX; finalY];


%% position states and motion

% default, link 1 pointing straight up and link 2 pointing straight down.
% angular positions can be hard coded


%the origin (fixed side of link 1)
x0 = 0;
y0 = 0;

%link 1 initial coordinates
x1(1) = x0; %TODO PLACEHOLDERS change to depend on angle
y1(1) = y0 + link1;

%link 2 coordinates
x2(1) = x1 + link2; %TODO PLACEHOLDERS change to depend on angle
y2(1) = y1;


% initial, moving free end of link 2 from default position to init
% coordinates specified by user

% final, moving links 1 and 2 such that the arm moves smoothly between init
% and final coordinates in a way that is physically possible

% return to default position, go from final position back to default
% position

%% inverse kinematics pseudocode
%% Default to init
    %1. Convert init coordinates to a position vector
    
    iPos = [initX; initY]; %TODO not sure if we need this
    iPosLength = hypot(initX, initY);
    
    %{
    2. Use cosine law and fixed link lengths to find the angles of the
    triangle made by the links and the position vector. WILL NEED TO
    SPECIFY WHICH OF THE POSSIBLE TRIANGLES WILL BE USED BASED ON WHICH
    SIDE OF THE MACHINE THIS POSITION IS ON. 
    3. Get CCW angle between ground and position vector, and add triangle angle
    adjacent to the ground to get an initial angular position for link 1
    %}
    %start with first quadrant only
    link1Angles(2) = acos((link1^2 + iPosLength^2 - link2^2)/(2*link1*iPosLength)) + atan2(initX, initY);
    link2Angles(2) = acos((link1^2 + link2^2 - iPosLength^2)/(2*link1*link2));
    %{
    4. Relate initial position of link 1 to an initial position of crank 1 
    using ICs or trig or whatever causes the least problems
    %}
    %using sin law
    crank1Angles(2) = link1Angles(2) + asin(crank1X*sin(link1Angles(2))/crank1);
    crank2Angles(2) = link2Angles(2) + asin(crank2offset*sin(link2Angles(2))/crank2); %relative to link 1
    %convert link 2 angular position to angle relative to positive x axis for plotting
    link2PlotAngle = (link1Angles(2) - 180) + crank2Angles(2);
    %{
    5. Rotate crank 1 from the default position to the calculated initial
    position while staying in quadrants 1
    %}
    %{
    6. Rotate crank 2 from the default position to the angular position
    associated with the angle between link 1 and 2 in the init position
    triangle (measured CCW relative to link 1 rather than the x axis?)
    %}


%% init to final
%{
    1. Convert final coordinates to a position vector
    2. Use cosine law and fixed link lengths to find the angles of the
    triangle made by the links and the final position vector. WILL NEED TO
    SPECIFY WHICH OF THE POSSIBLE TRIANGLES WILL BE USED BASED ON WHICH
    SIDE OF THE MACHINE THIS POSITION IS ON
    3. Compare the resulting angles with those from init position
    4. Relate final angular position of link 1 to an angular position of crank 1 
    using ICs or trig or whatever causes the least problems
    5. Rotate crank 1 from the init position to the final
    position while staying in quadrants 1 and 2
    6. Rotate crank 2 from the init position to the final position
    associated with the angle between link 1 and 2 in the init position
    triangle (CCW relative to link 1 rather than the x axis?)

%% final back to default
    1. Rotate crank 1 from the final position to the default
    position while staying in quadrants 1 and 2
    2. Rotate crank 2 from the final position to the default position
    associated with the angle between link 1 and 2 in the init position
    triangle (CCW relative to link 1 rather than the x axis?)
%}

%% Possible constraints
%{
    1. Position of ends of link 1 and link 2 must always be in the first 2
    quadrants relative to the origin where link 1 attached to the ground
    2. Input angle for crank 1 must be between 0 and pi rads, while crank 2
    can rotate between 0 and 2 pi rads (one-way or both ways)
    3. Links will only move one at a time
%}

%All animation code will need to use variable size loops due to variable
%lengths of motion

%maybe have link 2 extend so possible arm positions create a rectangular
%field rather than a circular one?



% 


%moveable object parameters:
radius = 2; 

%params for current center position of the object TODO placeholder
objX(1) = x2(1);% TODO Change to be the actual current position of the object instead of placeholders
objY(1) = y2(1);%

obj_pos = [objX - radius, objY - radius, 2*radius, 2*radius];





%% Animations
% TODO: move code below this up only when variables are needed further up

%% Creating Figure
% figure('Position', [100, 100, 1200, 600]) %makes the empty figure for the animation
    clf %clears figure if this function is run multiple times in a row
    set(gcf, 'Color', '#D3E2E8'); %makes the background blue


ax1 = subplot(3, 1, [1 2]); %adds the plot, maybe leaving space for a text box at (2 1 2) that can explain ?
hold on %allows everything here to be added to same figure

title('Project 4: Placeholder Title');


axis equal % sets axes to equal

    % Initial frame
    
        %plot object handles
            ground = line([(x0 -5) (x0+5)],[0 0],'linewidth', 2,'color','#0C8A11', 'LineStyle', '--'); %plot object for ground, does not need updating per frame

            links = plot([x0 x1(1) x2(1)],[y0 y1(1) y2(1)],'-o','linewidth',2, 'Color', 'b'); %plot obejct for rocker arm, spans from p0-p3
            
            
            m_object = rectangle('Position', obj_pos,...
                 'Curvature', [1 1], 'FaceColor', 'b', 'EdgeColor', 'k', 'LineWidth', 1.5);
    


            % initial and final object positions: (should not move)
             init_object = rectangle('Position', [initX - radius, initY - radius, 2*radius, 2*radius],...
                 'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'b', 'LineWidth', 1.5, 'LineStyle', '--');

             final_object = rectangle('Position', [finalX - radius, finalY - radius, 2*radius, 2*radius],...
                 'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'b', 'LineWidth', 1.5, 'LineStyle', '--');

            
            % moveable object
            m_object = rectangle('Position', obj_pos,...
                 'Curvature', [1 1], 'FaceColor', 'b', 'EdgeColor', 'k', 'LineWidth', 1.5);


    

 ax2 = subplot(3, 1, 3); %text box


        str = {'We can explain a bit about the function/the project here',... ...
            'placeholder for line 2',...
            'placeholder for line 3',...
            };
        
        text(0.5, 0.5, str, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 12);
                    
        hold off

                   

%% creating frames for animation 

    fps = 60; %frames per second [frames/second]
    rad_frame = speed / fps; %rads per frame, replaces astep
    theta2 = theta0:rad_frame:(n*2*pi)+theta0; %start:step:end notation, 0-3 full rotations, in steps of size astep      
    timestep = 1/fps; % fps inverted gives seconds per frame
    time = theta2 ./ speed; %ARRAY, (results in a time value in seconds for plotting angles)


%% Frame updates for both plots
     
    for n = 2:length(theta2)
        pause(timestep) %shows previous frame for timestep length
                
        %sets objects to next position
        %set(link4,'XData',[x0 x3(n)],'YData',[y0 y3(n)]);   %error in cases
        
  

    end %update end

end %function end