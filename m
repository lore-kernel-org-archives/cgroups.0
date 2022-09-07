From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 538b9e23ed6cc9ae64a7aa79b17317bf16a5d0c1
Date: Wed, 07 Sep 2022 16:13:09 +0800
Message-ID: <63185295.tcbxoJHMUFExoKVs%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662538449; x=1694074449;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=3TdnOYEVdeUBzMisM085xYKK1KLS+Bb6h4ayASdTCjs=;
  b=Ux6mOdYQmz7+/tkcex76ktQvJHyPQUGCqyqB+JcyDaCo4JUT63gniIxr
   e6rlWnA3Tio2eJ+HcTct2LU12WNkXfOYjJQQSwsnEQr2p1nvFOdgtrs8D
   cl6BHQhVy++/xmpexP6daWRBMuIUnvHZanTdLSAFKYxFt6IfB3rEvMeCW
   qS/y23fY5FrPBcKztm+LNq9dc+Qofx4p0GO6uPvMXL6D+AbfAX3E8SyIc
   Kv/pgqBtcTUD49xM9FvAd9sFOYkS53y0Tn/3QFAq6BUNWPVIxYtXBmfa7
   Jm8i4DL1aU/pai9xlQZNdzG8b4dLyCq6fFp6Cpt8PuUlc1Yt8pM6BKtHD
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 538b9e23ed6cc9ae64a7aa79b17317bf16a5d0c1  Merge branch 'for-6.0-fixes' into for-next

elapsed time: 868m

configs tested: 123
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
i386                             allyesconfig
i386                                defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                           rhel-8.3-kvm
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                    rhel-8.3-kselftests
x86_64                         rhel-8.3-kunit
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
x86_64                        randconfig-a011
x86_64                        randconfig-a013
x86_64                        randconfig-a015
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
sh                          r7780mp_defconfig
sparc                       sparc64_defconfig
parisc64                            defconfig
powerpc                 canyonlands_defconfig
arm                           viper_defconfig
powerpc                    adder875_defconfig
sh                        dreamcast_defconfig
sh                   sh7770_generic_defconfig
sh                          lboxre2_defconfig
riscv                randconfig-r042-20220906
arc                  randconfig-r043-20220906
s390                 randconfig-r044-20220906
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
powerpc                mpc7448_hpc2_defconfig
alpha                               defconfig
arm                           sama5_defconfig
powerpc                     tqm8548_defconfig
i386                          randconfig-c001
csky                             alldefconfig
m68k                                defconfig
powerpc                     pq2fads_defconfig
xtensa                          iss_defconfig
arm                          iop32x_defconfig
mips                           ip32_defconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
sh                           se7750_defconfig
sparc64                          alldefconfig
arm                             ezx_defconfig
powerpc                    amigaone_defconfig
arm                        cerfcube_defconfig
sparc                            allyesconfig
sh                           se7705_defconfig
powerpc                      bamboo_defconfig
powerpc                      makalu_defconfig
arc                         haps_hs_defconfig
nios2                         10m50_defconfig
arc                          axs103_defconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
arm                         lubbock_defconfig
m68k                       m5475evb_defconfig
sh                        edosk7705_defconfig
s390                             allmodconfig
parisc                generic-32bit_defconfig
riscv             nommu_k210_sdcard_defconfig
xtensa                              defconfig
m68k                        mvme16x_defconfig
xtensa                  nommu_kc705_defconfig
loongarch                           defconfig
loongarch                         allnoconfig
sh                            titan_defconfig
sh                     sh7710voipgw_defconfig
sh                          rsk7264_defconfig
sh                 kfr2r09-romimage_defconfig
ia64                             allmodconfig
nios2                            allyesconfig
nios2                               defconfig
parisc                              defconfig
parisc                           allyesconfig

clang tested configs:
hexagon              randconfig-r041-20220906
hexagon              randconfig-r045-20220906
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
powerpc                     akebono_defconfig
powerpc                   lite5200b_defconfig
powerpc                     tqm5200_defconfig
powerpc                     mpc512x_defconfig
arm                           spitz_defconfig
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
arm                       spear13xx_defconfig
mips                      malta_kvm_defconfig
arm                    vt8500_v6_v7_defconfig
arm                     davinci_all_defconfig
x86_64                        randconfig-k001
arm                              alldefconfig
powerpc                        icon_defconfig
powerpc                      obs600_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
