Setting up python:
- Open command promt or powershell.
- Type: python --version, if its 3.9 to 3.12, theres no need to download python again.
- Else, download a compatible python version, like this one: https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe
- After downloading, run the file and in the installer make sure to:
    - Choose Modify or Repair, Click Next.
    - Check the box that says "Add to PATH" or "Add Python to environment variables".
    - Click Install.

Setup:
- Double click "run_me.bat" file (on Windows) and follow instructions.
- Open project folder in an IDE, liek vscode.
- Go to main.py, run it, and press q to stop.

Notes:
- cv2 captures each frame at nagddraw ng points and lines
- mediapipe ang nagdedetect ng points ng hands, idk how but

this where the 0-20 numbers came from sa CONNECTIONS array, from mediapipe website:

![hand landmarks](assets/hand_landmarks.png)

ito sana plano madetect:

![asl alphabet](assets/asl_alphabet.jpg)

then ilagay sana sa textbox like this:
https://www.youtube.com/watch?v=MYVD7mVJ21w