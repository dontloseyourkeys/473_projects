function [] = mechanism_Beard_Hall(initX, initY, finalX, finalY, speed)
%% Function Description
%{
This function mechanism_Beard_Hall takes inputs 
______ and animates a
hydraulic robotic claw arm that can move an object.


initX, initY: the initial x and y positions for the object to be moved
finalX, finalY: the position the object should be moved to.
speed: the animation speed, piston length change per second
%}


close all %closes any windows that are open still

%mechanism_Beard_Hall(beta1, beta2, beta3, beta4, speed, L, R0)

% TODO remove before submission but these are placeholders so we can easily
% test
if nargin < 4
        initX = 80;
        initY = 20;
        finalX = 30;
        finalY = 70;
        speed = 3;
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
link1Lgth = 50;
pst1Link1 = link1Lgth*0.25; %point where piston 1 attaches to link 1 mesaured from ground
pst1Grnd = link1Lgth*0.1; %point where piston 1 attaches to ground measured as distance from arm base/origin
link2Lgth = 50;
pst2Link2 = link2Lgth*0.25; %point where piston 2 attaches to link 2 measured along link 2 from elbow
pst2Link1 = link1Lgth*0.1; %point where piston 2 attaches to link 1 measured along link 1 from elbow


%% PST2LINK1 WILL NEED TO BE SUBTRACTED FROM LINK 1 TO GET RIGHT LENGTH FOR THE PLOT

maxReach = link1Lgth + link2Lgth; %This length, as a diagonal, will be used to establish a square of acceptable coordinates?

%% Arrays, hard coded default position assumes link 1 points straight up and link 2 is at 0 radians from + x axis
%% for the following 2 arrays, first index is the piston or link number, and the second index is the specific position
%% 1 = default position, 2 = initial position of object, 3 = final position
%% Angles needed for calculating piston lengths
linkAng = [pi/2, 0, 0; -pi/4, 0, 0];
%% Piston lengths associated with default, initial, and final positions
pstKeyFrames = [sqrt(pst1Grnd^2+pst1Link1^2-2*pst1Grnd*pst1Link1*cos(linkAng(1,1))),0,0; sqrt(pst2Link1^2+pst2Link2^2-2*pst2Link1*pst2Link2*cos(linkAng(2,1))),0,0];

%% Arrays to be filled with frame specific angle or length data based on 
%% interpolation between values contained in the arrays above
linkPlotAng = zeros(2,0); %link angles
pstPlotLgth = zeros(2,0); %piston lengths
pstPlotAng = zeros(2,0); %piston angles

% Arrays to be filled with coordinate data
% 1st row is x coords, 2nd row is y coords, column is frame
pst1End = zeros(2,0);
pst2Start = zeros(2,0);
pst2End = zeros(2,0);
link1End = zeros(2,0);
link2End = zeros(2,0);

%% position states and motion

%the origin (fixed side of link 1)
x0 = 0;
y0 = 0;

%link 1 initial coordinates
x1(1) = x0; %TODO PLACEHOLDERS change to depend on angle
y1(1) = y0 + link1Lgth;

%link 2 coordinates
x2(1) = x1 + link2Lgth; %TODO PLACEHOLDERS change to depend on angle
y2(1) = y1;

% initial, moving free end of link 2 from default position to init
% coordinates specified by user

% final, moving links 1 and 2 such that the arm moves smoothly between init
% and final coordinates in a way that is physically possible

% return to default position, go from final position back to default
% position

