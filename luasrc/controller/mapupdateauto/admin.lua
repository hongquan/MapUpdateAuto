module("luci.controller.mapupdateauto.admin", package.seeall)

function index()
	entry({'admin', 'services', 'mapupdateauto'},
	      alias('admin', 'services', 'mapupdateauto', 'server'),
	      'Map Update')

	entry({'admin', 'services', 'mapupdateauto', 'server'}, cbi('mapupdateauto/server'), 'Server')
	entry({'admin', 'services', 'mapupdateauto', 'service_status'}, call('action_service_status'))
end

function action_service_status()
	local process_name = 'updater.lua'
	local fullpath = '/etc/mapupdateauto/%s' % {process_name}

	local action = luci.http.formvalue('action')
	local actret = nil
	if action == 'start' then
		local r = os.execute(fullpath..'&')
		if r == 0 then
			actret = 'OK'
		else
			actret = 'NOK'
		end
	elseif action == 'stop' then
		os.execute('killall '..process_name)
		actret = 'OK'
	end

	local out = luci.util.exec('ps aux | grep %s' % {process_name})
	if out:find(fullpath, 1, true) then
		stt = 'ON'
	else
		stt = 'OFF'
	end
	luci.http.prepare_content("application/json")

	local response = {status = stt}
	if actret ~= nil then
		response.action = actret
	end
	luci.http.write_json(response)
end