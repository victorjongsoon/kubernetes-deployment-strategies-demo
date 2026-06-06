import os
import socket
from datetime import datetime, timezone
from flask import Flask, jsonify

app = Flask(__name__)
VERSION = os.getenv("APP_VERSION", "v1")
COLOR = os.getenv("APP_COLOR", "#2563eb")
STRATEGY = os.getenv("APP_STRATEGY", "unknown")
POD_NAME = os.getenv("HOSTNAME", socket.gethostname())


def state():
    return {
        "version": VERSION,
        "color": COLOR,
        "strategy": STRATEGY,
        "pod": POD_NAME,
        "timestamp": datetime