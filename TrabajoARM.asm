.data
saludo: .asciz "Bienvenido, ingrese el mensaje que desea encriptar, su clave numerica (Entre 0 y 9) y su opcion (c/d) para codificar o decodificar su mensaje:\n"
input: .asciz "                                                                    \n"
/*mensajefalso: .asciz "buenas tardes todos;5;c                                                \r\n"*/						/*Mensaje de prueba*/
mensaje: .asciz "                                                  "	/*donde se va a extraer el mensaje*/
clave: .asciz   "         \n"								/*donde se va a extraer la clave*/
opcion: .asciz  "   \n"								/*donde se va a extraer la opcion*/
entero: .int 0										/*donde se va a guardar la clave como entero*/
pista: .int 0										/*donde se va a guardar la cantidad de caracteres de la pista para decodificar*/
errorOpcion: .asciz "Su opcion elegida no es valida\n"	/*mensaje si la opcion no es ni una c ni una d*/
letras_procesadas: .int 0
letras_procesadastxt: .asciz "Cantidad de letras procesadas:   \n"
bitParidad: .asciz " \n"								/*Luego de codificar guarda un 1 o un 0 en caracter dependiendo de la paridad*/
paridadIngresada: .int 0			/*donde guardamos la paridad ingresada si hay que decodificar en tipo int*/
paridad_ingresadatxt: .asciz "   "	/*donde guardamos la paridad ingresada si hay que decodificar en tipo asciz*/
mensajeError: .asciz "Error!, La paridad de su mensaje no coincide" /*Mensaje de error*/
texto_ingresado: .asciz "Usted ingreso:" /**/
texto_clave: .asciz "Su clave es:"
texto_opcion: .asciz "Su opcion es:"
texto_mensaje: .asciz "Su mensaje es:"
texto_mensaje_proc: .asciz "Su mensaje procesado es:"
salto_linea: .asciz " \n"
.text
saludar:							/*Mensaje de bienvenida para el usuario*/
		mov r0,#1
		ldr r1, =saludo
		mov r2,#144
		mov r7, #4
		swi #0
		bx lr
		
leer_input:							/*Lee por teclado el input que ingresa el usuario*/
	push {lr}
		mov r7, #3
		mov r0, #0
		mov r2, #75
		ldr r1, =input
		swi #0
	pop {lr}
		bx lr
		
mostrar_texto_ingresado:
		push {lr}
		mov r0, #1
		ldr r1, =texto_ingresado
		mov r2, #14
		mov r7, #4
		swi #0
	pop {lr}
		bx lr
		
mostrar_input:						/*Muestra el input ingresado por el usuario*/
	push {lr}
		mov r0, #1
		ldr r1, =input
		/*ldr r1, =mensajefalso*/
		mov r2, #70
		mov r7, #4
		swi #0
	pop {lr}
		bx lr
		
limpiar_registros:
		mov r0,#0				/*Va a guardar la direccion de la variable input*/
		mov r1,#0				/*Va a guardar el input de la direccion R0*/
		mov r2,#0				/*R2 se utiliza para guardar la posicion durante el recorrrido de los ciclos para extraer*/
		mov r3,#0				/*R3 se utiliza para guarda la posicion a almacenar durante el recorrrido del ciclo extraer_clave*/
		mov r4,#0				
		mov r5,#0				/*va a guardar la direccion de la variable mensaje*/
		mov r6,#0
		mov r8,#0				/*va a guardar la direccion de la variable clave*/
		mov r9,#0				/*va a guardar la direccion de la variable opcion*/
		mov r10,#0				/*R10 se utiliza para guarda la posicion a guardar durante el recorrrido del ciclo extraer_opcion*/
		mov r11,#0
		mov r12,#0
		bx lr
		
		
