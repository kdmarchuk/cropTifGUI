function pushOutputFoldercallback(~,~,guiCrop,handles)
%PUSHOUTPUTFOLDERCALLBACK Prompts the user to select the folder for the
%cropped files to be saved in.

    %% Prompt the user to select a folder
    % check for a currently selected folder    
    structParameters = getappdata(guiCrop,'structParameters');
    outputFolder = structParameters.outpathdir;
    
    if ~isempty(outputFolder)
        folderSelection = uigetdir(outputFolder,'Select a folder to put cropped files in');
    else
        folderSelection = uigetdir(pwd,'Select a folder to put cropped files in');
    end % if
    
    %% Check for a canceled selection.
    if folderSelection(1) == 0 || strcmp(folderSelection,outputFolder)
        return
    end %if
    
    %% Store the folder as appdata
    structParameters.outpathdir = folderSelection;
    setappdata(guiCrop,'structParameters',structParameters);
    % Update the string on the GUI
    handles.displayOutPathDir.String = structParameters.outpathdir;
end

