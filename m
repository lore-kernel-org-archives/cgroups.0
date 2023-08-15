From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 82b90b6c5b38e457c7081d50dff11ecbafc1e61a
Date: Tue, 15 Aug 2023 21:44:37 +0800
Message-ID: <202308152135.jZbme0EF-lkp@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692107109; x=1723643109;
  h=date:from:to:cc:subject:message-id;
  bh=d2HX1SFUGRxuad7Xj7sFRUUHCHzhR0c3vHhMEqo/GPI=;
  b=gafY2FDL6c/u6C4K4hNQ7ImkMsy4rTQ0epHh93CHjuAQdURt/Yrkf5KI
   CZbpmtqN6WFsjGT3QN8WHLtiHGfrUvv7Inme+4xIMdAyST+zq8i1jRgg2
   z7OO4GFgnWIsYsqQ0RQHZ0Lbsct0PQqiW5kNsq/Pdsqjp1edUiaOI+t1i
   ER5dKcBsdgWVC/J2av0Y+1JQOnzBFctrCw7Z0DZsrfY1CFbRTHc1ZP5v7
   DgMsI23bh9Dj9sEaJKVAmSnSCiwmTBKKfYfNDLNi9wNvxPv7pNV4R4rs9
   2+46VDauC46xv3ig7ISPFFc+qqxJSkopOE3aYwnZknLbmsTFuB4xCqR7H
   g==;
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 82b90b6c5b38e457c7081d50dff11ecbafc1e61a  cgroup:namespace: Remove unused cgroup_namespaces_init()

elapsed time: 723m

