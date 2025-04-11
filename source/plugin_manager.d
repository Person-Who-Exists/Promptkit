module promptkit.plugin_manager;

import std.stdio;
import std.process;
import std.string;
import std.file;
import std.exception;
import std.path;

string pathForPlugin(string pluginName) {
	string path;
	version(Windows) {
		import std.process :environment;
		import std.format;
		// Screw windows
		string winConfPath = environment.get("%appdata%");
		confPath = format("%s\\promptkit\\modules\\%s", winConfPath, pluginName);
	}
	else version(Posix) {
		path = expandTilde(format("~/.config/promptkit/modules/%s", pluginName));
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
