module("module_mapupdateauto", package.seeall)

function get_mapserver_url()
	local cmd = "grep -Eo http://[^\\']+ /etc/config/mapupdateauto"
	local f = io.popen(cmd)
	local txt = f:read('*a')
	f:close()
	return txt:strip()
end

function get_cpu()
	local cmd = 'cat /proc/cpuinfo'
	local f = io.popen(cmd)
	local cpuinfo = f:read('*a')
	f:close()
	local system =
		cpuinfo:match("system type\t+: ([^\n]+)") or
		cpuinfo:match("Processor\t+: ([^\n]+)") or
		cpuinfo:match("model name\t+: ([^\n]+)")
	return system
end

function get_mac_addr()
	local cmd = 'ifconfig | grep eth0 | grep -oE \\([[:xdigit:]]{2}:\\){5}[[:xdigit:]]{2}'
	local f = io.popen(cmd)
	local txt = f:read('*a')
	f:close()
	return txt:strip()
end

function urlencode(str)
	local function __chrenc(chr)
		return string.format(
			"%%%02x", string.byte(chr)
		)
	end

	if type(str) == "string" then
		str = str:gsub(
			"([^a-zA-Z0-9$_%-%.%+!*'(),])",
			__chrenc
		)
	end

	return str
end

---- API ---

function get_new_url(oldurl)
	if not oldurl then
		return oldurl
	end

	local mapserver_url = get_mapserver_url()
	if not mapserver_url then
		return oldurl
	end

	if oldurl:find(mapserver_url, 1 , true) == nil then
		return oldurl
	end

	local query = 'hw='..urlencode(get_cpu()..get_mac_addr())
	if oldurl:find('?') then
		return oldurl..'&'..query
	end
	return oldurl..'?'..query
end
