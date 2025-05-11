from config import HOSTNAME, USERNAME, PASSWORD, DEFAULT_LOCAL_PATH, DEFAULT_REMOTE_PATH
from utils.logger import setup_logger
from utils.table import display_logs
from core.ssh_manager import SSHManager
from core.command_executor import run_remote_command
from core.file_transfer import transfer_file
from platform_adapter.ssh_key_resolver import resolve_key_path
import datetime
import random
import time
import logging

def simulate_delay():
    delay = random.randint(1, 5)
    logging.info(f"Simulating {delay} second delay...")
    time.sleep(delay)

def main():
    setup_logger()
    logs = []

    key_path = resolve_key_path()
    ssh = SSHManager(HOSTNAME, 
                     USERNAME, 
                     key_filepath=key_path if key_path else None,
                     password=None if key_path else PASSWORD
                     )

    try:
        ssh.connect()
    except Exception as e:
        if key_path:
            logging.warning("Key failed, trying password...")
            ssh = SSHManager(HOSTNAME, USERNAME, password=PASSWORD)
            ssh.connect()
        else:
            logging.error("No key and password failed.")
            return

    try:
        logs.append([datetime.datetime.now(), "Command Execution", "Running 'ls -l'"])
        output = run_remote_command(ssh, 'ls -l')
        logs.append([datetime.datetime.now(), "Command Output", output])

        logs.append([datetime.datetime.now(), "File Transfer", f"{DEFAULT_LOCAL_PATH} → {DEFAULT_REMOTE_PATH}"])
        transfer_file(ssh.get_transport(), DEFAULT_LOCAL_PATH, DEFAULT_REMOTE_PATH)

        simulate_delay()
        display_logs(logs)

    finally:
        ssh.close()

if __name__ == "__main__":
    main()
