From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-next] BUILD SUCCESS
 c5b6c8a56ef3fda7ab7d6d573f445ba9028cb696
Date: Fri, 13 Aug 2021 18:09:55 +0800
Message-ID: <611644f3.xryJYuC8QVYJnOgN%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: c5b6c8a56ef3fda7ab7d6d573f445ba9028cb696  Merge branch 'for-5.15' into for-next

elapsed time: 727m

configs tested: 155
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20210812
powerpc                     mpc5200_defconfig
powerpc                         wii_defconfig
arm                      integrator_defconfig
arm                        trizeps4_defconfig
sh                          polaris_defconfig
powerpc                      bamboo_defconfig
powerpc                       holly_defconfig
powerpc                mpc7448_hpc2_defconfig
powerpc                        cell_defconfig
powerpc                 mpc837x_rdb_defconfig
powerpc                     redwood_defconfig
arm                         at91_dt_defconfig
sh                   secureedge5410_defconfig
powerpc                     pseries_defconfig
powerpc                      makalu_defconfig
arm                      jornada720_defconfig
arm                       aspeed_g4_defconfig
mips                        qi_lb60_defconfig
sh                              ul2_defconfig
sh                           se7619_defconfig
mips                  maltasmvp_eva_defconfig
powerpc               mpc834x_itxgp_defconfig
mips                        maltaup_defconfig
mips                           ip22_defconfig
sh                           se7721_defconfig
arm                        clps711x_defconfig
powerpc                      ppc6xx_defconfig
powerpc                 mpc837x_mds_defconfig
ia64                             alldefconfig
sh                        edosk7705_defconfig
xtensa                    xip_kc705_defconfig
sh                          kfr2r09_defconfig
xtensa                generic_kc705_defconfig
arm                           stm32_defconfig
arm                           omap1_defconfig
arc                           tb10x_defconfig
arm                          exynos_defconfig
mips                          ath25_defconfig
s390                          debug_defconfig
openrisc                  or1klitex_defconfig
arc                    vdk_hs38_smp_defconfig
csky                                defconfig
mips                           ip32_defconfig
xtensa                              defconfig
sh                          sdk7786_defconfig
sh                         microdev_defconfig
arm                          pxa910_defconfig
sh                           se7780_defconfig
mips                        workpad_defconfig
mips                     decstation_defconfig
powerpc                     ppa8548_defconfig
arc                        nsimosci_defconfig
arm                     davinci_all_defconfig
mips                           gcw0_defconfig
arm                            xcep_defconfig
powerpc64                        alldefconfig
powerpc                     ksi8560_defconfig
powerpc                      pcm030_defconfig
arm                         s5pv210_defconfig
powerpc                        icon_defconfig
x86_64                            allnoconfig
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
i386                 randconfig-a004-20210812
i386                 randconfig-a003-20210812
i386                 randconfig-a002-20210812
i386                 randconfig-a001-20210812
i386                 randconfig-a006-20210812
i386                 randconfig-a005-20210812
i386                 randconfig-a004-20210813
i386                 randconfig-a003-20210813
i386                 randconfig-a001-20210813
i386                 randconfig-a002-20210813
i386                 randconfig-a006-20210813
i386                 randconfig-a005-20210813
i386                 randconfig-a011-20210812
i386                 randconfig-a015-20210812
i386                 randconfig-a013-20210812
i386                 randconfig-a014-20210812
i386                 randconfig-a016-20210812
i386                 randconfig-a012-20210812
i386                 randconfig-a011-20210813
i386                 randconfig-a015-20210813
i386                 randconfig-a014-20210813
i386                 randconfig-a013-20210813
i386                 randconfig-a016-20210813
i386                 randconfig-a012-20210813
x86_64               randconfig-a006-20210812
x86_64               randconfig-a004-20210812
x86_64               randconfig-a003-20210812
x86_64               randconfig-a005-20210812
x86_64               randconfig-a002-20210812
x86_64               randconfig-a001-20210812
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
x86_64               randconfig-c001-20210812
x86_64               randconfig-a006-20210813
x86_64               randconfig-a004-20210813
x86_64               randconfig-a003-20210813
x86_64               randconfig-a002-20210813
x86_64               randconfig-a005-20210813
x86_64               randconfig-a001-20210813
x86_64               randconfig-a011-20210812
x86_64               randconfig-a013-20210812
x86_64               randconfig-a012-20210812
x86_64               randconfig-a016-20210812
x86_64               randconfig-a015-20210812
x86_64               randconfig-a014-20210812

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
