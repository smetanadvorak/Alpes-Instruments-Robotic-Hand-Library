function menuTension

%---variales---

valTension=0;
valCourant=0;
doigt=6;
%------------main gauche-----------------------------------------
delete(instrfindall) ;
s1=serial('COM11');
fclose(s1);
delete(s1);
clear s1;
s1=serial('COM4');
set(s1, 'BaudRate',460800,'DataBits',8,'StopBits',1,...
    'Parity','none','FlowControl','none','TimeOut',1);
fopen(s1);




fig = figure('Name','mode tension','NumberTitle','off','Resize','off','MenuBar','none','Position',[300,300,600,200]);
set(fig,'color',[1 1 1]);
uicontrol('Style','checkbox','String','start','position',[500 50 100 30],'Callback',@move)


uicontrol('Style','text','String','tension',...
    'Position',[240 100 60 20],...
    'Callback',@EditCallBack_Courant);

tension_edit=uicontrol('Style','edit','String','0',...
    'Position',[500 100 60 20],...
    'Callback',@EditCallBack_tension);

tension_Slider=uicontrol('Style','slider','Max',1150,'Min',-1150,'value',0,...
    'SliderStep',[0.01150 0.1],'Position',[300 100 200 20],...
    'Callback',@SliderCallBack_tension);



uicontrol('Style', 'popup',...
    'String', {'seletion du doigt','rotation pouce','pouce','index','majeur','annulaire','auriculaire'},...
    'Position', [50 100 115 50],...
    'Callback', @choix_doigt);



uicontrol('Style','text','String','courant',...
    'Position',[240 130 60 20],...
    'Callback',@EditCallBack_Courant);

courant_edit=uicontrol('Style','edit','String','0',...
    'Position',[500 130 60 20],...
    'Callback',@EditCallBack_Courant);

courant_Slider=uicontrol('Style','slider','Max',3000,'Min',0,'value',0,...
    'SliderStep',[0.03000 0.1],'Position',[300 130 200 20],...
    'Callback',@SliderCallBack_courant);




    function choix_doigt(hObject,varargin)
        index_selected = get(hObject,'Value');
        if ( index_selected==2)
            doigt=0;
        end
        if ( index_selected==3)
            doigt=1;
        end
        if ( index_selected==4)
            doigt=2;
        end
        if ( index_selected==5)
            doigt=3;
        end
        if ( index_selected==6)
            doigt=4;
        end
        if ( index_selected==7)
            doigt=5;
        end
    end

    function EditCallBack_Courant(hObject,varargin)
        val=str2double(get(hObject,'String'));
        
         if length(val) == 1 && val <=3000 && val >=0
            set(courant_Slider,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [0,21000]','Error','error','modal');
        end
        if (val>=0) && (val<=3000) %<-- normalement 36000 mais ne pas prendre de risque
            valCourant=val;
        end
    end


    function SliderCallBack_courant(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(courant_edit, 'String', num2str(val));
        valCourant=val;
    end

    function EditCallBack_tension(hObject,varargin)
        val=str2double(get(hObject,'String'));
         if length(val) == 1 && val <=1150 && val >=-1150
            set(tension_Slider,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [-1150,1150]','Error','error','modal');
        end
            
            if val>-1150 && val<1150
                valTension=val;
            end
    end

    function SliderCallBack_tension(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(tension_edit, 'String', num2str(val));
        valTension=val;
    end


    function move(hObject,varargin)
        while (get(hObject,'Value') == get(hObject,'Max'))
            mode_tensionDoigt(valTension,valCourant,doigt,s1);
            disp(10.35*(valCourant*75/36000));
            pause(0.02)
        end
    end




end

