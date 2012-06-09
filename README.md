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
