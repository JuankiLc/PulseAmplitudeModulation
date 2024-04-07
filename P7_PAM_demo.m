function [m, m_rec] = P7_PAM_demo(h, init, argTo, fs_pam)
%   P7_PAM_demo estudio de la modulación PAM
%   P7_PAM_demo(fs_pam, T) genera una modulación PAM tomando fs_param muestras por segundo
%   utilizando pulsos rectangulares de T segundos de duración.
%   La señal procesada es m(t)= 1/2+cos(2*pi*50*t)+cos(2*pi*90*t);

%   Genera unas representaciones gráficas de las señales.
% 

% Copyright 1984-2016 Teoría de la comunicación
% ETSIT Valladolid
% @author Juan Pablo de Castro jpdecastro@tel.uva.es
% @param fs_pam frecuencia de muestreo PAM
% @param T duración del pulso conformador
% @return señal modulada y señal demodulada
% close all;
global isOctave;
dur = 0.2;
up_ratio = 200; % upsampling
%fs_pam = 1000; % PAM sampling freq
Ts_pam = 1/fs_pam;
T = Ts_pam * argTo % lenght in seconds of pam pulse

Tratio = T / Ts_pam;
fs2 = fs_pam * up_ratio; % Sampling freq for upsampled signals.

t = linspace(0,dur,dur*fs2);

% pulse
pulsewidth = max(1,round(up_ratio * Tratio)); % length in samples of pam pulse
pulse = [ones(1, pulsewidth) zeros(1, length(t) - pulsewidth)];
%signal
%m = 1/2+cos(2*pi*200*t)+cos(2*pi*360*t);
m = sin(400*pi*t)/(400*pi*t);
m_sampled = upsample(downsample(m, up_ratio), up_ratio);
m_sampled = m_sampled(1:length(m));
s_pam = filter(pulse, 1, m_sampled);
s_pam = s_pam(1:length(m));
% frequency domain
f_m = fftshift(fft(m))/length(m);
faxis1 = linspace(-fs2/2, fs2/2, length(f_m));
f_m_samp =  fs2 * fftshift(fft(m_sampled))/length(m_sampled);
f_pam = fftshift(fft(s_pam))/length(s_pam);
f_pulse = fftshift(fft(pulse))/length(pulse);
faxis = linspace(-fs2/2, fs2/2, length(f_pam));
% Filter
f_idealfilter = zeros(1, length(faxis));
f_idealfilter(abs(faxis) < fs_pam/2) = Ts_pam /T;
f_pam_filtered = f_pam .* f_idealfilter;
m_rec = fft(fftshift(f_pam_filtered));
pot = sum(m.^2);
err = sum((abs(m-m_rec)).^2);
snr = pot/err
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gráficas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
figure(h.figure);
    set(h.figure, 'defaultlinelinewidth', 1.5);
    set (h.figure, 'defaulttextfontsize', 12);
    set (h.figure, 'defaultaxesfontsize', 12);
    hold off;
subplot(3,1,1);
    plot(t, m', t, s_pam', 'r-');
    title('m(t) y s_{PAM}(t)');
    axis([0 dur/10 -2 3]);
    grid;
    grid MINOR;
if isOctave == 0
    leg1 = legend('$m(t)$','$s_{PAM}(t)$');
    set(leg1,'Interpreter','latex');
else
    leg1 = legend('m(t)','s_{PAM}(t)');
    set(leg1,'Interpreter','tex');
end
% Plot FFT of S
subplot(3,4,5);
    plot(faxis1, abs(f_m));
    title('|M(f)|');
    axis([0 2*fs_pam 0 1  ]);
    grid;
    grid MINOR;
if isOctave == 0
    leg1 = legend('$\left|M(f)\right|$');
    set(leg1,'Interpreter','latex');
else
    leg1 = legend('|M(f)|');
    set(leg1,'Interpreter','tex');
end

