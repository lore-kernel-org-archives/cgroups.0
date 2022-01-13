From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-5.17-fixes] BUILD SUCCESS
 d068eebbd4822b6c14a7ea375dfe53ca5c69c776
Date: Fri, 14 Jan 2022 00:25:20 +0800
Message-ID: <61e05270.hcwfrlKrYr6X1ct4%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642091159; x=1673627159;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=mnAIH6dIYqS4MUYKYWWDy+VJ/L/oSWRWlRtucrQBfuQ=;
  b=fr6YX5AMDxPXmVE+gaHdwSMGur2awNLfulD7x4OtxCSlr4+vhuuBdb5Y
   AdHVvFAaH5CSaeC9Ez3DbwtedtqV/IAaGyb4yhKhUrYiJdfcizyKm1MMY
   Ms45yp6q0Gluo5mu1BXdxDQlFEXEq7U3hws04A4rLAkEH4Ifwhy0+KOzn
   uG4zdS1uz/XFRVretOtQ0H6ezPfPMo/0LZeYS5zYk96C+nKB+n8rFlGBx
   qQ8NJzccvfnrnnVmJHzBCxI3HkUgWsOq/pma3s8AO/K5dxLsr7EC+NFas
   p3AZRkmcXjfFd5UqSNeo1Hx8pSDAO+rVkbXaMCIABm/FED61ITdWSv8Ml
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.17-fixes
branch HEAD: d068eebbd4822b6c14a7ea375dfe53ca5c69c776  cgroup/cpuset: Make child cpusets restrict parents on v1 hierarchy

elapsed time: 1133m

configs tested: 143
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                          randconfig-c001
m68k                             alldefconfig
sh                          sdk7780_defconfig
ia64                        generic_defconfig
ia64                         bigsur_defconfig
sh                     magicpanelr2_defconfig
sh                          landisk_defconfig
sh                   sh7724_generic_defconfig
mips                  maltasmvp_eva_defconfig
sh                               alldefconfig
powerpc                      mgcoge_defconfig
arm                            lart_defconfig
powerpc                    klondike_defconfig
arm                           stm32_defconfig
powerpc                      bamboo_defconfig
csky                             alldefconfig
sparc                       sparc32_defconfig
sh                          rsk7269_defconfig
um                           x86_64_defconfig
sh                               j2_defconfig
powerpc64                        alldefconfig
mips                     decstation_defconfig
powerpc                       holly_defconfig
csky                                defconfig
powerpc                        warp_defconfig
m68k                       m5475evb_defconfig
mips                             allyesconfig
arm                            pleb_defconfig
arm                        trizeps4_defconfig
sh                           se7705_defconfig
mips                         mpc30x_defconfig
nios2                            alldefconfig
powerpc                      pasemi_defconfig
m68k                            q40_defconfig
arm                           tegra_defconfig
arm                          badge4_defconfig
sh                   sh7770_generic_defconfig
arm                          exynos_defconfig
ia64                             allmodconfig
sh                         apsh4a3a_defconfig
mips                           xway_defconfig
powerpc                       ppc64_defconfig
arm                          simpad_defconfig
sh                             sh03_defconfig
arm                        cerfcube_defconfig
powerpc                 mpc837x_mds_defconfig
xtensa                  nommu_kc705_defconfig
sh                          r7785rp_defconfig
arm                            hisi_defconfig
powerpc                       maple_defconfig
i386                             alldefconfig
arm                           sunxi_defconfig
sh                           se7721_defconfig
sh                           se7780_defconfig
powerpc                   motionpro_defconfig
arm                           h3600_defconfig
m68k                         amcore_defconfig
sh                          rsk7264_defconfig
sh                          kfr2r09_defconfig
um                             i386_defconfig
h8300                               defconfig
arm                  randconfig-c002-20220113
arm                  randconfig-c002-20220112
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
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64                        randconfig-a002
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
riscv                randconfig-r042-20220113
arc                  randconfig-r043-20220113
s390                 randconfig-r044-20220113
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec
x86_64                           allyesconfig

clang tested configs:
arm                  randconfig-c002-20220113
x86_64                        randconfig-c007
riscv                randconfig-c006-20220113
powerpc              randconfig-c003-20220113
i386                          randconfig-c001
mips                 randconfig-c004-20220113
mips                        bcm63xx_defconfig
mips                   sb1250_swarm_defconfig
powerpc                      pmac32_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a011
i386                          randconfig-a013
i386                          randconfig-a015
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
hexagon              randconfig-r045-20220113
hexagon              randconfig-r041-20220113
hexagon              randconfig-r045-20220112
riscv                randconfig-r042-20220112
hexagon              randconfig-r041-20220112

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
