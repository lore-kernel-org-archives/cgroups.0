From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 79a7f41f7f5ac69fd22eaf1fb3e230bea95f3399
Date: Tue, 01 Nov 2022 22:52:19 +0800
Message-ID: <636132a3.5k9oncezWDbTHOvR%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667314380; x=1698850380;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=lFV8BC6BLOCUZcWsgrvgegyp1h3wLUa3ipf+uZrKSxE=;
  b=Rb1d/3vozErxU/5HcTi9VSM6joA1CUifAuYT/6o0QVHDC2SIHklrHPyE
   acV/hYCIqEqWKzJY+QPBtX3NHGWtYCDaTxfzVB1eTWj5XoMWoaC/N7PIN
   qcp+DlD3fc2pNRAUtulyB0Xkoiuj938E1BzLytbQ9zS6A1uRYQhcPSRC1
   HTGCO5sUnjcY1HV4/W189WqN+xMMXP7am2cz08ZjXO3R4DwUkTSHtdH9e
   VzrRTWCoA1uHDdItP+7dlYUIDOhX/GrVHaoPuH/s1GEY0ym4KiMxY/hxl
   8A8HyR/lNjwK7y9RK2hIW/J6VnffNwv95htnlb8Tb3olX+FQcjZzTcXap
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 79a7f41f7f5ac69fd22eaf1fb3e230bea95f3399  cgroup: cgroup refcnt functions should be exported when CONFIG_DEBUG_CGROUP_REF

elapsed time: 720m

configs tested: 114
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                           x86_64_defconfig
um                             i386_defconfig
x86_64               randconfig-k001-20221031
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
i386                             allyesconfig
i386                                defconfig
ia64                             allmodconfig
sh                              ul2_defconfig
powerpc                 mpc8540_ads_defconfig
openrisc                       virt_defconfig
powerpc                 canyonlands_defconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
powerpc                         wii_defconfig
sh                           sh2007_defconfig
arm                         lubbock_defconfig
powerpc                      chrp32_defconfig
m68k                                defconfig
arm                            mps2_defconfig
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
s390                                defconfig
s390                             allmodconfig
arc                                 defconfig
alpha                               defconfig
s390                             allyesconfig
i386                 randconfig-a016-20221031
i386                 randconfig-a012-20221031
i386                 randconfig-a015-20221031
i386                 randconfig-a013-20221031
i386                 randconfig-a014-20221031
i386                 randconfig-a011-20221031
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64               randconfig-a016-20221031
x86_64               randconfig-a011-20221031
x86_64               randconfig-a013-20221031
x86_64               randconfig-a012-20221031
x86_64               randconfig-a014-20221031
x86_64               randconfig-a015-20221031
um                               alldefconfig
mips                            ar7_defconfig
m68k                            q40_defconfig
xtensa                           alldefconfig
loongarch                 loongson3_defconfig
mips                           jazz_defconfig
arm                           tegra_defconfig
mips                 decstation_r4k_defconfig
arm                          lpd270_defconfig
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
i386                 randconfig-c001-20221031
mips                 randconfig-c004-20221031
arm                        mini2440_defconfig
powerpc                      mgcoge_defconfig
powerpc                 mpc834x_itx_defconfig
mips                       bmips_be_defconfig
i386                          randconfig-c001
sparc                             allnoconfig
xtensa                    smp_lx200_defconfig
arm                          gemini_defconfig
sh                 kfr2r09-romimage_defconfig
xtensa                       common_defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
nios2                            allyesconfig
nios2                               defconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig

clang tested configs:
riscv                randconfig-r042-20221101
hexagon              randconfig-r041-20221101
hexagon              randconfig-r045-20221101
s390                 randconfig-r044-20221101
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
arm                     am200epdkit_defconfig
arm                       spear13xx_defconfig
x86_64               randconfig-a005-20221031
x86_64               randconfig-a006-20221031
x86_64               randconfig-a004-20221031
x86_64               randconfig-a001-20221031
x86_64               randconfig-a003-20221031
x86_64               randconfig-a002-20221031
mips                        bcm63xx_defconfig
powerpc                          allyesconfig
arm                    vt8500_v6_v7_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
