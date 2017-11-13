`/keys` and `/projects` are volumens that can be mounted on top of local directories, that allows state persistency and simple key sharing with the container.

```
docker run -it -v ~/Drive/recoveryKeys/ssh-keys/:/keys -v ~/Projects:/projects tiagodeoliveira/docker-shell
```
