%ENGR 105
%Byung Joon An (Pennkey: byungan)
%05/03/17
%Final Project
%Blackjack

%Collaboration Comment: None
%% Game Logic
function varargout = bjgameplay(varargin)
rng('shuffle'); %shuffle deck

% Begin initilization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bjgameplay_OpeningFcn, ...
                   'gui_OutputFcn',  @bjgameplay_OutputFcn, ...
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




% --- Executes just before bjgameplay is made visible.
function bjgameplay_OpeningFcn(hObject, eventdata, handles, varargin)

handles.curr.String = varargin{1}.current.Value;
% Choose default command line output for bjgameplay
handles.output = hObject;
% Update handles structure
global stat; %array to keep track of wins/losses/ties
stat = [];

guidata(hObject, handles);
uicontrol(handles.betText); %bring focus to edit text "bet"
handles.hitButton.Visible = 'Off'; %disable any action by user until bet is placed
handles.standButton.Visible = 'Off';
category = categorical(stat,[0 1 2],{'Losses','Wins','Tie'});
handles.barGraph = histogram(category); %empty histogram


% --- Outputs from this function are returned to the command line.
function varargout = bjgameplay_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function betText_Callback(hObject, eventdata, handles)
global bet; %set the bet amount from the edit text field
bet = str2double(get(hObject,'String'));




% --- Executes during object creation, after setting all properties.
function betText_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global bet;
bet = 0; %initially set the bet amount to 0


% --- Executes on button press in dealButton.
function dealButton_Callback(hObject, eventdata, handles)

global bet;
holdings = str2double(handles.curr.String);
if (bet > holdings)
    msgbox('You do not have enough money!'); %let the user bet up to the current holdings
elseif (bet == 0)
    msgbox('You have to bet something!'); %if the user hasn't bet anything
else
    handles.curr.String = holdings - bet; %place the bet on the table
    hit(handles); %simulate a deal to the user
    handles.betPanel.Visible = 'Off'; %remove the betting prompt from the screen
    handles.flippedPanel.Visible = 'On'; %display the most recently drawn card
    handles.hitButton.Visible = 'On'; %enable user action
    handles.standButton.Visible = 'On';
end


% --- Executes when user wants to quit the game
function quitButton_Callback(hObject, eventdata, handles)
quit = questdlg('Are you sure?');
if (quit == 'Yes')
    close(handles.figure1);
end


% --- Executes when user wants to hit
function hitButton_Callback(hObject, eventdata, handles)

hit(handles);


% --- Executes when user wants to stand
function standButton_Callback(hObject, eventdata, handles)

simulateDealer(handles); %let the dealer simulate
handles.flipped.String = 0; 
finish(handles); %compare results

%--- Executes to simulate a deal to the user
function drawn = hit(handles)
val = mod(int8(rand * 52), 13) + 1; %draw a random card
if (val == 11) 
    drawn = 'J';
    val = 10;
elseif (val == 12)
    drawn = 'Q';
    val = 10;
elseif (val == 13)
    drawn = 'K';
    val = 10;
elseif (val == 1)
    drawn = 'A';
    val = 10;
else
    drawn = val;
end
handles.flipped.String = drawn; %display the most recently drawn card
updated = str2double(handles.player.String) + val; 
handles.player.String = updated; %update user's current deck value

if (updated > 21) % overdrawn
    finish(handles);
end
    
%--- Executes to compare results between user and the dealer
function finish(handles) 
global bet;
global stat;
persistent category;
holdings = str2double(handles.curr.String); 
pHand = str2double(handles.player.String);
dHand = str2double(handles.dealer.String);

if (pHand > 21) %dealer wins
    win = 0;
elseif (dHand > 21) %user wins
    win = 1;
elseif (pHand > dHand)
    win = 1;
elseif (pHand < dHand) %dealer wins
    win = 0;
elseif (pHand == dHand) %tie
    win = 2;
end
    

if (win == 0)
    uiwait(msgbox('Dealer wins!'));
    stat = [stat, 0];
elseif (win == 1)
    uiwait(msgbox('Player wins!'));
    handles.curr.String = holdings + (2*bet);
    stat = [stat, 1];
elseif (win == 2)
    uiwait(msgbox('It is a tie!'));
    handles.curr.String = holdings + bet;
    stat = [stat, 2];
end

%for histogram
category = categorical(stat,[0 1 2],{'Losses','Wins','Tie'});

% reset table
handles.player.String = 0;
handles.dealer.String = 0;
handles.flipped.String = 0;

%prompt the user to bet
handles.flippedPanel.Visible = 'Off';
handles.betPanel.Visible = 'On';
handles.hitButton.Visible = 'Off';
handles.standButton.Visible = 'Off';

%update histogram
handles.barGraph = histogram(category, 'BarWidth', 0.5);

%user runs out of money
if (str2double(handles.curr.String) == 0)
    uiwait(msgbox('You are out of money. You will be kicked out to the lobby'));
    close(handles.figure1);
    byungan_blackjack(); %navigate to main menu
end
rng('shuffle'); %shuffle deck upon finishing round


%--- Executes a simulation of the dealer
function simulateDealer(handles)
current = 0;
handles.sim.Visible = 'On'; %display the simulating... message
while (current < 21)
    val = mod(int8(rand * 52), 13) + 1;
    
    if (val == 11)
        val = 10;
    elseif (val == 12)
        val = 10;
    elseif (val == 13)
        val = 10;
    elseif (val == 1)
        val = 10;
    end
    
    if (current > str2double(handles.player.String))
        handles.sim.Visible = 'Off';
        return;
    end
    if (current + val < 21) %keep dealing as long as deck remains < 21
        current = current + val;
        handles.dealer.String = current;
    else %dealer's current deck and the drawn card exceed 21
        chance = rand;
        if (chance < 0.3) % 30% chance that dealer draws the card anyway
            current = current + val;
            handles.dealer.String = current;
        end
        handles.sim.Visible = 'Off';
        %dealer automatically loses.
        return;
    end
    pause(1);
end
