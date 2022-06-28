From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-5.20] BUILD SUCCESS
 d75cd55ae2dedeee5382bb48832c322673b9781c
Date: Wed, 29 Jun 2022 07:55:11 +0800
Message-ID: <62bb94df.JxkZiXrSpv5wx47P%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656460541; x=1687996541;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=hF622s0f+n8alNjQgMYY6bo2AHVzSBaMBb5NtLm94wk=;
  b=V8ZxwDZsJNYoCVdNBm6t1nP820PFYz09U59iB7/ij9SAX+Bia88FSeKL
   McQQn4bDS/D0625HzX7yIUBsXDtkUCg4StbZ5hfUVZeaLfXZRkBS7iByp
   21g7kTiUxo3KJeGWoQcoE5byFu0X17If69TDn/DnPhR7ZoRU5jgn7FTu6
   BICMLxB+EJQjpbRY5AqM+pMJLpZhVmnJr35urwX70Vt3Y8v5bpXdA03W4
   ULx/rWKk41IngkHAQZMaExqPjFV82lKDuti421/d/OIxiTGCOz6RxECfb
   T8tACCoF1jHOGVJ3p3hCa+uADjm6Tmh1H42jihbIKoYgHIUU1c/WhERgk
   A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.20
branch HEAD: d75cd55ae2dedeee5382bb48832c322673b9781c  cgroup.c: remove redundant check for mixable cgroup in cgroup_migrate_vet_dst

elapsed time: 2285m

configs tested: 149
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
i386                 randconfig-c001-20220627
s390                          debug_defconfig
arm                          gemini_defconfig
sparc64                             defconfig
sparc64                          alldefconfig
mips                           xway_defconfig
sh                        sh7785lcr_defconfig
sh                               j2_defconfig
sh                           se7343_defconfig
parisc64                         alldefconfig
arm                        spear6xx_defconfig
xtensa                    smp_lx200_defconfig
powerpc                       holly_defconfig
powerpc                      ppc40x_defconfig
arm                        realview_defconfig
arm                            pleb_defconfig
parisc64                            defconfig
arm                          pxa910_defconfig
mips                      maltasmvp_defconfig
arc                        nsim_700_defconfig
arc                           tb10x_defconfig
sh                   sh7770_generic_defconfig
arm                          iop32x_defconfig
sh                           sh2007_defconfig
sh                           se7750_defconfig
sh                         ap325rxa_defconfig
openrisc                 simple_smp_defconfig
sh                          rsk7201_defconfig
sh                          sdk7780_defconfig
arm                            hisi_defconfig
arc                     nsimosci_hs_defconfig
arm                            lart_defconfig
sh                     magicpanelr2_defconfig
mips                             allmodconfig
sh                         ecovec24_defconfig
arm                        cerfcube_defconfig
arc                    vdk_hs38_smp_defconfig
powerpc                 mpc837x_mds_defconfig
sh                           se7712_defconfig
arm                      jornada720_defconfig
arm                       omap2plus_defconfig
powerpc                         ps3_defconfig
m68k                          sun3x_defconfig
powerpc                      bamboo_defconfig
powerpc                     tqm8541_defconfig
arc                     haps_hs_smp_defconfig
powerpc                     mpc83xx_defconfig
xtensa                    xip_kc705_defconfig
parisc                           allyesconfig
sparc                               defconfig
xtensa                           allyesconfig
csky                                defconfig
sparc                            allyesconfig
x86_64                                  kexec
powerpc                          allyesconfig
riscv                               defconfig
riscv                            allmodconfig
riscv                            allyesconfig
s390                                defconfig
s390                             allmodconfig
arc                                 defconfig
alpha                               defconfig
s390                             allyesconfig
nios2                            allyesconfig
nios2                               defconfig
parisc                              defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
x86_64               randconfig-c001-20220627
arm                  randconfig-c002-20220627
ia64                             allmodconfig
x86_64               randconfig-k001-20220627
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
i386                             allyesconfig
i386                                defconfig
x86_64               randconfig-a013-20220627
x86_64               randconfig-a012-20220627
x86_64               randconfig-a016-20220627
x86_64               randconfig-a015-20220627
x86_64               randconfig-a011-20220627
x86_64               randconfig-a014-20220627
i386                 randconfig-a014-20220627
i386                 randconfig-a011-20220627
i386                 randconfig-a012-20220627
i386                 randconfig-a015-20220627
i386                 randconfig-a016-20220627
i386                 randconfig-a013-20220627
arc                  randconfig-r043-20220627
riscv                randconfig-r042-20220627
s390                 randconfig-r044-20220627
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit

clang tested configs:
s390                 randconfig-c005-20220627
x86_64               randconfig-c007-20220627
mips                 randconfig-c004-20220627
i386                 randconfig-c001-20220627
powerpc              randconfig-c003-20220627
riscv                randconfig-c006-20220627
arm                  randconfig-c002-20220627
arm                        multi_v5_defconfig
powerpc                     skiroot_defconfig
powerpc                     ppa8548_defconfig
mips                           rs90_defconfig
arm                           spitz_defconfig
powerpc                     tqm5200_defconfig
mips                        bcm63xx_defconfig
arm                     am200epdkit_defconfig
arm                      pxa255-idp_defconfig
arm                            dove_defconfig
powerpc                      acadia_defconfig
mips                           ip27_defconfig
arm                        neponset_defconfig
powerpc                     ksi8560_defconfig
x86_64               randconfig-a004-20220627
x86_64               randconfig-a006-20220627
x86_64               randconfig-a001-20220627
x86_64               randconfig-a005-20220627
x86_64               randconfig-a002-20220627
x86_64               randconfig-a003-20220627
i386                 randconfig-a005-20220627
i386                 randconfig-a001-20220627
i386                 randconfig-a006-20220627
i386                 randconfig-a004-20220627
i386                 randconfig-a003-20220627
i386                 randconfig-a002-20220627
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
hexagon              randconfig-r041-20220627
hexagon              randconfig-r045-20220627

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
