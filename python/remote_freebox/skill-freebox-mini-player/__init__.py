from adapt.intent import IntentBuilder
from mycroft import MycroftSkill, intent_file_handler
from mycroft.util.log import LOG
from subprocess import call
from subprocess import check_output
from re import match
from re import search


class FreeboxMiniPlayerSkill(MycroftSkill):
    def __init__(self):
        MycroftSkill.__init__(self)

    def initialize(self):
        LOG.info('init FreeboxSkill 36')
        self.register_entity_file('tv.entity')
        self.register_entity_file('num.entity')
        self.register_intent_file('tv.standby.intent', self.handle_tv_standby)
        self.register_intent_file('tv.wake.intent', self.handle_tv_wake)
        self.register_intent_file('tv.volume_down.intent', self.handle_tv_volume_down)
        self.register_intent_file('tv.volume_up.intent', self.handle_tv_volume_up)
        self.register_intent_file('tv.change_channel.intent', self.handle_tv_wake)
        FreeboxMiniPlayerApi().initialize(self.settings.get('player_ip'))

    # @intent_file_handler('tv.wake.intent')
    def handle_tv_wake(self, message):
        FreeboxMiniPlayerApi().wake_up()
        # self.speak_dialog('freebox.mini.player')
        return

    # @intent_file_handler('tv.standby.intent')
    def handle_tv_standby(self, message):
        FreeboxMiniPlayerApi().standby()
        # self.speak_dialog('freebox.mini.player')
        return

    # @intent_file_handler('tv.standby.intent')
    def handle_tv_volume_down(self, message):
        FreeboxMiniPlayerApi().volume_down()
        # self.speak_dialog('freebox.mini.player')
        return

    # @intent_file_handler('tv.standby.intent')
    def handle_tv_volume_up(self, message):
        FreeboxMiniPlayerApi().volume_up()
        # self.speak_dialog('freebox.mini.player')
        return

    def handle_tv_change_channel(self, message):
        FreeboxMiniPlayerApi().call_channel(60)
        # self.speak_dialog('freebox.mini.player')
        return

def create_skill():
    return FreeboxMiniPlayerSkill()


class FreeboxMiniPlayerApi:
    connected = False
    ip = None
    call_root = ['irsend', 'SEND_ONCE', 'TV']

    @classmethod
    def initialize(self, ip):
        self.ip = ip
        # self._connect()

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
    def _get_state(self):
        state = "OFF"
        m = search(r'Display Power: state=(?P<state>\w+)', check_output(['adb', 'shell', 'dumpsys', 'power']))

        if m and m.group('state'):
            state = m.group('state')

        return state

    @classmethod
    def wake_up(self):
        self.call_event(['KEY_POWER'])

    @classmethod
    def standby(self):
        self.call_event(['KEY_POWER'])

    @classmethod
    def volume_down(self):
        self.call_event(['KEY_VOLUMEDOWN'])

    @classmethod
    def volume_up(self):
        self.call_event(['KEY_VOLUMEUP'])
