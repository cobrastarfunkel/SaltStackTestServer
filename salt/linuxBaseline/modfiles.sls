{% set file_loc = "/home/grub.back" %}

# Modifies a file in a couple ways and creates a backup under the file_loc variable .bacl


# Create a file for awk to modify to
touch {{ file_loc }}.2:
  cmd.run

# Create a backup of the original File
cp {{ file_loc }} {{ file_loc }}.back:
  cmd.run

# Append to a Line
sed -i '/GRUB_DISABLE_SUB/s/$/ audit=1/' {{ file_loc }}:
  cmd.run

# Replace a value in a line into the awk file because you can't overwrite a file with itself using awk
awk -F '=' '{ if($1 == "GRUB_DEFAULT")sub($2,"TEST"); print }' {{ file_loc }} > {{ file_loc }}.2:
  cmd.run

# mv the new file into the original file
mv {{ file_loc }}.2 {{ file_loc }}:
  cmd.run
