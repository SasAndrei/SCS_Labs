#include "stdio.h"
#include "stdlib.h"
#include "time.h"
#include <windows.h>


unsigned long* numbers;
typedef struct MyData {
    unsigned long start;
    unsigned long len;
} MYDATA, *PMYDATA;
DWORD WINAPI MyThreadFunction( LPVOID lpParam );

int is_prime(unsigned long n)
{
	
	for (unsigned long i=2; i<n; i++)
	{
		if(n%i == 0) return 0;
	}
	return 1;
} 

int main(int argc, char* argv[])
{
	unsigned long lEnd, failure, mult, len, nThreads;
	unsigned long i;
	HANDLE*  hThreadArray;
	DWORD*   dwThreadIdArray;
	PMYDATA* pDataArray;

    if (argc != 3) {
        
		lEnd = 100000;
		nThreads = 1;
    } 
	else {
        
       
		lEnd = atol(argv[1]);
		nThreads = atol(argv[2]);
	}
	len = 0;
	numbers = (unsigned long*)malloc(lEnd * sizeof(unsigned long));
	clock_t start = clock();
		for (i = 2; i <= lEnd; i++)
			if (is_prime(i)) {
				numbers[len] = i;
				len++;
			}
	clock_t end = clock();
	
	double cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;

	printf("for loop took %f seconds to execute \n", cpu_time_used);
		/*for (i=0; i<len; i++)
		{
			if(numbers[i] > 0)
			{
				printf("%d\n", numbers[i]);
			}
		}*/

		failure = 0;
    
    return failure; 
}

DWORD WINAPI MyThreadFunction( LPVOID lpParam ) 
{
	PMYDATA pDataArray;
	pDataArray = (PMYDATA)lpParam;

	
	unsigned long k, mult, j;
	for (k=pDataArray->start; k<pDataArray->start+pDataArray->len; k++)
		{
			if(is_prime(numbers[k]) == 1)
			{				
				
				for (j=2*numbers[k]-2;j<pDataArray->len;j+=numbers[k])
				{
					numbers[j] = 0;
					
				}			
				
			}
			else{numbers[k] = 0;}
		}
	return 0;
}