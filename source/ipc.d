module promptkit.ipc;

import std.socket;
import std.stdio;
import std.string;
import std.conv;
import std.algorithm.comparison;
import std.exception;
import std.file;

// Creates a Unix domain socket.
Socket createUDS(string pathname) {
	Socket socket = new Socket(AddressFamily.UNIX, SocketType.STREAM);
	try {
		socket.bind(new UnixAddress(pathname));
	}
	catch (Exception error) {
		stderr.writef("Socket bind failed: %s\n", error.msg);
		socket.close();
		return null;
	}
	return socket;
}

// Connects to a Unix domain socket.
bool connectToUDS(Socket socket, string pathname) {
	try {
		socket.connect(new UnixAddress(pathname));
	}
	catch (Exception error) {
		stderr.writef("Socket connect failed: %s\n", error.msg);
		return false;
	}
	return true;
}

// Listens for connections on a Unix domain socket.
bool listenOnUDS(Socket socket, int backlog) {
	try {
		socket.listen(backlog);
	}
	catch (Exception error) {
		stderr.writef("Socket listen failed: %s\n", error.msg);
		return false;
	}
	return true;
}

// Accepts a connection on a Unix domain socket.
Socket acceptUDSConnection(Socket socket) {
	try {
		return socket.accept();
	}
	catch (Exception error) {
		stderr.writef("Socket accept failed: %s\n", error.msg);
		return null;
	}
}

// Sends data over a Unix domain socket.
ssize_t sendData(Socket socket, const(ubyte)[] data) {
	try {
		return socket.send(data);
	}
	catch (Exception error) {
		stderr.writef("Socket send failed: %s\n", error.msg);
		return -1;
	}
}

// Receives data from a Unix domain socket.
ssize_t receiveData(Socket socket, ubyte[] buffer) {
	try {
		return socket.receive(buffer);
	}
	catch (Exception error) {
		stderr.writef("Socket receive failed: %s\n", error.msg);
		return -1;
	}
}

// Closes a Unix domain socket.  Also unlinks the path.
int closeUDS(Socket socket, string pathname) {
	socket.close();
	try {
		// Only unlink if a pathname was provided and the unlinking succeeds.
		if (!pathname.empty) {
			remove(pathname); // Use std.file.remove
		}
	}
	catch (Exception error) {
		stderr.writef("Unlink failed: %s\n", error.msg);
		return -1;
	}
	return 0;
}

// Sets the socket to non-blocking mode.
bool setSocketNonBlocking(Socket socket) {
	try {
		socket.blocking = false;
	}
	catch (Exception error) {
		stderr.writef("Set non-blocking failed: %s\n", error.msg);
		return false;
	}
	return true;
}
