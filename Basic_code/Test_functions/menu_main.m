function menu_main

%
%principe :
% creation de la fenetre principale du programme permettant :
%       -lance les initialisations et les tests d'initialisations
%       -la selection de la main choisie en mode tension ou position (avec initialisation si besoin)
%       -lancer un programme de passage de goblet entre les deux main
%       -lancer le comptage des mains (pour le comptage brancher les deux
%       mains)
%
%pour passer sous MAC aller aux lignes 23-28-32-37 pour changer les port
%com
%


%variables de detection si l'initialisation est faite
g=0;%<---- main gauche
d=0;%<---- main droite

%variables vérifiant si les mains sont déja ouvertes
ouvert_droit=0;
ouvert_gauche=0;

%Initialisation de chaque Mains
delete(instrfindall) ;

%s2=serial('/dev/tty.SerialPort');
%s2=serial('/dev/tty.usbserial-A703UV4L');
s2=serial('COM5');%<-- partie à changer pour passer sous mac
fclose(s2);
delete(s2);
clear s2;

%s2=serial('/dev/tty.SerialPort');
%s2=serial('/dev/tty.usbserial-A703UV4L');
s2=serial('COM5');%<--- partie à changer pour passer sous mac
set(s2, 'BaudRate',460800,'DataBits',8,'StopBits',1,...
    'Parity','none','FlowControl','none','TimeOut',1);

%s1=serial('/dev/tty.SerialPort');
%s1=serial('/dev/tty.usbserial-A703UV4L');
s1=serial('COM4');%<--- partie à changer pour passer sous mac
fclose(s1);
delete(s1);
clear s1;

%s1=serial('/dev/tty.SerialPort');
%s1=serial('/dev/tty.usbserial-A703UV4L');
s1=serial('COM4');%<--- partie à changer pour passer sous mac
set(s1, 'BaudRate',460800,'DataBits',8,'StopBits',1,...
    'Parity','none','FlowControl','none','TimeOut',1);


%------------PARTIE GRAPHIQUE-----------------------------------------
%------------creation de la fenetre------------------------------------
fig = figure('Name','menu main','NumberTitle','off','Resize','off','MenuBar','none','Position',[800,300,300,200]);
set(fig,'color',[1 1 1]);

%------------image-------------------------------------------
subplot(1,1,1);
imshow('irccyn.png')
set(gca,'Position',[0.10 -0.05 0.8 1])

%------------bouton passage de goblet------------------------------
uicontrol('Style','pushbutton','String','passage de goblet','position',[40 30 100 30],'Callback',@gobelet)


%------------Calcule------------------------------------------------
uicontrol('Style','pushbutton','String','Calculer','position',[170 30 100 30],'Callback',@calculer)

%------------menu defilant pour la selection de la main-------------

%Mode Position
uicontrol('Style','text','String','Mode Position','position',[180 160 100 30])

%Mode Tension
uicontrol('Style','text','String','Mode Tension','position',[30 160 100 30])

%Mode EMG control --- added by Elena Rampone ---
uicontrol('Style','text','String','Mode EMG control','position',[330 160 100 30])
%Mode EMG propotional control --- added by Elena Rampone ---
uicontrol('Style','text','String','Mode EMG proportional control','position',[480 160 150 30])
%Menu deroulant mode Position
uicontrol('Style', 'popup',...
    'String', {'seletion de la main','main gauche','main droite','les deux mains'},...
    'Position', [170 120 115 50],...
    'Callback', @choix_mainModePosition);

%Menu deroulant mode Tension
uicontrol('Style', 'popup',...
    'String', {'seletion de la main','main gauche','main droite','les deux mains'},...
    'Position', [20 120 115 50],...
    'Callback', @choix_mainModeTension);

%Menu deroulant mode EMG control --- added by Elena Rampone ---
uicontrol('Style', 'popup',...
    'String', {'seletion de la main','main gauche','main droite','les deux mains'},...
    'Position', [320 120 115 50],...
    'Callback', @choix_mainModeEMGcontrol);

