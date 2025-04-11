module promptkit.plugin_manager;

import std.stdio;
import std.process;
import std.string;
import std.file;
import std.exception;

string pathForPlugin(string pluginName) {
	string path;
	version(Windows) {
		path = ["~\\AppData\\Local\\promptkit\\modules\\", pluginName].join("");
	}
	else {
		path = ["~/.config/promptkit/modules/", pluginName].join("");
	}
	return path;
}

bool plugin_fetch_git(string url, string path) {
	chdir(path);
	try {
		Pid git = spawnProcess(["git", "clone", url]);
		wait(git);
		return true;
	}
	catch(Exception _) {
		return false;
	}
}

bool plugin_update_git(string path) {
	chdir(path);
	try {
		Pid git = spawnProcess(["git", "pull"]);
		wait(git);
		return true;
	}
	catch(Exception _) {
		return false;
	}
}

bool plugin_checkout_git(string path, string head) {
	chdir(path);
	try {
		Pid git = spawnProcess(["git", "checkout", head]);
		wait(git);
		return true;
	}
	catch(Exception _) {
		return false;
	}
}

bool plugin_build(string path) {
	chdir(path);
	try {
		Pid dub = spawnProcess(["dub", "build", "--build=release"]);
		wait(dub);
		return true;
	}
	catch(Exception _) {
		return false;
	}
}
