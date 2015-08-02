function varargout = PlottingGUI(varargin)
%PLOTTINGGUI M-file for PlottingGUI.fig
%
%   PLOTTINGGUI, by itself, creates a new PLOTTINGGUI or raises the existing
%   singleton*.
%
%   H = PLOTTINGGUI returns the handle to a new PLOTTINGGUI or the handle to
%   the existing singleton*.
%
%   PLOTTINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in PLOTTINGGUI.M with the given input arguments.
%
%   PLOTTINGGUI('Property','Value',...) creates a new PLOTTINGGUI or raises the
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before PlottingGUI_OpeningFcn gets called.  An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to PlottingGUI_OpeningFcn via varargin.
%
%   *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%   instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlottingGUI

% Last Modified by GUIDE v2.5 04-Apr-2010 10:32:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlottingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PlottingGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PlottingGUI is made visible.
function PlottingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlottingGUI (see VARARGIN)

% Choose default command line output for PlottingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% status = get(handles.chkBox, 'Value');

% Set 'show grid' checkbox to checked
set(handles.chkBox, 'Value', 1)

% This sets up the initial plot - only do when we are invisible
% so window can get raised using PlottingGUI.
if strcmp(get(hObject,'Visible'),'off')
    set(handles.axes1, 'FontSize', 0.05, 'Color', [0.95 0.96 0.95]);
    plot(rand(5));
end

elements = get(handles.popupmenu1, 'String');
index = get(handles.popupmenu1, 'Value');
element = elements{index};

set(handles.txtEditListItem, 'String', element);


% UIWAIT makes PlottingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PlottingGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Call custom function to render the plot
CreatePlot(handles);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end


% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)


% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
elements = get(hObject, 'String');
index = get(hObject, 'Value');
element = elements{index};

set(handles.txtEditListItem, 'String', element);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', ...
    'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on button press in chkGrid.
function chkGrid_Callback(hObject, eventdata, handles)
% hObject    handle to chkGrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkGrid
status = get(hObject, 'Value');
if status
    grid on
else
    grid off
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in chkBox.
function chkBox_Callback(hObject, eventdata, handles)
% hObject    handle to chkBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkBox
status = get(hObject, 'Value');
if status
    box on
else
    box off
end


function txtEditListItem_Callback(hObject, eventdata, handles)
% hObject    handle to txtEditListItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtEditListItem as text
%        str2double(get(hObject,'String')) returns contents of
%        txtEditListItem as a double

% Call custom function to render the plot
CreatePlot(handles);


% --- Executes during object creation, after setting all properties.
function txtEditListItem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtEditListItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on popupmenu1 and none of its controls.
function popupmenu1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu1.
function popupmenu1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cmdClearPlot.
function cmdClearPlot_Callback(hObject, eventdata, handles)
% hObject    handle to cmdClearPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold off;
cla;


% --- Custom function that creates the plot.
function CreatePlot(handles)
%axes(handles.axes1);
%cla;

%popup_sel_index = get(handles.popupmenu1, 'Value');
%switch popup_sel_index
%    case 1
%        plot(rand(5));
%    case 2
%        plot(sin(1:0.01:25.99));
%    case 3
%        bar(1:.5:10);
%    case 4
%        plot(membrane);
%    case 5
%        surf(peaks);
%end

element = get(handles.txtEditListItem, 'String');

if size(strtrim(element)) > 0
    try
        ret = eval(element);
    catch
       cla;
    end
    
    %if size(ret) > 1
    %    set(handles.tableData,'ColumnWidth', {25})
    %    set(handles.tableData, 'Data', a);
    %end
end

status = get(handles.chkGrid, 'Value');

if status
    grid on
else
    grid off
end

status = get(handles.chkBox, 'Value');

if status
    box on
else
    box off
end


% --- Executes on key press with focus on txtEditListItem and none of its controls.
function txtEditListItem_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to txtEditListItem (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

keyPressed = get(hObject, 'Key');
