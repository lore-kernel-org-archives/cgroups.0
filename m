From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 54b970021f92dc38f266926a31549bb88764f37d
Date: Wed, 01 Feb 2023 18:40:57 +0800
Message-ID: <63da41b9.+m+tppQCMMBI0EbB%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675248100; x=1706784100;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=53o9cuavzgsjn6igDc0NGGo4ZRr2UiYoFtrLpTaOA8Q=;
  b=HPtlWkOoDpzUGKCXGxED39MVKiR6/L3JYXwxOw+CiGz7E4t0tw7bBbo3
   vwAq4YRGIr0EZafeKHBRjJ0H44oBge88XSHRX6kr7DLamLCWOE1MBJXPC
   tGdC1QV9cYqxoxg/0/zbwhff9G7raVuJYlLh84XAXljmRRXIGwSRIq3A2
   4ZDazyxAL6oCPz3EALaOc3xE9B3Ou+68oJXNscXRv2JqoEeLJgP/9B4MD
   fi7WgPuTV41qGhXsDxDvmbMgC7FM/u5K3iEMdUuyQ0xYt/FmatekvaTns
   smyqcdNuaiB3dK7UU6ffAJXT+4nKNxuhprlAkIzYgr11W5g1yWfyv2JVO
   A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 54b970021f92dc38f266926a31549bb88764f37d  Merge branch 'for-6.2-fixes' into for-next

elapsed time: 737m

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
um                             i386_defconfig
s390                             allyesconfig
um                           x86_64_defconfig
ia64                             allmodconfig
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
x86_64                              defconfig
powerpc                           allnoconfig
x86_64                               rhel-8.3
x86_64                           allyesconfig
sh                               allmodconfig
m68k                             allmodconfig
mips                             allyesconfig
alpha                            allyesconfig
powerpc                          allmodconfig
m68k                             allyesconfig
arc                              allyesconfig
x86_64                           rhel-8.3-syz
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-bpf
x86_64               randconfig-a001-20230130
x86_64                         rhel-8.3-kunit
x86_64               randconfig-a003-20230130
x86_64               randconfig-a004-20230130
x86_64               randconfig-a002-20230130
i386                 randconfig-a002-20230130
i386                 randconfig-a001-20230130
i386                 randconfig-a003-20230130
x86_64               randconfig-a006-20230130
x86_64               randconfig-a005-20230130
arc                  randconfig-r043-20230129
i386                 randconfig-a006-20230130
arm                  randconfig-r046-20230129
i386                 randconfig-a004-20230130
i386                 randconfig-a005-20230130
arm                  randconfig-r046-20230130
arc                  randconfig-r043-20230130
i386                                defconfig
i386                             allyesconfig
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig

clang tested configs:
x86_64                          rhel-8.3-rust
hexagon              randconfig-r041-20230129
riscv                randconfig-r042-20230129
riscv                randconfig-r042-20230130
hexagon              randconfig-r045-20230130
hexagon              randconfig-r041-20230130
hexagon              randconfig-r045-20230129
s390                 randconfig-r044-20230129
s390                 randconfig-r044-20230130
i386                 randconfig-a013-20230130
i386                 randconfig-a012-20230130
i386                 randconfig-a014-20230130
i386                 randconfig-a011-20230130
i386                 randconfig-a016-20230130
i386                 randconfig-a015-20230130
x86_64               randconfig-a014-20230130
x86_64               randconfig-a013-20230130
x86_64               randconfig-a011-20230130
x86_64               randconfig-a012-20230130
x86_64               randconfig-a015-20230130
x86_64               randconfig-a016-20230130

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
