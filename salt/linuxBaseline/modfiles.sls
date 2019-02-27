{% set file_loc = "/home/grub.back" %}

 sed -i '/GRUB_DISABLE_SUB/s/$/ audit=1/' {{ file_loc }}:
  cmd.run
  