%% Calculating initial and final position data (CURRENTLY FOR 1ST QUADRANT ONLY)
%% initial position
    %Convert init coordinates to a position vector
    iPosLgth = hypot(initX, initY);
    iPosAng = atan2(initY, initX); %apparently Atan takes y first
    %Calculate link angles from triangle made with init position vector
    linkAng(1,2) = acos((link1Lgth^2 + iPosLgth^2 - link2Lgth^2)/(2*link1Lgth*iPosLgth)) + iPosAng;
    linkAng(2,2) = acos((link1Lgth^2 + link2Lgth^2 - iPosLgth^2)/(2*link1Lgth*link2Lgth));
    %Calculate piston lengths
    pstKeyFrames(1,2) = sqrt(pst1Grnd^2+pst1Link1^2-2*pst1Grnd*pst1Link1*cos(linkAng(1,2)));
    pstKeyFrames(2,2) = sqrt(pst2Link1^2+pst2Link2^2-2*pst2Link1*pst2Link2*cos(linkAng(2,2)));
    
    %superfluous but keeping around just in case
    %{
    %Get the angle of link 2 relative to the positive x axis for plotting
    lnk2PltAng(2) = (link1Ang(2) - 180) + link2Ang(2);
    %Calculate piston angles for plotting
    pst1PltAng(2) = asin((pst1Link1*sin(link1Ang(2)))/pst1KeyFrames(2));
    pst2PltAng(2) = (link1Ang(2) - asin((pst2Link2*sin(link2Ang(2)))/pst2KeyFrames(2))); %relative to positive x axis
    %}
    
%% final position
    %Convert init coordinates to a position vector
    fPosLgth = hypot(finalX, finalY);
    fPosAng = atan2(finalY, finalX);

    %Calculate link angles from triangle made with init position vector
    linkAng(1,3) = acos((link1Lgth^2 + fPosLgth^2 - link2Lgth^2)/(2*link1Lgth*fPosLgth)) + fPosAng;
    linkAng(2,3) = acos((link1Lgth^2 + link2Lgth^2 - fPosLgth^2)/(2*link1Lgth*link2Lgth));

    %Calculate piston lengths
    pstKeyFrames(1,3) = sqrt(pst1Grnd^2+pst1Link1^2-2*pst1Grnd*pst1Link1*cos(linkAng(1,3)));
    pstKeyFrames(2,3) = sqrt(pst2Link1^2+pst2Link2^2-2*pst2Link1*pst2Link2*cos(linkAng(2,3)));
    
    %superfluous but want to keep around just in case
    %{
    %Get the angle of link 2 relative to the positive x axis for plotting
    link2PltAng(3) = (link1Ang(3) - 180) + link2Ang(3);
    %Calculate piston angles for plotting
    pst1PltAng(3) = asin((pst1Link1*sin(link1Ang(3)))/pst1KeyFrames(3));
    pst2PltAng(3) = (link1Ang(3) - asin((pst2Link2*sin(link2Ang(3)))/pst2KeyFrames(2))); %relative to positive x axis
    %}
   
%% Creating frames for animation
    fps = 60; %frames per second [frames/second]
    pstFrameStep = speed/60; %piston length change per frame    


    %% defualt to initial

    %initialize the first frame for this motion
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
            if abs(pstPlotLgth(i,j) - pstKeyFrames(i,2)) < pstFrameStep
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
    
    %Calculate angles of all plot elements relative to positive x axis for each
    %frame based on piston lengths
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
%% using the calculated values for the obj position array

    %% movable object initialisation
    
    
    %moveable object parameters:
    radius = 2; 
    
    %grabbing num of frames
    num_frames = length(pstPlotLgth);
    
    %initialising positions for ball
    objX = zeros(1, num_frames);
    objY = zeros(1, num_frames);

    %object stays at initial position till picked up
    objX(1:diTotal) = initX;
    objY(1:diTotal) = initY;

    
    %object follows link 2 end coordinates from initial to final
    carry_frames = (diTotal + 1):(diTotal + ifTotal); %frame indices for following link 2
    objX(carry_frames) = link2End(1, carry_frames);
    objY(carry_frames) = link2End(2, carry_frames);

    %obj stays at final position 
    drop_frames = (diTotal + ifTotal + 1):num_frames; %frame indices for final position
    objX(drop_frames) = objX(diTotal + ifTotal);
    objY(drop_frames) = objY(diTotal + ifTotal);
    

    %position matrix for rectangle object acting as ball
    obj_pos = [objX - radius; objY - radius; repmat(2*radius, 1, num_frames); repmat(2*radius, 1, num_frames)];
    size(obj_pos)


    %% Possible constraints
