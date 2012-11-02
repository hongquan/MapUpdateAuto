module("luci.controller.mapupdateauto.admin", package.seeall)

function index()
	entry({'admin', 'services', 'mapupdateauto'},
	      alias('admin', 'services', 'mapupdateauto', 'server'),
	      'Map Update')

	entry({'admin', 'services', 'mapupdateauto', 'server'}, cbi('mapupdateauto/server'), 'Server')
	entry({'admin', 'services', 'mapupdateauto', 'service_status'}, call('get_service_status'))
end

function get_service_status()
	local process_name = 'updater.lua'
	local fullpath = '/usr/bin/lua /etc/mapupdateauto/%s' % {process_name}
	local out = luci.util.exec('ps aux | grep %s' % {process_name})
	if out:find(fullpath, 1, true) then
		stt = 'ON'
	else
		stt = 'OFF'
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({status = stt})
end