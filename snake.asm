#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas obligatoire de comprendre ce qu'elles font.

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0x00396239, 0x00ff00ff, 0xff00ff00, 0x00FFFF00, 0x000000FF, 0x0000FFFF, 0x00800080, 0x00FFA500, 0x00f00e0e
.eqv black 0
.eqv red   4
.eqv greenV2 8
.eqv rose  12
.eqv green  16
.eqv yellow 20
.eqv blue 24
.eqv cyan 28
.eqv purple 32
.eqv orange
.eqv redV2
score: .asciiz "Votre score est de :"

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4


PSLoop:
  bge $s1 $s0 endPSLoop
  li $t1 7
  srl $s2 $s1 2
  div $s2 $t1
  mfhi $s2
  li $a0 4
  mul $a0 $s2 $a0
  lw $a0 colors+green($a0)
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 122
beq $t0 $t1 GIhaut
li $t1 115
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra
################################ getLevel #################################
# Paramètres: Aucun
#La fonction affiche les niveau , et les change en fonction du choix de l'utilisateur
#la fonction place �galement les obstacles de fa�on al�atoire
# Retour: Aucun
################################################################################
getLevel:
subu $sp $sp				
sw $ra ($sp)					#range la valeur $ra
reset:
li $a0 50					#on utilise la fonction sleep pour ne pas surcharger le processeur
jal sleepMillisec
lw $t0 0xffff0004				#on charge dans $t0 l'entr�e 
beqz $t0 reset					#on boucle sur reset jusqu'a que l'entr�e soit differente de 0
jal resetAffichage

read:
lw $t0 0xffff0004				#on charge dans $t0 l'entr�e 
beq $t0 122 levelHaut#z				#Saut conditionnel correspendante a l'entr�e : Z haut S bas Q gauche D droite
beq $t0 115 levelBas#s
beq $t0 113 levelGauche #q
beq $t0 100 levelDroite #d
beq $t0 10 confirmLevel				#Confirmation du niveau , entr�e dans la partie de construction du niveau
j printLevels
printLevels:					#fonction qui dessine les niveaux
bne $s6 0 l2
jal printLevel1
j reset
l2:bne $s6 1 l3
jal printLevel2
j reset
l3:bne $s6 2 l4
jal printLevel3
j reset
l4:bne $s6 3 l5
jal printLevel4
j reset
l5:bne $s6 4 l6
jal printLevel5
j reset
l6:bne $s6 5 l7
jal printLevel6
j reset
l7:bne $s6 6 l8
jal printLevel7
j reset
l8:bne $s6 7 lQ
jal printLevel8
j reset
lQ:
jal printLevelQ
j reset


confirmLevel:					#en fonction du choix , met les variables aux valeurs correspendante 
beq $s6 0 level1
beq $s6 1 level2
beq $s6 2 level3
beq $s6 3 level4
beq $s6 4 level5
beq $s6 5 level6
beq $s6 6 level7
beq $s6 7 level8
beq $s6 8 exit
endLevel:					#place les obstacles
subi $t6 $t6 1					#nb obstacles - 1
loopLevel:beq $t6 -1 skipLevel			#condition sortie
jal newRandomObjectPosition
mul $t2 $t6 4					#Valeur en octet (nbObstacles*4)
sw $v0 obstaclesPosX($t2)			
sw $v1 obstaclesPosY($t2)
subi $t6 $t6 1					#d�crementation
j loopLevel					#Saut boucle
skipLevel:
lw $ra ($sp)				
addu $sp $sp 4
jr $ra
						#lecture d'entr�e pour changer le niveau
levelHaut:
la $t8 0xffff0004
li $t9 0
sw $t9 ($t8)
subi $s6 $s6 4
j test
levelBas:
la $t8 0xffff0004
li $t9 0
sw $t9 ($t8)
addi $s6 $s6 4
j test
levelDroite:
la $t8 0xffff0004
li $t9 0
sw $t9 ($t8)
addi $s6 $s6 1
j test
levelGauche:
la $t8 0xffff0004
li $t9 0
sw $t9 ($t8)
subi $s6 $s6 1
j test
						#Cas ou les valeurs sont supperieurs aux niveaux disponibles