%Menu deroulant mode EMG control + velocity control --- added by Elena Rampone ---
uicontrol('Style', 'popup',...
    'String', {'seletion de la main','main gauche','main droite','les deux mains'},...
    'Position', [497 120 115 50],...
    'Callback', @choix_mainModeEMG_prop_control);
%-----------Fonctions------------------------------
    function calculer(varargin)
        
        %s'actionne lorsque que l'on appuis sur calculer
        %
        %methode:
        %   initialisation si besoin des deux main
        %   cree une message box qui bloque l'execution jusqu'a ce que l'on
        %       appuis sur OK
        %   lance passage_gobelet
        
        
        
        %------------main gauche-----------------------------------------
        
        if ouvert_gauche==0
            
            fopen(s1);
            ouvert_gauche=1;
        end
        
        %------------main droite--------------------------------------------
        
        if ouvert_droit==0
            
            fopen(s2);
            ouvert_droit=1;
        end
        
        g=initialisationtest(s1);
        d=initialisationtest(s2);
        
        
        if g==0 % n est la variable qui permet de determiner si la main
            % gauche est déjà initialisé
            
            initialisation(s1);
            g=1;
        end
        
        
        
        if d==0 % m est la variable qui permet de determiner si la main
            % droite est déjà initialisé
            
            initialisation(s2);
            d=1;
        end
        
        %fonction appellée
        counting(s1,s2);
    end

    function gobelet(varargin)
        
        %s'actionne lorsque que l'on appuis sur passage de gobelet
        %
        %methode:
        %   initialisation si besoin des deux main
        %   cree une message box qui bloque l'execution jusqu'a ce que l'on
        %       appuis sur OK
        %   lance passage_gobelet
        
        
        
        %------------main gauche-----------------------------------------
        
        if ouvert_gauche==0
            
            fopen(s1);
            ouvert_gauche=1;
        end
        
        %------------main droite--------------------------------------------
        
        if ouvert_droit==0
            
            fopen(s2);
            ouvert_droit=1;
        end
        
        g=initialisationtest(s1);
        d=initialisationtest(s2);
        
        if g==0 % n est la variable qui permet de determiner si la main
            % gauche est déjà initialisé
            
            initialisation(s1);
            g=1;
        end
        
        
        
        if d==0 % m est la variable qui permet de determiner si la main
            % droite est déjà initialisé
            
            initialisation(s2);
            d=1;
        end
        
        % uiwait stop l'execution du programme jusqu'à l'appuis sur OK
        uiwait(msgbox('il vous faut un goblet avant de commencer','attention','error'));
        
        %fonction appellée
        passage_gobelet(s1,s2);
    end

%Mode Position
    function choix_mainModePosition(hObject,varargin)
        
        
        
        
        
        %choix entre une des deux main ou les deux mains
        %principe pour chaque index:
        %       -on verifit si le port com est ouvert
        %       -on verifie si une initialisation est faite
        %           -si oui on lance principale1.m
        %           -si non on initialise avant et on lance principale1.m
        
        %selection de l'index main gauche
        index_selected = get(hObject,'Value');
        
        if ( index_selected==2)
            
            %------------main gauche-----------------------------------------
            %Permet d'ouvrir la main qu'une fois pour les menus déroulants
            if ouvert_gauche==0
                
                fopen(s1);
                ouvert_gauche=1;
            end
            
            %Permet de ne faire l'initialisation qu'une fois
            g=initialisationtest(s1);
            if g==0
                initialisation(s1);
                g=1;
            end
            
            %Lance la fenetre mode tension
            principale1(s1)
            
            %selection de l'index main droite
        else if (index_selected==3)
                
                %------------main droite--------------------------------------------
                
                %permet d'ouvrir la main qu'une seul fois
                if ouvert_droit==0
                    fopen(s2);
                    ouvert_droit=1;
                end
                
                %permet de ne faire l'initialisation qu'une fois
                d=initialisationtest(s2);
                if d==0
                    initialisation(s2);
                    d=1;
                end
                
                %Fenetre mode Position
                principale1(s2);
                
                %selection de l'index les deux mains
            else if(index_selected==4)
                    
                    
                    %------------main gauche-----------------------------------------
                    %Meme principe que pour les deux premier index
                    if ouvert_gauche==0;
                        
                        fopen(s1);
                        ouvert_gauche=1;
                    end
                    
                    %------------main droite--------------------------------------------
                    
                    if ouvert_droit==0;
                        
                        fopen(s2);
                        ouvert_droit=1;
                    end
                    
                    %initialisation
                    d=initialisationtest(s2);
                    g=initialisationtest(s1);
                    
                    if d==0
                        initialisation(s1);
                        d=1;
                    end
                    
                    principale1(s1);
                    
                    if g==0
                        initialisation(s2);
                        g=1;
                    end
                    
                    principale1(s2);
                end
            end
        end
    end

