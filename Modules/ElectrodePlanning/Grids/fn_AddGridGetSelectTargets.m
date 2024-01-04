function [pt3f_selectTargets_XYZ] = fn_AddGridGetSelectTargets(g_strctModule)

iSelectedTargets = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
if length(iSelectedTargets) ~= 2
    return;
end

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;

pt3f_selectTargets_XYZ = zeros(3, 2); 
for idxTarget = 1:2
    iSelectedTarget = iSelectedTargets(idxTarget);
    
    if ~isempty(iSelectedTarget) && iSelectedTarget > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctTargets')
    
        
        pt3fPos = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iSelectedTarget).m_pt3fPositionVoxel;
        pt3fPosMM = a2fCRS_To_XYZ*[pt3fPos;1];
        pt3f_selectTarget = pt3fPosMM(1:3); 
        pt3f_selectTargets_XYZ(:, idxTarget) = pt3f_selectTarget;

    end
end

return;
