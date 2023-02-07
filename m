From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 14fffd51f9027fd393b3b074f11bc49c16fdf990
Date: Tue, 07 Feb 2023 17:24:10 +0800
Message-ID: <63e218ba.SCYYyKVdnx2yT/JM%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675761900; x=1707297900;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=tZeg7KmC9ygFNzgU2adpRB6vGpha/V8DpA5Cu+yDEHA=;
  b=j0c/C38MQgtSRYaKTAKPy6vTsjJnR593LyW1dJpY6x396Atu7l6D7x6q
   XCga4FE/be3JLtvEVPKkqXdSfgv6dGfu9yl+qwmAtbYhXb1wIddWh7tTb
   05sZtAkopiyqobONelSzMiE9R3YrGBnWqBQJRRzzZnh64eT9XB3JEiNYb
   3RVAiCJ2cUyvey/trblhMRklFshf0X/zXBq0joxmtBQ+cteub2s7RqZpn
   11K3JoiizPUDGPxYYvcy3TFGf6TypXs0goxyeY5hj6OabxZoYFKD8rawQ
   50D6sRay2dMY7FEH4XlvKv9Rb0WQxWoAW+yYHMPgKFR9BywLbmNDdjrf1
   A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 14fffd51f9027fd393b3b074f11bc49c16fdf990  Merge branch 'for-6.2-fixes' into for-next

elapsed time: 729m

configs tested: 78
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
x86_64                            allnoconfig
arc                                 defconfig
m68k                             allmodconfig
alpha                            allyesconfig
alpha                               defconfig
arc                              allyesconfig
m68k                             allyesconfig
um                             i386_defconfig
um                           x86_64_defconfig
s390                                defconfig
ia64                             allmodconfig
s390                             allmodconfig
powerpc                           allnoconfig
s390                             allyesconfig
i386                 randconfig-a011-20230206
x86_64                           rhel-8.3-bpf
i386                 randconfig-a014-20230206
i386                 randconfig-a012-20230206
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
i386                 randconfig-a013-20230206
x86_64                           rhel-8.3-kvm
i386                 randconfig-a016-20230206
i386                 randconfig-a015-20230206
x86_64               randconfig-a014-20230206
x86_64               randconfig-a013-20230206
x86_64               randconfig-a011-20230206
x86_64               randconfig-a012-20230206
x86_64               randconfig-a015-20230206
x86_64               randconfig-a016-20230206
sh                               allmodconfig
x86_64                              defconfig
mips                             allyesconfig
x86_64                               rhel-8.3
powerpc                          allmodconfig
x86_64                           allyesconfig
riscv                randconfig-r042-20230204
arc                  randconfig-r043-20230204
arc                  randconfig-r043-20230206
s390                 randconfig-r044-20230204
riscv                randconfig-r042-20230206
s390                 randconfig-r044-20230206
arm                                 defconfig
i386                                defconfig
arm64                            allyesconfig
arm                              allyesconfig
i386                             allyesconfig
arm                            mps2_defconfig
arm                           h3600_defconfig
m68k                       bvme6000_defconfig
arm                            xcep_defconfig
powerpc                       eiger_defconfig
powerpc                      ppc6xx_defconfig
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func

clang tested configs:
x86_64               randconfig-a002-20230206
x86_64               randconfig-a004-20230206
x86_64               randconfig-a003-20230206
x86_64               randconfig-a001-20230206
i386                 randconfig-a002-20230206
i386                 randconfig-a004-20230206
i386                 randconfig-a003-20230206
x86_64               randconfig-a005-20230206
x86_64               randconfig-a006-20230206
i386                 randconfig-a001-20230206
i386                 randconfig-a005-20230206
i386                 randconfig-a006-20230206
hexagon              randconfig-r041-20230206
hexagon              randconfig-r041-20230204
arm                  randconfig-r046-20230204
arm                  randconfig-r046-20230206
hexagon              randconfig-r045-20230204
hexagon              randconfig-r045-20230206
powerpc                 mpc8315_rdb_defconfig
arm                         hackkit_defconfig
i386                              allnoconfig
powerpc                     akebono_defconfig
x86_64                          rhel-8.3-rust

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
