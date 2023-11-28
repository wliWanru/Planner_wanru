function fn_LoadMultiFuncVol_WL()
global g_strctModule

strStartPath = g_strctModule.m_strDefaultFilesFolder;
folders = uigetfile_n_dir_WL(strStartPath, 'Select Folders Containing .nii Files');

% Check if the operation was cancelled
if isempty(folders)
    return;
end

strInputRegfile = 'Missing';

% Loop through each selected folder
for iFolder = 1:length(folders)
    strFolderPath = folders{iFolder}; % Current folder path
    strInputVolfile_full = fullfile(strFolderPath, 'sig.nii'); % Construct the full path to the .nii file

    % Check if the .nii file exists in the folder
    if ~exist(strInputVolfile_full, 'file')
        fprintf('The file %s does not exist. Skipping this folder.\n', strInputVolfile_full);
    end

    % If file exists, load the .nii file
    strctVol = MRIread(strInputVolfile_full);

    if size(strctVol.vol,4) > 1 
        strAnswer= questdlg('You cannot load a 4D volumes (time series) into planner (usually you overlay 3D statistical maps). Do you want to take just the first time frame instead?','Important Question','Yes','No (Cancel)','No (Cancel)');
        if ~strcmpi(strAnswer,'Yes')
            return;
        end;
        strctVol.vol = strctVol.vol(:,:,:,1);
    end
    
    % -- using folder name instead --
    [strTmp, str_nii_fname, ~] = fileparts(strInputVolfile_full); 
    [~, i_folder_name, ~] = fileparts(strTmp);
    
    disp([i_folder_name, '-', str_nii_fname])

    strctFuncVol.m_strName = [i_folder_name, '-', str_nii_fname];
    strctFuncVol.m_strFileName = strInputVolfile_full; 
    strctFuncVol.m_strRegisterationFileName = strInputRegfile;
    strctFuncVol.m_afVoxelSpacing = strctVol.volres;
    strctFuncVol.m_aiVolSize = size(strctVol.vol);
    strctFuncVol.m_a3fVol = strctVol.vol;

    a2fM=strctVol.tkrvox2ras;

    strctFuncVol.m_a2fM = a2fM;

    strctFuncVol.m_a2fReg = eye(4);
    %strctFuncVol.m_a2fRegVoxelSpacing = strctFuncVol.m_afVoxelSpacing;
    strctFuncVol.m_strctFreeSurfer = rmfield(strctVol,'vol');
    iNumFuncVols = length(g_strctModule.m_acFuncVol);
    g_strctModule.m_iCurrFuncVol = iNumFuncVols+1;
    g_strctModule.m_acFuncVol{iNumFuncVols+1} = strctFuncVol;

    fnUpdateFunctionalsList();

    if ~g_strctModule.m_bFuncVolLoaded
        g_strctModule.m_bFuncVolLoaded  = true;
    end;
    fnInvalidate(true);
end

return;

