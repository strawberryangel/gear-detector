string EVIL_NAME = "Progeny";
integer LISTEN_CHANNEL = 7;

list silence = [];

string DiabolicNestis = "d48c3923-d8a6-479d-8519-0df97c4b9893"; 

list whitelist= [
	"147cab2d-c421-4afe-bfd2-c7d4ecc6f4a6",
	"62847a5b-59d6-4426-aa31-cef130478247",
	"71a133aa-4ac8-498f-8137-06b6df9103df",
	DiabolicNestis
		];

integer detectProgeny(key avatar)
{
	if(avatar == llGetOwner()) return FALSE;
	if(llListFindList(whitelist, [(string)avatar]) >= 0) return FALSE;
	if(llListFindList(silence, [avatar]) >= 0) return FALSE;

	list AttachedNames;
	list AttachedUUIDs = llGetAttachedList(avatar);

	integer count = llGetListLength(AttachedUUIDs);
	integer i = count;
	while (i-- > 0)
	{
		key uuid = llList2Key(AttachedUUIDs,i);
		list temp = llGetObjectDetails(uuid, [OBJECT_NAME]);
		string name = llList2String(temp,0);

		if(llSubStringIndex(name, EVIL_NAME) >= 0)
			return TRUE;
	}

	return FALSE;
}

alert(key avatar)
{
	string username = llGetUsername(avatar);
	string display = llGetDisplayName(avatar);
	llOwnerSay("Abunai: " + display + " (" + username + ") " + (string)avatar);
}

scan()
{
	list avatarList = llGetAgentList(AGENT_LIST_REGION, []);
	integer count = llGetListLength(avatarList);
	while(count-- > 0)
	{
		key avatar = llList2Key(avatarList, count);
		if(detectProgeny(avatar)) alert(avatar);
	}
}

restartScan()
{
	llSetTimerEvent(20);
}


default
{
	listen(integer channel, string name, key id, string message)
	{
		message = llStringTrim(message, STRING_TRIM);
		list values = llParseStringKeepNulls(message, [" "], []);
		if(llGetListLength(values) < 2) return;
		string command = llList2String(values, 0);
		key agent = llList2Key(values, 1);
		if(agent == NULL_KEY) return;

		if(command == "add") silence += agent;
		if(command == "reset") silence = [];
	}
	state_entry()
	{
		llListen(LISTEN_CHANNEL, "", llGetOwner(), "");
		restartScan();
	}
	timer()
	{
		scan();
		}
	touch_start(integer total_number)
	{
		scan();
	}
}
