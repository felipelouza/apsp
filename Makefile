CCLIB=-lsdsl -ldivsufsort -ldivsufsort64 -Wno-comment
VLIB= -g -O0

LIB_DIR = ${HOME}/lib
INC_DIR = ${HOME}/include
MY_CXX_FLAGS= -std=c++11 -Wall -Wextra  -DNDEBUG $(CODE_COVER)
MY_CXX_OPT_FLAGS= -O3 -ffast-math -funroll-loops -m64 -fomit-frame-pointer -D_FILE_OFFSET_BITS=64
MY_CXX=/usr/bin/c++

LFLAGS = -lm -ldl
LIBOBJ = external/malloc_count/malloc_count.o

CXX_FLAGS=$(MY_CXX_FLAGS) $(MY_CXX_OPT_FLAGS) -I$(INC_DIR) -L$(LIB_DIR) $(LIBOBJ) $(LFLAGS)

CLAGS= -DSYMBOLBYTES=1

####
INPUT = dataset/c_elegans_ests_200.fasta
N = 100
T = 10
OUTPUT = 0
####

all: suffix_array_solution_prac new_algorithm

suffix_array_solution_prac: external/suffix_array_solution_prac.cpp
	$(MY_CXX) $(CXX_FLAGS) external/suffix_array_solution_prac.cpp $(CCLIB) -o external/suffix_array_solution_prac  

new_algorithm: new_algorithm.cpp
	$(MY_CXX) $(CXX_FLAGS) new_algorithm.cpp $(CCLIB) -o new_algorithm  

strip: utils/strip.cpp
	$(MY_CXX) utils/strip.cpp -o utils/strip

clean:
	rm external/suffix_array_solution_prac -f
	rm new_algorithm -f
	rm *.bin -f
	rm *.sdsl -f

run: run_suff run_new 

run_suff: 
	external/suffix_array_solution_prac $(INPUT) $(N) $(T) $(OUTPUT)
	
run_new: 
	./new_algorithm $(INPUT) $(N) $(T) $(OUTPUT)

run_strip: 
	utils/strip $(INPUT) $(N)
	
valgrind_new: new_algorithm
	valgrind --tool=memcheck --leak-check=full --track-origins=yes ./new_algorithm $(INPUT) $(N) $(T) $(OUTPUT)

diff:
	ls -lh *.bin
	diff results_suff.bin results_new.bin

