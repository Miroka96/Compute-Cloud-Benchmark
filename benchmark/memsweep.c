/*
**
** memsweep.c        Benchmark to measure memory access performance
**                   (measures time to access large heap array at
**                   varying locations)
**
** To compile:  cc -O -o memsweep memsweep.c -lm
**
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <float.h>

#define ARR_SIZE (4096 * 4096)

double wrapper(void);

static double second(void)
{
    return ((double)((double)clock()/(double)CLOCKS_PER_SEC));
}

int main(void)
{
  float time_sum = 0.;
  int count = 0;
  while(time_sum < 10){
    time_sum += wrapper();
    count++;
  }
  printf("%f\n", time_sum/count);
  return 0;
}

double wrapper(){
  unsigned int i;
  double time;
  volatile char* array;
  
  array = (char*) malloc(sizeof(char)*ARR_SIZE);
  
  time = second();
  for (i = 0; i < 10 * ARR_SIZE; i++)
  {
    array[(4096 * i + i) % ARR_SIZE] = 1 + array[i % ARR_SIZE];
  }
  free((void*)array);
  time = second() - time;
  return time;
}