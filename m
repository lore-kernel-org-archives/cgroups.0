From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.4] BUILD SUCCESS
 4cdb91b0dea7d7f59fa84a13c7753cd434fdedcf
Date: Sat, 18 Mar 2023 19:17:00 +0800
Message-ID: <64159dac.Hz4S7AlCqqe/VrOr%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679138265; x=1710674265;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=dETepRgIK4oa4SUh5PUJG59vWNAMLyVLSvaj1DvQt2s=;
  b=S2lmudpHRuYNaKH2o30UsXWDZRuCCTFEi6jC9qbzW/f4kuWqL+GamToj
   SpSJYYBvyLnYXzsLAXQiC0hgTgUm7R5sBxFKkcvrhO4JVxd+2HgOp/L8+
   eORmwHJHBKowG8LkzlZHvuaSOyOZUcWvmpqr0UqYiZOenPGHJKQSKzMXY
   J6BAjyl07t4ufpd4T8Z47S2EZ3j2Cx1r/EBPzZsYOHSqHMo5vv7f/KAV+
   mxLrk9r/McSI87HIVcs5nXBDf44S0ULQl9DVFjEejqf8r3ypT0ZKYKKN7
   4n/EoCW+kaa4ZqAZlbpaRFpFriTN3I0W1Ph5ATTGP4JHKUHLaPWVzAN+0
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.4
branch HEAD: 4cdb91b0dea7d7f59fa84a13c7753cd434fdedcf  cgroup: bpf: use cgroup_lock()/cgroup_unlock() wrappers

elapsed time: 733m

