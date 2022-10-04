From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:test-merge-for-6.1] BUILD SUCCESS
 99996071fa0f2cbf22697f6e82014ecb15a53b2a
Date: Tue, 04 Oct 2022 15:19:09 +0800
Message-ID: <633bde6d.XLJnwp9n9pOAEuvu%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664867970; x=1696403970;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Dua2vkeJXhGD2pJC42kY/gAtbX8tYNywuN+EFBVnfbs=;
  b=jgIKnvarQYglAFh8SumrHxja2WGUxGf0nqcUp7lXXeDLrpl8J0edaCx1
   yAeABAVjydNeJgaEbYpy3Y7GLw5mMqkVGUXlMMkHPafMcX0KnDwNIpy3F
   ojmc5GYL0XJafZe+rlAd5JtQVFP32iV3i866mdm38Ct7VGefPNYrnqyWy
   f7GAEBi81+GyYbQkWCUjuVwUmgmkCipuBo+4idic+DGVJ1wzl/TWGmN/c
   t9WZC02uU6k0Tj2mt5nP+5UoKM4+LfvcjkLIihk2J72AF28cigyQQSygM
   dzkQH2t3FTeEJrkjD2pRhKHV691/NxdotwinN0z74wMVB5W2fJCxA6Vt3
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-for-6.1
branch HEAD: 99996071fa0f2cbf22697f6e82014ecb15a53b2a  Merge branch 'for-6.1' into test-merge-for-6.1

elapsed time: 743m

configs tested: 63
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
arc                                 defconfig
s390                             allmodconfig
x86_64                           rhel-8.3-syz
alpha                               defconfig
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
s390                                defconfig
riscv                randconfig-r042-20221003
s390                             allyesconfig
arc                  randconfig-r043-20221003
s390                 randconfig-r044-20221003
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
x86_64                              defconfig
x86_64                               rhel-8.3
sh                               allmodconfig
x86_64                           allyesconfig
x86_64                          rhel-8.3-func
i386                 randconfig-a015-20221003
x86_64                    rhel-8.3-kselftests
arm                                 defconfig
i386                 randconfig-a016-20221003
m68k                             allmodconfig
i386                                defconfig
i386                 randconfig-a014-20221003
i386                 randconfig-a011-20221003
arc                              allyesconfig
i386                 randconfig-a012-20221003
i386                 randconfig-a013-20221003
alpha                            allyesconfig
m68k                             allyesconfig
arm64                            allyesconfig
arm                              allyesconfig
i386                             allyesconfig
x86_64               randconfig-a011-20221003
x86_64               randconfig-a012-20221003
x86_64               randconfig-a013-20221003
x86_64               randconfig-a015-20221003
x86_64               randconfig-a014-20221003
x86_64               randconfig-a016-20221003
arc                  randconfig-r043-20221002
ia64                             allmodconfig

clang tested configs:
hexagon              randconfig-r045-20221003
hexagon              randconfig-r041-20221003
i386                 randconfig-a003-20221003
i386                 randconfig-a002-20221003
i386                 randconfig-a001-20221003
i386                 randconfig-a004-20221003
i386                 randconfig-a005-20221003
i386                 randconfig-a006-20221003
x86_64               randconfig-a003-20221003
x86_64               randconfig-a002-20221003
x86_64               randconfig-a001-20221003
x86_64               randconfig-a004-20221003
x86_64               randconfig-a005-20221003
x86_64               randconfig-a006-20221003
hexagon              randconfig-r041-20221002
hexagon              randconfig-r045-20221002
riscv                randconfig-r042-20221002
s390                 randconfig-r044-20221002

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
