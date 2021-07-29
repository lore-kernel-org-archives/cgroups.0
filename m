From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-5.14-fixes] BUILD SUCCESS
 c3df5fb57fe8756d67fd56ed29da65cdfde839f9
Date: Thu, 29 Jul 2021 18:24:25 +0800
Message-ID: <610281d9.f1sdnYVaDqfQiUof%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.14-fixes
branch HEAD: c3df5fb57fe8756d67fd56ed29da65cdfde839f9  cgroup: rstat: fix A-A deadlock on 32bit around u64_stats_sync

elapsed time: 2063m

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
i386                 randconfig-c001-20210727
i386                 randconfig-c001-20210728
powerpc                    mvme5100_defconfig
powerpc                      ppc6xx_defconfig
arm                         palmz72_defconfig
mips                       rbtx49xx_defconfig
arc                        nsimosci_defconfig
s390                          debug_defconfig
arm                         lpc18xx_defconfig
m68k                        mvme16x_defconfig
sh                        sh7763rdp_defconfig
riscv                          rv32_defconfig
arm                      jornada720_defconfig
powerpc                     akebono_defconfig
powerpc                    ge_imp3a_defconfig
sh                          urquell_defconfig
powerpc                      cm5200_defconfig
sh                   sh7770_generic_defconfig
arm                           tegra_defconfig
mips                         rt305x_defconfig
powerpc                       holly_defconfig
arm                      pxa255-idp_defconfig
sh                         ecovec24_defconfig
xtensa                    xip_kc705_defconfig
arm                        mini2440_defconfig
arc                           tb10x_defconfig
h8300                            alldefconfig
x86_64                           allyesconfig
powerpc                      arches_defconfig
mips                       capcella_defconfig
alpha                               defconfig
sh                              ul2_defconfig
nios2                            alldefconfig
powerpc                      ppc40x_defconfig
mips                            gpr_defconfig
mips                      maltasmvp_defconfig
sh                           se7721_defconfig
arm                       aspeed_g5_defconfig
arm                            mmp2_defconfig
powerpc                      katmai_defconfig
x86_64                              defconfig
powerpc                       eiger_defconfig
mips                      pistachio_defconfig
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
csky                                defconfig
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
x86_64               randconfig-a006-20210728
x86_64               randconfig-a003-20210728
x86_64               randconfig-a001-20210728
x86_64               randconfig-a004-20210728
x86_64               randconfig-a005-20210728
x86_64               randconfig-a002-20210728
i386                 randconfig-a005-20210728
i386                 randconfig-a003-20210728
i386                 randconfig-a004-20210728
i386                 randconfig-a002-20210728
i386                 randconfig-a001-20210728
i386                 randconfig-a006-20210728
i386                 randconfig-a005-20210727
i386                 randconfig-a003-20210727
i386                 randconfig-a004-20210727
i386                 randconfig-a002-20210727
i386                 randconfig-a001-20210727
i386                 randconfig-a006-20210727
x86_64               randconfig-a011-20210727
x86_64               randconfig-a016-20210727
x86_64               randconfig-a013-20210727
x86_64               randconfig-a014-20210727
x86_64               randconfig-a012-20210727
x86_64               randconfig-a015-20210727
i386                 randconfig-a016-20210728
i386                 randconfig-a012-20210728
i386                 randconfig-a013-20210728
i386                 randconfig-a014-20210728
i386                 randconfig-a011-20210728
i386                 randconfig-a015-20210728
i386                 randconfig-a016-20210727
i386                 randconfig-a013-20210727
i386                 randconfig-a012-20210727
i386                 randconfig-a011-20210727
i386                 randconfig-a014-20210727
i386                 randconfig-a015-20210727
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-c001-20210727
x86_64               randconfig-c001-20210728
x86_64               randconfig-a003-20210727
x86_64               randconfig-a006-20210727
x86_64               randconfig-a001-20210727
x86_64               randconfig-a005-20210727
x86_64               randconfig-a004-20210727
x86_64               randconfig-a002-20210727
x86_64               randconfig-a016-20210728
x86_64               randconfig-a011-20210728
x86_64               randconfig-a014-20210728
x86_64               randconfig-a013-20210728
x86_64               randconfig-a012-20210728
x86_64               randconfig-a015-20210728

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
