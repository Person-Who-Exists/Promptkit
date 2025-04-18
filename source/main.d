module promptkit.main;

import std.stdio;
import std.string;
import std.conv;
import std.process;
import std.format;
import std.path;
import std.file;

string helpText = "Add help text here or make help generation with argparse";
string[string] initFiles;

void main(string[] args) {
	switch(args[1]) {
		case "help": {
			writeln(helpText);
			break;
		}
		case "init": {
			string thisBin = absolutePath(thisExePath());
			writeln(spawnProcess([thisBin, "background", environment["PROMPTKIT_SOCKET"]]));
			break;
		}
		case "background": {
			import promptkit.background;
			import promptkit.ipc;
			break;
		}
		case "reload": {
			import promptkit.ipc;
			break;
		}
		case "generate": {
			import promptkit.ipc;
			break;
		}
		default: {
			writeln(helpText);
			break;
		}
	}
	return;
}
