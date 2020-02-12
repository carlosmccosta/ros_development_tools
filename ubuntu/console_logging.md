# Save console output

## Install expect for having unbuffer command
```
sudo apt-get install expect
```


## Save log to file (stdout and stderr)
```
unbuffer [command] &> file.log
```


## Save log to file (stdout and stderr) while also viewing the output in the console
```
unbuffer [command] |& tee file.log
```
