From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 a091b198ba1ab51c1d3ec1564b2263941f297d65
Date: Fri, 07 Jan 2022 19:15:48 +0800
Message-ID: <61d820e4.J5jQIFRuMs5lW1GP%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641554214; x=1673090214;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=9EslOF7mLae/oC9PAgQ0+tIaLX6bWQUnKoqqOUiOy58=;
  b=lP2kUQdjqa9aWNWYqfUHz/useK/Llp352wDLLCvqRpF+H6n7HqWS6N5/
   AaaMUv+pjff7uEvnqhwBKJYHfHSqEVfOjOFPecL9hphTFHXdyG7uOjQAy
   JiBwzH8b/3KCW/EXAShZpDyn9BQ1rdJsUD3xFY8wDcgFMlOYeCyv5KjQy
   zz3N+3ixzDLAC7wxyoDd4GnYFScX/hdHZzMfDuCV9pJnq0JhkLeAfbflC
   w3s7AvwJPCqAeEwcorbz4EHYtRl0qVFGeMnHGco986Dntvp0MCw3BQ5nk
   h4/Qr+9efa49idaQUZu6CaG6KNbvHP1dDIheVc6zA2Jw8zv2pq7i74jby
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: a091b198ba1ab51c1d3ec1564b2263941f297d65  Merge branch 'for-5.17' into for-next

elapsed time: 757m

configs tested: 111
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20220107
arm                       omap2plus_defconfig
arm                            lart_defconfig
sh                        sh7763rdp_defconfig
sh                           se7343_defconfig
sh                     sh7710voipgw_defconfig
sh                           se7721_defconfig
m68k                        mvme147_defconfig
sh                          lboxre2_defconfig
powerpc                      chrp32_defconfig
powerpc                      mgcoge_defconfig
mips                           jazz_defconfig
arm                           viper_defconfig
arc                         haps_hs_defconfig
mips                         mpc30x_defconfig
xtensa                    smp_lx200_defconfig
sparc64                          alldefconfig
arm                           h5000_defconfig
arm                          badge4_defconfig
sh                        dreamcast_defconfig
arm                  randconfig-c002-20220107
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a005-20220107
x86_64               randconfig-a001-20220107
x86_64               randconfig-a004-20220107
x86_64               randconfig-a006-20220107
x86_64               randconfig-a002-20220107
x86_64               randconfig-a003-20220107
i386                 randconfig-a005-20220107
i386                 randconfig-a004-20220107
i386                 randconfig-a006-20220107
i386                 randconfig-a002-20220107
i386                 randconfig-a001-20220107
i386                 randconfig-a003-20220107
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
mips                 randconfig-c004-20220107
arm                  randconfig-c002-20220107
i386                 randconfig-c001-20220107
riscv                randconfig-c006-20220107
powerpc              randconfig-c003-20220107
x86_64               randconfig-c007-20220107
mips                        qi_lb60_defconfig
arm                          collie_defconfig
powerpc                          allyesconfig
arm                         s5pv210_defconfig
arm                         palmz72_defconfig
powerpc                 xes_mpc85xx_defconfig
x86_64               randconfig-a012-20220107
x86_64               randconfig-a015-20220107
x86_64               randconfig-a014-20220107
x86_64               randconfig-a013-20220107
x86_64               randconfig-a011-20220107
x86_64               randconfig-a016-20220107
i386                 randconfig-a012-20220107
i386                 randconfig-a016-20220107
i386                 randconfig-a014-20220107
i386                 randconfig-a015-20220107
i386                 randconfig-a011-20220107
i386                 randconfig-a013-20220107
hexagon              randconfig-r041-20220107
hexagon              randconfig-r045-20220107
riscv                randconfig-r042-20220107

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
