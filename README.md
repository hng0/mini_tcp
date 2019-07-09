# mini_tcp

A mini TCP server implemented in OCaml.

## Write-up

A port of [Implementing a TCP server in C](https://ops.tips/blog/a-tcp-server-in-c/) in OCaml for the purpose of learning OCaml, Jane's Core library, and networking abstractions. The implementation closely matches the one in C. A better, non-blocking approach would be using more idiomatic OCaml patterns and libraries such as Async.

The code is overly documented and has verbose variable names to remind me the concepts when I forget them.

## Learnings

- OCaml effectful code.
- OCaml build tool (dune).
- Core_unix API in Core__.
- High level understanding of socket, socket states, and connection queues.

## Run & Test

To run the TCP server, in terminal 1:

```sh
# build.
$ dune build server.exe
# run.
$ dune exec ./server.exe
```

Open terminal 2 to act as a client:

```sh
# communicate to TCP server using TELNET protocol.
$ telnet 0.0.0.0 8080
```

Terminal 1 should print out client address and port and immediately attempt to close the connection.

```sh
$ dune exec ./server.exe
Client connected @ 127.0.0.1 port 57350
Closing connection...
```