test:
addi $s6 $s6 9
li $t8 9
div $s6 $t8
mfhi $s6
j printLevels
						#chargement des valeurs (nb obstacles et vitesse de jeu)
level1:
li $s5 500
li $s3 1
li $t6 0
sw $t6 numObstacles
j endLevel
level2:
li $s3 1
li $s5 450
li $t6 5
sw $t6 numObstacles
j endLevel
level3:
li $s3 2
li $s5 400
li $t6 3
sw $t6 numObstacles
j endLevel
level4:
li $s3 3
li $s5 350
li $t6 6
sw $t6 numObstacles
j endLevel
level5:
li $s3 5
li $s5 300
li $t6 7
sw $t6 numObstacles
j endLevel
level6:
li $s3 10
li $s5 250
li $t6 12
sw $t6 numObstacles
j endLevel
level7:
li $s3 15
li $s5 200
li $t6 16
sw $t6 numObstacles
j endLevel
level8:
li $s3 20
li $s5 150
li $t6 20
sw $t6 numObstacles
j endLevel




##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition

sw $v0 candy
sw $v1 candy + 4
jal printLevel1						#saut pour choix niveaux
li $s6 0
jal getLevel
jal resetAffichage
# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
move $a0 $s5
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $a0 10000					#sleep de 10 s pour permetre de rejouer et reinitialisation des variables aux valeurs initiales
jal sleepMillisec
li $t0 0
li $t1 1
sw $t1 snakeDir
sw $t1 tailleSnake
sw $t0 snakePosX
sw $t0 snakePosY
sw $t0 scoreJeu
la $t8 0xffff0004
li $t9 0
sw $t9 ($t8)
j main
exit:
jal resetAffichage
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1          # Taille actuelle du serpent.
snakePosX:     .word 0 : 4096  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 4096  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 4096  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 4096  # Coordonnées Y des obstacles
candy:         .word 0, 
0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente à du cannibalisme
#                 et à été proscrit par la loi dans les sociétés reptiliennes.
################################################################################

majDirection:
subu $sp $sp 4						#range la valeur $ra
sw $ra ($sp)
beq $a0 4 skipDir					#lis les valeurs de l'entr�e et fait des saut conditionelle pour l'affectation de snake dir
lw $t1 snakeDir
beq $t1 0 condHaut					#Saut test affectation Haut
beq $t1 1 condDroite					#Saut test affectation Droite
beq $t1 2 condBas					#Saut test affectation Bas
beq $t1 3 condGauche					#Saut test affectation Gauche

condHaut:						#cond Haut :
beq $a0 2 skipDir					#si l'entr�e == Bas : saut fin fonction
sw $a0 snakeDir						#affectation snakeDir
j skipDir
condDroite:
beq $a0 3 skipDir					#si l'entr�e == Gauche : saut fin fonction
sw $a0 snakeDir						#affectation snakeDir
j skipDir
condBas:
beq $a0 0 skipDir					#si l'entr�e == Haut : saut fin fonction
sw $a0 snakeDir						#affectation snakeDir
j skipDir
condGauche:
beq $a0 1 skipDir					#si l'entr�e == Droite : saut fin fonction
sw $a0 snakeDir						#affectation snakeDir
j skipDir

skipDir:
lw $ra ($sp)
addu $sp $sp 4
jr $ra							#fin fonction
# En haut, ... en bas, ... à gauche, ... à droite, ... ces soirées là ...
############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:

#jal hiddenCheatFunctionDoingEverythingTheProjectDemandsWithoutHavingToWorkOnIt
subu $sp $sp 4					#range la valeur $ra
sw $ra ($sp)

