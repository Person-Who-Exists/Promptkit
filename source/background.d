module promptkit.background;

import std.stdio;
import std.string;
import std.process;
import std.format;
import std.conv;
import std.socket;
import core.thread;
import promptkit.ipc;
import promptkit.conf;
import promptkit.plugin_manager;

void background() {
	bool loop = true;
	ubyte[1024] buffer;

	ConfData config = parseConf();

	string socketPath = format("/tmp/promptkit-%s", environment["PROMPTKIT_SOCKET"]);
	Socket socket = createUDS(socketPath);

	while (loop) {
		Thread.sleep(dur!("msecs")( 100 ));
		auto buffLen = receiveData(socket, buffer);
	}
}

void generate() {

}
