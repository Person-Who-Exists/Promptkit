module promptkit.background;

import std.stdio : writeln;
import std.string;
import std.process : environment;
import std.conv : to;
import std.socket : Socket;
import std.concurrency;
import core.thread;
import promptkit.ipc;
import promptkit.conf;
import promptkit.plugin_manager;

void background()
{
	bool loop = true;
	ubyte[1024] buffer;
	string socketPath;

	//ConfData config = parseConf();
	try
	{
		socketPath = format("/tmp/promptkit-%s", environment["PROMPTKIT_SOCKET"]);
	}
	catch (Exception error)
	{
		writeln("PROMPTKIT_SOCKET environment var doesn't exist... exiting");
		return;
	}

	Socket socket = udsCreate(socketPath);
	scope (exit)
		udsDestroy(socketPath);
	while (loop)
	{
		socket.receive(buffer);
		string command = to!string(buffer);
		switch (command)
		{
			case "generate": {
				break;
			}
			case "reload": {
				break;
			}
			case "exit": {
				return;
			}
			default: {
				break;
			}
		}
	}
}

void generate()
{

}
