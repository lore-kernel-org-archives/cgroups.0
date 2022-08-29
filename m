From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.1] BUILD SUCCESS
 c0f2df49cf2471289d5aabf16f50ac26eb268f7d
Date: Tue, 30 Aug 2022 00:34:44 +0800
Message-ID: <630ceaa4.HyGHzLSEmyMoQYFz%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661790942; x=1693326942;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=PzjTy3Tf5l7Kwdi/mu9ZiYf4YGlZVX2h1EMncBFMCi0=;
  b=Et6t9deUaiDR27zrjjgs3daPY1erU531iEgKwPijXRionP5q5IvLgzCV
   Q31msJjHiAQWP2YOk+MbY1w6SvHPSJ3CvUgWQk45mQiwtlUODpDSmjiea
   IUeLO+dA70mMU6aCABF+TINhv2qvgBr+NoBbCiq/ycTDFfUJlrywdUZNT
   YyWIEBvFYH5PcEKfPrZrnrnSTaeiuQTH9FfOegvrCIyxOenMWSv7clqkn
   1oYD9BK7AK7AgO/i15k080VKohmMvxP58UiJuKkVd32vkRuBOV3k7mRBR
   +JDXEPT4qhP7e9+bN5wgIYzxFiKAVdJ0f/8gN9SA09jMX1W/oiHmudHJn
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.1
branch HEAD: c0f2df49cf2471289d5aabf16f50ac26eb268f7d  cgroup: Fix build failure when CONFIG_SHRINKER_DEBUG

elapsed time: 721m

configs tested: 138
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
nios2                               defconfig
um                             i386_defconfig
parisc                              defconfig
um                           x86_64_defconfig
parisc64                            defconfig
csky                              allnoconfig
nios2                            allyesconfig
csky                                defconfig
loongarch                         allnoconfig
arc                               allnoconfig
arc                                 defconfig
x86_64                              defconfig
parisc                           allyesconfig
x86_64                               rhel-8.3
alpha                               defconfig
i386                        debian-10.3-kunit
sparc                               defconfig
loongarch                           defconfig
i386                         debian-10.3-func
alpha                             allnoconfig
m68k                             allmodconfig
riscv                             allnoconfig
x86_64                                  kexec
i386                                defconfig
x86_64                           allyesconfig
xtensa                           allyesconfig
powerpc                           allnoconfig
i386                          debian-10.3-kvm
x86_64                           rhel-8.3-kvm
i386                 randconfig-a005-20220829
powerpc                          allmodconfig
x86_64                    rhel-8.3-kselftests
riscv                randconfig-r042-20220828
riscv                               defconfig
sparc                            allyesconfig
i386                 randconfig-a006-20220829
arc                              allyesconfig
arc                  randconfig-r043-20220829
s390                             allmodconfig
riscv                    nommu_virt_defconfig
mips                             allyesconfig
riscv                          rv32_defconfig
arc                  randconfig-r043-20220828
i386                 randconfig-a001-20220829
alpha                            allyesconfig
s390                                defconfig
i386                   debian-10.3-kselftests
x86_64                           rhel-8.3-syz
i386                 randconfig-a003-20220829
x86_64                          rhel-8.3-func
m68k                             allyesconfig
sh                               allmodconfig
i386                              debian-10.3
i386                 randconfig-a002-20220829
x86_64                         rhel-8.3-kunit
arm                                 defconfig
s390                             allyesconfig
arm                              allmodconfig
s390                 randconfig-r044-20220828
x86_64                        randconfig-a004
i386                 randconfig-a004-20220829
arm64                               defconfig
x86_64                        randconfig-a002
riscv                    nommu_k210_defconfig
i386                             allyesconfig
ia64                             allmodconfig
um                                  defconfig
m68k                                defconfig
ia64                                defconfig
x86_64               randconfig-a003-20220829
powerpc                        cell_defconfig
x86_64               randconfig-a004-20220829
sh                            titan_defconfig
powerpc                     tqm8555_defconfig
x86_64                        randconfig-a006
powerpc                          allyesconfig
arm                          pxa3xx_defconfig
riscv                            allmodconfig
x86_64               randconfig-a005-20220829
xtensa                              defconfig
i386                          randconfig-c001
x86_64               randconfig-a002-20220829
x86_64               randconfig-a006-20220829
arm                           imxrt_defconfig
riscv                            allyesconfig
sh                             sh03_defconfig
x86_64               randconfig-a001-20220829
arm64                            allyesconfig
arm                              allyesconfig
sh                          urquell_defconfig
parisc                generic-32bit_defconfig
sh                           se7705_defconfig
arm                        mini2440_defconfig
powerpc                      ppc40x_defconfig
i386                 randconfig-c001-20220829
powerpc                     taishan_defconfig
arm                         axm55xx_defconfig
microblaze                      mmu_defconfig
arm                         lpc18xx_defconfig
powerpc                  storcenter_defconfig
powerpc                       eiger_defconfig
arc                 nsimosci_hs_smp_defconfig
sh                           se7722_defconfig
xtensa                  nommu_kc705_defconfig
arm                             ezx_defconfig
arm                            mps2_defconfig

clang tested configs:
x86_64               randconfig-a011-20220829
hexagon              randconfig-r041-20220829
riscv                randconfig-r042-20220829
x86_64               randconfig-a014-20220829
hexagon              randconfig-r041-20220828
x86_64               randconfig-a016-20220829
s390                 randconfig-r044-20220829
i386                 randconfig-a011-20220829
hexagon              randconfig-r045-20220828
mips                           ip28_defconfig
powerpc                     tqm8560_defconfig
powerpc                      walnut_defconfig
i386                 randconfig-a014-20220829
x86_64               randconfig-a015-20220829
hexagon              randconfig-r045-20220829
x86_64               randconfig-a012-20220829
x86_64                        randconfig-a001
x86_64               randconfig-a013-20220829
i386                 randconfig-a013-20220829
i386                 randconfig-a012-20220829
x86_64                        randconfig-a003
i386                 randconfig-a015-20220829
powerpc                    ge_imp3a_defconfig
x86_64                        randconfig-a005
i386                 randconfig-a016-20220829
mips                  cavium_octeon_defconfig
mips                          ath25_defconfig
arm                     davinci_all_defconfig
powerpc                     mpc512x_defconfig
riscv                    nommu_virt_defconfig
arm                             mxs_defconfig
arm                          pcm027_defconfig
arm                        mvebu_v5_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
