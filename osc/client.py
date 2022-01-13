# Python Client
from pythonosc.udp_client import SimpleUDPClient

__client__ = None

def connect(port=57120):
  global __client__
  ip_addr = "127.0.0.1"
  __client__ = SimpleUDPClient(ip_addr, port)

def sine(freq=440, amp=0.1):
  __client__.send_message("/sine", [freq, amp])

def tri(freq=440, amp=0.1):
  __client__.send_message("/tri", [freq, amp])
  
def square(freq=440, amp=0.1):
  __client__.send_message("/square", [freq, amp])
