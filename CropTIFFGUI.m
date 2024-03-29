function CropTIFFGUI()
%CROPTIFFGUI Creates the GUI, sets callback functions. R2015b
%   
    %% Create the figure
    figWidth = 400;
    figHeight = 700;
    
    % Set the display position for the GUI
    displayPos = get(0,'MonitorPositions');
    
    if displayPos(1,2) > 0
        figPos = [...
            (displayPos(1,3) - figWidth)/2,...
            (displayPos(1,4) - figHeight)/2,...
            figWidth,figHeight];
    else
        figPos = [...
            (displayPos(2,3) - figWidth)/2,...
            (displayPos(2,4) - figHeight)/2,...
            figWidth,figHeight];
    end % if
    
    guiCrop = figure(...
        'Color',[0 0 0],...
        'Colormap',gray(256),...
        'MenuBar','None',...
        'Name','Batch Crop',...
        'NumberTitle','Off',...
        'Position',figPos,...
        'Resize','Off',...
        'Tag','guiCrop');
    
    %% Create a structure for the parameters and save it as appdata
    % This structure contains the defaults for the GUI. You can edit it
    % here to adapt the default GUI settings to match your preferences.
    % As users edit the parameters in the GUI, these values are updated. It
    % can also be used to store parameters that you do not want users to
    % edit.
    
    structParameters = struct(...
        'xMin',1,...
        'xMax',512,...
        'yMin',1,...
        'yMax',512,...
        'zMin',1,...
        'zMax',150,...
        'run',1,...
        'newFolder','CroppedFiles',...
        'inpathdir','',...
        'outpathdir','',...
        'currentFile','');
    
    setappdata(guiCrop,'structParameters',structParameters)
    
    %% Create the file path directory box
    uicontrol(...
        'Background',[0 0 0],...
        'FontSize',12,...
        'Foreground','w',...
        'Parent',guiCrop,...
        'Position',[100 630 200 30],...
        'Style','text',...
        'String','Select File Directory',...
        'Tag','textFileDir')
    
    handles.displayInPathDir = uicontrol(...
        'Background',[0.2 0.2 0.2],...
        'FontSize',10,...
        'ForegroundColor','w',...
        'HorizontalAlign','Left',...
        'Parent',guiCrop,...
        'Position',[10 610 350 20],...
        'String',structParameters.inpathdir,...
        'Style','text',...
        'Tag','displayInPathDir');
    
    handles.displayOutPathDir = uicontrol(...
        'Background',[0.2 0.2 0.2],...
        'FontSize',10,...
        'ForegroundColor','w',...
        'HorizontalAlign','Left',...
        'Parent',guiCrop,...
        'Position',[10 230 350 20],...
        'String',structParameters.outpathdir,...
        'Style','text',...
        'Tag','displayOutPathDir');
    
    uicontrol(...
        'BackgroundColor','k',...
        'ForegroundColor','w',...
        'Callback',{@pushInputFoldercallback,guiCrop,handles},...
        'FontSize',10,...
        'Parent',guiCrop,...
        'Position',[370 610 20 20],...
        'String','...',...
        'Style','pushbutton',...
        'Tag','pushInPathDir',...
        'TooltipString','Find directory of the .tif files');
    
    
    %% Create Crop parameters
    panelCropSettings = uipanel(...
        'BackgroundColor','k',...
        'BorderType','Line',...
        'FontSize',12,...
        'ForegroundColor','w',...
        'HighlightColor','w',...
        'Parent',guiCrop,...
        'Position',[60 400 280 200]./[figPos(3) figPos(4) figPos(3) figPos(4)],...
        'Title','Crop Settings',...
        'TitlePosition','Centertop',...
        'Tag','panelCrop',...
        'Units','Pixels');
    uistack(panelCropSettings,'bottom')
    
    uicontrol(...
        'Background','k',...
        'FontSize',11,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[50 150 50 20],...
        'Style','text',...
        'String','x min',...
        'Tag','textXMin')
    
    editXMin = mycontrol(...
        'Background',[0.2 0.2 0.2],...
        'FontSize',10,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[55 130 40 20],...
        'Style','edit',...
        'String',structParameters.xMin,...
        'Tag','editXMin',...
        'TooltipString','Enter the starting x value');
    set(editXMin.Handle,'Callback',{@editXcallback,editXMin,guiCrop})
    
    uicontrol(...
        'Background','k',...
        'FontSize',11,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[190 150 50 20],...
        'Style','text',...
        'String','x max',...
        'Tag','textXMax')
    
    editXMax = mycontrol(...
        'Background',[0.2 0.2 0.2],...
        'FontSize',10,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[195 130 40 20],...
        'Style','edit',...
        'String',structParameters.xMax,...
        'Tag','editXMax',...
        'TooltipString','Enter the ending x value');
    set(editXMax.Handle,'Callback',{@editXcallback,editXMax,guiCrop})
    
    uicontrol(...
        'Background','k',...
        'FontSize',11,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[50 100 50 20],...
        'Style','text',...
        'String','y min',...
        'Tag','textYMin')
    
    editYMin = mycontrol(...
        'Background',[0.2 0.2 0.2],...
        'FontSize',10,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[55 80 40 20],...
        'Style','edit',...
        'String',structParameters.yMin,...
        'Tag','editYMin',...
        'TooltipString','Enter the starting y value');
    set(editYMin.Handle,'Callback',{@editYcallback,editYMin,guiCrop})
    
    uicontrol(...
        'Background','k',...
        'FontSize',11,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[190 100 50 20],...
        'Style','text',...
        'String','y max',...
        'Tag','textYMax')
    
    editYMax = mycontrol(...
        'Background',[0.2 0.2 0.2],...
        'FontSize',10,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[195 80 40 20],...
        'Style','edit',...
        'String',structParameters.yMax,...
        'Tag','editYMax',...
        'TooltipString','Enter the ending y value');
    set(editYMax.Handle,'Callback',{@editYcallback,editYMax,guiCrop})
    
    uicontrol(...
        'Background','k',...
        'FontSize',11,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[25 50 100 20],...
        'Style','text',...
        'String','First Frame',...
        'Tag','textFirstFrame')
    
    editFrameMin = mycontrol(...
        'Background',[0.2 0.2 0.2],...
        'FontSize',10,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[55 30 40 20],...
        'Style','edit',...
        'String',structParameters.zMin,...
        'Tag','editFrameMin',...
        'TooltipString','Enter the number of the first frame');
    set(editFrameMin.Handle,'Callback',{@editFramecallback,editFrameMin,guiCrop})
    
    uicontrol(...
        'Background','k',...
        'FontSize',11,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[165 50 100 20],...
        'Style','text',...
        'String','Final Frame',...
        'Tag','textFinalFrame')
    
    editFrameMax = mycontrol(...
        'Background',[0.2 0.2 0.2],...
        'FontSize',10,...
        'Foreground','w',...
        'Parent',panelCropSettings,...
        'Position',[195 30 40 20],...
        'Style','edit',...
        'String',structParameters.zMax,...
        'Tag','editFrameMax',...
        'TooltipString','Enter the number of the final frame');
    set(editFrameMax.Handle,'Callback',{@editFramecallback,editFrameMax,guiCrop})
    
    %% Create Compression Options
    panelCompressChecks = uipanel(...
        'BackgroundColor','k',...
        'BorderType','Line',...
        'FontSize',12,...
        'ForegroundColor','w',...
        'HighlightColor','w',...
        'Parent',guiCrop,...
        'Position',[60 300 280 75]./[figPos(3) figPos(4) figPos(3) figPos(4)],...
        'Title','Saving Options',...
        'TitlePosition','Centertop',...
        'Tag','panelCrop',...
        'Units','Pixels');
    uistack(panelCompressChecks,'bottom')
    
    check16bit = uicontrol(...
        'BackgroundColor','k',...
        'FontSize',11,...
        'ForegroundColor','w',...
        'Parent',panelCompressChecks,...
        'Position',[65 25 100 20],...
        'String','16-Bit',...
        'Style','checkbox',...
        'Tag','check16bit',...
        'TooltipString','Compress output to 16-bit',...
        'Value',1);
    
    check8bit = uicontrol(...
        'BackgroundColor','k',...
        'FontSize',11,...
        'ForegroundColor','w',...
        'Parent',panelCompressChecks,...
        'Position',[165 25 100 20],...
        'String','8-Bit',...
        'Style','checkbox',...
        'Tag','check8bit',...
        'TooltipString','Compress output to 8-bit',...
        'Value',0);
    
    %% Create Final Output inputs
    uicontrol(...
        'Background','k',...
        'FontSize',12,...
        'Foreground','w',...
        'Parent',guiCrop,...
        'Position',[100 250 200 30],...
        'Style','text',...
        'String','Choose Output Directory',...
        'Tag','textOutDir')
    
    uicontrol(...
        'BackgroundColor','k',...
        'ForegroundColor','w',...
        'Callback',{@pushOutputFoldercallback,guiCrop,handles},...
        'FontSize',10,...
        'Parent',guiCrop,...
        'Position',[370 230 20 20],...
        'String','...',...
        'Style','pushbutton',...
        'Tag','pushOutPathDir',...
        'TooltipString','Choose Directory of the cropped files');
    
    checkNewFolder = uicontrol(...
        'BackgroundColor','k',...
        'FontSize',12,...
        'ForegroundColor','w',...
        'Parent',guiCrop,...
        'Position',[125 170 200 20],...
        'String','Create New Folder?',...
        'Style','checkbox',...
        'Tag','checkNewFolder',...
        'TooltipString','Create a new folder within the output directory',...
        'Value',1);
    
    uicontrol(...
        'Background','k',...
        'FontSize',11,...
        'Foreground','w',...
        'Parent',guiCrop,...
        'Position',[100 140 200 20],...
        'Style','text',...
        'String','New Folder Name',...
        'Tag','textFolderName')
    
    editNewFolder = mycontrol(...
        'Background',[0.2 0.2 0.2],...
        'FontSize',10,...
        'ForegroundColor','w',...
        'Parent',guiCrop,...
        'Position',[125 120 150 20],...
        'String',structParameters.newFolder,...
        'Style','edit',...
        'Tag','editNewFolder');
    set(editNewFolder.Handle,'Callback',{@editNewFoldercallback,editNewFolder,guiCrop})
    
    handles.textFileName = uicontrol(...
        'Background','k',...
        'FontSize',9,...
        'Foreground','w',...
        'Parent',guiCrop,...
        'Position',[10 20 380 40],...
        'Style','text',...
        'String','',...
        'Tag','textFileName');
    
    handles.pushStop = uicontrol(...
        'BackgroundColor','w',...
        'ForegroundColor','r',...
        'Callback',{@pushStopcallback,handles},...
        'String','STOP!',...
        'FontSize',14,...
        'Style','pushbutton',...
        'Parent',guiCrop,...
        'Value',1,...
        'Position',[205 70 80 40],...
        'Tag','pushStop',...
        'TooltipString','STOP SCRIPT!');
    
    uicontrol(...
        'BackgroundColor','w',...
        'ForegroundColor','k',...
        'Callback',{@pushCropcallback,checkNewFolder,check8bit,check16bit,guiCrop,handles},...
        'FontSize',14,...
        'Parent',guiCrop,...
        'Position',[115 70 80 40],...
        'String','CROP!',...
        'Style','pushbutton',...
        'Tag','pushCrop',...
        'TooltipString','Run!');
    
    
end

