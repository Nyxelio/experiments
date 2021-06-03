from subprocess import call
from subprocess import check_output
from re import match
from re import search

player_ip = '192.168.1.9'

class FreeboxMiniPlayerApi:
    connected = False
    awake = False

    @classmethod
    def _get_key_codes(klass, code):
        return map(lambda code: "KEYCODE_{}".format(code), str(code))

    @classmethod
    def call_channel(klass, channel):
        root = ['adb', 'shell', 'input', 'keyevent']
        root.append('KEYCODE_TV_NUMBER_ENTRY')
        root.extend(_get_key_codes(channel))
        print root
        call(root)

    @classmethod
    def _connect(klass, ip):
        if match('.*connected.*', check_output(['adb', 'connect', ip])) is not None:
            self.connected = True

    @classmethod
    def _disconnect(klass, ip):
        check_output(['adb', 'disconnect', ip])

    @classmethod
    def _get_state(klass):
        state = "OFF"
        m = search(r'Display Power: state=(?P<state>\w+)', check_output(['adb', 'shell', 'dumpsys', 'power']))

        if m and m.group('state'):
            state = m.group('state')

        return state

    @classmethod
    def wake_up(klass, ip):
        if self.awake:
            return

        if not self.connected:
            self._connect(ip)

        if self._get_state() != 'ON':
            # call(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_WAKEUP'])
            print "Awaking"
        else:
            print 'Already awake'

        self.awake = True

    @classmethod
    def standby(klass, ip):
        if not self.awake:
            return

        if not self.connected:
            self._connect(ip)

        if self._get_state() != 'OFF':
            # call(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_SLEEP'])
            print "Sleeping"

        self.awake = False
    # adb shell dumpsys power | grep y | xargs -0 test -z && adb shell input key event 26
    # call(['adb', 'shell', 'input', 'keyevent', 'KEYCODE_WAKEUP'])
    # channels = [
    #    ['bfm tv', 15],
    #    ['bfm business', 347],
    #    ['national geographic', 60],
    #    ['nat geo wild', 61]