%{
    1. Position of ends of link 1 and link 2 must always be in the first 2
    quadrants relative to the origin where link 1 attached to the ground
    2. Input angle for crank 1 must be between 0 and pi rads, while crank 2
    can rotate between 0 and 2 pi rads (one-way or both ways)
    3. Links will only move one at a time
%}




%% Animations
% TODO: move code below this up only when variables are needed further up

%% Creating Figure
% figure('Position', [100, 100, 1200, 600]) %makes the empty figure for the animation
    clf %clears figure if this function is run multiple times in a row
    set(gcf, 'Color', '#D3E2E8'); %makes the background blue


ax1 = subplot(3, 1, [1 2]); %adds the plot, maybe leaving space for a text box at (2 1 2) that can explain ?
hold on %allows everything here to be added to same figure

title('Project 4: Hydraulic 2 Segment Claw Arm');


axis equal % sets axes to equal

    % Initial frame
    
        %plot object handles
            ground = line([(x0 -5) (x0+5)],[0 0],'linewidth', 2,'color','#0C8A11', 'LineStyle', '--'); %plot object for ground, does not need updating per frame

            links = plot([x0 link1End(1,1) link2End(1,1)],[y0 link1End(2,1) link2End(2,1)],'-o','linewidth',2, 'Color', 'b'); %plot obejct for rocker arm, spans from p0-p3
            
            piston1 = plot([pst1Grnd pst1End(1,1)],[0 pst1End(2,1)],'-o','linewidth',2, 'Color', 'r'); %plots piston connected to ground

            piston2 = plot([pst2Start(1,1) pst2End(1,1)],[pst2Start(2,1) pst2End(2,1)],'-o','linewidth',2, 'Color', 'r'); %plots piston at link elbow
            
            % initial and final object positions: (should not move)
             init_object = rectangle('Position', [initX - radius, initY - radius, 2*radius, 2*radius],...
                 'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'b', 'LineWidth', 1.5, 'LineStyle', '--');

             final_object = rectangle('Position', [finalX - radius, finalY - radius, 2*radius, 2*radius],...
                 'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'b', 'LineWidth', 1.5, 'LineStyle', '--');

            % moveable object
            m_object = rectangle('Position', obj_pos(:, 1),...
                 'Curvature', [1 1], 'FaceColor', 'b', 'EdgeColor', 'k', 'LineWidth', 1.5);


 ax2 = subplot(3, 1, 3); %text box


        str = {'Inspired by toy robotics kits, this project animates ',... ...
            'a hydraulic arm that can grab and move a ball from ',...
            'an initial position to a final position',...
            };
        
        text(0.5, 0.5, str, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 12);
                    
        hold off


%% Frame updates for both plots

    timestep = 1/fps; % fps inverted gives seconds per frame
    for i = 2:length(pstPlotLgth)
        pause(timestep) %shows previous frame for timestep length
                
        %sets objects to next position
        %set(link4,'XData',[x0 x3(n)],'YData',[y0 y3(n)]);   %error in cases
        set(links,'XData',[x0 link1End(1,i) link2End(1,i)],'YData',[y0 link1End(2,i) link2End(2,i)]);
        set(piston1,'XData',[pst1Grnd pst1End(1,i)],'YData',[0 pst1End(2,i)]);
        set(piston2,'XData',[pst2Start(1,i) pst2End(1,i)],'YData',[pst2Start(2,i) pst2End(2,i)]);

        set(m_object, 'Position', obj_pos(:, i));

    end %update end

end %function end