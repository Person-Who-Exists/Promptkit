module promptkit.conf;

import std.stdio;
import std.string;
import std.conv;
import std.file;
import std.path;
import std.json;

struct Plugin {
	string name;
	string source;
	string head;
}

struct PromptComponent {
	string id;
	JSONValue config;
	bool constant;
}

struct ConfData {
	Plugin[] pluginList;
	PromptComponent[] prompt;
	JSONValue settings;
}

ConfData parseConf() {
	Plugin[] pluginList;
	PromptComponent[] prompt;
	string confPath;

	// Blame windows for the next 9 lines
	version(Windows) {
		import std.process :environment;
		import std.format;
		// Screw windows
		string winConfPath = environment.get("%appdata%");
		confPath = format("%s\\promptkit\\config.json", winConfPath);
	}
	else version(Posix) {
		confPath = expandTilde("~/.config/promptkit/config.json");
	}

	if (!(exists(confPath) && isFile(confPath))) {
		throw new Exception("Please create a conf file at ", confPath);
	}

	// Parse config file
	string JSONStr = readText(confPath);
	JSONValue jsonConfig = parseJSON(JSONStr);

	// Populate pluginList with plugin data
	foreach(JSONValue plugin; jsonConfig["plugins"].array) {
		string[string] pluginArrMap;
		foreach(string key; plugin.object.keys) {
			string value = plugin.object[key].str();
			pluginArrMap[key] = value;
		}
		// Replace this with something dynamic
		Plugin thisPlugin;
		thisPlugin.name = pluginArrMap["name"];
		thisPlugin.source = pluginArrMap["source"];
		thisPlugin.head = pluginArrMap["head"];

		pluginList ~= thisPlugin;
	}

	// Populate the prompt with prompt components
	foreach(JSONValue plugin; jsonConfig["prompt"].array) {
		string[string] prompComponentArrMap;
		foreach(string key; plugin.object.keys) {
			string value = plugin.object[key].str();
			prompComponentArrMap[key] = value;
		}
		// Replace this with something dynamic
		PromptComponent thisPromptComponent;
		thisPromptComponent.id = prompComponentArrMap["name"];
		thisPromptComponent.config = prompComponentArrMap["source"];
		thisPromptComponent.constant = to!bool(prompComponentArrMap["head"]);

		prompt ~= thisPromptComponent;
	}

	auto parsedFile = ConfData(pluginList, prompt, jsonConfig["settings"]);

	return parsedFile;
}
