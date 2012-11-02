#!/usr/bin/lua

local json = require("luci.json")
local client = require("luci.httpclient")
require("luci.model.uci")

local _app = 'mapupdateauto'
local nid = '5bfc6d2351e67904d9849fbd9e000e9d'
local host_url = 'http://192.168.1.182:5984/altermap'
local uci = luci.model.uci.cursor()

function get_url()
	host_url = uci:get_first(_app, 'general', 'host_url')
	nid = uci:get_first(_app, 'general', 'nid')
	if host_url:sub(-1) == '/' then
		host_url = host_url:sub(1, -2)
	end
	return '%s/%s' % {host_url, nid}
end

function get_node(url)
	local r, e, msg = client.request_to_buffer(url)
	if e == nil then
		return json.decode(r)
	end
	return r, e, msg
end

function update_node(url, data)
	local headers = {}
	headers['Content-Type'] = 'application/json'

	local body = ''

	if type(data) == 'table' then
		body = json.encode(data)
	else
		body = data
	end

	local options = {
		method = 'PUT',
		headers = headers,
		body = json.encode(data)
	}

	local r, e, msg = client.request_to_buffer(url, options)
	if e == nil then
		return json.decode(r)
	elseif e == 201 then
		return json.decode(msg)
	end
	return r, e, msg
end

function sleep(n)
	os.execute("sleep " .. tonumber(n))
end

while true do
	local url = get_url()
	local node = get_node(url)
	node.active = true
	local r = update_node(url, node)
	sleep(2*60)
end
