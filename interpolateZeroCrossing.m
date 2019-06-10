% This functions takes phases, dt, sampling from the Kuramoto generator as
% input. In addition, it allows for discarding parts of the data.
function [P1ITI, P2ITI, onsetsTimeP1, onsetsTimeP2]=interpolateZeroCrossing(Phases, dt, sampling, discard)


resolution=dt*sampling;

OPp1=Phases(2,:);
OPp2=Phases(3,:);

% radians to degrees
degOPp1=rad2deg(OPp1);
degOPp2=rad2deg(OPp2);

% force it into 1-360
modOPp1=mod(degOPp1, 360);
modOPp2=mod(degOPp2, 360);

timevector=resolution:resolution:(resolution*length(modOPp1));
% find crossing points
onsetLocP1=[false];
for n=2:length(modOPp1)
    if modOPp1(n-1)>modOPp1(n)
        onsetLocP1(n)=true;
    else
        onsetLocP1(n)=false;
    end 
end
onsetLocP2=[false];
for n=2:length(modOPp2)
    if modOPp2(n-1)>modOPp2(n)
        onsetLocP2(n)=true;
    else
        onsetLocP2(n)=false;
    end 
end

% Linearly interpolate the actual zero-crossing point

crossedP1=find(onsetLocP1==1);
onsetsTimeP1=[];
for n=1:length(crossedP1)
    pastPhase=modOPp1(crossedP1(n));
    prePhase=modOPp1(crossedP1(n)-1);
    pastTime=timevector(crossedP1(n));
    preTime=timevector(crossedP1(n)-1);
    
    
    phaseSteps=pastPhase+(360-prePhase);
    timeSteps=resolution/phaseSteps;
    timeAdd=(360-prePhase)*timeSteps;
    
    onsetsTimeP1(n)=pastTime+timeAdd;
    
end

crossedP2=find(onsetLocP2==1);
onsetsTimeP2=[];
for n=1:length(crossedP2)
    pastPhase=modOPp2(crossedP2(n));
    prePhase=modOPp2(crossedP2(n)-1);
    pastTime=timevector(crossedP2(n));
    preTime=timevector(crossedP2(n)-1);
    
    
    phaseSteps=pastPhase+(360-prePhase);
    timeSteps=resolution/phaseSteps;
    timeAdd=(360-prePhase)*timeSteps;
    
    onsetsTimeP2(n)=pastTime+timeAdd;  
end

P1ITI=diff(onsetsTimeP1);
P2ITI=diff(onsetsTimeP2);

if discard ~= 0
    P1ITI=P1ITI(discard:end);
    P2ITI=P2ITI(discard:end);
    onsetsTimeP1=onsetsTimeP1(discard:end);
    onsetsTimeP2=onsetsTimeP2(discard:end);
end

return

