# Generation of requirements.txt

```
pip3 install pipreqs
cd [library_folder]
pipreqs .
```


# Compilation

```
cd [library_folder]
python setup.py bdist_wheel
pip3 install --force-reinstall --upgrade dist/[wheel_file_name].whl
```
