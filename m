From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 48da2ddc4c785b908364be6e37eff1f55c189579
Date: Fri, 04 Feb 2022 12:59:22 +0800
Message-ID: <61fcb2aa.5fSSlrHwALb5sh1Q%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643950798; x=1675486798;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=l0NtKdegugXGI6z/G98c+q6POOYIzyo19ClDlNsQLBQ=;
  b=Ku0p31R/SEnUXu4eZNSll3TX3LXz3nnvNXu1PJRyVIUF58OfflGZnNQU
   ofV4t5l7zLzouxxAHhcDlHF8H/2oDj5yzc8VP5RXb90FxcAn9gzHJJAS0
   PN6FngOUbEt6AZUI7SIFm/dYncHsKBHy8PZjxnIGfmb6ejPNVJ3DV3Vmq
   jN/CwMF4pClF0LmXGcOcD3MW9d12BpiBjwdCAWUVGfJBjxBpjmpUtl+1m
   sHXAzYxpyLKLZUyL8sKfmmel7Gmj3fqk6/RbnTt7LLowIURHiiVOYxC/Q
   3FsRCHAnRZMyMj38K1uUYXMMHxHDdD5jrbxququS51vt9pks//gdrmLLW
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 48da2ddc4c785b908364be6e37eff1f55c189579  Merge branch 'for-5.17-fixes' into for-next

elapsed time: 723m

configs tested: 171
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20220131
i386                          randconfig-c001
arm                        clps711x_defconfig
powerpc                 linkstation_defconfig
mips                            ar7_defconfig
powerpc                     rainier_defconfig
arm                           h5000_defconfig
ia64                         bigsur_defconfig
sh                   secureedge5410_defconfig
arc                        nsim_700_defconfig
mips                           ci20_defconfig
sh                           se7750_defconfig
sh                         microdev_defconfig
arc                            hsdk_defconfig
arm                         vf610m4_defconfig
parisc                           allyesconfig
arc                          axs101_defconfig
arm                            mps2_defconfig
arm                           sunxi_defconfig
sparc                            allyesconfig
powerpc                     mpc83xx_defconfig
powerpc                     stx_gp3_defconfig
mips                         bigsur_defconfig
powerpc                   currituck_defconfig
powerpc                     tqm8548_defconfig
powerpc                 canyonlands_defconfig
powerpc                      ep88xc_defconfig
arm                         lubbock_defconfig
mips                          rb532_defconfig
powerpc                      ppc40x_defconfig
sh                   rts7751r2dplus_defconfig
sh                           se7206_defconfig
nds32                               defconfig
arm                            qcom_defconfig
powerpc                     pq2fads_defconfig
m68k                            q40_defconfig
sh                              ul2_defconfig
s390                       zfcpdump_defconfig
sh                          lboxre2_defconfig
arc                 nsimosci_hs_smp_defconfig
sh                ecovec24-romimage_defconfig
m68k                       m5249evb_defconfig
arm                             rpc_defconfig
arm                             pxa_defconfig
sh                             espt_defconfig
mips                           ip32_defconfig
microblaze                      mmu_defconfig
xtensa                           allyesconfig
mips                    maltaup_xpa_defconfig
openrisc                 simple_smp_defconfig
nios2                         10m50_defconfig
um                                  defconfig
arm                         nhk8815_defconfig
arm                  randconfig-c002-20220130
arm                  randconfig-c002-20220131
arm                  randconfig-c002-20220202
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
nios2                               defconfig
arc                              allyesconfig
nds32                             allnoconfig
nios2                            allyesconfig
csky                                defconfig
alpha                               defconfig
alpha                            allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
parisc                              defconfig
s390                             allmodconfig
s390                                defconfig
s390                             allyesconfig
i386                             allyesconfig
sparc                               defconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a004-20220131
x86_64               randconfig-a003-20220131
x86_64               randconfig-a001-20220131
x86_64               randconfig-a006-20220131
x86_64               randconfig-a005-20220131
x86_64               randconfig-a002-20220131
i386                 randconfig-a006-20220131
i386                 randconfig-a005-20220131
i386                 randconfig-a003-20220131
i386                 randconfig-a002-20220131
i386                 randconfig-a001-20220131
i386                 randconfig-a004-20220131
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
riscv                randconfig-r042-20220130
arc                  randconfig-r043-20220130
s390                 randconfig-r044-20220130
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
riscv                randconfig-c006-20220201
x86_64                        randconfig-c007
powerpc              randconfig-c003-20220201
mips                 randconfig-c004-20220201
i386                          randconfig-c001
arm                  randconfig-c002-20220201
riscv                randconfig-c006-20220130
arm                  randconfig-c002-20220130
powerpc              randconfig-c003-20220130
mips                 randconfig-c004-20220130
arm                       imx_v4_v5_defconfig
powerpc                     ppa8548_defconfig
arm                         socfpga_defconfig
powerpc                          allyesconfig
powerpc               mpc834x_itxgp_defconfig
arm                  colibri_pxa270_defconfig
x86_64                           allyesconfig
mips                          rm200_defconfig
arm                             mxs_defconfig
powerpc                   lite5200b_defconfig
arm                         shannon_defconfig
powerpc                     tqm5200_defconfig
arm                           sama7_defconfig
arm                       spear13xx_defconfig
mips                          ath79_defconfig
mips                        workpad_defconfig
powerpc                        icon_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64               randconfig-a013-20220131
x86_64               randconfig-a015-20220131
x86_64               randconfig-a014-20220131
x86_64               randconfig-a016-20220131
x86_64               randconfig-a011-20220131
x86_64               randconfig-a012-20220131
i386                 randconfig-a011-20220131
i386                 randconfig-a013-20220131
i386                 randconfig-a014-20220131
i386                 randconfig-a012-20220131
i386                 randconfig-a015-20220131
i386                 randconfig-a016-20220131
i386                          randconfig-a011
i386                          randconfig-a013
i386                          randconfig-a015
riscv                randconfig-r042-20220131
hexagon              randconfig-r045-20220130
hexagon              randconfig-r045-20220131
hexagon              randconfig-r041-20220130
hexagon              randconfig-r041-20220131
s390                 randconfig-r044-20220131

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
