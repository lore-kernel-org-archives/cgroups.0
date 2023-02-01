From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:test-merge-for-6.2-fixes] BUILD SUCCESS
 40deb00b6ec5658946b313c70b54cbce24236fda
Date: Wed, 01 Feb 2023 18:40:55 +0800
Message-ID: <63da41b7.KuNlkH6/A62SIrpj%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675248120; x=1706784120;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=lj7bYoUxEgM5E8UcuKNL+8R4gEJUEDzXv4nx8o3TFtE=;
  b=mJ3y+7yv6ANCLMLEhZlYmq68JHBz/Utvtq9zTZk7zMKZEoyRiVpzTCRm
   lnFuAOfM02g47kL4E/4WDQ0zmakB9x6O1YFp7lAgOj2LePMGdTvlzt1oU
   C8qoRWD3M6hjMlZHSZL+2YnAcb2gZdm+GxmtW3LE6tFRzb6DQvf/QrvwQ
   IS49OL/QO2X881sKV14MKBTxkZ9iwJfIqLBAj6e3ImN1Vzg63lKIMoF/N
   7KHcvM6WHznbnapffq46mssvboACNVF4L7tm3ILG9Nd87J4XsLJudRhcs
   QV9c78DgNmu4Odu5rtKAaKzU6AP1X1A+aCS+rxzqhC6e+yH2R4bsxw4Ok
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-for-6.2-fixes
branch HEAD: 40deb00b6ec5658946b313c70b54cbce24236fda  Merge branch 'for-6.2-fixes' into test-merge-for-6.2-fixes

elapsed time: 736m

configs tested: 68
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                            allnoconfig
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                                defconfig
s390                             allyesconfig
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
ia64                             allmodconfig
x86_64                          rhel-8.3-func
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64               randconfig-a001-20230130
x86_64               randconfig-a003-20230130
x86_64               randconfig-a004-20230130
x86_64               randconfig-a002-20230130
x86_64               randconfig-a006-20230130
x86_64               randconfig-a005-20230130
powerpc                           allnoconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
x86_64                           allyesconfig
alpha                            allyesconfig
sh                               allmodconfig
mips                             allyesconfig
powerpc                          allmodconfig
i386                 randconfig-a002-20230130
i386                 randconfig-a001-20230130
i386                 randconfig-a004-20230130
i386                 randconfig-a003-20230130
i386                 randconfig-a005-20230130
i386                 randconfig-a006-20230130
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-bpf
arc                  randconfig-r043-20230129
arm                  randconfig-r046-20230129
arm                  randconfig-r046-20230130
arc                  randconfig-r043-20230130
i386                                defconfig
i386                             allyesconfig
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig

clang tested configs:
x86_64                          rhel-8.3-rust
hexagon              randconfig-r041-20230129
i386                 randconfig-a013-20230130
riscv                randconfig-r042-20230129
i386                 randconfig-a012-20230130
i386                 randconfig-a014-20230130
i386                 randconfig-a011-20230130
riscv                randconfig-r042-20230130
hexagon              randconfig-r045-20230130
hexagon              randconfig-r041-20230130
hexagon              randconfig-r045-20230129
i386                 randconfig-a015-20230130
i386                 randconfig-a016-20230130
s390                 randconfig-r044-20230129
s390                 randconfig-r044-20230130
x86_64                        randconfig-a014
x86_64                        randconfig-a012
x86_64                        randconfig-a016

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
