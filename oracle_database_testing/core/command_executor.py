import logging

def run_remote_command(ssh_manager, command):
    output, error = ssh_manager.exec_command(command)
    if error:
        logging.error(f"Error executing {command}: {error}")
    return output
