module("luci.controller.mapupdateauto.admin", package.seeall)

function index()
	entry({'admin', 'services', 'mapupdateauto'},
	      alias('admin', 'services', 'mapupdateauto', 'server'),
	      'Map Update')

	entry({'admin', 'services', 'mapupdateauto', 'server'}, cbi('mapupdateauto/server'), 'Server')
end