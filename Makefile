TOP := spi_master_tb

FILELIST := -i $(CURDIR)/include
FILELIST += $(shell find $(CURDIR)/package/ -type f -name "*.sv")
FILELIST += $(shell find $(CURDIR)/source/ -type f -name "*.sv")
FILELIST += $(shell find $(CURDIR)/testbench/ -type f -name "*.sv")

all:
	@rm -rf build
	@mkdir -p build
	@echo "*" > build/.gitignore
	@cd build && xvlog -sv $(FILELIST)
	@cd build && xelab ${TOP} -debug typical
	@cd build && xsim ${TOP} -runall
