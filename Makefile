TARGET=procMacros

$(TARGET) : $(TARGET).tab.c $(TARGET).h lex.yy.c
	gcc $(TARGET).tab.c lex.yy.c -o $(TARGET) 

$(TARGET).tab.c $(TARGET).h : $(TARGET).y
	yacc -d $(TARGET).y -o $(TARGET).tab.c 

lex.yy.c : $(TARGET).l
	flex $(TARGET).l
test:
	cat test.txt && ./$(TARGET) < test.txt 
clean : 
	$(RM) $(TARGET) $(TARGET).tab.c $(TARGET).tab.h lex.yy.c
