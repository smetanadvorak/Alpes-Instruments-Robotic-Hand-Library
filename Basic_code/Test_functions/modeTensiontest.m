
function modeTensiontest

%
%présnetation du programme:
%premiere partie variable avec en bas de cette partie une variable que 
%l'on peux changer manuellement courantMax mis actuellement à 3500 mais
%peux aller à 36 000
%deuxieme partie interphace graphique
%troisieme partie fonction reliant l'interphace a la main
%chaque fonction est repeter 6 fois (1 pour chaque doigt)
%l'ecriture est lourde mais l'execution est plus rapide comme cela
%

%%
%------------------variables-------------------------

%modifiées par appuis sur les boutons

%menu deroulant choix de la main
port_com='';


%slider et edit box
valTensionPouce=0;
valCourantPouce=0;
valTensionRpouce=0;
valCourantRpouce=0;
valTensionIndex=0;
valCourantIndex=0;
valTensionMajeur=0;
valCourantMajeur=0;
valTensionAnnulaire=0;
valCourantAnnulaire=0;
valTensionAuriculaire=0;
valCourantAuriculaire=0;
valTensionMano=0;
valCourantMano=0;


%check box pour chaque doigt
activate_pouce=0;
activate_Rpouce=0;
activate_index=0;
activate_majeur=0;
activate_annulaire=0;
activate_auriculaire=0;
activate_mano=0;

%%

%valeur à changer pour augmenter la limite de courant Max 750
courantMax=750;
%%

%création de la figure
fig = figure('Name','mode tension','NumberTitle','off','Resize','off','MenuBar','none','Position',[300,50,800,650]);
set(fig,'color',[1 1 1]);

%check box start
uicontrol('Style','toggle','String','start','position',[400 40 100 30],'Callback',@Callback_start)

%menu déroulant selection de la main
uicontrol('Style', 'popup',...
    'String', {'seletion de la main','main droite','main gauche'},...
    'Position', [20 250 115 50],...
    'Callback', @choix_main);

uicontrol('style','pushbutton','String','mise à zero','position',[570 100 60 20],'Callback',@Callback_RAZPouce);
uicontrol('style','pushbutton','String','mise à zero','position',[570 180 60 20],'Callback',@Callback_RAZRpouce);
uicontrol('style','pushbutton','String','mise à zero','position',[570 260 60 20],'Callback',@Callback_RAZIndex);
uicontrol('style','pushbutton','String','mise à zero','position',[570 340 60 20],'Callback',@Callback_RAZMajeur);
uicontrol('style','pushbutton','String','mise à zero','position',[570 420 60 20],'Callback',@Callback_RAZAnnulaire);
uicontrol('style','pushbutton','String','mise à zero','position',[570 500 60 20],'Callback',@Callback_RAZAuriculaire);
uicontrol('style','pushbutton','String','mise à zero','position',[570 580 60 20],'Callback',@Callback_RAZMano);


%------------------CLASSEMENT DES DOIGTS------

%%Pouce

Pouce1=uicontrol('Style','checkbox','String','activer','position',[570 125 100 30],'Callback',@activatePouce);

uicontrol('Style','text','String','pouce',...
    'Position',[180 115 60 20]);


uicontrol('Style','text','String','tension',...
    'Position',[240 100 60 20]);

uicontrol('Style','text','String','courant',...
    'Position',[240 130 60 20],...
    'Callback',@EditCallBack_Courant);

courant_edit_pouce=uicontrol('Style','edit','String','0',...
    'Position',[500 130 60 20],...
    'Callback',@EditCallBack_CourantPouce);

courant_Slider_pouce=uicontrol('Style','slider','Max',courantMax,'Min',0,'value',0,...
    'SliderStep',[0.0750 0.1],'Position',[300 130 200 20],...
    'Callback',@SliderCallBack_courantPouce);

tension_edit_pouce=uicontrol('Style','edit','String','0',...
    'Position',[500 100 60 20],...
    'Callback',@EditCallBack_tensionPouce);

