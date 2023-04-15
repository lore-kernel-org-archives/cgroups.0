From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.4] BUILD SUCCESS
 9403d9cb564b6a3af86cb18fe722097ed7620f6f
Date: Sat, 15 Apr 2023 14:07:03 +0800
Message-ID: <643a3f07.4bVtaWvJPeNXmlQW%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681538837; x=1713074837;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=78RtRaR1ACDyXc/wxevKJDxKa1sLRcPY6AidZJiXtwk=;
  b=aqsi/J1HC83ycAfIFZa22UV9UqxiP+Lwa7Wt0oL3rXFcDavx5TSirfCm
   +BqUm176BUr9iNO4qujiMTtuOyjdmTt8c1aNYyMu8sL9ayyK+M7wKUb1G
   N2nip94BXIXDugxH8GhzQUBfzUOjEJy/djXP5hKd+UcH3mDZiVxbHOjm0
   3Nxdi3ywjcJzsECnReXZ7AuHj49e44ikMV1ghQ/bl2ToyPoqkZeOZ9CRl
   dRPgzL8YaZXArjcuRxNti/tqFbTtvOeNp0naGZypsj3iibez1l44C2tsg
   dGxRahs811XoLtNeNdFLq/fTzZhjkjdByn+ZSrMXASzfS8uVOcxIJaEHr
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.4
branch HEAD: 9403d9cb564b6a3af86cb18fe722097ed7620f6f  docs: cgroup-v1/cpusets: update libcgroup project link

elapsed time: 723m

configs tested: 95
configs skipped: 8

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r006-20230409   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r011-20230409   gcc  
alpha                randconfig-r016-20230414   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r003-20230409   gcc  
arc          buildonly-randconfig-r003-20230413   gcc  
arc                                 defconfig   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r005-20230413   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r015-20230414   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r016-20230410   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r014-20230410   gcc  
hexagon      buildonly-randconfig-r001-20230409   clang
hexagon              randconfig-r012-20230410   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r006-20230410   clang
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230410   clang
i386                 randconfig-a002-20230410   clang
i386                 randconfig-a003-20230410   clang
i386                 randconfig-a004-20230410   clang
i386                 randconfig-a005-20230410   clang
i386                 randconfig-a006-20230410   clang
i386                 randconfig-a011-20230410   gcc  
i386                 randconfig-a012-20230410   gcc  
i386                 randconfig-a013-20230410   gcc  
i386                 randconfig-a014-20230410   gcc  
i386                 randconfig-a015-20230410   gcc  
i386                 randconfig-a016-20230410   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r013-20230410   gcc  
loongarch            randconfig-r014-20230409   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
microblaze           randconfig-r016-20230409   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r011-20230410   clang
nios2                               defconfig   gcc  
openrisc             randconfig-r011-20230414   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r013-20230414   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r002-20230410   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r014-20230414   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r006-20230413   clang
s390                                defconfig   gcc  
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r001-20230410   gcc  
sh           buildonly-randconfig-r002-20230413   gcc  
sh                   randconfig-r012-20230414   gcc  
sh                   randconfig-r015-20230409   gcc  
sparc        buildonly-randconfig-r004-20230410   gcc  
sparc        buildonly-randconfig-r004-20230413   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r012-20230409   gcc  
sparc64      buildonly-randconfig-r001-20230413   gcc  
sparc64      buildonly-randconfig-r003-20230410   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                        randconfig-a001   clang
x86_64                        randconfig-a003   clang
x86_64                        randconfig-a005   clang
x86_64               randconfig-a011-20230410   gcc  
x86_64               randconfig-a012-20230410   gcc  
x86_64               randconfig-a013-20230410   gcc  
x86_64               randconfig-a014-20230410   gcc  
x86_64               randconfig-a015-20230410   gcc  
x86_64               randconfig-a016-20230410   gcc  
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r004-20230409   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
