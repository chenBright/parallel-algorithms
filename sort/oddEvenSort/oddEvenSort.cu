#include <iostream>
 using namespace std;
 
 #include <cuda_runtime.h>
 
 __device__ void swap(int *a, int *b) {
     int temp = *a;
     *a = *b;
     *b = temp;
 }
 
 __global__ void sort(int *d_arr, int n, bool isEven) {
     int i;
     if (isEven) {
         i = threadIdx.x * 2;
     } else {
         i = threadIdx.x * 2 + 1;
     }
 
     if (i < n -1) {
         if (d_arr[i] > d_arr[i + 1]) {
             swap(&d_arr[i], &d_arr[i + 1]);
         }
     }
 }
 
 void sort(int *arr, int n) {
     size_t size = n * sizeof(int);
 
     int *d_arr = NULL;
     cudaMalloc((void **)&d_arr, size);
     cudaMemcpy(d_arr, arr, size, cudaMemcpyHostToDevice);
 
 
     for (int phase = 0; phase < n; ++phase) {
         sort<<<1, n / 2>>>(d_arr, n, phase % 2 == 0);
     }
 
     cudaMemcpy(arr, d_arr, size, cudaMemcpyDeviceToHost);
 
 }
 
 int main() {
     int h_a[] = {9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
     int n = 10;
 
     for (int i = 0; i < n; ++i) {
         cout << h_a[i] << ' ';
     }
     cout << endl;
 
 
     sort(h_a, n);
 
     for (int i = 0; i < n; ++i) {
         cout << h_a[i] << ' ';
     }
     cout << endl;
 
     return 0;
 }
 
 