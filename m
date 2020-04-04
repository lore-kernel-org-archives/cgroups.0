From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-5.7] BUILD SUCCESS
 0c05b9bdbfe52ad9b391a28dd26f047715627e0c
Date: Sat, 04 Apr 2020 12:06:20 +0800
Message-ID: <5e8807bc.uEb9/DKrjWJx9Tpf%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git  for-5.7
branch HEAD: 0c05b9bdbfe52ad9b391a28dd26f047715627e0c  docs: cgroup-v1: Document the cpuset_v2_mode mount option

elapsed time: 741m

configs tested: 192
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

arm                              allmodconfig
arm                               allnoconfig
arm                              allyesconfig
arm64                            allmodconfig
arm64                             allnoconfig
arm64                            allyesconfig
arm                           efm32_defconfig
arm                         at91_dt_defconfig
arm                        shmobile_defconfig
arm64                               defconfig
arm                          exynos_defconfig
arm                        multi_v5_defconfig
arm                           sunxi_defconfig
arm                        multi_v7_defconfig
sparc                            allyesconfig
xtensa                       common_defconfig
i386                                defconfig
riscv                          rv32_defconfig
c6x                        evmc6678_defconfig
m68k                           sun3_defconfig
powerpc                           allnoconfig
ia64                              allnoconfig
nios2                         10m50_defconfig
ia64                             alldefconfig
i386                              allnoconfig
i386                             alldefconfig
i386                             allyesconfig
ia64                             allmodconfig
ia64                             allyesconfig
ia64                                defconfig
c6x                              allyesconfig
nios2                         3c120_defconfig
openrisc                    or1ksim_defconfig
openrisc                 simple_smp_defconfig
xtensa                          iss_defconfig
alpha                               defconfig
csky                                defconfig
nds32                             allnoconfig
nds32                               defconfig
h8300                     edosk2674_defconfig
h8300                    h8300h-sim_defconfig
h8300                       h8s-sim_defconfig
m68k                             allmodconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
arc                              allyesconfig
arc                                 defconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
powerpc                          rhel-kconfig
mips                           32r2_defconfig
mips                         64r6el_defconfig
mips                             allmodconfig
mips                              allnoconfig
mips                             allyesconfig
mips                      fuloong2e_defconfig
mips                      malta_kvm_defconfig
parisc                            allnoconfig
parisc                generic-64bit_defconfig
parisc                generic-32bit_defconfig
parisc                           allyesconfig
x86_64               randconfig-a001-20200403
x86_64               randconfig-a002-20200403
x86_64               randconfig-a003-20200403
i386                 randconfig-a001-20200403
i386                 randconfig-a002-20200403
i386                 randconfig-a003-20200403
alpha                randconfig-a001-20200403
m68k                 randconfig-a001-20200403
mips                 randconfig-a001-20200403
nds32                randconfig-a001-20200403
parisc               randconfig-a001-20200403
c6x                  randconfig-a001-20200403
h8300                randconfig-a001-20200403
microblaze           randconfig-a001-20200403
nios2                randconfig-a001-20200403
sparc64              randconfig-a001-20200403
c6x                  randconfig-a001-20200404
h8300                randconfig-a001-20200404
microblaze           randconfig-a001-20200404
nios2                randconfig-a001-20200404
sparc64              randconfig-a001-20200404
csky                 randconfig-a001-20200403
openrisc             randconfig-a001-20200403
s390                 randconfig-a001-20200403
sh                   randconfig-a001-20200403
xtensa               randconfig-a001-20200403
x86_64               randconfig-b001-20200403
x86_64               randconfig-b002-20200403
x86_64               randconfig-b003-20200403
i386                 randconfig-b001-20200403
i386                 randconfig-b002-20200403
i386                 randconfig-b003-20200403
x86_64               randconfig-b001-20200404
x86_64               randconfig-b002-20200404
x86_64               randconfig-b003-20200404
i386                 randconfig-b001-20200404
i386                 randconfig-b002-20200404
i386                 randconfig-b003-20200404
x86_64               randconfig-c001-20200404
x86_64               randconfig-c002-20200404
x86_64               randconfig-c003-20200404
i386                 randconfig-c001-20200404
i386                 randconfig-c002-20200404
i386                 randconfig-c003-20200404
x86_64               randconfig-c001-20200403
x86_64               randconfig-c002-20200403
x86_64               randconfig-c003-20200403
i386                 randconfig-c001-20200403
i386                 randconfig-c002-20200403
i386                 randconfig-c003-20200403
x86_64               randconfig-d001-20200403
x86_64               randconfig-d002-20200403
x86_64               randconfig-d003-20200403
i386                 randconfig-d001-20200403
i386                 randconfig-d002-20200403
i386                 randconfig-d003-20200403
x86_64               randconfig-d001-20200404
x86_64               randconfig-d002-20200404
x86_64               randconfig-d003-20200404
i386                 randconfig-d001-20200404
i386                 randconfig-d002-20200404
i386                 randconfig-d003-20200404
x86_64               randconfig-e001-20200404
x86_64               randconfig-e002-20200404
x86_64               randconfig-e003-20200404
i386                 randconfig-e001-20200404
i386                 randconfig-e002-20200404
i386                 randconfig-e003-20200404
x86_64               randconfig-e001-20200403
x86_64               randconfig-e002-20200403
x86_64               randconfig-e003-20200403
i386                 randconfig-e001-20200403
i386                 randconfig-e002-20200403
i386                 randconfig-e003-20200403
x86_64               randconfig-f001-20200403
x86_64               randconfig-f002-20200403
x86_64               randconfig-f003-20200403
i386                 randconfig-f001-20200403
i386                 randconfig-f002-20200403
i386                 randconfig-f003-20200403
x86_64               randconfig-g001-20200403
x86_64               randconfig-g002-20200403
x86_64               randconfig-g003-20200403
i386                 randconfig-g001-20200403
i386                 randconfig-g002-20200403
i386                 randconfig-g003-20200403
x86_64               randconfig-h001-20200403
x86_64               randconfig-h002-20200403
x86_64               randconfig-h003-20200403
i386                 randconfig-h001-20200403
i386                 randconfig-h002-20200403
i386                 randconfig-h003-20200403
arc                  randconfig-a001-20200403
arm                  randconfig-a001-20200403
arm64                randconfig-a001-20200403
ia64                 randconfig-a001-20200403
powerpc              randconfig-a001-20200403
sparc                randconfig-a001-20200403
riscv                            allmodconfig
riscv                             allnoconfig
riscv                            allyesconfig
riscv                               defconfig
riscv                    nommu_virt_defconfig
s390                             alldefconfig
s390                              allnoconfig
s390                          debug_defconfig
s390                                defconfig
s390                       zfcpdump_defconfig
s390                             allmodconfig
s390                             allyesconfig
sh                               allmodconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
sparc64                          allmodconfig
sparc64                          allyesconfig
um                           x86_64_defconfig
um                             i386_defconfig
um                                  defconfig
x86_64                              fedora-25
x86_64                                  kexec
x86_64                                    lkp
x86_64                                   rhel
x86_64                         rhel-7.2-clear
x86_64                               rhel-7.6

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
