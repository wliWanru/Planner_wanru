function [pt3f_selectTarget_XYZ] = fn_AddGridGetSelectSingleTarget(g_strctModule)

iSelectedTarget = get(g_strctModule.m_strctPanel.m_hTargetList,'value');
if length(iSelectedTarget) ~= 1
    return;
end

a2fCRS_To_XYZ = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fReg*g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_a2fM;


if ~isempty(iSelectedTarget) && iSelectedTarget > 0 && isfield(g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol},'m_astrctTargets')

    pt3fPos = g_strctModule.m_acAnatVol{g_strctModule.m_iCurrAnatVol}.m_astrctTargets(iSelectedTarget).m_pt3fPositionVoxel;
    pt3fPosMM = a2fCRS_To_XYZ*[pt3fPos;1];
    pt3f_selectTarget = pt3fPosMM(1:3);
    pt3f_selectTarget_XYZ = pt3f_selectTarget;

end


return;
