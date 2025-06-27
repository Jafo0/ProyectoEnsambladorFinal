.data
	imagen:		.space 0x80000		#512 ancho x 256 alto pixeles
	xVel:		.word	0		# x velocidad inicio 0
	yVel:		.word	0		# y velocidad inicio 0
	xPos:		.word	50		# x posicion
	yPos:		.word	27		# y posicion cabeza de la serpiente inicial
	tail:		.word	7624		# índice donde está la cola
	ManzanX:	.word	32		# Coordenadas de la manzana que la serpiente debe comer
	ManzanY:	.word	16		# Coordenadas de la manzana que la serpiente debe comer
	snakeArriba:	.word	0x0000ff00	# pixel verde para cuando se mueve a arriba
	snakeAbajo:	.word	0x0100ff00	# pixel verde para cuando se mueve a abajo
	snakeIzquierda:	.word	0x0200ff00	# pixel verde para cuando se mueve a izquierda
	snakeDerecha:	.word	0x0300ff00	# pixel verde para cuando se mueve a derecha 
	xConversion:	.word	64		# x valor de convertir xPos a bitmap display
	yConversion:	.word	4		# y valor de convertir (x, y) a bitmap display
	
.text
###Bitmap  8, 8, 512, 256
main:

#Dibujar el fondo
	la 	$t0, imagen	# cargar dirección del buffer de video
	li 	$t1, 8192		# guarda 512*256 pixeles es el contador
	li 	$t2, 0x4169E1FF		# color gris de fondo
l1:
	sw   	$t2, 0($t0)
	addi 	$t0, $t0, 4 	# avanza a la proxima posicion del pixel en display
	addi 	$t1, $t1, -1	# decrecer numero de pixel
	bnez 	$t1, l1		# repetir hasta que no sea igual a zero
	
#DIBUJAR BORDE
	
	# seccion arriba del borde
	la	$t0, imagen		# cargar dirección del buffer de video
	addi	$t1, $zero, 64		# t1 = 64 largo de la fila
	li 	$t2, 0x00000000		# cargar color negro
drawBorderTop:
	sw	$t2, 0($t0)		# color Pixel black
	addi	$t0, $t0, 4		# ir al siguiente píxel
	addi	$t1, $t1, -1		# disminuir contador de píxeles
	bnez	$t1, drawBorderTop	# repetir hasta que contador sea cero
	
	# Sección inferior del borde
	la	$t0, imagen		# cargar dirección del buffer de video
	addi	$t0, $t0, 7936		# inicia el pixel en la zona inferior izquierda
	addi	$t1, $zero, 64		# t1 = 512 length of row

drawBorderBot:
	sw	$t2, 0($t0)		# color Pixel black
	addi	$t0, $t0, 4		# ir al siguiente píxel
	addi	$t1, $t1, -1		# disminuir contador de píxeles
	bnez	$t1, drawBorderBot	# repetir hasta que contador sea cero
	
	# sección izquierda del borde
	la	$t0, imagen		# cargar dirección del buffer de video
	addi	$t1, $zero, 256		# t1 = 512 length of col

drawBorderLeft:
	sw	$t2, 0($t0)		# color Pixel black
	addi	$t0, $t0, 256		# ir al siguiente píxel
	addi	$t1, $t1, -1		# disminuir contador de píxeles
	bnez	$t1, drawBorderLeft	# repetir hasta que contador sea cero
	
	# Sección derecha del borde
	la	$t0, imagen		# cargar dirección del buffer de video
	addi	$t0, $t0, 508		# Hace que el pixel comience en parte superior derecha
	addi	$t1, $zero, 255		# t1 = 512 length of col

drawBorderRight:
	sw	$t2, 0($t0)		# color Pixel black
	addi	$t0, $t0, 256		# ir al siguiente píxel
	addi	$t1, $t1, -1		# disminuir contador de píxeles
	bnez	$t1, drawBorderRight	# repetir hasta que contador sea cero
	
	la	$t0, imagen		# cargar dirección del buffer de video
	lw	$s2, tail		# s2 = cola de snake
	lw	$s3, snakeArriba	# s3 = direccion snake
	
	add	$t1, $s2, $t0		# t1 = cola empieza en bit map display
	sw	$s3, 0($t1)		# dibujar píxel donde está la serpiente
	addi	$t1, $t1, -256		# fijar t1 al pixel arriba
	sw	$s3, 0($t1)		# dibujar píxel actual de la serpiente
	
	# dibujar manzana inicial
	jal 	drawApple
	
