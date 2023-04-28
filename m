From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:test-merge-for-6.4] BUILD SUCCESS
 08dcf7efef21aece7597a08886b7a505751624a2
Date: Fri, 28 Apr 2023 17:53:20 +0800
Message-ID: <20230428095320.o3w0j%lkp@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682675674; x=1714211674;
  h=date:from:to:cc:subject:message-id;
  bh=v+LWjjC1KkaR3x2n/fvHDnIco+OpPk7tXvpeUOA/yOo=;
  b=P9VS3bFKr8+aXdXRxfaAUfvSbyHxsKZCbY6k125CaRZWHt2lDW61LGwL
   zdOUpALH18/kWlrTufHh5KyBeW67/YlESaTHErYQmVsWz/pOkt0inGQ+a
   8KeIjdIfzSWD2brYy7tdiYYCIdz3kDXBMzRSwuQDWeCr24FjDzvF6w13n
   rNlzkvo9g/it6JTt7C+GBZtTTeU+/i/ECtUdJMphN3YXk1VzNQwJk0e/z
   H7xwSbKL2AqZQsrH8ADl1QnXj+xxGX3wBfulxo63P2mwAaFRGJiW0Foc7
   k9N4Fx1jRsXliSWDrYam5/hcPr7cqFiT/lOBHS0z2ytx03+Cns2MfwkK8
   Q==;
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-for-6.4
branch HEAD: 08dcf7efef21aece7597a08886b7a505751624a2  Merge branch 'for-6.4' into test-merge-for-6.4

elapsed time: 720m

configs tested: 108
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r005-20230427   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r043-20230428   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r001-20230427   gcc  
arm                                 defconfig   gcc  
arm                      footbridge_defconfig   gcc  
arm                  randconfig-r014-20230427   gcc  
arm                  randconfig-r046-20230428   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r005-20230427   gcc  
arm64                randconfig-r015-20230427   clang
csky                                defconfig   gcc  
csky                 randconfig-r001-20230427   gcc  
csky                 randconfig-r022-20230427   gcc  
hexagon      buildonly-randconfig-r004-20230427   clang
hexagon              randconfig-r041-20230428   clang
hexagon              randconfig-r045-20230428   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                          randconfig-a001   gcc  
i386                          randconfig-a002   clang
i386                          randconfig-a003   gcc  
i386                          randconfig-a004   clang
i386                          randconfig-a005   gcc  
i386                          randconfig-a006   clang
i386                          randconfig-a011   clang
i386                          randconfig-a012   gcc  
i386                          randconfig-a013   clang
i386                          randconfig-a014   gcc  
i386                          randconfig-a015   clang
i386                          randconfig-a016   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r021-20230427   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r035-20230427   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r006-20230427   gcc  
m68k                                defconfig   gcc  
m68k                            q40_defconfig   gcc  
m68k                 randconfig-r004-20230427   gcc  
m68k                 randconfig-r012-20230427   gcc  
microblaze           randconfig-r024-20230427   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r032-20230427   clang
nios2                               defconfig   gcc  
nios2                randconfig-r013-20230427   gcc  
nios2                randconfig-r016-20230427   gcc  
openrisc     buildonly-randconfig-r002-20230427   gcc  
openrisc             randconfig-r006-20230427   gcc  
openrisc             randconfig-r033-20230427   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                    amigaone_defconfig   gcc  
powerpc              randconfig-r002-20230427   gcc  
powerpc                      walnut_defconfig   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r011-20230427   clang
riscv                randconfig-r042-20230428   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r025-20230427   clang
s390                 randconfig-r044-20230428   gcc  
sh                               allmodconfig   gcc  
sh                ecovec24-romimage_defconfig   gcc  
sh                         microdev_defconfig   gcc  
sh                            titan_defconfig   gcc  
sparc        buildonly-randconfig-r003-20230427   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r036-20230427   gcc  
sparc64              randconfig-r026-20230427   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                        randconfig-a001   clang
x86_64                        randconfig-a002   gcc  
x86_64                        randconfig-a003   clang
x86_64                        randconfig-a004   gcc  
x86_64                        randconfig-a005   clang
x86_64                        randconfig-a006   gcc  
x86_64                        randconfig-a011   gcc  
x86_64                        randconfig-a012   clang
x86_64                        randconfig-a013   gcc  
x86_64                        randconfig-a014   clang
x86_64                        randconfig-a015   gcc  
x86_64                        randconfig-a016   clang
x86_64                               rhel-8.3   gcc  
xtensa                  nommu_kc705_defconfig   gcc  
xtensa               randconfig-r031-20230427   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
