open Core

let () =
  let open Core__.Core_unix in
  (* Background:
   * - A file descriptor is an abstraction to access and manipulate input/output.
   * - A socket is an abstraction that allows interaction between
   * application layer (HTTP...) and transport layer (TCP...).
   *
   * Explaination:
   * Create a socket for our server using IPv4 protocol and SOCK_STREAM comm semantics.
   *)
  let file_descriptor = socket ~domain:PF_INET ~kind:SOCK_STREAM ~protocol:0 in
  if File_descr.to_int file_descriptor = -1
  then failwith "Failed to create socket.";
  (* Bind the socket to an address and a port. *)
  let socket_addr = ADDR_INET (Inet_addr.of_string "0.0.0.0", 8080) in
  bind file_descriptor ~addr:socket_addr;
  (* Background:
   * - By default, newly created socket is used for active connection by clients
   * that send out request.
   * - Backlog size is the size of the incomplete connection queue.
   *
   * Explanation:
   * Make socket passive to receive requests.
   *)
  listen file_descriptor ~backlog:5;
  let rec loop () =
    (* Background:
     * As connections come to the tcp server, they are queued up in 2 queues.
     * - Incomplete connection queue: contains connections have not finished 3-way handshake (SYN, SYN/ACK, ACK).
     * - Complete connection queue: contains connections have finished 3-way handshake.
     *
     * Explanation:
     * This loop dequeues a connection from the complete connection queue via
     * #accept call, then close it via #close.
     *)
    let (curr_file_descriptor, client_addr) = accept file_descriptor in
    match client_addr with
    | ADDR_UNIX s ->
      printf "Client connected @ %s\n" s;
      print_endline "Closing connection...";
    | ADDR_INET (addr, port) ->
      let addr = Inet_addr.to_string addr in
      printf "Client connected @ %s port %d\n" addr port;
      print_endline "Closing connection...";
    close curr_file_descriptor;
    loop ()
  in
  loop ()
;;
