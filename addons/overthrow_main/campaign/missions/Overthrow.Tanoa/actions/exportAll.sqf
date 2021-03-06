_target = vehicle player;

if(_target == player) exitWith {};

if(count (player nearObjects [OT_portBuilding,30]) == 0) exitWith {};

private _town = player call nearestTown;
_doillegal = false;
if(_town in (server getVariable ["NATOabandoned",[]])) then {
	_doillegal = true;
}else{
	hint format ["Only legal items may be exported while NATO controls %1",_town];
};

"Exporting inventory" call notify_minor;
[5,false] call progressBar;	
sleep 5;
_total = 0;
{
	_count = 0;
	_cls = _x select 0;
	_num = _x select 1;
	if(_doillegal or _cls in (OT_allItems + OT_allBackpacks)) then {
		_costprice = ["Tanoa",_cls,0] call getSellPrice;
		_total = _total + (_costprice * _num);
		call {
			if(_cls isKindOf ["Rifle",configFile >> "CfgWeapons"]) exitWith {
				[_target, _cls, _num] call CBA_fnc_removeWeaponCargoGlobal;
			};
			if(_cls isKindOf ["Launcher",configFile >> "CfgWeapons"]) exitWith {
				[_target, _cls, _num] call CBA_fnc_removeWeaponCargoGlobal;
			};
			if(_cls isKindOf ["Pistol",configFile >> "CfgWeapons"]) exitWith {
				[_target, _cls, _num] call CBA_fnc_removeWeaponCargoGlobal;
			};
			if(_cls isKindOf ["CA_Magazine",configFile >> "CfgMagazines"]) exitWith {
				[_target, _cls, _num] call CBA_fnc_removeMagazineCargoGlobal;
			};
			if(_cls isKindOf "Bag_Base") exitWith {
				[_target, _cls, _num] call CBA_fnc_removeBackpackCargoGlobal;
			};
			if !([_target, _cls, _num] call CBA_fnc_removeItemCargoGlobal) then {
				[_target, _cls, _num] call CBA_fnc_removeWeaponCargoGlobal;
			};			
		};		
	};
}foreach(_target call unitStock);

[_total] call money;