/*---------------------------------------------SECCION DE EXTRACCIONES DEL INPUT------------------------------------------------------------------------------*/		
extraer_mensaje:				/*Guarda el mensaje del usuario en la variable Mensaje*/
		LDRB r4, [r0,r2]		/*Carga en r4 el bit de la direccion r0 de la posicion r2*/
		cmp r4, #0x3b			/*Compara el contenido de R4 con 3B que es el ";" en asccii*/
		beq vuelta				/*Si es igual vuelve al main*/
		STRB r4, [r5,r2]		/*Guarda el contenido de r4 en la direccion contenida en R5 que es la var mensaje, en la posicion R2*/
		add r2, #1				/*Suma 1 al contador que es R2*/
		bl extraer_mensaje		/*Vuelve a empezar el ciclo con el siguiente caracter*/
		
extraer_clave:					/*Guarda la clave del usuario en la variable Clave*/
		add r2, #1				/*Suma 1 a R2 para ir a la posicion siguiente a la ultima utilizada en extraer_mensaje que era el ';'*/
		ldrb r4, [r0,r2]		/*Carga en r4 el bit de la direccion r0 de la posicion r2*/
		cmp r4, #0x3b			/*Compara el contenido de R4 con 3B que es el ";" en asccii*/
		addne r10 ,#1			/*guarda en r10 cuantas letras tiene la clave*/
		cmp r4, #0x3b			/*Compara el contenido de R4 con 3B que es el ";" en asccii*/
		beq vuelta1				/*Si es igual vuelve al main*/
		STRB r4, [r8,r3]		/*Guarda el contenido de r4 en la direccion contenida en R8 que es la var clave, en la posicion R3*/
		add r3,#1				/*Suma 1 al la posicion que es R3*/
		bl extraer_clave		/*Vuelve a empezar el ciclo con el siguiente caracter*/

extraer_opcion:					/*Guarda la opcion del usuario en la variable Opcion*/
		add r2, #1				/*Suma 1 a R2 para ir a la posicion siguiente a la ultima utilizada en extraer_clave que era el ';'*/
		ldrb r4, [r0,r2]		/*Carga en r4 el bit de la direccion r0 de la posicion r2*/
		STRB r4, [r9,r6]		/*Guarda el contenido de r4 en la direccion contenida en R9 que es la var opcion, en la posicion R6 que es 0*/
		bx lr					/*Vuelve al main*/
		
extraer_paridad:				/*Guarda si es que el usuario lo ingreso, el bit de paridad*/
		add r2,#2				/*Suma 2 a R2 para saltear dos posicones, una es un ';' y en la que queda es el bit de paridad*/
		ldrb r4, [r0,r2]		/*Carga en r4 el bit de la direccion r0 de la posicion r2*/
		strb r4,[r11,r6]		/*Guarda el contenido de r4 en la direccion contenida en R11 que es la var paridad_ingresadatxt, en la posicion R6 que sigue siendo 0*/
		bx lr					/*Vuelve al main*/
/*---------------------------------------------FIN SECCION DE EXTRACCIONES DEL INPUT------------------------------------------------------------------------------*/
		
texto_de_mensaje:
		push {lr}
		mov r0, #1
		ldr r1, =texto_mensaje
		mov r2, #14
		mov r7, #4
		swi #0
	pop {lr}
		bx lr

mostrar_mensaje:				/*Muestra solo el mensaje ingresado por el usuario*/
	push {lr}
		mov r0, #1
		ldr r1, =mensaje		/*Muestra el mensaje que se encuentra en la direccion R5, reemplazado luego del ciclo*/
		mov r2, #50
		mov r7, #4
		swi #0
	pop {lr}
		bx lr
		
salto_manual:
		push {lr}
		mov r0, #1
		ldr r1, =salto_linea
		mov r2, #3
		mov r7, #4
		swi #0
	pop {lr}
		bx lr
		
texto_de_clave:
		push {lr}
		mov r0, #1
		ldr r1, =texto_clave
		mov r2, #12
		mov r7, #4
		swi #0
	pop {lr}
		bx lr	
		
mostrar_clave:					/*Muestra solo la clave ingresada por el usuario*/
	push {lr}
		mov r0, #1
		ldr r1, =clave			/*Muestra el mensaje que se encuentra en la direccion R8, reemplazado luego del ciclo*/
		mov r2, #11
		mov r7, #4
		swi #0
	pop {lr}
		bx lr

