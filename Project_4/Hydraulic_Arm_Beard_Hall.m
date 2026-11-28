function [] = Hydraulic_Arm_Beard_Hall(linkLgth, initX, initY, finalX, finalY, speed)
%Quick start: run Hydraulic_Arm_Beard_Hall() with no arguments to get a
%rundown of the argument syntax in the command window

%% Function Description
%{
This function mechanism_Beard_Hall takes the following inputs and animates a
hydraulic robotic claw arm that can move an object between predetermined positions.

  [cm]      linkLgth:       the length of the 2 links 
  [cm]      initX, initY:   the initial x and y positions for the object to be moved
  [cm]      finalX, finalY: the position the object should be moved to.
  [cm/s]    speed:          the animation speed, piston length change per second

__Mathematical Overview____________________________________________________

    The initial and final positions will be converted to vectors that form
triangles with both links. The angles for these resulting triangles are
calculated using the cosine law, and those angles adjacent to the pistons
will be used in conjunction with the piston connection points on the ground
and each link to calculate the length of each piston at each of the passed
in positions.

    The 2 pistons act as inputs for this mechanism, with the length of each 
determining the angular position of one of the links ach piston will be set 
to a constant speed, which will be expressed as a change in length per 
frame of animation. An array of piston lengths is created by changing the 
piston length at each position by one step length until the piston length 
is within one step length of the next position. 

    Once this array is complete, the piston length in each frame of 
animation is used to calculate the angles of each mechanism element 
relative to the positive x axis, and those angles are then used to 
calculate coordinates of key points of the mechanism in every frame. In the 
animation, the movable object will simply move with the free end of the 
mechanism while it's moving between the object's initial and final 
positions. Graphs showing the piston lengths over time and the object's 
path between the initial and final positions are plotted in tandem with the
animation.

__Project Background and inspiration_______________________________________

    This project was inspired by toy robotics kits that use hydraulic pistons to
make a simple 2 part arm that you can then program and control. As this is
meant to be at a toy or hobby scale, the lengths are in cm

    To make the animation process possible using only matlab, several
simplifications were made. These kits usually allow 3d rotation, but this
was omitted to allow 2d planar animation. Additionally, in a real model of this, the arm would require a claw grabber
or a magnet to actually pick up an object. For simplicity's sake, this was
represented by the object sticking directly to the node on the end of the
arm once this node overlaps the object center. The two arms were also fixed
to be the same length, as this greatly simplifies the cases the animation
must cover.

%}

%% Housekeeping for repeated running/testing and message for if run improperly

close all %closes any windows that are open still

% message for if run with wrong number of arguments
if nargin < 6
    fprintf(['\n\n**This function Hydraulic_Arm_Beard_Hall animates a hydraulic robotic arm that can move an object between two predetermined positions**' ...
    '\n\n' ...
    'The syntax is Hydraulic_Arm_Beard_Hall(linkLgth, initX, initY, finalX, finalY, speed), where' ...
    '\n\nlinkLgth [cm]:     the length of the 2 arm ' ...
    '\ninitX, initY [cm]:   the initial x and y positions for the object to be moved from' ...
    '\nfinalX, finalY [cm]: the final x and y positions the object should be moved to.' ...
    '\nspeed [cm/s]:          the animation speed, piston length change per second\n' ...
    '' ...
    'Please re-run the function using the correct syntax. There should be 6 numerical arguments. \n\n' ...
    ''])
    return
end

%% Scalar variables within function
% -------------------------------------------------------------------------
%{
Given inputs: 

SCALAR link1Lgth : input arg, 1st arm length (ground to elbow) 
SCALAR link2Lgth : input arg, 2nd arm length (elbow to end)
SCALARS     initX, initY:       the initial x and y positions for the object to be moved
SCALARS     finalX, finalY:     the position the object should be moved to.
SCALAR      speed:          the animation speed, rads/s of ___(whatever we consider the base link)____
   
Calculated variables:

SCALAR      pst1Link1: distance along link 1 where piston 1 attaches
SCALAR      pst1Grnd: distance along horizontal ground from 0 where piston 1 attaches

SCALAR      pst2Link2: distance along link 2 (from elbow) where piston 1 attaches
SCALAR      pst2Link1: distance along link 1 (from elbow) 

SCALAR      maxReach: The length of the 2 arms added together, which sets
the radius of the outer circle bounding what the grabber can reach
%}


%% initialize fixed parameters

