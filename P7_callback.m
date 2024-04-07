%-------------------------------------------------------------------------%
%                                                                         %
%            PRÁCTICA 7 DE TEORÍA DE LA COMUNICACIÓN                      %
%                'Simulación de sistemas PAM'                             %
%                                                                         %
%-------------------------------------------------------------------------%
function P7_callback (obj, control, init)
  h=guidata(obj);
  recalc = true;
  if (nargin == 2)
      init = false;
  end
  if (recalc || init)
    % Inicialización de variables
    To=80;
    Fs=1000;
    if (init == false)
      toidx = get(h.controlTo,'Value');
      To = str2num(cell2mat(h.tos(toidx)))
      fsidx = get(h.controlFs,'Value');
      Fs = str2num(cell2mat(h.freqs(fsidx)))
    end

    set(h.controlFs, 'value', find(strcmp(h.freqs, num2str(Fs))));
    set(h.controlTo, 'value', find(strcmp(h.tos, num2str(To))));

    P7_PAM_demo(h, init, To/100, Fs);
  end
end