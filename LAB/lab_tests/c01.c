// Ejemplo del uso de operadores logicos.
//   Devuelve 1 si los dos numeros son > 0 e iguales
{ int x; int y;
  bool z; 

  z = true; 
  for (; z;) {
    read(x); read(y);
    if ((x != y) || (x != 0)) {         
      if (!(x == 0))                      
        if ((x == y) && (x > 0)) {
          print(1); z = false;
        }
        else print(0);
      else {}
    } 
    else {}
  }
}
