From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-next] BUILD SUCCESS
 c0002d11d79900f8aa5c8375336434940d6afedf
Date: Tue, 14 Sep 2021 14:41:21 +0800
Message-ID: <61404411.kPY5BQL8lx27zLZI%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: c0002d11d79900f8aa5c8375336434940d6afedf  cgroupv2, docs: fix misinformation in "device controller" section

elapsed time: 729m

configs tested: 141
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20210913
powerpc                   motionpro_defconfig
arm                         axm55xx_defconfig
powerpc                 mpc8540_ads_defconfig
m68k                        m5307c3_defconfig
powerpc                      ppc6xx_defconfig
mips                           gcw0_defconfig
mips                      fuloong2e_defconfig
arm                          pxa168_defconfig
arm                          pxa910_defconfig
mips                     loongson1b_defconfig
powerpc                     taishan_defconfig
arm                         s3c2410_defconfig
arm                            mps2_defconfig
xtensa                  cadence_csp_defconfig
arm                     davinci_all_defconfig
powerpc                     redwood_defconfig
arm                       netwinder_defconfig
powerpc                        cell_defconfig
mips                      maltasmvp_defconfig
mips                        workpad_defconfig
m68k                            q40_defconfig
arm                            mmp2_defconfig
m68k                       m5275evb_defconfig
powerpc                    ge_imp3a_defconfig
powerpc                    gamecube_defconfig
sh                                  defconfig
mips                           ip27_defconfig
powerpc                      katmai_defconfig
powerpc                     tqm8555_defconfig
arm                          ixp4xx_defconfig
mips                   sb1250_swarm_defconfig
sh                          kfr2r09_defconfig
powerpc                 linkstation_defconfig
mips                         bigsur_defconfig
mips                        maltaup_defconfig
arc                        nsim_700_defconfig
arm                             mxs_defconfig
powerpc                  iss476-smp_defconfig
arm                         bcm2835_defconfig
m68k                          atari_defconfig
sh                   secureedge5410_defconfig
sh                           se7721_defconfig
mips                         rt305x_defconfig
mips                        omega2p_defconfig
ia64                        generic_defconfig
arm                       aspeed_g5_defconfig
riscv                    nommu_virt_defconfig
xtensa                  audio_kc705_defconfig
alpha                               defconfig
s390                             alldefconfig
sh                      rts7751r2d1_defconfig
openrisc                         alldefconfig
m68k                        mvme16x_defconfig
powerpc                     ep8248e_defconfig
powerpc                      arches_defconfig
riscv                               defconfig
x86_64               randconfig-c001-20210913
arm                  randconfig-c002-20210913
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                                defconfig
m68k                             allmodconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nds32                               defconfig
nios2                            allyesconfig
csky                                defconfig
alpha                            allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
xtensa                           allyesconfig
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
s390                                defconfig
parisc                           allyesconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                           allnoconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
i386                 randconfig-a004-20210913
i386                 randconfig-a005-20210913
i386                 randconfig-a002-20210913
i386                 randconfig-a006-20210913
i386                 randconfig-a003-20210913
i386                 randconfig-a001-20210913
x86_64               randconfig-a002-20210913
x86_64               randconfig-a003-20210913
x86_64               randconfig-a006-20210913
x86_64               randconfig-a004-20210913
x86_64               randconfig-a005-20210913
x86_64               randconfig-a001-20210913
arc                  randconfig-r043-20210913
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                             allnoconfig
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
riscv                randconfig-c006-20210913
x86_64               randconfig-c007-20210913
mips                 randconfig-c004-20210913
powerpc              randconfig-c003-20210913
i386                 randconfig-c001-20210913
arm                  randconfig-c002-20210913
s390                 randconfig-c005-20210913
x86_64               randconfig-a016-20210913
x86_64               randconfig-a013-20210913
x86_64               randconfig-a012-20210913
x86_64               randconfig-a011-20210913
x86_64               randconfig-a014-20210913
x86_64               randconfig-a015-20210913
i386                 randconfig-a016-20210913
i386                 randconfig-a011-20210913
i386                 randconfig-a015-20210913
i386                 randconfig-a012-20210913
i386                 randconfig-a013-20210913
i386                 randconfig-a014-20210913
riscv                randconfig-r042-20210913
hexagon              randconfig-r045-20210913
s390                 randconfig-r044-20210913
hexagon              randconfig-r041-20210913

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