# Esta es la función de actualización del juego
gameUpdateLoop:
	lw	$t3, 0xffff0004		# leer tecla presionada del teclado

	#Pausar por 66 ms para que la tasa de cuadros sea ~15
	
	addi	$v0, $zero, 32		# pausa del sistema
	addi	$a0, $zero, 66		# 66 ms
	syscall
	
	beq	$t3, 100, moveRight	# si tecla presionada = 'd', ir a moveRight
	beq	$t3, 97, moveLeft	# si tecla presionada = 'a', ir a moveLeft
	beq	$t3, 119, moveUp	# si tecla presionada = 'w', ir a moveUp
	beq	$t3, 115, moveDown	# si tecla presionada = 's', ir a moveDown
	beq	$t3, 0, moveUp		# iniciar el juego moviéndose hacia arriba

moveUp:
	lw	$s3, snakeArriba	# s3 = direccion snake
	add	$a0, $s3, $zero		# a0 = direccion de la snake
	jal	updateSnake
	
	# mover a la snake
	jal 	updateSnakeHeadPosition
	
	j	exitMoving 	

moveDown:
	lw	$s3, snakeAbajo	# s3 = direccion de la snake
	add	$a0, $s3, $zero	# a0 = direccion de la snake
	jal	updateSnake
	
	# mover a la snake
	jal 	updateSnakeHeadPosition
	
	j	exitMoving
	
moveLeft:
	lw	$s3, snakeIzquierda	# s3 = direccion de la snake
	add	$a0, $s3, $zero		# a0 = direccion de la snake
	jal	updateSnake
	
	# mover a la snake
	jal 	updateSnakeHeadPosition
	
	j	exitMoving
	
moveRight:
	lw	$s3, snakeDerecha	# s3 = direccion de la snake
	add	$a0, $s3, $zero		# a0 = direccion de la snake
	jal	updateSnake
	
	# mover a la snake
	jal 	updateSnakeHeadPosition

	j	exitMoving

exitMoving:
	j 	gameUpdateLoop		# se devuelve al inicio del loop
	
updateSnake:
	addiu 	$sp, $sp, -24	# reservar 24 bytes en la pila
	sw 	$fp, 0($sp)	# guardar puntero de marco del llamador
	sw 	$ra, 4($sp)	# guardar dirección de retorno del llamador
	addiu 	$fp, $sp, 20	# setup updateSnake frame pointer
	
	### DIBUJAR CABEZA
	lw	$t0, xPos		# t0 = xPos of snake
	lw	$t1, yPos		# t1 = yPos of snake
	lw	$t2, xConversion	# t2 = 64
	mult	$t1, $t2		# yPos * 64
	mflo	$t3			# t3 = yPos * 64
	add	$t3, $t3, $t0		# t3 = yPos * 64 + xPos
	lw	$t2, yConversion	# t2 = 4
	mult	$t3, $t2		# (yPos * 64 + xPos) * 4
	mflo	$t0			# t0 = (yPos * 64 + xPos) * 4
	
	la 	$t1, imagen		# cargar dirección del buffer de video
	add	$t0, $t1, $t0		# t0 = (yPos * 64 + xPos) * 4 + frame address
	lw	$t4, 0($t0)		# save original val of pixel in t4
	sw	$a0, 0($t0)		# store direction plus color on the bitmap display
	
	
	### VELOCIDAD
	lw	$t2, snakeArriba		# load word snake arriba = 0x0000ff00
	beq	$a0, $t2, setVelocityUp		# si la direccion de la cabeza y color == snake arriba branch a setVelocityUp
	
	lw	$t2, snakeAbajo			# load word snake arriba = 0x0100ff00
	beq	$a0, $t2, setVelocityDown	# si la direccion de la cabeza y color== snake abajo branch a setVelocitydown
	
	lw	$t2, snakeIzquierda		# load word snake arriba = 0x0200ff00
	beq	$a0, $t2, setVelocityLeft	# si la direccion de la cabeza y color ==snake izq branch a setVelocityUp
	
	lw	$t2, snakeDerecha		# load word snake arriba = 0x0300ff00
	beq	$a0, $t2, setVelocityRight	# si la direccion de la cabeza y color == snake derecha branch a setVelocityUp
	
