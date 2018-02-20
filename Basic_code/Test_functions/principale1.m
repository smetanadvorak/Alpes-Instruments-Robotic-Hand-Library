
%-------------------contrôle en position---------------------------
%
%But: interface graphique et mise en commun des différentes fonctions
%
%doigts: 0: rotation pouce
%        1: pouce
%        2: index
%        3: majeur
%        4: annulaire
%        5: auriculaire
%
%pour une description de comment fonctionne les interfaces graphiques
%se referer au rapport de stage de janvier
%
%fonctions exterieur utilisées:
%        - main_droite_gauche.m :dit quelle main est branchée
%        - back_main.m :ouvre la main
%        - mouv_main.m :ferme la main
%        - test_attraper_relacher.m :si il y a detection d'objet en contact
%                                    avec le doigt il se réouvre
%        - test_attraper.m :si il y a detection d'objet en contact avec le
%                           doigt il ecrit dans commande "le doigt tien
%                           quelquechose"
%        - mouv_doigts.m :fait bouger un doigt
%        - puissance_textbox.m :affiche la valeur de la puissance dans un
%          text.
%        -Newgui.m: donne quelques exemples de mouvement de la main
%

%----------------------Principale-------------------------------
function principale1(s)



%-----------------generation d'une fenetre------------------------

fig=figure('NumberTitle','off','Resize','off','MenuBar','none');
main_droite_gauche(fig,s);
%donne le nom de la fenêtre en fonction de la main branchée
%main_droite_gauche(fig,s);

set(fig,'color',[1 1 1]);


%-----------------------Bouttons------------------------------

%fonction ouverture et fermeture total de la main

%Jeux de main jeux de vilain
uicontrol('Style','pushbutton','String','JEUX','position',...
    [50 400 50 20],'Callback',@jeux);

%fermeture
uicontrol('Style','pushbutton','position',...
    [50 120 50 20],'Callback',@grip_main);

%ouverture
uicontrol('Style','pushbutton','position',...
    [50 20 50 20],'Callback',@lacher_main);

%mouvs_exmeples
uicontrol('Style','pushbutton','String','mouvs_exemples','position',...
    [250 400 100 20],'Callback',@mouvements);


%------------------------sliders--------------------------------
%Positon des maximums calculé avec le registre 26 POSITION_CODEUR
%en position maximale pour chaques doigts aussi recupérable par le registre
%12 CONSIGNE_POSITION_MAX

%rotation pouce
Rpouce_Slider=uicontrol('Style','slider','Max',21000,'Min',0,'value',0,...
    'SliderStep',[0.021000 0.1],'Position',[300 20 200 20],...
    'Callback',@SliderCallBack_Rpouce);

%pouce
pouce_Slider=uicontrol('Style','slider','Max',19000,'Min',0,'value',0,...
    'SliderStep',[0.019000 0.1],'Position',[300 80 200 20],...
    'Callback',@SliderCallBack_pouce);

%index
index_Slider=uicontrol('Style','slider','Max',43000,'Min',0,'value',0,...
    'SliderStep',[0.043000 0.1],'Position',[300 140 200 20],...
    'Callback',@SliderCallBack_index);

%majeur
majeur_Slider=uicontrol('Style','slider','Max',43000,'Min',0,'value',0,...
    'SliderStep',[0.043000 0.1],'Position',[300 200 200 20],...
    'Callback',@SliderCallBack_majeur);


%annulaire
annulaire_Slider=uicontrol('Style','slider','Max',43000,'Min',0,'value',0,...
    'SliderStep',[0.043000 0.1],'Position',[300 260 200 20],...
    'Callback',@SliderCallBack_annulaire);

%auriculaire
auriculaire_Slider=uicontrol('Style','slider','Max',43000,'Min',0,'value',0,...
    'SliderStep',[0.043000 0.1],'Position',[300 320 200 20],...
    'Callback',@SliderCallBack_auriculaire);


%%-----------------edit--------------------------------
%auriculaire
auriculaire_edit1=uicontrol('Style','edit','String','position',...
    'Position',[500 320 60 20],...
    'Callback',@EditCallBack_auriculaire);

%annulaire
annulaire_edit1=uicontrol('Style','edit','String','position',...
    'Position',[500 260 60 20],...
    'Callback',@EditCallBack_annulaire);

%majeur
majeur_edit1=uicontrol('Style','edit','String','position',...
    'Position',[500 200 60 20],...
    'Callback',@EditCallBack_majeur);

