#define rdtsc __asm __emit 0fh __asm __emit 031h
#define cpuid __asm __emit 0fh __asm __emit 0a2h
#include <stdio.h>
#include <stdlib.h>

void func() {
	unsigned cycles_high1 = 0, cycles_low1 = 0, cpuid_time = 0;
	unsigned cycles_high2 = 0, cycles_low2 = 0;
	unsigned __int64 temp_cycles1 = 0, temp_cycles2 = 0;
	char sir[] = { 7,5,1,3,10,2 };
	unsigned val = 1;
	__int64 total_cycles = 0;

	//compute the CPUID overhead
	__asm {
		pushad
		CPUID
		RDTSC
		mov cycles_high1, edx
		mov cycles_low1, eax
		popad

		pushad
		CPUID
		RDTSC
		popad
		pushad
		CPUID
		RDTSC
		mov cycles_high1, edx
		mov cycles_low1, eax
		popad

		pushad
		CPUID
		RDTSC
		popad

		pushad
		CPUID
		RDTSC
		mov cycles_high1, edx
		mov cycles_low1, eax
		popad

		pushad
		CPUID
		RDTSC
		sub eax, cycles_low1
		mov cpuid_time, eax
		popad
	}
	cycles_high1 = 0;
	cycles_low1 = 0;
	//Measure the code sequence
	__asm {
		pushad
		CPUID
		RDTSC
		mov cycles_high1, edx
		mov cycles_low1, eax
		popad
	}
	//Section of code to be measured
	/* 
	
	_asm {
		add ebx, ecx
	}

	_asm {
		add val, ecx
	}
	_asm {
		mul  ebx
	}
	_asm {
		fdiv val
	}
	

	_asm {
		fsub val
	}
	*/

	__asm {

		mov eax, 0
		mov ebx, 0
		mov esi, 0

		mov ecx, 6


		scan: 
			mov ebx, ecx
			mov esi, 0

		next : 
			mov al, sir[esi]
			mov ah, sir[esi + 1]
			cmp ah, al
			jnae noswap
			mov sir[esi], ah
			mov sir[esi + 1], al

			noswap : 
				dec ebx
				inc esi
				jnc next
				loop scan

	}

	__asm {
		pushad
		CPUID
		RDTSC
		mov cycles_high2, edx
		mov cycles_low2, eax
		popad
	}
	temp_cycles1 = ((unsigned __int64)cycles_high1 << 32) | cycles_low1;
	temp_cycles2 = ((unsigned __int64)cycles_high2 << 32) | cycles_low2;
	total_cycles = temp_cycles2 - temp_cycles1 - cpuid_time;
	printf("%lld", total_cycles);
}


int main() {
	func();
	return 0;
}