tension_Slider_pouce=uicontrol('Style','slider','Max',1150,'Min',-1150,'value',0,...
    'SliderStep',[0.01150 0.1],'Position',[300 100 200 20],...
    'Callback',@SliderCallBack_tensionPouce);

%%rotation pouce

Rpouce1=uicontrol('Style','checkbox','String','activer','position',[570 205 100 30],'Callback',@activateRpouce);

uicontrol('Style','text','String','rotation pouce',...
    'Position',[160 195 80 20]);

uicontrol('Style','text','String','tension',...
    'Position',[240 180 60 20]);

uicontrol('Style','text','String','courant',...
    'Position',[240 210 60 20],...
    'Callback',@EditCallBack_Courant);

courant_edit_Rpouce=uicontrol('Style','edit','String','0',...
    'Position',[500 210 60 20],...
    'Callback',@EditCallBack_CourantRpouce);

courant_Slider_Rpouce=uicontrol('Style','slider','Max',courantMax,'Min',0,'value',0,...
    'SliderStep',[0.07500 0.1],'Position',[300 210 200 20],...
    'Callback',@SliderCallBack_courantRpouce);

tension_edit_Rpouce=uicontrol('Style','edit','String','0',...
    'Position',[500 180 60 20],...
    'Callback',@EditCallBack_tensionRpouce);

tension_Slider_Rpouce=uicontrol('Style','slider','Max',1150,'Min',-1150,'value',0,...
    'SliderStep',[0.01150 0.1],'Position',[300 180 200 20],...
    'Callback',@SliderCallBack_tensionRpouce);

%%Index

Index1=uicontrol('Style','checkbox','String','activer','position',[570 285 100 30],'Callback',@activateIndex);

uicontrol('Style','text','String','index',...
    'Position',[180 275 60 20]);

uicontrol('Style','text','String','tension',...
    'Position',[240 260 60 20]);

uicontrol('Style','text','String','courant',...
    'Position',[240 290 60 20]);

courant_edit_index=uicontrol('Style','edit','String','0',...
    'Position',[500 290 60 20],...
    'Callback',@EditCallBack_CourantIndex);

courant_Slider_index=uicontrol('Style','slider','Max',courantMax,'Min',0,'value',0,...
    'SliderStep',[0.07500 0.1],'Position',[300 290 200 20],...
    'Callback',@SliderCallBack_courantIndex);

tension_edit_index=uicontrol('Style','edit','String','0',...
    'Position',[500 260 60 20],...
    'Callback',@EditCallBack_tensionIndex);

tension_Slider_index=uicontrol('Style','slider','Max',1150,'Min',-1150,'value',0,...
    'SliderStep',[0.01150 0.1],'Position',[300 260 200 20],...
    'Callback',@SliderCallBack_tensionIndex);


%%Majeur

Majeur1=uicontrol('Style','checkbox','String','activer','position',[570 365 100 30],'Callback',@activateMajeur);

uicontrol('Style','text','String','majeur',...
    'Position',[180 355 60 20]);

uicontrol('Style','text','String','tension',...
    'Position',[240 340 60 20]);

uicontrol('Style','text','String','courant',...
    'Position',[240 370 60 20]);

courant_edit_majeur=uicontrol('Style','edit','String','0',...
    'Position',[500 370 60 20],...
    'Callback',@EditCallBack_CourantMajeur);

courant_Slider_majeur=uicontrol('Style','slider','Max',courantMax,'Min',0,'value',0,...
    'SliderStep',[0.07500 0.1],'Position',[300 370 200 20],...
    'Callback',@SliderCallBack_courantMajeur);

tension_edit_majeur=uicontrol('Style','edit','String','0',...
    'Position',[500 340 60 20],...
    'Callback',@EditCallBack_tensionMajeur);