% Piston 1 distances along links, scales with arm length
link1Lgth = linkLgth;
pst1Link1 = link1Lgth*0.25; %point where piston 1 attaches to link 1 mesaured from ground
pst1Grnd = link1Lgth*0.1; %point where piston 1 attaches to ground measured as distance from arm base/origin

% Piston 2 distances along links, scales with arm length
link2Lgth = linkLgth;
pst2Link2 = link2Lgth*0.25; %point where piston 2 attaches to link 2 measured along link 2 from elbow
pst2Link1 = link1Lgth*0.1; %point where piston 2 attaches to link 1 measured along link 1 from elbow

%the origin (fixed side of link 1)
x0 = 0;
y0 = 0;

%max reachable area for compatibility checks
maxReach = link1Lgth + link2Lgth; %This length, as a diagonal, will be used to establish a square of acceptable coordinates?

%moveable object parameters:
radius = 0.05*linkLgth; 
 

%% Compatibility checks

%{
These compatibility checks ensure that all argument inputs are valid, and returns an appropriate error message if not. 
Speed and link length must be positive
Object must be in 1st quadrant and cannot clip through the ground
%}

% Checks that speed is positive non-zero number
if speed <= 0
        disp("Speed must be a positive number")
        return
end

% Checks that links are positive non-zero numbers in length
if min([link1Lgth, link2Lgth]) <= 0
        disp("Links must only have positive lengths")
        return
end

% bounds the points to be within the first quadrant, aka above ground and
% in reach of the arm
if min([initX, finalX]) < 0 
        fprintf("Initial or final coordinates out of bounds. \nObject x coordinates must always be positive.\n\n  ");
        return
end

% in reach of the arm
% the object scales with the arms, so thats why this dependency mentiosn
% the link lengths
if  min([initY, finalY]) < radius
        fprintf("Initial or final coordinates out of bounds. \nBased on a link length of %.4g, object y coordinates must be at least %.4g.\n\n  ",linkLgth, radius);
        return
end


%checks whether initial point or final point is further, checks whether
%furthest point is within reachable radius
if max([sqrt(initX^2 + initY^2) sqrt(finalX^2 + finalY^2)]) > maxReach 
    disp("points too far for grabbing range, please choose points closer to the origin, or make link lengths longer")
    return
end


%% Arrays for initial position calculations
%{
The hard coded default position assumes link 1 points straight up and link
2 is -45 from the horizontal
% for the following 2 arrays, first index is the piston or link number, and the second index is the specific position

Indices in use:
 1 = default position, 
 2 = initial position of object
 3 = final position
%}

% Angles needed for calculating piston lengths
linkAng = [pi/2, 0, 0; -pi/4, 0, 0];  

% Piston lengths associated with default, initial, and final positions
pstKeyFrames = [sqrt(pst1Grnd^2+pst1Link1^2-2*pst1Grnd*pst1Link1*cos(linkAng(1,1))),0,0; sqrt(pst2Link1^2+pst2Link2^2-2*pst2Link1*pst2Link2*cos(linkAng(2,1))),0,0];

%% initialising empty arrays to be filled with frame specific angle or length data

% Plotting parameters
linkPlotAng = zeros(2,0); %link angles
pstPlotLgth = zeros(2,0); %piston lengths
pstPlotAng = zeros(2,0); %piston angles

% Arrays to be filled with coordinate data
% 1st row is x coords, 2nd row is y coords, column is frame index
pst1End = zeros(2,0);
pst2Start = zeros(2,0);
pst2End = zeros(2,0);
link1End = zeros(2,0);
link2End = zeros(2,0);

%% Calculating initial position piston lengths
    %Convert init coordinates to a position vector
    iPosLgth = hypot(initX, initY); %SCALAR, length unit
    iPosAng = atan2(initY, initX); %SCALAR, RADS
    
    %Calculate link angles from triangle made with init position vector
    %this uses law of cosines to find angle
    linkAng(1,2) = acos((link1Lgth^2 + iPosLgth^2 - link2Lgth^2)/(2*link1Lgth*iPosLgth)) + iPosAng; %populating arrays initialised earlier
    linkAng(2,2) = acos((link1Lgth^2 + link2Lgth^2 - iPosLgth^2)/(2*link1Lgth*link2Lgth));
    
    %Calculate piston lengths
    %law of cosines again
    pstKeyFrames(1,2) = sqrt(pst1Grnd^2+pst1Link1^2-2*pst1Grnd*pst1Link1*cos(linkAng(1,2)));
    pstKeyFrames(2,2) = sqrt(pst2Link1^2+pst2Link2^2-2*pst2Link1*pst2Link2*cos(linkAng(2,2)));

