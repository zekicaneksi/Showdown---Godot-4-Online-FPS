# Showdown---Godot-4-Online-FPS
A minimal online FPS shooting game made with Godot 4


### Environment Variables

A json file at the root directory of the project named `env.json` must be created. Example;
```
{
	"ADDRESS": "127.0.0.1",
	"PORT": 3000,
}
```

- ADDRESS
	- The address the clients (players) will try to connect to.
- PORT
	- The port the server will listen on and the clients (players) will try to connect to.

### Exporting the Dedicated Server

When exporting, in the `Resources` tab, set `export mode` to `Export as dedicated server`. Then you can run the exported app from the command line `(ie: ./showdown.x86_64)`

If you get a similar error to `ERROR: Can't create` error, it is probably because the port is already in use.

You can see the processes that occupies ports with this in Linux;

```
sudo lsof -i -P -n 
```

To kill a process with process id

```
sudo kill <pid>
```

Also, these errors basically tell you that the server couldn't transfer a package to an user (who is just disconnected most likely). So, such errors can be ignored;

```
# https://github.com/godotengine/godot/issues/70505
ERROR: Condition "peer > 0 && !connected_peers.has(peer)" is true.
ERROR: Condition "!is_inside_tree()" is true. Returning: Transform3D()
ERROR: Parameter "m" is null.
```
