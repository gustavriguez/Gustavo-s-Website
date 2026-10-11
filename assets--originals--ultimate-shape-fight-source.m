1% state all the sizes and stuff here.
gap=10;
shapewidth=5;
shapeheight=20;
playerleftpos=[gap,shapewidth+3*gap];
playerrightpos=[15,40];
% for these the first column is the respective location of player 1 and 2
centerpos=playerleftpos+shapewidth/2;
% the center for each shape again in a matrix 1x2
shieldgap=2;
shieldthick=1;
shieldleft=[playerrightpos(1)+shieldgap, playerleftpos(2)-shieldgap-shieldthick];
shieldright=shieldleft+shieldthick;
% leftright and thickness and space from player of the shield

ballradius=1.67;
% hehe, ball radius

lasergap=2;
laserheight=1.67;
% hehe, again just stating distin x from shape and the height it starts at
laserybottom=shapeheight/2-laserheight/2;
laserytop=shapeheight/2+laserheight/2;
% just the top and bottom y values of it, so the thickness essentially
chargelength=3;
% these state the distance from each player, how tall itsll be, where it
% starts/end on the y axis, and the initial length
laserleftbase=[playerrightpos(1)+lasergap, playerleftpos(2)-lasergap-chargelength];
laserrightbase=laserleftbase+chargelength;
% thes store the x value of left and right of laser, as a 1x2 matric, clmn
% 2 corresponds to p2, for left and right
shapechoice=[0 0];
shapecolor=[0 0 0; 0 0 0];
lasercolor=[0 0 0; 0 0 0];
hits=[0 0];
% creates the 1x2 and 2x3 matrices to store each players data, shape choice
% (1,1) stores the playerleftpos shape and (1,2) store p2, same idea with
% shape/laser color with each row being a player
activeheight=[shapeheight shapeheight];
% active height will be changed in the shrink for loop but for all the
% other blocks its essentially meaningless, regardless i just used it
start=67;
% arbitrary as long as its not==1
fprintf('Welcome to the dungeon, Where Shapes come to Fight and dreams come to DIE\n: ')
start=input('Type 1 to START: ');
while start~=1;
    start=input('Type 1 to START: ');
end
if start==1
showruleset=input('Type 1 to see ruleset or 0 to not: ');
while showruleset~=1 && showruleset~=0
    showruleset=input('Invalid Choice Try Again: ');
end
end
% just a simple while loop if its not 1 itll just retry

if showruleset==1
    fprintf('\n2 players are required\n\n');
    fprintf('Select a character, health bar color as well as a laser color\n\n');
    fprintf('Choose moves in private\n\n');
    fprintf('Quick Attacks-Hits faster than laser, but shield blocks it\n\n');
    fprintf('Laser attacks cut through a shield but quick attacks hit first\n\n');
    fprintf('Shield deflects the Quick attack, but laser breaks it\n\n');
    % rules you gave us
  
% two \n so you can read
end

for player=1:2
    if player==2
        clc;
        % clears for player2
    end
   
    fprintf('--- Player %i Setup ---\n', player);
    fprintf('Pick your shape\n');
    fprintf('1: Rectangle\n');
    fprintf('2: Triangle\n');
    shapechoice(player)=input('Enter: ');
    while shapechoice(player)~=1 && shapechoice(player)~=2
        shapechoice(player)=input('Invalid choice, try again: ');
    end
    % another simple loop since theres only two choices

    fprintf('\n');
    fprintf('Player %i: choose your health bar color\n', player);
    fprintf('1: Blue\n');
    fprintf('2: Red\n');
    fprintf('3: Random Color\n');
    healthcolor=input('Enter: ');
    while healthcolor~= 1 && healthcolor~=2 && healthcolor~=3
        healthcolor=input('Invalid choice, try again: ');
    end

    if healthcolor== 1
        shapecolor(player,:)=[0 0 1];
    elseif healthcolor== 2
        shapecolor(player,:)=[1 0 0];
    else
        shapecolor(player,:)=[rand(1) rand(1) rand(1)];
    end
    % all jst stating the color as a matrix, these are stored in a 2x3
    % where row 1 is for player 1 and p2 is row 2 
    fprintf('\n');
    fprintf('Player %i: choose your laser color\n', player);
    fprintf('1: Red\n');
    fprintf('2: Green\n');
    fprintf('3: Blue\n');
    laserchoice=input('Enter here: ');
    while laserchoice~=1 && laserchoice~=2 && laserchoice~=3
        laserchoice=input('Invalid choice, try again: ');
    end
