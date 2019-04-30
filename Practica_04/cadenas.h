int stringlen(char *str){
  char *aux;
  int counter = 0;
  aux = str;

  while(1){
    if(*str == '\0' || *str == NULL)
      break;
    else{
      aux++;
      counter++;
    }  
  }
  return counter;
}

void stringcpy(char *to, char *from){ //Asumimos que to >= from 
  if(to == NULL || from == NULL)
    return;
  
  int i, len_to, len_from;
  char * res; 

  len_to = stringlen(to);
  len_from = stringlen(from);

  if(len_to > len_from)
    res = (char *) malloc(len_to+1);
  else
    res = (char *) malloc(len_from+1);
  
  memcpy(res, from, len_from);
  free(to);
  to = res;

  return;
}

void stringcat(char *to, char *from){
  if(to == NULL || from == NULL)
    return;
  
  int i, len_to, len_from;
  char * res; 
  len_to = stringlen(to);
  len_from = stringlen(from);

  res = (char *) malloc(len_to + len_from + 1);
  memcpy(res, to, len_to-1);
  memcpy(res+(len_to-1), from, len_from);
  free(to);
  to = res;

  return;
}

char* stringconcat( char *s1,  char *s2){
    char *result = malloc(stringlen(s1) + stringlen(s2) + 1); // +1 for the null-terminator
    stringcpy(result, s1);
    stringcat(result, s2);
    return result;
}
