{
	int x;
	int y;
	bool z;

    read(x);
    read(y);

    if ( true ) print( 0 );
    else {}

    if ( false ) {} else { print( 1 ); }

    if ( !true ) {} else { print( 2 ); }

    if ( !false ) { print(3); } else {}

    if ( true || false ) {
    	print( 4 );
    } else {}

    if ( true && true ) {
    	print( 5 );
    } else {}

    if ( true && !false ) {
    	print( 6 );
    } else {}

    if ( (x != y) || (x != 0) ) {
    	print( 7 );
    } else {}

    if ( !( x == 0 ) )
    	print( 8 );
    else {}

    if ( ( x == y ) && ( x > 0 ) ) {
    	print( 9 );
    }
   	else {}
}
