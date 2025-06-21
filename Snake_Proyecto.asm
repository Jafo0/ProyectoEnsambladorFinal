.data
	frameBuffer:		.space 0x80000		#512 wide x 256 high pixeles
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

main:

#Dibujar el fondo
	la 	$t0, frameBuffer	# cargar dirección del buffer de video
	li 	$t1, 8192		# guarda 512*256 pixeles es el contador
	li 	$t2, 0x4169E1FF		# color gris de fondo
l1:
	sw   	$t2, 0($t0)
	addi 	$t0, $t0, 4 	# avanza a la proxima posicion del pixel en display
	addi 	$t1, $t1, -1	# decrecer numero de pixel
	bnez 	$t1, l1		# repetir hasta que no sea igual a zero
	
#DIBUJAR BORDE
	
	# seccion arriba del borde
	la	$t0, frameBuffer	# cargar dirección del buffer de video
	addi	$t1, $zero, 64		# t1 = 64 largo de la fila
	li 	$t2, 0x00000000		# cargar color negro
drawBorderTop:
	sw	$t2, 0($t0)		# color Pixel black
	addi	$t0, $t0, 4		# ir al siguiente píxel
	addi	$t1, $t1, -1		# disminuir contador de píxeles
	bnez	$t1, drawBorderTop	# repetir hasta que contador sea cero
	
	# Sección inferior del borde
	la	$t0, frameBuffer	# cargar dirección del buffer de video
	addi	$t0, $t0, 7936		# inicia el pixel en la zona inferior izquierda
	addi	$t1, $zero, 64		# t1 = 512 length of row

drawBorderBot:
	sw	$t2, 0($t0)		# color Pixel black
	addi	$t0, $t0, 4		# ir al siguiente píxel
	addi	$t1, $t1, -1		# disminuir contador de píxeles
	bnez	$t1, drawBorderBot	# repetir hasta que contador sea cero
	
	# sección izquierda del borde
	la	$t0, frameBuffer	# cargar dirección del buffer de video
	addi	$t1, $zero, 256		# t1 = 512 length of col

drawBorderLeft:
	sw	$t2, 0($t0)		# color Pixel black
	addi	$t0, $t0, 256		# ir al siguiente píxel
	addi	$t1, $t1, -1		# disminuir contador de píxeles
	bnez	$t1, drawBorderLeft	# repetir hasta que contador sea cero
	
	# Sección derecha del borde
	la	$t0, frameBuffer	# cargar dirección del buffer de video
	addi	$t0, $t0, 508		# Hace que el pixel comience en parte superior derecha
	addi	$t1, $zero, 255		# t1 = 512 length of col

drawBorderRight:
	sw	$t2, 0($t0)		# color Pixel black
	addi	$t0, $t0, 256		# ir al siguiente píxel
	addi	$t1, $t1, -1		# disminuir contador de píxeles
	bnez	$t1, drawBorderRight	# repetir hasta que contador sea cero
