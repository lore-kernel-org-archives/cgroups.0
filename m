From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.2-fixes] BUILD SUCCESS
 e5ae8803847b80fe9d744a3174abe2b7bfed222a
Date: Wed, 01 Feb 2023 18:40:59 +0800
Message-ID: <63da41bb.2l41rZ/Q0vluO1ic%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675248124; x=1706784124;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=g6n1pzIxc/IThPSoKWzX6Ba49VHs2cTMTP6K0bCIqrw=;
  b=iAsvweJMcRHt1W0pk5jXVqKP2iezDcMrQ8Ix3ht+c3dRypviFkFOusAs
   gS27KFyse5zf/8YEMz9XTKpg9c8rwYtx6DzbddeM2DpCAif0+lKdVJSeo
   qKKAxqlZNX8zLEVKnry3P2S7AxOwLAaStLl6HrNN38AUYP4A0SbEjeBDQ
   XTB1Qj6LVAlzwKHSL6DmgEOjBuDpwDB7feHBPhx5AcuF4O/E3F/2+9+pH
   BKLy0s0XLOtBjkDO5FIRoZMTmEQ0iflQ2AyG4M3PUMfr5TzTLvzoBByJM
   DjLtyp947VB96/3EVLwDzSy4T2aqxnN/UcBq6iIslnnFb0pBXejmBm4EI
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.2-fixes
branch HEAD: e5ae8803847b80fe9d744a3174abe2b7bfed222a  cgroup/cpuset: Fix wrong check in update_parent_subparts_cpumask()

elapsed time: 738m

configs tested: 68
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                            allnoconfig
um                           x86_64_defconfig
um                             i386_defconfig
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                                defconfig
s390                             allyesconfig
ia64                             allmodconfig
alpha                            allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64               randconfig-a001-20230130
x86_64               randconfig-a003-20230130
x86_64               randconfig-a004-20230130
x86_64               randconfig-a002-20230130
arc                  randconfig-r043-20230129
arm                  randconfig-r046-20230129
x86_64               randconfig-a006-20230130
arm                  randconfig-r046-20230130
arc                  randconfig-r043-20230130
x86_64               randconfig-a005-20230130
x86_64                              defconfig
powerpc                           allnoconfig
x86_64                               rhel-8.3
sh                               allmodconfig
x86_64                           allyesconfig
i386                 randconfig-a002-20230130
i386                 randconfig-a001-20230130
mips                             allyesconfig
i386                 randconfig-a004-20230130
i386                 randconfig-a003-20230130
i386                 randconfig-a005-20230130
i386                 randconfig-a006-20230130
x86_64                           rhel-8.3-syz
x86_64                           rhel-8.3-kvm
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-bpf
i386                                defconfig
i386                             allyesconfig
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig
powerpc                          allmodconfig

clang tested configs:
x86_64                          rhel-8.3-rust
hexagon              randconfig-r041-20230129
hexagon              randconfig-r045-20230130
hexagon              randconfig-r041-20230130
hexagon              randconfig-r045-20230129
s390                 randconfig-r044-20230129
riscv                randconfig-r042-20230129
riscv                randconfig-r042-20230130
s390                 randconfig-r044-20230130
i386                 randconfig-a013-20230130
i386                 randconfig-a011-20230130
i386                 randconfig-a012-20230130
i386                 randconfig-a014-20230130
i386                 randconfig-a015-20230130
i386                 randconfig-a016-20230130
x86_64               randconfig-a013-20230130
x86_64               randconfig-a011-20230130
x86_64               randconfig-a012-20230130
x86_64               randconfig-a014-20230130
x86_64               randconfig-a015-20230130
x86_64               randconfig-a016-20230130

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
