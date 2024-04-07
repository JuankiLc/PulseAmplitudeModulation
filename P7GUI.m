%-------------------------------------------------------------------------%
%                                                                         %
%            PRÁCTICA 7 DE TEORÍA DE LA COMUNICACIÓN (2018/2019)          %
%                'Simulación de sistemas PAM'             %
%                                                                         %
%-------------------------------------------------------------------------%
close all
clear
global isOctave;
isOctave = 0;
% Comprobación para ver si se está utilizando Octave o Matlab
if exist('pkg') == 2
    isOctave = 1;
    pkg load communications % Load Octave communications toolbox.
    pkg load signal % Load Octave communications toolbox.
end

h.figure = figure('Units', 'normalized','Position', [0.0 0.0 1.0 0.9]);
p = uipanel ('title', 'Params', 'units','normalized','Position', [.0 0.0 0.10 1.0]);
h.axes1 = axes('units', 'normalized','Position',[0.0,0.0, 1.0,0.9]);

h.labelTo = uicontrol('parent',p,'style','text', 'string','To (%)', ...
            'units', 'normalized','position',[0 0.80 0.5 0.05]);
h.tos = {'0','5','10','15','20','25','30','35','40','45','50','55','60','65','70','75','80','85','90','95','100'};
h.controlTo = uicontrol('parent',p,'style','popupmenu', ...
            'value',6, 'String', h.tos, 'callback', @P7_callback, ...
            'units', 'normalized','position', [0 0.70 1 0.05]); 

h.labelFs = uicontrol('parent',p,'style','text', 'string','fs (Hz))', ...
            'units', 'normalized','position',[0 0.6 0.5 0.05]);
h.freqs = {'200','300','400','500','600','700','800','900','1000','1100','1200','1300','1400','1500'};
h.controlFs = uicontrol('parent',p,'style','popupmenu', ...
            'value',4, 'String', h.freqs, 'callback', @P7_callback, ...
            'units', 'normalized','position', [0 0.55 1 0.05]);      
        
h.xrange = 1:20; %// Dummy data.
guidata(h.figure, h);
P7_callback(gcf, 0, true);