private _cls = _this;

private _data = [];
{
	if((_x select 0) == _cls) exitWith {_data = _x};
}foreach(OT_recruitables);

private _primary = _data select 1;
private _tertiary = _data select 2;
private _range = _data select 3;
private _uniform = _data select 4;
private _bino = _data select 5;

private _warehouseWpn = false;
private _warehouseScope = false;
private _warehouseTertiary = false;
private _warehousePistol = false;

//calculate cost
private _cost = floor((["Tanoa","CIV",0] call getPrice) * 1.5);

private _wpn = [_primary] call findWeaponInWarehouse;
if(_wpn == "") then {	
	_possible = [];
	{
		_weapon = [_x] call BIS_fnc_itemType;
		_weaponType = _weapon select 1;
		if(_weaponType == _primary) then {_possible pushback _x};
	}foreach(OT_allWeapons);
	_sorted = [_possible,[],{(cost getvariable [_x,[200]]) select 0},"ASCEND"] call BIS_fnc_SortBy;
	_wpn = _sorted select 0;
	_price =((cost getVariable [_wpn,[200]]) select 0);
	_cost = _cost + _price;
}else{
	_warehouseWpn = true;
};
private _pwpn = ["Pistol"] call findWeaponInWarehouse;
if(_pwpn != "") then {
	_warehousePistol = true;
};

private _scope = [_range] call findScopeInWarehouse;
if(_scope == "") then {	
	_possible = [];
	{
		_name = _x;
		_max = 0;
		_allModes = "true" configClasses ( configFile >> "cfgWeapons" >> _name >> "ItemInfo" >> "OpticsModes" );
		{
			_mode = configName _x;
			_max = _max max getNumber (configFile >> "cfgWeapons" >> _name >> "ItemInfo" >> "OpticsModes" >> _mode >> "distanceZoomMax");			
		}foreach(_allModes);
		if(_max >= _range) then {_possible pushback _name};
	}foreach(OT_allOptics);
	_sorted = [_possible,[],{(cost getvariable [_x,[200]]) select 0},"ASCEND"] call BIS_fnc_SortBy;
	_scope = _sorted select 0;
	if(_scope != "") then {		
		_price = ((cost getVariable [_scope,[200]]) select 0);
		_cost = _cost + _price;
	};
}else{
	_warehouseScope = true;
};

if(_tertiary != "") then {
	_d = warehouse getvariable [_tertiary,[_tertiary,0]];
	_num = _d select 1;
	if(_num == 0) then {
		_price = ((cost getVariable [_tertiary,[1000]]) select 0);
		_cost = _cost + _price;
	}else{
		_warehouseTertiary = true;
	};
};

[_cost,_cls,_wpn,_warehouseWpn,_pwpn,_warehousePistol,_tertiary,_warehouseTertiary,_scope,_warehouseScope,_uniform,_bino]