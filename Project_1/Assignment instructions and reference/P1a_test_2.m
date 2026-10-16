function P1a_test(r1,r2,r3,speed) %= [outputs]?


%script i made bc i broke the last one RIP



%}

%%hardcoded variables
num_rotations = 10; %sets number of full rotations to be animated



%creating frames for animation 
astep = 0.02; %defines angle in rad r2 rotates per frame
theta = 0:astep:num_rotations*2*pi; %start:step:end notation, 0-3 full rotations, in steps of size astep

length(theta)
%}

%{
variable legend: 


given by instructions: 
r1 = length of fixed horizontal ground link
r2: crank length
r3: rocker length
speed, crank speed in rad/s

There should be no offset (r1 is horisontal)


theta: the angle of rotation of crank arm in rad

%}

%r1: offset between 0 and y position of sliding collar

%p1: pin 1, fixed to origin/ground
x1 = 0; y1 = 0; % p1 values broken and changing????

%r2: span between p1 and p2, is rotating arm
x2 = r2 * cos(theta); %x coord of crank tip p2
y2 = r2 * sin(theta); %y coord of crank tip p2




%%trying to plot the figure

figure(1) %makes the empty figure




%issue with range of x1
    
%slider = rectangle('Position',[r4(1)-0.1*r3 r1-0.1*r3 0.2*r3 0.2*r3],'linewidth',2);
crank = plot([0 0],[0 r2],'-o','linewidth',2);
%line([x1, x2], [y1, y2], 'Color', 'r', 'LineWidth', 2);

hold on
hold off


title('Fig.1: Animation of Slider Crank Mechanism')
axis equal


timestep = astep/speed; 

fprintf('x1: %.2f, y1: %.2f | x2: %.2f, y2: %.2f | theta: %.2f\n', x1, y1, x2, y2, theta); %debug print

    
    for n = 2:length(theta)
        pause(timestep)
    
        set(crank,'XData',[0 x2(n) r2],'YData',[0 y2(n) r2])
        
    end


%{
P1a_AugustBeard_EthanHall(1,3,5,2); %function call for valid link lengths
%}

%P1a_test(1,3,5,2); %function call for invalid link lengths

end
