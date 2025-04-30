module promptkit.ipc;

import std.stdio : writeln;
import std.file : remove;
import std.socket : Socket, AddressFamily, SocketType, UnixAddress, SocketShutdown;

Socket udsCreate(string path)
{
	try
	{
		Socket socket = new Socket(AddressFamily.UNIX, SocketType.STREAM);
		socket.bind(new UnixAddress(path));
		return socket;
	}
	catch (Exception error)
	{
		throw new Error("Could not create or bind socket because ", error);
		return null;
	}
}

Socket udsConnect(string path)
{
	try
	{
		Socket socket = new Socket(AddressFamily.UNIX, SocketType.STREAM);
		socket.connect(new UnixAddress(path));
		return socket;
	}
	catch (Exception error)
	{
		throw new Error("Could not connect to socket because ", error);
		return null;
	}
}

void udsDestroy(string path)
{
	try
	{
		Socket socket = new Socket(AddressFamily.UNIX, SocketType.STREAM);
		socket.shutdown(SocketShutdown.BOTH);
		socket.close();
		remove(path);
	}
	catch (Exception error)
	{
		throw new Error("Could not destroy socket because ", error);
		return;
	}
}
