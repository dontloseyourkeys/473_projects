%% calls functions

%% P1A---------------------------------------------------------------
disp('testing P1a...');


disp('test a1: function call using example video parameters');
P1a_AugustBeard_EthanHall(10, 8, 20, 1) %function call using example video parameters, 

disp('test a2');
P1a_AugustBeard_EthanHall(3,6,10,2) %function call for valid inverted double crank link lengths

disp('test a3');
P1a_AugustBeard_EthanHall(5,3,2,2) %function call for invalid geometry of link lengths

disp('changepoint edge case')
P1a_AugustBeard_EthanHall(4, 4, 8, 2); %this edge case says that it can't 

disp('changepoint, crank rocker')
P1a_AugustBeard_EthanHall(4.1, 4, 9, 2);

disp('changepoint, double crank')
P1a_AugustBeard_EthanHall(4, 4.1, 9, 2);



%% P1B---------------------------------------------------------------
disp('testing P1b...');
disp('test b1: video parameters');
P1b_AugustBeard_EthanHall(5,4,13,6,10,1) %tests with example's numbers

disp('test b2: working double crank quick plane mechanism');
P1b_AugustBeard_EthanHall(3, 5, 10, 15, 4, 2);


disp('test b3: invalid geometry of r1, r2, r3, crank cant rotate');
P1b_AugustBeard_EthanHall(5,3,2,5, 6, 2) %function call for invalid geometry of link lengths due to r2, r3

disp('test b4: invalid geometry of r4, r5, not assemblable');
P1b_AugustBeard_EthanHall(3,6,10, 5, 6, 2) %function call for double crank 

disp('test b5: invalid animation- changepoint'); %changepoint
P1b_AugustBeard_EthanHall(4, 4, 8, 5, 4, 2);
