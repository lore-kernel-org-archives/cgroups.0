From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:test-merge-for-5.15] BUILD SUCCESS
 184174b9768b25f082d5b43ff69871dbdbad21cf
Date: Wed, 01 Sep 2021 13:19:18 +0800
Message-ID: <612f0d56.JWWzYwtbPNKI11JP%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-for-5.15
branch HEAD: 184174b9768b25f082d5b43ff69871dbdbad21cf  Merge branch 'for-5.15' into test-merge-for-5.15

elapsed time: 734m

configs tested: 126
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20210831
parisc                           alldefconfig
arm                           u8500_defconfig
arm                          lpd270_defconfig
arm                        oxnas_v6_defconfig
arm                        spear3xx_defconfig
powerpc                     redwood_defconfig
sparc                            alldefconfig
arc                           tb10x_defconfig
riscv             nommu_k210_sdcard_defconfig
arc                     nsimosci_hs_defconfig
arm                        trizeps4_defconfig
nds32                            alldefconfig
mips                           ip27_defconfig
powerpc                 xes_mpc85xx_defconfig
mips                           jazz_defconfig
arm                         vf610m4_defconfig
mips                      maltaaprp_defconfig
sh                           se7750_defconfig
powerpc                   lite5200b_defconfig
arm                            mmp2_defconfig
csky                             alldefconfig
arm                             rpc_defconfig
arm                         hackkit_defconfig
sh                                  defconfig
xtensa                       common_defconfig
xtensa                  nommu_kc705_defconfig
sh                          lboxre2_defconfig
s390                       zfcpdump_defconfig
ia64                             allmodconfig
powerpc               mpc834x_itxgp_defconfig
arm                             mxs_defconfig
riscv                             allnoconfig
xtensa                         virt_defconfig
powerpc                      bamboo_defconfig
arm                            hisi_defconfig
powerpc                        warp_defconfig
arc                          axs101_defconfig
mips                        workpad_defconfig
openrisc                         alldefconfig
mips                           ip32_defconfig
mips                        bcm63xx_defconfig
x86_64                            allnoconfig
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
x86_64               randconfig-a005-20210831
x86_64               randconfig-a001-20210831
x86_64               randconfig-a003-20210831
x86_64               randconfig-a002-20210831
x86_64               randconfig-a004-20210831
x86_64               randconfig-a006-20210831
i386                 randconfig-a005-20210831
i386                 randconfig-a002-20210831
i386                 randconfig-a003-20210831
i386                 randconfig-a006-20210831
i386                 randconfig-a004-20210831
i386                 randconfig-a001-20210831
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
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
i386                 randconfig-c001-20210831
s390                 randconfig-c005-20210831
riscv                randconfig-c006-20210831
powerpc              randconfig-c003-20210831
mips                 randconfig-c004-20210831
arm                  randconfig-c002-20210831
x86_64               randconfig-c007-20210831
x86_64               randconfig-a014-20210831
x86_64               randconfig-a015-20210831
x86_64               randconfig-a013-20210831
x86_64               randconfig-a016-20210831
x86_64               randconfig-a012-20210831
x86_64               randconfig-a011-20210831
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