texto_de_opcion:
		push {lr}
		mov r0, #1
		ldr r1, =texto_opcion
		mov r2, #13
		mov r7, #4
		swi #0
		pop {lr}
		bx lr

mostrar_opcion:					/*Muestra solo la opcion ingresada por el usuario*/
	push {lr}
		mov r0, #1
		ldr r1, =opcion			/*Muestra el mensaje que se encuentra en la direccion R9, reemplazado luego del ciclo*/
		mov r2, #5
		mov r7, #4
		swi #0
	pop {lr}
		bx lr
		
mostrar_texto_de_mensajeproc:
		push {lr}
		mov r0, #1
		ldr r1, =texto_mensaje_proc
		mov r2, #24
		mov r7, #4
		swi #0
		pop {lr}
		bx lr
		
/*--------------------------------------------------------SECCION DE ELECCION DE OPCION-----------------------------------------------------------------------*/
opcion_elegida:
		ldrb r1, [r9,#0]		/*Guarda en R1 el caracter con la opcion elegida por el usuario*/
		cmp r1,#'c'				/*Hace comparaciones para ssaber si hay que codificar o decodificar el mensaje*/
		beq codificarMensaje	/*Se dirige al main a la seccion de codificacion*/
		cmp r1,#'C'
		beq codificarMensaje	/*Se dirige al main a la seccion de codificacion*/
		cmp r1,#'d'
		beq decodificarMensaje	/*Se dirige al main a la seccion de decodificacion*/
		cmp r1,#'D'
		beq decodificarMensaje	/*Se dirige al main a la seccion de decodificacion*/
		bl mostrar_error_opcion  /*Si el programa llega hasta aca es por que la opcion ingresada es invalida, muestra un mensaje y sale del programa*/
		
mostrar_error_opcion:			/*Muestra un mensaje de error al ingresar una opcion no valida y finaliza el programa*/
		mov r0, #1
		ldr r1, =errorOpcion
		mov r2, #32
		mov r7, #4
		swi #0
		bl fin
/*-----------------------------------------------------------FIN SECCION DE ELECCION DE OPCION-----------------------------------------------------------------*/



/*------------------------------------------------------SECCION DE CODIFICACION--------------------------------------------------------------------------------*/
ascii_a_entero:
		sub r0,#0x30         	/*R0 contiene la clave de tipo caracter en exadecimal, le resto 30 para converirla en un numero decimal*/
		strb r0,[r2]			/*Guardo el numero que esta en r0 en R2 que tiene la direccion de la variable entero*/
		ldrb r3,[r2]			/*Guardo el int de la direccion r2 en R3*/
		bx lr
		
codificar:
		ldrb r2, [r5,r4]		/*Guarda en r2 el contenido de la direccion guardada en r5 que es la var mensaje en la posicion marcada por r4*/
		cmp r2, #0x00			/*Compara el caracter en r2 para saber si es el final de la cadena*/
		bleq fin_codificacion	/*Si es el final, termina de codificar y vuelve al main*/
		cmp r2, #0x20			/*Si no es el final, compara el caracter en r2 para saber si es un espacio y no codificarlo*/
		addeq r4,#1				/*si es un espacio le suma uno a r4 para continuar con el siguiente caracter el mensaje*/
		cmp r2, #0x20			/*compara de nuevo el caracter en r2 para saber si es un espacion y no codificarlo*/
		beq codificar			/*Si es un espacio vuelve a iniciar la codificacion sin alterar el espacion y ya teniendo la siguiente posicion*/
		cmp r2, #0x60			/*Compara el caracter cargado en r2 con 60 en hexa*/
		bhi codificarmin		/*Si el carater en r2 es mayor a 60 en hexa, el caracter sera una miniscula y llamara a la funcion que codifica las minusculas*/
		cmp r2,#0x5b			/*Compara el caracter cargado en r2 con 5B en hexa*/
		bcc codificarmay		/*Si el carater en r2 es menor a 5B en hexa, el caracter sera una mayuscula y llamara a la funcion que codifica las mayusculas*/
		
codificarmin:
		add r2,r3				/*sumamos el caracter cargado en r2 y la cantidad de espacios a moverse cargada en r3*/
		cmp r2, #0x7a			/*comparamos el contenido de r2 con 122 en hexa 7a, para saber si nos pasamos de la 'z'*/
		subhi r2,#0x1a			/*si r2 es mayor, le restamos 26 en hexa 1a, para empezar de nuevo desde la 'a'*/
		strb r2, [r5,r4]		/*reemplazamos el contenido de la direccion guardada en r5 en la posicion r4 por el numero guadrado en r2*/
		add r4,#1				/*Sumamos 1 a r4 para ir a la siguiente posision del mensaje al iniciar de nuevo el ciclo de codificacion*/
		add r12,#1				/*r12 guarda la cantidad de letras procesadas*/
		bal codificar			/*Vuelve a iniciar la codificacion con el siguiente caracter*/
		
codificarmay:
		add r2,r3				/*sumamos el caracter cargado en r2 y la cantidad de espacios a moverse cargada en r3*/
		cmp r2, #0x5a			/*comparamos el contenido de r2 con 90 en hexa 5a, para saber si nos pasamos de la 'Z'*/
		subhi r2,#0x1a			/*si r2 es mayor, le restamos 26 en hexa 1a, para empezar de nuevo desde la 'A'*/
		strb r2, [r5,r4]		/*reemplazamos el contenido de la direccion guardada en r5 en la posicion r4 por el numero guadrado en r2*/
		add r4,#1				/*Sumamos 1 a r4 para ir a la siguiente posision del mensaje al iniciar de nuevo el ciclo de codificacion*/
		add r12,#1				/*r12 guarda la cantidad de letras procesadas*/
		bal codificar			/*Vuelve a iniciar la codificacion con el siguiente caracter*/
		
bit_de_paridad:						/*Ciclo para saber si la cantidad de letras procesadas es par o impar y determinar la paridad*/
		sub r1, #2					/*resta 2 a la cantidad total de letras procesadas*/
		cmp r1, #1					/*compara r1 despues de la resta con un 1*/
		beq guarda_uno				/*Si es igual, significa que la cantidad de letras es impar y guarda un 1 en la var bitParidad*/
		cmp r1, #0					/*compara r1 despues de la resta con un 0*/
		beq guarda_cero				/*Si es igual, significa que la cantidad de letras es par y guarda un 0 en la var bitParidad*/
		bal bit_de_paridad			/*repite el ciclo si r1 es mas grande que 1 y que 0*/
		
guarda_uno:							/*guarda un 1, en hexa en la var bitParidad*/
		ldr r4, =bitParidad			/*carga la dir de la variable bitParidad en R4*/
		mov r0, #0x31				/*carga en r0 el 31 en hexa que es el 1 en ascii*/
		strb r0, [r4,r2]			/*guarda el contenido de r0 en la vari bitParidad, en las posicion marcada por r2 que es 0*/
		bx lr						/*Luego de guardar la paridad a mostrar vuelve al main*/
		
guarda_cero:						/*guarda un 0, en hexa en la var bitParidad*/
		ldr r4, =bitParidad			/*carga la dir de la variable bitParidad en R4*/
		mov r0, #0x30				/*carga en r0 el 30 en hexa que es el 0 en ascii*/
		strb r0, [r4,r2]			/*guarda el contenido de r0 en la vari bitParidad, en las posicion marcada por r2 que es 0*/
		bx lr						/*Luego de guardar la paridad a mostrar vuelve al main*/
		
mostrar_paridad:
		mov r0, #1
		ldr r1, =bitParidad
		mov r2, #3
		mov r7, #4
		swi #0
		bx lr
/*------------------------------------------------------FIN SECCION DE CODIFICACION---------------------------------------------------------------------------*/


/*------------------------------------------------------SECCION DE DECODIFICACION------------------------------------------------------------------------------*/
decodificar:
		ldrb r2, [r5,r4]		/*Cargo en r2 el bit de la direccion guardada en r5 en la posicion marcada por r4*/
		cmp r2, #0x00			/*Compara el caracter en r2 para saber si es el final de la cadena*/
		bleq fin_decodificacion	/*Si es el final, termina de decodificar y vuelve al main*/
		cmp r2, #0x20			/*Si no es el final, compara el caracter en r2 para saber si es un espacio y no decodificarlo*/
		addeq r4,#1				/*si es un espacio le suma uno a r4 para continuar con el siguiente caracter el mensaje*/
		cmp r2, #0x20			/*compara de nuevo el caracter en r2 para saber si es un espacion y no codificarlo*/
		beq decodificar			/*Si es un espacio vuelve a iniciar la decodificacion sin alterar el espacion y ya teniendo la siguiente posicion*/
		cmp r2, #0x60			/*Compara el caracter cargado en r2 con 60 en hexa*/
		bhi decodificarmin		/*Si el carater en r2 es mayor a 60 en hexa, el caracter sera una miniscula y llamara a la funcion que decodifica las minusculas*/
		cmp r2,#0x5b			/*Compara el caracter cargado en r2 con 5B en hexa*/
		bcc decodificarmay		/*Si el carater en r2 es menor a 5B en hexa, el caracter sera una mayuscula y llamara a la funcion que decodifica las mayusculas*/

decodificarmin:
		sub r2,r10				/*Restamos el caracter cargado en r2 y la cantidad de espacios a moverse cargada en r10*/
		cmp r2, #0x61			/*comparamos el contenido de r2 con 97 en hexa 61, para saber si nos fuimos mas atras de la 'a'*/
		addcc r2,#0x1a			/*si r2 es menor, le sumamos 26 en hexa 1a, para empezar de nuevo desde la 'z'*/
		strb r2, [r5,r4]		/*reemplazamos el contenido de la direccion guardada en r5 en la posicion r4 por el numero guadrado en r2*/
		add r4,#1				/*Sumamos 1 a r4 para ir a la siguiente posision del mensaje al iniciar de nuevo el ciclo de decodificacion*/
		add r12,#1				/*r12 guarda la cantidad de letras procesadas*/
		bal decodificar			/*Vuelve a iniciar la decodificacion con el siguiente caracter*/

decodificarmay:
		sub r2,r10				/*Restamos el caracter cargado en r2 y la cantidad de espacios a moverse cargada en r10*/
		cmp r2, #0x41			/*comparamos el contenido de r2 con 65 en hexa 41, para saber si nos fuimos mas atras de la 'A'*/
		addcc r2,#0x1a			/*si r2 es menor, le sumamos 26 en hexa 1a, para empezar de nuevo desde la 'Z'*/
		strb r2, [r5,r4]		/*reemplazamos el contenido de la direccion guardada en r5 en la posicion r4 por el numero guadrado en r2*/
		add r4,#1				/*Sumamos 1 a r4 para ir a la siguiente posision del mensaje al iniciar de nuevo el ciclo de decodificacion*/
		add r12,#1				/*r12 guarda la cantidad de letras procesadas*/
		bal decodificar			/*Vuelve a iniciar la decodificacion con el siguiente caracter*/

	
paridad_a_entero:
		ldrb r0,[r11]			/*Cargo en r0 el contenido de la direccion de r11 que es la variable paridad_ingresadatxt*/
		sub r0,#0x30         	/*R0 contiene la clave de tipo caracter en exadecimal, le resto 30 para converirla en un numero decimal*/
		ldr r2, =paridadIngresada	/*Cargo en r2 la dir de la var paridadIngresada*/
		strb r0,[r2]			/*Guardo el numero que esta en r0 en R2 que tiene la direccion de la variable paridadIngresada*/
		ldrb r3,[r2]			/*Guardo el int de la direccion r2 en R3 donde esta guardada la paridad*/
		bx lr
		
bit_de_paridad_deco:
		sub r1,#2
		cmp r1,#1
		beq comparar_paridad_uno
		cmp r1,#0
		beq comparar_paridad_cero
		bal bit_de_paridad_deco
		
comparar_paridad_uno:
		cmp r1,r3
		bne mostrar_error_paridad
		bx lr
		
comparar_paridad_cero:
		cmp r1,r3
		bne mostrar_error_paridad
		bx lr
		
mostrar_error_paridad:
		mov r0, #1
		ldr r1, =mensajeError
		mov r2, #44
		mov r7, #4
		swi #0
		bl fin
		
/*------------------------------------------------------FIN SECCION DE DECODIFICACION--------------------------------------------------------------------------*/


/*---------------------------------------------------------------SECCION FINAL---------------------------------------------------------------------------------*/

cant_letras_proc:
	ldr r0,=letras_procesadastxt
	cmp r12,#50
	movhi r6, #0x35
	cmp r12,#50
	strhib r6, [r0,r2]
	cmp r12,#50
	subhi r12, #50
	
	cmp r12,#40
	movhi r6, #0x34
	cmp r12,#40
	strhib r6, [r0,r2]
	cmp r12,#40
	subhi r12, #40
	
	cmp r12,#30
	movhi r6, #0x33
	cmp r12,#30
	strhib r6, [r0,r2]
	cmp r12,#30
	subhi r12, #30
	
	cmp r12,#20
	movhi r6, #0x32
	cmp r12,#20
	strhib r6, [r0,r2]
	cmp r12,#20
	subhi r12, #20
	
	cmp r12,#10
	movhi r6, #0x31
	cmp r12,#10
	strhib r6, [r0,r2]
	cmp r12,#10
	subhi r12, #10
	
	add r2,#1
	add r12, #0x30
	strb r12, [r0,r2]
	bal mostrar_letras_proc
	
mostrar_letras_proc:
		mov r0, #1
		ldr r1, =letras_procesadastxt
		mov r2, #35
		mov r7, #4
		swi #0
		bl fin




.global main
main:
		bl saludar				/*Mensaje de bienvenida al usuario*/
		bl leer_input			/*Lee el mensaje, clave y opcion ingresados por el usuario*/
		bl mostrar_texto_ingresado
		bl mostrar_input		/*Muestra un texto por consola*/
		bl limpiar_registros    /*Limpia los registros antes de empezar a utilizarlos*/
		ldr r0,=input			/*Guarda en r0 la direccion donde esta almacendada la variavle INPUT*/
		/*ldr r0,=mensajefalso*/			
		ldr r5, =mensaje		/*Guarda en R5 la direccion de la variable mensaje*/
		ldr r8, =clave			/*Guarda en R8 la direccion de la variable clave*/
		ldr r9, =opcion			/*Guarda en R9 la direccion de la variable opcion*/
		ldr r11,=paridad_ingresadatxt /*Guarda en R11 la direccion de la variable paridad_ingresadatxt*/
		bl extraer_mensaje      
vuelta:
		mov r10, #0x00			/*R10 va a contar la cantidad de caracteres ingresado en la pista o clave para saber cuanto mover al decodificar*/
		bl extraer_clave        
vuelta1:
		bl extraer_opcion
		bl extraer_paridad
/*A esta altura r0 tiene la dir del input, r5 la dir de mensaje, r8 la dir de clave, r9 la dir de opcion,
r10 la cantidad de caracteres de la opcion o sea la pista para decodificar y r11 la dir de paridad_ingresadatxt */
/*Ya se pueden usar de nuevo R0, R1, R2, R3, R4 y R6*/
		
		bl texto_de_mensaje
		bl mostrar_mensaje
		bl salto_manual
		bl texto_de_clave
		bl mostrar_clave
		bl texto_de_opcion
		bl mostrar_opcion
		mov r0,#0				/*Limpiamos el contenido de R0,R2,R3,R4,R6 luego de los ciclos para extraer*/
		mov r1,#0
		mov r2,#0				
		mov r3,#0
		mov r4,#0
		mov r6,#0
		bl opcion_elegida		/*Compara la opcion guardada en la dir R9 y elige si codificar o decodificar*/


codificarMensaje:				/*Siguen disponibles los reg:R0, R1, R2, R3, R4, R6 y r12 */
		mov r1,#0				/*Limpiamos el contenido de r1 luego de saber que opcion se eligio*/
		ldrb r0,[r8]			/*Guardo en R0 el contenido que se encuentra en la direccion almacenada en R8 que es la clave*/
		ldr r2, =entero			/*Guarda en R2 la direccion de la variable entero, que es donde se va a guardar cuanto se deben desplazar los caracteres a codificar*/
		bl ascii_a_entero		/*Convierte la clave que esta en ascii a tipo int para usarla en la codificacion*/
		/*Antes de codificar el R3 esta ocupado con la cantidad que se deben desplazar los caracteres, R0 y R2 estan libres para usar de nuevo*/
		bl codificar

fin_codificacion:				/*Estan disponibles los reg: R0, R1, R2, R3, R4, R6. El r12 contiene la cantidad de letras encriptadas */
		
		bl mostrar_texto_de_mensajeproc
		bl mostrar_mensaje		/*Muestra el mensaje ya codificado*/
		mov r0,#0
		mov r1,#0
		mov r2,#0
		mov r3,#0
		mov r4,#0
		mov r6,#0
		add r1, r12				/*Guarda en r1 la cantidad de letras procesadas*/
		bl bit_de_paridad		/*Guarda en la variable bitParidad si debe mostrar un 0 o un 1 dependiendo de la cantidad de letras del mensaje*/
		bl mostrar_paridad		/*Luego de mostrar el mensaje ya encriptado muestra la paridad*/
		/*Estan disponibles los reg: R0, R1, R2, R3, R4, R6. El r12 contiene la cantidad de letras encriptadas*/
		
		mov r0,#0
		mov r1,#0
		mov r2,#31				/*guardo en r2 un 31 por que en la variable letras_procesadastxt ya tengo los primeros 30 bits ocupados con texto*/
		mov r3,#0
		mov r4,#0
		mov r6,#0
		
		bl cant_letras_proc		/*Funcion que guarda la cantidad de letras procesadas de int a ascci para mostrar un mensaje y terminar el programa*/
		


decodificarMensaje:				/*Siguen disponibles los reg:R0, R1, R2, R3, R4, R6 y r12. El r10 tiene la cantidad de caracteres que tiene la pista y r11 tiene la dir de la var paridad_ingresadatxt*/
		mov r1,#0				/*Limpiamos el contenido de r1 luego de saber que opcion se eligio*/
		bl decodificar

	

fin_decodificacion:				/*Siguen disponibles los reg:R0, R1, R2, R3, R4, R6 y r10. El r12 tiene la cantidad de caracteres procesados y r11 tiene la dir de la var paridad_ingresadatxt*/
		mov r2,#0				/*Limpiamos r2, r4, r10 luego de decodificar*/
		mov r4,#0
		mov r10,#0
		add r1, r12				/*Guarda en r1 la cantidad de letras procesadas*/
		bl paridad_a_entero
		/*R3 tiene guardada la paridad ingresada por el usuario*/
		bl bit_de_paridad_deco	/*Compara la paridad del mensaje ingresado por el usuario con la del mensaje ya decodificado, si no coinciden muestra un error*/
		bl mostrar_texto_de_mensajeproc
		bl mostrar_mensaje		/*Muestra el mensaje ya decodificado*/
		bl salto_manual
		mov r1,#0
		mov r2,#31				/*guardo en r2 un 31 por que en la variable letras_procesadastxt ya tengo los primeros 30 bits ocupados con texto*/
		mov r0,#0
		mov r4,#0
		mov r6, #0
		
		bl cant_letras_proc		/*Funcion que guarda la cantidad de letras procesadas de int a ascci para mostrar un mensaje y terminar el programa*/
		
fin:
		mov r7, #1
		swi 0