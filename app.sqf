

// Gun store Robbery

private _robbed = false;
private _coolDown = time - 60;
private _isActive = missionNamespace getVariable ["_isActive", false];
private _getCooldown = missionNamespace getVariable ["_onCooldown", time - 60];
private _i = 15;
private _gunList = ["arifle_CTAR_blk_F", "arifle_AK12U_lush_holo_snds_pointer_F", "sgun_HunterShotgun_01_sawedoff_F", "SMG_05_F", "hgun_P07_khk_Snds_F"];
private _ammoList = ["30Rnd_580x42_Mag_F", "30Rnd_762x39_AK12_Lush_Mag_F", "2Rnd_12Gauge_Slug", "30Rnd_9x21_Mag_SMG_02", "16Rnd_9x21_Mag"];
private _weaponChose = random 4;

if ((time - _getCooldown) < 60) exitWith {
	hint"Recently robbed, come back later";
};
if (missionNamespace getVariable ["_isActive", false]) exitWith {};
missionNamespace setVariable ["_isActive", true];
while { _i>0 } do {
	_i = _i - 1;
	if !(alive player) exitWith {
		hint"You're leaking blood homie, he aint scared of you";
		uiSleep 5;
		hintSilent "";
	};
	if ((player distance civGun)>10) exitWith {
		hint"You ran away homie! You must stay within 10m";
		uiSleep 5;
		hintSilent "";
	};
	if ((weapons player) isEqualTo []) exitWith {
		hint"First time? You dropped your gun holmes! He aint scared of you now!";
		uiSleep 5;
		hintSilent "";
	};
	if (_i isEqualTo 1) exitWith {
		hint"GRAB THE GUN BEFORE THE CASE LOCKS!";
		_robbed = true;
		uiSleep 5;
		hintSilent"";
	};
	uiSleep 1;
	hint format ["Robbery Countdown %1", _i];
	if (_i isEqualTo 14) then {
		player playMove "";
	};
};
if (_robbed isEqualTo true) then {
	private _gun = _gunList select _weaponChose;
	private _ammo = _ammoList select _weaponChose;
	gunStoreRobbery addWeaponCargo [_gun, 1];
	gunStoreRobbery addMagazineCargo [_ammo, 3];
	missionNamespace setVariable ["_onCooldown", time];
	missionNamespace setVariable ["_isActive", false];
	uiSleep 120;
	clearWeaponCargo gunStoreRobbery;
	clearMagazineCargo gunStoreRobbery;
};


// Escort

if (missionNamespace getVariable ["started", false]) exitWith {};
if (missionNamespace getVariable ["onCooldown", false]) exitWith {};
if ((player distance escortStart) > 5) exitWith {};
if (missionNamespace getVariable ["isActive", false]) exitWith {
	hint"There is already an escort happening!";
};
started = true;
private _beginPos = position player;
private _i = 30;
hint"Escort Started! Please wait for the truck to spawn";
while { _i > 0 } do {
	uiSleep 1;
	_i = _i - 1;
	if !(alive player) exitWith {
		hint"You must be alive to start the escort!";
		started = false;
	};
	if ((player distance _beginPos) > 15) exitWith {
		hint"Escort cancelled! You must remain within 15 meters!";
		started = false;
	};
};
if !(started) exitWith {};
if (_i <= 0) then {
	_escort = createVehicle ["B_Truck_01_transport_F", getMarkerPos "truckSpawn", [], 0, "CAN_COLLIDE"];
	_escort setPos (getMarkerPos "truckSpawn");
	_escort setDir 90;
	escortTruck = _escort;
	isActive = true;
	private _weaponChose = random 4;
	private _gunList = ["arifle_CTAR_blk_F", "arifle_AK12U_lush_holo_snds_pointer_F", "sgun_HunterShotgun_01_sawedoff_F", "SMG_05_F", "hgun_P07_khk_Snds_F"];
	private _ammoList = ["30Rnd_580x42_Mag_F", "30Rnd_762x39_AK12_Lush_Mag_F", "2Rnd_12Gauge_Slug", "30Rnd_9x21_Mag_SMG_02", "16Rnd_9x21_Mag"];
	private _gun = _gunList select _weaponChose;
	private _ammo = _ammoList select _weaponChose;
	_escort addWeaponCargo [_gun, 1];
	_escort addMagazineCargo [_ammo, 3];
	_checkPoint1Pos = [3649.776, 13135.313, 0];
	_checkPoint1 = createMarker ["checkPoint1", _checkPoint1Pos];
	_checkPoint1 setMarkerText "Checkpoint 1";
	_checkPoint1 setMarkerType "mil_flag";
	hint "Drive the truck to the first checkpoint then secure it at the checkpoint!";
};
while { (isActive && alive escortTruck) } do {
	systemChat "I first while loop";
	uiSleep 10;
	if (damage escortTruck isEqualTo 1) exitWith {
		hint "The Escort Truck blew up!";
		started = false;
		isActive = false;
	};
	private _redzoneCooldown = missionNamespace getVariable ["redzoneCooldown", 0];
	if ((time - _redzoneCooldown) >= 10) then {
		_truckPos = getPos escortTruck;
		deleteMarker "truckZone";
		_redEllipseMarker = createMarker ["truckZone", _truckPos];
		_redEllipseMarker setMarkerShape "ELLIPSE";
		"truckZone"setMarkerText "Escort Truck Location";
		_redEllipseMarker setMarkerSize [100, 100];
		_redEllipseMarker setMarkerColor "ColorRed";
		_redEllipseMarker setMarkerAlpha 0.7;
		redzoneCooldown = time;
	};
};


