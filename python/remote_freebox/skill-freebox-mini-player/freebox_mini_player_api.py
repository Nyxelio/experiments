from subprocess import call
from subprocess import check_output
from re import match
from re import search

class FreeboxMiniPlayerApi:
    connected = False
    ip = None
    call_root = ['adb', 'shell', 'input', 'keyevent']

    @classmethod
    def initialize(self, ip):
        self.ip = ip
        self._connect()

    @classmethod
    def _get_key_codes(self, code):
        return map(lambda code: "KEYCODE_{}".format(code), str(code))

    @classmethod
    def call_channel(self, channel):
        keycodes = ['KEYCODE_TV_NUMBER_ENTRY']
        self.call_event(keycodes + self._get_key_codes(channel))

    @classmethod
    def call_event(self, keycodes):
        call(self.call_root + keycodes)

    @classmethod
    def _connect(self):
        if match('.*connected.*', check_output(['adb', 'connect', self.ip])) is not None:
            self.connected = True

    @classmethod
    def _disconnect(self):
        check_output(['adb', 'disconnect', self.ip])

    @classmethod
    def _get_state(self):
        state = "OFF"
        m = search(r'Display Power: state=(?P<state>\w+)', check_output(['adb', 'shell', 'dumpsys', 'power']))

        if m and m.group('state'):
            state = m.group('state')

        return state

    @classmethod
    def wake_up(self):
        if not self.connected:
            self._connect()

        if self._get_state() != 'ON':
            self.call_event(['KEYCODE_WAKEUP'])
            print "Awaking"
        else:
            print 'Already awake'

    @classmethod
    def standby(self):
        if not self.connected:
            self._connect()

        if self._get_state() != 'OFF':
            self.call_event(['KEYCODE_SLEEP'])
            print "Sleeping"

    # adb shell dumpsys power | grep y | xargs -0 test -z && adb shell input key event 26
    # call(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_WAKEUP'])
    # channels = [
    #    ['bfm tv', 15],
    #    ['bfm business', 347],
    #    ['national geographic', 60],
    #    ['nat geo wild', 61]
