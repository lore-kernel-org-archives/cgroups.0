From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 1f1562fcd04a485734e94390660e741c3be47867
Date: Tue, 14 Dec 2021 17:53:15 +0800
Message-ID: <61b8698b.tjqn91st/yV26Dao%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639475642; x=1671011642;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=OFiufZCohtTxl4Ra1pTjcawk0SRVUTbt8mAJ6G5yMPk=;
  b=ZJmSbkmk/RT8IntW8D5uFkFYnKzORfyd+rf2F4IclQHMRC2yVa0sAcjf
   0Z7EiJo0aNdbkMvWWIC/4k6tdUCjgNYj+NaMVV8jLeIDPvYhaqXn8ytJq
   anG/enSI3FBn+nLXMGPUuN76Jf9tT8UyLhdKoUpwNVnH2+phoweXm4u3+
   89zcU412uxGM5V8ASb7DJK86EJnYLG2zPzagMPfJ7acxadunSXRSSo0/G
   X7RAwICfXmnckjOr7/W0/ti0MtpiYH/HDZ3lzW0XVvcfOC2uQB/3e0CwP
   zbM08+KKYbEuJRYoypGF/054iNHKTRo8niGD/djhKhWm7OL7KBtXoCWc4
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 1f1562fcd04a485734e94390660e741c3be47867  cgroup/cpuset: Don't let child cpusets restrict parent in default hierarchy

elapsed time: 728m

configs tested: 183
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
i386                 randconfig-c001-20211213
sh                          landisk_defconfig
powerpc                         wii_defconfig
powerpc                      acadia_defconfig
arm                        magician_defconfig
arm                        oxnas_v6_defconfig
arc                        vdk_hs38_defconfig
powerpc                     pq2fads_defconfig
arm                           h5000_defconfig
powerpc                 mpc837x_mds_defconfig
openrisc                 simple_smp_defconfig
arm                         hackkit_defconfig
xtensa                    xip_kc705_defconfig
mips                      bmips_stb_defconfig
sh                   secureedge5410_defconfig
sh                   sh7770_generic_defconfig
powerpc                   motionpro_defconfig
arm                       imx_v6_v7_defconfig
arm                         s5pv210_defconfig
powerpc                     taishan_defconfig
arm                     davinci_all_defconfig
powerpc                    ge_imp3a_defconfig
mips                         db1xxx_defconfig
arm                            hisi_defconfig
powerpc                  iss476-smp_defconfig
arm                          pxa3xx_defconfig
sh                           se7722_defconfig
arc                     haps_hs_smp_defconfig
mips                     decstation_defconfig
mips                          rm200_defconfig
xtensa                  audio_kc705_defconfig
mips                         tb0219_defconfig
powerpc                       ebony_defconfig
arm                        trizeps4_defconfig
mips                           gcw0_defconfig
parisc                           allyesconfig
i386                             alldefconfig
sh                         ap325rxa_defconfig
powerpc                 mpc8560_ads_defconfig
powerpc                      ppc6xx_defconfig
sh                          polaris_defconfig
mips                           mtx1_defconfig
powerpc                     ksi8560_defconfig
sh                           se7721_defconfig
powerpc                    sam440ep_defconfig
m68k                       m5208evb_defconfig
m68k                         apollo_defconfig
powerpc                       holly_defconfig
sh                              ul2_defconfig
mips                         tb0287_defconfig
arm                         vf610m4_defconfig
powerpc                   currituck_defconfig
m68k                       bvme6000_defconfig
powerpc                 canyonlands_defconfig
sh                        sh7785lcr_defconfig
arm                           sunxi_defconfig
mips                           ip22_defconfig
m68k                          hp300_defconfig
mips                          malta_defconfig
arc                          axs101_defconfig
powerpc                      obs600_defconfig
m68k                          atari_defconfig
mips                     loongson1c_defconfig
arm                            qcom_defconfig
sh                           se7724_defconfig
nds32                            alldefconfig
sh                           se7712_defconfig
m68k                        mvme147_defconfig
powerpc                     kilauea_defconfig
mips                      pic32mzda_defconfig
powerpc                     mpc512x_defconfig
m68k                          multi_defconfig
arm                  randconfig-c002-20211213
arm                  randconfig-c002-20211214
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allmodconfig
m68k                             allyesconfig
m68k                                defconfig
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
parisc                              defconfig
s390                             allyesconfig
s390                             allmodconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a001-20211214
i386                 randconfig-a002-20211214
i386                 randconfig-a005-20211214
i386                 randconfig-a003-20211214
i386                 randconfig-a006-20211214
i386                 randconfig-a004-20211214
x86_64               randconfig-a011-20211213
x86_64               randconfig-a012-20211213
x86_64               randconfig-a014-20211213
x86_64               randconfig-a013-20211213
x86_64               randconfig-a016-20211213
x86_64               randconfig-a015-20211213
i386                 randconfig-a013-20211213
i386                 randconfig-a011-20211213
i386                 randconfig-a016-20211213
i386                 randconfig-a014-20211213
i386                 randconfig-a015-20211213
i386                 randconfig-a012-20211213
arc                  randconfig-r043-20211213
riscv                randconfig-r042-20211213
s390                 randconfig-r044-20211213
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
x86_64               randconfig-c007-20211213
arm                  randconfig-c002-20211213
riscv                randconfig-c006-20211213
mips                 randconfig-c004-20211213
i386                 randconfig-c001-20211213
s390                 randconfig-c005-20211213
powerpc              randconfig-c003-20211213
x86_64               randconfig-a006-20211213
x86_64               randconfig-a005-20211213
x86_64               randconfig-a001-20211213
x86_64               randconfig-a002-20211213
x86_64               randconfig-a003-20211213
x86_64               randconfig-a004-20211213
i386                 randconfig-a001-20211213
i386                 randconfig-a002-20211213
i386                 randconfig-a005-20211213
i386                 randconfig-a003-20211213
i386                 randconfig-a006-20211213
i386                 randconfig-a004-20211213
x86_64               randconfig-a011-20211214
x86_64               randconfig-a014-20211214
x86_64               randconfig-a012-20211214
x86_64               randconfig-a013-20211214
x86_64               randconfig-a016-20211214
x86_64               randconfig-a015-20211214
i386                 randconfig-a013-20211214
i386                 randconfig-a011-20211214
i386                 randconfig-a016-20211214
i386                 randconfig-a014-20211214
i386                 randconfig-a015-20211214
i386                 randconfig-a012-20211214
hexagon              randconfig-r045-20211214
s390                 randconfig-r044-20211214
riscv                randconfig-r042-20211214
hexagon              randconfig-r041-20211214
hexagon              randconfig-r045-20211213
hexagon              randconfig-r041-20211213

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
