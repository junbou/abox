m = Map("httpserver", translate("HTTP Server"))

vh = m:section(TypedSection, "vhost", translate("Virtual Hosts"), translate("Manage virtual hosts"))
vh.anonymous = true
vh.addremove = true
vh.template = "cbi/tblsection"

o = vh:option(Flag, "enabled", translate("Enabled"))

o = vh:option(Value, "hostname", translate("Host"))

o = vh:option(Value, "target", translate("Target"))

o = vh:option(Value, "httpport", translate("Http Port"))
o.datatype = "port"

o = vh:option(Value, "httpsport", translate("Https Port"))
o.datatype = "port"

return m