%index
index_edit1=uicontrol('Style','edit','String','position',...
    'Position',[500 140 60 20],...
    'Callback',@EditCallBack_index);

%pouce
pouce_edit1=uicontrol('Style','edit','String','position',...
    'Position',[500 80 60 20],...
    'Callback',@EditCallBack_pouce);

%rotation pouce
Rpouce_edit1=uicontrol('Style','edit','String','position',...
    'Position',[500 20 60 20],...
    'Callback',@EditCallBack_Rpouce);


%%-----------------partie text-------------------------

%puissance mNm
uicontrol('Style','text','String','puissance mNm',...
    'Position', [130 350 100 20]);

%ouvrir la main
uicontrol('Style','text','String','ouvrir la main',...
    'Position', [20 50 100 20]);

%fermer le poing
uicontrol('Style','text','String','fermer le poing',...
    'Position', [20 150 100 20]);

%position des doigts
uicontrol('Style','text','String','position des doigts',...
    'Position', [380 350 100 20]);

%rotation pouce
uicontrol('Style','text','String','rotation pouce',...
    'Position', [220 20 70 20]);

%pouce
uicontrol('Style','text','String','pouce',...
    'Position', [245 80 50 20]);

%index
uicontrol('Style','text','String','index',...
    'Position', [245 140 50 20]);

%majeur
uicontrol('Style','text','String','majeur',...
    'Position', [245 200 50 20]);

%annuaire
uicontrol('Style','text','String','annulaire',...
    'Position', [245 260 50 20]);

%auriculaire
uicontrol('Style','text','String','auriculaire',...
    'Position', [240 320 55 20]);

%--------------------Partie text modifiable--------------------------

%rotation pouce
pow_Rpouce=uicontrol('Style','text','String','0',...
    'Position', [150 20 50 20]);

%pouce
pow_pouce=uicontrol('Style','text','String','0',...
    'Position', [150 80 50 20]);

%index
pow_index=uicontrol('Style','text','String','0',...
    'Position', [150 140 50 20]);

%majeur
pow_majeur=uicontrol('Style','text','String','0',...
    'Position', [150 200 50 20]);

%annuaire
pow_annulaire=uicontrol('Style','text','String','0',...
    'Position', [150 260 50 20]);

%auriculaire
pow_auriculaire=uicontrol('Style','text','String','0',...
    'Position', [150 320 50 20]);

%-----------Ouverture et fermeture de la main-----------------

    function lacher_main(varargin)
        
        %----------> > > ouvre la main < < < <----------------
        back_main(s);
        
        %----------reset les sliders et les edits-------------
        %pouce
        set(pouce_Slider,'Value',0);
        set(pouce_edit1,'String',0);
        
        %rotation pouce
        set(Rpouce_Slider,'Value',0);
        set(Rpouce_edit1,'String',0);
        
        %index
        set(index_Slider,'Value',0);
        set(index_edit1,'String',0);
        
        %majeur
        set(majeur_Slider,'Value',0);
        set(majeur_edit1,'String',0);
        
        %annulaire
        set(annulaire_Slider,'Value',0);
        set(annulaire_edit1,'String',0);
        
        %auriculaire
        set(auriculaire_Slider,'Value',0);
        set(auriculaire_edit1,'String',0);
        
    end

    function grip_main(varargin)
        %----------> > > > ferme la main < < < < -------------------
        
        mouv_main(s)
        
       
        
        %----------met au max les sliders et les edits-------------
        %pouce
        set(pouce_Slider,'Value',19000);
        set(pouce_edit1,'String',19000);
        
        %rotation pouce
        set(Rpouce_Slider,'Value',21000);
        set(Rpouce_edit1,'String',21000);
        
        %index
        set(index_Slider,'Value',43000);
        set(index_edit1,'String',43000);
        
        %majeur
        set(majeur_Slider,'Value',43000);
        set(majeur_edit1,'String',43000);
        
        %annulaire
        set(annulaire_Slider,'Value',43000);
        set(annulaire_edit1,'String',43000);
        
        %auriculaire
        set(auriculaire_Slider,'Value',43000);
        set(auriculaire_edit1,'String',43000);
        %--------------Et on lève le petit doigt-------------------
        pause(2);
        test_attraper_relacher(43000,5,s);
    end

