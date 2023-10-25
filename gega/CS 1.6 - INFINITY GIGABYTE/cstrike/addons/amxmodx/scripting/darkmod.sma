//====================================================================================================
//=========================================   DARKMOD - CUP  =========================================
//===========================================      by     ============================================
//===========================================  bekzodoff  ============================================
//====================================================================================================

//////////////////////////////////////////////////////////////////////////

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>
#include <cstrike>
#include <hamsandwich>
#include <colorchat>

#define PLUGIN "DARKMOD - CUP"
#define VERSION "4.7"
#define AUTHOR "bekzodoff"

#define MONEYGIVEN  16000

#define m_pNext	42
#define m_fInReload	54

#define m_flNextAttack			83
#define m_rgpPlayerItems_Slot1	368
#define m_rgpPlayerItems_Slot2	369

//////////////////////////////////////////////////////////////////////////

new const DR_TAG[] = "[DARKMOD]";
new cfgdir[128];
new bool:g_bKnifeRound;
new bool:g_bVotingProcess;
new g_iMaxPlayers;
new g_Votes[ 2 ];
new g_pSwapVote;
new g_pSpawnMoney;
new g_pSpawnReload;
new g_pNoslash;


////////////////////////////////////////////////////////////////////////////////////////////
//===========================================================================================
//*************************************   REGISTER   ****************************************
//===========================================================================================
//////////////////////////////////////////////////////////////////////////

public plugin_init() {
	register_plugin( PLUGIN, VERSION, AUTHOR );
	
	get_configsdir(cfgdir,63)
	format(cfgdir,63,"%s/darkmod",cfgdir)
	
	RegisterHam(Ham_Spawn, "player", "Cmd_Spawn_Reload");
	RegisterHam(Ham_Spawn, "player", "Cmd_Spawn_Money", 1 )
	g_iMaxPlayers = get_maxplayers( );
	g_pSwapVote = register_cvar( "dr_swapvote", "1" );   
	g_pSpawnMoney = register_cvar( "dr_spawn_money", "0" );   
	g_pSpawnReload = register_cvar( "dr_spawn_reload", "1" );   
	g_pNoslash = register_cvar( "dr_noslash", "1" );
	
	register_concmd( "game1", "GAME1", ADMIN_BAN, "Game 1" );
	register_concmd( "game2", "GAME2", ADMIN_BAN, "Game 2" );
	register_concmd( "game3", "GAME3", ADMIN_BAN, "Game 3" );
	register_concmd( "knife", "CmdKnifeRound", ADMIN_BAN, "Start Knife Round" );
	register_concmd( "kniferestart", "CmdRestartRound", ADMIN_BAN, "Restart Round" );
	register_concmd( "overtime", "CmdOvertime", ADMIN_BAN, "OVERTIME" );
	register_concmd( "over", "CmdOvertime", ADMIN_BAN, "OVERTIME" );
	register_concmd( "swap", "CmdSwapTeams", ADMIN_BAN, "Swap teams" );
	register_concmd( "shield", "BlockCmds" );
	register_concmd( "cl_rebuy", "BlockCmds" );
	
	register_event( "CurWeapon", "EventCurWeapon", "be", "2!29" );
	register_logevent( "EventRoundEnd", 2, "0=World triggered", "1=Round_Draw", "1=Round_End" );
	register_dictionary( "darkmod.txt" );
	register_menucmd( register_menuid( "\rSwap teams?" ), 1023, "MenuCommand" );
	
}

//////////////////////////////////////////////////////////////////////////
//===========================================================================================
//***********************************   DR_PLUGINS   ****************************************
//===========================================================================================
//////////////////////////////////////////////////////////////////////////

public Cmd_Spawn_Money( id )
{
	if( g_pSpawnMoney && get_pcvar_num( g_pSpawnMoney ) )
	{
		if( is_user_alive( id ) )
			{
			cs_set_user_money( id, 16000 )
			}
	}
}

