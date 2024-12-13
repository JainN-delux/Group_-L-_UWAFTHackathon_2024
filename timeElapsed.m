function newArray = timeElapsed(datetime_array)
    % This function converts an array of elements in datetime format
    % into the total elapsed time in seconds since the first data point was
    % acquired
    %
    % To find out more about datetime formats and arrays try the command:
    %
    %   >> doc datetime
    %
    % Copyright 2018 The MathWorks, Inc
    
    newArray = second(datetime_array);
    arraySize = numel(newArray); % Number of elements in the array
    first = newArray(1);
    i = 1;
    
    % The following loop will run until it reaches the end of the array.
    % Whenever the next number is smaller than the current number the loop will
    % add 60 seconds and then start at the begining of the array again.
    while i < arraySize
        if newArray(i) > newArray(i+1)
            newArray(i+1) = newArray(i+1) +60;
            i = 1;
        end
        i = i+1;
    end
    
    % Subtract the first number to all elements of the array in order to start
    % the array at 0.
        newArray = newArray - first;  
end

% Load our data and setup up some variables from the data
clear
load('ExampleData.mat');
lat=Position.latitude;
lon=Position.longitude;
positionDatetime=Position.Timestamp;
Xacc = Acceleration.X;
Yacc = Acceleration.Y;
Zacc = Acceleration.Z;
accelDatetime=Acceleration.Timestamp;
% We use the following to obtain linear time data in seconds from a datetime array
positionTime=timeElapsed(positionDatetime);
accelTime=timeElapsed(accelDatetime);

% Store the circumference of the earth in miles and create a variable to
% store our total distance
earthCirc = 24901;
totaldis = 0;

% Set stride as constant variable
stride = 2.5; % Average stride (ft)

% Loop over the data, store it in our distance array while summing up the distance
distanceArray = [];
for i = 1:(length(lat)-1)
    lat1 = lat(i); % The first latitude
    lat2 = lat(i+1); % The second latitude
    lon1 = lon(i); % The first longitude
    lon2 = lon(i+1); % The second longitude

    degDis = distance(lat1, lon1, lat2, lon2);
    dis = (degDis/360)*earthCirc;
    distanceArray(i) = totaldis;

    totaldis = totaldis + dis;
end

% Calculate steps based off stride
totaldis_ft = totaldis*5280; % Converting distance from miles to feet
steps = totaldis_ft/stride;

% Print out our distance and steps to the command window
disp(['The total distance traveled is: ', num2str(totaldis),' miles'])
disp(['You took ', num2str(steps) ' steps'])

% Create a plot with our distance
plot(distanceArray);
legend('Distance');
xlabel('Time (s)')
ylabel('Distance');
title('Distance Data Vs. Time');
hold off