jal updateSnake					#Fonction permetant d'actualiser le corp Entr�e : SnakeDir
lw $t0 snakePosX				#charge dans $t0 la valeur de snakePosX
lw $t1 snakePosY				#charge dans $t1 la valeur de snakePosY
lw $t2 candy					#charge dans $t2 la valeur de candy
lw $t3 candy + 4				#charge dans $t3 la valeur de candy Y
beq $t0 $t2 cond3				#test si la t�te est a la m�me position qu'au bonbon
skipGameStatus:
lw $ra ($sp)					
addu $sp $sp 4
jr $ra						#fin fonction
cond3:
beq $t1 $t3 cond4				#test si la t�te est a la m�me position qu'au bonbon (position Y)
j skipGameStatus
cond4:						#la t�te mange le bonbon
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy +4					#charge de nouvelles valeurs pour candy
lw $t4 tailleSnake				#charge la taille
li $t1 4
mul $t5 $t4 $t1
lw $t6 lastSnakePiece				#charge dans la queue la position lastSnakePiece
sw $t6 snakePosX($t5)
lw $t6 lastSnakePiece +4
sw $t6 snakePosY($t5)
addi $t4 $t4 1			
sw $t4 tailleSnake				#incremente la taille du serpent
lw $t4 scoreJeu					#augemente le score
add $t4 $t4 $s3
sw $t4 scoreJeu

j skipGameStatus

############################### updateCorp ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: La fonction s'occupe de charger les nouvelles valeurs du serpent
# de la fa�on suivante : SnakePosX[i]=snakePosX[i-1] i>0
################################################################################

updateCorp:
subu $sp $sp 4					#range la valeur $ra
sw $ra ($sp)

lw $t6 tailleSnake				
subi $t6 $t6 1
li $t0 4
la $t1 snakePosX
la $t2 snakePosY

loop3:beqz $t6 skip3				#boucle , s'occupe de charger les valeurs T[X]=T[X-1]
mul $t7 $t6 $t0					#$t7 = taille*4
add $t8 $t7 $t1					#adresse + taille*4
lw $t9 -4($t8)					#charge dans $t9 T[i-1]
sw $t9 0($t8)					#charge dans l'adresse T[i-1]
add $t8 $t7 $t2					
lw $t9 -4($t8)					#charge dans $t9 T[i-1]
sw $t9 0($t8)					#charge dans l'adresse T[i-1]
subi $t6 $t6 1					#decrementation
j loop3
skip3:
lw $ra 0($sp)
addu $sp $sp 4
jr $ra						#fin fonction

updateSnake:
subu $sp $sp 4					#range la valeur $ra
sw $ra ($sp)		
lw $t4 snakePosX				#charge dans $t4 la valeur snakePosX
lw $t5 snakePosY				#charge dans $t5 la valeur snakePosY
jal updateCorp					#saut pour actualiser les valeurs du corp 
lw $a0 snakeDir
beq $a0 0 Haut					#sauts conditionnels , change la position de la t�te
beq $a0 1 Droite
beq $a0 2 Bas
beq $a0 3 Gauche
j End

Haut:						#affecte a snakePosX ou Y les nouvelles coordon�es 

addi $t4 $t4 -1
sw $t4 snakePosX				#snakePosX--
j End

Droite:
addi $t5 $t5 1
sw $t5 snakePosY				#snakePosY++
j End

Bas:

addi $t4 $t4 1
sw $t4 snakePosX				#snakePosX++
j End

Gauche:

addi $t5 $t5 -1
sw $t5 snakePosY				#snakePosY--

End:

lw $ra ($sp)
addu $sp $sp 4
jr $ra							#fin fonction
############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:

