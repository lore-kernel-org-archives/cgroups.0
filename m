From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.5] BUILD SUCCESS
 c33080cdc0cab7e72c5e4841cb7533d18a3130dc
Date: Wed, 24 May 2023 01:24:47 +0800
Message-ID: <20230523172447.HhJJl%lkp@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684862755; x=1716398755;
  h=date:from:to:cc:subject:message-id;
  bh=yN+4wb+6uv2gHIF8/GMt4Zb4yVN4RzVDTqQ5TC9IioE=;
  b=YVOZ3PChzAmBanTaHXocYfb8FB8MKW4eUWkHM7QC0oQCBuKCkgtNeMny
   fkcYTY3G8ZbPvScvzcChy8FmOj9A/esAK6gxMcyYDz7697bQBjGxgy59A
   wY/hXq15oJ1IYz2zJVmJv3pJStcMK1/EO9fctzC+fprn69euF/Zwh0Lts
   Wm74jVVgGZzg7vRvBJrVa3Vsadhq2bE/4Bil948JDte6oDNxuxc+GlbYp
   4WNtAdC8SzZG4C3s1q9JFKhtreiPeRIHI7Ag3J0NcPuZEEnkK0QSu+tey
   sNvri3jA01+9Bq4S5EYYcmteapIobAG+oHt6K913p1il15c6xO1HWcJs9
   A==;
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: INFO setup_repo_specs: /db/releases/20230524001904/lkp-src/repo/*/tj-cgroup
https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.5
branch HEAD: c33080cdc0cab7e72c5e4841cb7533d18a3130dc  cgroup: Replace all non-returning strlcpy with strscpy

elapsed time: 1320m

configs tested: 212
configs skipped: 16

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r002-20230522   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r001-20230522   gcc  
alpha                randconfig-r022-20230521   gcc  
alpha                randconfig-r024-20230521   gcc  
alpha                randconfig-r025-20230521   gcc  
alpha                randconfig-r026-20230522   gcc  
alpha                randconfig-r033-20230522   gcc  
arc                              allyesconfig   gcc  
arc          buildonly-randconfig-r001-20230522   gcc  
arc          buildonly-randconfig-r003-20230522   gcc  
arc          buildonly-randconfig-r004-20230521   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r003-20230522   gcc  
arc                  randconfig-r013-20230521   gcc  
arc                  randconfig-r014-20230521   gcc  
arc                  randconfig-r016-20230522   gcc  
arc                  randconfig-r023-20230521   gcc  
arc                  randconfig-r023-20230522   gcc  
arc                  randconfig-r034-20230522   gcc  
arc                  randconfig-r035-20230521   gcc  
arc                  randconfig-r036-20230521   gcc  
arc                  randconfig-r043-20230521   gcc  
arc                  randconfig-r043-20230522   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r003-20230521   gcc  
arm                  randconfig-r031-20230521   gcc  
arm                  randconfig-r046-20230522   gcc  
arm                       spear13xx_defconfig   clang
arm64                            allyesconfig   gcc  
arm64        buildonly-randconfig-r006-20230522   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r005-20230522   gcc  
csky         buildonly-randconfig-r004-20230521   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r005-20230522   gcc  
csky                 randconfig-r011-20230522   gcc  
csky                 randconfig-r015-20230521   gcc  
hexagon              randconfig-r024-20230521   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230522   gcc  
i386                 randconfig-a002-20230522   gcc  
i386                 randconfig-a003-20230522   gcc  
i386                 randconfig-a004-20230522   gcc  
i386                 randconfig-a005-20230522   gcc  
i386                 randconfig-a006-20230522   gcc  
i386                 randconfig-i051-20230523   clang
i386                 randconfig-i052-20230523   clang
i386                 randconfig-i053-20230523   clang
i386                 randconfig-i054-20230523   clang
i386                 randconfig-i055-20230523   clang
i386                 randconfig-i056-20230523   clang
i386                 randconfig-i061-20230523   clang
i386                 randconfig-i062-20230523   clang
i386                 randconfig-i063-20230523   clang
i386                 randconfig-i064-20230523   clang
i386                 randconfig-i065-20230523   clang
i386                 randconfig-i066-20230523   clang
i386                 randconfig-r001-20230522   gcc  
i386                 randconfig-r026-20230522   clang
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                        generic_defconfig   gcc  
ia64                 randconfig-r003-20230522   gcc  
ia64                 randconfig-r004-20230523   gcc  
ia64                 randconfig-r013-20230522   gcc  
ia64                 randconfig-r015-20230522   gcc  
ia64                          tiger_defconfig   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r003-20230521   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r002-20230521   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r003-20230522   gcc  
m68k                       bvme6000_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                        m5407c3_defconfig   gcc  
m68k                 randconfig-r005-20230521   gcc  
m68k                 randconfig-r013-20230522   gcc  
m68k                 randconfig-r036-20230522   gcc  
microblaze           randconfig-r004-20230522   gcc  
microblaze           randconfig-r016-20230521   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r006-20230521   gcc  
mips                  decstation_64_defconfig   gcc  
mips                      malta_kvm_defconfig   clang
mips                 randconfig-r001-20230521   gcc  
mips                 randconfig-r006-20230521   gcc  
nios2                            alldefconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r004-20230521   gcc  
nios2                randconfig-r005-20230521   gcc  
openrisc     buildonly-randconfig-r001-20230522   gcc  
openrisc     buildonly-randconfig-r002-20230521   gcc  
openrisc                    or1ksim_defconfig   gcc  
openrisc             randconfig-r006-20230521   gcc  
openrisc             randconfig-r014-20230522   gcc  
openrisc             randconfig-r031-20230522   gcc  
openrisc             randconfig-r033-20230521   gcc  
openrisc             randconfig-r034-20230521   gcc  
parisc       buildonly-randconfig-r002-20230522   gcc  
parisc       buildonly-randconfig-r004-20230522   gcc  
parisc       buildonly-randconfig-r006-20230521   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r001-20230523   gcc  
parisc               randconfig-r014-20230522   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                    mvme5100_defconfig   clang
powerpc                      pmac32_defconfig   clang
powerpc              randconfig-r004-20230522   gcc  
powerpc              randconfig-r021-20230521   gcc  
powerpc              randconfig-r034-20230522   gcc  
powerpc                    sam440ep_defconfig   gcc  
powerpc                     stx_gp3_defconfig   gcc  
powerpc                         wii_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r042-20230521   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r006-20230522   gcc  
s390                 randconfig-r011-20230521   gcc  
s390                 randconfig-r026-20230521   gcc  
s390                 randconfig-r044-20230521   gcc  
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r003-20230521   gcc  
sh                ecovec24-romimage_defconfig   gcc  
sh                         ecovec24_defconfig   gcc  
sh                        edosk7705_defconfig   gcc  
sh                            hp6xx_defconfig   gcc  
sh                   secureedge5410_defconfig   gcc  
sparc        buildonly-randconfig-r005-20230521   gcc  
sparc        buildonly-randconfig-r005-20230522   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r012-20230521   gcc  
sparc                randconfig-r014-20230521   gcc  
sparc64              randconfig-r011-20230521   gcc  
sparc64              randconfig-r015-20230522   gcc  
sparc64              randconfig-r016-20230521   gcc  
sparc64              randconfig-r032-20230521   gcc  
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
x86_64                        randconfig-k001   clang
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
x86_64               randconfig-x082-20230522   gcc  
x86_64               randconfig-x083-20230522   gcc  
x86_64               randconfig-x084-20230522   gcc  
x86_64               randconfig-x085-20230522   gcc  
x86_64               randconfig-x086-20230522   gcc  
x86_64               randconfig-x091-20230523   gcc  
x86_64               randconfig-x092-20230523   gcc  
x86_64               randconfig-x093-20230523   gcc  
x86_64               randconfig-x094-20230523   gcc  
x86_64               randconfig-x095-20230523   gcc  
x86_64               randconfig-x096-20230523   gcc  
x86_64                           rhel-8.3-bpf   gcc  
x86_64                          rhel-8.3-func   gcc  
x86_64                    rhel-8.3-kselftests   gcc  
x86_64                         rhel-8.3-kunit   gcc  
x86_64                           rhel-8.3-kvm   gcc  
x86_64                           rhel-8.3-ltp   gcc  
x86_64                           rhel-8.3-syz   gcc  
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r002-20230522   gcc  
xtensa               randconfig-r013-20230521   gcc  
xtensa               randconfig-r032-20230522   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
