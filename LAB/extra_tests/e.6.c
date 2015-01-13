{
	// Estre programa imprime 15 y luego 22.
	int a;
	int b;
	a = 3 % 2;           // 1
	while ( a++ < 3 ) {  // Esto se repetira 2 veces: una para a=2 y otra para
	                     // a = 3, notese que se usa postincremento!
		b = 7 * a;       // 2 * 7 y 3 * 7
		print( ++b );    // 14+1 y 21+2
	}
}