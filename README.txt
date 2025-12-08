# FlagSnap

FlagSnap is a mod and addon combo for the WoW 1.12 client designed to automate flag pickup in WSG.



## Requirements
The following dependencies are required:
* A WoW 1.12 client
* [VanillaFixes](https://github.com/hannesmann/vanillafixes) (Required for DLL loading)

## Installation

1. Download the latest release from the [Releases Page](https://github.com/ErikNikolajsen/FlagSnap/releases).
2. Move the content of the `.zip` file to your WoW folder (overwrite if prompted).
3. In your WoW folder, open `dlls.txt` (included with VanillaFixes) and add `FlagSnap.dll` on a new line at the end of the file. Save and close the file.
4. Launch the game using `VanillaFixes.exe`.

## Usage

Setting up the Keybind:
Once in-game, open the Keybindings menu and assign a key to `Toggle FlagSnap on/off`.

**How it works:**
* Default: The addon starts active and will attempt to pickup the flag automatically.
* Drop/Pause: Press your bound key to drop the flag and disable auto-pickup.
* Resume: Press the key again to re-enable auto-pickup.

## Disclaimer
**Use at your own risk.** This mod utilizes DLL injection to automate gameplay actions. While designed for 1.12 clients, server rules regarding automation vary. The user alone is responsible for any bans or account suspensions resulting from the use of this tool.
