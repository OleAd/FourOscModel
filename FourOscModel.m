%% Modelling of interpersonal synchronization using coupled oscillators
% This script contains an example of using coupled oscillators for
% modelling interpersonal synchronization.
% 
% This particular example aims to simulate tapping at a rate of 2 Hz.
% 
% 
% Connectivity matrix:
% Osc1 is participant 1's internal oscillator
% Osc2 is participant 1's producing oscillator
% Osc3 is participant 2's producing oscillator
% Osc4 is participant 2's internal oscillator
%       1   2   3   4
%   1   0   x1  y1  0
%   2   x1  0   0   0 
%   3   0   0   0   x2
%   4   0   y2  x2  0
% 
% 
% 
% Ole Adrian Heggli, 2018, ole.heggli@clin.au.dk
% 
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Setting up the model
% These remains constant for all coupling strengths

N=4;                                % Four oscillators 
D=zeros(N);                         % In the current approach there's no delays
f_dist=ones(N,1);                   % This vector specify distribution of intrinsic frequencies, in this case all are equal
dt=25e-3;                           % Integration step
sampling=20;                        % Downsampling
k=1;                                % Coupling, global K. Technically, this is not in use anymore. 
t_max=12;                           % Time of simulatiom
frequency_mean=2;                   % Mean of oscillator frequencies
f_std=.2;                           % Std of oscillator frequencies. Not sure what we should argue here.
msNoise=20;                         % Noise, in ms.
currNoise=msNoise*(2*pi/500);       % Noise


%

%% Running the model

% Initiate a figure, and some variables
figure;
collLags=[];

numSims=10; % Define how many simulations

% Define the connectivity matrix
x1=.2;
x2=.2;
y1=8;
y2=8;

C=[0 x1 y1 0; x1 0 0 0; 0 0 0 x2; 0 y2 x2 0];   % Connectivity matrix

% Start simulation loop

for n=1:numSims
    onsetOPp1=[];
    onsetOPp2=[];
    % Generate the phases
    [Phases] = Kuramoto_calculations(C,D,frequency_mean,f_std,f_dist,...
                            t_max,dt,sampling,currNoise);
    % Only consider the two output oscillators
    OPp1=Phases(2,:);
    OPp2=Phases(3,:);
    % Discard the first 4 occurances, as this is the "metronome count-in"
    OPp1=OPp1(5:end);
    OPp2=OPp2(5:end);
    % Calculate onset times in seconds (or milliseconds)
    degOPp1=radtodeg(OPp1);
    degOPp2=radtodeg(OPp2);
    onsetOPp1=degOPp1*(500/360);
    onsetOPp2=degOPp2*(500/360);
    % Calculate intertap interval (ITI)
    P1ITI=diff(onsetOPp1);
    P2ITI=diff(onsetOPp2);
    % Calculate and collect cross-correlations
    thisLags=crosscorr(P1ITI, P2ITI, 1);
    collLags=[collLags;thisLags];
    
    % Plot the first simulation
    if n==1
        subplot(1,2,1)
        plot(1:length(P1ITI), P1ITI, 'b');
        hold on
        plot(1:length(P2ITI), P2ITI, 'r');
        axis([0 t_max*2 min(min(P1ITI), min(P2ITI))-50 max(max(P1ITI), max(P2ITI))+50])
    end
    
end

% Calculate the mean lags, and standard error.
meanLags=mean(collLags);
semp1=std(collLags(:,1))/sqrt(length(collLags(:,1)));
sem0=std(collLags(:,2))/sqrt(length(collLags(:,2)));
semn1=std(collLags(:,3))/sqrt(length(collLags(:,3)));
err=[semn1, sem0, semp1];

% Plot the lag pattern
subplot(1,2,2)
bar(meanLags);
hold on
errorbar(1:3, meanLags, err, 'o')
axis([0 4 -.5 .5]);

% 




















