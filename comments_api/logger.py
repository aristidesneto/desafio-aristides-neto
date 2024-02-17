import logging
import os

from pythonjsonlogger import jsonlogger

logger = logging.getLogger(__name__)
debug_mode = os.getenv('DEBUG_LEVEL', 'INFO')
logger.setLevel(debug_mode)

console_handler = logging.StreamHandler()
console_handler.setLevel(debug_mode)
# console_format = logging.Formatter('%(asctime)s - [%(levelname)s] %(message)s')
console_format = jsonlogger.JsonFormatter(
    '%(asctime)s %(levelname)s %(message)s'
)

console_handler.setFormatter(console_format)

logger.addHandler(console_handler)