%% Calculating final position piston lengths
    %Convert init coordinates to a position vector
    fPosLgth = hypot(finalX, finalY);
    fPosAng = atan2(finalY, finalX);
    
    %Calculate link angles from triangle made with init position vector
    linkAng(1,3) = acos((link1Lgth^2 + fPosLgth^2 - link2Lgth^2)/(2*link1Lgth*fPosLgth)) + fPosAng;
    linkAng(2,3) = acos((link1Lgth^2 + link2Lgth^2 - fPosLgth^2)/(2*link1Lgth*link2Lgth));
    
    %Calculate piston lengths
    pstKeyFrames(1,3) = sqrt(pst1Grnd^2+pst1Link1^2-2*pst1Grnd*pst1Link1*cos(linkAng(1,3)));
    pstKeyFrames(2,3) = sqrt(pst2Link1^2+pst2Link2^2-2*pst2Link1*pst2Link2*cos(linkAng(2,3)));

%% Creating frames for animation

    fps = 60; %frames per second
    pstFrameStep = speed/60; %piston length change per frame    
    
    timestep = 1/fps; % fps inverted gives seconds per frame

%% Populating the positions for all links for 3 phases of motion: ===================================================================================================
%{

There are 3 stages of motion to be captured by this animation. 

The first is when the arm moves from its default pose to the initial location of the
object, denoted by "default to initial" or shortened to di in some variable names. 

The second is when the arm is carrying the object from its initial position to its final position. This is denoted by
"initial to final" or if in some variable names

The 3rd and final stage of motion is when the arm has dropped the ball in
its final spot, and is returning to its default position. This is denoted
by "final to default" or fd in some variable names

%}
  %% default to initial 
% diTotal: number of frames in this stage of motion

  %initialize the first frame for this motion from the keyframes
    pstPlotLgth(1,1) = pstKeyFrames(1,1);
    pstPlotLgth(2,1) = pstKeyFrames(2,1);

    %Calculate total required frames based on which piston needs more steps
    %to get into the new position
    diTotal = ceil(max(abs((pstKeyFrames(1,2) - pstKeyFrames(1,1))/pstFrameStep), abs((pstKeyFrames(2,2) - pstKeyFrames(2,1))/pstFrameStep)));
  
    %once for each piston
    for i = 1:2 
        %for tracking when pistons are done moving to the new position
        pstDone = false;
        %for determining whether to increase or decrease a piston
        if pstKeyFrames(i,1) < pstKeyFrames(i,2) %Increase the value if initial is greater than default position
            sign = 1;
        elseif pstKeyFrames(i,1) > pstKeyFrames(i,2) %decrease the value if initial is less than default position
            sign = -1;
        else
            sign = 0;
        end
        %for each frame in the current motion
        for j = 2:diTotal
            %If the current piston isn't in its final position
            if pstDone == false
                %change the position by the step size in the determined
                %direction
                pstPlotLgth(i,j) = pstPlotLgth(i,(j-1)) + pstFrameStep*sign;
            else
                %set the current frame to the same position as the last
                %frame
                pstPlotLgth(i,j) = pstPlotLgth(i,j-1);
            end
            %if current frame's position is within a step size of the
            %initial position
            if abs(pstPlotLgth(i,j) - pstKeyFrames(i,2)) < pstFrameStep %%this may have to do with the visual jumps

                %Stop moving this piston during this motion
                pstDone = true;
            end
        end
    end

    %% initial to final
    
    %Calculate total required frames based on which piston needs more steps
    %to get into the new position
    ifTotal = ceil(max(abs((pstKeyFrames(1,3) - pstKeyFrames(1,2))/pstFrameStep), abs((pstKeyFrames(2,3) - pstKeyFrames(2,2))/pstFrameStep)));

    %once for each piston
    for i = 1:2 
        %for tracking when pistons are done moving to the new position
        pstDone = false;
        %for determining whether to increase or decrease a piston
        if pstKeyFrames(i,2) < pstKeyFrames(i,3) %Increase the value if final is greater than initial position
            sign = 1;
        elseif pstKeyFrames(i,2) > pstKeyFrames(i,3) %decrease the value if final is less than initial position
            sign = -1;
        else
            sign = 0;
        end
        %for each frame in the current motion
        for j = (diTotal + 1):(diTotal + ifTotal)
            %If the current piston isn't in its final position
            if pstDone == false
                %change the position by the step size in the determined
                %direction
                pstPlotLgth(i,j) = pstPlotLgth(i,(j-1)) + pstFrameStep*sign;
            else
                %set the current frame to the same position as the last
                %frame
                pstPlotLgth(i,j) = pstPlotLgth(i,j-1);
            end
            %if current frame's position is within a step size of the
            %initial position
            if abs(pstPlotLgth(i,j) - pstKeyFrames(i,3)) < pstFrameStep
                %Stop moving this piston during this motion
                pstDone = true;
            end
        end
    end

    %% final back to default

    %Calculate total required frames based on which piston needs more steps
    %to get into the new position
    fdTotal = ceil(max(abs((pstKeyFrames(1,1) - pstKeyFrames(1,3))/pstFrameStep), abs((pstKeyFrames(2,1) - pstKeyFrames(2,3))/pstFrameStep)));
 
    %once for each piston
    for i = 1:2 
        %for tracking when pistons are done moving to the new position
        pstDone = false;
        %for determining whether to increase or decrease a piston
        if pstKeyFrames(i,3) < pstKeyFrames(i,1) %Increase the value if default is greater than final position
            sign = 1;
        elseif pstKeyFrames(i,3) > pstKeyFrames(i,1) %decrease the value if default is less than final position
            sign = -1;
        else
            sign = 0;
        end
        %for each frame in the current motion
        for j = (diTotal + ifTotal + 1):(diTotal + ifTotal + fdTotal)
            %If the current piston isn't in its final position
            if pstDone == false
                %change the position by the step size in the determined
                %direction
                pstPlotLgth(i,j) = pstPlotLgth(i,(j-1)) + pstFrameStep*sign;
            else
                %set the current frame to the same position as the last
                %frame
                pstPlotLgth(i,j) = pstPlotLgth(i,j-1);
            end
            %if current frame's position is within a step size of the
            %initial position
            if abs(pstPlotLgth(i,j) - pstKeyFrames(i,1)) < pstFrameStep
                %Stop moving this piston during this motion
                pstDone = true;
            end
        end
    end
    