if laserchoice== 1
        lasercolor(player,:)=[1 0 0];
    elseif laserchoice== 2
        lasercolor(player,:)=[0 1 0];
    else
        lasercolor(player,:)=[0 0 1];
    end

    fprintf('\n');
    if player==1
        disp('Pass to Player 2');
        pause(.5);
    end
end
figure(1)
plot([0 50],[60 60],'w')
% this is the plot defining the ground, and defines the height of the plot,
hold on
% ticks/axes
xticks([0 50]);
yticks([0 10 20 40 60]);
set(gca,'fontsize',12);
healthfrac1=1-hits(1)/4;
healthfrac2=1-hits(2)/4;
% there is 4hp, so the total here is 1 and subtracted by a portion of 1
% until 4 hits are done the percentage of hit/4 is used later

if shapechoice(1)==1
    if healthfrac1>0 
    player1fill=fill([playerleftpos(1) playerleftpos(1) playerrightpos(1) playerrightpos(1) playerleftpos(1)],[0 activeheight(1)*healthfrac1 activeheight(1)*healthfrac1 0 0],shapecolor(1,:));
    % goes from left to right and then back left to close the shape, for
    % the y it uses the active height which is decreased by the hit
    % percentage, so hit once means 75% height, again starts from 0 and
    % here closes as well.
    else 
    player1fill=plot([0 0],[0 0],'w');
    % if it not above 0 then its not filled
    end
    player1outline=plot([playerleftpos(1) playerleftpos(1) playerrightpos(1) playerrightpos(1) playerleftpos(1)],[0 activeheight(1) activeheight(1) 0 0],'k','linewidth',1.5);
    % outline stays the same until the srink block
else
if healthfrac1>0
    fillheight1=activeheight(1)*healthfrac1;
    toplefttri=playerleftpos(1)+shapewidth*healthfrac1/2;
    % for the triang it takes top lefft and right positions and moves
    % inward with each reduction in the healthfraction 
    toprighttri=playerrightpos(1)-shapewidth*healthfrac1/2;
    player1fill=fill([playerleftpos(1) playerrightpos(1) toprighttri toplefttri playerleftpos(1)],[0 0 fillheight1 fillheight1 0],shapecolor(1,:));
    % then i take the topleft and topright for the x fill and in the y fill
    % it just fills it up to that height 
else
    player1fill=plot([0 0],[0 0],'w');
end
player1outline =plot([playerleftpos(1) centerpos(1) playerrightpos(1) playerleftpos(1)],[0 activeheight(1) 0 0],'k','linewidth',1.5);
end

% repeat for shape for p2 
if shapechoice(2)==1
    if healthfrac2>0 
    player2fill=fill([playerleftpos(2) playerleftpos(2) playerrightpos(2) playerrightpos(2) playerleftpos(2)],[0 activeheight(2)*healthfrac2 activeheight(2)*healthfrac2 0 0],shapecolor(2,:));
    else 
    player2fill=plot([0 0],[0 0],'w');
    end
    player2outline=plot([playerleftpos(2) playerleftpos(2) playerrightpos(2) playerrightpos(2) playerleftpos(2)],[0 activeheight(2) activeheight(2) 0 0],'k','linewidth',1.67);
else
if healthfrac2>0
    fillheight2=activeheight(2)*healthfrac2;
    toplefttri2=playerleftpos(2)+shapewidth*healthfrac2/2;
    toprighttri2=playerrightpos(2)-shapewidth*healthfrac2/2;
    player2fill=fill([playerleftpos(2) playerrightpos(2) toprighttri2 toplefttri2 playerleftpos(2)],[0 0 fillheight2 fillheight2 0],shapecolor(2,:));
else
    player2fill=plot([0 0],[0 0],'w');
