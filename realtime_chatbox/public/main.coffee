$window = $(window)
$usernameInput = $('.usernameInput')
$messages = $('.messages')
$inputMessage = $('.inputMessage')

$loginPage = $('.login.page')
$chatPage = $('.chat.page')

username = ''
connected = false
typing = false
lastTypingTime = 0
$currentInput = $usernameInput.focus()

FADE_TIME = 150
TYPING_TIMER_LENGTH = 400

socket = io()

$window.keydown (event) ->
  if !(event.ctrlKey || event.metaKey || event.altKey)
    $currentInput.focus()

  if event.which is 13
    if username
      sendMessage()
      socket.emit 'stop typing'
      typing = false
    else
      setUsername()

$loginPage.click () ->
  $currentInput.focus()

$inputMessage.click () ->
  $inputMessage.focus()

$inputMessage.on 'input', () ->
  updateTyping()

updateTyping = () ->
  if connected
     unless typing
       typing = true
       socket.emit 'typing'

  lastTypingTime = (new Date()).getTime()

  setTimeout () ->
    typingTimer = (new Date()).getTime()
    timeDiff = typingTimer - lastTypingTime
    if (timeDiff >= TYPING_TIMER_LENGTH and typing)
      socket.emit('stop typing')
      typing = false
  , TYPING_TIMER_LENGTH

setUsername = () ->
  username = cleanInput $usernameInput.val().trim()

  if username
    $loginPage.fadeOut()
    $chatPage.show()
    $loginPage.off('click')
    $currentInput = $inputMessage.focus()

    socket.emit 'add user', username

cleanInput = (input) =>
  return $('<div/>').text(input).text()

sendMessage = () =>
  message = $inputMessage.val()
  message = cleanInput message
  if message and connected
    $inputMessage.val('')
    addChatMessage({
      username: username,
      message: message
    })
  socket.emit 'new message', message

addChatMessage = (data) ->
  $messages.append $('<li>').text("#{data.username} a écrit #{data.message}")

addChatTyping = (data) ->
  data.typing = true;
  data.message = 'is typing'
  addChatMessage data

socket.on 'new message', (data) =>
  addChatMessage data

socket.on 'login', () =>
  connected = true
  $messages.append $('<li>').text("Bienvenue sur le chat !")

socket.on 'user connect', (username) =>
  $messages.append $('<li>').text("#{username} s'est connecté")

socket.on 'user disconnect', (username) =>
  $messages.append $('<li>').text("#{username} s'est déconnecté")

socket.on 'typing', (data) =>
  addChatTyping data

socket.on 'stop typing', (data) =>
  removeChatTyping data