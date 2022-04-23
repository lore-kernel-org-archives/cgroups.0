From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 4ab93063c83a2478863158799b027e9489ad4a40
Date: Sat, 23 Apr 2022 18:40:15 +0800
Message-ID: <6263d78f.6xntrSk4EimnKTzT%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650710478; x=1682246478;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=J4AXS8euKAxd+dx8JDk7HM7t3wn0UEUnPw9FovRmlG0=;
  b=QKgXnv6HfaY0u8S/ucndyGoP6ktBkOnqADSIU/douQFcbhaQxCRoRXrR
   S6sD86kL41XnuPELLoAgpCHm3U2DgBDJwfnWJWbNubGEbpDJTN0Q00YTL
   UFMj+jOxl2tubevLBz1XWhi5wkkhD6c6DWhBhqe04UPCu90HpVnNXffqV
   rPQ7oh8sM8Of0WKkZ1MT/fsvs9LGwu4oM/2YBXQVj1tm5ls7+qQRDcjpP
   b1vXiseHJRazF/RuDH9+YuUxP/CxzrTWjiN8INZFnzuzpWdIW/iIgtfrP
   3cjtiLXW176ovjBtUMlECIY6qYir/dXeWVCw1QWhfOD2qtIW9BqLmI9vT
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 4ab93063c83a2478863158799b027e9489ad4a40  cgroup: Add test_cpucg_weight_underprovisioned() testcase

elapsed time: 926m

configs tested: 127
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                               defconfig
arm64                            allyesconfig
arm                              allmodconfig
arm                                 defconfig
arm                              allyesconfig
i386                          randconfig-c001
arm                       aspeed_g5_defconfig
sh                          rsk7201_defconfig
sparc                               defconfig
arm                        shmobile_defconfig
powerpc                       holly_defconfig
sh                        edosk7760_defconfig
powerpc                      ppc40x_defconfig
arc                          axs103_defconfig
m68k                             allyesconfig
m68k                          atari_defconfig
m68k                        m5407c3_defconfig
sh                          rsk7203_defconfig
m68k                         apollo_defconfig
arm                           sunxi_defconfig
arm                           h3600_defconfig
mips                         rt305x_defconfig
arm                         nhk8815_defconfig
xtensa                  audio_kc705_defconfig
ia64                      gensparse_defconfig
powerpc                      cm5200_defconfig
h8300                    h8300h-sim_defconfig
arm                            xcep_defconfig
sh                           se7619_defconfig
sh                           se7722_defconfig
m68k                       m5475evb_defconfig
powerpc                   currituck_defconfig
powerpc                 canyonlands_defconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220422
ia64                             allmodconfig
ia64                             allyesconfig
ia64                                defconfig
m68k                             allmodconfig
m68k                                defconfig
nios2                               defconfig
arc                              allyesconfig
csky                                defconfig
nios2                            allyesconfig
alpha                               defconfig
alpha                            allyesconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                             allmodconfig
s390                                defconfig
s390                             allyesconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
i386                             allyesconfig
sparc                            allyesconfig
i386                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a011
x86_64                        randconfig-a013
x86_64                        randconfig-a015
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
arc                  randconfig-r043-20220422
riscv                               defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
riscv                            allmodconfig
riscv                            allyesconfig
x86_64                    rhel-8.3-kselftests
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                          rhel-8.3-func
x86_64                                  kexec
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                         rhel-8.3-kunit
x86_64                               rhel-8.3

clang tested configs:
arm                        magician_defconfig
arm                  colibri_pxa300_defconfig
mips                      malta_kvm_defconfig
mips                       rbtx49xx_defconfig
mips                      maltaaprp_defconfig
arm                      tct_hammer_defconfig
riscv                    nommu_virt_defconfig
powerpc                       ebony_defconfig
powerpc                 mpc8315_rdb_defconfig
arm                         shannon_defconfig
powerpc                     ppa8548_defconfig
powerpc                 mpc832x_rdb_defconfig
powerpc                      ppc64e_defconfig
powerpc                  mpc885_ads_defconfig
arm                         socfpga_defconfig
arm                             mxs_defconfig
powerpc                     akebono_defconfig
i386                          randconfig-a006
i386                          randconfig-a002
i386                          randconfig-a004
x86_64                        randconfig-a005
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
x86_64                        randconfig-a001
x86_64                        randconfig-a003
hexagon              randconfig-r041-20220422
riscv                randconfig-r042-20220422
hexagon              randconfig-r045-20220422
s390                 randconfig-r044-20220422

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
