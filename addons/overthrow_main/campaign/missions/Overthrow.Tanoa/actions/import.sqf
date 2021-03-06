if (OT_taking) exitWith {};

OT_taking = true;
private _idx = lbCurSel 1500;
private _cls = lbData [1500,_idx];
private _num = _this select 0;
private _price = ["Tanoa",_cls,100] call getPrice;
_total = (_num * _price);
private _veh = (vehicle player);

if((player getVariable ["money",0]) < _total) exitWith {format["You need $%1",[_total, 1, 0, true] call CBA_fnc_formatNumber] call notify_minor;OT_taking = false};
if ((!(_veh isKindOf "Truck_F")) and (!(_veh canAdd [_cls,_num]))) exitWith {hint "This vehicle cannot fit that, use a truck for more storage";OT_taking = false};

_count = 0;


call {
	if(_cls isKindOf ["Rifle",configFile >> "CfgWeapons"]) exitWith {
		_veh addWeaponCargoGlobal [_cls,_num];
	};
	if(_cls isKindOf ["Launcher",configFile >> "CfgWeapons"]) exitWith {
		_veh addWeaponCargoGlobal [_cls,_num];
	};
	if(_cls isKindOf ["Pistol",configFile >> "CfgWeapons"]) exitWith {
		_veh addWeaponCargoGlobal [_cls,_num];
	};
	if(_cls isKindOf ["CA_Magazine",configFile >> "CfgMagazines"]) exitWith {
		_veh addMagazineCargoGlobal [_cls,_num];
	};
	if(_cls isKindOf "Bag_Base") exitWith {
		_veh addBackpackCargoGlobal [_cls,_num];
	};
	_veh addItemCargoGlobal [_cls,_num];
};
[-_total] call money;

OT_taking = false;
