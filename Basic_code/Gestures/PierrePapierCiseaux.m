%Pierre papier ciseaux
function PierrePapierCiseaux(s,text)
% mot aleatoire compris entre 1 et 3
PPC=fix(1+(4-1)*rand(1,1));

%Initialise la main � une position de repos
back_main(s);

%lance le jeu en affichant les trois mots magiques
set(text,'String','Pierre');
pause(1);
set(text,'String','Papier');
pause(1);
set(text,'String','Ciseaux');


%conditionnel d�pendant de la valeur al�atoire du dessu
if PPC==1,
    back_main(s);
    disp('-------Reponse--------');
    disp('PAPIER');
elseif PPC==2,
    mouv_main(s);
    disp('-------Reponse--------');
    disp('PIERRE');
else
    Ciseaux(s);
    disp('-------Reponse--------');
    disp('CISEAUX');
end

pause(3);

%retour � la valeur de repos
back_main(s)

    