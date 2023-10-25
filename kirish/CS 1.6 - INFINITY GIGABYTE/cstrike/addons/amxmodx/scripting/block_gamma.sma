#include <amxmodx>

#define MAXPLAYERS 32

new g_pcvarMaxCount
new g_iCount[MAXPLAYERS+1]

public plugin_init()
{
register_plugin("Anti Gamma", "1.1", "bekzodoff")
g_pcvarMaxCount = register_cvar("max_bad_value", "2")

set_task(0.0, "taskDeveloperCheck", _, _, _, "b")
}

public client_putinserver(id)
{
g_iCount[id] = 0
}

public taskDeveloperCheck()
{
new players[MAXPLAYERS], inum
get_players(players, inum, "ch") //don't collect BOTs & HLTVs
for(new i; i<inum; ++i)
{
query_client_cvar(players[i] , "gamma" , "cvar_result")
}
}

public cvar_result(id, const cvar[], const value[])
{
new Float:fValue = str_to_float(value)

if(!fValue)
return

server_cmd("gamma 3");
client_cmd(id, "gamma 3");

}