%------------------mouvement des doigts-----------------------
%pouce
    function EditCallBack_pouce(hObject,varargin)
        
        %--------partie liant l'edit box au slider correspondant--------
        
        num = str2double(get(pouce_edit1,'String'));%<----recuperation de
        %                                                 la valeur dans
        %                                                 l'edit
        if length(num) == 1 && num <=19000 && num >=0%<-- securité
            set(pouce_Slider,'Value',num);%<-- liaison edit/slider
        else
            msgbox('La valeur doit etre comprise entre [0,19000]',...
                'Error','error','modal');%<-- boite d'erreur
        end
        
        %--------------partie liaison avec le doigt------------------------
        doigt=1;
        pos=str2double(get( hObject, 'String'));%<--- recupération de la
        %                                             valeur de l'edit
        
        %programme bougeant les doigts;
        if (pos>=0) && (pos<=19000)
            mouv_doigts(pos,doigt,s);%<--- Appel de fonction externe
        end
        
        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_pouce,s);
       
        
    end

    function SliderCallBack_pouce(hObject,varargin)
        %--------partie liant le slider à l'edit box correspondante--------
        
        num = fix(get(pouce_Slider, 'Value'));%<-- recuperation de la valeur
        set(pouce_edit1, 'String', num2str(num));%<-- modif de l'edit box
        
        %--------------partie liaison avec le doigt------------------------
        %
        %But: bouger le pouce avec le slider corresponand
        %
        
        %choix du doigt;
        doigt=1;
        
        %programme bougeant les doigts;
        mouv_doigts(fix(get( hObject, 'Value')),doigt,s);%<--- Appel de fonction externe
        
        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_pouce,s);
    end

%Rpouce

    function EditCallBack_Rpouce(hObject,varargin)
        %--------partie liant l'edit box au slider correspondant--------
        num = str2double(get(Rpouce_edit1,'String'));
        if length(num) == 1 && num <=21000 && num >=0
            set(Rpouce_Slider,'Value',num);
        else
            msgbox('La valeur doit etre comprise entre [0,21000]','Error','error','modal');
        end
        %--------------partie liaison avec le doigt------------------------
        doigt=0;
        pos=str2double(get( hObject, 'String'));
        
        %programme bougeant les doigts;
        if (pos>=0) && (pos<=43000)
            mouv_doigts(pos,doigt,s);
        end
        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_Rpouce,s);
       
    end

    function SliderCallBack_Rpouce(hObject,varargin)
        %--------partie liant le slider à l'edit box correspondante--------
        num = fix(get(Rpouce_Slider, 'Value'));
        set(Rpouce_edit1, 'String', num2str(num));
        %--------------partie liaison avec le doigt------------------------
        %
        %But: bouger le doigt :Rpouce avec le slider corresponand
        %
        
        %choix du doigt;
        doigt=0;
        
        %programme bougeant les doigts;
        mouv_doigts(fix(get( hObject, 'Value')),doigt,s);
        
       %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_Rpouce,s);
        
    end

%index
    function EditCallBack_index(hObject,varargin)
        %--------partie liant l'edit box au slider correspondant--------
        num = str2double(get(index_edit1,'String'));
        if length(num) == 1 && num <=43000 && num >=0
            set(index_Slider,'Value',num);
        else
            msgbox('La valeur doit etre comprise entre [0,43000]','Error','error','modal');
        end
        %--------------partie liaison avec le doigt------------------------
        doigt=2;
        pos=str2double(get( hObject, 'String'));
        
        %programme bougeant les doigts;
        if (pos>=0) && (pos<=43000)
            mouv_doigts(pos,doigt,s);
        end
        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_index,s);
    end

    function SliderCallBack_index(hObject,varargin)
        %--------partie liant le slider à l'edit box correspondante--------
        num = fix(get(index_Slider, 'Value'));
        set(index_edit1, 'String', num2str(num));
        %--------------partie liaison avec le doigt------------------------
        %
        %But: bouger le doigt :index avec le slider corresponand
        %
        
        %choix du doigt;
        doigt=2;
        poistion=fix(get( hObject, 'Value'));
        
        %programme bougeant les doigts;
        mouv_doigts(poistion,doigt,s);
        
        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_index,s);
        
    end

