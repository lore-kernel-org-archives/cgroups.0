From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-next] BUILD SUCCESS
 d42132d940a719371f837fa87b8bfbcea57abbd0
Date: Wed, 09 Jun 2021 15:07:16 +0800
Message-ID: <60c068a4.U4J3oNGSx7R4mae5%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: d42132d940a719371f837fa87b8bfbcea57abbd0  Merge branch 'for-5.14' into for-next

elapsed time: 725m

configs tested: 181
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
mips                         rt305x_defconfig
nios2                            allyesconfig
mips                      malta_kvm_defconfig
powerpc                     asp8347_defconfig
arm                           spitz_defconfig
sparc                       sparc32_defconfig
h8300                       h8s-sim_defconfig
arm                   milbeaut_m10v_defconfig
xtensa                           alldefconfig
mips                          ath79_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                           se7722_defconfig
sh                           se7724_defconfig
sh                          sdk7786_defconfig
arc                          axs103_defconfig
arm                    vt8500_v6_v7_defconfig
mips                     loongson2k_defconfig
powerpc                     taishan_defconfig
xtensa                          iss_defconfig
powerpc                     pseries_defconfig
parisc                generic-32bit_defconfig
h8300                    h8300h-sim_defconfig
mips                      loongson3_defconfig
ia64                      gensparse_defconfig
m68k                            q40_defconfig
openrisc                            defconfig
mips                     cu1000-neo_defconfig
arc                        nsim_700_defconfig
arm                       versatile_defconfig
sh                         microdev_defconfig
sh                             espt_defconfig
powerpc                 mpc837x_rdb_defconfig
h8300                            allyesconfig
powerpc                      ep88xc_defconfig
m68k                          atari_defconfig
powerpc                      cm5200_defconfig
arc                    vdk_hs38_smp_defconfig
powerpc                       eiger_defconfig
powerpc                     tqm8560_defconfig
mips                      fuloong2e_defconfig
xtensa                  audio_kc705_defconfig
arm                         lpc32xx_defconfig
sh                           se7343_defconfig
mips                         tb0226_defconfig
arm                      integrator_defconfig
arm                         cm_x300_defconfig
arm                         bcm2835_defconfig
mips                            ar7_defconfig
arm64                            alldefconfig
arm                           tegra_defconfig
sh                           se7206_defconfig
sh                 kfr2r09-romimage_defconfig
powerpc                 linkstation_defconfig
xtensa                  nommu_kc705_defconfig
i386                             allyesconfig
ia64                        generic_defconfig
powerpc                        warp_defconfig
powerpc                   currituck_defconfig
mips                  cavium_octeon_defconfig
sh                          sdk7780_defconfig
arm                             mxs_defconfig
mips                             allmodconfig
mips                       rbtx49xx_defconfig
arc                         haps_hs_defconfig
powerpc                         wii_defconfig
arm                         s3c2410_defconfig
mips                       lemote2f_defconfig
arm                       aspeed_g4_defconfig
mips                           ip27_defconfig
powerpc                      ppc6xx_defconfig
arm                         s5pv210_defconfig
nios2                         3c120_defconfig
powerpc                    mvme5100_defconfig
csky                                defconfig
arm                        cerfcube_defconfig
mips                      maltaaprp_defconfig
powerpc                    gamecube_defconfig
um                           x86_64_defconfig
arc                 nsimosci_hs_smp_defconfig
arm                         mv78xx0_defconfig
sh                           se7619_defconfig
xtensa                         virt_defconfig
powerpc                 mpc832x_rdb_defconfig
arm                       imx_v6_v7_defconfig
um                             i386_defconfig
arm                       netwinder_defconfig
powerpc                     tqm5200_defconfig
sh                   secureedge5410_defconfig
powerpc                      bamboo_defconfig
powerpc                  mpc866_ads_defconfig
mips                        workpad_defconfig
nds32                             allnoconfig
powerpc                     mpc83xx_defconfig
arm                      jornada720_defconfig
arc                           tb10x_defconfig
microblaze                          defconfig
powerpc                     kilauea_defconfig
sh                        edosk7760_defconfig
s390                             allyesconfig
sh                   sh7770_generic_defconfig
arm                     am200epdkit_defconfig
powerpc                      pmac32_defconfig
mips                      bmips_stb_defconfig
um                               alldefconfig
arm                          pxa168_defconfig
h8300                               defconfig
x86_64                            allnoconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                               defconfig
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a004-20210608
x86_64               randconfig-a002-20210608
x86_64               randconfig-a003-20210608
x86_64               randconfig-a006-20210608
x86_64               randconfig-a005-20210608
x86_64               randconfig-a001-20210608
i386                 randconfig-a003-20210608
i386                 randconfig-a006-20210608
i386                 randconfig-a004-20210608
i386                 randconfig-a001-20210608
i386                 randconfig-a005-20210608
i386                 randconfig-a002-20210608
i386                 randconfig-a015-20210608
i386                 randconfig-a013-20210608
i386                 randconfig-a016-20210608
i386                 randconfig-a011-20210608
i386                 randconfig-a012-20210608
i386                 randconfig-a014-20210608
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
um                            kunit_defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a002-20210607
x86_64               randconfig-a004-20210607
x86_64               randconfig-a003-20210607
x86_64               randconfig-a006-20210607
x86_64               randconfig-a005-20210607
x86_64               randconfig-a001-20210607
x86_64               randconfig-a015-20210608
x86_64               randconfig-a012-20210608
x86_64               randconfig-a014-20210608
x86_64               randconfig-a011-20210608
x86_64               randconfig-a016-20210608
x86_64               randconfig-a013-20210608

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
