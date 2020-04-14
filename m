From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-next] BUILD SUCCESS
 eec8fd0277e37cf447b88c6be181e81df867bcf1
Date: Tue, 14 Apr 2020 10:48:30 +0800
Message-ID: <5e95247e.Pj5I28kgP4YPaXjy%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git  for-next
branch HEAD: eec8fd0277e37cf447b88c6be181e81df867bcf1  device_cgroup: Cleanup cgroup eBPF device filter code

elapsed time: 480m

configs tested: 195
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

arm                              allmodconfig
arm                               allnoconfig
arm                              allyesconfig
arm64                            allmodconfig
arm64                             allnoconfig
arm64                            allyesconfig
arm                         at91_dt_defconfig
arm                           efm32_defconfig
arm                          exynos_defconfig
arm                        multi_v5_defconfig
arm                        multi_v7_defconfig
arm                        shmobile_defconfig
arm                           sunxi_defconfig
arm64                               defconfig
sparc                            allyesconfig
um                             i386_defconfig
um                           x86_64_defconfig
alpha                               defconfig
sparc64                             defconfig
i386                              allnoconfig
i386                             alldefconfig
i386                             allyesconfig
i386                              debian-10.3
i386                                defconfig
ia64                             alldefconfig
ia64                             allmodconfig
ia64                              allnoconfig
ia64                             allyesconfig
ia64                                defconfig
nios2                         3c120_defconfig
nios2                         10m50_defconfig
c6x                        evmc6678_defconfig
xtensa                          iss_defconfig
c6x                              allyesconfig
xtensa                       common_defconfig
openrisc                 simple_smp_defconfig
openrisc                    or1ksim_defconfig
nds32                               defconfig
nds32                             allnoconfig
csky                                defconfig
h8300                       h8s-sim_defconfig
h8300                     edosk2674_defconfig
m68k                             allmodconfig
h8300                    h8300h-sim_defconfig
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
m68k                           sun3_defconfig
arc                                 defconfig
arc                              allyesconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
powerpc                           allnoconfig
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
x86_64               randconfig-a001-20200414
x86_64               randconfig-a002-20200414
x86_64               randconfig-a003-20200414
i386                 randconfig-a001-20200414
i386                 randconfig-a002-20200414
i386                 randconfig-a003-20200414
alpha                randconfig-a001-20200413
m68k                 randconfig-a001-20200413
mips                 randconfig-a001-20200413
nds32                randconfig-a001-20200413
parisc               randconfig-a001-20200413
riscv                randconfig-a001-20200413
c6x                  randconfig-a001-20200413
h8300                randconfig-a001-20200413
microblaze           randconfig-a001-20200413
nios2                randconfig-a001-20200413
sparc64              randconfig-a001-20200413
s390                 randconfig-a001-20200414
xtensa               randconfig-a001-20200414
sh                   randconfig-a001-20200414
openrisc             randconfig-a001-20200414
csky                 randconfig-a001-20200414
csky                 randconfig-a001-20200413
openrisc             randconfig-a001-20200413
s390                 randconfig-a001-20200413
sh                   randconfig-a001-20200413
xtensa               randconfig-a001-20200413
x86_64               randconfig-b001-20200413
x86_64               randconfig-b002-20200413
x86_64               randconfig-b003-20200413
i386                 randconfig-b001-20200413
i386                 randconfig-b002-20200413
i386                 randconfig-b003-20200413
x86_64               randconfig-c001-20200413
x86_64               randconfig-c002-20200413
x86_64               randconfig-c003-20200413
i386                 randconfig-c001-20200413
i386                 randconfig-c002-20200413
i386                 randconfig-c003-20200413
x86_64               randconfig-c001-20200414
x86_64               randconfig-c002-20200414
x86_64               randconfig-c003-20200414
i386                 randconfig-c001-20200414
i386                 randconfig-c002-20200414
i386                 randconfig-c003-20200414
x86_64               randconfig-d001-20200413
x86_64               randconfig-d002-20200413
x86_64               randconfig-d003-20200413
i386                 randconfig-d001-20200413
i386                 randconfig-d002-20200413
i386                 randconfig-d003-20200413
x86_64               randconfig-e001-20200413
x86_64               randconfig-e002-20200413
x86_64               randconfig-e003-20200413
i386                 randconfig-e001-20200413
i386                 randconfig-e002-20200413
i386                 randconfig-e003-20200413
x86_64               randconfig-f001-20200413
x86_64               randconfig-f002-20200413
x86_64               randconfig-f003-20200413
i386                 randconfig-f001-20200413
i386                 randconfig-f002-20200413
i386                 randconfig-f003-20200413
x86_64               randconfig-g001-20200413
x86_64               randconfig-g002-20200413
x86_64               randconfig-g003-20200413
i386                 randconfig-g001-20200413
i386                 randconfig-g002-20200413
i386                 randconfig-g003-20200413
x86_64               randconfig-g001-20200414
x86_64               randconfig-g002-20200414
x86_64               randconfig-g003-20200414
i386                 randconfig-g001-20200414
i386                 randconfig-g002-20200414
i386                 randconfig-g003-20200414
x86_64               randconfig-h001-20200413
x86_64               randconfig-h002-20200413
x86_64               randconfig-h003-20200413
i386                 randconfig-h001-20200413
i386                 randconfig-h002-20200413
i386                 randconfig-h003-20200413
x86_64               randconfig-h001-20200414
x86_64               randconfig-h002-20200414
x86_64               randconfig-h003-20200414
i386                 randconfig-h001-20200414
i386                 randconfig-h002-20200414
i386                 randconfig-h003-20200414
arc                  randconfig-a001-20200413
arm                  randconfig-a001-20200413
arm64                randconfig-a001-20200413
ia64                 randconfig-a001-20200413
powerpc              randconfig-a001-20200413
sparc                randconfig-a001-20200413
arc                  randconfig-a001-20200414
arm                  randconfig-a001-20200414
arm64                randconfig-a001-20200414
ia64                 randconfig-a001-20200414
powerpc              randconfig-a001-20200414
sparc                randconfig-a001-20200414
riscv                            allmodconfig
riscv                             allnoconfig
riscv                            allyesconfig
riscv                               defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
s390                             alldefconfig
s390                             allmodconfig
s390                              allnoconfig
s390                             allyesconfig
s390                          debug_defconfig
s390                                defconfig
s390                       zfcpdump_defconfig
sh                               allmodconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
sparc                               defconfig
sparc64                          allmodconfig
sparc64                           allnoconfig
sparc64                          allyesconfig
um                                  defconfig
x86_64                              fedora-25
x86_64                                  kexec
x86_64                                    lkp
x86_64                                   rhel
x86_64                         rhel-7.2-clear
x86_64                               rhel-7.6
x86_64                    rhel-7.6-kselftests

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