end
player2outline=plot([playerleftpos(2) centerpos(2) playerrightpos(2) playerleftpos(2)],[0 activeheight(2) 0 0],'k','linewidth',1.67);
end
winner=0;
% begin the move loop/hp loop
while winner==0 
    fprintf('Player 1: Choose Your Move\n')
    fprintf('1-Quick Attack\n')
    fprintf('2-Charged Laser\n')
    fprintf('3-Recoil Shield\n')
    move1=input('Enter: ');
while move1~=1 && move1~=2 && move1~=3
    move1=input('Invalid, try again: ')
end
clc
  
  fprintf('Player 2: Choose Your Move\n')
  fprintf('1-Quick Attack\n')
  fprintf('2-Charged Laser\n')
  fprintf('3-Recoil Shield\n')
  move2=input('Enter: ');

while move2~=1 && move2~=2 && move2~=3
    move2=input('Invalid, try again: ')
end
clc
damage=0;
% if =1 player 1 gets hit etc.
% will go thru every move possiblity

if move1==1
    if move2==1
         xball1=linspace(playerrightpos(1)+1, 50/2-ballradius/2, 25);
         % plotwidt is 50, iwanted to do 67 but it was too slow, starts
         % right ahead of each player and stops right at the center of the
         % plot but a little shy bc the ball radius is taken into
         % consideration
         xball2=linspace(playerleftpos(2)-1, 50/2+ballradius/2, 25);
for n=1:length(xball1)
quickball1=plot(xball1(n),shapeheight/2,'o','MarkerSize',20,'MarkerFaceColor',shapecolor(1,:),'MarkerEdgeColor',shapecolor(1,:));
quickball2=plot(xball2(n),shapeheight/2,'o','MarkerSize',20,'MarkerFaceColor',shapecolor(2,:),'MarkerEdgeColor',shapecolor(2,:));
% markers match the shape color 
    pause(.05)
    delete(quickball1)
    delete(quickball2)
    end
    roundmessage='Attacks cancel';

    elseif move2==2
xball1=linspace(playerrightpos(1)+1,centerpos(2),25);
% starts ahead of p1 and stops at the middle of p2
for n=1:length(xball1)
   quickball1=plot(xball1(n),shapeheight/2,'o','MarkerSize',20,'MarkerFaceColor',shapecolor(1,:),'MarkerEdgeColor',shapecolor(1,:));
    laser2=fill([laserleftbase(2) laserleftbase(2) laserrightbase(2) laserrightbase(2) laserleftbase(2)],[ laserybottom laserytop laserytop laserybottom laserybottom], lasercolor(2,:)*n/length(xball1));
% fills the edges leftbase is leftedge of laser; top and bottom explanatory
% in thename, but the color is multiplied by n and divided by the length,
% so for each stop in animation the color spectrum increases as the n
% increases to match the length
pause(0.05)
delete(quickball1)
delete(laser2)
end
damage=2;
roundmessage='Laser Too slow, Player #2 is hit';
    else
        % shield logic will be else
       shield2=fill([shieldleft(2) shieldleft(2) shieldright(2) shieldright(2) shieldleft(2)],[ 0 shapeheight shapeheight 0 0], shapecolor(2,:));
       xballfwd=linspace(playerrightpos(1) +1, shieldleft(2)-ballradius, 15);
       xballback=linspace(shieldleft(2)-ballradius, centerpos(1), 15);
       for n=1:length(xballfwd)
           quickball1=plot(xballfwd(n),shapeheight/2,'o','MarkerSize',20, 'MarkerFaceColor',shapecolor(1,:),'MarkerEdgeColor',shapecolor(1,:));
           pause(0.05)
           delete(quickball1)
          
       end
       for n=1:length(xballback)
           quickball1=plot(xballback(n),shapeheight/2,'o','MarkerSize',20, 'MarkerFaceColor',shapecolor(1,:),'MarkerEdgeColor',shapecolor(1,:));
           pause(0.05)
           delete(quickball1)
       end
       delete(shield2)
       damage=1;
       roundmessage='Quick attack deflection, Player #1 got hit';

    % create for move1==2 and so on
end
 % contine with move logic for each possible combo 
elseif move1==2
    if move2==1
        xball2=linspace(playerleftpos(2)-1, centerpos(1),25);
        for n=1:length(xball2)
