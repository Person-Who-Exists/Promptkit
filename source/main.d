module promptkit.main;

import std.stdio : writeln;
import std.string;
import std.conv : to;
import std.process : spawnProcess, environment;
import std.format;
import std.path;
import std.file;

string helpText = "Add help text here or make help generation with argparse";

void main(string[] args)
{
	switch (args[1])
	{
	case "help":
		{
			writeln(helpText);
			break;
		}
	case "init":
		{
			import promptkit.background;

			background();
			return;
		}
	case "reload":
		{
			import promptkit.ipc;

			break;
		}
	case "generate":
		{
			import promptkit.ipc;

			break;
		}
	case "exit":
		{
			import promptkit.ipc;

			break;
		}
	default:
		{
			writeln(helpText);
			break;
		}
	}
	return;
}
