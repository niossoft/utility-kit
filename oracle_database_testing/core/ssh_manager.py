import paramiko
import logging

class SSHManager:
    def __init__(self, hostname, username, password=None, key_filepath=None):
        self.hostname = hostname
        self.username = username
        self.password = password
        self.key_filepath = key_filepath
        self.client = None

    def connect(self):
        self.client = paramiko.SSHClient()
        self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        if self.key_filepath:
            self.client.connect(self.hostname, username=self.username, key_filename=self.key_filepath)
        else:
            self.client.connect(self.hostname, username=self.username, password=self.password)
        logging.info(f"Connected to {self.hostname}")

    def close(self):
        if self.client:
            self.client.close()
            logging.info(f"Connection to {self.hostname} closed")

    def get_transport(self):
        return self.client.get_transport()

    def exec_command(self, command):
        stdin, stdout, stderr = self.client.exec_command(command)
        return stdout.read().decode(), stderr.read().decode()
