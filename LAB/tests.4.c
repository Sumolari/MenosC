int valor;
bool continuar;
read( valor );
continuar = true;
for ( ; continuar; valor-- )
	if ( valor < 3 )
		continuar = false;
	else
		continuar = true;