tension_Slider_majeur=uicontrol('Style','slider','Max',1150,'Min',-1150,'value',0,...
    'SliderStep',[0.01150 0.1],'Position',[300 340 200 20],...
    'Callback',@SliderCallBack_tensionMajeur);

%%Annulaire

Annulaire1=uicontrol('Style','checkbox','String','activer','position',[570 445 100 30],'Callback',@activateAnnulaire);

uicontrol('Style','text','String','annulaire',...
    'Position',[180 435 60 20]);

uicontrol('Style','text','String','tension',...
    'Position',[240 420 60 20]);

uicontrol('Style','text','String','courant',...
    'Position',[240 450 60 20]);

courant_edit_annulaire=uicontrol('Style','edit','String','0',...
    'Position',[500 450 60 20],...
    'Callback',@EditCallBack_CourantAnnulaire);

courant_Slider_annulaire=uicontrol('Style','slider','Max',courantMax,'Min',0,'value',0,...
    'SliderStep',[0.07500 0.1],'Position',[300 450 200 20],...
    'Callback',@SliderCallBack_courantAnnulaire);

tension_edit_annulaire=uicontrol('Style','edit','String','0',...
    'Position',[500 420 60 20],...
    'Callback',@EditCallBack_tensionAnnulaire);

tension_Slider_annulaire=uicontrol('Style','slider','Max',1150,'Min',-1150,'value',0,...
    'SliderStep',[0.01150 0.1],'Position',[300 420 200 20],...
    'Callback',@SliderCallBack_tensionAnnulaire);

%%Auriculaire

Auriculaire1=uicontrol('Style','checkbox','String','activer','position',[570 525 100 30],'Callback',@activateAuriculaire);

uicontrol('Style','text','String','auriculaire',...
    'Position',[180 515 60 20]);

uicontrol('Style','text','String','tension',...
    'Position',[240 500 60 20]);

uicontrol('Style','text','String','courant',...
    'Position',[240 530 60 20]);

courant_edit_auriculaire=uicontrol('Style','edit','String','0',...
    'Position',[500 530 60 20],...
    'Callback',@EditCallBack_CourantAuriculaire);

courant_Slider_auriculaire=uicontrol('Style','slider','Max',courantMax,'Min',0,'value',0,...
    'SliderStep',[0.07500 0.1],'Position',[300 530 200 20],...
    'Callback',@SliderCallBack_courantAuriculaire);

tension_edit_auriculaire=uicontrol('Style','edit','String','0',...
    'Position',[500 500 60 20],...
    'Callback',@EditCallBack_tensionAuriculaire);

tension_Slider_auriculaire=uicontrol('Style','slider','Max',1150,'Min',-1150,'value',0,...
    'SliderStep',[0.01150 0.1],'Position',[300 500 200 20],...
    'Callback',@SliderCallBack_tensionAuriculaire);

