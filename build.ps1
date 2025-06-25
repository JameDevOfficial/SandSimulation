# SandSimulation Build Script
# Run this from the project root directory

# Make sure you have makelove and luabundler installed and added to your path!
# https://github.com/pfirsich/makelove
# https://github.com/Benjamin-Dobell/luabundler

# Step 0: Delete main.lua in root if it exists
if (Test-Path -Path "./main.lua") {
    Remove-Item -Path "./main.lua" -Force
    Write-Host "Deleted old main.lua in project root."
}

# Step 1: Bundle Lua files using luabundler
luabundler bundle ./game/main.lua `
  -p "./?.lua" `
  -p "./game/?.lua" `
  -p "./elements/?.lua" `
  -p "./libs/?.lua" `
  -p "./libs/ui/?.lua" `
  -o main.lua

# Step 2: Move bundled file to build folder
if (-not (Test-Path -Path "./build")) {
    New-Item -ItemType Directory -Path "./build"
}
Move-Item -Path "./main.lua" -Destination "./build/main.lua" -Force

# Step 3: Delete build/bin if it exists
if (Test-Path -Path "./build/bin") {
    Remove-Item -Path "./build/bin" -Recurse -Force
    Write-Host "Deleted old build/bin directory."
}

# Step 4: Build with makelove
Set-Location build
makelove --config ./make_all.toml

# Verification
if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful! Output in ./build directory" -ForegroundColor Green
} else {
    Write-Host "Build failed. Check errors above" -ForegroundColor Red
}
Set-Location ..