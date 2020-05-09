classdef BabyNameTrends < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        BabyNameTrendsUIFigure          matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        AboutTab                        matlab.ui.container.Tab
        AboutLabel                      matlab.ui.control.Label
        VersionLabel                    matlab.ui.control.Label
        PopularNamesbyBirthYearTab      matlab.ui.container.Tab
        EntertheBirthYearEditFieldLabel  matlab.ui.control.Label
        EntertheBirthYearEditField      matlab.ui.control.NumericEditField
        SelectNumberofNamesDisplayedLabel  matlab.ui.control.Label
        SelectNumberofNamesDisplayedSlider  matlab.ui.control.Slider
        TextArea                        matlab.ui.control.TextArea
        Label                           matlab.ui.control.Label
        PopularityofNamesoverTimeTab    matlab.ui.container.Tab
        EnterNametoPlotPopularityLabel  matlab.ui.control.Label
        EnterNametoPlotPopularityEditField  matlab.ui.control.EditField
        EnterButton                     matlab.ui.control.Button
        ClearButton                     matlab.ui.control.Button
        UIAxes                          matlab.ui.control.UIAxes
        Label_2                         matlab.ui.control.Label
        TextArea_2                      matlab.ui.control.TextArea
        SelectGenderDropDownLabel       matlab.ui.control.Label
        SelectGenderDropDown            matlab.ui.control.DropDown
        EntertheRangeofBirthYearSpinnerLabel  matlab.ui.control.Label
        EntertheRangeofBirthYearSpinner  matlab.ui.control.Spinner
        toSpinnerLabel                  matlab.ui.control.Label
        toSpinner                       matlab.ui.control.Spinner
    end

    
    properties (Access = private)
        TextArea2Cell % containing string to be displayed in TextArea_2
        TextArea2Index % Description
    end
    
    methods (Access = private)
        
        function [ topNames ] = detTopNames(~,yearOfBirth,top)
            %Determines the top girl and boy names in a particular year.
            %by getting that info from the input data file for that year.
            %   Inputs: yearOfBirth - an integer between [1880 and 2016].
            %                   top - an integer betwenn [0 and 100].
            %   Output:    topNames - a cell array with top rows and two columes, the
            %                         first colume is the top girl names as char array,
            %                         the second colume is the top boy names as char
            %                         arrays.
            
            file = sprintf('yob%d.txt',yearOfBirth);
                % Determine file name with inputs.
            FID = fopen(file,'r');
                % Open the corresponding file.
            list = textscan(FID,'%s %s %d','Delimiter',',');
                % Using textscan to store the content in cell array list.
            fclose(FID);
                % Close the file.
                
            names = list{:,1};    
                % Get a cell array of names from list.
            gender = cell2mat(list{:,2});    
                % Get a string array of gender from list.
             
            nameF = names(gender == 'F');
                % Get a cell array containing all female names.
            nameM = names(gender == 'M');
                % Get a cell array containing all male names.
             
            % Preallocate cell arrays of female and male names.
            topF = cell(round(top),1);
            topM = cell(round(top),1);
            % For loop assigning desired number of top names to the cell arrays.
            for i = 1:round(top)
                topF(i,1) = nameF(i);
                topM(i,1) = nameM(i);
            end
             
            % Contcanenate cell arrays of female and male names to get topNames.
            topNames = [topF,topM];
     
        end
        
        function [] = tab1(app,value)
            app.TextArea.Value = newline;
            
            if value == 0
                app.TextArea.Enable = 'off';
                return;
            end
            topNames = detTopNames(app,app.EntertheBirthYearEditField.Value,value);
            app.TextArea.Enable = 'on';
            cellArrayText{1,1} = sprintf('Rank\t\t\tGirls\t\t\tBoys\n');
            cellArrayText{2,1} = sprintf('_______________________________________________________\n');
            for i = 1:value
                cellArrayText{i+2,1} = sprintf('%4d\t  %20s\t%20s\n',i,topNames{i,1},topNames{i,2});
            end
            
            app.TextArea.Value = cellArrayText;
        end
        
        function [ popularity ] = detNamePopularityInYear(~,yearOfBirth,name,gender)
            %Determines the occurrences (popularity) of a particular name given the
            %gender and the year of birth by searching in the input data file.
            %   Inputs: yearOfBirth - an integer between [1880 and 2016].
            %                  name - a string for the name to search for.
            %                gender - a string either 'f', 'F', 'm' or 'M'.
            %   Output:  popularity - If name in year of birth input file, then it is
            %                         an int32. If name is Not found, then it is an 
            %                         empty vector.
            
            file = sprintf('yob%d.txt',yearOfBirth);
                % Determine file name with inputs.
            FID = fopen(file,'r');
                % Open the corresponding file.
            list = textscan(FID,'%s %s %d','Delimiter',',');
                % Scan the text and store them in a cell array.
            fclose(FID);
                % Close the file.
            
            popularity = list{3}(strcmpi(list{1},name) & strcmpi(list{2},gender));
                % Find the popularity of input name (int32).
                
            % Set popularity to empty if name was not found.
            if isempty(popularity)
                popularity = [];
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            about = sprintf(['This app dedicates to demonstrate\nthe popularity of baby names in The United States\n\n' ...
                             'You can either browse the names by ranking of popularity in a specific year,\n'...
                             'Or you can visualize the trend of a specific name across a period of time.\n\n'...
                             'All the data are acquired from\nThe United States Social Security Administration website\n'...
                             'https://www.ssa.gov/oact/babynames/limits.html\nNational data']);
            
            version = sprintf('Version 1.1\nMay 15, 2019\nDeveloped with MATLAB');
            
            app.AboutLabel.Text = about;
            app.VersionLabel.Text = version;
        end

        % Value changed function: EntertheBirthYearEditField
        function EntertheBirthYearEditFieldValueChanged(app, event)
            value = round(app.SelectNumberofNamesDisplayedSlider.Value);
            
            tab1(app,value);
            
        end

        % Value changing function: 
        % SelectNumberofNamesDisplayedSlider
        function SelectNumberofNamesDisplayedSliderValueChanging(app, event)
            value = round(event.Value);
            
            tab1(app,value);
            
        end

        % Key press function: BabyNameTrendsUIFigure
        function BabyNameTrendsUIFigureKeyPress(app, event)
            key = event.Key;
            if strcmp(key , 'uparrow')
                if ceil(app.SelectNumberofNamesDisplayedSlider.Value) >= ...
                        max(app.SelectNumberofNamesDisplayedSlider.MajorTicks)
                    return;
                else
                    app.SelectNumberofNamesDisplayedSlider.Value = ...
                        app.SelectNumberofNamesDisplayedSlider.Value + 1;
                    
                    value = round(app.SelectNumberofNamesDisplayedSlider.Value);
                    tab1(app,value);
                end
            elseif strcmp(key , 'downarrow')
                if floor(app.SelectNumberofNamesDisplayedSlider.Value) <= ...
                        min(app.SelectNumberofNamesDisplayedSlider.MajorTicks)
                    return;
                else
                    app.SelectNumberofNamesDisplayedSlider.Value = ...
                        app.SelectNumberofNamesDisplayedSlider.Value - 1;
                
                    value = round(app.SelectNumberofNamesDisplayedSlider.Value);
                    tab1(app,value);
                end
            elseif strcmp(key , 'rightarrow')
                if app.EntertheBirthYearEditField.Value >= ...
                        max(app.EntertheBirthYearEditField.Limits)
                    return;
                else
                    app.EntertheBirthYearEditField.Value = ...
                        app.EntertheBirthYearEditField.Value + 1;
                    
                    value = round(app.SelectNumberofNamesDisplayedSlider.Value);
                    tab1(app,value);
                end
            elseif strcmp(key , 'leftarrow')
                if app.EntertheBirthYearEditField.Value <= ...
                        min(app.EntertheBirthYearEditField.Limits)
                    return;
                else
                    app.EntertheBirthYearEditField.Value = ...
                        app.EntertheBirthYearEditField.Value - 1;
                    
                    value = round(app.SelectNumberofNamesDisplayedSlider.Value);
                    tab1(app,value);
                end
                
            end
        end

        % Button pushed function: ClearButton
        function ClearButtonPushed(app, event)
            cla(app.UIAxes,'reset');
            title(app.UIAxes, 'Popularity of Names')
            xlabel(app.UIAxes, 'Year')
            ylabel(app.UIAxes, 'Number of Occurrence')
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            
            app.EnterNametoPlotPopularityEditField.Value = '';
            app.SelectGenderDropDown.Value = '0';
            app.EntertheRangeofBirthYearSpinner.Value = 1880;
            app.toSpinner.Value = 2017;
            
            app.TextArea2Cell = {};
            app.TextArea_2.Value = newline;
            app.TextArea_2.Enable = 'off';
            app.Label_2.Text = '';
        end

        % Button pushed function: EnterButton
        function EnterButtonPushed(app, event)
            if isempty(app.EnterNametoPlotPopularityEditField.Value)
                app.Label_2.Text = 'Please Enter a Name';
                return;
            end    
            if app.SelectGenderDropDown.Value == '0'
                app.Label_2.Text = 'Please Select Gender';
                return;
            end
            if isempty(app.EntertheRangeofBirthYearSpinner.Value) || ...
                    isempty(app.toSpinner.Value)
                app.Label_2.Text = 'Please Enter Year Range';
                return;
            end
            if app.EntertheRangeofBirthYearSpinner.Value > app.toSpinner.Value
                app.Label_2.Text = 'Starting Year Must Be Smaller than or Equal to Endding Year';
                return;
            end
            app.Label_2.Text = 'Please Wait...';
            pause(0.001);
            
            genderIn = app.SelectGenderDropDown.Value;
            nameIn = strtrim(app.EnterNametoPlotPopularityEditField.Value);
            name = [upper(nameIn(1)) lower(nameIn(2:end))];
                % Convert names to correct format.
            app.EnterNametoPlotPopularityEditField.Value = name;    
            yeari = app.EntertheRangeofBirthYearSpinner.Value;
            yearf = app.toSpinner.Value;
            occurrence = zeros(1,yearf-yeari+1);
                % Initialize array of occurrence.
            for years = yeari:yearf
                % Assign occurrences only if occurrence exists.
                if ~isempty(detNamePopularityInYear(app,years,name,genderIn))
                    % Assign occurrences only if occurrence exists.
                    occurrence(years-yeari+1) = detNamePopularityInYear(app, ...
                                               years,name,genderIn);
                end
            end
            
            % If statement determining if name was found.
            if sum(occurrence) ~= 0
                % Print occurrences and create array for plotting if name
                % was found.
                [maxOccur,index] = max(occurrence);
                    % Find maximum occurrence and year it occur.
                app.Label_2.Text = '';
                app.TextArea_2.Enable = 'on';
                
                app.TextArea2Cell(2:end+1) = app.TextArea2Cell(1:end);
                
                app.TextArea2Cell{1} = sprintf(['''%s''%s was most popular in %d with %d ' ...
                         'occurrence. (From %d to %d) \n'], name, ['(' upper(genderIn) ')'], ...
                             index+yeari-1,maxOccur,yeari,yearf);
                app.TextArea_2.Value = app.TextArea2Cell;         
                
                % Find the index where occurrence start and end.
                occurIndex = find(occurrence ~= 0);
                occurPlot = occurrence(occurIndex(1):occurIndex(end));
                % Find the corresponding year range for plotting.
                yearRange = yeari:yearf;
                yearPlot = yearRange(occurIndex(1)): ...
                           yearRange(occurIndex(end));  
                     
                % Create cell array containing info for plotting.
                namePlot = {[name '(' upper(genderIn) ')'],occurPlot, ...
                            yearPlot};           
                        
                % Plot Name Trends
                hold(app.UIAxes,'on');    % Hold on the figure for plotting.
                app.UIAxes.XTickMode = 'auto';
                app.UIAxes.YTickMode = 'auto';
                h = plot(app.UIAxes,double(namePlot{3}),namePlot{2});
                    % Plot the trend lines.
                set(h,'LineWidth',2);    % Set the width of lines.
                text(app.UIAxes,double(namePlot{3}(end)),namePlot{2}(end), ...
                     namePlot{1},'HorizontalAlignment','right');    
                    % Add text at the end of lines.
                
            else
                % Name was not found.
                app.Label_2.Text = 'Name was NOT found!';
            end
                      
        end

        % Value changed function: EnterNametoPlotPopularityEditField
        function EnterNametoPlotPopularityEditFieldValueChanged(app, event)
            value = app.EnterNametoPlotPopularityEditField.Value;

            nameIn = strtrim(value);
            name = [upper(nameIn(1)) lower(nameIn(2:end))];
                % Convert names to correct format.
            app.EnterNametoPlotPopularityEditField.Value = name;    
        end

        % Value changing function: 
        % EnterNametoPlotPopularityEditField
        function EnterNametoPlotPopularityEditFieldValueChanging(app, event)
            app.Label_2.Text = '';
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create BabyNameTrendsUIFigure and hide until all components are created
            app.BabyNameTrendsUIFigure = uifigure('Visible', 'off');
            app.BabyNameTrendsUIFigure.Position = [100 100 640 600];
            app.BabyNameTrendsUIFigure.Name = 'Baby Name Trends';
            app.BabyNameTrendsUIFigure.Resize = 'off';
            app.BabyNameTrendsUIFigure.KeyPressFcn = createCallbackFcn(app, @BabyNameTrendsUIFigureKeyPress, true);
            app.BabyNameTrendsUIFigure.BusyAction = 'cancel';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.BabyNameTrendsUIFigure);
            app.TabGroup.Position = [13 15 613 571];

            % Create AboutTab
            app.AboutTab = uitab(app.TabGroup);
            app.AboutTab.Title = '                About               ';

            % Create AboutLabel
            app.AboutLabel = uilabel(app.AboutTab);
            app.AboutLabel.HorizontalAlignment = 'center';
            app.AboutLabel.FontSize = 16;
            app.AboutLabel.Position = [13 160 588 332];
            app.AboutLabel.Text = 'About';

            % Create VersionLabel
            app.VersionLabel = uilabel(app.AboutTab);
            app.VersionLabel.HorizontalAlignment = 'center';
            app.VersionLabel.Position = [103 23 408 113];
            app.VersionLabel.Text = 'Version';

            % Create PopularNamesbyBirthYearTab
            app.PopularNamesbyBirthYearTab = uitab(app.TabGroup);
            app.PopularNamesbyBirthYearTab.Title = 'Popular Names by Birth Year';

            % Create EntertheBirthYearEditFieldLabel
            app.EntertheBirthYearEditFieldLabel = uilabel(app.PopularNamesbyBirthYearTab);
            app.EntertheBirthYearEditFieldLabel.Position = [20 498 113 22];
            app.EntertheBirthYearEditFieldLabel.Text = 'Enter the Birth Year:';

            % Create EntertheBirthYearEditField
            app.EntertheBirthYearEditField = uieditfield(app.PopularNamesbyBirthYearTab, 'numeric');
            app.EntertheBirthYearEditField.Limits = [1880 2017];
            app.EntertheBirthYearEditField.ValueDisplayFormat = '%4d';
            app.EntertheBirthYearEditField.ValueChangedFcn = createCallbackFcn(app, @EntertheBirthYearEditFieldValueChanged, true);
            app.EntertheBirthYearEditField.HorizontalAlignment = 'left';
            app.EntertheBirthYearEditField.Tooltip = {'Enter any year from 1880 to 2017'};
            app.EntertheBirthYearEditField.Position = [132 498 40 22];
            app.EntertheBirthYearEditField.Value = 2017;

            % Create SelectNumberofNamesDisplayedLabel
            app.SelectNumberofNamesDisplayedLabel = uilabel(app.PopularNamesbyBirthYearTab);
            app.SelectNumberofNamesDisplayedLabel.Position = [359 498 201 22];
            app.SelectNumberofNamesDisplayedLabel.Text = 'Select Number of Names Displayed:';

            % Create SelectNumberofNamesDisplayedSlider
            app.SelectNumberofNamesDisplayedSlider = uislider(app.PopularNamesbyBirthYearTab);
            app.SelectNumberofNamesDisplayedSlider.MajorTicks = [0 10 20 30 40 50 60 70 80 90 100];
            app.SelectNumberofNamesDisplayedSlider.Orientation = 'vertical';
            app.SelectNumberofNamesDisplayedSlider.ValueChangingFcn = createCallbackFcn(app, @SelectNumberofNamesDisplayedSliderValueChanging, true);
            app.SelectNumberofNamesDisplayedSlider.Tooltip = {'Slide to 0 to reset'};
            app.SelectNumberofNamesDisplayedSlider.Position = [516 109 3 377];

            % Create TextArea
            app.TextArea = uitextarea(app.PopularNamesbyBirthYearTab);
            app.TextArea.FontSize = 16;
            app.TextArea.Enable = 'off';
            app.TextArea.Position = [20 10 451 476];

            % Create Label
            app.Label = uilabel(app.PopularNamesbyBirthYearTab);
            app.Label.Position = [193 498 76 22];
            app.Label.Text = '(1880 - 2017)';

            % Create PopularityofNamesoverTimeTab
            app.PopularityofNamesoverTimeTab = uitab(app.TabGroup);
            app.PopularityofNamesoverTimeTab.Title = 'Popularity of Names over Time';

            % Create EnterNametoPlotPopularityLabel
            app.EnterNametoPlotPopularityLabel = uilabel(app.PopularityofNamesoverTimeTab);
            app.EnterNametoPlotPopularityLabel.Position = [22 499 168 22];
            app.EnterNametoPlotPopularityLabel.Text = 'Enter Name to Plot Popularity:';

            % Create EnterNametoPlotPopularityEditField
            app.EnterNametoPlotPopularityEditField = uieditfield(app.PopularityofNamesoverTimeTab, 'text');
            app.EnterNametoPlotPopularityEditField.ValueChangedFcn = createCallbackFcn(app, @EnterNametoPlotPopularityEditFieldValueChanged, true);
            app.EnterNametoPlotPopularityEditField.ValueChangingFcn = createCallbackFcn(app, @EnterNametoPlotPopularityEditFieldValueChanging, true);
            app.EnterNametoPlotPopularityEditField.Tooltip = {'First Name Only'};
            app.EnterNametoPlotPopularityEditField.Position = [196 498 164 22];

            % Create EnterButton
            app.EnterButton = uibutton(app.PopularityofNamesoverTimeTab, 'push');
            app.EnterButton.ButtonPushedFcn = createCallbackFcn(app, @EnterButtonPushed, true);
            app.EnterButton.BusyAction = 'cancel';
            app.EnterButton.Interruptible = 'off';
            app.EnterButton.Position = [397 465 88 22];
            app.EnterButton.Text = 'Enter';

            % Create ClearButton
            app.ClearButton = uibutton(app.PopularityofNamesoverTimeTab, 'push');
            app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
            app.ClearButton.Position = [508 465 88 22];
            app.ClearButton.Text = 'Clear';

            % Create UIAxes
            app.UIAxes = uiaxes(app.PopularityofNamesoverTimeTab);
            title(app.UIAxes, 'Popularity of Names')
            xlabel(app.UIAxes, 'Year')
            ylabel(app.UIAxes, 'Number of Occurrence')
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.Position = [22 1 574 345];

            % Create Label_2
            app.Label_2 = uilabel(app.PopularityofNamesoverTimeTab);
            app.Label_2.HorizontalAlignment = 'center';
            app.Label_2.FontSize = 16;
            app.Label_2.Position = [22 435 574 22];
            app.Label_2.Text = '';

            % Create TextArea_2
            app.TextArea_2 = uitextarea(app.PopularityofNamesoverTimeTab);
            app.TextArea_2.Enable = 'off';
            app.TextArea_2.Position = [22 361 574 60];

            % Create SelectGenderDropDownLabel
            app.SelectGenderDropDownLabel = uilabel(app.PopularityofNamesoverTimeTab);
            app.SelectGenderDropDownLabel.Position = [398 498 86 22];
            app.SelectGenderDropDownLabel.Text = 'Select Gender:';

            % Create SelectGenderDropDown
            app.SelectGenderDropDown = uidropdown(app.PopularityofNamesoverTimeTab);
            app.SelectGenderDropDown.Items = {'-', 'Male', 'Female'};
            app.SelectGenderDropDown.ItemsData = {'0', 'M', 'F'};
            app.SelectGenderDropDown.Position = [508 498 88 22];
            app.SelectGenderDropDown.Value = '0';

            % Create EntertheRangeofBirthYearSpinnerLabel
            app.EntertheRangeofBirthYearSpinnerLabel = uilabel(app.PopularityofNamesoverTimeTab);
            app.EntertheRangeofBirthYearSpinnerLabel.Position = [22 465 164 22];
            app.EntertheRangeofBirthYearSpinnerLabel.Text = 'Enter the Range of Birth Year:';

            % Create EntertheRangeofBirthYearSpinner
            app.EntertheRangeofBirthYearSpinner = uispinner(app.PopularityofNamesoverTimeTab);
            app.EntertheRangeofBirthYearSpinner.Limits = [1880 2017];
            app.EntertheRangeofBirthYearSpinner.ValueDisplayFormat = '%4d';
            app.EntertheRangeofBirthYearSpinner.HorizontalAlignment = 'center';
            app.EntertheRangeofBirthYearSpinner.Tooltip = {'Enter the Starting Year (From 1880)'};
            app.EntertheRangeofBirthYearSpinner.Position = [196 465 65 22];
            app.EntertheRangeofBirthYearSpinner.Value = 1880;

            % Create toSpinnerLabel
            app.toSpinnerLabel = uilabel(app.PopularityofNamesoverTimeTab);
            app.toSpinnerLabel.Position = [273 465 25 22];
            app.toSpinnerLabel.Text = 'to';

            % Create toSpinner
            app.toSpinner = uispinner(app.PopularityofNamesoverTimeTab);
            app.toSpinner.Limits = [1880 2017];
            app.toSpinner.Tooltip = {'Enter the endding year (Before 2018)'};
            app.toSpinner.Position = [295 465 65 22];
            app.toSpinner.Value = 2017;

            % Show the figure after all components are created
            app.BabyNameTrendsUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = BabyNameTrends

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.BabyNameTrendsUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.BabyNameTrendsUIFigure)
        end
    end
end