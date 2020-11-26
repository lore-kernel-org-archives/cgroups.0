From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-5.10-fixes] BUILD SUCCESS
 5a7b5f32c5aa628841502d19a813c633ff6ecbe4
Date: Thu, 26 Nov 2020 18:17:01 +0800
Message-ID: <5fbf809d.iVUDTiSL3856mzDl%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git  for-5.10-fixes
branch HEAD: 5a7b5f32c5aa628841502d19a813c633ff6ecbe4  cgroup/cgroup.c: replace 'of->kn->priv' with of_cft()

elapsed time: 721m

configs tested: 121
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
nios2                            alldefconfig
m68k                       m5208evb_defconfig
powerpc                      obs600_defconfig
arm                            pleb_defconfig
powerpc                        warp_defconfig
arm                            mps2_defconfig
powerpc                     akebono_defconfig
powerpc                 mpc832x_rdb_defconfig
arm                            mmp2_defconfig
sh                        apsh4ad0a_defconfig
sh                     magicpanelr2_defconfig
powerpc                   bluestone_defconfig
mips                        qi_lb60_defconfig
arm                         lubbock_defconfig
h8300                    h8300h-sim_defconfig
powerpc                 mpc85xx_cds_defconfig
arm                     eseries_pxa_defconfig
arm                         s3c6400_defconfig
parisc                generic-64bit_defconfig
alpha                               defconfig
riscv                               defconfig
h8300                               defconfig
sh                         apsh4a3a_defconfig
mips                        jmr3927_defconfig
arm                           omap1_defconfig
arm                            hisi_defconfig
sh                           se7705_defconfig
m68k                       m5249evb_defconfig
mips                       capcella_defconfig
arm                   milbeaut_m10v_defconfig
sh                         ecovec24_defconfig
i386                             alldefconfig
arm                            qcom_defconfig
powerpc                    socrates_defconfig
arm                       spear13xx_defconfig
powerpc                     tqm5200_defconfig
powerpc                       holly_defconfig
um                            kunit_defconfig
arm                             pxa_defconfig
s390                          debug_defconfig
sh                          r7785rp_defconfig
mips                           xway_defconfig
xtensa                           alldefconfig
sh                          lboxre2_defconfig
nds32                             allnoconfig
mips                     decstation_defconfig
powerpc                 mpc8313_rdb_defconfig
sh                           se7619_defconfig
m68k                        stmark2_defconfig
sh                           se7780_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
csky                                defconfig
alpha                            allyesconfig
nds32                               defconfig
nios2                            allyesconfig
nios2                               defconfig
arc                              allyesconfig
c6x                              allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
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
x86_64               randconfig-a015-20201125
x86_64               randconfig-a011-20201125
x86_64               randconfig-a014-20201125
x86_64               randconfig-a016-20201125
x86_64               randconfig-a012-20201125
x86_64               randconfig-a013-20201125
i386                 randconfig-a012-20201125
i386                 randconfig-a013-20201125
i386                 randconfig-a011-20201125
i386                 randconfig-a016-20201125
i386                 randconfig-a014-20201125
i386                 randconfig-a015-20201125
x86_64               randconfig-a006-20201126
x86_64               randconfig-a003-20201126
x86_64               randconfig-a004-20201126
x86_64               randconfig-a005-20201126
x86_64               randconfig-a001-20201126
x86_64               randconfig-a002-20201126
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                                   rhel
x86_64                           allyesconfig
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a015-20201126
x86_64               randconfig-a011-20201126
x86_64               randconfig-a014-20201126
x86_64               randconfig-a016-20201126
x86_64               randconfig-a012-20201126
x86_64               randconfig-a013-20201126

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