laser1=fill([laserleftbase(1) laserleftbase(1) laserrightbase(1) laserrightbase(1) laserleftbase(1)],[ laserybottom laserytop laserytop laserybottom laserybottom], lasercolor(1,:)*n/length(xball2));
 quickball2=plot(xball2(n),shapeheight/2,'o','MarkerSize',20,'MarkerFaceColor',shapecolor(1,:),'MarkerEdgeColor',shapecolor(2,:));
       pause(.05)
       delete(laser1)
       delete(quickball2)
       end
damage=1;
roundmessage='Laser too slow, player #1 hit';
    elseif move2==2
  chargen=10;
  laserright1=linspace(laserrightbase(1),50/2,10);
  laserleft2=linspace(laserleftbase(2),50/2,10);
        for n=1:chargen
        laser1=fill([laserleftbase(1) laserleftbase(1) laserrightbase(1) laserrightbase(1) laserleftbase(1)],[ laserybottom laserytop laserytop laserybottom laserybottom], lasercolor(1,:)*n/chargen);
        laser2=fill([laserleftbase(2) laserleftbase(2) laserrightbase(2) laserrightbase(2) laserleftbase(2)],[ laserybottom laserytop laserytop laserybottom laserybottom], lasercolor(2,:)*n/chargen);
pause(0.05)
delete(laser1)
delete(laser2)
        end
        for n=1:length(laserright1)
        laser1=fill([laserleftbase(1) laserleftbase(1) laserright1(n) laserright1(n) laserleftbase(1)],[ laserybottom laserytop laserytop laserybottom laserybottom], lasercolor(1,:));
        laser2=fill([laserleft2(n) laserleft2(n) laserrightbase(2) laserrightbase(2) laserleft2(n)],[ laserybottom laserytop laserytop laserybottom laserybottom], lasercolor(2,:));    
pause(.05)
delete(laser1)
delete(laser2)
        end
        roundmessage='Attacks cancel';
    else 
        shield2=fill([shieldleft(2) shieldleft(2) shieldright(2) shieldright(2) shieldleft(2)], [0 shapeheight shapeheight 0 0],shapecolor(2,:));
        chargen=10;
        laserright1=linspace(laserrightbase(1),centerpos(2)+1,15);
for n=1:chargen
    laser1=fill([laserleftbase(1) laserleftbase(1) laserrightbase(1) laserrightbase(1) laserleftbase(1)],[ laserybottom laserytop laserytop laserybottom laserybottom], lasercolor(1,:)*n/chargen);
    pause(.05)
    delete(laser1)
end
for n=1:length(laserright1)
laser1=fill([laserleftbase(1) laserleftbase(1) laserright1(n) laserright1(n) laserleftbase(1)],[ laserybottom laserytop laserytop laserybottom laserybottom], lasercolor(1,:));
pause(0.05)
delete(laser1)
end
delete(shield2)
damage=2;
roundmessage='Shield broken, Player#2 got hit';
    end
else
    if move2==1
        shield1=fill([shieldleft(1) shieldleft(1) shieldright(1) shieldright(1) shieldleft(1)],[0 shapeheight shapeheight 0 0],shapecolor(1,:));
        xballfwd=linspace(playerleftpos(2)-1,shieldright(1)+ballradius,10);
        xballback=linspace(shieldright(1)+ballradius,centerpos(2),15);

      for n=1:length(xballfwd)
      quickball2=plot(xballfwd(n),shapeheight/2,'o','MarkerSize',20,'MarkerFaceColor',shapecolor(1,:),'MarkerEdgeColor',shapecolor(1,:));
      pause(0.05)
      delete(quickball2)
end
for n=1:length(xballback)
      quickball2=plot(xballback(n),shapeheight/2,'o','MarkerSize',20,'MarkerFaceColor',shapecolor(1,:),'MarkerEdgeColor',shapecolor(1,:));
      pause(0.05)
      delete(quickball2)
end
delete(shield1)
damage=2;
roundmessage='Quick attack deflected, Player #2 got hit';
    elseif move2==2
       shield1=fill([shieldleft(1) shieldleft(1) shieldright(1) shieldright(1) shieldleft(1)],[0 shapeheight shapeheight 0 0],shapecolor(1,:));
