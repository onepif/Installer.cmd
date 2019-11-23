rem diskpart /s partitioning_gpt.sc
list disk
sel disk N

clean
convert gpt
rem В ряде случаев рекомендую 350. См. http://www.outsidethebox.ms/16231/
create partition primary size=350
format quick fs=ntfs label="Windows RE"
assign letter=T
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
create partition efi size=100
format quick fs=fat32 label="System"
assign letter=S
create partition msr size=128
create partition primary 
format quick fs=ntfs label="Windows"
assign letter=W
list volume
list par
