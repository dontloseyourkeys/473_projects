%% Fourbar Linkage Test Suite
% Runs each possible classification case in order with speed = 2, n = 1, theta = 0
%% disclaimer: I generated these tests w chatgpt but also its not the assignment its for testing

close all;
clc;


%% Case 1: Unassembleable Linkages (Fails Triangle Inequality)
fprintf('--- TEST 1: Unassembleable Linkage ---\n');
fourbar_Beard_Hall(10, 2, 3, 4, 0, 2, 1);


%% Case 2: Grashof Double-Crank (r1 is shortest)
% Shortest + Longest < Sum of Others (1 + 4 < 2 + 3) -> 5 < 5 is False, so let's use [3, 2, 3, 3] -> 2+3 < 3+3 (5 < 6)
fprintf('--- TEST 2: Double-Crank (r1 shortest) ---\n');
fourbar_Beard_Hall(2, 3, 3, 3, 0, 2, 1);


%% Case 3: Grashof Crank-Rocker with r2 as Crank (r2 is shortest)
fprintf('--- TEST 3: Crank-Rocker (r2 shortest) ---\n');
fourbar_Beard_Hall(4, 2, 4, 3, 0, 2, 1);

%% Case 4: Grashof Double Rocker (r3 is shortest - non-animatable)
fprintf('--- TEST 4: Double Rocker (r3 shortest) ---\n');
fourbar_Beard_Hall(4, 3, 2, 4, 0, 2, 1);

%% Case 5: Grashof Crank-Rocker with r4 as Crank (r4 is shortest - non-animatable)
fprintf('--- TEST 5: Crank-Rocker with r4 Crank (r4 shortest) ---\n');
fourbar_Beard_Hall(4, 3, 4, 2, 0, 2, 1);

%% Case 6: Change-Point Mechanism (S + L == P + Q)
fprintf('--- TEST 6: Change Point Mechanism ---\n');
fourbar_Beard_Hall(1, 2, 3, 2, 0, 2, 1);

%% Case 7: Non-Grashof Triple Rocker (S + L > P + Q)
fprintf('--- TEST 7: Triple Rocker ---\n');
fourbar_Beard_Hall(3, 3, 3, 2, 0, 2, 1);