chargen=10;
laserleft2=linspace(laserleftbase(2), centerpos(1)-1,15);
for n=1:chargen
    laser2=fill([laserleftbase(2) laserleftbase(2) laserrightbase(2) laserrightbase(2) laserleftbase(2)],[laserybottom laserytop laserytop laserybottom laserybottom],lasercolor(2,:)*n/chargen);
pause(0.05)
delete(laser2)
end

for n=1:length(laserleft2)
    laser2=fill([laserleft2(n) laserleft2(n) laserrightbase(2) laserrightbase(2) laserleft2(n)],[laserybottom laserytop laserytop laserybottom laserybottom],lasercolor(2,:)*n/length(laserleft2));
pause(0.05)
delete(laser2)
end
delete(shield1)
damage=1;
    roundmessage='Shield broken, Player #1 hit';
    else 
    shield1=fill([shieldleft(1) shieldleft(1) shieldright(1) shieldright(1) shieldleft(1)],[0 shapeheight shapeheight 0 0],shapecolor(1,:));
    shield2=fill([shieldleft(2) shieldleft(2) shieldright(2) shieldright(2) shieldleft(2)],[0 shapeheight shapeheight 0 0],shapecolor(2,:));
    pause(1)
    delete(shield1)
    delete(shield2)
    roundmessage='Boring no one gets damaged :(';
    end
end
if damage==1
    hits(1)=hits(1)+1;
elseif damage==2
    hits(2)=hits(2)+1;
end

delete(player1fill)
delete(player1outline)
delete(player2fill)
delete(player2outline)
healthfrac1=1-hits(1)/4;
healthfrac2=1-hits(2)/4;

% once move logic is done, it delets the fills and shapes and redraws them
if shapechoice(1)==1
    if healthfrac1 > 0
        player1fill=fill([playerleftpos(1) playerleftpos(1) playerrightpos(1) playerrightpos(1) playerleftpos(1)],[0 activeheight(1)*healthfrac1 activeheight(1)*healthfrac1 0 0], shapecolor(1,:));
    else
        player1fill=plot([0 0],[0 0],'w');
    end
        player1outline=plot([playerleftpos(1) playerleftpos(1) playerrightpos(1) playerrightpos(1) playerleftpos(1)],[0 activeheight(1) activeheight(1) 0 0],'k','linewidth',1.5);
    else
        if healthfrac1 > 0
            fillheight1=activeheight(1)*healthfrac1;
            toplefttri=playerleftpos(1)+shapewidth*healthfrac1/2;
            toprighttri=playerrightpos(1)-shapewidth*healthfrac1/2;
            player1fill=fill([playerleftpos(1) playerrightpos(1) toprighttri toplefttri playerleftpos(1)],[0 0 fillheight1 fillheight1 0],shapecolor(1,:));
        else
        player1fill=plot([0 0],[0 0],'w');
        end
        player1outline=plot([playerleftpos(1) centerpos(1) playerrightpos(1) playerleftpos(1)],[0 activeheight(1) 0 0],'k','linewidth',1.5);
    end

    if shapechoice(2)== 1
        if healthfrac2 > 0
            player2fill =fill([playerleftpos(2) playerleftpos(2) playerrightpos(2) playerrightpos(2) playerleftpos(2)],[0 activeheight(2)*healthfrac2 activeheight(2)*healthfrac2 0 0],shapecolor(2,:));
        else
            player2fill=plot([0 0],[0 0],'w');
        end
        player2outline=plot([playerleftpos(2) playerleftpos(2) playerrightpos(2) playerrightpos(2) playerleftpos(2)],[0 activeheight(2) activeheight(2) 0 0],'k','linewidth',1.5);
    else
        if healthfrac2 > 0
            fillheight2=activeheight(2)*healthfrac2;
            toplefttri2=playerleftpos(2)+shapewidth*healthfrac2/2;
            toprighttri2=playerrightpos(2)-shapewidth*healthfrac2/2;
            player2fill=fill([playerleftpos(2) playerrightpos(2) toprighttri2 toplefttri2 playerleftpos(2)],[0 0 fillheight2 fillheight2 0],shapecolor(2,:));
        else
            player2fill=plot([0 0],[0 0],'w');
        end
        player2outline=plot([playerleftpos(2) centerpos(2) playerrightpos(2) playerleftpos(2)],[0 activeheight(2) 0 0],'k','linewidth',1.5);
    end

   disp(roundmessage)
    pause(1.5)
    clc

    if hits(1)>=4
        winner=2;
        loser=1;
    elseif hits(2)>=4
        winner=1;
        loser=2;
    end