setVelocityUp:
	addi	$t5, $zero, 0		# set x velocidad a zero
	addi	$t6, $zero, -1	 	# set y velocidad a -1
	sw	$t5, xVel		# actualizar velocidad en x
	sw	$t6, yVel		# actualizar velocidad en y
	j exitVelocitySet
	
setVelocityDown:
	addi	$t5, $zero, 0		# set x velocidad a zero
	addi	$t6, $zero, 1 		# set y velocidad a 1
	sw	$t5, xVel		# actualizar velocidad en x
	sw	$t6, yVel		# actualizar velocidad en y
	j exitVelocitySet
	
setVelocityLeft:
	addi	$t5, $zero, -1		# set x velocidad a -1
	addi	$t6, $zero, 0 		# set y velocidad a zero
	sw	$t5, xVel		# actualizar velocidad en x
	sw	$t6, yVel		# actualizar velocidad en y
	j exitVelocitySet
	
setVelocityRight:
	addi	$t5, $zero, 1		# set x velocidad a 1
	addi	$t6, $zero, 0 		# set y velocidad ao zero
	sw	$t5, xVel		# actualizar velocidad en x
	sw	$t6, yVel		# actualizar velocidad en y
	j exitVelocitySet
	
exitVelocitySet:
	
	### LOCALIDAD DE CABEZA
	li 	$t2, 0x00ff0000			# color rojo
	bne	$t2, $t4, cabezaNoManzana	# si  la ubicacion de la cabeza no es la manzna  salir
	
	jal 	newAppleLocation
	jal	drawApple
	j	exitUpdateSnake
	
cabezaNoManzana:

	li	$t2, 0x4169E1FF			# color de fondo
	beq	$t2, $t4, validHeadSquare	# si  la ubicacion de la cabeza  es fondo salirse
	
	addi 	$v0, $zero, 10			# salir del programa
	syscall
	
validHeadSquare:

	### QUITA COLA
	lw	$t0, tail		# t0 = cola
	la 	$t1, imagen		# cargar dirección del buffer de video
	add	$t2, $t0, $t1		# t2 = tail ubicacon en el  bitmap display
	li 	$t3, 0x4169E1FF		#color azul fondo
	lw	$t4, 0($t2)		# t4 = cola direccion y el color 
	sw	$t3, 0($t2)		# reemplazar cola con color de fondo
	
	### NUEVA COLA
	lw	$t5, snakeArriba		# load word snake Arriba = 0x0000ff00
	beq	$t5, $t4, setNextTailUp		# si la direccion de cola y color == snake arriba branch a setNextTailUp
	
	lw	$t5, snakeAbajo			# load word snake arrina = 0x0100ff00
	beq	$t5, $t4, setNextTailDown	# si la direccion de cola y color == snake abajo branch a setNextTailDown
	
	lw	$t5, snakeIzquierda		# load word snake arriba = 0x0200ff00
	beq	$t5, $t4, setNextTailLeft	# si la direccion de cola y el color == snake izq branch a setNextTailLeft
	
	lw	$t5, snakeDerecha		# load word snake arriba = 0x0300ff00
	beq	$t5, $t4, setNextTailRight	# si la direccion de cola y el color == snake derecha branch a setNextTailRight
	
setNextTailUp:
	addi	$t0, $t0, -256		# tail = tail - 256
	sw	$t0, tail		# guardar  tail en memoria
	j exitUpdateSnake
	
setNextTailDown:
	addi	$t0, $t0, 256		# tail = tail + 256
	sw	$t0, tail		# guardar  tail en memoria
	j exitUpdateSnake
	
setNextTailLeft:
	addi	$t0, $t0, -4		# tail = tail - 4
	sw	$t0, tail		# guardar  tail en memoria
	j exitUpdateSnake
	
setNextTailRight:
	addi	$t0, $t0, 4		# tail = tail + 4
	sw	$t0, tail		# guardar  tail en memoria
	j exitUpdateSnake
	
exitUpdateSnake:
	
	lw 	$ra, 4($sp)	# cargar direccion  retorno
	lw 	$fp, 0($sp)	# restaurar puntero de marco del llamador
	addiu 	$sp, $sp, 24	# restaurar puntero de pila del llamador
	jr 	$ra		# retornar al código llamador

