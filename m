From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:iocost-debt-forgiveness] BUILD SUCCESS
 83e8ea543f9e76ccc87b20e1001645e197f3f1b1
Date: Fri, 18 Sep 2020 20:37:15 +0800
Message-ID: <5f64a9fb.9JI4w9dLcEa2/TyJ%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git  iocost-debt-forgiveness
branch HEAD: 83e8ea543f9e76ccc87b20e1001645e197f3f1b1  iocost: add iocg_forgive_debt tracepoint

elapsed time: 722m

configs tested: 144
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
arc                      axs103_smp_defconfig
powerpc               mpc834x_itxgp_defconfig
powerpc                        fsp2_defconfig
xtensa                              defconfig
powerpc                        cell_defconfig
mips                           ip22_defconfig
powerpc                     akebono_defconfig
powerpc                     rainier_defconfig
mips                       capcella_defconfig
powerpc                     kilauea_defconfig
arc                 nsimosci_hs_smp_defconfig
nds32                            alldefconfig
powerpc                 linkstation_defconfig
parisc                generic-64bit_defconfig
arm                      pxa255-idp_defconfig
ia64                         bigsur_defconfig
powerpc                      makalu_defconfig
arc                        vdk_hs38_defconfig
arm                        mvebu_v5_defconfig
m68k                            mac_defconfig
mips                 decstation_r4k_defconfig
nios2                         3c120_defconfig
powerpc                 xes_mpc85xx_defconfig
sh                               alldefconfig
sh                               j2_defconfig
powerpc                      acadia_defconfig
sh                             shx3_defconfig
powerpc                    gamecube_defconfig
xtensa                          iss_defconfig
mips                      loongson3_defconfig
mips                         cobalt_defconfig
powerpc                      ep88xc_defconfig
sparc                            alldefconfig
ia64                          tiger_defconfig
arc                           tb10x_defconfig
mips                  cavium_octeon_defconfig
nios2                         10m50_defconfig
mips                       lemote2f_defconfig
x86_64                           allyesconfig
powerpc                       maple_defconfig
sh                          rsk7269_defconfig
sh                          sdk7780_defconfig
powerpc                     sbc8548_defconfig
powerpc                 mpc837x_rdb_defconfig
sh                      rts7751r2d1_defconfig
powerpc                     pq2fads_defconfig
um                           x86_64_defconfig
sh                              ul2_defconfig
ia64                      gensparse_defconfig
ia64                             allmodconfig
sh                          r7780mp_defconfig
mips                      malta_kvm_defconfig
mips                         tb0226_defconfig
h8300                               defconfig
mips                           ci20_defconfig
openrisc                         alldefconfig
sh                   sh7724_generic_defconfig
powerpc                       ppc64_defconfig
arm                          iop32x_defconfig
m68k                        m5272c3_defconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
c6x                              allyesconfig
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
i386                 randconfig-a004-20200917
i386                 randconfig-a006-20200917
i386                 randconfig-a003-20200917
i386                 randconfig-a001-20200917
i386                 randconfig-a002-20200917
i386                 randconfig-a005-20200917
x86_64               randconfig-a014-20200917
x86_64               randconfig-a011-20200917
x86_64               randconfig-a016-20200917
x86_64               randconfig-a012-20200917
x86_64               randconfig-a015-20200917
x86_64               randconfig-a013-20200917
i386                 randconfig-a015-20200917
i386                 randconfig-a014-20200917
i386                 randconfig-a011-20200917
i386                 randconfig-a013-20200917
i386                 randconfig-a016-20200917
i386                 randconfig-a012-20200917
i386                 randconfig-a015-20200918
i386                 randconfig-a011-20200918
i386                 randconfig-a014-20200918
i386                 randconfig-a013-20200918
i386                 randconfig-a012-20200918
i386                 randconfig-a016-20200918
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                                   rhel
x86_64                    rhel-7.6-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-a006-20200917
x86_64               randconfig-a004-20200917
x86_64               randconfig-a003-20200917
x86_64               randconfig-a002-20200917
x86_64               randconfig-a001-20200917
x86_64               randconfig-a005-20200917
x86_64               randconfig-a014-20200918
x86_64               randconfig-a011-20200918
x86_64               randconfig-a012-20200918
x86_64               randconfig-a016-20200918
x86_64               randconfig-a015-20200918
x86_64               randconfig-a013-20200918

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
