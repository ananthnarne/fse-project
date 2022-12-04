connect.SetColorMode(4, 2); %port 4, color code
setScan(true);
setSeen(false);

while 1
    touch = connect.TouchPressed(2);
    distance = connect.UltrasonicDist(1);
    moveForward(connect, 50);
    color = connect.ColorCode(4);

    if touch == 1
        stop(connect);
        moveBack(connect);
        if distance > 100
            disp("turning to hallway");
            turn(connect, 'A'); % turn right
        else
            disp("turning left");
            turn(connect, 'D'); % turn left
        end
    end

    if color == 1
        setSeen(false);
        disp("seeing black")
    end

    if color == 5
        disp('stopping for red');
        setScan(false);
        stop(connect);
        pause(0.7);
        moveForward(connect, 50);
        pause(0.5);
	    setScan(true);
    end
    if color == 2
        setScan(false); % turn distance scan off
        if ~getSeen()
            disp('stopping for zone');
            setSeen(true);
            stop(connect);
            pause(3);
            % scan stuff
            moveForward(connect, 50);
            pause(0.5);
            setScan(true); % turn distance scan on
        end
    end
    if color == 3
        setScan(false); % turn distance scan off
        if ~getSeen()
            setSeen(true);
            disp('stopping for zone');
            stop(connect);
            pause(3);
            % scan stuff
            moveForward(connect, 50);
            pause(0.5);
            setScan(true); % turn distance scan on
        end
    end

    if getScan() == true
        if distance > 60
            disp(distance);
            disp("SEEING");
            setScan(false);
            stop(connect);
            pause(0.5);
            turn(connect, 'A'); % turn left
            % scan stuff
	        moveForward(connect, 50);
	        pause(2.5);
            disp("scanning again");
	        setScan(true); % turn distance scan on
        end
    end
end

% stops both motors
function stop(connect)
    connect.StopMotor('A');
    connect.StopMotor('D');
end

% moves the motors backwards
function moveBack(connect)
    connect.MoveMotor('A', -50);
    connect.MoveMotor('D', -50*0.93);
    pause(1);
    stop(connect);
end

% moves the motors back but only a little
function moveBackALittle(connect)
    connect.MoveMotor('A', -50);
    connect.MoveMotor('D', -50*0.93);
    pause(0.3);
    stop(connect);
end

% turns the robot either left or right depending on what is passed into the motor variable
function turn(connect, motor)
    moveBackALittle(connect);
    turningLeft = motor == 'D';
    a_speed = 50;
    d_speed = -50;
    if turningLeft 
        a_speed = -50;
        d_speed = 50;
    end
    
    connect.MoveMotor('A', a_speed);
    connect.MoveMotor('D', d_speed*0.93);
    pause(0.75);
    stop(connect);
end

% moves the robot forward
function moveForward(connect, speed)
    connect.MoveMotor('A', speed);
    connect.MoveMotor('D', speed*0.93);
end

% sets the scan for distance variable to either true or false
function setScan(val)
    global scan;
    scan = val;
end

% gets the value of the scan variable
function s = getScan()
    global scan;
    s = scan;
end

% gets the value of the seen variable
% the seen variable is what is used to tell if the robot has seen a color (red or blue) before
function s = getSeen()
    global seen;
    s = seen;
end

% this sets the seen variable
function setSeen(val)
    global seen;
    seen = val;
end
