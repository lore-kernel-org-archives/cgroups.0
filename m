From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.0-fixes] BUILD SUCCESS
 763f4fb76e24959c370cdaa889b2492ba6175580
Date: Thu, 25 Aug 2022 02:40:37 +0800
Message-ID: <630670a5.s/4w3lZrlXHmGHdx%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661366493; x=1692902493;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=oIPySqj+sHYhRiBTiZzz0o+5rieiD04KIZEhKsO6xzE=;
  b=MgDyTDb52XLYEl7V0hT9aZWSkikEnM0fNo912EyPcgHwW1txBt8fvgV/
   mro0ABZ2+u/Cf0OHRNsXhRnER7F1rHA8aCUeMEPvQ8nq32meaBLxA25e5
   LJUdTB+4xptUh1826RrqgHakpbY/s3FVHXOKvHcJYnQF6O+Z9KPrGBszD
   7U2Z4VDUD6yPzrlDUTb/MmNOJOPvxvTUZ2xuZTrDpZzmdaTsDDVxz1Voz
   SqfnpHdNucS0diANGniNpJO8PXQsL4vYw6Mx+XE098Sy25ykD8XDzVDfa
   yHMH701jKlKGfI1tLs12KV/hnLG/9rntszQ7tSX6CyihPUJmWbJ03qm6q
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.0-fixes
branch HEAD: 763f4fb76e24959c370cdaa889b2492ba6175580  cgroup: Fix race condition at rebind_subsystems()

elapsed time: 1445m

configs tested: 149
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
loongarch                           defconfig
loongarch                         allnoconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
sh                           se7724_defconfig
arm                         lubbock_defconfig
powerpc                   currituck_defconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
i386                          randconfig-c001
m68k                        m5272c3_defconfig
m68k                          atari_defconfig
sh                          sdk7786_defconfig
powerpc                    klondike_defconfig
i386                             allyesconfig
i386                                defconfig
s390                                defconfig
s390                             allmodconfig
arc                                 defconfig
alpha                               defconfig
s390                             allyesconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
arm                       omap2plus_defconfig
arc                          axs101_defconfig
arc                         haps_hs_defconfig
powerpc                          allyesconfig
riscv                               defconfig
riscv                            allmodconfig
riscv                            allyesconfig
x86_64                           rhel-8.3-kvm
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                    rhel-8.3-kselftests
x86_64                         rhel-8.3-kunit
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
sh                        sh7763rdp_defconfig
m68k                          multi_defconfig
arc                      axs103_smp_defconfig
m68k                            mac_defconfig
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
nios2                            allyesconfig
nios2                               defconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
arm                            hisi_defconfig
um                                  defconfig
sh                     sh7710voipgw_defconfig
parisc64                         alldefconfig
sh                          kfr2r09_defconfig
xtensa                          iss_defconfig
arm                           h5000_defconfig
ia64                                defconfig
sparc                               defconfig
xtensa                           allyesconfig
csky                                defconfig
sparc                            allyesconfig
x86_64                                  kexec
arc                        nsim_700_defconfig
sh                   sh7770_generic_defconfig
arm                          gemini_defconfig
ia64                         bigsur_defconfig
parisc                           alldefconfig
powerpc                     tqm8555_defconfig
arm64                               defconfig
arm                              allmodconfig
m68k                                defconfig
mips                             allmodconfig
sparc                             allnoconfig
microblaze                          defconfig
m68k                        mvme16x_defconfig
m68k                            q40_defconfig
ia64                        generic_defconfig
sh                             shx3_defconfig
arc                     nsimosci_hs_defconfig
powerpc                      tqm8xx_defconfig
m68k                        stmark2_defconfig
m68k                         apollo_defconfig
arm                        shmobile_defconfig
ia64                          tiger_defconfig
mips                      loongson3_defconfig
arm                             rpc_defconfig
ia64                             allmodconfig
x86_64                        randconfig-a011
x86_64                        randconfig-a013
x86_64                        randconfig-a015
arm                            lart_defconfig
m68k                       m5249evb_defconfig
sh                             espt_defconfig

clang tested configs:
hexagon              randconfig-r045-20220823
riscv                randconfig-r042-20220823
hexagon              randconfig-r041-20220823
s390                 randconfig-r044-20220823
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-k001
mips                     loongson1c_defconfig
powerpc                     ppa8548_defconfig
powerpc                  mpc866_ads_defconfig
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
arm                            mmp2_defconfig
powerpc                     powernv_defconfig
hexagon              randconfig-r045-20220824
hexagon              randconfig-r041-20220824
i386                          randconfig-a011
i386                          randconfig-a013
i386                          randconfig-a015
mips                     cu1000-neo_defconfig
powerpc                    gamecube_defconfig
mips                        omega2p_defconfig
powerpc                 xes_mpc85xx_defconfig
arm                        neponset_defconfig
powerpc                 mpc832x_rdb_defconfig
powerpc                          g5_defconfig
mips                     decstation_defconfig
mips                           ci20_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
