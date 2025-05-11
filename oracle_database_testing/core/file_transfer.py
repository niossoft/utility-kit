from scp import SCPClient
import logging

def transfer_file(ssh_transport, local_path, remote_path):
    try:
        scp = SCPClient(ssh_transport)
        scp.put(local_path, remote_path)
        logging.info(f"Transferred {local_path} to {remote_path}")
    except Exception as e:
        logging.error(f"Transfer failed: {e}")
