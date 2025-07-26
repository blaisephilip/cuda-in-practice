# cuda-in-practice

Build and run applications on the GPU of your workstation.  
The configuration of here described toolset is tested in 2025-05.  

## Prerequisites

* NVIDIA GPU
* CUDA installation
[https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html)  
[https://developer.nvidia.com/cuda-downloads](https://developer.nvidia.com/cuda-downloads)  
* NSights installation [https://developer.nvidia.com/nsight-systems/get-started](https://developer.nvidia.com/nsight-systems/get-started)
* C++ Compiler Installation
Example: use MSVC for Visual Studio

The applied code is used from the following NVIDIA training:  
https://colab.research.google.com/github/NVDLI/notebooks/blob/master/even-easier-cuda/An_Even_Easier_Introduction_to_CUDA.ipynb  


Tested versions:  
cuda_12.9.0_576.02_windows  
NsightSystems-2025.3.1.90-3582212  

## Application

1. Switch to the scripts directory in your terminal.
2. Start a powershell script.

## General development notes

* Always use .cu for source and .cuh for headers, so the Intellisense does not report any false positives.
* Set the "C_Cpp.default.compilerPath" variable in .vscode/settings.json to the correct path of the cl.exe compiler in the Visual Studio installation, or another C/C++ compiler executable.
