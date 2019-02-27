{% set file_loc = "/home/grub" %}

{% set append_line = "GRUB_DISABLE_SUB" %}
{% set append_value = "audit=1" %}

{% set awk_line = "GRUB_DEFAULT" %}
{% set awk_value = "TEST" %}

# Modifies a file in a couple ways and creates a backup under the file_loc variable .back


# Create a file for awk to modify to
touch {{ file_loc }}.2:
  cmd.run

# Create a backup of the original File
cp {{ file_loc }} {{ file_loc }}.back:
  cmd.run

# Append to a Line if what you're looking for isn't in the file
if ! grep {{ append_value }} {{ file_loc }}; then sed -i '/{{ append_line }}/s/$/ {{ append_value }}/' {{ file_loc }}; fi:
  cmd.run

# Replace a value in a line into the awk file because you can't overwrite a file with itself using awk
awk -F '=' '{ if($1 == "{{ awk_line }}")sub($2,"{{ awk_value }}"); print }' {{ file_loc }} > {{ file_loc }}.2:
  cmd.run

# mv the awk file into the original file
mv {{ file_loc }}.2 {{ file_loc }}:
  cmd.run