%%
%-----------Fonctions mise a zero--------------------------
    function Callback_RAZPouce(varargin)
        valTensionPouce=0;
        valCourantPouce=0;
        set(courant_Slider_pouce,'Value',0);
        set(courant_edit_pouce, 'String', 0);
        set(tension_Slider_pouce,'Value',0);
        set(tension_edit_pouce, 'String', 0);
    end
    function Callback_RAZRpouce(varargin)
        valTensionRpouce=0;
        valCourantRpouce=0;
        set(courant_Slider_Rpouce,'Value',0);
        set(courant_edit_Rpouce, 'String', 0);
        set(tension_Slider_Rpouce,'Value',0);
        set(tension_edit_Rpouce, 'String', 0);
    end
    function Callback_RAZIndex(varargin)
        valTensionIndex=0;
        valCourantIndex=0;
        set(courant_Slider_index,'Value',0);
        set(courant_edit_index, 'String', 0);
        set(tension_Slider_index,'Value',0);
        set(tension_edit_index, 'String', 0);
    end
    function Callback_RAZMajeur(varargin)
        valTensionMajeur=0;
        valCourantMajeur=0;
        set(courant_Slider_majeur,'Value',0);
        set(courant_edit_majeur, 'String', 0);
        set(tension_Slider_majeur,'Value',0);
        set(tension_edit_majeur, 'String', 0);
    end
    function Callback_RAZAnnulaire(varargin)
        valTensionAnnulaire=0;
        valCourantAnnulaire=0;
        set(courant_Slider_annulaire,'Value',0);
        set(courant_edit_annulaire, 'String', 0);
        set(tension_Slider_annulaire,'Value',0);
        set(tension_edit_annulaire, 'String', 0);
    end
    function Callback_RAZAuriculaire(varargin)
        valTensionAuriculaire=0;
        valCourantAuriculaire=0;
        set(courant_Slider_auriculaire,'Value',0);
        set(courant_edit_auriculaire, 'String', 0);
        set(tension_Slider_auriculaire,'Value',0);
        set(tension_edit_auriculaire, 'String', 0);
    end
    function Callback_RAZMano(varargin)
        valTensionMano=0;
        valCourantMano=0;
        set(courant_Slider_mano,'Value',0);
        set(courant_edit_mano, 'String', 0);
        set(tension_Slider_mano,'Value',0);
        set(tension_edit_mano, 'String', 0);
    end
 

%%
    function choix_main(hObject,varargin)
        index_selected = get(hObject,'Value');
        
        if ( index_selected==2)
            port_com='COM3';
        end
        if ( index_selected==3)
            port_com='COM4';
        end
    end

%%
%fonction liée à chaques doigts

