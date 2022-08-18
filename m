From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.0-fixes] BUILD SUCCESS
 4f7e7236435ca0abe005c674ebd6892c6e83aeb3
Date: Thu, 18 Aug 2022 13:47:32 +0800
Message-ID: <62fdd274.QjonNlmiFOqWNsux%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660801712; x=1692337712;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=UjqwlFoJPGJ3vP6eEhtndfd/Jlg91tFLIqFswAULmfs=;
  b=EJxBLO6lXR62JeBGd/ODqGqGlm7nU7r8yo7KSw3JpX5r4o4mQ+lrFumj
   ze3dTZYlTPrZyKVcyj0K8W9TMKT85vUmoJ4Zw+coRXd7ZKgYgpClNOyln
   Z9Uz7ZmRnqvnM3OxNGoUDefRng7AfEBuQjIkgXIev6YWBLXunGJW/RTIH
   3cCU/wZPc/U6VMSxhHguK6eHJKD/MQWUp8gK0sEDIshBEeCkfrL5Pglf3
   wfLJ2OYSO2MWI+V2zJ0kJYNmYWrAHnBhFfdbJveVKoLX3siC+c3XWwRau
   oHBv70WX1xch+UTZijlc8vYTXLCppz/9SkrHNS0TkObSQ+1ckiZPW3CN/
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.0-fixes
branch HEAD: 4f7e7236435ca0abe005c674ebd6892c6e83aeb3  cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

elapsed time: 723m

configs tested: 78
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                           rhel-8.3-kvm
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests
arc                              allyesconfig
x86_64                           rhel-8.3-syz
alpha                            allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
um                           x86_64_defconfig
um                             i386_defconfig
powerpc                          allmodconfig
mips                             allyesconfig
powerpc                           allnoconfig
i386                                defconfig
arc                  randconfig-r043-20220818
x86_64                        randconfig-a013
s390                 randconfig-r044-20220818
x86_64                        randconfig-a011
riscv                randconfig-r042-20220818
x86_64                        randconfig-a004
x86_64                        randconfig-a002
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
sh                               allmodconfig
x86_64                        randconfig-a015
x86_64                        randconfig-a006
x86_64                              defconfig
i386                          randconfig-a001
x86_64                               rhel-8.3
i386                             allyesconfig
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                           allyesconfig
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
arm                             pxa_defconfig
powerpc                      ppc40x_defconfig
powerpc                      mgcoge_defconfig
powerpc                      cm5200_defconfig
i386                          randconfig-c001
arc                          axs101_defconfig
sh                   rts7751r2dplus_defconfig
powerpc                 mpc837x_mds_defconfig
powerpc                       maple_defconfig
alpha                            alldefconfig
mips                      loongson3_defconfig
sh                          polaris_defconfig
arc                          axs103_defconfig
sh                        edosk7705_defconfig
arm                          pxa3xx_defconfig
mips                           ip32_defconfig
arm                            xcep_defconfig
sh                               alldefconfig
loongarch                           defconfig
loongarch                         allnoconfig

clang tested configs:
hexagon              randconfig-r041-20220818
hexagon              randconfig-r045-20220818
x86_64                        randconfig-a012
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a016
x86_64                        randconfig-a014
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
powerpc                 xes_mpc85xx_defconfig
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
