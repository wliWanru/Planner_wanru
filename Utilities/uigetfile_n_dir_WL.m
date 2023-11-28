function [pathname] = uigetfile_n_dir_WL(start_path, dialog_title)

% -- this is from https://ww2.mathworks.cn/matlabcentral/fileexchange/32555-uigetfile_n_dir-select-multiple-files-and-directories
% -- but revised by Wanru Li, to make it possible to input a directory directly

% Pick multiple directories and/or files

import javax.swing.JFileChooser;
import javax.swing.JPanel;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.Box;

jchooser = javaObjectEDT('javax.swing.JFileChooser', start_path);
jchooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);

% Create a JPanel to hold the additional components
accessory = JPanel();
accessory.setLayout(java.awt.FlowLayout(java.awt.FlowLayout.LEFT));
accessory.add(JLabel('Directory path:'));

% Create a text field for inputting the path
jTextField = JTextField(20);
accessory.add(jTextField);

% Add a browse button
jButtonBrowse = javax.swing.JButton('Browse');
set(handle(jButtonBrowse, 'CallbackProperties'), 'ActionPerformedCallback', @(h,e)onBrowseButtonClick(jTextField, jchooser));
accessory.add(jButtonBrowse);

% Set the accessory for file chooser
jchooser.setAccessory(accessory);

if nargin > 1
    jchooser.setDialogTitle(dialog_title);
end

jchooser.setMultiSelectionEnabled(true);

status = jchooser.showOpenDialog([]);

if status == JFileChooser.APPROVE_OPTION
    jFile = jchooser.getSelectedFiles();
    pathname{size(jFile, 1)}=[];
    for i=1:size(jFile, 1)
        pathname{i} = char(jFile(i).getAbsolutePath);
    end
    
elseif status == JFileChooser.CANCEL_OPTION
    pathname = [];
else
    error('Error occurred while picking file.');
end
end

function onBrowseButtonClick(jTextField, jchooser)
% Callback for the browse button
dirPath = jTextField.getText();
if ~isempty(dirPath)
    f = java.io.File(dirPath);
    if f.exists()
        jchooser.setCurrentDirectory(f);
    end
end
jchooser.showOpenDialog([]);
end
