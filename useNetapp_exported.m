classdef useNetapp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        Label                    matlab.ui.control.Label
        OptionsandinputsPanel    matlab.ui.container.Panel
        PredictButton            matlab.ui.control.Button
        BrowseButton             matlab.ui.control.Button
        SelectListBox            matlab.ui.control.ListBox
        SelectListBoxLabel       matlab.ui.control.Label
        TabGroup                 matlab.ui.container.TabGroup
        OneimageTab              matlab.ui.container.Tab
        OpenresultsfileButton_2  matlab.ui.control.Button
        SaveresultButton         matlab.ui.control.Button
        LevelEditField           matlab.ui.control.EditField
        LevelEditFieldLabel      matlab.ui.control.Label
        UIAxes                   matlab.ui.control.UIAxes
        OnefolderTab             matlab.ui.container.Tab
        SaveresultsButton        matlab.ui.control.Button
        LevelEditField_2         matlab.ui.control.EditField
        LevelEditField_2Label    matlab.ui.control.Label
        OpenresultsfileButton    matlab.ui.control.Button
        UIAxes2                  matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        img % Description
        CNN
        file_name1
        dirsave
        re
        sname1
        df1
        fname1
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            load('NetCI.mat','net');
            app.CNN=net;
            warning off
        end

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            try
            switch app.SelectListBox.Value
                case 'One file'
                    app.TabGroup.SelectedTab=app.OneimageTab;
                    [file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif;*.jpeg'},'Choose an image');
                    figure(app.UIFigure)
                    imlink = fullfile(path,file);
                    app.img=imread(imlink);
                    imshow(app.img,'Parent',app.UIAxes)
                    clear app.sname1
                    app.sname1 = file;
                case 'One folder'
                    app.TabGroup.SelectedTab=app.OnefolderTab;
                    app.df1=uigetdir('selector');
                    figure(app.UIFigure)
                    app.fname1=dir([app.df1 '\*.png']);
                    app.file_name1={app.fname1.name};
                    
                                      
            end
            catch
                msgbox('Error: Please select image data!')
            end
            
        end

        % Button pushed function: PredictButton
        function PredictButtonPushed(app, event)
        switch app.SelectListBox.Value
            case 'One file'
                clear app.re
                
                    inputSize = app.CNN.Layers(1).InputSize;
                    I = imresize(app.img,inputSize(1:2));
                    I=im2double(I);
                    label = classify(app.CNN,I);
                    app.re=label;
                    xlabel('Parent',app.UIAxes,app.sname1)
                    app.LevelEditField.Value=char(label);
            case 'One folder'
                app.re=strings(length(app.fname1),1);
                app.sname1=strings(length(app.fname1),1);
                for i=1:length(app.fname1)
                    name=app.file_name1{i};
                    app.sname1(i)=cellstr(name(1:end-4));
                    im=imread([app.df1 '\' app.file_name1{i}]);
                    inputSize = app.CNN.Layers(1).InputSize;
                    I = imresize(im,inputSize(1:2));
                    I=im2double(I);
                    label = classify(app.CNN,I);
                    imshow(im,'Parent',app.UIAxes2)
                    xlabel('Parent',app.UIAxes2,app.sname1(i))
                    app.re(i)=label;
                    app.LevelEditField_2.Value=char(label);
                    pause(0.2)
                end
        end
            
        
        end

        % Button pushed function: OpenresultsfileButton
        function OpenresultsfileButtonPushed(app, event)
            try   
                if app.dirsave~=0
                    winopen([app.dirsave '\' 'resultCNN.xlsx'])
                else
                    winopen('resultCNN.xlsx')
                end
            catch
                msgbox('Sorry!! You have not saved the results!')
            end
        end

        % Button pushed function: SaveresultsButton
        function SaveresultsButtonPushed(app, event)
    answer1 = questdlg('Would you like to save result?', ...
	'Saving Menu', ...
	'OK! Choose a folder to save','Cancel','OK! Choose a folder to save');
    switch (answer1)
    case 'Cancel'
%         warndlg('Processing without saving result','Warning');
        app.dirsave=0;
    case 'OK! Choose a folder to save'
        app.dirsave=uigetdir('selector');
        figure(app.UIFigure)
            if app.dirsave~=0
                delete([app.dirsave '\' 'resultCNN.xlsx'])
                writematrix(double(app.re),[app.dirsave '\' 'resultCNN.xlsx'],'Sheet','Sheet1','Range','B2');
                writecell(cellstr(app.sname1),[app.dirsave '\' 'resultCNN.xlsx'],'Sheet','Sheet1','Range','A2');
            else
                delete 'resultCNN.xlsx'
                writematrix(double(app.re),'resultCNN.xlsx','Sheet','Sheet1','Range','B2');
                writecell(cellstr(app.sname1),'resultCNN.xlsx','Sheet','Sheet1','Range','A2');  
            end
    end
        end

        % Button pushed function: SaveresultButton
        function SaveresultButtonPushed(app, event)
            answer1 = questdlg('Would you like to save result?', ...
	'Saving Menu', ...
	'OK! Choose a folder to save','Cancel','OK! Choose a folder to save');
    switch (answer1)
    case 'Cancel'
%         warndlg('Processing without saving result','Warning');
        app.dirsave=0;
    case 'OK! Choose a folder to save'
        app.dirsave=uigetdir('selector');
        figure(app.UIFigure)
            if app.dirsave~=0
                delete([app.dirsave '\' 'resultCNN.xlsx'])
                writematrix(double(app.re),[app.dirsave '\' 'resultCNN.xlsx'],'Sheet','Sheet1','Range','B2');
                writecell(cellstr(app.sname1),[app.dirsave '\' 'resultCNN.xlsx'],'Sheet','Sheet1','Range','A2');
            else
                delete 'resultCNN.xlsx'
                writematrix(double(app.re),'resultCNN.xlsx','Sheet','Sheet1','Range','B2');
                writecell(cellstr(app.sname1),'resultCNN.xlsx','Sheet','Sheet1','Range','A2');  
            end
    end
        end

        % Button pushed function: OpenresultsfileButton_2
        function OpenresultsfileButton_2Pushed(app, event)
            try   
                if app.dirsave~=0
                    winopen([app.dirsave '\' 'resultCNN.xlsx'])
                else
                    winopen('resultCNN.xlsx')
                end
            catch
                msgbox('Sorry!! You have not saved the results!')
            end            
        end

        % Value changed function: SelectListBox
        function SelectListBoxValueChanged(app, event)
            value = app.SelectListBox.Value;
            switch value
                case 'One file'
                    app.TabGroup.SelectedTab=app.OneimageTab;
                case 'One folder'
                    app.TabGroup.SelectedTab=app.OnefolderTab;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [225 1 416 382];

            % Create OneimageTab
            app.OneimageTab = uitab(app.TabGroup);
            app.OneimageTab.Title = 'One image';

            % Create UIAxes
            app.UIAxes = uiaxes(app.OneimageTab);
            title(app.UIAxes, 'Feature image')
            app.UIAxes.Position = [32 103 352 245];

            % Create LevelEditFieldLabel
            app.LevelEditFieldLabel = uilabel(app.OneimageTab);
            app.LevelEditFieldLabel.HorizontalAlignment = 'right';
            app.LevelEditFieldLabel.FontSize = 20;
            app.LevelEditFieldLabel.Position = [141 76 53 24];
            app.LevelEditFieldLabel.Text = 'Level';

            % Create LevelEditField
            app.LevelEditField = uieditfield(app.OneimageTab, 'text');
            app.LevelEditField.HorizontalAlignment = 'center';
            app.LevelEditField.FontSize = 20;
            app.LevelEditField.Position = [209 72 100 28];

            % Create SaveresultButton
            app.SaveresultButton = uibutton(app.OneimageTab, 'push');
            app.SaveresultButton.ButtonPushedFcn = createCallbackFcn(app, @SaveresultButtonPushed, true);
            app.SaveresultButton.BackgroundColor = [0.8 0.8 0.8];
            app.SaveresultButton.FontSize = 20;
            app.SaveresultButton.FontWeight = 'bold';
            app.SaveresultButton.Position = [16 19 151 40];
            app.SaveresultButton.Text = 'Save result';

            % Create OpenresultsfileButton_2
            app.OpenresultsfileButton_2 = uibutton(app.OneimageTab, 'push');
            app.OpenresultsfileButton_2.ButtonPushedFcn = createCallbackFcn(app, @OpenresultsfileButton_2Pushed, true);
            app.OpenresultsfileButton_2.BackgroundColor = [0.8 0.8 0.8];
            app.OpenresultsfileButton_2.FontSize = 20;
            app.OpenresultsfileButton_2.FontWeight = 'bold';
            app.OpenresultsfileButton_2.FontColor = [0 0 1];
            app.OpenresultsfileButton_2.Position = [179 19 225 40];
            app.OpenresultsfileButton_2.Text = 'Open results file';

            % Create OnefolderTab
            app.OnefolderTab = uitab(app.TabGroup);
            app.OnefolderTab.Title = 'One folder';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.OnefolderTab);
            title(app.UIAxes2, 'Feature image')
            app.UIAxes2.Position = [32 106 352 242];

            % Create OpenresultsfileButton
            app.OpenresultsfileButton = uibutton(app.OnefolderTab, 'push');
            app.OpenresultsfileButton.ButtonPushedFcn = createCallbackFcn(app, @OpenresultsfileButtonPushed, true);
            app.OpenresultsfileButton.BackgroundColor = [0.8 0.8 0.8];
            app.OpenresultsfileButton.FontSize = 20;
            app.OpenresultsfileButton.FontWeight = 'bold';
            app.OpenresultsfileButton.FontColor = [0 0 1];
            app.OpenresultsfileButton.Position = [174 22 225 40];
            app.OpenresultsfileButton.Text = 'Open results file';

            % Create LevelEditField_2Label
            app.LevelEditField_2Label = uilabel(app.OnefolderTab);
            app.LevelEditField_2Label.HorizontalAlignment = 'right';
            app.LevelEditField_2Label.FontSize = 20;
            app.LevelEditField_2Label.Position = [141 83 53 24];
            app.LevelEditField_2Label.Text = 'Level';

            % Create LevelEditField_2
            app.LevelEditField_2 = uieditfield(app.OnefolderTab, 'text');
            app.LevelEditField_2.HorizontalAlignment = 'center';
            app.LevelEditField_2.FontSize = 20;
            app.LevelEditField_2.Position = [209 79 100 28];

            % Create SaveresultsButton
            app.SaveresultsButton = uibutton(app.OnefolderTab, 'push');
            app.SaveresultsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveresultsButtonPushed, true);
            app.SaveresultsButton.BackgroundColor = [0.8 0.8 0.8];
            app.SaveresultsButton.FontSize = 20;
            app.SaveresultsButton.FontWeight = 'bold';
            app.SaveresultsButton.FontColor = [0.149 0.149 0.149];
            app.SaveresultsButton.Position = [16 22 143 40];
            app.SaveresultsButton.Text = 'Save results';

            % Create OptionsandinputsPanel
            app.OptionsandinputsPanel = uipanel(app.UIFigure);
            app.OptionsandinputsPanel.ForegroundColor = [0 0 1];
            app.OptionsandinputsPanel.Title = 'Options and inputs';
            app.OptionsandinputsPanel.FontWeight = 'bold';
            app.OptionsandinputsPanel.FontSize = 15;
            app.OptionsandinputsPanel.Position = [1 1 225 382];

            % Create SelectListBoxLabel
            app.SelectListBoxLabel = uilabel(app.OptionsandinputsPanel);
            app.SelectListBoxLabel.HorizontalAlignment = 'right';
            app.SelectListBoxLabel.FontSize = 15;
            app.SelectListBoxLabel.FontWeight = 'bold';
            app.SelectListBoxLabel.FontColor = [0.3922 0.8314 0.0745];
            app.SelectListBoxLabel.Position = [13 268 59 22];
            app.SelectListBoxLabel.Text = 'Select: ';

            % Create SelectListBox
            app.SelectListBox = uilistbox(app.OptionsandinputsPanel);
            app.SelectListBox.Items = {'One file', 'One folder'};
            app.SelectListBox.ValueChangedFcn = createCallbackFcn(app, @SelectListBoxValueChanged, true);
            app.SelectListBox.FontSize = 15;
            app.SelectListBox.FontWeight = 'bold';
            app.SelectListBox.FontColor = [0.3922 0.8314 0.0745];
            app.SelectListBox.Position = [87 254 131 50];
            app.SelectListBox.Value = 'One file';

            % Create BrowseButton
            app.BrowseButton = uibutton(app.OptionsandinputsPanel, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.BackgroundColor = [0.8 0.8 0.8];
            app.BrowseButton.FontSize = 20;
            app.BrowseButton.FontWeight = 'bold';
            app.BrowseButton.FontAngle = 'italic';
            app.BrowseButton.FontColor = [1 0 0];
            app.BrowseButton.Position = [42 168 147 46];
            app.BrowseButton.Text = 'Browse';

            % Create PredictButton
            app.PredictButton = uibutton(app.OptionsandinputsPanel, 'push');
            app.PredictButton.ButtonPushedFcn = createCallbackFcn(app, @PredictButtonPushed, true);
            app.PredictButton.BackgroundColor = [0.302 0.7451 0.9333];
            app.PredictButton.FontSize = 25;
            app.PredictButton.FontWeight = 'bold';
            app.PredictButton.Position = [42 58 147 73];
            app.PredictButton.Text = 'Predict';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.FontSize = 20;
            app.Label.FontWeight = 'bold';
            app.Label.FontColor = [1 0.4118 0.1608];
            app.Label.Position = [15 409 594 46];
            app.Label.Text = {'Program of LF-CI-CNN for Investigating properties of material '; 'in concrete beam'};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = useNetapp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end