%% converting from angles to coordinate arrays for graphing purposes

% Calculate angles of all plot elements relative to positive x axis for each
% frame based on piston lengths
for i = 1:length(pstPlotLgth)
    pstPlotAng(1,i) = pi - acos((pstPlotLgth(1,i)^2+pst1Grnd^2-pst1Link1^2)/(2*pstPlotLgth(1,i)*pst1Grnd));
    linkPlotAng(1,i) = acos((pst1Link1^2+pst1Grnd^2-pstPlotLgth(1,i)^2)/(2*pst1Link1*pst1Grnd));
    
    pstPlotAng(2,i) = linkPlotAng(1,i) - acos((pst2Link1^2+pstPlotLgth(2,i)^2-pst2Link2^2)/(2*pst2Link1*pstPlotLgth(2,i)));
    linkPlotAng(2,i) = (linkPlotAng(1,i) - pi) + acos((pst2Link1^2+pst2Link2^2-pstPlotLgth(2,i)^2)/(2*pst2Link1*pst2Link2));
end

%calculate per frame plot element coordinates
for i = 1:length(pstPlotLgth)

    %coordinates of the end of link 1
    link1End(1,i) = link1Lgth*cos(linkPlotAng(1,i));
    link1End(2,i) = link1Lgth*sin(linkPlotAng(1,i));
    
    %coordinates of the end of link 2
    link2End(1,i) = link1Lgth*cos(linkPlotAng(1,i)) + link2Lgth*cos(linkPlotAng(2,i));
    link2End(2,i) = link1Lgth*sin(linkPlotAng(1,i)) + link2Lgth*sin(linkPlotAng(2,i));
    
    
    %coordinates of the end of piston 1, start is fixed at (pst1Grnd, 0)
    pst1End(1,i) = pstPlotLgth(1,i)*cos(pstPlotAng(1,i)) + pst1Grnd;
    pst1End(2,i) = pstPlotLgth(1,i)*sin(pstPlotAng(1,i));
    
    %coordinates of the start of piston 2 along link 1
    pst2Start(1,i) = (link1Lgth - pst2Link1)*cos(linkPlotAng(1,i));
    pst2Start(2,i) = (link1Lgth - pst2Link1)*sin(linkPlotAng(1,i));
    
    %coordinates of the end of piston 2 along link 2
    pst2End(1,i) = (link1Lgth - pst2Link1)*cos(linkPlotAng(1,i)) + pstPlotLgth(2,i)*cos(pstPlotAng(2,i));
    pst2End(2,i) = (link1Lgth - pst2Link1)*sin(linkPlotAng(1,i)) + pstPlotLgth(2,i)*sin(pstPlotAng(2,i));
