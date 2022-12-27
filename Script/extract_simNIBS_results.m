% Extract the below values from the results of the simulation in each
% participant.
% Nodes in individual space, 
%   node areas (mm^2)
%   field values (e.g. normE)
%   coordinates (x,y,z)
%   anatomical area index (ref. HCP_MMP1)
% Nodes in fsaverage space, 
%   node_areas(mm^2)
%   field values (e.g. normE)
%   coordinates (x,y,z)
% Others
%   anatomical area list(ref. HCP_MMP1)
%   simulation identifier (filename of .msh)
%
% Coded by S.Hirose at Aug 11th 2022
%
% function mm = extract_simNIBS_results(subdir,simdir,field)

function mm = extract_simNIBS_results(subdir,simdir,field)

%% get filepath
mshfiles    = dir(fullfile(subdir,simdir,'subject_overlays','*.msh'));
m2mdir      = dir(fullfile(subdir,'m2m_*'));
m2mdir      = fullfile(m2mdir.folder,m2mdir.name);

%% Read the simulation results
for simind = 1:size(mshfiles,1)
    % in individual space    
    mshfile = fullfile(mshfiles(simind).folder,mshfiles(simind).name);
    m = mesh_load_gmsh4(mshfile);
    [m, snames] = subject_atlas(m, m2mdir, 'HCP_MMP1');
    mm(simind).indiv.areas  = mesh_get_node_areas(m); % node areas (mm^2)
    mm(simind).indiv.value  = m.node_data{get_field_idx(m, field, 'node')}.data;
    mm(simind).indiv.xyz    = m.nodes;
    mm(simind).indiv.anat   = m.node_data{end}.data;
    % in fsaverage space
    m = mesh_load_gmsh4(strrep(strrep(mshfile,[filesep 'subject_overlays' filesep],[filesep 'fsavg_overlays' filesep]),'_central.msh','_fsavg.msh'));
    mm(simind).fsave.areas = mesh_get_node_areas(m);
    mm(simind).fsave.value = m.node_data{get_field_idx(m, field, 'node')}.data;
    mm(simind).fsave.xyz = m.nodes;
    % parameters
    mm(simind).param.arealist = snames;
    [~,mm(simind).param.sim_descrip] = fileparts(mshfile);
end
