From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.1] BUILD SUCCESS
 b74440d89895816660236be4433f0891e37d44eb
Date: Sun, 25 Sep 2022 03:54:02 +0800
Message-ID: <632f605a.cnBa0LmDhXlAn4LY%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664049295; x=1695585295;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=O0R0FiEG4FP7J+K98C0IyrgS0VpqWjwZzP/fC0s/q0o=;
  b=Lnu3gVQ5b7/CN6tCOBnD0iq37bCakRmnXCvNj0hBTHu0LY+kXIfohSMg
   H0pT6fY1KW0771mJ6vtSTX8cN+oMPYMUSAfCSIEUFUI5CKW0w/i0yNL7B
   maQaJNy1IEC0XNCI+YD6sLt1l2qWAppL5wNf0EOhaKP9h4X0bgM4PyL65
   xBB/rIIgJB9rZ5+AeoeJkP1IBBmZrciNHo6fRa+A5jcvQ6aLacv2g9Kcc
   TQkYeIjpNBwZXwueFuhfI3Ik5yEUGpgAQm78OOoWvBm3O7H9uFgk/W2bq
   wsSdTSWHyP7vcchlee4pInpFLeCGHx+oXS2q2agvTvRpo95jGd54KJKyD
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.1
branch HEAD: b74440d89895816660236be4433f0891e37d44eb  iocost_monitor: reorder BlkgIterator

elapsed time: 979m

configs tested: 61
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
alpha                               defconfig
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
s390                                defconfig
s390                             allmodconfig
powerpc                          allmodconfig
mips                             allyesconfig
x86_64                              defconfig
powerpc                           allnoconfig
sh                               allmodconfig
s390                             allyesconfig
x86_64                               rhel-8.3
arc                  randconfig-r043-20220923
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a013
s390                 randconfig-r044-20220923
x86_64                        randconfig-a006
riscv                randconfig-r042-20220923
x86_64                        randconfig-a011
m68k                             allmodconfig
x86_64                           allyesconfig
i386                          randconfig-a001
i386                                defconfig
x86_64                        randconfig-a015
i386                          randconfig-a003
arc                              allyesconfig
arm                                 defconfig
alpha                            allyesconfig
m68k                             allyesconfig
i386                          randconfig-a005
arm64                            allyesconfig
arm                              allyesconfig
i386                             allyesconfig
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
ia64                             allmodconfig
riscv                randconfig-r042-20220925
arc                  randconfig-r043-20220925
s390                 randconfig-r044-20220925
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm

clang tested configs:
hexagon              randconfig-r045-20220923
hexagon              randconfig-r041-20220923
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a012
x86_64                        randconfig-a005
x86_64                        randconfig-a016
x86_64                        randconfig-a014
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
