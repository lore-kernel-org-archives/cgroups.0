From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 0fcfe377e5c87786994414e9bc142f70eac6c008
Date: Mon, 05 Sep 2022 17:36:13 +0800
Message-ID: <6315c30d.Rgj0C0kAw4DjM9tz%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662370629; x=1693906629;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=P3NN1b8Ygu+mKRrC+Av2MzQNGauHLYNy1uJ3ucQdHz0=;
  b=CLURmaojj8oimBRymS1SZuscXA+1myUPzRkRVLttUec1PuDG0+YneKfz
   dhrZ+kvDjlMXifWVtxQQQmpFetTede9/YixLc5a3ADvxPFJZHfU9+Ks5i
   iD8ypZQhIkIo4HMdTIt/4ImiqorsAB0SYU6BQGIr4C+Z2GTKiJ87kYr9S
   fQuOZT5nfD76M2ZAJ8+YRWWJ4TsEJZF1L7uucwCBUUYYa3A9RbGvUxMd9
   GwkhF3W3nevK2bWS79zfUm27EntgqdOBu2xMEiSm87HP1ZtxHh9ODlzIl
   7tqQ08GR2uBSaFaF2Lg3PQDtwcNSY/ukL0rGIV+bDGcqEoeGp2jX0Zfrf
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 0fcfe377e5c87786994414e9bc142f70eac6c008  Merge branch 'for-6.1' into for-next

elapsed time: 727m

configs tested: 145
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
ia64                          tiger_defconfig
sh                         apsh4a3a_defconfig
mips                           jazz_defconfig
arm                        realview_defconfig
powerpc                mpc7448_hpc2_defconfig
mips                  maltasmvp_eva_defconfig
sh                           se7712_defconfig
powerpc                      ppc40x_defconfig
arm                          pxa3xx_defconfig
arm                             ezx_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
powerpc                      makalu_defconfig
sh                          sdk7786_defconfig
sh                         microdev_defconfig
openrisc                       virt_defconfig
x86_64                           rhel-8.3-kvm
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                    rhel-8.3-kselftests
x86_64                         rhel-8.3-kunit
powerpc                     ep8248e_defconfig
powerpc                      ep88xc_defconfig
sh                   sh7770_generic_defconfig
sh                   secureedge5410_defconfig
powerpc                  iss476-smp_defconfig
mips                         db1xxx_defconfig
sh                           se7780_defconfig
xtensa                    xip_kc705_defconfig
arc                     nsimosci_hs_defconfig
loongarch                           defconfig
loongarch                         allnoconfig
powerpc                          allyesconfig
riscv                               defconfig
riscv                            allmodconfig
riscv                            allyesconfig
arm                        mvebu_v7_defconfig
parisc                generic-32bit_defconfig
arc                          axs101_defconfig
m68k                             alldefconfig
arm                           viper_defconfig
m68k                            q40_defconfig
sparc64                             defconfig
powerpc                 mpc837x_mds_defconfig
powerpc              randconfig-c003-20220904
i386                          randconfig-c001
s390                                defconfig
s390                             allmodconfig
arc                                 defconfig
alpha                               defconfig
s390                             allyesconfig
sparc                               defconfig
arm                     eseries_pxa_defconfig
powerpc                      mgcoge_defconfig
sh                           se7751_defconfig
nios2                            allyesconfig
arm                           corgi_defconfig
sh                               j2_defconfig
sh                             espt_defconfig
sh                 kfr2r09-romimage_defconfig
m68k                         apollo_defconfig
powerpc                        warp_defconfig
riscv                    nommu_k210_defconfig
arm                       imx_v6_v7_defconfig
arc                              alldefconfig
arm                         axm55xx_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
i386                                defconfig
i386                 randconfig-a003-20220905
i386                 randconfig-a005-20220905
i386                 randconfig-a006-20220905
i386                 randconfig-a001-20220905
i386                 randconfig-a002-20220905
i386                 randconfig-a004-20220905
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
i386                 randconfig-c001-20220905
ia64                             allmodconfig
arm                                 defconfig
powerpc                          allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
i386                             allyesconfig
sh                               allmodconfig
m68k                             allmodconfig
arm                        mini2440_defconfig
m68k                          atari_defconfig
mips                  decstation_64_defconfig
arm                              allyesconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
powerpc                           allnoconfig
m68k                             allyesconfig
m68k                       m5208evb_defconfig
microblaze                          defconfig
arm64                            allyesconfig
sh                              ul2_defconfig
arm                         lpc18xx_defconfig
powerpc                     pq2fads_defconfig
powerpc                     asp8347_defconfig
arm                          pxa910_defconfig
sh                     magicpanelr2_defconfig
arm                  randconfig-c002-20220905
x86_64               randconfig-c001-20220905
mips                      loongson3_defconfig
openrisc                 simple_smp_defconfig
powerpc                    sam440ep_defconfig
xtensa                  nommu_kc705_defconfig
arm                            mps2_defconfig
i386                             alldefconfig
sh                           se7343_defconfig
openrisc                    or1ksim_defconfig

clang tested configs:
powerpc                        fsp2_defconfig
arm                              alldefconfig
hexagon                             defconfig
x86_64                        randconfig-k001
powerpc                     akebono_defconfig
arm                         socfpga_defconfig
i386                 randconfig-a016-20220905
i386                 randconfig-a012-20220905
i386                 randconfig-a015-20220905
i386                 randconfig-a011-20220905
i386                 randconfig-a013-20220905
i386                 randconfig-a014-20220905
powerpc                   bluestone_defconfig
powerpc                     tqm5200_defconfig
arm                            mmp2_defconfig
riscv                randconfig-r042-20220905
hexagon              randconfig-r041-20220905
hexagon              randconfig-r045-20220905
s390                 randconfig-r044-20220905
mips                   sb1250_swarm_defconfig
powerpc                      ppc64e_defconfig
arm                  colibri_pxa270_defconfig
powerpc                    socrates_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
