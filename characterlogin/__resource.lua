dependency 'essentialmode'
ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/cursor.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

server_script {
        'login-server.lua'
}
client_script {
        'login-client.lua'
}
