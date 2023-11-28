function  fn_ApplyFuncTransfToAll_WL()

global g_strctModule
if g_strctModule.m_iCurrFuncVol == 0
    return;
end;
[strFile, strPath] = uigetfile([g_strctModule.m_strDefaultFilesFolder,'*.reg'],'Select transformation file');
if strFile(1) == 0
    return;
end;
a2fTrans = fnReadRegisteration([strPath, strFile]);

% g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg = ...
%     inv(a2fTrans) * g_strctModule.m_acFuncVol{g_strctModule.m_iCurrFuncVol}.m_a2fReg;%#ok

n_func_vols = length(g_strctModule.m_acFuncVol); 

for i_vol = 1:n_func_vols
    g_strctModule.m_acFuncVol{i_vol}.m_a2fReg = ...
    inv(a2fTrans) * g_strctModule.m_acFuncVol{i_vol}.m_a2fReg;%#ok
end

fprintf('\n applied func transform to all %d FuncVols \n');


fnInvalidate(1);

return;