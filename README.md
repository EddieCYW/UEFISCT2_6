UEFI-SCT
========

1. The branches/sct-next wants to provide one solution to run SCT on Shell2.0
2. The user need to patch 3 files in ShellPkg of EDKII to make the SCT run. The 
   files are provided in the Doc/ShellPkg

Build UEFI Shell
----------------

1. Please replace the 3 files with the new files provided in "ShellPkg Patch" folder.
    *   ShellPkg\Application\Shell\Shell.c  
    *   ShellPkg\Application\Shell\ShellProtocol.c  
    *   ShellPkg\Application\Shell\ShellProtocol.h
2. Execute "edksetup.bat"
3. Execute "build -p ShellPkg\ShellPkg.dsc -a X64 -t VS2008x86"
4. The shell.efi will be generated and located at C:WorkSpace\Build\Shell\DEBUG_VS2008x86\X64

How to accelerate SCT execution
-------------------------------

Some tips to accelerate SCT execution:

*   Always execute SCT on HDD, SSD is preferred.
*   Execute the SCT on platform release build image if it is possible.
*   Tuning the platform boot performance. Many reboot may occurc in the SCT execution.
*   "-v" parameter could accelerate the execution about 70-80%, "sct -a -v".

Expect the tips could help you. If you have other experience on acceleration, please feel free to contact eric.jin@intel.com

Build of the UEFI Self Certification Tests for X64
--------------------------------------------------

Please refer to the "How to build SCT in UDK2014.txt" for build instructions.

Build of the UEFI Self Certification Tests for ARM or AARCH64 architecture on Linux
-----------------------------------------------------------------------------------

*   The present UEFI-SCT repository has to be located in the root directory
    of the edk2 repository to test and named SctPkg. The absolute path to the
    edk2 root directory is referred to as <absolute-path-to-edk2> in the following.

*   Issue the following commands at a shell prompt :

        chmod a+x <absolute-path-to-edk2>/SctPkg/build.sh
        chmod a+x <absolute-path-to-edk2>/SctPkg/CommonGenFramework.sh
        <absolute-path-to-edk2>/SctPkg/build.sh <ARCH> <TOOLCHAIN>

    ARCH selects the targeted architecture. It can be either ARM (32 bits) or AARCH64 (64 bits).
    TOOLCHAIN defines the tool chain used to build. It can be RVCTLINUX, GCC46, GCC47, GCC48 or GCC49
    depending on the tool chain available on your machine.

    In the case of RVCTLINUX, the path to the tool chain binaries is defined by the environment
    variable 'RVCT_TOOLS_PATH'.

    In the case of the GCC tool chains provided by Linaro, the path and the prefix of the binaries
    are defined by the environment variable `<TOOLCHAIN>_<ARCH>_PREFIX`. For example, suppose you
    are using a version 4.8 of Linaro tool chain for AARCH64 architecture which binaries are prefixed
    with 'aarch64-none-elf-' and are stored in `/work/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux/bin/`
    directory. Then to build the tests for AARCH64 architecture, the environment variable
    `GCC48_AARCH64_PREFIX` has to be defined as :

    `export GCC48_AARCH64_PREFIX=/work/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux/bin/aarch64-none-elf-`


Note: To build with ARM RealView Compiler on MS Windows execute RVCT31.bat
