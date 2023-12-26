planner_session_dir = 'K:\data\project_data\mfMRI_scene';
planner_name = 'PlannerSession_MaoDan_231221_231226_1324_use_12222141_markers.mat';
planner_name_modified = 'test.mat';

planner_fname = fullfile(planner_session_dir, planner_name);

g_strctModule = load(planner_fname).('g_strctModule');

anat_vols = g_strctModule.m_acAnatVol; 


src_targets_idx = 1;
fprintf('\nsrc_targets %d name is %s\n', src_targets_idx, anat_vols{src_targets_idx}.m_strName);

dst_targets_idx = 3; 
fprintf('\ndst_targets %d name is %s\n', dst_targets_idx, anat_vols{dst_targets_idx}.m_strName);


g_strctModule.m_acAnatVol{dst_targets_idx}.m_astrctTargets = anat_vols{src_targets_idx}.m_astrctTargets; 
disp(g_strctModule.m_acAnatVol{dst_targets_idx}.m_astrctTargets); 

save(fullfile(planner_session_dir, planner_name_modified), 'g_strctModule'); 
disp('saved'); 

