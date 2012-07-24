# What is textfight?
textfight is a simple, text-based client/server application that allows fighters
to join and wander around the small world. These fighters can walk around, and,
when they land on the same square, do battle!

# Using textfight

## Start the server
`ruby textfight_server.rb`
This starts the server listening for connections from fighters.

### Debug
Add in a -d flag to the command above to start the server in debug mode.

## Starting the client
`./textfight_client.sh`
This connects to the server, expected to be localhost

## Join a non-localhost server
To connect to another server besides localhost, you can modify textfight_client.sh or simply `telnet servername 3939`
