function pushCropcallback(~,~,checkNewFolder,check8bit,check16bit,guiCrop, handles)
%PUSHCROPCALLBACK The 'Crop!' button essentially runs the program to crop
%all the .tif files in the chosen directory. Includes most of the error
%handling.

    %% Load structure parameters and set variables
    structParameters = getappdata(guiCrop,'structParameters');
    
    xMin = structParameters.xMin;
    xMax = structParameters.xMax;
    yMin = structParameters.yMin;
    yMax = structParameters.yMax;
    zMin = structParameters.zMin;
    zMax = structParameters.zMax;
    inpathdir = strcat(structParameters.inpathdir,'\');
    newFolder = structParameters.newFolder;
    outpathdir = strcat(structParameters.outpathdir,'\');
    
    fNames = dir(fullfile(inpathdir,'*tif'));
    fNames = {fNames.name}.';
    totalFiles = length(fNames);
    
    %% Run the program with error handling
    % If there are no .tifs to crop, show warning and return.
    if totalFiles == 0
        warndlg('There are no files to crop','No Files Found');
        return
    % Check if that folder already exists. If it does, offer the user to
    % overwrite the files, or choose a new folder name. If it does not,
    % create the new folder in the output path directory.
    elseif get(checkNewFolder,'Value') == 1   
        if exist(strcat(outpathdir,newFolder),'dir') == 7
            choice = questdlg('Warning','Cropped Directory','Overwrite','Cancel','Cancel');
            switch choice
                case 'Overwrite'
                    finaloutpath = strcat(outpathdir,newFolder,'\');
                case 'Cancel'
                    return
            end %switch
        else
            mkdir(outpathdir,newFolder);
            finaloutpath = strcat(outpathdir,newFolder,'\');
        end %if
    % Warn the user that the original data will be overwritten because the
    % output directory is the same as the input and no folder is being
    % created. Offer the choice to overwrite or cancel.
    elseif strcmp(inpathdir,outpathdir) && get(checkNewFolder,'Value') == 0
        choice = questdlg('WARNING! Your input and output directory are the same and you ARE NOT creating a new folder. This will overwrite your orgiginal data. Do you wish to continue?',...
            'Choose Wisely','Overwrite','Cancel','Cancel');
        switch choice
            case 'Overwrite'
                finaloutpath = outpathdir;
            case 'Cancel'
                return
        end %switch
    else
        finaloutpath = outpathdir;
    end %if
    % Make sure only one saving format is selected.
    % Warn the user how the 8-bit saving works.
    if get(check8bit,'Value') == 1 && get(check16bit,'Value') == 1
        warndlg('Please select only one saving format','Select only one');
        return 
    elseif get(check8bit,'Value') == 1 && get(check16bit,'Value') == 0
        choice = questdlg('Bit depth reduction to 8-bit is normalized per image stack. This may not be appropriate for many types of image analysis.',...
            'Ponder','Continue','Cancel','Cancel');
        switch choice
            case 'Cancel'
                return
            case 'Continue'
        end %switch
    end % if
    
    % Run the openTiff, cropping, and saveTIFF functions on each file found
    % in the directory.
    for i = 1:totalFiles
        % Check stop button status, reset and return if pushed
        if handles.pushStop.Value == 0
            msgbox('Process Stopped');
            handles.pushStop.Value = 1;
            return
        end %if
    fileName = char(fNames(i));
    
    % Updates the string on the GUI with the current file being cropped.
    structParameters.currentFile = fileName;
    setappdata(guiCrop,'structParameters',structParameters);   
    set(handles.textFileName,'String',structParameters.currentFile);
    pause(0.01)
    % Open the tiff files
    [fileStack] = openTIFF(inpathdir,fileName);
    c = class(fileStack);
    % crop the tiff files
    cropStack = zeros((yMax-yMin+1),(xMax-xMin+1),(zMax-zMin+1),c);
    for ii = 1:(zMax-zMin+1)
        for jj = 1:(yMax-yMin+1)
            for kk = 1:(xMax-xMin+1)
                cropStack(jj,kk,ii) = fileStack(jj+yMin-1,kk+xMin-1,ii+zMin-1);
            end % for
        end % for
    end % for    
    % Reduce the bit depth if the saving options are selected
    if get(check8bit,'Value') == 1
        c = 'uint8';
        cropStack = reduceBitDepth(cropStack,c);
    elseif get(check16bit,'Value') == 1
        c = 'uint16';    
        cropStack = reduceBitDepth(cropStack,c);
    end % if
    % save the tiff files
    writeTiff(cropStack,strcat(finaloutpath,fileName));
    end % for
    
    % Let the user know all the files were cropped.
    msgbox('Success!','Success');
    
end %pushCropcallback