%%%%%%%%%%%%%%%%%%%%
% M \delta
%%%%%%%%%%%%%%%%%%%%
subplot(3,4,6);
if isOctave == 0
    yyaxis left;
        plot(faxis, abs(f_m_samp));
       
       %axis([0 1.5/T 0 1*fs_pam]);
        axis([0 3*fs_pam 0 1*fs_pam]);
    yyaxis right;
        plot(faxis, abs(f_pulse), '-.');
    %ylim([0 1.5*T]);
    leg1 = legend('$\left|M_\delta(f)\right|$','$\left|P(f)\right|$');
    set(leg1,'Interpreter','latex');
else
    % plotyy for Ostave compatibility.
    ax = plotyy(faxis, abs(f_m_samp), faxis, abs(f_pulse)); % TODO graph with
    xlabel("f")
    axis(ax(1), [0 3*fs_pam 0 1*fs_pam]);
    axis(ax(2), [0 3*fs_pam]);% 0 1*fs_pam]);
    leg1 = legend('|M_\delta(f)|','|P(f)|');
    set(leg1,'Interpreter','tex');
end
grid;
grid MINOR;
title('|M_\delta(f)|');


%%%%%%%%%%%%%%%%%%%%
% S_PAM(f)
%%%%%%%%%%%%%%%%%%%%
subplot(3,4,7);
if isOctave == 0
    xlim([0 3*fs_pam]);
    yyaxis left;
    plot(faxis, abs(f_pam));
    %axis([0 1.5/T 0 0.5]);
    %axis([0 3*fs_pam 0 0.5]);
    yyaxis right;
    plot(faxis, abs(f_pulse), '-.');
    %ylim([0 T*8]);
    leg1 = legend('$\left|S_{PAM}(f)\right|$','$\left|P(f)\right|$');
    set(leg1,'Interpreter','latex');
else
    % plotyy for Octave compatibility.
    ax = plotyy(faxis, abs(f_pam), faxis, abs(f_pulse));
    xlabel("f")
    axis(ax(1), [0 3*fs_pam 0 0.5]);
    axis(ax(2), [0 3*fs_pam]); %0 2/fs_pam]);
    leg1 = legend('|S_{PAM}(f)|','|P(f)|');
    set(leg1,'Interpreter','tex');
end
grid;
grid MINOR;
title('|S_{PAM}(f)|');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % S_PAM filtrado
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,4,8);
if isOctave == 0
    yyaxis left;
    plot(faxis, abs(f_pam_filtered));
    yyaxis right;
    plot( faxis, f_idealfilter);
    xlim([0 2*fs_pam]);% 0 0.7 ]);
    leg1 = legend('$\left|S_{PAM}(f)H_{rec}(f)\right|$','$\left|H_{rec}(f)\right|$');
    set(leg1,'Interpreter','latex');
else
     % plotyy for Octave compatibility.
    ax = plotyy(faxis, abs(f_pam_filtered), faxis,  f_idealfilter);
    xlabel("f")
    axis(ax(1), [0 2*fs_pam]); %0 0.5]);
    axis(ax(2), [0 2*fs_pam]); %0 2/fs_pam]);
    leg1 = legend('|S_{PAM}(f)H_{rec}(f)|','|H_{rec}(f)|');
    set(leg1,'Interpreter','tex');
end

grid;
grid MINOR;
title('|S_{PAM}(f) · H_{rec}(f)|');

subplot(3,1,3);
delay = floor(pulsewidth/2);
m_rec = real([zeros(1, delay) m_rec(1:length(m_rec)-delay)]);

plot(t, [m', m_rec']);
if isOctave == 0
  tit = title('$m(t)$ y $\tilde{m}(t)$');
  set(tit,'Interpreter','latex');
else
  tit = title('m(t) y m^{~}(t) (reconstruida)');
  set(tit,'Interpreter','tex');
end
axis([0 dur/10 -2 3]);
grid;
grid MINOR;