%%Pouce

    function activatePouce(hObject,varargin)
        if get(hObject,'Value') == get(hObject,'Max')
            activate_pouce=1;
        else
            activate_pouce=0;
        end
        
    end

    function EditCallBack_CourantPouce(hObject,varargin)
        val=str2double(get(hObject,'String'));
        
        if length(val) == 1 && val <=courantMax && val >=0
            set(courant_Slider_pouce,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [0,21000]','Error','error','modal');
        end
        if (val>=0) && (val<=courantMax) %<-- normalement 36000 mais ne pas prendre de risque
            valCourantPouce=val;
        end
    end

    function SliderCallBack_courantPouce(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(courant_edit_pouce, 'String', num2str(val));
        valCourantPouce=val;
    end

    function EditCallBack_tensionPouce(hObject,varargin)
        val=str2double(get(hObject,'String'));
        if length(val) == 1 && val <=1150 && val >=-1150
            set(tension_Slider_pouce,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [-1150,1150]','Error','error','modal');
        end
        
        if val>-1150 && val<1150
            valTensionPouce=val;
        end
    end

    function SliderCallBack_tensionPouce(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(tension_edit_pouce, 'String', num2str(val));
        valTensionPouce=val;
    end

%%Rpouce

    function activateRpouce(hObject,varargin)
        if get(hObject,'Value') == get(hObject,'Max')
            activate_Rpouce=1;
        else
            activate_Rpouce=0;
        end
        
    end

    function EditCallBack_CourantRpouce(hObject,varargin)
        val=str2double(get(hObject,'String'));
        
        if length(val) == 1 && val <=courantMax && val >=0
            set(courant_Slider_Rpouce,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [0,21000]','Error','error','modal');
        end
        if (val>=0) && (val<=courantMax) %<-- normalement 36000 mais ne pas prendre de risque
            valCourantRpouce=val;
        end
    end

    function SliderCallBack_courantRpouce(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(courant_edit_Rpouce, 'String', num2str(val));
        valCourantRpouce=val;
    end

    function EditCallBack_tensionRpouce(hObject,varargin)
        val=str2double(get(hObject,'String'));
        if length(val) == 1 && val <=1150 && val >=-1150
            set(tension_Slider_Rpouce,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [-1150,1150]','Error','error','modal');
        end
        
        if val>-1150 && val<1150
            valTensionRpouce=val;
        end
    end

    function SliderCallBack_tensionRpouce(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(tension_edit_Rpouce, 'String', num2str(val));
        valTensionRpouce=val;
    end

%%Index

    function activateIndex(hObject,varargin)
        if get(hObject,'Value') == get(hObject,'Max')
            activate_index=1;
        else
            activate_index=0;
        end
        
    end

    function EditCallBack_CourantIndex(hObject,varargin)
        val=str2double(get(hObject,'String'));
        
        if length(val) == 1 && val <=courantMax && val >=0
            set(courant_Slider_index,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [0,21000]','Error','error','modal');
        end
        if (val>=0) && (val<=courantMax) %<-- normalement 36000 mais ne pas prendre de risque
            valCourantIndex=val;
        end
    end

    function SliderCallBack_courantIndex(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(courant_edit_index, 'String', num2str(val));
        valCourantIndex=val;
    end

    function EditCallBack_tensionIndex(hObject,varargin)
        val=str2double(get(hObject,'String'));
        if length(val) == 1 && val <=1150 && val >=-1150
            set(tension_Slider_index,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [-1150,1150]','Error','error','modal');
        end
        
        if val>-1150 && val<1150
            valTensionIndex=val;
        end
    end

    function SliderCallBack_tensionIndex(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(tension_edit_index, 'String', num2str(val));
        valTensionIndex=val;
    end

%%majeur

    function activateMajeur(hObject,varargin)
        if get(hObject,'Value') == get(hObject,'Max')
            activate_majeur=1;
        else
            activate_majeur=0;
        end
        
    end

    function EditCallBack_CourantMajeur(hObject,varargin)
        val=str2double(get(hObject,'String'));
        
        if length(val) == 1 && val <=courantMax && val >=0
            set(courant_Slider_majeur,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [0,21000]','Error','error','modal');
        end
        if (val>=0) && (val<=courantMax) %<-- normalement 36000 mais ne pas prendre de risque
            valCourantMajeur=val;
        end
    end

    function SliderCallBack_courantMajeur(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(courant_edit_majeur, 'String', num2str(val));
        valCourantMajeur=val;
    end

    function EditCallBack_tensionMajeur(hObject,varargin)
        val=str2double(get(hObject,'String'));
        if length(val) == 1 && val <=1150 && val >=-1150
            set(tension_Slider_majeur,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [-1150,1150]','Error','error','modal');
        end
        
        if val>-1150 && val<1150
            valTensionMajeur=val;
        end
    end

    function SliderCallBack_tensionMajeur(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(tension_edit_majeur, 'String', num2str(val));
        valTensionMajeur=val;
    end

%%annulaire

    function activateAnnulaire(hObject,varargin)
        if get(hObject,'Value') == get(hObject,'Max')
            activate_annulaire=1;
        else
            activate_annulaire=0;
        end
        
    end

    function EditCallBack_CourantAnnulaire(hObject,varargin)
        val=str2double(get(hObject,'String'));
        
        if length(val) == 1 && val <=courantMax && val >=0
            set(courant_Slider_annulaire,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [0,21000]','Error','error','modal');
        end
        if (val>=0) && (val<=courantMax) %<-- normalement 36000 mais ne pas prendre de risque
            valCourantAnnulaire=val;
        end
    end

    function SliderCallBack_courantAnnulaire(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(courant_edit_annulaire, 'String', num2str(val));
        valCourantAnnulaire=val;
    end

    function EditCallBack_tensionAnnulaire(hObject,varargin)
        val=str2double(get(hObject,'String'));
        if length(val) == 1 && val <=1150 && val >=-1150
            set(tension_Slider_annulaire,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [-1150,1150]','Error','error','modal');
        end
        
        if val>-1150 && val<1150
            valTensionAnnulaire=val;
        end
    end

    function SliderCallBack_tensionAnnulaire(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(tension_edit_annulaire, 'String', num2str(val));
        valTensionAnnulaire=val;
    end

%%auriculaire

    function activateAuriculaire(hObject,varargin)
        if get(hObject,'Value') == get(hObject,'Max')
            activate_auriculaire=1;
        else
            activate_auriculaire=0;
        end
        
    end

    function EditCallBack_CourantAuriculaire(hObject,varargin)
        val=str2double(get(hObject,'String'));
        
        if length(val) == 1 && val <=courantMax && val >=0
            set(courant_Slider_auriculaire,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [0,21000]','Error','error','modal');
        end
        if (val>=0) && (val<=courantMax) %<-- normalement 36000 mais ne pas prendre de risque
            valCourantAuriculaire=val;
        end
    end

    function SliderCallBack_courantAuriculaire(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(courant_edit_auriculaire, 'String', num2str(val));
        valCourantAuriculaire=val;
    end

    function EditCallBack_tensionAuriculaire(hObject,varargin)
        val=str2double(get(hObject,'String'));
        if length(val) == 1 && val <=1150 && val >=-1150
            set(tension_Slider_auriculaire,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [-1150,1150]','Error','error','modal');
        end
        
        if val>-1150 && val<1150
            valTensionAuriculaire=val;
        end
    end

    function SliderCallBack_tensionAuriculaire(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(tension_edit_auriculaire, 'String', num2str(val));
        valTensionAuriculaire=val;
    end

%%
%%Main

Main1=uicontrol('Style','checkbox','String','activer','position',[570 605 100 30],'Callback',@activateMano);

uicontrol('Style','text','String','main',...
    'Position',[180 595 40 20]);


uicontrol('Style','text','String','tension',...
    'Position',[240 580 60 20]);

uicontrol('Style','text','String','courant',...
    'Position',[240 610 60 20]);

courant_edit_mano=uicontrol('Style','edit','String','0',...
    'Position',[500 610 60 20],...
    'Callback',@EditCallBack_CourantMano);

courant_Slider_mano=uicontrol('Style','slider','Max',courantMax,'Min',0,'value',0,...
    'SliderStep',[0.03000 0.1],'Position',[300 610 200 20],...
    'Callback',@SliderCallBack_courantMano);

tension_edit_mano=uicontrol('Style','edit','String','0',...
    'Position',[500 580 60 20],...
    'Callback',@EditCallBack_tensionMano);

tension_Slider_mano=uicontrol('Style','slider','Max',1150,'Min',-1150,'value',0,...
    'SliderStep',[0.01150 0.1],'Position',[300 580 200 20],...
    'Callback',@SliderCallBack_tensionMano);

%---Fermer la main
    function activateMano(hObject,varargin)
        if get(hObject,'Value') == get(hObject,'Max')
            activate_mano=1;
        else
            activate_mano=0;
        end
        
    end

    function EditCallBack_CourantMano(hObject,varargin)
        val=str2double(get(hObject,'String'));
        
        if length(val) == 1 && val <=courantMax && val >=0
            set(courant_Slider_mano,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [0,21000]','Error','error','modal');
        end
        if (val>=0) && (val<=courantMax) %<-- normalement 36000 mais ne pas prendre de risque
            valCourantMano=val;
        end
    end

    function SliderCallBack_courantMano(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(courant_edit_mano, 'String', num2str(val));
        valCourantMano=val;
    end

    function EditCallBack_tensionMano(hObject,varargin)
        val=str2double(get(hObject,'String'));
        if length(val) == 1 && val <=1150 && val >=-1150
            set(tension_Slider_mano,'Value',val);
        else
            msgbox('La valeur doit etre comprise entre [-1150,1150]','Error','error','modal');
        end
        
        if val>-1150 && val<1150
            valTensionMano=val;
        end
    end

    function SliderCallBack_tensionMano(hObject,varargin)
        val = fix(get(hObject, 'Value'));
        set(tension_edit_mano, 'String', num2str(val));
        valTensionMano=val;
    end

%%
%------------Fonction start----------------------------------------
    function Callback_start(hObject,varargin)
        
       
        
        delete(instrfindall) ;
        s1=serial(port_com);
        fclose(s1);
        delete(s1);
        clear s1;
        s1=serial(port_com);
        set(s1, 'BaudRate',460800,'DataBits',8,'StopBits',1,...
            'Parity','none','FlowControl','none','TimeOut',1);
        fopen(s1);
        
        
        %Verouillage des check boxs
        
        if get(hObject,'Value') == get(hObject,'Max')
            set(Pouce1,'enable','off');
        else
            if get(hObject,'Value') == get(hObject,'Min')
                set(Pouce1,'enable','on');
                
            end
        end
        
        if get(hObject,'Value') == get(hObject,'Max')
            set(Rpouce1,'enable','off');
        else
            if get(hObject,'Value') == get(hObject,'Min')
                set(Rpouce1,'enable','on');
                
            end
        end
        
        if get(hObject,'Value') == get(hObject,'Max')
            set(Index1,'enable','off');
        else
            if get(hObject,'Value') == get(hObject,'Min')
                set(Index1,'enable','on');
                
            end
            
        end
        
        if get(hObject,'Value') == get(hObject,'Max')
            set(Majeur1,'enable','off');
        else
            if get(hObject,'Value') == get(hObject,'Min')
                set(Majeur1,'enable','on');
                
            end
            
        end
        
        if get(hObject,'Value') == get(hObject,'Max')
            set(Annulaire1,'enable','off');
        else
            if get(hObject,'Value') == get(hObject,'Min')
                set(Annulaire1,'enable','on');
                
            end
        end
        
        if get(hObject,'Value') == get(hObject,'Max')
            set(Auriculaire1,'enable','off');
        else
            if get(hObject,'Value') == get(hObject,'Min')
                set(Auriculaire1,'enable','on');
                
            end
        end
        
        if get(hObject,'Value') == get(hObject,'Max')
            set(Main1,'enable','off');
        else
            if get(hObject,'Value') == get(hObject,'Min')
                set(Main1,'enable','on');
                
            end
        end
        
        %boucle principale
        while get(hObject,'Value')== get(hObject,'Max')
            
            if activate_pouce==1
                mode_tensionDoigt(valTensionPouce,valCourantPouce,1,s1);
                pause(0.02);
            end
            
            if activate_Rpouce==1
                mode_tensionDoigt(valTensionRpouce,valCourantRpouce,0,s1);
                pause(0.02);
            end
            
            if activate_index==1
                position=lecture_position(s1,2)
                if position>=100
                mode_tensionDoigt(valTensionIndex,valCourantIndex,2,s1);
                pause(0.02);
                end
            end
            
            if activate_majeur==1   
                mode_tensionDoigt(valTensionMajeur,valCourantMajeur,3,s1);
                pause(0.02);
            end
            
            if activate_annulaire==1
                mode_tensionDoigt(valTensionAnnulaire,valCourantAnnulaire,4,s1);
                pause(0.02);
            end
            
            if activate_auriculaire==1
                mode_tensionDoigt(valTensionAuriculaire,valCourantAuriculaire,5,s1);
                pause(0.02);
            end
            
            
            if activate_mano==1;
                
                mode_tensionDoigt(valTensionMano,valCourantMano,2,s1);
                pause(0.02);
                mode_tensionDoigt(valTensionMano,valCourantMano,3,s1);
                pause(0.02);
                mode_tensionDoigt(valTensionMano,valCourantMano,4,s1);
                pause(0.02);
                mode_tensionDoigt(valTensionMano,valCourantMano,5,s1);
                pause(0.02);
                if valTensionMano>=100 && valCourantMano>=100
                    mode_tensionDoigt(valTensionMano,valCourantMano,1,s1);
                else
                    mode_tensionDoigt(valTensionMano,valCourantMano,1,s1);
                end
                pause(0.02);
            end
            
            
        end
        
    end

 

end



