#@ File(label="Select directory", style="directory") directory

import os
import re

# Function to rename files
def rename_plus(old_name):
    match = re.search(r'day(\d{1})_', old_name)
    if match:
        nday = match.group(1)
        new_name = re.sub(r'day(\d{1})_', 'day0{}_'.format(nday), old_name)
        os.rename(old_name, new_name)

# Get the directory from user input
directory = directory.getPath()

# Get the list of files
files = [os.path.join(directory, f) for f in os.listdir(directory) if f.endswith('.jpg')]

# Apply the renaming function to each file
for file in files:
    rename_plus(file)
