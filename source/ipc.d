module promptkit.ipc;

import std.socket;
import std.stdio;
import std.string;
import std.conv;
import std.algorithm.comparison;
import std.exception;
import std.file;

// Creates a Unix domain socket.
Socket createUnixDomainSocket(string pathname) {
	Socket socket = new Socket(AddressFamily.UNIX, SocketType.STREAM);
	try {
		socket.bind(new UnixAddress(pathname));
	}
	catch (Exception e) {
		stderr.writef("Socket bind failed: %s\n", e.msg);
		socket.close();
		return null;
	}
	return socket;
}

// Connects to a Unix domain socket.
bool connectToUnixDomainSocket(Socket socket, string pathname) {
	try {
		socket.connect(new UnixAddress(pathname));
	}
	catch (Exception e) {
		stderr.writef("Socket connect failed: %s\n", e.msg);
		return false;
	}
	return true;
}

// Listens for connections on a Unix domain socket.
bool listenOnUnixDomainSocket(Socket socket, int backlog) {
	try {
		socket.listen(backlog);
	}
	catch (Exception e) {
		stderr.writef("Socket listen failed: %s\n", e.msg);
		return false;
	}
	return true;
}

// Accepts a connection on a Unix domain socket.
Socket acceptUnixDomainSocketConnection(Socket socket) {
	try {
		return socket.accept();
	}
	catch (Exception e) {
		stderr.writef("Socket accept failed: %s\n", e.msg);
		return null;
	}
}

// Sends data over a Unix domain socket.
ssize_t sendData(Socket socket, const(ubyte)[] data) {
	try {
		return socket.send(data);
	}
	catch (Exception e) {
		stderr.writef("Socket send failed: %s\n", e.msg);
		return -1;
	}
}

// Receives data from a Unix domain socket.
ssize_t receiveData(Socket socket, ubyte[] buffer) {
	try {
		return socket.receive(buffer);
	}
	catch (Exception e) {
		stderr.writef("Socket receive failed: %s\n", e.msg);
		return -1;
	}
}

// Closes a Unix domain socket.  Also unlinks the path.
int closeUnixDomainSocket(Socket socket, string pathname) {
	socket.close();
	try {
		// Only unlink if a pathname was provided and the unlinking succeeds.
		if (!pathname.empty) {
			remove(pathname); // Use std.file.remove
		}
	}
	catch (Exception e) {
		stderr.writef("Unlink failed: %s\n", e.msg);
		return -1;
	}
	return 0;
}

// Sets the socket to non-blocking mode.
bool setSocketNonBlocking(Socket socket) {
	try {
		socket.blocking = false;
	}
	catch (Exception e) {
		stderr.writef("Set non-blocking failed: %s\n", e.msg);
		return false;
	}
	return true;
}
