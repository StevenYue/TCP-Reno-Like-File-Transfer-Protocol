CC = gcc
CFLAGS = -I/home/courses/cse533/Stevens/unpv13e_solaris2.10/lib/ -g -O2 -D_REENTRANT -Wall -D__EXTENSIONS__
LIBS = /home/courses/cse533/Stevens/unpv13e_solaris2.10/libunp.a -lresolv -lsocket -lnsl -lpthread



CLEANFILES = core core.* *.core *.o temp.* *.out typescript* \
                *.lc *.lh *.bsdi *.sparc *.uw


PROGS = client server

all:    ${PROGS}

get_ifi_info_plus.o: get_ifi_info_plus.c
	${CC} ${CFLAGS} -c get_ifi_info_plus.c

client:    client.o get_ifi_info_plus.o
	${CC} ${CFLAGS} -o client client.o get_ifi_info_plus.o ${LIBS} -lm

server:    server.o get_ifi_info_plus.o
	${CC} ${CFLAGS} -o server server.o get_ifi_info_plus.o ${LIBS}  -lm

server.o: server.c
	${CC} ${CFLAGS} -c server.c

client.o: client.c
	${CC} ${CFLAGS} -c client.c


clean:
	rm -f ${PROGS} ${CLEANFILES}



