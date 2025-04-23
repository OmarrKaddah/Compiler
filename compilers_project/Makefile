all:
	bison -d -v ref.y
	flex ref.l
	gcc -o ref.tab.c ref.yy.c -o compiler.exe