% This file is provided to give an example of how to animate a mechanism
% using MATLAB.

function P1_Sample(r1,r2,r3,speed)
% Function to animate 3 cycles of a slider-crank mechanism
% r1 is the offset of the slider, which is the (possibly negative) height
%   of the slider pivot above the crank pivot,
% r2 is the length of the crank,
% r3 is the length of the rod connecting the crank with the slider,
% speed is the speed of the crank.

% The function checks if the crank is capable of making a full rotation,
%   and returns an error message otherwise. The function then generates 3 
%   figures:
% Figure 1 animates the mechanism completing 3 crank revolutions at the
%   given speed.
% Figure 2 is a plot of the slider position versus crank angle over a
%   single rotation
% Figure 3 is a plot of the speed of the slider versus crank angle,
%   calculated in 2 different ways:
%     - Numerically, where the speed is determined by looking at the change
%       in position over a single time step
%     - Analytically, where the speed is determined using the derivative of
%       the position equation.

%% Calculate the positions at each increment of crank angle:
% The following equations are used to find the positions of various
% parts of the mechanism:

% In order to animate it, we will basically plot the mechanism at a bunch
% of different positions. We'll define a variable 'astep' that gives the
% angle (in radians) that the crank rotates between each frame of the
% animation:
astep = 0.02; 

% Since we want to animate it over the course of three rotations, we'll
% make a list 'theta' that contains all of the angles between 0 and 6 pi,
% increased by 'astep' each time.
theta=0:astep:6*pi; 
% This way, when we calculate things like the x position of the crank tip,
% we can simply say x2 = r2*cos(theta), and it will calculate all of the
% values of x2 over three rotations.

x2 = r2*cos(theta); % x coordinate of crank tip
y2 = r2*sin(theta); % y coordinate of crank tip
r4 = x2+sqrt(r3^2-(y2-r1).^2); % x position of slider

%% Check that the system can be assembled
if  r3<r2+abs(r1) % If the crank can't move, throw an error message:
    disp 'The crank cannot rotate: a connecting rod is too short.'
else    % If the crank can move, animate the rest of the system:
    
    %% Animate the System:
    % Now we will make the initial plot of the system:
    figure(1)
    
    % The crank and connecting bar are animated using the plot function.
    % Note that we used r4(1), since that will be the position of that bar
    % in the first position in "theta".
    mech = plot([0 r2 r4(1)],[0 0 r1],'-o','linewidth',2);
    
    % The 'hold' command prevents the crank from being erased when we plot
    % the slider and ground
    hold on
    
    % Create a slider using rectangle ('Position',[x y w h])
    slider = rectangle('Position',[r4(1)-0.1*r3 r1-0.1*r3 0.2*r3 0.2*r3],'linewidth',2);

    % Because the ground is made up of only one line (not two, like
    % 'mech'), we can make it using the 'line' function
    ground = line([0 r2+r3],[r1-0.1*r3 r1-0.1*r3],'linewidth',2,'color','r');
    hold off
    
    % Give the plot a title:
    title('Fig.1: Animation of Slider Crank Mechanism')
    
    % "axis equal" will make sure the x and y axes have the same scale.
    % This is important, since if they don't, your mechanism will appear to
    % stretch and shrink as it rotates.
    axis equal
    
    % Set the axes to accomodate any link lengths and offsets:
    axis([-1.1*r2 r2+1.1*r3 min([r1 -r2])-0.2*r3 max([r1 r2])+0.2*r3])
    
    timestep = astep/speed; % The pause between frames is time step = astep/speed
    
    % Update the animation
    for n = 2:length(theta)
        pause(timestep)

        % Set the new slider and mechanism positions. Notice that we are
        % using the 'set' command to change the positions of the graphics
        % objects. This is much more efficient than erasing them and
        % redrawing them for every frame of the animation.
        set(slider,'Position',[r4(n)-0.1*r3 r1-0.1*r3 0.2*r3 0.2*r3])
        set(mech,'XData',[0 x2(n) r4(n)],'YData',[0 y2(n) r1])
    end
    
    %% Plot slider positions versus crank angle
    figure(2)
    % We only want one rotation, so we make a new vector for the positions
    % from 0 to 2*pi:
    th2 = 0:astep:2*pi;
    
    % And then we plot it:
    plot(th2,r4(1:length(th2)))
    title('Fig.2 Slider Positions vs Crank Angle')
    xlabel('Crank Angle [rad]')
    ylabel('Slider Position')
    
    %% Plot slider speeds versus crank angle
    figure(3)
    
    % Slider speed calculated numerically from position sequence:
    r4dot_num = diff(r4(1:length(th2)+1))/timestep;
    
    % Exact slider speed found analytically:
    r4dot_ana = (-r2*sin(th2)-r2*cos(th2).*(r2*sin(th2)-r1)./sqrt(r3^2-(r2*sin(th2)-r1).^2))*speed;
    
    % Numerical solution
    subplot(2,1,1)
    plot(th2,r4dot_num)
    title('Fig.3 Slider Speeds vs Crank Angle')
    xlabel('Crank Angle [rad]')
    ylabel('Slider Speed (numerical)')
    
    % Analytical solution
    subplot(2,1,2)
    plot(th2,r4dot_ana,'color','r')
    xlabel('Crank Angle [rad]')
    ylabel('Slider Speed (analytical)')
    
end % of else statement

P1_Sample(2,3,6,10);