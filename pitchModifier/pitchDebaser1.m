function varargout = pitchDebaser1(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pitchDebaser1_OpeningFcn, ...
                   'gui_OutputFcn',  @pitchDebaser1_OutputFcn, ...
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
end

function pitchDebaser1_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
end

function varargout = pitchDebaser1_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
end



function select_Callback(~, ~, handles)
global x Fs filename y;
[filename, pathname] = uigetfile({'*.*'},'Select File:');

if isequal(filename,0)
    set(handles.text,'string','Users Selected Canceled');
else
    [x,Fs] = audioread([pathname filename]);
    y = x;
    set(handles.text,'string',{'File loaded: '; filename})
end
end

function stop_Callback(~, ~, ~)
clear sound;
end

function modify_Callback(~, ~, handles)
global x y filename text
k = str2double(get(handles.edit, 'string'));
text='Computing result of '+string(k)+' semitones debase from: ';
set(handles.text,'string',{text; filename});
f = 2^(k/12);    % ratio of audios, >1 low freq output
y = voiceapprox(x(:,1),f);
y=y./max(abs(y));
text=string(k)+' semitones debase from: ';
set(handles.text,'string',{'Computation completed of '+text; filename});
end

function play_Callback(~, ~, handles)
global y Fs filename text;
clear sound;sound(y,Fs);
set(handles.text,'string',{'Audio playing: '+text;filename});
end

function save_Callback(~, ~, handles)
global y Fs;
[FN, PN] = uiputfile({'*.wav','wav(*.wav)'},'Save File:','Untitled');
if FN == 0
    return;
else
    set(handles.text,'string',{'Audio saving: ';FN});
    audiowrite([PN, FN],y,Fs);
    set(handles.text,'string',{'Audio saved: ';FN});
end
end

function edit_Callback(~, ~, ~)
end

function edit_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit5_Callback(~, ~, ~)
end

function text_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
