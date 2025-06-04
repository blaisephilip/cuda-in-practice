#include <stdio.h>

// CUDA Kernel function to add the elements of two arrays on the GPU
__global__
void add(int n, float *x, float *y)
{
    // Get the thread ID
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    
    // Make sure we don't go out of bounds
    if (index < n)
        y[index] = x[index] + y[index];
}

int main(void)
{
    int N = 1<<20; // 1M elements
    
    // Allocate host memory
    float *x = new float[N];
    float *y = new float[N];

    // Initialize host arrays
    for (int i = 0; i < N; i++) {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    // Allocate device memory
    float *d_x, *d_y;
    cudaMalloc(&d_x, N * sizeof(float));
    cudaMalloc(&d_y, N * sizeof(float));

    // Copy arrays to device
    cudaMemcpy(d_x, x, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, y, N * sizeof(float), cudaMemcpyHostToDevice);

    // Launch add() kernel on GPU
    int blockSize = 256;
    int numBlocks = (N + blockSize - 1) / blockSize;
    add<<<numBlocks, blockSize>>>(N, d_x, d_y);

    // Copy result back to host
    cudaMemcpy(y, d_y, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Cleanup
    cudaFree(d_x);
    cudaFree(d_y);
    delete [] x;
    delete [] y;

    return 0;
}