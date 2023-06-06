From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.5] BUILD SUCCESS
 0dad9b072b2b170a99fcefa330a1a3193d503d8c
Date: Tue, 06 Jun 2023 18:21:23 +0800
Message-ID: <20230606102123.7cmJK%lkp@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686046948; x=1717582948;
  h=date:from:to:cc:subject:message-id;
  bh=e1pPARKFZ+IffDlPO8+vij0dsWvsXFqjw4w1f9jc+qQ=;
  b=YwNy7cOKh8gAmMHzDM/CsW5mBZNYV/f9N5yyIOvpT6mwjhMWpVThwIpO
   A9lgkchq5vPjtYcm8oRbbj2hvcE3tvzP7x/vz6Y3wT2F566jtXE+KEXBH
   OYZbewwBGcAWHKqiKRn35n99f2AKFh3u/ena2DMPllU1LT7CLYz2YQZb1
   DLvnRBmodQM1OIQ4Zj0ti/p5P2KBmzXhFWRYGbkzMO9L2Fusao/lhTkY1
   Fj4f9jLcWzlRKYEHMnviH6x8KqUrd3UXmrpQ1ak1tS7cPtCYYGDka8qPM
   C4DX/WiJSUfySYPgZkhM8jwMtS/GdfaB9pLK9ciC9t9o/SMy0sDangEjX
   w==;
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.5
branch HEAD: 0dad9b072b2b170a99fcefa330a1a3193d503d8c  cgroup: make cgroup_is_threaded() and cgroup_is_thread_root() static

elapsed time: 725m

