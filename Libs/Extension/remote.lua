local ext = libs.extension;

actions.foo = function ()
	ext.queue("browser", "execute", 
		--"document.getElementById('app-player').contentWindow.document.getElementById('play-pause').click()"
		"alert(document.getElementById('app-player').contentWindow.document.getElementById('vol-position').style.left = '100px')"
	);
end