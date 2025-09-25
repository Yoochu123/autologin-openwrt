module("luci.controller.autologin", package.seeall)

function index()
    entry({"admin", "services", "autologin"}, 
          template("autologin/manager"), 
          "AutoLogin WiFi", 
          10)
end