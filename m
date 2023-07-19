From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 32bf85c60ca3584a7ba3bef19da2779b73b2e7d6
Date: Thu, 20 Jul 2023 00:18:35 +0800
Message-ID: <202307200034.rW85cJBC-lkp@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689783530; x=1721319530;
  h=date:from:to:cc:subject:message-id;
  bh=6yxjOIwtO3jfh0yErWVwQN+xXOlhvl6guyjwhNIgPS8=;
  b=CZcz1C5zSBu6aXOWQt/68rdVZB7ft5C7edZtxc8BJXkjUks576y6DtTY
   MHO2Wqh/EUL48phyK+UZU7/0f2jBSMMh8QOCx2UUiG0F4nW9dmoWshzGN
   JMItrlMIeub1srPSQF2w8bm8KoqgvETNLd4mvmB52X3RfS0do783LcZyU
   oUYdTXcIuTlz7xaTUtmoWf+D4F3rP45bcuh9oQfj2wA39fVM1UgM9tGWw
   JFqrDbl2vHgykt36fX6fAbITmdLEdBFZa7OzPXiscu67lvWvaYdic5A11
   GSjaQ0R1ck74eKO8sMJhDCGH7ek750viN/Pbf19u8qKreSM8ezv5SBnWa
   Q==;
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 32bf85c60ca3584a7ba3bef19da2779b73b2e7d6  cgroup/misc: Change counters to be explicit 64bit types

elapsed time: 1034m

configs tested: 140
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r023-20230718   gcc  
alpha                randconfig-r035-20230718   gcc  
arc                              allyesconfig   gcc  
arc                          axs101_defconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r034-20230718   gcc  
arc                  randconfig-r035-20230718   gcc  
arc                  randconfig-r043-20230718   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                            mps2_defconfig   gcc  
arm                  randconfig-r026-20230718   gcc  
arm                  randconfig-r032-20230718   clang
arm                  randconfig-r046-20230718   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r011-20230718   clang
arm64                randconfig-r012-20230718   clang
csky                                defconfig   gcc  
hexagon              randconfig-r031-20230718   clang
hexagon              randconfig-r041-20230718   clang
hexagon              randconfig-r045-20230718   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230718   gcc  
i386         buildonly-randconfig-r005-20230718   gcc  
i386         buildonly-randconfig-r006-20230718   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230718   gcc  
i386                 randconfig-i002-20230718   gcc  
i386                 randconfig-i003-20230718   gcc  
i386                 randconfig-i004-20230718   gcc  
i386                 randconfig-i005-20230718   gcc  
i386                 randconfig-i006-20230718   gcc  
i386                 randconfig-i011-20230718   clang
i386                 randconfig-i012-20230718   clang
i386                 randconfig-i013-20230718   clang
i386                 randconfig-i014-20230718   clang
i386                 randconfig-i015-20230718   clang
i386                 randconfig-i016-20230718   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r002-20230718   gcc  
loongarch            randconfig-r003-20230718   gcc  
loongarch            randconfig-r022-20230718   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                       m5249evb_defconfig   gcc  
m68k                          multi_defconfig   gcc  
microblaze           randconfig-r006-20230718   gcc  
microblaze           randconfig-r015-20230718   gcc  
microblaze           randconfig-r036-20230718   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                     cu1000-neo_defconfig   clang
mips                           jazz_defconfig   gcc  
mips                        qi_lb60_defconfig   clang
mips                 randconfig-r013-20230718   gcc  
mips                 randconfig-r033-20230718   clang
mips                 randconfig-r036-20230718   clang
nios2                            alldefconfig   gcc  
nios2                               defconfig   gcc  
openrisc             randconfig-r021-20230718   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r025-20230718   gcc  
parisc               randconfig-r032-20230718   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                      arches_defconfig   gcc  
powerpc                          g5_defconfig   clang
powerpc              randconfig-r014-20230718   clang
powerpc              randconfig-r015-20230718   clang
powerpc              randconfig-r022-20230718   clang
powerpc                     skiroot_defconfig   clang
powerpc                     tqm8540_defconfig   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r001-20230718   gcc  
riscv                randconfig-r013-20230718   clang
riscv                randconfig-r042-20230718   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r014-20230718   clang
s390                 randconfig-r031-20230718   gcc  
s390                 randconfig-r044-20230718   clang
sh                               allmodconfig   gcc  
sh                         microdev_defconfig   gcc  
sh                   randconfig-r011-20230718   gcc  
sh                   randconfig-r024-20230718   gcc  
sh                   randconfig-r034-20230718   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r016-20230718   gcc  
sparc                randconfig-r021-20230718   gcc  
sparc                       sparc32_defconfig   gcc  
sparc64              randconfig-r005-20230718   gcc  
sparc64              randconfig-r012-20230718   gcc  
sparc64              randconfig-r023-20230718   gcc  
sparc64              randconfig-r024-20230718   gcc  
sparc64              randconfig-r025-20230718   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230718   gcc  
x86_64       buildonly-randconfig-r002-20230718   gcc  
x86_64       buildonly-randconfig-r003-20230718   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-x001-20230718   clang
x86_64               randconfig-x002-20230718   clang
x86_64               randconfig-x003-20230718   clang
x86_64               randconfig-x004-20230718   clang
x86_64               randconfig-x005-20230718   clang
x86_64               randconfig-x006-20230718   clang
x86_64               randconfig-x011-20230718   gcc  
x86_64               randconfig-x012-20230718   gcc  
x86_64               randconfig-x013-20230718   gcc  
x86_64               randconfig-x014-20230718   gcc  
x86_64               randconfig-x015-20230718   gcc  
x86_64               randconfig-x016-20230718   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa                              defconfig   gcc  
xtensa               randconfig-r033-20230718   gcc  
xtensa                    smp_lx200_defconfig   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
