% knife(beta1, beta2, beta3, beta4, speed, L, R0)
% animates a cam with a translating knife-edge follower with no offset, where:
%
% beta1, beta2, beta3, and beta4 are the cam rotations for dwells, rise, and fall (see below)
% speed is the angular speed of the cam CCW in rad/s
% L is the lift of the follower in cm
% R0 is the base circle radius of the cam in cm

% The cam and follower are animated for 3 cam rotations.
% Also, the displacement and follower speed are plotted
% versus cam angle (in radians) for one cam rotation. 
% The follower dwells at a height of zero as the cam rotates to
% angle beta1, rises to height L with harmonic motion as the cam rotates
% by beta2, dwells as the cam rotates by beta3, returns to 0 cm with
% cycloidal motion as the cam rotates by beta4, and then dwells for the
% remainder of the cam cycle.

% Your project is to modify this code to replace the
% knife-edge follower with a flat-face follower. The code should output
% R0min, which is the smallest possible base radius for this cam, and
% Wmin, which is the minimum follower width. You can remove the
% plots of follower diplacement and speed since these will not change.

function knife(beta1, beta2, beta3, beta4, speed, L, R0)

%% Error Checks:

% None of the inputs should be negative, so we'll put in an error catch
% that will stop the function if they are. I've decided to use the assert
% command, which takes two arguments: a logical statement, and an error
% that will be thrown if that statement is false

assert((beta1>=0 && beta2>=0 && beta3>=0 && beta4>=0 && L>=0 && R0>=0), ...
    'Angles, Rise, and Base Circle Radius cannot be negative!')

% We also need to make sure that the motions can all occur in one rotation:
assert((sum([beta1 beta2 beta3 beta4]) <= 2*pi), ...
    'Motion must occur in one rotation of the cam')


%% Create essential variables:

% Set stepsize:
stepsize = 0.02;

% The first thing we need to do is set up a nice big vector of the
% displacement and speed at each value of theta. There are a few ways to do
% this, but what I opted for was to create the displacement and speed
% values for each section of movement, and concatenate them together. I
% felt that this method made it easier to see what was happening.

% Initialize variables:
theta = 0:stepsize:2*pi;
y = []; % Follower displacement
s = []; % Speed of follower displacement

% Dwell 1
theta1 = 0:stepsize:beta1-stepsize;

y   = [y   zeros(size(theta1))];
s  = [s  zeros(size(theta1))];

% You'll notice that we went from 0 to beta1-stepsize. This is because,
% when we stack the values of y together, the angle beta1 in dwell 1 is the
% same as the angle 0 in the rising motion. This would result in
% representing that angle twice, and our y, and dy arrays would be too
% long.

% Harmonic Motion (rise)
theta2 = 0:stepsize:beta2-stepsize;

y   = [y   (L/2)*(1-cos(pi*theta2/beta2))];
s  = [s  (L*pi/(2*(beta2))*sin(pi*theta2/beta2))*speed];

% Dwell 2
theta3 = 0:stepsize:beta3-stepsize;

y  = [y L*ones(size(theta3))]; % During this dwell, it'll stay at y-L.
s  = [s zeros(size(theta3))];  % During any dwell, the speed should be 0.

% Cycloidal Motion (fall):
theta4 = 0:stepsize:beta4-stepsize;

y = [y (L - L*theta4/beta4 + (L/(2*pi)) * sin(2*pi*theta4/beta4))];
s = [s (L/beta4)*(cos(2*pi*theta4/beta4)-1)*speed];

% Dwell 3
% Now we want to fill the rest of the vectors y and s with zeros so that
% that they are the same length as theta:
y(length(theta))=0;
s(length(theta))=0;

% Generate the shape of the cam. Basically, value of theta, we will draw
% the contact point at (R0+y), then rotate it theta radians around the
% origin. We'll be animating it in the positive theta (CCW) direction, so
% it makes sense to plot it in the negative theta (CW) direction.

R_c = exp(-1i*theta).*(1i*(R0+y));

%% Animation:

% Initial plot of cam
figure(1)

%Plot the pivot point...
plot(0,0,'ro') 
% ...and don't delete it.
hold on 
% Plot the cam
cam = plot(real(R_c),imag(R_c),'linewidth',2);

% Plot the knife-edge. Generally, you don't want your mechanism to go
% off-screen, but for the follower, it's implied to be attached to
% something, so it makes sense that it does.
follow = patch([-0.05*L -0.05*L 0 0.05*L 0.05*L],[R0+1.5*L R0+y(1)+0.5*L ...
    R0+y(1) R0+y(1)+0.5*L R0+1.5*L],[0.8 0.8 0.8]);

% Always make sure your axes are sensible
axis equal
axis([-R0-1.5*L R0+1.5*L -R0-1.5*L R0+1.5*L])

rotnum = 1; % Rotating 3 times
for a = 1:rotnum % for each rotation
    for b = 1:length(theta) % for each angle
        % Pause a moment
        pause(stepsize/speed)
        
        % Rotate the cam a little, and move the follower
        set(cam,'XData',real(exp(1i*theta(b))*R_c),'YData',imag(exp(1i*theta(b))*R_c));
        set(follow, 'YData',[R0+1.5*L R0+y(b)+0.5*L R0+y(b) R0+y(b)+0.5*L R0+1.5*L]);
    end
end


%% Plot position and speed
figure(2)

subplot(2,1,1)
plot(theta,y)
axis([0 2*pi -0.1*L 1.1*L])
title('Figure 1: Follower Displacement and speed vs. Cam Angle')
ylabel('Displacement')

subplot(2,1,2)
plot(theta,s)
axis([0 2*pi -1.2*max(abs(s)) 1.2*max(abs(s))])
ylabel('Speed')
xlabel('Cam Angle (Radians)')