end

%% movable object initialisation and coordinates
    
    %moveable object parameters:
    radius = 0.05*linkLgth; 
    
    %grabbing num of frames
    num_frames = length(pstPlotLgth);

    %initialising positions for ball 
    objX = zeros(1, num_frames);
    objY = zeros(1, num_frames);

    %default to initial
    %object stays at initial position till picked up 
    objX(1:diTotal) = initX;
    objY(1:diTotal) = initY;

    %initial to final
    %object follows link 2 end coordinates from initial to final
    carry_frames = (diTotal + 1):(diTotal + ifTotal); %frame indices for following link 2, from frame after Default to initial to 
    objX(carry_frames) = link2End(1, carry_frames);
    objY(carry_frames) = link2End(2, carry_frames);
    
    %final to default
    %obj stays at final position 
    drop_frames = (diTotal + ifTotal + 1):num_frames; %frame indices for final position
    objX(drop_frames) = finalX;
    objY(drop_frames) = finalY;

    %position matrix for rectangle object acting as ball
    obj_pos = [objX - radius; objY - radius; repmat(2*radius, 1, num_frames); repmat(2*radius, 1, num_frames)];


%% precalculating points for the graphs

%array for holding piston lengths
span1 = hypot(pst1End(1, :) - pst1Grnd, pst1End(2, :));
span2 = hypot(pst2End(1, :) - pst2Start(1, :), pst2End(2, :) - pst2Start(2, :));

deltaTime =  (1:size(pstPlotLgth, 2)) ./ fps; %elapsed time in seconds

% piston velocities
v1 = gradient(span1, timestep);
v2 = gradient(span2, timestep);


%% Animations

% Creating figure

    figure('Position', [100, 10, 1200, 1000]) %makes the empty figure for the animation
    set(gcf, 'Color', '#D3E2E8'); %makes the background blue

    sgtitle('Project 4: Hydraulic 2 Segment Grabbing Arm', 'FontWeight', 'bold');

% main animation plot   
ax1 = subplot(2, 2, 1); %The animation
hold on %allows everything here to be added to same figure

title('Animation Window');

% Setting reasonable axes
   axis equal % sets axes to equal
        
        % finds appropriate window bounds from arrays
        xmin = 1.2 * min([-5 min([x0, pst1Grnd, initX, finalX, link1End(1,:), link2End(1,:), pst1End(1,:), pst2Start(1,:), pst2End(1,:), objX])]);  %uses all x vals    % 120% safety margin on leftmost position of the crank
        xmax = 1.2 * max([x0, pst1Grnd, initX, finalX, link1End(1,:), link2End(1,:), pst1End(1,:), pst2Start(1,:), pst2End(1,:), objX]);     % 120% safety margin on extended position of crank, to be changed
        ymin = 1.2 * min([-5, min([y0, initY, finalY, link1End(2,:), link2End(2,:), pst1End(2,:), pst2Start(2,:), pst2End(2,:), objY])]);               % takes smallest of (lowest crank position or offset), subtracts half r3 for margin
        ymax = 1.2 * max([y0, initY, finalY, link1End(2,:), link2End(2,:), pst1End(2,:), pst2Start(2,:), pst2End(2,:), objY]);               % same as ymin but in positive direction
      
        %axis([xmin, xmax, ymin, ymax])
        xlim([xmin, xmax]);
        ylim([ymin, ymax]);

   
