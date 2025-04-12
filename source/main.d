module promptkit.main;

import std.stdio;
import std.string;
import std.conv;
import std.process;

string helpText = "Add help text here or make help generation with argparse";

void main(string[] args) {
	switch(args[1]) {
		case "help": {
			writeln(helpText);
			break;
		}
		case "init": {
			// Run the init script here
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