configs tested: 174
configs skipped: 12

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r004-20230605   gcc  
alpha                randconfig-r026-20230605   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r022-20230605   gcc  
arc                  randconfig-r032-20230605   gcc  
arc                  randconfig-r036-20230605   gcc  
arc                  randconfig-r043-20230605   gcc  
arc                  randconfig-r043-20230606   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r004-20230605   clang
arm                                 defconfig   gcc  
arm                  randconfig-r046-20230605   clang
arm                  randconfig-r046-20230606   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r013-20230605   gcc  
arm64                randconfig-r016-20230605   gcc  
arm64                randconfig-r024-20230605   gcc  
arm64                randconfig-r025-20230606   clang
csky                                defconfig   gcc  
csky                 randconfig-r021-20230606   gcc  
csky                 randconfig-r022-20230606   gcc  
csky                 randconfig-r025-20230605   gcc  
hexagon      buildonly-randconfig-r003-20230606   clang
hexagon              randconfig-r026-20230605   clang
hexagon              randconfig-r041-20230605   clang
hexagon              randconfig-r045-20230605   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230605   clang
i386                 randconfig-i001-20230606   gcc  
i386                 randconfig-i002-20230605   clang
i386                 randconfig-i002-20230606   gcc  
i386                 randconfig-i003-20230605   clang
i386                 randconfig-i003-20230606   gcc  
i386                 randconfig-i004-20230605   clang
i386                 randconfig-i004-20230606   gcc  
i386                 randconfig-i005-20230605   clang
i386                 randconfig-i005-20230606   gcc  
i386                 randconfig-i006-20230605   clang
i386                 randconfig-i006-20230606   gcc  
i386                 randconfig-i011-20230605   gcc  
i386                 randconfig-i011-20230606   clang
i386                 randconfig-i012-20230605   gcc  
i386                 randconfig-i012-20230606   clang
i386                 randconfig-i013-20230605   gcc  
i386                 randconfig-i013-20230606   clang
i386                 randconfig-i014-20230605   gcc  
i386                 randconfig-i014-20230606   clang
i386                 randconfig-i015-20230605   gcc  
i386                 randconfig-i015-20230606   clang
i386                 randconfig-i016-20230605   gcc  
i386                 randconfig-i016-20230606   clang
i386                 randconfig-i051-20230605   clang
i386                 randconfig-i051-20230606   gcc  
i386                 randconfig-i052-20230605   clang
i386                 randconfig-i052-20230606   gcc  
i386                 randconfig-i053-20230605   clang
i386                 randconfig-i053-20230606   gcc  
i386                 randconfig-i054-20230605   clang
i386                 randconfig-i054-20230606   gcc  
i386                 randconfig-i055-20230605   clang
i386                 randconfig-i055-20230606   gcc  
i386                 randconfig-i056-20230605   clang
i386                 randconfig-i056-20230606   gcc  
i386                 randconfig-i061-20230605   clang
i386                 randconfig-i061-20230606   gcc  
i386                 randconfig-i062-20230605   clang
i386                 randconfig-i062-20230606   gcc  
i386                 randconfig-i063-20230605   clang
i386                 randconfig-i063-20230606   gcc  
i386                 randconfig-i064-20230605   clang
i386                 randconfig-i064-20230606   gcc  
i386                 randconfig-i065-20230605   clang
i386                 randconfig-i065-20230606   gcc  
i386                 randconfig-i066-20230605   clang
i386                 randconfig-i066-20230606   gcc  
i386                 randconfig-r035-20230605   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch    buildonly-randconfig-r004-20230605   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r012-20230605   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r001-20230605   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips         buildonly-randconfig-r002-20230606   clang
mips         buildonly-randconfig-r005-20230605   gcc  
mips                 randconfig-r021-20230605   clang
mips                 randconfig-r025-20230606   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r025-20230605   gcc  
nios2                randconfig-r033-20230605   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r021-20230606   clang
powerpc              randconfig-r031-20230605   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv        buildonly-randconfig-r001-20230606   clang
riscv                               defconfig   gcc  
riscv                randconfig-r015-20230605   gcc  
riscv                randconfig-r023-20230605   gcc  
riscv                randconfig-r042-20230605   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r044-20230605   gcc  
sh                               allmodconfig   gcc  
sh           buildonly-randconfig-r001-20230605   gcc  
sparc                               defconfig   gcc  
sparc64              randconfig-r003-20230605   gcc  
sparc64              randconfig-r023-20230605   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r003-20230605   clang
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230605   clang
x86_64               randconfig-a001-20230606   gcc  
x86_64               randconfig-a002-20230605   clang
x86_64               randconfig-a002-20230606   gcc  
x86_64               randconfig-a003-20230605   clang
x86_64               randconfig-a003-20230606   gcc  
x86_64               randconfig-a004-20230605   clang
x86_64               randconfig-a004-20230606   gcc  
x86_64               randconfig-a005-20230605   clang
x86_64               randconfig-a005-20230606   gcc  
x86_64               randconfig-a006-20230605   clang
x86_64               randconfig-a006-20230606   gcc  
x86_64               randconfig-a011-20230605   gcc  
x86_64               randconfig-a011-20230606   clang
x86_64               randconfig-a012-20230605   gcc  
x86_64               randconfig-a012-20230606   clang
x86_64               randconfig-a013-20230605   gcc  
x86_64               randconfig-a013-20230606   clang
x86_64               randconfig-a014-20230605   gcc  
x86_64               randconfig-a014-20230606   clang
x86_64               randconfig-a015-20230605   gcc  
x86_64               randconfig-a015-20230606   clang
x86_64               randconfig-a016-20230606   clang
x86_64               randconfig-r032-20230605   clang
x86_64               randconfig-x051-20230605   gcc  
x86_64               randconfig-x051-20230606   clang
x86_64               randconfig-x052-20230605   gcc  
x86_64               randconfig-x052-20230606   clang
x86_64               randconfig-x053-20230605   gcc  
x86_64               randconfig-x053-20230606   clang
x86_64               randconfig-x054-20230605   gcc  
x86_64               randconfig-x054-20230606   clang
x86_64               randconfig-x055-20230605   gcc  
x86_64               randconfig-x055-20230606   clang
x86_64               randconfig-x056-20230605   gcc  
x86_64               randconfig-x056-20230606   clang
x86_64               randconfig-x061-20230605   gcc  
x86_64               randconfig-x062-20230605   gcc  
x86_64               randconfig-x063-20230605   gcc  
x86_64               randconfig-x064-20230605   gcc  
x86_64               randconfig-x065-20230605   gcc  
x86_64               randconfig-x066-20230605   gcc  
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r006-20230605   gcc  
xtensa               randconfig-r024-20230606   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
