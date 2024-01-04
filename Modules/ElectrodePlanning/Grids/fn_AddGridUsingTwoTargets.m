function fn_AddGridUsingTwoTargets()
global g_strctModule 
% fnChangeMouseMode('ConfirmSelectInList', 'comfirm select target in the list');
% g_strctModule.m_hClickCallback = @fn_AddGridGetSelectTargets;
% 
% strctStartPoint = g_strctModule.m_strctSavedClickedPoint;
% strctStartPoint.m_pt2fPos = g_strctModule.tmp.pt3f_selectTarget_XYZ;
% 
% 
% fnChangeMouseMode('ConfirmSelectInList', 'comfirm select target in the list');
% g_strctModule.m_hClickCallback = @fn_AddGridGetSelectTargets;
% 
% strctEndPoint = g_strctModule.m_strctSavedClickedPoint;
% strctEndPoint.m_pt2fPos = g_strctModule.tmp.pt3f_selectTarget_XYZ;
% 
% 
% strctStartPoint
% strctEndPoint

fnChangeMouseMode('ConfirmSelectInList', 'comfirm select target in the list');
g_strctModule.m_hClickCallback = @fn_AddGridUsingTwoTargetsAux;

return;