%majeur
    function EditCallBack_majeur(hObject,varargin)
        %--------partie liant l'edit box au slider correspondant--------
        num = str2double(get(majeur_edit1,'String'));
        if length(num) == 1 && num <=43000 && num >=0
            set(majeur_Slider,'Value',num);
        else
            msgbox('La valeur doit etre comprise entre [0,43000]','Error','error','modal');
        end
        %--------------partie liaison avec le doigt------------------------
        doigt=3;
        pos=str2double(get( hObject, 'String'));
        
        %programme bougeant les doigts;
        if (pos>=0) && (pos<=43000)
            mouv_doigts(pos,doigt,s);
        end
        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_majeur,s);
    end

    function SliderCallBack_majeur(hObject,varargin)
        %--------partie liant le slider à l'edit box correspondante--------
        num = fix(get(majeur_Slider, 'Value'));
        set(majeur_edit1, 'String', num2str(num));
        %--------------partie liaison avec le doigt------------------------
        %
        %But: bouger le doigt :majeur avec le slider corresponand
        %
        
        %choix du doigt;
        doigt=3;
        
        %programme bougeant les doigts;
        mouv_doigts(fix(get( hObject, 'Value')),doigt,s);
        
       %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_majeur,s);
        
    end

%auriculaire

    function EditCallBack_auriculaire(hObject,varargin)
        %--------partie liant l'edit box au slider correspondant--------
        num = str2double(get(auriculaire_edit1,'String'));
        if length(num) == 1 && num <=43000 && num >=0
            set(auriculaire_Slider,'Value',num);
        else
            msgbox('La valeur doit etre comprise entre [0,43000]','Error','error','modal');
        end
        %--------------partie liaison avec le doigt------------------------
        doigt=5;
        pos=str2double(get( hObject, 'String'));
        
        %programme bougeant les doigts;
        if (pos>=0) && (pos<=43000)
            mouv_doigts(pos,doigt,s);
        end
        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_auriculaire,s);
    end

    function SliderCallBack_auriculaire(hObject,varargin)
        %--------partie liant le slider à l'edit box correspondante--------
        num = fix(get(auriculaire_Slider, 'Value'));
        set(auriculaire_edit1, 'String', num2str(num));
        %--------------partie liaison avec le doigt------------------------
        %
        %But: bouger le doigt :auriculaire avec le slider corresponand
        %
        %choix du doigt;
        doigt=5;
        %set( handles.p, 'Value', str2double(get(handles.q, 'String')) )
        
        %programme bougeant les doigts;
        mouv_doigts(fix(get( hObject, 'Value')),doigt,s);
        
        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_auriculaire,s);
        
    end

%annulaire

    function EditCallBack_annulaire(hObject,varargin)
        %--------partie liant l'edit box au slider correspondant--------
        num = str2double(get(annulaire_edit1,'String'));
        if length(num) == 1 && num <=43000 && num >=0
            set(annulaire_Slider,'Value',num);
        else
            msgbox('La valeur doit etre comprise entre [0,43000]','Error','error','modal');
        end
        %--------------partie liaison avec le doigt------------------------
        doigt=4;
        pos=str2double(get( hObject, 'String'));
        
        %programme bougeant les doigts;
        p = tic;
        if (pos>=0) && (pos<=43000)
            mouv_doigts(pos,doigt,s);
        end
        P = toc(p)
% %         verifie que rien est dans la main
%         test_attraper(pos,doigt,s);

        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_annulaire,s);
    end

    function SliderCallBack_annulaire(hObject,varargin)
        %--------partie liant le slider à l'edit box correspondante--------
        num = fix(get(annulaire_Slider, 'Value'));
        set(annulaire_edit1, 'String', num2str(num));
        %--------------partie liaison avec le doigt------------------------
        %
        %But: bouger le doigt :annulaire avec le slider corresponand
        %
        %choix du doigt;
        doigt=4;
        m = tic;
        %programme bougeant les doigts;
        mouv_doigts(fix(get( hObject, 'Value')),doigt,s);
        M = toc(m)
        %si il y a quelque chose qui bloque ce doigt il ce réouvre
%         pause(2);%<-- attendre que le doigt se ferme avant la lecture de position 
%                      %des codeurs
%         test_attraper_relacher(fix(get( hObject, 'Value')),doigt,s);

        %-----------------Puissance-------------------------------
        puissance_textbox(doigt,pow_annulaire,s);
        
    end

%---------------JEUX---------------------------------

    function jeux(varargin)
        
        PPC=uicontrol('Style','text',...
                'Position', [150 400 100 20]);

        PierrePapierCiseaux(s,PPC)
        set(PPC,'String','Rejouer?');
    end 
    function mouvements(varargin)
        Newgui(s);
    end



end


