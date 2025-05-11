from config import WINDOWS_KEY_FILEPATH, LINUX_KEY_FILEPATH
import platform
import os

def resolve_key_path():
    print(" platform.system(): " + platform.system())
    if platform.system() == "Windows":
        path = WINDOWS_KEY_FILEPATH
    else:
        path = LINUX_KEY_FILEPATH
    return path if os.path.exists(path) else None

if __name__ == "__main__":
    resolve_key_path()
