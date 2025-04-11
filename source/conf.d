module promptkit.conf;

import std.stdio;
import std.string;
import std.conv;
import std.file;
import std.path;
import std.json;
import std.typecons: tuple;

alias confFormat = tuple!(
	string[string][], "plugins",
	bool[string], "settings"
);

string[string] loadConf() {
	string confPath;
	string[string] settings;
	version(Windows) {
		// Fix this, windows doesn't support ~'s
		confPath = "~\\AppData\\Local\\promptkit\\config.json";
	}
	else version(Posix) {
		confPath = expandTilde("~/.config/promptkit/config.json");
	}
	if (!(exists(confPath) && isFile(confPath))) {
		throw new Exception("Please create a conf file at ", confPath);
	}
	string JSONStr = readText(confPath);

	auto jsonConfig = parseJSON(JSONStr);

	JSONValue[] plugins = jsonConfig["plugins"].array;
	string[string][] pluginList;

	foreach (plugin; plugins) {
		string[string] currentPlugin;

		foreach(string key, JSONValue value; plugin) {
			currentPlugin[key] = value.str();
		}

		pluginList ~= currentPlugin;
	}

	foreach(string key, JSONValue value; jsonConfig["settings"]) {
		settings[key] = value.str();
	}

	return settings;
}