subu $sp $sp 4						#range la valeur $ra
sw $ra ($sp)
li $v0 0						#charge dans $v0 0 pour ne pas finir le jeu	
li $t0 16						#charge dans $t0 la valeur 16 pour tester les conditions de bords 
lw $t1 snakePosY
beq $t1 $t0 jEndCond					#test si snakePosY a attein le bord
li $t0 -1						#charge dans $t0 la valeur -1 pour tester les conditions de bords 
beq $t1 $t0 jEndCond 					#test si snakePosY a attein le bord
lw $t2 snakePosX
beq $t2 $t0 jEndCond					#test si snakePosX a attein le bord
li $t0 16						#charge dans $t0 la valeur 16 pour tester les conditions de bords 
beq $t2 $t0 jEndCond					#test si snakePosX a attein le bord
jal condObstacles					#saut test obstacle
jal condCorp						#saut test snake mange son propre corp
jProcCond:
lw $ra ($sp)
addu $sp $sp 4
jr $ra							#fin fonction

jEndCond:li $v0 1					#charge dans $v0 1 pour faire une fin de partie
j jProcCond

condObstacles: 
lw $t0 numObstacles					#chargement nombre d'obstacles
subu $t0 $t0 1						#numObstaclsee -1
li $t3 4
loopObst:beq $t0 -1 endNumObst				#Condition d'arr�t $t0==-1
mul $t4 $t0 $t3						#numObstacles * 4 
lw $t5 obstaclesPosX($t4)				#acces a l'obstacles numobstacles
lw $t4 obstaclesPosY($t4)				#acces a l'obstacles numobstacles
beq $t5 $t2 secondCondObst				#test premi�re condition
subu $t0 $t0 1						#decrementation du compteur
j loopObst
secondCondObst:beq $t4 $t1 finCondObst			#seconde condition d'arr�t
subu $t0 $t0 1						#decrementation du compteur
j loopObst
endNumObst:						#fin de fonction
jr $ra
finCondObst:						#charge dans $v0 1 pour faire une fin de partie
li $v0 1
j endNumObst

condCorp:						#fonction s'occupant de verifier si la t�te a la m�me position qu'un element du corp
subu $sp $sp 4						#range le registre $ra
sw $ra ($sp)
lw $t3 tailleSnake					#charge la taille du serpent
subu $t3 $t3 1						#tailleSnake - 1
li $t5 4
loopCond:blt $t3 $t5 condContinue			#condition de sortie : taille du snake <4
mul $t6 $t5 $t3						#$t6 = 4 * taillesnake
lw $t7 snakePosX($t6)					#charger la posX de l'element I
beq $t2 $t7 condArret					#premi�re comparaison avec posX et posX de l'element I
jSuite:
subu $t3 $t3 1						#d�crementation
j loopCond
condContinue:
lw $ra ($sp)
addu $sp $sp 4
jr $ra							#fin fonction

condArret:						#deuxi�me comparaison avec posY et posY de l'element I
lw $t7 snakePosY($t6)
beq $t1 $t7 Arret
j jSuite
Arret:


li $v0 1
j condContinue
############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:					#fonction d'affichage du score :
subu $sp $sp 4						#ranger $ra
sw $ra ($sp)
jal resetAffichage					#vide l'�cran
lw $a0 colors + yellow					#choix de la couleur du score 
li $a1 0						#la fonction affiche score pixel par pixel en utilisant les position a1 et a2
li $a2 0
jal printColorAtPosition
li $a2 1
jal printColorAtPosition
li $a2 3
jal printColorAtPosition
li $a2 4
jal printColorAtPosition
li $a2 6
jal printColorAtPosition
li $a2 7
jal printColorAtPosition
li $a2 8
jal printColorAtPosition
li $a2 10
jal printColorAtPosition
li $a2 11
jal printColorAtPosition
li $a2 12
jal printColorAtPosition
li $a2 14
jal printColorAtPosition
li $a2 15
jal printColorAtPosition
li $a1 1
li $a2 0
jal printColorAtPosition
li $a2 3
jal printColorAtPosition
li $a2 6
jal printColorAtPosition
li $a2 8
jal printColorAtPosition
li $a2 10
jal printColorAtPosition
li $a2 12
jal printColorAtPosition
li $a2 14
jal printColorAtPosition
li $a1 2
li $a2 0
jal printColorAtPosition
li $a2 1
jal printColorAtPosition
li $a2 3
jal printColorAtPosition
li $a2 6
jal printColorAtPosition
li $a2 8
jal printColorAtPosition
li $a2 10
jal printColorAtPosition
li $a2 11
jal printColorAtPosition
li $a2 12
jal printColorAtPosition
li $a2 14
jal printColorAtPosition
li $a2 15
jal printColorAtPosition
li $a1 3
li $a2 1
jal printColorAtPosition
li $a2 3
jal printColorAtPosition
li $a2 6
jal printColorAtPosition
li $a2 8
jal printColorAtPosition
li $a2 10
jal printColorAtPosition
li $a2 11
jal printColorAtPosition
li $a2 14
jal printColorAtPosition
li $a1 4
li $a2 0
jal printColorAtPosition
li $a2 1
jal printColorAtPosition
li $a2 3
jal printColorAtPosition
li $a2 4
jal printColorAtPosition
li $a2 6
jal printColorAtPosition
li $a2 7
jal printColorAtPosition
li $a2 8
jal printColorAtPosition
li $a2 10
jal printColorAtPosition
li $a2 12
jal printColorAtPosition
li $a2 14
jal printColorAtPosition
li $a2 15
jal printColorAtPosition		#__________________________________________________________________________________________________________________________ fin de l'affichage score
li $t2 0
li $a1 8			
lw $t1 scoreJeu				#charger la valeur du score
lw $a0 colors+green			#choix de la coueur du score 
back:div $t1 $t1 10				
bgtz $t1 increment
beq $t2 0 choix0
beq $t2 1 choix1
beq $t2 2 choix2
beq $t2 3 choix3

choix0:
li $a2 7
lw $a3 scoreJeu
jal printNum
j suite
choix1:
lw $a3 scoreJeu
li $a2 5
li $t3 10
div $a3 $t3 
mflo $a3
mfhi $t9
jal printNum
move $a3 $t9
li $a2 9
li $a1 8
jal printNum
j suite
choix2:
lw $a3 scoreJeu
li $a2 3
li $t3 100
div $a3 $t3 
mflo $a3
mfhi $t9 
jal printNum
move $a3 $t9
li $t3 10
div $a3 $t3
mflo $a3
mfhi $t9 
li $a2 7
li $a1 8
jal printNum
move $a3 $t9
li $a2 11
li $a1 8
jal printNum
j suite
choix3:
lw $a3 scoreJeu
li $a2 0
li $t3 1000
div $a3 $t3 
mflo $a3
mfhi $t9 
jal printNum
move $a3 $t9
li $t3 100
div $a3 $t3
mflo $a3
mfhi $t9
li $a2 4
li $a1 8
jal printNum
move $a3 $t9
li $t3 10
div $a3 $t3
mflo $a3
mfhi $t9
li $a2 8
li $a1 8
jal printNum
move $a3 $t9
li $a2 12
li $a1 8
jal printNum
# Fin.
suite:
lw $ra ($sp)
addu $sp $sp 4
jr $ra
increment:
addi $t2 $t2 1
j back



print0:
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 2
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 2
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 2
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
j back1
print1:

addi $a2 $a2 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
j back1
print2:
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
j back1
print3:
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
j back1
print4:
jal printColorAtPosition
addi $a2 $a2 2
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 2
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
j back1