%Mode Tension
    function choix_mainModeTension(hObject,varargin)
        
        
        
        
        
        %choix entre une des deux main ou les deux mains
        %principe pour chaque index:
        %       -on verifit si le port com est ouvert
        %       -on verifie si une initialisation est faite
        %           -si oui on lance modeTension.m
        %           -si non on initialise avant et on lance modeTension.m
        
        %selection de l'index main gauche
        index_selected = get(hObject,'Value');
        
        if ( index_selected==2)
            
            %------------main gauche-----------------------------------------
            %verifie si la main est deja ouvert et l'ouvre sinon
            if ouvert_gauche==0;
                fopen(s1);
                ouvert_gauche=1;
            end
            %verifit que l'initialisation est faite sinon la fait
            g=initialisationtest(s1);
            if g==0
                initialisation(s1);
                g=1;
            end
            
            modeTension(s1)
            
            %selection de l'index main droite
        else if (index_selected==3)
                
                %------------main droite--------------------------------------------
                if ouvert_droit==0;
                    
                    fopen(s2);
                    ouvert_droit=1;
                end
                
                d=initialisationtest(s2);
                if d==0
                    initialisation(s2);
                    d=1;
                end
                
                
                modeTension(s2);
                
                %selection de l'index les deux mains
            else if(index_selected==4)
                    
                    %------------main gauche-----------------------------------------
                    if ouvert_gauche==0;
                        
                        fopen(s1);
                        ouvert_gauche=1;
                    end
                    %------------main droite--------------------------------------------
                    if ouvert_droit==0
                        
                        fopen(s2);
                        ouvert_droit=1;
                    end
                    
                    d=initialisationtest(s2);
                    g=initialisationtest(s1);
                    
                    if d==0
                        initialisation(s1);
                        d=1;
                    end
                    modeTension(s1);
         
                    if g==0
                        initialisation(s2);
                        g=1;
                    end
                    
                    modeTension(s2);
                end
            end
        end
    end