public Cmd_Spawn_Reload( id )
{
	if( g_pSpawnReload && get_pcvar_num( g_pSpawnReload ) ) 
	{
		if( !is_user_alive(id) && get_pcvar_num( g_pSpawnReload ) )
		{
			return
		}

		set_pdata_float(id, m_flNextAttack, -0.001, 5)
	
		new iWeapon
		for(new i=m_rgpPlayerItems_Slot1; i<=m_rgpPlayerItems_Slot2; i++) 
		{
			iWeapon = get_pdata_cbase(id, i, 5)
			while( pev_valid(iWeapon) )
			{
				set_pdata_int(iWeapon, m_fInReload, 1, 4)
				ExecuteHamB(Ham_Item_PostFrame, iWeapon)
				iWeapon = get_pdata_cbase(iWeapon, m_pNext, 4)
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////
//===========================================================================================
//***********************************   KNIFE ROUND   ***************************************
//===========================================================================================
//////////////////////////////////////////////////////////////////////////

public EventCurWeapon( id ) {
	if( g_bKnifeRound ) engclient_cmd( id, "weapon_knife" );
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public CmdRestartRound( id, level, cid ) {
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;
	
	g_bKnifeRound = false;
	server_cmd( "sv_restartround 1" );
	server_cmd("exec %s/server/server.cfg",cfgdir);
	//set_task( 2.0, "half_live_message" );
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public KnifeRestartRound( id, level, cid ) {
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;
	
	g_bKnifeRound = false;
	server_cmd( "sv_restartround 1" );
	server_cmd("exec %s/knife/knife.cfg",cfgdir);
	set_task( 2.0, "cmd_client" );
	set_task( 2.0, "knife_message" );
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public CmdKnifeRound( id, level, cid ) {    
	if( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;
	
	KnifeRestartRound( id, level, cid );  
	set_task( 2.0, "KnifeRoundStart", id );
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public KnifeRoundStart( ) {
	g_bKnifeRound = true;
	g_bVotingProcess = false;
	
	new players[ 32 ], num;
	get_players( players, num );
	
	for( new i = 0; i < num ; i++ )
	{
		new item = players[ i ];
		EventCurWeapon( item );
	}
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public EventRoundEnd( ) {
	if( g_bKnifeRound && get_pcvar_num( g_pSwapVote ) ) {
		new players[ 32 ], num;
		get_players( players, num, "ae", "TERRORIST" );
		
		if(!num) 
		{
			set_task( 0.0, "ct_win" );
			set_task( 2.5, "vote_ct" );
		}
		else
		{	        	
			set_task( 0.0, "t_win" );  
			set_task( 2.5, "vote_t" );  
		}    
	}
	g_bKnifeRound = false;
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public vote_t( ) {
	for( new i = 1; i <= g_iMaxPlayers; i++ ) {
		if( is_user_alive( i ) && cs_get_user_team( i ) == CS_TEAM_T )
		{
			ShowMenu( i );
		}
	}
	set_task( 2.5, "ShowMenu" );
}

//////////////////////////////////////////////////////////////////////////

public vote_ct( ) {
	for( new i = 1; i <= g_iMaxPlayers; i++ ) {
		if( is_user_alive( i ) && cs_get_user_team( i ) == CS_TEAM_CT )
		{
			ShowMenu( i );
		}
	}
	set_task( 2.5, "ShowMenu" );
}

//////////////////////////////////////////////////////////////////////////

public clear( id ) {
	
	client_cmd(id,"echo DON'T WRITE THIS COMMAND");
	
	return PLUGIN_CONTINUE;
}


public ShowMenu( id ) {
	g_bVotingProcess = true;
	
	if( g_bVotingProcess ) {
	server_cmd( "amx_mapmenu" );
	}
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public BlockCmds( ) {
	if( g_bKnifeRound ) {
		return PLUGIN_HANDLED_MAIN;
	}
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public ct_win()
{
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_WIN_CT", DR_TAG );
	return PLUGIN_CONTINUE;
}

public t_win()
{
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_WIN_T", DR_TAG );
	return PLUGIN_CONTINUE;
}

public knife_message()
{
	set_hudmessage(255, 255, 255, -1.0, 0.28, 0, 1.0, 4.0, 0.8, 0.8, -1)
	show_hudmessage(0,"%L",LANG_PLAYER,"DR_KNIFE")

	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_KNIFE", DR_TAG );
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_KNIFE", DR_TAG );
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_KNIFE", DR_TAG );

	return PLUGIN_CONTINUE;
}


public cmd_client(id){
    client_cmd(id,"vest")
	server_cmd("vest");
}

//////////////////////////////////////////////////////////////////////////
//===========================================================================================
//*************************************   OVERTIME   ****************************************
//===========================================================================================
//////////////////////////////////////////////////////////////////////////

public Overtime( id, level, cid ) {
	if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;
	
	server_cmd( "sv_restartround 1" );
	server_cmd("exec %s/overtime/overtime.cfg",cfgdir)
	set_task( 2.0, "over_message" );
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public CmdOvertime( id,level,cid ) {
	if( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;
	
	Overtime( id, level, cid );
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public over_message()
{
	set_hudmessage(255, 255, 255, -1.0, 0.28, 0, 1.0, 4.0, 0.8, 0.8, -1)
	show_hudmessage(0,"%L",LANG_PLAYER,"DR_OVER")
	
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_OVER", DR_TAG );
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_OVER", DR_TAG );
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_OVER", DR_TAG );
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////
//===========================================================================================
//**************************************   GAME   *******************************************
//===========================================================================================
//////////////////////////////////////////////////////////////////////////

public GAME1( id, level, cid ) {
	if( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;
	
	server_cmd( "sv_restart 1" );
	set_task( 2.0, "half_live_message" );

	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public GAME2( id, level, cid ) {
	if( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;
	
	server_cmd( "sv_restart 2" );
	set_task( 3.0, "half_live_message" );

	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public GAME3( id, level, cid ) {
	if( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;
	
	server_cmd( "sv_restart 3" );
	set_task( 4.0, "half_live_message" );

	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public half_live_message()
{
	set_hudmessage(255, 255, 255, -1.0, 0.28, 0, 1.0, 4.0, 0.8, 0.8, -1)
	show_hudmessage(0,"%L",LANG_PLAYER,"DR_LIVE")

	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_LIVE", DR_TAG );
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_LIVE", DR_TAG );
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_LIVE", DR_TAG );

	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////
//===========================================================================================
//**************************************   SWAP   *******************************************
//===========================================================================================
//////////////////////////////////////////////////////////////////////////

public CmdSwapTeams( id,level,cid ) {
	if( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;
	
	SwapTeams( );
	swap_message( );
	set_task( 2.0, "cmdrestart" );
	
	return PLUGIN_CONTINUE;
}

//////////////////////////////////////////////////////////////////////////

public cmdrestart( ) 
{
	server_cmd( "sv_restartround 1" );
}
	

public SwapTeams( ) {
	for( new i = 1; i <= g_iMaxPlayers; i++ ) {
		if( is_user_connected( i ) )
		{
			switch( cs_get_user_team( i ) )
			{
				case CS_TEAM_T: cs_set_user_team( i, CS_TEAM_CT );			
				case CS_TEAM_CT: cs_set_user_team( i, CS_TEAM_T );
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////

public swap_message()
{
	set_hudmessage(255, 255, 255, -1.0, 0.28, 0, 1.0, 4.0, 0.8, 0.8, -1)
	show_hudmessage(0,"%L",LANG_PLAYER,"DR_SWAP")
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_SWAP", DR_TAG );
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_SWAP", DR_TAG );
	ColorChat( 0, RED, "[DARKMOD] ^x01%L", 0, "DR_MS_SWAP", DR_TAG );
	
	return PLUGIN_CONTINUE;
}