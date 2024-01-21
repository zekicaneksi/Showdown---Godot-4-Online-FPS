# Showdown---Godot-4-Online-FPS
A minimal online FPS shooting game made with Godot 4

## The Game

The dedicated server hosts the game. Players open the game, put their names in and join. Players can shoot each other which triggers respawn. There is also a scoreboard that can be opened with the tab key.

### Screenshots

![image](https://github.com/zekicaneksi/Showdown---Godot-4-Online-FPS/assets/59491631/ab0d6598-7260-42f0-abc6-df0393d7161d)

![image](https://github.com/zekicaneksi/Showdown---Godot-4-Online-FPS/assets/59491631/c7747a36-4e17-4af2-969a-5a6a47234e82)

![image](https://github.com/zekicaneksi/Showdown---Godot-4-Online-FPS/assets/59491631/f3352177-7fae-4147-8817-d0ca0ed5235f)

![image](https://github.com/zekicaneksi/Showdown---Godot-4-Online-FPS/assets/59491631/737b98ef-5f6e-4b52-aec1-83f7a10ce11c)

![image](https://github.com/zekicaneksi/Showdown---Godot-4-Online-FPS/assets/59491631/a9a5f9d8-2553-4661-8369-ec78ebb15581)

![image](https://github.com/zekicaneksi/Showdown---Godot-4-Online-FPS/assets/59491631/0276f6ed-ee76-4974-917e-4a1ef121f5fd)


## Environment Variables

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

## Exporting the Dedicated Server

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
