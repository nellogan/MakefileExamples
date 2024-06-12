# Executive Summary:
Makefile examples ranging from fundamental to advanced. Conditional compilation of source files based on system details 
enables makefile to be a portable build tool, e.g., if system is CUDA capable -> use CUDA files or function variants.
Stage1 and onward incorporate automated testing/validation using external tools such as valgrind and compute-sanitizer 
(if installed).  Stage3 is essentially a portable template for using makefiles to automate the testing, building, and 
acceptance of an application or system that in uses multiple: languages, compilers, and testing tools.


# Requirements:
- *nix operating system
- C compiler such as gcc or clang
- GNU Make version 4.3+
- GNU bash (developed with version 5.1.16, but should work with almost any version)


# Optional Requirements:
- Python 3.X
- Valgrind
- Nvcc
- Compute-sanitizer


# Installation Steps:
### 1.  CLONE:
Copy and paste below into terminal and press enter:

    git clone https://github.com/nellogan/MakefileExamples.git


### 2.  BUILD:
To build all stages, copy and paste below into a terminal window:

    make

If 'make fresh-start' is entered, make will remove all generated files and directories.


### 3. EXPERIMENT:
Try changing directories to various Stages, issue make or make <target> and observe results.

    cd Stage0 
    make
    ./bin/MainExecutable
    ...output...
    cd Stage1
    make
    ./bin/MainExecutable
    ...output...
    cd ../Stage2
    make system-test
    ...output...
    ...

Try commenting/uncommenting lines in source files to force errors to see how automated testing reacts.


# Stage Descriptions:
#### Stage0:
    Fundamental -- File structure: bin, build, include, and src. Each object file (rule) is manually typed with a 
    limited amount of variables. Rules are somewhat redundantly written.

#### Stage1:
    Simple -- File structure: bin, build, include, src, and test (where test mimics parent structure). File structure 
    will not change much in further stages. More liberal use of variables. Introduction of make functions such as 
    wildcard, patterns such as globs(*), patterns(%), and automatic variables such as $<. Test directory contains its 
    own makefile that is invoked from Stage1 makefile i.e. recursive make. UnitTestRunner bundles all unit tests as a 
    single executable. Use of a shell conditional if statement under the "test:" target.
    
    Automated testing is introduced. Accomplished by setting the prerequisite of the build target to include the test 
    target, i.e. build: test $(MAIN_EXECUTABLE). This forces the build target to only be completed after all tests are 
    built and returned successfully. If any of the tests fail, makefile will exit: $(MAIN_EXECUTABLE) will not be 
    compiled. 

#### Stage2:
    Intermediate -- A system-test in addition to the UnitTestRunner. Two variables (VALGRIND_INSTALLED and 
    PYTHON3_INSTALLED) defined based if valgrind and python3 are on $PATH. These variables influence how system-test and 
    test submake are built and evaluated. Commandline arguments to /test/system-test/sh will differ depending on 
    VALGRIND_INSTALLED (0 if not installed, 1 if installed). Makefile conditional ifeq used to early exit system-test if 
    PYTHON3_INSTALLED is 0. If VALGRIND_INSTALLED, test results are validated/audited using valgrind with logs saved in 
    /test/valgrind_logs. If an error and/or leak is found by valgrind, a non-zero exit code is emitted. This will 
    trigger an early exit, thus halting compilation.

#### Stage3:
    Advanced -- Variables from main makefile are exported to test makefile. Exact paths of directories rather than 
    starting from a relative file path. Instead of handling all unit tests via a single UnitTestRunner, unit tests are 
    compiled and evaluated individually. This is done through a macro and conditional compilation in test source files. 
    Library files are used. Pattern to handle a different file type that requires a different compiler (.cu CUDA files); 
    therefore, another leak/error checker is used (nvidia compute-sanitizer) on these files. Uses conditionals to
    determine rules, e.g., nvcc not on path -> compile main/tests without CUDA files. Since nvcc/compute-sanitizer are 
    optional (CUDA files), $(MAIN_EXECUTABLE) will compile without these functions if not installed.
    
    Extras: Uses ANSI color codes for fancier SUCCESS/WARNING/ERROR messages. Valgrind does not know how to handle 
    compiled CUDA code, so a suppression file is added in test/util.
    
    Todo: Save make output to log file for record keeping.


# Demo:

Stage3 with nvcc:

https://github.com/nellogan/git-test/assets/104987293/2ec2fe24-421b-4f87-a004-78ec03704478

Stage3 without nvcc:

https://github.com/nellogan/git-test/assets/104987293/92eb4dc0-1bca-4a82-a097-9b6cddba373e

Stage3 valgrind error:

https://github.com/nellogan/git-test/assets/104987293/3525dc3f-6769-48c8-91c0-d34ab1496119

Stage3 compute-sanitizer error:

https://github.com/nellogan/git-test/assets/104987293/6314586a-2922-4d4a-bcb4-4652704f35a9