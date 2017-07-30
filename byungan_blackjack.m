%ENGR 105
%Byung Joon An (Pennkey: byungan)
%05/03/17
%Final Project
%Blackjack

%Collaboration Comment: None
%% Main Menu
function varargout = byungan_blackjack(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @byungan_blackjack_OpeningFcn, ...
                   'gui_OutputFcn',  @byungan_blackjack_OutputFcn, ...
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


% --- Executes just before byungan_blackjack is made visible.
function byungan_blackjack_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
% background image
matlabImage = imread('hqdefault.jpg');
image(matlabImage)
axis off
axis image

uicontrol(handles.current);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = byungan_blackjack_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function current_Callback(hObject, eventdata, handles)

handles.current.Value = str2double(get(hObject,'String'));



% --- Executes during object creation, after setting all properties.
function current_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Start the game on button press
function startButton_Callback(hObject, eventdata, handles)

if (handles.current.Value <= 0)
    uiwait(msgbox('You need to buy in to the table first!!!'));
else
    bjgameplay(handles);
    close(handles.figure1);
end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
%set values for user's holdings
handles.current.Value = floor(get(hObject,'Value') * 10000);
handles.current.String = floor(get(hObject,'Value') * 10000);



% --- Slider to adjust buy-in amount by the user
function slider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
