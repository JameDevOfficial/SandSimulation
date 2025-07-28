import os
import shutil
import subprocess
import platform
from pathlib import Path

def run(cmd, cwd=None):
    print(f"Running: {cmd}")
    result = subprocess.run(cmd, shell=True, cwd=cwd)
    if result.returncode != 0:
        print(f"Command failed: {cmd}")
    return result.returncode == 0

def main():
    root = Path.cwd()
    releases = root / "releases"
    game_src = root / "game"
    game_dst = releases / "game"
    executables = releases / "executables"
    web = releases / "web"
    love_file = releases / "SandSimulation.love"

    # Step 0: Clean up old releases
    if releases.exists():
        print("Deleting old releases directory...")
        shutil.rmtree(releases)

    # Step 1: Create directory structure
    print("Creating releases directory structure...")
    executables.mkdir(parents=True, exist_ok=True)
    game_dst.mkdir(parents=True, exist_ok=True)
    web.mkdir(parents=True, exist_ok=True)

    # Step 2: Copy game files
    print("Copying game files...")
    shutil.copytree(game_src, game_dst, dirs_exist_ok=True)

    # Step 3: Create .love file
    print("Creating .love file...")
    if love_file.exists():
        love_file.unlink()
    shutil.make_archive(str(love_file.with_suffix('')), 'zip', root_dir=game_dst)
    zip_path = love_file.with_suffix('.zip')
    if zip_path.exists():
        zip_path.rename(love_file)

    # Step 4: Build executables with love-release
    os.chdir(game_dst)
    print("Building executables with love-release...")
    has_love_release = shutil.which("love-release")
    if not has_love_release:
        print("Error: love-release not found in PATH.")
        return

    # Fix: Separate Windows and macOS builds, use correct Linux flag
    run("love-release -W 32")  # Windows 32-bit
    run("love-release -W 64")  # Windows 64-bit  
    run("love-release -M --uti com.example.sandsimulation")  # macOS
    run("love-release --uti com.example.sandsimulation")  # Linux (no -L flag needed)

    # Move built files to executables
    for f in ["SandSimulation-win32.zip", "SandSimulation-win64.zip", "SandSimulation-macosx-x64.zip", "SandSimulation-linux-x64.zip"]:
        file = game_dst / f
        if file.exists():
            shutil.move(str(file), executables)

    # Step 5: Build web version with love.js
    os.chdir(root)
    print("Building web version...")
    is_wsl = "Microsoft" in platform.uname().release
    
    # Fix: Convert WSL paths to Windows paths for love.js
    if is_wsl:
        # Convert /mnt/c/... to C:\...
        love_file_win = str(love_file).replace('/mnt/c/', 'C:\\').replace('/', '\\')
        web_win = str(web).replace('/mnt/c/', 'C:\\').replace('/', '\\')
        lovejs_cmd = f"npx love.js.cmd -c \"{love_file_win}\" \"{web_win}\" --title \"Sand Simulation\""
    else:
        lovejs_cmd = f"npx love.js -c \"{love_file}\" \"{web}\" --title \"Sand Simulation\""
    
    run(lovejs_cmd)

    # Cleanup
    if love_file.exists():
        love_file.unlink()

    # Step 6: Build summary
    print("\nBuild Summary:\n===============")
    checks = {
        "Windows 32-bit": executables / "SandSimulation-win32.zip",
        "Windows 64-bit": executables / "SandSimulation-win64.zip", 
        "macOS": executables / "SandSimulation-macosx-x64.zip",
        "Linux": executables / "SandSimulation-linux-x64.zip",
        "Web version": web / "index.html"
    }
    for name, path in checks.items():
        print(f"{'✓' if path.exists() else '✗'} {name}: {path if path.exists() else 'build missing!'}")

    print("\nAll builds completed! Check ./releases/ directory.")

if __name__ == "__main__":
    main()