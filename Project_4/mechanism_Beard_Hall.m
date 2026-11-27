function [] = mechanism_Beard_Hall(linkLgth, initX, initY, finalX, finalY, speed)

%% Function Description
%{
This function mechanism_Beard_Hall takes the following inputs and animates a
hydraulic robotic claw arm that can move an object between predetermined positions.

linkLgth: the length of the 2 links
initX, initY: the initial x and y positions for the object to be moved
finalX, finalY: the position the object should be moved to.
speed: the animation speed, piston length change per second

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

%}

% to remove

%{
test cases that present odd behavior: 
mechanism_Beard_Hall(30, 40, 0, 10, 10, 40, 1)

%}

close all %closes any windows that are open still

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

%% initialize fixed parameters

link1Lgth = linkLgth;
pst1Link1 = link1Lgth*0.25; %point where piston 1 attaches to link 1 mesaured from ground
pst1Grnd = link1Lgth*0.1; %point where piston 1 attaches to ground measured as distance from arm base/origin

link2Lgth = linkLgth;
pst2Link2 = link2Lgth*0.25; %point where piston 2 attaches to link 2 measured along link 2 from elbow
pst2Link1 = link1Lgth*0.1; %point where piston 2 attaches to link 1 measured along link 1 from elbow

%the origin (fixed side of link 1)
x0 = 0;
y0 = 0;

%% Compatibility checks

maxReach = link1Lgth + link2Lgth; %This length, as a diagonal, is the maximum radius of the arm's motion

if min([link1Lgth, link2Lgth]) < 0
        disp("Links must only have positive lengths")
        return
end

if min([initX, initY, finalX, finalY]) < 0
        disp("Points must only have positive coordinates")
        return
end

if max([sqrt(initX^2 + initY^2) sqrt(finalX^2 + finalY^2)]) > maxReach
    disp("points too far for grabbing range, please choose points closer to the origin, or adjust link lengths")
    return
end

%% Arrays, hard coded default position assumes link 1 points straight up and link 2 is at 0 radians from + x axis
%% for the following 2 arrays, first index is the piston or link number, and the second index is the specific position
%% 1 = default position, 2 = initial position of object, 3 = final position

%% Angles needed for calculating piston lengths
linkAng = [pi/2, 0, 0; -pi/4, 0, 0];
%% Piston lengths associated with default, initial, and final positions
pstKeyFrames = [sqrt(pst1Grnd^2+pst1Link1^2-2*pst1Grnd*pst1Link1*cos(linkAng(1,1))),0,0; sqrt(pst2Link1^2+pst2Link2^2-2*pst2Link1*pst2Link2*cos(linkAng(2,1))),0,0];

%% Arrays to be filled with frame specific angle or length data

% Plotting parameters
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

%% Calculating initial position piston lengths
    %Convert init coordinates to a position vector
    iPosLgth = hypot(initX, initY);
    iPosAng = atan2(initY, initX); %apparently Atan takes y first

    %Calculate link angles from triangle made with init position vector
    linkAng(1,2) = acos((link1Lgth^2 + iPosLgth^2 - link2Lgth^2)/(2*link1Lgth*iPosLgth)) + iPosAng;
    linkAng(2,2) = acos((link1Lgth^2 + link2Lgth^2 - iPosLgth^2)/(2*link1Lgth*link2Lgth));

    %Calculate piston lengths
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

    if any(link2End(2,:) < 0)
        disp("Resulting motion would put the free end of the arm below the ground. " + ...
            "Please increase the smallet y coordinate.")
        return
    end

%% using the calculated values for the obj position array

    %% movable object initialisation
    
    %moveable object parameters:
    radius = 0.05*linkLgth; 
    
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
    drop_frames = (diTotal + ifTotal):num_frames; %frame indices for final position
    objX(drop_frames) = objX(diTotal + ifTotal);
    objY(drop_frames) = objY(diTotal + ifTotal);

    %position matrix for rectangle object acting as ball
    obj_pos = [objX - radius; objY - radius; repmat(2*radius, 1, num_frames); repmat(2*radius, 1, num_frames)];

    %% graphing

