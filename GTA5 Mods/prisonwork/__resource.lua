resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "Prison Jobs"

client_scripts {
	"prisonwork_cl.lua",
	"props_cl.lua"
}
server_scripts {
  "prisonwork_sv.lua",
  "@mysql-async/lib/MySQL.lua"
}