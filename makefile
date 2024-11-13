cp: cp.s
	as cp.s -o cp.o
	ld cp.o -o cp
	rm *.o
