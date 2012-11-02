m = Map('mapupdateauto', 'MapUpdateAuto', translate('Update router status on map'))

s = m:section(TypedSection, 'general', 'General')
s.anonymous = true

p = s:option(Value, 'host_url', 'Host URL',
             translate('URL to the a CouchDB host than running Map. <br/>Ex: http://192.168.1.182:5984/altermap'))
p = s:option(Value, 'nid', 'Node ID')

p = s:option(DummyValue, 'running', 'Service status')
p.template = 'mapupdateauto/status'

return m