From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.4-fixes] BUILD SUCCESS
 2bd110339288c18823dcace602b63b0d8627e520
Date: Tue, 23 May 2023 21:19:23 +0800
Message-ID: <20230523131923.lAZT6%lkp@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684848017; x=1716384017;
  h=date:from:to:cc:subject:message-id;
  bh=rAf/gEJij118xjixg1LwYld7WLwm98LnGRbv9qQho3U=;
  b=ag8Oz/6OeB7bXkSlfQwTM/KrU+8aUq98/gQjgnw6EaA4avcJIyW1NKrb
   Ui0NOlQiuyyOEm4lFk2z1E608uHApo0hZk/v8IUd60XYEnX7nViZAOS4x
   xYsYMcVQM6QFSxLwIZPS1Xb3xcndgRYi9+HBCaQhepX4f+c/jLuNxZOc3
   Tx6nfqImn3eW0O6wECrGSDFc3BZ6nJv1xUtt1+BPMtQwIMEYdeUC64b4L
   wQ26BWQolV1hU8TanFUjwQFyc8BljHHT3ku0pUymB2dwmQN3clsFKESOD
   FdjXyjfFgOk+BILxy/oOY4Hn5jvwHXwCHZPGmYvpvALndEAkPLTN+X5OI
   g==;
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: INFO setup_repo_specs: /db/releases/20230523172912/lkp-src/repo/*/tj-cgroup
https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.4-fixes
branch HEAD: 2bd110339288c18823dcace602b63b0d8627e520  cgroup: always put cset in cgroup_css_set_put_fork

elapsed time: 724m

configs tested: 180
configs skipped: 18

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r004-20230521   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r003-20230523   gcc  
alpha                randconfig-r006-20230522   gcc  
alpha                randconfig-r006-20230523   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r003-20230521   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r002-20230523   gcc  
arc                  randconfig-r014-20230521   gcc  
arc                  randconfig-r033-20230522   gcc  
arc                  randconfig-r043-20230521   gcc  
arc                  randconfig-r043-20230522   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r004-20230522   gcc  
arm          buildonly-randconfig-r005-20230521   clang
arm                                 defconfig   gcc  
arm                  randconfig-r046-20230521   clang
arm                  randconfig-r046-20230522   gcc  
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r006-20230521   clang
arm64                               defconfig   gcc  
arm64                randconfig-r011-20230522   clang
arm64                randconfig-r033-20230521   clang
arm64                randconfig-r034-20230522   gcc  
csky         buildonly-randconfig-r003-20230522   gcc  
csky         buildonly-randconfig-r004-20230522   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r026-20230521   gcc  
hexagon      buildonly-randconfig-r001-20230521   clang
hexagon              randconfig-r014-20230521   clang
hexagon              randconfig-r015-20230521   clang
hexagon              randconfig-r025-20230522   clang
hexagon              randconfig-r036-20230521   clang
hexagon              randconfig-r041-20230521   clang
hexagon              randconfig-r041-20230522   clang
hexagon              randconfig-r045-20230521   clang
hexagon              randconfig-r045-20230522   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-r003-20230522   gcc  
ia64                             allmodconfig   gcc  
ia64         buildonly-randconfig-r001-20230522   gcc  
ia64         buildonly-randconfig-r005-20230522   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r005-20230522   gcc  
ia64                 randconfig-r013-20230522   gcc  
ia64                 randconfig-r023-20230521   gcc  
ia64                 randconfig-r032-20230521   gcc  
ia64                 randconfig-r035-20230522   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r005-20230522   gcc  
loongarch            randconfig-r022-20230521   gcc  
loongarch            randconfig-r032-20230522   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r005-20230523   gcc  
m68k                 randconfig-r031-20230522   gcc  
microblaze           randconfig-r016-20230521   gcc  
microblaze           randconfig-r024-20230522   gcc  
microblaze           randconfig-r031-20230521   gcc  
microblaze           randconfig-r034-20230521   gcc  
microblaze           randconfig-r035-20230521   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r002-20230522   clang
mips                 randconfig-r016-20230521   clang
nios2        buildonly-randconfig-r003-20230522   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r002-20230523   gcc  
nios2                randconfig-r003-20230523   gcc  
nios2                randconfig-r004-20230522   gcc  
nios2                randconfig-r005-20230521   gcc  
nios2                randconfig-r006-20230521   gcc  
nios2                randconfig-r025-20230521   gcc  
nios2                randconfig-r035-20230522   gcc  
openrisc     buildonly-randconfig-r006-20230522   gcc  
openrisc             randconfig-r002-20230521   gcc  
openrisc             randconfig-r004-20230523   gcc  
openrisc             randconfig-r005-20230523   gcc  
openrisc             randconfig-r014-20230522   gcc  
openrisc             randconfig-r033-20230521   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r003-20230521   gcc  
parisc               randconfig-r004-20230522   gcc  
parisc               randconfig-r036-20230522   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r012-20230522   clang
powerpc              randconfig-r023-20230522   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r006-20230521   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r004-20230521   clang
riscv                randconfig-r013-20230521   gcc  
riscv                randconfig-r013-20230522   clang
riscv                randconfig-r015-20230522   clang
riscv                randconfig-r042-20230521   gcc  
riscv                randconfig-r042-20230522   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r011-20230521   gcc  
s390                 randconfig-r022-20230522   clang
s390                 randconfig-r033-20230522   gcc  
s390                 randconfig-r044-20230521   gcc  
s390                 randconfig-r044-20230522   clang
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r004-20230521   gcc  
sh           buildonly-randconfig-r005-20230522   gcc  
sh                   randconfig-r001-20230522   gcc  
sh                   randconfig-r002-20230522   gcc  
sh                   randconfig-r014-20230522   gcc  
sh                   randconfig-r026-20230522   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r012-20230521   gcc  
sparc                randconfig-r023-20230522   gcc  
sparc64      buildonly-randconfig-r005-20230521   gcc  
sparc64              randconfig-r001-20230521   gcc  
sparc64              randconfig-r006-20230522   gcc  
sparc64              randconfig-r015-20230522   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230522   gcc  
x86_64               randconfig-a002-20230522   gcc  
x86_64               randconfig-a003-20230522   gcc  
x86_64               randconfig-a004-20230522   gcc  
x86_64               randconfig-a005-20230522   gcc  
x86_64               randconfig-a006-20230522   gcc  
x86_64               randconfig-a011-20230522   clang
x86_64               randconfig-a012-20230522   clang
x86_64               randconfig-a013-20230522   clang
x86_64               randconfig-a014-20230522   clang
x86_64               randconfig-a015-20230522   clang
x86_64               randconfig-a016-20230522   clang
x86_64               randconfig-x051-20230522   clang
x86_64               randconfig-x052-20230522   clang
x86_64               randconfig-x053-20230522   clang
x86_64               randconfig-x054-20230522   clang
x86_64               randconfig-x055-20230522   clang
x86_64               randconfig-x056-20230522   clang
x86_64               randconfig-x061-20230522   clang
x86_64               randconfig-x062-20230522   clang
x86_64               randconfig-x063-20230522   clang
x86_64               randconfig-x064-20230522   clang
x86_64               randconfig-x065-20230522   clang
x86_64               randconfig-x066-20230522   clang
x86_64               randconfig-x071-20230522   gcc  
x86_64               randconfig-x072-20230522   gcc  
x86_64               randconfig-x073-20230522   gcc  
x86_64               randconfig-x074-20230522   gcc  
x86_64               randconfig-x075-20230522   gcc  
x86_64               randconfig-x076-20230522   gcc  
x86_64               randconfig-x081-20230522   gcc  
x86_64                        randconfig-x081   gcc  
x86_64               randconfig-x082-20230522   gcc  
x86_64                        randconfig-x082   clang
x86_64               randconfig-x083-20230522   gcc  
x86_64                        randconfig-x083   gcc  
x86_64               randconfig-x084-20230522   gcc  
x86_64                        randconfig-x084   clang
x86_64               randconfig-x085-20230522   gcc  
x86_64                        randconfig-x085   gcc  
x86_64               randconfig-x086-20230522   gcc  
x86_64                        randconfig-x086   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r003-20230522   gcc  
xtensa               randconfig-r013-20230521   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
