# Import Visual Studio Developer environment
$vsPath = "C:\Program Files\Microsoft Visual Studio\2022\Community"
$vcvarspath = "$vsPath\VC\Auxiliary\Build\vcvars64.bat"

# Create a temporary batch file to capture environment variables
$tempFile = [System.IO.Path]::GetTempFileName() + ".bat"
"call `"$vcvarspath`"`nset" | Out-File -FilePath $tempFile -Encoding ASCII

# Parse the environment variables
$envVars = cmd /c "$tempFile & del $tempFile" | Where-Object { $_ -match '=' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    [PSCustomObject]@{Name = $name; Value = $value}
}

# Set environment variables
$envVars | ForEach-Object { Set-Item -Path "env:$($_.Name)" -Value $_.Value }

echo "#########################################################################"
echo "Starting some environment checks..."
echo "The available NVIDIA GPUs on this system are:"
nvidia-smi
echo "#########################################################################"
echo "The available NVIDIA driver:"
nvcc -V

echo "#########################################################################"
echo "Start of the build process for vector addition and block addition"
cd ../src
echo "Build and profile vector_add.cu"
nvcc vector_add.cu -o vector_add
# ./vector_add
echo "Profile vector_add with Nsight Systems for system-wide performance analysis"
nsys profile --stats=true ./vector_add
# Profile with Nsight Compute
echo "Profile vector_add with Nsight Compute for detailed kernel analysis"
ncu --metrics gpu__time_duration.sum,sm__throughput.avg.pct_of_peak_sustained_elapsed ./vector_add

echo "#########################################################################"
echo "Build and profile add_block.cu"
nvcc add_block.cu -o add_block
echo "Profile add_block with Nsight Systems for system-wide performance analysis"
nsys profile --stats=true ./add_block
# Profile with Nsight Compute
echo "Profile add_block with Nsight Compute for detailed kernel analysis"
ncu --metrics gpu__time_duration.sum,sm__throughput.avg.pct_of_peak_sustained_elapsed ./add_block

echo "#########################################################################"
echo "Build and profile add_grid.cu"
nvcc add_grid.cu -o add_grid
echo "Profile add_grid with Nsight Systems for system-wide performance analysis"
nsys profile --stats=true ./add_grid
# Profile with Nsight Compute
echo "Profile add_grid with Nsight Compute for detailed kernel analysis"
ncu --metrics gpu__time_duration.sum,sm__throughput.avg.pct_of_peak_sustained_elapsed ./add_grid

cd ../scripts

echo "#########################################################################"
echo "End of the build process"
echo "#########################################################################"
