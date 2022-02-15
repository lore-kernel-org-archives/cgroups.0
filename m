From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-5.17-fixes] BUILD SUCCESS
 05c7b7a92cc87ff8d7fde189d0fade250697573c
Date: Tue, 15 Feb 2022 18:56:18 +0800
Message-ID: <620b86d2.nNPwny8A1vWIHN19%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644922606; x=1676458606;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=q4fZAfoN5nCqH7PYonogbz3yTS0aQLYVzDgMJqhT9V0=;
  b=A9h0AFk0BTqVTzIzlzvD/RI8S6hSh7n9I1ymVL9FzqICddn3jfNqM0c+
   DStJLXF0u1PbAZWMK3QZiwyGVXfhSjawy3bq0StnAjZ6fo1yLGyRNq5k/
   fMPpHSH47MJ9dCnosu5iQfeUdA/03Gy1bJ1IWeZ8R4XlA1rKkGTzwuYTC
   ML8E7hJQEvlAI7AiSLIIqGOar+ymKPiQerRcXv95goPETWn2ULWwhU6On
   FKyMk29l9ET6ZOwrHv+r5yCzToDK8RAB44gq7MDkqk3PbrAHbZY0KlFKG
   fBakFz5CC0r8XVvga6hMesDqVw1CelclCB5l+n36vX5C2FLrHmlFNDy+1
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.17-fixes
branch HEAD: 05c7b7a92cc87ff8d7fde189d0fade250697573c  cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug

elapsed time: 730m

configs tested: 129
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20220214
mips                 randconfig-c004-20220214
nios2                            alldefconfig
sh                          r7780mp_defconfig
sh                            titan_defconfig
ia64                         bigsur_defconfig
xtensa                         virt_defconfig
arc                     haps_hs_smp_defconfig
xtensa                              defconfig
arm                          lpd270_defconfig
arm                        oxnas_v6_defconfig
sh                     magicpanelr2_defconfig
parisc                              defconfig
mips                          rb532_defconfig
powerpc                       maple_defconfig
powerpc64                           defconfig
arm                        mvebu_v7_defconfig
parisc                           alldefconfig
microblaze                          defconfig
sparc                               defconfig
arm64                            alldefconfig
m68k                          hp300_defconfig
arm                     eseries_pxa_defconfig
arm                            pleb_defconfig
sh                           se7721_defconfig
powerpc                           allnoconfig
arm                         lpc18xx_defconfig
powerpc                      bamboo_defconfig
arc                        nsimosci_defconfig
arm                  randconfig-c002-20220214
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
alpha                               defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                             allyesconfig
s390                             allmodconfig
parisc64                            defconfig
parisc                           allyesconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
x86_64               randconfig-a013-20220214
x86_64               randconfig-a014-20220214
x86_64               randconfig-a012-20220214
x86_64               randconfig-a015-20220214
x86_64               randconfig-a011-20220214
x86_64               randconfig-a016-20220214
i386                 randconfig-a013-20220214
i386                 randconfig-a016-20220214
i386                 randconfig-a012-20220214
i386                 randconfig-a015-20220214
i386                 randconfig-a011-20220214
i386                 randconfig-a014-20220214
riscv                randconfig-r042-20220214
arc                  randconfig-r043-20220214
s390                 randconfig-r044-20220214
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                                  kexec

clang tested configs:
riscv                randconfig-c006-20220214
i386                 randconfig-c001-20220214
x86_64               randconfig-c007-20220214
powerpc              randconfig-c003-20220214
arm                  randconfig-c002-20220214
mips                 randconfig-c004-20220214
arm                         lpc32xx_defconfig
powerpc                 mpc8315_rdb_defconfig
mips                        workpad_defconfig
arm                         s3c2410_defconfig
powerpc                     ppa8548_defconfig
mips                          ath25_defconfig
mips                     cu1830-neo_defconfig
arm                       spear13xx_defconfig
mips                         tb0287_defconfig
arm                          moxart_defconfig
powerpc                    gamecube_defconfig
mips                     loongson2k_defconfig
arm                       netwinder_defconfig
arm                       versatile_defconfig
powerpc                      ppc44x_defconfig
x86_64               randconfig-a002-20220214
x86_64               randconfig-a006-20220214
x86_64               randconfig-a005-20220214
x86_64               randconfig-a004-20220214
x86_64               randconfig-a003-20220214
x86_64               randconfig-a001-20220214
i386                 randconfig-a004-20220214
i386                 randconfig-a005-20220214
i386                 randconfig-a006-20220214
i386                 randconfig-a002-20220214
i386                 randconfig-a003-20220214
i386                 randconfig-a001-20220214
hexagon              randconfig-r045-20220214
hexagon              randconfig-r041-20220214

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
