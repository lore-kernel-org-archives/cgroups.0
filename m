From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:for-5.6-fixes] BUILD SUCCESS
 0cd9d33ace336bc424fc30944aa3defd6786e4fe
Date: Tue, 04 Feb 2020 16:27:11 +0800
Message-ID: <5e392adf.+411Phrrm+UdY6U/%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git  for-5.6-fixes
branch HEAD: 0cd9d33ace336bc424fc30944aa3defd6786e4fe  cgroup: init_tasks shouldn't be linked to the root cgroup

elapsed time: 6390m

configs tested: 177
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

arm                              allmodconfig
arm                               allnoconfig
arm                              allyesconfig
arm                         at91_dt_defconfig
arm                           efm32_defconfig
arm                          exynos_defconfig
arm                        multi_v5_defconfig
arm                        multi_v7_defconfig
arm                        shmobile_defconfig
arm                           sunxi_defconfig
arm64                            allmodconfig
arm64                             allnoconfig
arm64                            allyesconfig
arm64                               defconfig
sparc                            allyesconfig
arc                                 defconfig
um                           x86_64_defconfig
s390                                defconfig
sparc64                          allyesconfig
ia64                                defconfig
powerpc                             defconfig
microblaze                    nommu_defconfig
alpha                               defconfig
mips                             allmodconfig
i386                                defconfig
i386                             allyesconfig
i386                             alldefconfig
i386                              allnoconfig
ia64                             allmodconfig
ia64                              allnoconfig
ia64                             allyesconfig
ia64                             alldefconfig
xtensa                       common_defconfig
openrisc                    or1ksim_defconfig
nios2                         3c120_defconfig
xtensa                          iss_defconfig
c6x                        evmc6678_defconfig
c6x                              allyesconfig
nios2                         10m50_defconfig
openrisc                 simple_smp_defconfig
nds32                               defconfig
csky                                defconfig
nds32                             allnoconfig
m68k                          multi_defconfig
m68k                       m5475evb_defconfig
h8300                    h8300h-sim_defconfig
h8300                     edosk2674_defconfig
m68k                           sun3_defconfig
h8300                       h8s-sim_defconfig
m68k                             allmodconfig
arc                              allyesconfig
microblaze                      mmu_defconfig
powerpc                           allnoconfig
powerpc                       ppc64_defconfig
powerpc                          rhel-kconfig
mips                           32r2_defconfig
mips                         64r6el_defconfig
mips                              allnoconfig
mips                             allyesconfig
mips                      fuloong2e_defconfig
mips                      malta_kvm_defconfig
parisc                            allnoconfig
parisc                            allyesonfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
x86_64               randconfig-a001-20200129
i386                 randconfig-a001-20200129
x86_64               randconfig-a002-20200129
i386                 randconfig-a002-20200129
i386                 randconfig-a003-20200129
x86_64               randconfig-a003-20200129
nds32                randconfig-a001-20200130
parisc               randconfig-a001-20200130
alpha                randconfig-a001-20200130
mips                 randconfig-a001-20200130
m68k                 randconfig-a001-20200130
riscv                randconfig-a001-20200130
nds32                randconfig-a001-20200131
parisc               randconfig-a001-20200131
alpha                randconfig-a001-20200131
riscv                randconfig-a001-20200131
m68k                 randconfig-a001-20200131
h8300                randconfig-a001-20200204
nios2                randconfig-a001-20200204
sparc64              randconfig-a001-20200204
h8300                randconfig-a001-20200130
nios2                randconfig-a001-20200130
c6x                  randconfig-a001-20200130
sparc64              randconfig-a001-20200130
csky                 randconfig-a001-20200130
openrisc             randconfig-a001-20200130
s390                 randconfig-a001-20200130
sh                   randconfig-a001-20200130
xtensa               randconfig-a001-20200130
x86_64               randconfig-b003-20200131
x86_64               randconfig-b002-20200131
i386                 randconfig-b003-20200131
i386                 randconfig-b001-20200131
i386                 randconfig-b002-20200131
x86_64               randconfig-b001-20200131
x86_64               randconfig-b001-20200129
x86_64               randconfig-b002-20200129
x86_64               randconfig-b003-20200129
i386                 randconfig-b001-20200129
i386                 randconfig-b002-20200129
i386                 randconfig-b003-20200129
i386                 randconfig-c001-20200131
x86_64               randconfig-c003-20200131
i386                 randconfig-c003-20200131
x86_64               randconfig-c001-20200131
x86_64               randconfig-c002-20200131
i386                 randconfig-c002-20200131
i386                 randconfig-d003-20200130
x86_64               randconfig-d002-20200130
i386                 randconfig-d001-20200130
i386                 randconfig-d002-20200130
x86_64               randconfig-d003-20200130
x86_64               randconfig-d001-20200130
i386                 randconfig-e002-20200129
x86_64               randconfig-e002-20200129
i386                 randconfig-e001-20200129
i386                 randconfig-e003-20200129
x86_64               randconfig-e003-20200129
x86_64               randconfig-e001-20200129
x86_64               randconfig-f001-20200129
x86_64               randconfig-f002-20200129
x86_64               randconfig-f003-20200129
i386                 randconfig-f001-20200129
i386                 randconfig-f002-20200129
i386                 randconfig-f003-20200129
x86_64               randconfig-g001-20200130
x86_64               randconfig-g002-20200130
x86_64               randconfig-g003-20200130
i386                 randconfig-g001-20200130
i386                 randconfig-g002-20200130
i386                 randconfig-g003-20200130
x86_64               randconfig-h001-20200129
x86_64               randconfig-h002-20200129
x86_64               randconfig-h003-20200129
i386                 randconfig-h001-20200129
i386                 randconfig-h002-20200129
i386                 randconfig-h003-20200129
arm64                randconfig-a001-20200130
ia64                 randconfig-a001-20200130
sparc                randconfig-a001-20200130
arm                  randconfig-a001-20200130
arc                  randconfig-a001-20200130
riscv                          rv32_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                            allmodconfig
riscv                    nommu_virt_defconfig
riscv                            allyesconfig
s390                              allnoconfig
s390                             alldefconfig
s390                          debug_defconfig
s390                             allmodconfig
s390                       zfcpdump_defconfig
s390                             allyesconfig
sh                  sh7785lcr_32bit_defconfig
sh                                allnoconfig
sh                            titan_defconfig
sh                               allmodconfig
sh                          rsk7269_defconfig
sparc                               defconfig
sparc64                          allmodconfig
sparc64                           allnoconfig
sparc64                             defconfig
um                             i386_defconfig
um                                  defconfig
x86_64                                    lkp
x86_64                                   rhel
x86_64                              fedora-25
x86_64                                  kexec
x86_64                         rhel-7.2-clear
x86_64                               rhel-7.6

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org Intel Corporation
