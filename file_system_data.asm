data_area:
  times 128*0x40 db 0

index_area:
.starting_entry:
  db 0x02           ; entry type of 0x02 for Starting Marker Entry
  times 63 db 0     ; fill the rest of the entry with padded 0's. these are unused/reserved

times 64*0x1E db 0  ; the rest of the index area is just empty 0's

.volume_identifier:
  db 0x01
  times 3 db 0
  db 0h,0h,0h,0h,0h,0h,0x5C,0x21    ; time stamp of 8 bytes (this matches to 25 December 2018)
  db 'Startaste Disk'               ; volume name in UTF-8 (Startaste Disk), null terminated
  times 52-14 db 0
