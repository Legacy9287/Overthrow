private ["_town","_id","_pos","_building","_tracked","_civs","_vehs","_group","_groups","_all","_shopkeeper"];
if (!isServer) exitwith {};


_count = 0;
_town = _this;
_posTown = server getVariable _town;

_shopkeeper = objNULL;



private _groups = [];
{	
	_building = _x;		
	_pos = getpos _building;
	_t = _pos call nearestTown;
	if(_t == _town) then {
		_group = createGroup civilian;	
		_group setBehaviour "CARELESS";
		_groups pushback _group;
		
		_tracked = _building call spawnTemplate;
		_vehs = _tracked select 0;
		[_groups,_vehs] call BIS_fnc_arrayPushStack;
				
		_cashdesk = _pos nearestObject OT_item_ShopRegister;
		_dir = getDir _cashdesk;
		_cashpos = [getpos _cashdesk,1,_dir] call BIS_fnc_relPos;		
		private _start = _building buildingPos 0;
		_shopkeeper = _group createUnit [OT_civType_carDealer, _start, [],0, "NONE"];
		_shopkeeper allowDamage false;
		_shopkeeper disableAI "MOVE";
		_shopkeeper disableAI "AUTOCOMBAT";
		_shopkeeper setVariable ["NOAI",true,false];

		_shopkeeper setDir (_dir-180);			

		_shopkeeper remoteExec ["initCarShopLocal",0,_shopkeeper];
		[_shopkeeper] call initCarDealer;
		_shopkeeper setVariable ["carshop",true,true];
	};
}foreach(nearestObjects [_posTown,OT_carShops, 700]);
		
		
_groups