#import <pthread.h>
#import <stdio.h>

int fibonacci(int n) {
	if (n <= 1) return n;
	return fibonacci(n - 1) + fibonacci(n - 2);
}

void *fib(void *n) {
	int result = fibonacci(*(int *)n);
	printf("fibonacci number %d: %d\n", *(int *)n, (int)result);
	return NULL;
}

int main(int argc, char *argv[]) {
	pthread_t threadID[10];
	int threadError;
	
	int indexes[10];
	for (int index = 0; index < 10; index += 1) {
		indexes[index] = index;
		threadError = pthread_create(&threadID[index], NULL, fib, &indexes[index]);
	}
	
	pthread_exit(NULL);
}
