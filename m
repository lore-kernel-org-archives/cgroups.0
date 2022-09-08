From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.1] BUILD SUCCESS
 c478bd88362418bd2a1c230215fde184f5642e44
Date: Thu, 08 Sep 2022 12:56:03 +0800
Message-ID: <631975e3.oFmvwHAOxyeQVi6k%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662613013; x=1694149013;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=pAxkceB878k1Ay1bHZYgGAP5y0fENi0US3D3YxV+9U8=;
  b=SRN8suyqPjMsTy0mgi+Hklwkbxg3c8kE+Hm8z0ppwfjDJGM3yH4uWTp6
   XXlhtKeR/i/l66vLcYvFfvxRs6XqbNub+uPCLS7SyQ2G1EsF50g1yfbd2
   f76e+olKJm3DYiiejcOoWoV6eczeH6yi5pPUNnD+LYxQ0om7031+SgDSy
   5OcVXr4HqM8kUjBKJEz2BmUhbLFH5SPx+0OavATIRVIUyxk+L2aTjRsc+
   rEIQLBqG+h9Sq/WAoZCQxwSv33vjxi0OoMfiz2l/AdXlvueU9vJ575V7k
   kVd3RJz/Bp9kEmvt7CxUsBp79p/6j+ttgOAzDrEaaPlTrm5zBs7A6odU+
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.1
branch HEAD: c478bd88362418bd2a1c230215fde184f5642e44  cgroup/cpuset: remove unreachable code

elapsed time: 739m

configs tested: 102
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
arc                  randconfig-r043-20220907
m68k                             allmodconfig
powerpc                           allnoconfig
arc                              allyesconfig
alpha                            allyesconfig
i386                                defconfig
powerpc                          allmodconfig
x86_64                              defconfig
mips                             allyesconfig
x86_64                               rhel-8.3
x86_64                        randconfig-a013
m68k                             allyesconfig
x86_64                        randconfig-a002
x86_64                        randconfig-a011
i386                          randconfig-a001
x86_64                    rhel-8.3-kselftests
x86_64                        randconfig-a006
i386                          randconfig-a014
i386                             allyesconfig
i386                          randconfig-a003
x86_64                        randconfig-a015
sh                               allmodconfig
x86_64                           allyesconfig
arm                                 defconfig
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
i386                          randconfig-a005
x86_64                        randconfig-a004
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
i386                          randconfig-a012
i386                          randconfig-a016
csky                                defconfig
sparc                            alldefconfig
sparc                               defconfig
um                                  defconfig
sh                            titan_defconfig
arm                            mps2_defconfig
arm64                            allyesconfig
arm                              allyesconfig
ia64                          tiger_defconfig
arc                              alldefconfig
i386                             alldefconfig
powerpc                     ep8248e_defconfig
m68k                          hp300_defconfig
m68k                        m5272c3_defconfig
arm                          exynos_defconfig
sparc                             allnoconfig
arm                        cerfcube_defconfig
powerpc                      arches_defconfig
openrisc                 simple_smp_defconfig
powerpc                     asp8347_defconfig
loongarch                           defconfig
loongarch                         allnoconfig
i386                          randconfig-c001
sh                          r7785rp_defconfig
arm                          iop32x_defconfig
powerpc                     mpc83xx_defconfig
xtensa                generic_kc705_defconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
sh                     sh7710voipgw_defconfig
sh                             sh03_defconfig
sh                           se7750_defconfig
s390                             allmodconfig
xtensa                       common_defconfig
ia64                             allmodconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
sh                          r7780mp_defconfig
arm                            qcom_defconfig

clang tested configs:
hexagon              randconfig-r041-20220907
hexagon              randconfig-r045-20220907
s390                 randconfig-r044-20220907
x86_64                        randconfig-a005
riscv                randconfig-r042-20220907
x86_64                        randconfig-a001
i386                          randconfig-a013
x86_64                        randconfig-a012
i386                          randconfig-a015
i386                          randconfig-a002
x86_64                        randconfig-a003
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a006
i386                          randconfig-a011
i386                          randconfig-a004
powerpc                 mpc8315_rdb_defconfig
mips                           ip22_defconfig
powerpc                     tqm8540_defconfig
arm                           spitz_defconfig
x86_64                        randconfig-k001
powerpc                     akebono_defconfig
mips                      malta_kvm_defconfig
arm                    vt8500_v6_v7_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
