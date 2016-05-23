CC = gcc
CFLAGS = -O3 
LDFLAGS= -lm
SERIAL = swater2D
PARALLEL = swater2D-omp
VTK = vtk_export

all: $(SERIAL) $(PARALLEL)

$(SERIAL): $(VTK) 
	$(CC) $(CFLAGS) $(SERIAL).c $(VTK).o -o $@ $(LDFLAGS)	

$(PARALLEL): $(VTK)
	$(CC) $(CFLAGS) $(PARALLEL).c $(VTK).o -o $@ $(LDFLAGS) -fopenmp	

$(VTK): 
	$(CC) $(CFLAGS) -c $(VTK).c  	

test:  $(SERIAL) $(PARALLEL)
	@echo
	@echo "Running:"
	@./$(SERIAL) -s 200 -f serial.vtk
	@./$(PARALLEL) -s 200 -f parallel.vtk 	
	@echo 
	@echo -n "Checking results: "
	@diff -qs serial.vtk parallel.vtk
	@rm -f serial.vtk parallel.vtk

clean:
	rm -f $(SERIAL) $(PARALLEL) *.vtk  *.o