updateSnakeHeadPosition:
	addiu 	$sp, $sp, -24	# reservar 24 bytes en la pila
	sw 	$fp, 0($sp)	# guardar puntero de marco del llamador
	sw 	$ra, 4($sp)	# guardar dirección de retorno del llamador
	addiu 	$fp, $sp, 20	# setup updateSnake frame
	
	lw	$t3, xVel	# load xVel desde la memoria
	lw	$t4, yVel	# load yVel desde la memoria
	lw	$t5, xPos	# load xPos desde la memoria
	lw	$t6, yPos	# load yPos desde la memoria
	add	$t5, $t5, $t3	# actualizar x pos
	add	$t6, $t6, $t4	# actualizar y pos
	sw	$t5, xPos	# store xpos actualizada a la memoria
	sw	$t6, yPos	# store ypos actualizada a la memoria
	
	lw 	$ra, 4($sp)	# load caller's return address
	lw 	$fp, 0($sp)	# restaurar puntero de marco del llamador
	addiu 	$sp, $sp, 24	# restaurar puntero de pila del llamador
	jr 	$ra		# retornar al código llamador

drawApple:
	addiu 	$sp, $sp, -24	# reservar 24 bytes en la pila
	sw 	$fp, 0($sp)	# guardar puntero de marco del llamador
	sw 	$ra, 4($sp)	# guardar dirección de retorno del llamador
	addiu 	$fp, $sp, 20	# setup updateSnake frame pointer
	
	lw	$t0, ManzanX		# t0 = posicion x de manzana
	lw	$t1, ManzanY		# t1 = posicion y de manzana
	lw	$t2, xConversion	# t2 = 64
	mult	$t1, $t2		# ManzanY * 64
	mflo	$t3			# t3 = ManzanY * 64
	add	$t3, $t3, $t0		# t3 = ManzanY * 64 + ManzanX
	lw	$t2, yConversion	# t2 = 4
	mult	$t3, $t2		# (manzan y * 64 + manzan x) * 4
	mflo	$t0			# t0 = (ManzanY * 64 + ManzanX) * 4
	
	la 	$t1, imagen		# cargar dirección del buffer de video
	add	$t0, $t1, $t0		# t0 = (ManzanY * 64 + ManzanX) * 4 + frame address
	li	$t4, 0x00ff0000
	sw	$t4, 0($t0)
	
	lw 	$ra, 4($sp)	
	lw 	$fp, 0($sp)		# restaurar puntero de marco del llamador
	addiu 	$sp, $sp, 24		# restaurar puntero de pila del llamador
	jr 	$ra			# retornar al código llamador	
	

newAppleLocation:
	addiu 	$sp, $sp, -24	# reservar 24 bytes en la pila
	sw 	$fp, 0($sp)	# guardar puntero de marco del llamador
	sw 	$ra, 4($sp)	# guardar dirección de retorno del llamador
	addiu 	$fp, $sp, 20	# setup updateSnake frame pointer

redoRandom:		
	addi	$v0, $zero, 42	# random int 
	addi	$a1, $zero, 63	
	syscall
	add	$t1, $zero, $a0	# random ManzanX
	
	addi	$v0, $zero, 42	# random int 
	addi	$a1, $zero, 31	
	syscall
	add	$t2, $zero, $a0	# random ManzanY
	
	lw	$t3, xConversion	# t3 = 64
	mult	$t2, $t3		# random ManzanY * 64
	mflo	$t4			# t4 = random ManzanY * 64
	add	$t4, $t4, $t1		# t4 = random ManzanY * 64 + random ManzanX
	lw	$t3, yConversion	# t3 = 4
	mult	$t3, $t4		# (random ManzanY * 64 + random ManzanX) * 4
	mflo	$t4			# t1 = (random ManzanY * 64 + random ManzanX) * 4
	
	la 	$t0, imagen		# cargar dirección del buffer de video
	add	$t0, $t4, $t0		# t0 = (ManzanY * 64 + ManzanX) * 4 + frame address
	lw	$t5, 0($t0)		# t5 = valr pixel en  t0
	
	li	$t6, 0x4169E1FF		# azul de fondo
	beq	$t5, $t6, ManzanBuena	# si la ubicacion es un espacio adecuado salta  ManzanBuena
	j redoRandom

ManzanBuena:
	sw	$t1, ManzanX
	sw	$t2, ManzanY	

	lw 	$ra, 4($sp)
	lw 	$fp, 0($sp)	# restaurar puntero de marco del llamador
	addiu 	$sp, $sp, 24	# restaurar puntero de pila del llamador
	jr 	$ra		# retornar al código llamador
