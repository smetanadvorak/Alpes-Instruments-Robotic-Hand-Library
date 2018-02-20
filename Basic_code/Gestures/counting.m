function counting(s1,s2)
%création de la figure
fig=figure('Name','simple result','NumberTitle','off','Resize','off','MenuBar','none','Position',[600,300,200,200]);
set(fig,'color',[1 1 1]);

%textes
uicontrol('Style','text','String','additionner ou multiplier deux chiffres',...
    'Position', [50 120 100 50]);
uicontrol('Style','text','String','(max resultat=10)',...
    'Position', [50 60 100 20]);

%edit pour rentré le calcul
count=uicontrol('Style','edit',...
    'Position',[70 90 60 20],...
    'Callback',@EditCallBack_count);


    function EditCallBack_count(varargin)
        %récuperation de la chaine de charactere
        num = get(count,'String');
        
        %séparation de la chaine pour récuperer le symbole
        chiffre1=str2double(num(1));
        
        %resulte égale à 10 permet de laisser la main ouverte
        result=10;
        
        %recuperation du calcule en lui même
        %recherche du symbole '+','*','x'
        if num(2)=='+'
            chiffre2=str2double(num(3));
            result=chiffre1+chiffre2;
        end
        if num(2)=='*'
            chiffre2=str2double(num(3));
            result=chiffre1*chiffre2;
        end
        if num(2)=='x'
            chiffre2=str2double(num(3));
            result=chiffre1*chiffre2;
        end
        
        %le cas ou le premier nombre est 10 
        if num(2)=='0'
            
            chiffre12=str2double(strcat(num(1),num(2)));
            if num(3)=='+'
                chiffre3=str2double(num(4));
                result=chiffre12+chiffre3;
            end
            if num(3)=='*'
                chiffre3=str2double(num(4));
                result=chiffre12*chiffre3;
            end
            if num(3)=='x'
                chiffre3=str2double(num(4));
                result=chiffre12*chiffre3;
            end
        end
           
        
        %mouvement de la main en fonction du résultat
        %récuperation de programmes pour faire les mouvement
        if result<=10
            if result==0
                mouv_main(s1)
                mouv_main(s1)
            end
            if result==1
                un(s1)
                mouv_main(s2)
                
            end
            if result==2
                deux(s1)
                mouv_main(s2)
                
            end
            if result==3
                trois(s1)
                mouv_main(s2)
                
            end
            if result==4
                quatre(s1)
                mouv_main(s2)
                
            end
            if result==5
                back_main(s1)
                mouv_main(s2)
            end
            if result==6
                un(s2)
                back_main(s1)
                
            end
            if result==7
                deux(s2)
                back_main(s1)
            end
            if result==8
                trois(s2)
                back_main(s1)
            end
            if result==9
                quatre(s2)
                back_main(s1)
            end
            if result==10
                back_main(s1);
                back_main(s2);
                
            end
       
        end
        
        %pause de 3 seconde
        pause(3);
        
        %réouverture des deux mains
        back_main(s1);
        back_main(s2);
        
    end
end
                

    
