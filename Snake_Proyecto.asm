.data
	imagen		.space 0x80000		#512 wide x 256 high pixeles
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
