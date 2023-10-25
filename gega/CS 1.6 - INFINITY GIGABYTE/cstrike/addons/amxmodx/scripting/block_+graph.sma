#include <amxmodx>

#define MAXPLAYERS 32

new max_reset
new count[MAXPLAYERS+1]

public plugin_init() {
register_plugin("Check fps", "1.0", "connor")
max_reset = register_cvar("max_bad_value", "5")
}

public plugin_cfg() {
set_task(0.0, "graph_check", _, _, _, "b")
}

public client_connect(id) {
count[id] = 0
}

public client_disconnect(id) {
count[id] = 0
}

public graph_check() {
new players[MAXPLAYERS], inum
get_players(players, inum, "ch") //don't collect BOTs & HLTVs
for(new i; i<inum; ++i)
{
query_client_cvar(players[i] , "+graph" , "cvar_result")
query_client_cvar(players[i] , "+graph" , "cvar_result")
}
}

public cvar_result(id, const cvar[], const value[])
{
if(equal(value, "Bad CVAR request"))
{
client_cmd(id, "-graph")
server_cmd("-graph")
}

new iValue = str_to_num(value)
if(equal(cvar,"+graph"))
{

if(iValue)
{
client_cmd(id, "-graph")
server_cmd("-graph")
count[id]++
}
}
else if(equal(cvar,"+graph"))
{
if(iValue)
{
//developer is higher than 0
client_cmd(id, "-graph")
server_cmd("-graph")
count[id]++
}
}

if(count[id] == get_pcvar_num(max_reset))
client_cmd(id, "-graph")
server_cmd("-graph")
}