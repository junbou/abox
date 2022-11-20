module("luci.controller.admin.httpserver", package.seeall)

function index()
	entry({"admin", "services", "httpserver"}, cbi("httpserver"), _("HTTP Server"), 89)
end