configs tested: 329
configs skipped: 32

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r001-20230313   gcc  
alpha        buildonly-randconfig-r002-20230313   gcc  
alpha        buildonly-randconfig-r004-20230313   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r002-20230313   gcc  
alpha                randconfig-r016-20230312   gcc  
alpha                randconfig-r021-20230312   gcc  
alpha                randconfig-r034-20230313   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r002-20230313   gcc  
arc          buildonly-randconfig-r004-20230312   gcc  
arc          buildonly-randconfig-r005-20230313   gcc  
arc          buildonly-randconfig-r006-20230313   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r004-20230312   gcc  
arc                  randconfig-r006-20230313   gcc  
arc                  randconfig-r011-20230313   gcc  
arc                  randconfig-r013-20230313   gcc  
arc                  randconfig-r022-20230313   gcc  
arc                  randconfig-r023-20230313   gcc  
arc                  randconfig-r026-20230312   gcc  
arc                  randconfig-r031-20230312   gcc  
arc                  randconfig-r032-20230312   gcc  
arc                  randconfig-r032-20230318   gcc  
arc                  randconfig-r034-20230312   gcc  
arc                  randconfig-r043-20230312   gcc  
arc                  randconfig-r043-20230313   gcc  
arc                  randconfig-r043-20230315   gcc  
arc                  randconfig-r043-20230318   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r001-20230313   gcc  
arm          buildonly-randconfig-r004-20230313   gcc  
arm          buildonly-randconfig-r005-20230313   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r001-20230312   gcc  
arm                  randconfig-r004-20230313   clang
arm                  randconfig-r006-20230313   clang
arm                  randconfig-r024-20230313   gcc  
arm                  randconfig-r025-20230313   gcc  
arm                  randconfig-r026-20230313   gcc  
arm                  randconfig-r035-20230312   gcc  
arm                  randconfig-r046-20230312   clang
arm                  randconfig-r046-20230313   gcc  
arm                  randconfig-r046-20230315   gcc  
arm                           stm32_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r004-20230313   gcc  
arm64        buildonly-randconfig-r006-20230313   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r001-20230312   clang
arm64                randconfig-r002-20230313   gcc  
arm64                randconfig-r004-20230312   clang
arm64                randconfig-r005-20230312   clang
arm64                randconfig-r006-20230312   clang
arm64                randconfig-r011-20230312   gcc  
arm64                randconfig-r012-20230313   clang
arm64                randconfig-r021-20230312   gcc  
arm64                randconfig-r034-20230313   gcc  
csky         buildonly-randconfig-r004-20230312   gcc  
csky         buildonly-randconfig-r005-20230313   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r002-20230312   gcc  
csky                 randconfig-r003-20230312   gcc  
csky                 randconfig-r022-20230313   gcc  
csky                 randconfig-r023-20230312   gcc  
csky                 randconfig-r025-20230313   gcc  
csky                 randconfig-r033-20230313   gcc  
csky                 randconfig-r035-20230312   gcc  
csky                 randconfig-r036-20230312   gcc  
hexagon              randconfig-r001-20230313   clang
hexagon              randconfig-r004-20230312   clang
hexagon              randconfig-r015-20230312   clang
hexagon              randconfig-r016-20230313   clang
hexagon              randconfig-r033-20230312   clang
hexagon              randconfig-r041-20230312   clang
hexagon              randconfig-r041-20230313   clang
hexagon              randconfig-r041-20230315   clang
hexagon              randconfig-r045-20230312   clang
hexagon              randconfig-r045-20230313   clang
hexagon              randconfig-r045-20230315   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r002-20230313   gcc  
i386         buildonly-randconfig-r003-20230313   gcc  
i386         buildonly-randconfig-r006-20230313   gcc  
i386                         debian-10.3-func   gcc  
i386                   debian-10.3-kselftests   gcc  
i386                        debian-10.3-kunit   gcc  
i386                          debian-10.3-kvm   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230313   gcc  
i386                 randconfig-a002-20230313   gcc  
i386                 randconfig-a003-20230313   gcc  
i386                 randconfig-a004-20230313   gcc  
i386                 randconfig-a005-20230313   gcc  
i386                 randconfig-a006-20230313   gcc  
i386                 randconfig-a011-20230313   clang
i386                 randconfig-a012-20230313   clang
i386                 randconfig-a013-20230313   clang
i386                 randconfig-a014-20230313   clang
i386                 randconfig-a015-20230313   clang
i386                 randconfig-a016-20230313   clang
i386                          randconfig-c001   gcc  
i386                 randconfig-r004-20230313   gcc  
i386                 randconfig-r005-20230313   gcc  
i386                 randconfig-r032-20230313   gcc  
i386                 randconfig-r035-20230313   gcc  
ia64                             allmodconfig   gcc  
ia64         buildonly-randconfig-r005-20230312   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r002-20230313   gcc  
ia64                 randconfig-r006-20230313   gcc  
ia64                 randconfig-r011-20230312   gcc  
ia64                 randconfig-r012-20230312   gcc  
ia64                 randconfig-r015-20230315   gcc  
ia64                 randconfig-r016-20230312   gcc  
ia64                 randconfig-r022-20230313   gcc  
ia64                 randconfig-r023-20230313   gcc  
ia64                 randconfig-r025-20230313   gcc  
ia64                 randconfig-r031-20230312   gcc  
ia64                 randconfig-r036-20230318   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r001-20230313   gcc  
loongarch    buildonly-randconfig-r002-20230313   gcc  
loongarch    buildonly-randconfig-r005-20230312   gcc  
loongarch    buildonly-randconfig-r006-20230313   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r004-20230313   gcc  
loongarch            randconfig-r013-20230313   gcc  
loongarch            randconfig-r021-20230312   gcc  
loongarch            randconfig-r022-20230312   gcc  
loongarch            randconfig-r026-20230312   gcc  
loongarch            randconfig-r036-20230313   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r002-20230313   gcc  
m68k         buildonly-randconfig-r004-20230313   gcc  
m68k         buildonly-randconfig-r006-20230313   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r003-20230313   gcc  
m68k                 randconfig-r005-20230312   gcc  
m68k                 randconfig-r011-20230312   gcc  
m68k                 randconfig-r011-20230313   gcc  
m68k                 randconfig-r012-20230312   gcc  
m68k                 randconfig-r014-20230313   gcc  
m68k                 randconfig-r014-20230315   gcc  
m68k                 randconfig-r016-20230313   gcc  
m68k                 randconfig-r031-20230313   gcc  
m68k                 randconfig-r033-20230318   gcc  
m68k                 randconfig-r035-20230318   gcc  
microblaze   buildonly-randconfig-r002-20230312   gcc  
microblaze   buildonly-randconfig-r002-20230313   gcc  
microblaze   buildonly-randconfig-r006-20230312   gcc  
microblaze           randconfig-r001-20230312   gcc  
microblaze           randconfig-r001-20230313   gcc  
microblaze           randconfig-r003-20230312   gcc  
microblaze           randconfig-r005-20230312   gcc  
microblaze           randconfig-r006-20230312   gcc  
microblaze           randconfig-r032-20230312   gcc  
microblaze           randconfig-r034-20230312   gcc  
microblaze           randconfig-r036-20230313   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r002-20230312   gcc  
mips         buildonly-randconfig-r004-20230313   clang
mips         buildonly-randconfig-r006-20230313   clang
mips                     decstation_defconfig   gcc  
mips                 randconfig-r001-20230312   gcc  
mips                 randconfig-r013-20230312   clang
mips                 randconfig-r015-20230313   gcc  
mips                 randconfig-r033-20230312   gcc  
nios2        buildonly-randconfig-r001-20230313   gcc  
nios2        buildonly-randconfig-r003-20230312   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r003-20230313   gcc  
nios2                randconfig-r005-20230312   gcc  
nios2                randconfig-r012-20230313   gcc  
nios2                randconfig-r015-20230313   gcc  
nios2                randconfig-r016-20230313   gcc  
nios2                randconfig-r021-20230313   gcc  
nios2                randconfig-r026-20230312   gcc  
nios2                randconfig-r036-20230312   gcc  
openrisc     buildonly-randconfig-r001-20230312   gcc  
openrisc     buildonly-randconfig-r003-20230312   gcc  
openrisc     buildonly-randconfig-r005-20230313   gcc  
openrisc             randconfig-r012-20230313   gcc  
openrisc             randconfig-r014-20230312   gcc  
openrisc             randconfig-r021-20230313   gcc  
openrisc             randconfig-r031-20230312   gcc  
openrisc             randconfig-r032-20230312   gcc  
openrisc             randconfig-r034-20230313   gcc  
openrisc             randconfig-r036-20230312   gcc  
parisc       buildonly-randconfig-r006-20230312   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r002-20230312   gcc  
parisc               randconfig-r005-20230312   gcc  
parisc               randconfig-r005-20230313   gcc  
parisc               randconfig-r013-20230312   gcc  
parisc               randconfig-r021-20230313   gcc  
parisc               randconfig-r023-20230313   gcc  
parisc               randconfig-r026-20230313   gcc  
parisc               randconfig-r031-20230313   gcc  
parisc               randconfig-r033-20230313   gcc  
parisc               randconfig-r034-20230313   gcc  
parisc               randconfig-r036-20230313   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc      buildonly-randconfig-r001-20230312   gcc  
powerpc      buildonly-randconfig-r005-20230312   gcc  
powerpc      buildonly-randconfig-r006-20230312   gcc  
powerpc              randconfig-c003-20230312   gcc  
powerpc              randconfig-r003-20230313   gcc  
powerpc              randconfig-r012-20230312   gcc  
powerpc              randconfig-r015-20230313   clang
powerpc              randconfig-r026-20230312   gcc  
powerpc              randconfig-r033-20230313   gcc  
powerpc              randconfig-r035-20230313   gcc  
powerpc              randconfig-r036-20230313   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r001-20230312   gcc  
riscv        buildonly-randconfig-r002-20230313   clang
riscv        buildonly-randconfig-r004-20230312   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r002-20230312   clang
riscv                randconfig-r004-20230313   gcc  
riscv                randconfig-r005-20230313   gcc  
riscv                randconfig-r005-20230318   clang
riscv                randconfig-r011-20230313   clang
riscv                randconfig-r012-20230312   gcc  
riscv                randconfig-r014-20230312   gcc  
riscv                randconfig-r024-20230312   gcc  
riscv                randconfig-r031-20230313   gcc  
riscv                randconfig-r042-20230312   gcc  
riscv                randconfig-r042-20230313   clang
riscv                randconfig-r042-20230315   clang
riscv                randconfig-r042-20230318   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390         buildonly-randconfig-r006-20230312   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r001-20230313   gcc  
s390                 randconfig-r013-20230312   gcc  
s390                 randconfig-r013-20230313   clang
s390                 randconfig-r021-20230312   gcc  
s390                 randconfig-r023-20230312   gcc  
s390                 randconfig-r025-20230312   gcc  
s390                 randconfig-r032-20230313   gcc  
s390                 randconfig-r044-20230312   gcc  
s390                 randconfig-r044-20230313   clang
s390                 randconfig-r044-20230315   clang
s390                 randconfig-r044-20230318   gcc  
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r002-20230313   gcc  
sh           buildonly-randconfig-r005-20230312   gcc  
sh           buildonly-randconfig-r006-20230313   gcc  
sh                   randconfig-r015-20230312   gcc  
sh                   randconfig-r023-20230313   gcc  
sh                   randconfig-r024-20230312   gcc  
sh                   randconfig-r024-20230313   gcc  
sh                   randconfig-r035-20230312   gcc  
sh                   sh7770_generic_defconfig   gcc  
sparc        buildonly-randconfig-r003-20230313   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r002-20230313   gcc  
sparc                randconfig-r021-20230312   gcc  
sparc                randconfig-r022-20230312   gcc  
sparc                randconfig-r023-20230312   gcc  
sparc                randconfig-r034-20230312   gcc  
sparc                randconfig-r035-20230313   gcc  
sparc64      buildonly-randconfig-r001-20230312   gcc  
sparc64      buildonly-randconfig-r003-20230312   gcc  
sparc64      buildonly-randconfig-r003-20230313   gcc  
sparc64              randconfig-r001-20230313   gcc  
sparc64              randconfig-r002-20230312   gcc  
sparc64              randconfig-r004-20230312   gcc  
sparc64              randconfig-r004-20230313   gcc  
sparc64              randconfig-r012-20230313   gcc  
sparc64              randconfig-r015-20230312   gcc  
sparc64              randconfig-r021-20230312   gcc  
sparc64              randconfig-r021-20230313   gcc  
sparc64              randconfig-r022-20230312   gcc  
sparc64              randconfig-r024-20230312   gcc  
sparc64              randconfig-r024-20230313   gcc  
sparc64              randconfig-r025-20230313   gcc  
sparc64              randconfig-r026-20230312   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r004-20230313   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230313   gcc  
x86_64               randconfig-a002-20230313   gcc  
x86_64               randconfig-a003-20230313   gcc  
x86_64               randconfig-a004-20230313   gcc  
x86_64               randconfig-a005-20230313   gcc  
x86_64               randconfig-a006-20230313   gcc  
x86_64               randconfig-a011-20230313   clang
x86_64               randconfig-a012-20230313   clang
x86_64               randconfig-a013-20230313   clang
x86_64               randconfig-a014-20230313   clang
x86_64               randconfig-a015-20230313   clang
x86_64               randconfig-a016-20230313   clang
x86_64               randconfig-k001-20230313   clang
x86_64                        randconfig-k001   clang
x86_64               randconfig-r002-20230313   gcc  
x86_64               randconfig-r016-20230313   clang
x86_64               randconfig-r033-20230313   gcc  
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r001-20230312   gcc  
xtensa       buildonly-randconfig-r004-20230312   gcc  
xtensa       buildonly-randconfig-r005-20230312   gcc  
xtensa       buildonly-randconfig-r006-20230312   gcc  
xtensa               randconfig-r001-20230312   gcc  
xtensa               randconfig-r001-20230313   gcc  
xtensa               randconfig-r003-20230312   gcc  
xtensa               randconfig-r015-20230312   gcc  
xtensa               randconfig-r016-20230312   gcc  
xtensa               randconfig-r023-20230312   gcc  
xtensa               randconfig-r032-20230313   gcc  
xtensa               randconfig-r033-20230312   gcc  
xtensa               randconfig-r034-20230312   gcc  
xtensa               randconfig-r034-20230318   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
