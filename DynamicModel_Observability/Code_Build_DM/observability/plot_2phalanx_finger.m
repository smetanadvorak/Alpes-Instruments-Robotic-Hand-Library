% TASK: plot the 2 phalanx finger 
% INPUT
%   joint_coordinates: vector of the relative joint coordinates [q1,q2]


% TEST: joint_coordinates = [pi/2,3*pi/2]
function plot_2phalanx_finger (joint_coordinates)
    L1 = 0.03;
    L2 = 0.02;
    L3 = 0.024;
    
    if isempty(joint_coordinates)
        sprintf('No critical configurations. \n')
        return
    end
    
    joint_coordinates(1) = wrapToPi(joint_coordinates(1));
    joint_coordinates(2) = wrapToPi(joint_coordinates(2));
    figure
    plot(0, 0,'Marker','.','Color','r', 'MarkerSize',20);
    hold on
    plot([0, L1*cos(joint_coordinates(1))], [0, L1*sin(joint_coordinates(1))],'Color','r');
    hold on
    plot(L1*cos(joint_coordinates(1)), L1*sin(joint_coordinates(1)),'Marker','.','Color','r', 'MarkerSize',20);
    hold on
    plot([L1*cos(joint_coordinates(1)), L1*cos(joint_coordinates(1))+L2*cos(joint_coordinates(1) + joint_coordinates(2))],...
            [L1*sin(joint_coordinates(1)), L1*sin(joint_coordinates(1))+L2*sin(joint_coordinates(1) + joint_coordinates(2))],'Color','r');
    hold on
    plot(L1*cos(joint_coordinates(1))+ L2*cos(joint_coordinates(1) + joint_coordinates(2)),...
            L1*sin(joint_coordinates(1))+L2*sin(joint_coordinates(1) + joint_coordinates(2)),'Marker','.','Color','r', 'MarkerSize',20);
    hold on
    plot([L1*cos(joint_coordinates(1))+L2*cos(joint_coordinates(1)+joint_coordinates(2)),...
                L1*cos(joint_coordinates(1))+L2*cos(joint_coordinates(1)+joint_coordinates(2))+...
                    L3*cos(joint_coordinates(1)+joint_coordinates(2)+joint_coordinates(3))],...
         [L1*sin(joint_coordinates(1))+L2*sin(joint_coordinates(1) + joint_coordinates(2)),...
                L1*sin(joint_coordinates(1))+L2*sin(joint_coordinates(1)+joint_coordinates(2))+...
                    L3*sin(joint_coordinates(1)+joint_coordinates(2)+joint_coordinates(3))],'Color','r');
    hold on
    plot(L1*cos(joint_coordinates(1))+ L2*cos(joint_coordinates(1) + joint_coordinates(2))+...
            L3*cos(joint_coordinates(1)+joint_coordinates(2)+joint_coordinates(3)),...
         L1*sin(joint_coordinates(1))+L2*sin(joint_coordinates(1) + joint_coordinates(2))+...
            L3*sin(joint_coordinates(1)+joint_coordinates(2)+joint_coordinates(3)),'Marker','.','Color','r', 'MarkerSize',20);
    
    xlabel('X');
    ylabel('Z');
    axis equal
    title('Critical configuration of the 2 phalanx finger');
end