% Initial frame
    
     %Static plot object handles:

     % initial and final object positions, outlines: (should not move)
             init_object = rectangle('Position', [initX - radius, initY - radius, 2*radius, 2*radius],...
                 'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'r', 'LineWidth', 1.5, 'LineStyle', '--');

             final_object = rectangle('Position', [finalX - radius, finalY - radius, 2*radius, 2*radius],...
                 'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'r', 'LineWidth', 1.5, 'LineStyle', '--');

            ground = line([xmin xmax],[0 0],'linewidth', 2,'color','#0C8A11', 'LineStyle', '-'); %plot object for ground, does not need updating per frame

    %plot object handles for animating

            % moveable object
            m_object = rectangle('Position', obj_pos(:, 1),...
                 'Curvature', [1 1], 'FaceColor', 'r', 'EdgeColor', 'k', 'LineWidth', 1.5);

            links = plot([x0 link1End(1,1) link2End(1,1)],[y0 link1End(2,1) link2End(2,1)],'-o','linewidth',2, 'Color', 'k'); %plot obejct for rocker arm, spans from p0-p3
            
            piston1 = plot([pst1Grnd pst1End(1,1)],[0 pst1End(2,1)],'-o','linewidth',2, 'Color', 'b'); %plots piston connected to ground
            piston2 = plot([pst2Start(1,1) pst2End(1,1)],[pst2Start(2,1) pst2End(2,1)],'-o','linewidth',2, 'Color', 'g'); %plots piston at link elbow

  
%object trajectory plot
     ax2 = subplot(2, 2, 2); %object path graph
        hold on;
    
        axis equal
        title('Object Path');
    
        %reusing axes 
        %axis([xmin, xmax, ymin, ymax]) 

        xlim([xmin, xmax]);
        ylim([ymin, ymax]);
    
        pathPlot = plot(obj_pos(1,:),obj_pos(2,:), 'LineWidth', 1, 'Color', 'r',  'LineStyle', '--');
        pathMark = plot(obj_pos(:,1),obj_pos(:,1), 'bo', 'MarkerFaceColor','r','MarkerSize',10);
        hold off;
    
%piston length plots 
     ax3 = subplot(2, 2, [3, 4]); %Piston length vs time graph
    
        hold on;
        yyaxis left %adds left axis stuff and plots relative to that
        
            xlabel('Time (s)');
            ylabel('length (cm)');
            %grid on
            
            ylim([0, 1.2 * max([span1, span2])]); %sets y limits to 1.2 times extreme vals
            
            %rad_lims = ylim;
        
            title('Piston lengths and velocities over time');
    
         %positions
         p1P = plot(deltaTime, span1, 'linewidth', 3, 'Color', 'b');  %draws the graph
         p2P = plot(deltaTime, span2, 'linewidth', 3, 'Color', 'g', 'LineStyle', '-');  
         
         plot1mark = plot(deltaTime(1), span1(1), 'bo', 'MarkerFaceColor', 'b'); %adds a marker to the time graph for current angle at current time
         plot2mark = plot(deltaTime(1), span2(1), 'bo', 'MarkerFaceColor', 'g'); %adds a marker to the time graph for current angle at current time
        
        %velocities
        yyaxis right
        ylabel('Velocity (cm/s)');
        
        %lines showing pistons move at constant positive or negative
        %velocity
        yline(speed,  '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
        yline(-speed, '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
        yline(0, '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.2');
    
        p1V = plot(deltaTime, v1, 'LineWidth', 1.5, 'Color', 'b', 'LineStyle', '--');
        p2V = plot(deltaTime, v2, 'LineWidth', 1.5, 'Color', 'g', 'LineStyle', '--');
    
        v1mark = plot(deltaTime(1), v1(1), 'bo', 'MarkerFaceColor', 'b');
        v2mark = plot(deltaTime(1), v2(1), 'go', 'MarkerFaceColor', 'g');
    
        legend([p1P, p1V, p2P, p2V], ...
         {'Piston 1 Length', 'Piston 1 Velocity', 'Piston 2 Length', 'Piston 2 Velocity'}, ...
        'Location', 'northwest');


        hold off;


 pause(1)   
%% Frame updates for all plots


    for i = 2:length(pstPlotLgth)
        pause(timestep) %shows previous frame for timestep length
                
        %sets objects to next position
        set(links,'XData',[x0 link1End(1,i) link2End(1,i)],'YData',[y0 link1End(2,i) link2End(2,i)]);
        set(piston1,'XData',[pst1Grnd pst1End(1,i)],'YData',[0 pst1End(2,i)]);
        set(piston2,'XData',[pst2Start(1,i) pst2End(1,i)],'YData',[pst2Start(2,i) pst2End(2,i)]);

        set(m_object, 'Position', obj_pos(:, i));

        %graphs 
        %velocity markers
        set(plot1mark, 'XData', deltaTime(i), 'YData', span1(i));
        set(plot2mark, 'XData', deltaTime(i), 'YData', span2(i));
        
        %position markers
        set(v1mark,   'XData', deltaTime(i), 'YData', v1(i));
        set(v2mark,   'XData', deltaTime(i), 'YData', v2(i));
        %path tracing marker
        set(pathMark, 'XData', obj_pos(1,i), 'YData', obj_pos(2,i));

    end %update end

end %main function close