%array for holding 

span1 = hypot(pst1End(1, :) - pst1Grnd, pst1End(2, :));
span2 = hypot(pst2End(1, :) - pst2Start(1, :), pst2End(2, :) - pst2Start(2, :));

deltaTime =  (1:size(pstPlotLgth, 2)) ./ fps; %time in seconds

%% Animations

%% Creating Figure

    clf %clears figure if this function is run multiple times in a row

ax1 = subplot(6, 2, [1, 3, 5]); %The animation
hold on %allows everything here to be added to same figure

title('Project 4: Hydraulic 2 Segment Claw Arm');

% Setting reasonable axes
   axis equal % sets axes to equal
        
        % finds appropriate window bounds
        xmin = 1.2 * min([-5 min([x0, pst1Grnd, initX, finalX, link1End(1,:), link2End(1,:), pst1End(1,:), pst2Start(1,:), pst2End(1,:), objX])]);  %uses all x vals    % 120% safety margin on leftmost position of the crank
        xmax = 1.2 * max([x0, pst1Grnd, initX, finalX, link1End(1,:), link2End(1,:), pst1End(1,:), pst2Start(1,:), pst2End(1,:), objX]);     % 120% safety margin on extended position of crank, to be changed
        ymin = 1.2 * min([-5, min([y0, initY, finalY, link1End(2,:), link2End(2,:), pst1End(2,:), pst2Start(2,:), pst2End(2,:), objY])]);               % takes smallest of (lowest crank position or offset), subtracts half r3 for margin
        ymax = 1.2 * max([y0, initY, finalY, link1End(2,:), link2End(2,:), pst1End(2,:), pst2Start(2,:), pst2End(2,:), objY]);               % same as ymin but in positive direction
      
        %axis([xmin, xmax, ymin, ymax])
        xlim([xmin, xmax]);
        ylim([ymin, ymax]);

    % Initial frame
    
        %plot object handles

             % initial and final object positions: (should not move)
             init_object = rectangle('Position', [initX - radius, initY - radius, 2*radius, 2*radius],...
                 'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'b', 'LineWidth', 1.5, 'LineStyle', '--');

             final_object = rectangle('Position', [finalX - radius, finalY - radius, 2*radius, 2*radius],...
                 'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'b', 'LineWidth', 1.5, 'LineStyle', '--');

            ground = line([(x0-10) (x0+10)],[0 0],'linewidth', 2,'color','#0C8A11', 'LineStyle', '--'); %plot object for ground, does not need updating per frame

            %plot object handles for animating
            links = plot([x0 link1End(1,1) link2End(1,1)],[y0 link1End(2,1) link2End(2,1)],'-o','linewidth',2, 'Color', 'b'); %plot obejct for rocker arm, spans from p0-p3
            
            piston1 = plot([pst1Grnd pst1End(1,1)],[0 pst1End(2,1)],'-o','linewidth',2, 'Color', 'r'); %plots piston connected to ground

            piston2 = plot([pst2Start(1,1) pst2End(1,1)],[pst2Start(2,1) pst2End(2,1)],'-o','linewidth',2, 'Color', 'm'); %plots piston at link elbow
            
            % moveable object
            m_object = rectangle('Position', obj_pos(:, 1),...
                 'Curvature', [1 1], 'FaceColor', 'b', 'EdgeColor', 'k', 'LineWidth', 1.5);

 ax2 = subplot(6, 2, [9, 10, 11, 12]); %Piston length vs time graph

    hold on;
    yyaxis left %adds left axis stuff and plots relative to that
    
        xlabel('Time (s)');
        ylabel('length');
        grid on
        
        ylim([0, 1.2 * max([span1, span2])]); %sets y limits to 1.2 times extreme vals
        
        %rad_lims = ylim;
    
        title('Piston lengths overtime');

     span1plot = plot(deltaTime, span1, 'linewidth', 2, 'Color', 'r');  %draws the graph
     span2plot = plot(deltaTime, span2, 'linewidth', 2, 'Color', 'm');  %draws the graph
     
     plot1mark = plot(deltaTime(1), span1(1), 'bo', 'MarkerFaceColor', 'r'); %adds a marker to the time graph for current angle at current time
     plot2mark = plot(deltaTime(1), span2(1), 'bo', 'MarkerFaceColor', 'm'); %adds a marker to the time graph for current angle at current time
    
    hold off;
    
    pause(1)   

 
 ax3 = subplot(6,2,[2,4,6]); %object path graph
    hold on;
    
    title('Object Path');

    xmin = 1.2 * min([-5 min([x0, pst1Grnd, initX, finalX, link1End(1,:), link2End(1,:), pst1End(1,:), pst2Start(1,:), pst2End(1,:), objX])]);  %uses all x vals    % 120% safety margin on leftmost position of the crank
    xmax = 1.2 * max([x0, pst1Grnd, initX, finalX, link1End(1,:), link2End(1,:), pst1End(1,:), pst2Start(1,:), pst2End(1,:), objX]);     % 120% safety margin on extended position of crank, to be changed
    ymin = 1.2 * min([-5, min([y0, initY, finalY, link1End(2,:), link2End(2,:), pst1End(2,:), pst2Start(2,:), pst2End(2,:), objY])]);               % takes smallest of (lowest crank position or offset), subtracts half r3 for margin
    ymax = 1.2 * max([y0, initY, finalY, link1End(2,:), link2End(2,:), pst1End(2,:), pst2Start(2,:), pst2End(2,:), objY]);               % same as ymin but in positive direction

    %axis([xmin, xmax, ymin, ymax])
    xlim([xmin, xmax]);
    ylim([ymin, ymax]);

    pathPlot = plot(obj_pos(1,:),obj_pos(2,:), 'LineWidth', 1, 'Color', 'y');
    pathMark = plot(obj_pos(:,1),obj_pos(:,1), 'bo', 'MarkerFaceColor','y','MarkerSize',10);
    hold off;
 
%{
 ax4 = subplot(6, 2, 2); %text box

 hold on;

     obj_x = plot(deltaTime, objX, 'linewidth', 2, 'Color', 'k');  %draws the graph

     obj_y = plot(deltaTime, objY, 'linewidth', 2, 'Color', 'g');  %draws the graph

        str = {'Inspired by toy robotics kits, this project animates ',... ...
            'a hydraulic arm that can grab and move a ball from ',...
            'an initial position to a final position. The',...
            ['red links are the hydraulic pistons, and the ' ...
            'blue links are the arms'],...
            };
        
        text(0.5, 0.5, str, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 12);
                    
hold off
%}

%% Frame updates for both plots

    timestep = 1/fps; % fps inverted gives seconds per frame
    for i = 2:length(pstPlotLgth)
        pause(timestep) %shows previous frame for timestep length
                
        %sets objects to next position
        set(links,'XData',[x0 link1End(1,i) link2End(1,i)],'YData',[y0 link1End(2,i) link2End(2,i)]);
        set(piston1,'XData',[pst1Grnd pst1End(1,i)],'YData',[0 pst1End(2,i)]);
        set(piston2,'XData',[pst2Start(1,i) pst2End(1,i)],'YData',[pst2Start(2,i) pst2End(2,i)]);

        set(m_object, 'Position', obj_pos(:, i));

        %graphs 
        set(plot1mark, 'XData', deltaTime(i), 'YData', span1(i));
        set(plot2mark, 'XData', deltaTime(i), 'YData', span2(i));
        set(pathMark, 'XData', obj_pos(1,i), 'YData', obj_pos(2,i));

    end %update end

end %function end