OBJ=\
deps/obl/oblas_lite.o\
lib/params.o\
lib/chooser.o\
lib/precode.o\
lib/rand.o\
lib/tuple.o\
lib/uvec.o\
lib/nanorq.o

TEST_UTILS=\
t/00util/matgen\
t/00util/repgen\
t/00util/hdpcgen\
t/00util/precond\
t/00util/schedgen\
t/00util/oblperf

CPPFLAGS := -DOBLAS_AVX2 -DALIGNSZ=32
CFLAGS   = -O3 -g -std=c11 -Wall -Iinclude -Ideps/ -fPIC
CFLAGS  += -march=native -funroll-loops -ftree-vectorize -fno-inline -Wno-unused -Wno-sequence-point 

all: libnanorq.a

main: main.o $(OBJ)

t/00util/matgen: t/00util/matgen.o $(OBJ)

t/00util/repgen: t/00util/repgen.o $(OBJ)

t/00util/hdpcgen: t/00util/hdpcgen.o $(OBJ)

t/00util/precond: t/00util/precond.o $(OBJ)

t/00util/schedgen: t/00util/schedgen.o $(OBJ)

t/00util/oblperf: t/00util/oblperf.o $(OBJ)

test: CPPFLAGS=
test: clean $(TEST_UTILS)
	prove -I. -v t/*.t

libnanorq.a:
libnanorq.a: $(OBJ) 
	$(AR) rcs $@ $(OBJ) 

clean:
	$(RM) main *.o *.a *.gperf *.prof t/00util/*.o $(TEST_UTILS) $(OBJ)

indent:
	find -name '*.[h,c]' | xargs clang-format -i

scan:
	scan-build $(MAKE) clean all

gperf: LDLIBS = -lprofiler -ltcmalloc
gperf: clean ./t/00util/schedgen
	CPUPROFILE_FREQUENCY=100000 CPUPROFILE=gperf.prof ./t/00util/schedgen 50000 > /dev/null
	pprof ./t/00util/schedgen gperf.prof --callgrind > callgrind.gperf
	gprof2dot --format=callgrind callgrind.gperf -z main | dot -T svg > gperf.svg

ubsan: CC=clang
ubsan: CFLAGS += -fsanitize=undefined,implicit-conversion
ubsan: LDLIBS += -lubsan
ubsan: clean ./t/00util/schedgen
	./t/00util/schedgen 50000 > /dev/null