end

for shrink=1:67
    % jeje
    activeheight(loser)=shapeheight*(1-(shrink)/67);

   % loser is the one who will be squashed by matlabs evil reign
    delete(player1fill)
    delete(player1outline)
    delete(player2fill)
    delete(player2outline)
    healthfrac1=1-hits(1)/4;
    healthfrac2=1-hits(2)/4;
    % same idea redraws them here
    % so inn this block only the loser will be affeccted by the shrink as
    % the active height will only reduce fromm the for loop if they are
    % loser. so if p2 lost loser is 2, and so on.
  if shapechoice(1)== 1
        if healthfrac1>0
        player1fill=fill([playerleftpos(1) playerleftpos(1) playerrightpos(1) playerrightpos(1) playerleftpos(1)],[0 activeheight(1)*healthfrac1 activeheight(1)*healthfrac1 0 0],shapecolor(1,:));
        else
        player1fill=plot([0 0],[0 0],'w');
        end
        player1outline=plot([playerleftpos(1) playerleftpos(1) playerrightpos(1) playerrightpos(1) playerleftpos(1)], [0 activeheight(1) activeheight(1) 0 0],'k','linewidth',1.5);
    else
        if healthfrac1>0
            fillheight1=activeheight(1)*healthfrac1;
            toplefttri=playerleftpos(1)+shapewidth*healthfrac1/2;
            toprighttri=playerrightpos(1)-shapewidth*healthfrac1/2;
            player1fill=fill([playerleftpos(1) playerrightpos(1) toprighttri toplefttri playerleftpos(1)], [0 0 fillheight1 fillheight1 0],shapecolor(1,:));
        else
            player1fill=plot([0 0],[0 0],'w');
        end
        player1outline=plot([playerleftpos(1) centerpos(1) playerrightpos(1) playerleftpos(1)],[0 activeheight(1) 0 0],'k','linewidth',1.5);
    end

    if shapechoice(2)== 1
        if healthfrac2>0
            player2fill=fill([playerleftpos(2) playerleftpos(2) playerrightpos(2) playerrightpos(2) playerleftpos(2)],[0 activeheight(2)*healthfrac2 activeheight(2)*healthfrac2 0 0],shapecolor(2,:));
         
        else
            player2fill=plot([0 0],[0 0],'w');
        end
        player2outline=plot([playerleftpos(2) playerleftpos(2) playerrightpos(2) playerrightpos(2) playerleftpos(2)],[0 activeheight(2) activeheight(2) 0 0],'k','linewidth',1.5);
    else
        if healthfrac2>0
            fillheight2=activeheight(2)*healthfrac2;
            toplefttri2=playerleftpos(2)+shapewidth*healthfrac2/2;
            toprighttri2=playerrightpos(2)-shapewidth*healthfrac2/2;
            player2fill=fill([playerleftpos(2) playerrightpos(2) toprighttri2 toplefttri2 playerleftpos(2)],[0 0 fillheight2 fillheight2 0],shapecolor(2,:));
        else
            player2fill=plot([0 0],[0 0],'w');
        end
        player2outline=plot([playerleftpos(2) centerpos(2) playerrightpos(2) playerleftpos(2)],[0 activeheight(2) 0 0],'k','linewidth',1.5);
    end
    pause(0.05)
end

if winner== 1
    title('Congratulations Player 1! Victory is yours!','fontsize',16)
    fprintf('Player 1 wins!\n')
else
    title('Congratulations Player 2! Victory is yours!','fontsize',16)
    fprintf('Player 2 wins!\n')
end



% ARIGATO GOZAIMASU DOCTORRR BRETTT :)