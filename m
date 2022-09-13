From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:cgroup-driver_core-for-v6.1] BUILD SUCCESS
 ee244c732790b535e1435e4e8ad4a63eff5b62ca
Date: Tue, 13 Sep 2022 19:18:37 +0800
Message-ID: <6320670d.USwV3o2zrygqg8WL%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663067963; x=1694603963;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=VuzEZYW6Pt0tQoB2D48o2CtKMKmaBmwAd0vC/OxLbQg=;
  b=jYbYfjEnQ65CHoqsTCrBBP5WbPRKvx1/LEZwaO7BXlSN6bf55bS5iyY3
   4/Mcqq0sZ264GjeHk3IPt3Kh5RH2phzfcjgc+t8MXBJ7Pou8WLMcMqBGm
   7wzKfCDxf3+Emv5MYxm0A1gCOyVlPvdf4N0ex247xU23LxLAnmp+mrxLV
   E2Yy71vf4c/LfLMaWxzB3Jg+8u+CdgSgdZ16oJdK4rK8Nb9bRjRFXqeIm
   tLj+GwZsdFeogFS9ims78bXSHyqVWD0tAMIfHsfr2Ailx7BfWZNVsgYIa
   CzY7/UCebbCNAZvjuBehT/S+SvV2dDJE36ytpNlbWg0/lLOpzlDHgTw71
   A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-driver_core-for-v6.1
branch HEAD: ee244c732790b535e1435e4e8ad4a63eff5b62ca  Merge branch 'driver-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core into cgroup-driver_core-for-v6.1

elapsed time: 732m

configs tested: 58
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                              defconfig
riscv                randconfig-r042-20220911
arc                  randconfig-r043-20220912
arc                  randconfig-r043-20220911
powerpc                           allnoconfig
i386                 randconfig-a001-20220912
i386                 randconfig-a002-20220912
s390                 randconfig-r044-20220911
i386                 randconfig-a004-20220912
i386                 randconfig-a003-20220912
x86_64                               rhel-8.3
i386                 randconfig-a006-20220912
i386                 randconfig-a005-20220912
arc                              allyesconfig
i386                                defconfig
x86_64                           rhel-8.3-kvm
alpha                            allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
m68k                             allmodconfig
x86_64                           rhel-8.3-syz
sh                               allmodconfig
mips                             allyesconfig
m68k                             allyesconfig
x86_64               randconfig-a001-20220912
powerpc                          allmodconfig
arm                                 defconfig
x86_64                           allyesconfig
x86_64               randconfig-a006-20220912
x86_64               randconfig-a004-20220912
x86_64               randconfig-a002-20220912
arm                              allyesconfig
i386                             allyesconfig
x86_64               randconfig-a005-20220912
x86_64               randconfig-a003-20220912
arm64                            allyesconfig
ia64                             allmodconfig

clang tested configs:
hexagon              randconfig-r041-20220912
hexagon              randconfig-r045-20220911
hexagon              randconfig-r041-20220911
hexagon              randconfig-r045-20220912
s390                 randconfig-r044-20220912
riscv                randconfig-r042-20220912
i386                 randconfig-a014-20220912
i386                 randconfig-a015-20220912
i386                 randconfig-a013-20220912
i386                 randconfig-a016-20220912
i386                 randconfig-a011-20220912
i386                 randconfig-a012-20220912
x86_64               randconfig-a011-20220912
x86_64               randconfig-a012-20220912
x86_64               randconfig-a013-20220912
x86_64               randconfig-a014-20220912
x86_64               randconfig-a016-20220912
x86_64               randconfig-a015-20220912

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
