From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-next] BUILD SUCCESS
 96aff80dde1b7ccd1f335eff4f5cd9bae37e74c2
Date: Tue, 31 Aug 2021 14:00:13 +0800
Message-ID: <612dc56d.CT7izs7cc1yrAbGJ%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 96aff80dde1b7ccd1f335eff4f5cd9bae37e74c2  Merge branch 'for-5.15' into for-next

elapsed time: 724m

configs tested: 120
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
arm                          gemini_defconfig
powerpc64                           defconfig
powerpc                      arches_defconfig
arm                         vf610m4_defconfig
mips                           ci20_defconfig
powerpc                 mpc836x_mds_defconfig
s390                       zfcpdump_defconfig
mips                         mpc30x_defconfig
mips                          ath79_defconfig
openrisc                 simple_smp_defconfig
mips                        vocore2_defconfig
mips                           ip22_defconfig
sh                      rts7751r2d1_defconfig
powerpc                     pq2fads_defconfig
arm                         s3c6400_defconfig
sh                        apsh4ad0a_defconfig
powerpc                     mpc5200_defconfig
sparc64                             defconfig
arm                        magician_defconfig
mips                        nlm_xlr_defconfig
arm                         bcm2835_defconfig
arm                       netwinder_defconfig
powerpc                     tqm8555_defconfig
powerpc                      tqm8xx_defconfig
arm                          exynos_defconfig
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
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a014-20210830
x86_64               randconfig-a015-20210830
x86_64               randconfig-a013-20210830
x86_64               randconfig-a016-20210830
x86_64               randconfig-a012-20210830
x86_64               randconfig-a011-20210830
i386                 randconfig-a016-20210830
i386                 randconfig-a011-20210830
i386                 randconfig-a015-20210830
i386                 randconfig-a014-20210830
i386                 randconfig-a012-20210830
i386                 randconfig-a013-20210830
s390                 randconfig-r044-20210830
arc                  randconfig-r043-20210830
riscv                randconfig-r042-20210830
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
x86_64                                  kexec

clang tested configs:
i386                 randconfig-c001-20210830
s390                 randconfig-c005-20210830
riscv                randconfig-c006-20210830
powerpc              randconfig-c003-20210830
mips                 randconfig-c004-20210830
arm                  randconfig-c002-20210830
x86_64               randconfig-c007-20210830
x86_64               randconfig-a005-20210830
x86_64               randconfig-a001-20210830
x86_64               randconfig-a003-20210830
x86_64               randconfig-a002-20210830
x86_64               randconfig-a004-20210830
x86_64               randconfig-a006-20210830
i386                 randconfig-a005-20210830
i386                 randconfig-a002-20210830
i386                 randconfig-a003-20210830
i386                 randconfig-a006-20210830
i386                 randconfig-a004-20210830
i386                 randconfig-a001-20210830
i386                 randconfig-a016-20210831
i386                 randconfig-a011-20210831
i386                 randconfig-a015-20210831
i386                 randconfig-a014-20210831
i386                 randconfig-a012-20210831
i386                 randconfig-a013-20210831
s390                 randconfig-r044-20210831
hexagon              randconfig-r041-20210831
hexagon              randconfig-r045-20210831
riscv                randconfig-r042-20210831

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