%% MODIFIED BY ELENA RAMPONE
%Mode EMG control
    function choix_mainModeEMGcontrol(hObject,varargin)
        %choix entre une des deux main ou les deux mains
        %principe pour chaque index:
        %       -on verifit si le port com est ouvert
        %       -on verifie si une initialisation est faite
        %           -si oui on lance principale1.m
        %           -si non on initialise avant et on lance principale1.m
        
        %selection de l'index main gauche
        index_selected = get(hObject,'Value');
        
        if ( index_selected==2)
            
            %------------main gauche-----------------------------------------
            %Permet d'ouvrir la main qu'une fois pour les menus déroulants
            if ouvert_gauche==0
                
                fopen(s1);
                ouvert_gauche=1;
            end
            
            %Permet de ne faire l'initialisation qu'une fois
            g=initialisationtest(s1);
            if g==0
                initialisation(s1);
                g=1;
            end
            
            %Lance la fenetre mode EMG control
            mode_EMGcontrol(s1)
            
            %selection de l'index main droite
        else if (index_selected==3)
                
                %------------main droite--------------------------------------------
                
                %permet d'ouvrir la main qu'une seul fois
                if ouvert_droit==0
                    fopen(s2);
                    ouvert_droit=1;
                end
                
                %permet de ne faire l'initialisation qu'une fois
                d=initialisationtest(s2);
                if d==0
                    initialisation(s2);
                    d=1;
                end
                
                %Fenetre mode EMG control
                mode_EMGcontrol(s2);
                
                %selection de l'index les deux mains
            else if(index_selected==4)
                    
                    
                    %------------main gauche-----------------------------------------
                    %Meme principe que pour les deux premier index
                    if ouvert_gauche==0;
                        
                        fopen(s1);
                        ouvert_gauche=1;
                    end
                    
                    %------------main droite--------------------------------------------
                    
                    if ouvert_droit==0;
                        
                        fopen(s2);
                        ouvert_droit=1;
                    end
                    
                    %initialisation
                    d=initialisationtest(s2);
                    g=initialisationtest(s1);
                    
                    if d==0
                        initialisation(s1);
                        d=1;
                    end
                    
                    mode_EMGcontrol(s1);
                    
                    if g==0
                        initialisation(s2);
                        g=1;
                    end
                    
                    mode_EMGcontrol(s2);
                end
            end
        end
    end %function choix_mainModeEMGcontrol
    function choix_mainModeEMG_prop_control(hObject,varargin)
        %choix entre une des deux main ou les deux mains
        %principe pour chaque index:
        %       -on verifit si le port com est ouvert
        %       -on verifie si une initialisation est faite
        %           -si oui on lance principale1.m
        %           -si non on initialise avant et on lance principale1.m
        
        %selection de l'index main gauche
        index_selected = get(hObject,'Value');
        
        if ( index_selected==2)
            
            %------------main gauche-----------------------------------------
            %Permet d'ouvrir la main qu'une fois pour les menus déroulants
            if ouvert_gauche==0
                
                fopen(s1);
                ouvert_gauche=1;
            end
            
            %Permet de ne faire l'initialisation qu'une fois
            g=initialisationtest(s1);
            if g==0
                initialisation(s1);
                g=1;
            end
            
            %Lance la fenetre mode EMG control
            mode_EMG_prop_control(s1)
            
            %selection de l'index main droite
        else if (index_selected==3)
                
                %------------main droite--------------------------------------------
                
                %permet d'ouvrir la main qu'une seul fois
                if ouvert_droit==0
                    fopen(s2);
                    ouvert_droit=1;
                end
                
                %permet de ne faire l'initialisation qu'une fois
                d=initialisationtest(s2);
                if d==0
                    initialisation(s2);
                    d=1;
                end
                
                %Fenetre mode EMG control
                mode_EMG_prop_control(s2);
                
                %selection de l'index les deux mains
            else if(index_selected==4)
                    
                    
                    %------------main gauche-----------------------------------------
                    %Meme principe que pour les deux premier index
                    if ouvert_gauche==0;
                        
                        fopen(s1);
                        ouvert_gauche=1;
                    end
                    
                    %------------main droite--------------------------------------------
                    
                    if ouvert_droit==0;
                        
                        fopen(s2);
                        ouvert_droit=1;
                    end
                    
                    %initialisation
                    d=initialisationtest(s2);
                    g=initialisationtest(s1);
                    
                    if d==0
                        initialisation(s1);
                        d=1;
                    end
                    
                    mode_EMG_prop_control(s1);
                    
                    if g==0
                        initialisation(s2);
                        g=1;
                    end
                    
                    mode_EMG_prop_control(s2);
                end
            end
        end
    end %function choix_mainModeEMG_velocity_control
end