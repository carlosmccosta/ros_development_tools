# HW monitoring


## lm-sensors

Install:

```
sudo apt install lm-sensors
sudo sensors-detect
```

Run:

```
watch -n 1 sensors
```


## s-tui

Install:

```
sudo apt install stress s-tui
```

Run:

```
s-tui
```


## nvidia

```
watch -n 1 nvidia-smi
nvidia-smi --loop-ms=1000 --format=csv --query-gpu=power.draw
nvidia-smi --loop-ms=1000 --format=csv --query-gpu=index,timestamp,power.draw,temperature.gpu,clocks.sm,clocks.mem,clocks.gr,utilization.gpu,utilization.memory,memory.used
```

Also, there is the GUI, with `PowerMizer` and `Thermal settings` tabs:

```
nvidia-settings
```


## cpu-x

Install:

```
sudo apt install cpu-x
```

Run:

```
sudo cpu-x
```


## turbostat (CPU)

Install:

```
sudo apt install linux-tools-common
sudo apt install linux-tools-5.15.0-88-generic
sudo apt install linux-cloud-tools-5.15.0-88-generic
sudo apt install linux-tools-generic
sudo apt install linux-cloud-tools-generic
sudo apt install gawk
sudo snap install ttyplot
```

Run:

```
sudo turbostat
sudo turbostat --Summary --quiet --show Busy%,Avg_MHz,PkgTmp,PkgWatt --interval 1
sudo turbostat --Summary --quiet --show PkgWatt --interval 1 | gawk '{ printf("%.2f\n" , $1); fflush(); }' | ttyplot -s 100 -t "Turbostat - CPU Power (watts)" -u "watts"
```


## powertop

Install:

```
sudo apt install powertop
```

Run:

```
sudo powertop
```


## htop

Install:

```
sudo apt install htop
```

Run:

```
htop
```