configs tested: 183
configs skipped: 17

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r001-20230815   gcc  
alpha                randconfig-r021-20230815   gcc  
alpha                randconfig-r022-20230815   gcc  
alpha                randconfig-r023-20230815   gcc  
alpha                randconfig-r024-20230815   gcc  
alpha                randconfig-r031-20230815   gcc  
alpha                randconfig-r035-20230815   gcc  
alpha                randconfig-r036-20230815   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r003-20230815   gcc  
arc                  randconfig-r011-20230815   gcc  
arc                  randconfig-r024-20230815   gcc  
arc                  randconfig-r031-20230815   gcc  
arc                  randconfig-r043-20230815   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                           h3600_defconfig   gcc  
arm                         lpc18xx_defconfig   gcc  
arm                          moxart_defconfig   clang
arm                        multi_v7_defconfig   gcc  
arm                             mxs_defconfig   clang
arm                  randconfig-r004-20230815   gcc  
arm                  randconfig-r006-20230815   gcc  
arm                  randconfig-r032-20230815   gcc  
arm                  randconfig-r046-20230815   clang
arm                           sama7_defconfig   clang
arm                        spear6xx_defconfig   gcc  
arm                           sunxi_defconfig   gcc  
arm                           tegra_defconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r016-20230815   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r031-20230815   gcc  
hexagon              randconfig-r024-20230815   clang
hexagon              randconfig-r041-20230815   clang
hexagon              randconfig-r045-20230815   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230815   clang
i386         buildonly-randconfig-r005-20230815   clang
i386         buildonly-randconfig-r006-20230815   clang
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230815   clang
i386                 randconfig-i002-20230815   clang
i386                 randconfig-i003-20230815   clang
i386                 randconfig-i004-20230815   clang
i386                 randconfig-i005-20230815   clang
i386                 randconfig-i006-20230815   clang
i386                 randconfig-i011-20230815   gcc  
i386                 randconfig-i012-20230815   gcc  
i386                 randconfig-i013-20230815   gcc  
i386                 randconfig-i014-20230815   gcc  
i386                 randconfig-i015-20230815   gcc  
i386                 randconfig-i016-20230815   gcc  
i386                 randconfig-r016-20230815   gcc  
i386                 randconfig-r024-20230815   gcc  
i386                 randconfig-r025-20230815   gcc  
i386                 randconfig-r033-20230815   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r023-20230815   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                       bvme6000_defconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r003-20230815   gcc  
m68k                 randconfig-r013-20230815   gcc  
m68k                 randconfig-r016-20230815   gcc  
m68k                 randconfig-r025-20230815   gcc  
m68k                          sun3x_defconfig   gcc  
microblaze           randconfig-r023-20230815   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                  cavium_octeon_defconfig   gcc  
mips                     cu1000-neo_defconfig   clang
mips                           jazz_defconfig   gcc  
mips                       lemote2f_defconfig   clang
mips                     loongson1b_defconfig   gcc  
mips                  maltasmvp_eva_defconfig   gcc  
mips                 randconfig-r002-20230815   gcc  
nios2                         3c120_defconfig   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r002-20230815   gcc  
nios2                randconfig-r023-20230815   gcc  
nios2                randconfig-r031-20230815   gcc  
openrisc                    or1ksim_defconfig   gcc  
openrisc             randconfig-r001-20230815   gcc  
openrisc             randconfig-r012-20230815   gcc  
openrisc             randconfig-r022-20230815   gcc  
openrisc             randconfig-r035-20230815   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r013-20230815   gcc  
parisc               randconfig-r015-20230815   gcc  
parisc               randconfig-r022-20230815   gcc  
parisc               randconfig-r024-20230815   gcc  
parisc               randconfig-r026-20230815   gcc  
parisc               randconfig-r032-20230815   gcc  
parisc               randconfig-r033-20230815   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                       ebony_defconfig   gcc  
powerpc                    klondike_defconfig   gcc  
powerpc                      mgcoge_defconfig   gcc  
powerpc                    mvme5100_defconfig   gcc  
powerpc                    sam440ep_defconfig   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r021-20230815   gcc  
riscv                randconfig-r025-20230815   gcc  
riscv                randconfig-r026-20230815   gcc  
riscv                randconfig-r042-20230815   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r012-20230815   gcc  
s390                 randconfig-r044-20230815   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r014-20230815   gcc  
sh                   randconfig-r025-20230815   gcc  
sh                   rts7751r2dplus_defconfig   gcc  
sh                          sdk7780_defconfig   gcc  
sh                           se7619_defconfig   gcc  
sh                           se7705_defconfig   gcc  
sh                            titan_defconfig   gcc  
sh                              ul2_defconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r021-20230815   gcc  
sparc                randconfig-r022-20230815   gcc  
sparc                randconfig-r023-20230815   gcc  
sparc                randconfig-r026-20230815   gcc  
sparc                randconfig-r034-20230815   gcc  
sparc                randconfig-r036-20230815   gcc  
sparc64              randconfig-r004-20230815   gcc  
sparc64              randconfig-r011-20230815   gcc  
sparc64              randconfig-r021-20230815   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                   randconfig-r005-20230815   gcc  
um                   randconfig-r014-20230815   clang
um                   randconfig-r026-20230815   clang
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230815   clang
x86_64       buildonly-randconfig-r002-20230815   clang
x86_64       buildonly-randconfig-r003-20230815   clang
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-r006-20230815   clang
x86_64               randconfig-x001-20230815   gcc  
x86_64               randconfig-x002-20230815   gcc  
x86_64               randconfig-x003-20230815   gcc  
x86_64               randconfig-x004-20230815   gcc  
x86_64               randconfig-x005-20230815   gcc  
x86_64               randconfig-x006-20230815   gcc  
x86_64               randconfig-x011-20230815   clang
x86_64               randconfig-x012-20230815   clang
x86_64               randconfig-x013-20230815   clang
x86_64               randconfig-x014-20230815   clang
x86_64               randconfig-x015-20230815   clang
x86_64               randconfig-x016-20230815   clang
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r004-20230815   gcc  
xtensa               randconfig-r014-20230815   gcc  
xtensa               randconfig-r015-20230815   gcc  
xtensa               randconfig-r021-20230815   gcc  
xtensa               randconfig-r022-20230815   gcc  
xtensa               randconfig-r026-20230815   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
