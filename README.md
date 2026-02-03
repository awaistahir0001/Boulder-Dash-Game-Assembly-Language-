====
Boulder Dash (COAL Assembly Project) - DOS / DOSBox-X
====

1) Overview
-----------
This is a Boulder Dash–style course project written in x86 Assembly (DOS .COM format).
The program displays a tile-based UI in DOS text mode by writing directly to video
memory (segment 0xB800).

The main flow:
- Clears screen
- Asks the user to enter a filename
- Opens and reads the file using DOS interrupts (int 21h)
- Validates the map data (must contain at least 1600 bytes)
- Renders the map tiles on screen

Note:
This repository focuses on the level loader + renderer (UI display) in Assembly.
The map file is the key input: it defines where walls, diamonds, rocks, etc. are.

-----------------------------------------------------------

2) Tile Legend (Map Symbols)
----------------------------
Your level/map file should contain characters that represent tiles:

'W'  = Wall
'D'  = Diamond
'B'  = Boulder
'R'  = Rock
'T'  = Target / Exit
'x'  = Dirt
' '  = Blank / Empty

The renderer reads each byte from the file and prints a styled character in the
console screen using a matching color attribute.

-----------------------------------------------------------

3) Requirements
---------------
To run/compile this project you need:

A) DOSBox-X (to run the program)
B) NASM assembler (recommended, because the code uses: [org 0x0100])

Files in repo:
- boulder_dash.asm   (Assembly source)
- level file(s)      (YOU provide, ex: level1.dat / map1.txt)

-----------------------------------------------------------

4) IMPORTANT: Level File Format
-------------------------------
The program expects to read at least 1600 bytes of map data.

1600 cells usually means:
- 80 columns x 20 rows (80 * 20 = 1600)

So your file should contain EXACTLY the tile characters for 1600 positions.

IMPORTANT NOTES:
- Avoid extra newlines if possible.
- If you use a normal text editor, it may add CR/LF characters.
- If your file contains fewer than 1600 bytes, you will get:
  "file has incomplete data"

Tip:
Create the map as a “flat” 1600-character file (no extra formatting),
or ensure total bytes >= 1600.

-----------------------------------------------------------

5) How to Compile (NASM)
------------------------
If you are compiling outside DOSBox (recommended):

1) Install NASM on Windows
2) Open Command Prompt in the repo folder
3) Run:

   nasm -f bin boulder_dash.asm -o BOULDER.COM

This creates a DOS executable file (BOULDER.COM).

-----------------------------------------------------------

6) How to Run in DOSBox-X (Step-by-step)
----------------------------------------
1) Open DOSBox-X
2) Mount your project folder as a DOS drive.
   Example (change path to your folder):

   mount c C:\Users\YOURNAME\Desktop\boulder-dash

3) Switch to the mounted drive:

   c:

4) Confirm files exist:

   dir

   You should see:
   - BOULDER.COM (or your .COM output)
   - your map file (example: LEVEL1.DAT)

5) Run the program:

   BOULDER.COM

6) The program will ask:

   Enter filename:

   Type your level filename exactly as it appears (example):
   LEVEL1.DAT

7) If the file opens and reads correctly, you will see messages like:
   - file opened successfully
   - file read successful
   - press any key to begin

8) Press any key and the tile-map UI will be displayed.

-----------------------------------------------------------

7) Common Errors & Fixes
------------------------
A) "file does not exist"
- Make sure the map file is in the same mounted folder as the program.
- Type the name correctly (including extension).
- Use DOS 8.3 filenames if needed (LEVEL1.DAT, MAP1.TXT etc).

B) "failed to read the file"
- File may be locked/corrupt or DOSBox cannot access it.
- Try a different file name and ensure it’s in the mounted folder.

C) "file has incomplete data"
- Your map file is smaller than 1600 bytes.
- Ensure the file contains at least 1600 tile characters.

-----------------------------------------------------------

8) Project Notes (Technical)
----------------------------
- Built as a DOS .COM program (origin 0x0100)
- Uses BIOS/DOS interrupts:
  - int 10h for cursor positioning
  - int 21h for printing strings, reading input, opening and reading files
  - int 16h to wait for key press
- Draws UI by writing words to video memory (0xB800)
- Uses a tile-to-color mapping in the "display" routine

-----------------------------------------------------------

9) Author
---------
Course project for COAL (Computer Organization & Assembly Language)
Run environment: Notepad + DOSBox-X
===========================================================
