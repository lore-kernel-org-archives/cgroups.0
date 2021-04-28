From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:test-merge-for-5.13] BUILD SUCCESS
 0def337b7d52bca20d0556fb8dc8797c540f5fc8
Date: Wed, 28 Apr 2021 11:45:47 +0800
Message-ID: <6088da6b.MtHdBq+KhtOFSJX4%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-for-5.13
branch HEAD: 0def337b7d52bca20d0556fb8dc8797c540f5fc8  Merge branch 'for-5.13' into tes-merge-for-5.13

elapsed time: 723m

configs tested: 139
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
riscv                            allmodconfig
x86_64                           allyesconfig
i386                             allyesconfig
riscv                            allyesconfig
sh                             sh03_defconfig
powerpc                 mpc837x_mds_defconfig
microblaze                          defconfig
parisc                           allyesconfig
arm                      pxa255-idp_defconfig
sh                         ecovec24_defconfig
powerpc                 mpc836x_mds_defconfig
m68k                        m5407c3_defconfig
mips                           mtx1_defconfig
powerpc                    mvme5100_defconfig
powerpc                      ppc40x_defconfig
mips                        nlm_xlr_defconfig
mips                        bcm47xx_defconfig
h8300                            alldefconfig
sh                 kfr2r09-romimage_defconfig
arm                        spear6xx_defconfig
powerpc                          g5_defconfig
m68k                          sun3x_defconfig
m68k                        m5272c3_defconfig
arm                         socfpga_defconfig
openrisc                  or1klitex_defconfig
parisc                generic-64bit_defconfig
arm                         nhk8815_defconfig
arm                  colibri_pxa300_defconfig
xtensa                    xip_kc705_defconfig
sh                         apsh4a3a_defconfig
arm                           stm32_defconfig
s390                             alldefconfig
mips                      maltaaprp_defconfig
arc                                 defconfig
arc                              allyesconfig
mips                            ar7_defconfig
mips                       capcella_defconfig
arm                          moxart_defconfig
arm                          pcm027_defconfig
arm                           tegra_defconfig
xtensa                       common_defconfig
sh                           se7721_defconfig
powerpc                    amigaone_defconfig
m68k                        m5307c3_defconfig
powerpc                      arches_defconfig
mips                             allmodconfig
powerpc                   bluestone_defconfig
arm                       mainstone_defconfig
arm                   milbeaut_m10v_defconfig
powerpc                     tqm8548_defconfig
arm                         cm_x300_defconfig
arm                        clps711x_defconfig
sh                           se7712_defconfig
mips                         mpc30x_defconfig
mips                  decstation_64_defconfig
sh                          urquell_defconfig
riscv             nommu_k210_sdcard_defconfig
m68k                           sun3_defconfig
riscv                            alldefconfig
m68k                         amcore_defconfig
sh                  sh7785lcr_32bit_defconfig
openrisc                 simple_smp_defconfig
arc                          axs103_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
nds32                             allnoconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
s390                                defconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a005-20210426
i386                 randconfig-a002-20210426
i386                 randconfig-a001-20210426
i386                 randconfig-a006-20210426
i386                 randconfig-a004-20210426
i386                 randconfig-a003-20210426
x86_64               randconfig-a015-20210426
x86_64               randconfig-a016-20210426
x86_64               randconfig-a011-20210426
x86_64               randconfig-a014-20210426
x86_64               randconfig-a012-20210426
x86_64               randconfig-a013-20210426
i386                 randconfig-a014-20210426
i386                 randconfig-a012-20210426
i386                 randconfig-a011-20210426
i386                 randconfig-a013-20210426
i386                 randconfig-a015-20210426
i386                 randconfig-a016-20210426
x86_64               randconfig-a002-20210427
x86_64               randconfig-a004-20210427
x86_64               randconfig-a001-20210427
x86_64               randconfig-a006-20210427
x86_64               randconfig-a005-20210427
x86_64               randconfig-a003-20210427
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
um                               allmodconfig
um                                allnoconfig
um                               allyesconfig
um                                  defconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a002-20210426
x86_64               randconfig-a004-20210426
x86_64               randconfig-a001-20210426
x86_64               randconfig-a006-20210426
x86_64               randconfig-a005-20210426
x86_64               randconfig-a003-20210426

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
