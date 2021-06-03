from adapt.intent import IntentBuilder
from mycroft import MycroftSkill, intent_handler


class FreeboxMiniPlayerSkill(MycroftSkill):
    def __init__(self):
        MycroftSkill.__init__(self)

    @intent_handler(IntentBuilder().require('FreeboxMiniPlayer'))
    def handle_freebox_mini_player(self, message):
        pass
        # self.speak_dialog('freebox.mini.player')


def create_skill():
    return FreeboxMiniPlayerSkill()

