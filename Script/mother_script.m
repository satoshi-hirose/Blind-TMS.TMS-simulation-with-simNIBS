% Before running this script,complete "headreco all" for all participants.
% Make sure that simNIBS/matlab is in MATLAB path list
% see Readme.txt for detailed instruction.


%% parameters 

% directories
analysisdir = '../Analyze/'; % absolute path or relative path from Script directory
simdirname = 'TMS_simulation'; % directory name of the simulation 

% maximum stimulator output (dI/dt)
stim_max = 62.8*10^6; 

% the distance (mm) between Inion and center of the TMS coil on the surface of the skin 
% Note: TMS position is on the Inion-Cz-Nasion circular arc and is above the Inion.
tms_pos_from_Inion = 25; 

% Participants' ID ([Number of participants] x 1)
% subnames = {'1';'2';'4';'6';'7';'8';'10';'11';'16';'18';'19';'21';'22';'23';'24'};
subnames = {'2';'6';'7';'11';'19';'21';'23';'24'}; % for test

% Angles of the stimulator (degree)
% 0 = handle direction towards Cz. increase with anticlockwise rotation)
% [Number of participants] x [Number of simulation per perticipant]
angles = [45,55;60,60;45,45;45,45;50,50;50,45;50,45;65,55;45,50;45,40;45,45;50,50;60,55;50,45;55,50;45,45;55,55;50,55];

% Stimulus intensity for each participant in % (100 % = maximum stimulator output)
% [Number of participants] x 1
stim_percents = [80; 75; 90; 85; 70; 65; 100; 75; 90; 85; 80; 70; 100; 95; 85; 80; 60; 75];

mkdir ../Results
save ../Results/Parameters


%% prepare parameters for simulation for each participant (simNIBS)
for sub = 1:length(subnames)
    SIM_PARAM{sub}                      = sim_struct('SESSION');
    SIM_PARAM{sub}.fnamehead            = fullfile(analysisdir,subnames{sub},[subnames{sub},'.msh']);
    SIM_PARAM{sub}.pathfem              = fullfile(analysisdir,subnames{sub},simdirname);
    SIM_PARAM{sub}.fields               = 'e';
    SIM_PARAM{sub}.map_to_vol           = true;
    SIM_PARAM{sub}.map_to_MNI           = true;
    SIM_PARAM{sub}.map_to_fsavg         = true;
    SIM_PARAM{sub}.map_to_surf          = true;
    SIM_PARAM{sub}.poslist{1}           = sim_struct('TMSLIST');
    SIM_PARAM{sub}.poslist{1}.fnamecoil = fullfile(SIMNIBSDIR,'ccd-files','Magstim_70mm_Fig8.nii.gz');    % Modify if use a different coil
    [TMS_pos,angle_pos]                 = get_TMS_pos(fullfile(analysisdir,subnames{sub},['m2m_' subnames{sub}],'eeg_positions','EEG10-10_UI_Jurak_2007.csv'),tms_pos_from_Inion,angles(sub,:));
    % Angle and TMS position coordinates is calculated from m2m file, eeg position file, TMS position (distance from Inion), and angle of the TMS coil in degree.
    for i = 1:size(angle_pos,2)
        SIM_PARAM{sub}.poslist{1}.pos(i).centre = TMS_pos';
        SIM_PARAM{sub}.poslist{1}.pos(i).pos_ydir = angle_pos(:,i)';
        SIM_PARAM{sub}.poslist{1}.pos(i).didt = stim_percents(sub)/100*stim_max;
    end
end

save ../Results/SimulationParameters SIM_PARAM

%% run simulation for each participant
for sub=1:length(subnames)
    run_simnibs(SIM_PARAM{sub})
end

%% Combine the results
for sub=1:length(subnames)
    RESULTS{sub} = extract_simNIBS_results(fullfile(analysisdir,subnames{sub}),simdirname,'normE');
end
save ../Results/IndividualResults RESULTS

return
%% Group Analysis
group_analysis
