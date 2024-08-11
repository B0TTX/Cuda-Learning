#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define N 100000000
#define MAX_ERR 1e-6

__global__ void vecAdd(float *out, float *a, float *b, int n)
{
	for(int i=0; i<n; i++)
	{
		out[i] = a[i] + b[i];
	}
}


int main()
{
	float *a, *b, *out;
	float *x, *y, *z;

	a = (float*)malloc(sizeof(float) * N);
	b = (float*)malloc(sizeof(float) * N);
	out = (float*)malloc(sizeof(float) * N);


	for(int i=0; i<N; i++)
	{
		a[i] = 1.0f;
		b[i] = 2.0f;
	}

	cudaMalloc((void**)&x, sizeof(float) * N);
	cudaMalloc((void**)&y, sizeof(float) * N);
	cudaMalloc((void**)&z, sizeof(float) * N);

	cudaMemcpy(x, a, sizeof(float) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(y, b, sizeof(float) * N, cudaMemcpyHostToDevice);

	vecAdd<<<1,1>>>(z, x, y, N);

	cudaMemcpy(out, z, sizeof(float) * N, cudaMemcpyDeviceToHost);

	cudaFree(x);
	cudaFree(y);
	cudaFree(z);

	free(a);
	free(b);
	free(out);
}
