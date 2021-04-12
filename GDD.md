# Documento de diseño de videojuego: Guerra de abrazos



## Objetivos del Juego

+ Descripción: 2D Top-Down party game en el que los jugadores compiten por dar más abrazos empujando y moviendose.
+ ¿Para quíen?: El juego está dirigido a todos los públicos que quieran jugar con dos o más amigos en el mismo dispositivo. Especialmente hecho para jugar casualmente en fiestas con personas de todas las edades.
What—Provide a game summary. What is this game about? Include a concise description of the gameplay.
How—Explain how this game will be awesome. Mention “back of the box” items like new/novel mechanics or gameplay features.
Explain what platform this game is for. Will it feature multiplayer capability? Does it have any technical requirements?
Provide short descriptions of gameplay types (stealth, battle arena, driving, flying, and so on) in the game.

## Resumen de la historia

Guerra de abrazos (JH)

Story overview—Remember to keep this description short and frame it in the context of the gameplay. Include the setup (how does the player start the game?). List all locations and how they relate to the narrative (how does the player get from one location to the next?). Don’t forget the finale (What is the ending? What is the player expected to be/have done by the end of the game?).
How are you communicating the story? Movies? Cutscenes? In-game?

## Controles del juego
Controles básicos de movimiento: WASD y flechas en ordenador para dos jugadores. 
Controles de habilidad: DASH -> espacio/intro
Proyectil -> Shift/Mayus

Controles de mando -> Movimiento joystics solo movimiento.
Dash -> L1/X
Proyectil -> R1/Cuadrao

## Requerimientos de técnicas
Game controls—Provide an overview of the controls. List specific moves the player will be doing, but don’t go into detail on the actual moves … yet.
Show an image of a controller, touchscreen, or keyboard with corresponding control mapping.

## Pantalla de inicio
Título guapo guerra de abrazos.  
Menú con Multijugador local, multijugador online. 

## Flujo de menús
Multijugador local y online -> 
    Aparecen directamente en el mapa mientras se van uniendo el resto. 
    Todavía no han empezado y se pueden acercar a un cajero para cambiar opciones del juego
    En el cajero se puede modificar el tiempo de una partida. 

## Cámaras del juego

Camara fija de todo el nivel.

## HUD
En el HUD aparece la puntuación que lleva cada jugador y el tiempo hasta que termine la ronda o hasta cuantos abrazos hay que llegar para ganar.

## Personajes del juego
Personajes jugables
Los personajes jugables tienen como objetivo dar abrazos para ganar el juego.

Personajes no jugables son los recursos que tienen que ser abrazados dentro de estos tenemos los siguientes tipos:
- Persona normal: Solo se le puede abrazar una vez ganando un punto. Una vez que ha sido abrazado abandona el mapa a mayor velocidad
- Persona especialmente triste: Se le puede abrazar de forma continuada hasta que abandona el mapa. El mantenerse cerca de él hace que se le pueda dar abrazos aunque tenga un cooldown.
- Persona especialmente inabrazable: No se le puede abrazar y al tocarle baja puntos. 

## Flujo del juego
Una vez se inicia el juego empiezan a aparecer por el mapa personas que se van moviendo, estos son los recursos a conseguir por los jugadores que deben de situarse cerca suya para conseguir "abrazarlos". Dependiendo de los atributos visuales de estas personas se sabe que dan más o menos puntos o que dan puntos de forma continuada. El jugador que se sitúe cerca de él le da un abrazo y gana un punto. Para los que pueden ser abrazos de forma continuada hay un cooldown que esperar a su alrededor para que vuelva a haber un abrazo. 

## Habilidades de los personajes
+ Proyectil que al colisionar empuja a su alrededor
+ Abrazar. Al colisionar con otra persona ambas entran en un estado de abrazo, continuando ambos a la misma velocidad durante la duración del abrazo, siendo esta la suma de sus velocidades anteriores individuales. Al finalizar el abrazo los participantes son empujados para separarlos. 
+ Dash. Rápido movimiento para cambiar de dirección o sitio, si dasheas en un abrazo de otros jugadores lo cortas.
Story overview—Remember to keep this description short and frame it in the context of the gameplay. Include the setup (how does the player start the game?). List all locations and how they relate to the narrative (how does the player get from one location to the next?). Don’t forget the finale (What is the ending? What is the player expected to be/have done by the end of the game?).

## Puntuación
La puntuación equivale al número de abrazos que ha dado el jugador.

## Fin de partida 

Se muestra una tabla de reusltados mostrando primero al que haya ganado. 

## Recompensas

## Progresión en el juego

## Niveles 

## Música
