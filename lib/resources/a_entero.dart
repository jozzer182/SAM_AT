int aEntero(String dato){
  if(dato.isEmpty) return 0;
  return int.parse(dato);
}

aEnteroNoCero(String dato){
  if(dato.isEmpty) return 1;
  return int.parse(dato);
}