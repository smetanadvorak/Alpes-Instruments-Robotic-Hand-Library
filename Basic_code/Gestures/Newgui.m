function Newgui(s)

%
%Quelques exemples de mouvements de main
%
%-----------------generation d'une fenetre------------------------

fig=figure('NumberTitle','off','Resize','off');
%donne le nom de la fenetre en fonction de la main branchée

set(fig,'color',[1 1 1]);


uicontrol('Style','text','String','à faire entre chaque',...
    'Position', [135 120 100 20]);
uicontrol('Style','pushbutton','String','reset','position',...
    [150 100 70 20],'Callback',@open);

%FU**
uicontrol('Style','pushbutton','String','Not agree','position',...
    [50 220 70 20],'Callback',@Notagree);

%Peace and love
uicontrol('Style','pushbutton','String','Peace','position',...
    [50 170 70 20],'Callback',@peace);

%Viva la revolution
uicontrol('Style','pushbutton','String','revolution','position',...
    [50 270 70 20],'Callback',@close);

%compter de 1 à 5
uicontrol('Style','pushbutton','String','count','position',...
    [50 320 70 20],'Callback',@count);

%décompter de 5 à 1
uicontrol('Style','pushbutton','String','countdown','position',...
    [50 370 70 20],'Callback',@countdown);

%vien par ici
uicontrol('Style','pushbutton','String','come','position',...
    [150 370 70 20],'Callback',@come);

%ROCK AND ROLL
uicontrol('Style','pushbutton','String','ROCK','position',...
    [150 320 70 20],'Callback',@rock);

%Lever du petit doigt
uicontrol('Style','pushbutton','String','snob','position',...
    [150 270 70 20],'Callback',@snob);

%PAN
uicontrol('Style','pushbutton','String','gun','position',...
    [150 220 70 20],'Callback',@gun);

%High five bro
uicontrol('Style','pushbutton','String','high five','position',...
    [150 170 70 20],'Callback',@five);

%J'ai une question monsieur
uicontrol('Style','pushbutton','String','question','position',...
    [250 170 70 20],'Callback',@question);

%J'ai une question monsieur
uicontrol('Style','pushbutton','String','Perf','position',...
    [250 220 70 20],'Callback',@PERFECT);


%PERFECT
    function PERFECT(varargin)
        PERF(s)
    end
        
%reset
    function open(varargin)
        back_main(s)
    end

%FU**
    function Notagree(varargin)
        honneur(s);
    end

%Peace and love
    function peace(varargin)
        paix(s);
    end

%Revolution
    function close(varargin)
        mouv_main2(s);
    end

%compter
    function count(varargin)
        un(s)
        pause(3)
        deux(s)
        pause(1)
        trois(s)
        pause(1)
        quatre(s)
        pause(1)
        back_main(s)
    end

%decompter
    function countdown(varargin)
        back_main(s)
        pause(1)
        quatre(s)
        pause(1)
        trois(s)
        pause(1)
        deux(s)
        pause(3)
        un(s)
        pause(3)
        back_main(s)
    end


%Vien       
    function come(varargin)
        comon(s)
        pause(2)
        mouv_main2(s)
        comon(s)
        mouv_main2(s)
        comon(s)
        mouv_main2(s)
        comon(s)
        mouv_main2(s)
    end

%ROCK AND ROLL
    function rock(varargin)
        ROCK(s)
    end

%lever du petit doigt
    function snob(varargin)
        ptit_doigt(s)
    end

%PAN
    function gun(varargin)
        deux(s)
        pause(2)
        trois(s)
        
    end

%high five
    function five(varargin)
        back_main(s)
        mouv_main(s)
        pause(2)
        back_main(s)
    end

%Question
    function question(varargin)
        leverDoigt(s)
    end
end