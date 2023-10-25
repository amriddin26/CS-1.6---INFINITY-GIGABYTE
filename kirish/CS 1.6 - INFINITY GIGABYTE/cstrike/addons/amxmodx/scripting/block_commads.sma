#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>
#include <cstrike>
#include <hamsandwich>

#define PLUGIN "COMMANDS BLOCKER"
#define VERSION "4.7"
#define AUTHOR "bekzodoff"

public plugin_init() {
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	register_concmd( "dr_double_duck_on", "Cmd_Double_duck", ADMIN_BAN, "Double_duck" );
	register_concmd( "dr_double_duck_off", "Cmd_Block_Double_duck", ADMIN_BAN, "Block_Double_duck" );
	register_concmd( "dr_graph_on", "Cmd_Graph", ADMIN_BAN, "Graph" );
	register_concmd( "dr_graph_off", "Cmd_Block_Graph", ADMIN_BAN, "Block_Graph" );
	register_concmd( "dr_alphamin_on", "Cmd_Alphamin", ADMIN_BAN, "Alphamin" );
	register_concmd( "dr_alphamin_off", "Cmd_Block_Alphamin", ADMIN_BAN, "Block_Alphamin" );
	register_concmd( "dr_brightness_on", "Cmd_Brightness", ADMIN_BAN, "Brightness" );
	register_concmd( "dr_brightness_off", "Cmd_Block_Brightness", ADMIN_BAN, "Block_Brightness" );
	register_concmd( "dr_chooseteam_on", "Cmd_Chooseteam", ADMIN_BAN, "Chooseteam" );
	register_concmd( "dr_chooseteam_off", "Cmd_Block_Chooseteam", ADMIN_BAN, "Block_Chooseteam" );
	register_concmd( "dr_developer_on", "Cmd_Developer", ADMIN_BAN, "Developer" );
	register_concmd( "dr_developer_off", "Cmd_Block_Developer", ADMIN_BAN, "Block_Developer" );
	register_concmd( "dr_fastsprites_on", "Cmd_Fastsprites", ADMIN_BAN, "Fastsprites" );
	register_concmd( "dr_fastsprites_off", "Cmd_Block_Fastsprites", ADMIN_BAN, "Block_Fastsprites" );
	register_concmd( "dr_gamma_on", "Cmd_Gamma", ADMIN_BAN, "Gamma" );
	register_concmd( "dr_gamma_off", "Cmd_Block_Gamma", ADMIN_BAN, "Block_Gamma" );
	register_concmd( "dr_monolights_on", "Cmd_Monolights", ADMIN_BAN, "Monolights" );
	register_concmd( "dr_monolights_off", "Cmd_Block_Monolights", ADMIN_BAN, "Block_Monolights" );
	register_concmd( "dr_net_graph_on", "Cmd_Net_graph", ADMIN_BAN, "Net_graph" );
	register_concmd( "dr_net_graph_off", "Cmd_Block_Net_graph", ADMIN_BAN, "Block_Net_graph" );
	register_concmd( "dr_overbright_on", "Cmd_Overbright", ADMIN_BAN, "Overbright" );
	register_concmd( "dr_overbright_off", "Cmd_Block_Overbright", ADMIN_BAN, "Block_Overbright" );
	register_concmd( "dr_r_speeds_on", "Cmd_R_speeds", ADMIN_BAN, "R_speeds" );
	register_concmd( "dr_r_speeds_off", "Cmd_Block_R_speeds", ADMIN_BAN, "Block_R_speeds" );
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////
public Cmd_Double_duck( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause anti_dd_scroll.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Double_duck( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause anti_dd_scroll.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Graph( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_+graph.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Graph( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_+graph.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Alphamin( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_alphamin.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Alphamin( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_alphamin.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Brightness( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_brightness.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Brightness( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_brightness.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Chooseteam( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_chooseteam.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Chooseteam( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_chooseteam.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Developer( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_developer.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Developer( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_developer.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Fastsprites( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_fastsprites.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Fastsprites( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_fastsprites.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Gamma( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_gamma.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Gamma( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_gamma.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Monolights( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_monolights.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Monolights( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_monolights.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Net_graph( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_net_graph.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Net_graph( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_net_graph.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_Overbright( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_overbright.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_Overbright( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_overbright.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////
public Cmd_R_speeds( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx pause block_r_speeds.amxx" );
	
	return PLUGIN_CONTINUE;
}

public Cmd_Block_R_speeds( id, level, cid )
{
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

	server_cmd( "amxx unpause block_r_speeds.amxx" );
	
	return PLUGIN_CONTINUE;
}
//////////////////////////////////////////////////////////////////////