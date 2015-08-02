function testglobals()
global balleklorin = 5;

result = mysub(balleklorin);
printf('Result = %d\n', result);

function [balleklorin] = mysub(multiplier)
global balleklorin;
balleklorin = balleklorin * multiplier;