print5:
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
j back1
print6:
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 2
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
j back1
print7:
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
j back1
print8:
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 2
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 2
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
j back1
print9:
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 2
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
subu $a2 $a2 2
addi $a1 $a1 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
j back1
printSel:
addi $a1 $a1 5
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
j back1
printNum:
subu $sp $sp 4
sw $ra ($sp)
beq $a3 0 print0
beq $a3 1 print1
beq $a3 2 print2
beq $a3 3 print3
beq $a3 4 print4
beq $a3 5 print5
beq $a3 6 print6
beq $a3 7 print7
beq $a3 8 print8
beq $a3 9 print9
beq $a3 -1 printSel
back1:
lw $ra ($sp)
addu $sp $sp 4
jr $ra

printLevel1:

subu $sp $sp 4
sw $ra ($sp)
li $a1 0
li $a2 0
lw $a0 colors+red
li $a3 -1
jal printNum
jal printLevelGen
lw $ra ($sp)
addu $sp $sp 4
jr $ra

printLevel2:

subu $sp $sp 4
sw $ra ($sp)
li $a1 0
li $a2 4
lw $a0 colors+red
li $a3 -1
jal printNum
jal printLevelGen
lw $ra ($sp)
addu $sp $sp 4
jr $ra

printLevel3:

subu $sp $sp 4
sw $ra ($sp)
li $a1 0
li $a2 8
lw $a0 colors+red
li $a3 -1
jal printNum
jal printLevelGen
lw $ra ($sp)
addu $sp $sp 4
jr $ra

printLevel4:

subu $sp $sp 4
sw $ra ($sp)
li $a1 0
li $a2 12
lw $a0 colors+red
li $a3 -1
jal printNum
jal printLevelGen
lw $ra ($sp)
addu $sp $sp 4
jr $ra

printLevel5:

subu $sp $sp 4
sw $ra ($sp)
li $a1 6
li $a2 0
lw $a0 colors+red
li $a3 -1
jal printNum
jal printLevelGen
lw $ra ($sp)
addu $sp $sp 4
jr $ra

printLevel6:

subu $sp $sp 4
sw $ra ($sp)
li $a1 6
li $a2 4
lw $a0 colors+red
li $a3 -1
jal printNum
jal printLevelGen
lw $ra ($sp)
addu $sp $sp 4
jr $ra

printLevel7:

subu $sp $sp 4
sw $ra ($sp)
li $a1 6
li $a2 8
lw $a0 colors+red
li $a3 -1
jal printNum
jal printLevelGen
lw $ra ($sp)
addu $sp $sp 4
jr $ra

printLevel8:

subu $sp $sp 4
sw $ra ($sp)
li $a1 6
li $a2 12
lw $a0 colors+red
li $a3 -1
jal printNum
jal printLevelGen
lw $ra ($sp)
addu $sp $sp 4
jr $ra

printLevelQ:

subu $sp $sp 4
sw $ra ($sp)
li $a1 10
li $a2 6
lw $a0 colors+red
li $a3 -1
jal printNum
jal printLevelGen
lw $ra ($sp)
addu $sp $sp 4
jr $ra


printLevelGen:
subu $sp $sp 4
sw $ra ($sp)
lw $a0 colors+green
li $a1 0
li $a2 0
li $a3 1
jal printNum
li $a1 0
li $a2 4
li $a3 2
jal printNum
li $a1 0
li $a2 8
li $a3 3
jal printNum
li $a1 0
li $a2 12
li $a3 4
jal printNum
li $a1 6
li $a2 0
li $a3 5
jal printNum
li $a1 6
li $a2 4
li $a3 6
jal printNum
li $a1 6
li $a2 8
li $a3 7
jal printNum
li $a1 6
li $a2 12
li $a3 8
jal printNum
li $a1 12
li $a2 6
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a2 $a2 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
addi $a1 $a1 1
jal printColorAtPosition
subi $a2 $a2 1
jal printColorAtPosition
subi $a2 $a2 1
jal printColorAtPosition
subi $a1 $a1 1
jal printColorAtPosition
li $a1 15
li $a2 9
jal printColorAtPosition
lw $ra ($sp)
addu $sp $sp 4
jr $ra
