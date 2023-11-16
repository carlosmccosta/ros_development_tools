# HW stress test


## CPU

Install:

```
sudo apt install stress
```

Run:

```
stress --cpu $(nproc) --timeout 180
```


## GPU

Install:

```
sudo apt install glmark2
```

Run:

```
glmark2 --annotate --show-all-options --fullscreen
```
