From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 32a47817d07557ffca9992964c514fd79bda6fba
Date: Wed, 11 Jan 2023 18:32:02 +0800
Message-ID: <63be9022.dV2GuG+zKzioP4xX%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673433176; x=1704969176;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=VweBvKjHJD+r5ZR2MO5op5fuxLWkKhRPAyTdeyT7nFc=;
  b=fvz9ngN1hN1IN8m10z0ToLKtY1cjmVM5pyzSO2Pn5ql86dvMZ/BJyjRU
   qkkxdxG7M1Pb/CDDqU/ergRhq8RPNlqxKK27ycLFbvfM+wpN4s5LXsr3C
   vsA3mjn+E2JIwDiiAbBvMn1ISzApvUojzbRk5HYX65eXnzaa0YrARo4cj
   Hv4LHdDma6lx/21/UA/AnQgpHaWKfwoOl/SycHBu0YI2waqY3qRAxY33L
   RGqlzuUyl+Xbfxylu+UFQdCkb7VxBDmBaNho6Rj4Cz78M62PDY3Fr+qLF
   Ki6MkHg7DSR5lwbRK7hfeFBdfnS1K1QUuZybOn0v3am8K0Ch/JzbdhaM1
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 32a47817d07557ffca9992964c514fd79bda6fba  cgroup/cpuset: fix a few kernel-doc warnings & coding style

elapsed time: 720m

configs tested: 66
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                                defconfig
powerpc                           allnoconfig
s390                             allyesconfig
x86_64                            allnoconfig
m68k                             allmodconfig
alpha                            allyesconfig
m68k                             allyesconfig
arc                              allyesconfig
arc                  randconfig-r043-20230110
s390                 randconfig-r044-20230110
riscv                randconfig-r042-20230110
sh                               allmodconfig
x86_64                           rhel-8.3-bpf
x86_64                           rhel-8.3-syz
ia64                             allmodconfig
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
mips                             allyesconfig
um                           x86_64_defconfig
um                             i386_defconfig
i386                                defconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
powerpc                          allmodconfig
x86_64                              defconfig
i386                          randconfig-a001
i386                          randconfig-a005
i386                          randconfig-a003
x86_64                               rhel-8.3
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
i386                             allyesconfig
x86_64                        randconfig-a015
x86_64                           allyesconfig
x86_64                        randconfig-a013
x86_64                        randconfig-a011
arm                                 defconfig
arm64                            allyesconfig
arm                              allyesconfig
i386                          randconfig-a016
i386                          randconfig-a014
i386                          randconfig-a012

clang tested configs:
arm                  randconfig-r046-20230110
hexagon              randconfig-r045-20230110
hexagon              randconfig-r041-20230110
x86_64                          rhel-8.3-rust
i386                          randconfig-a002
i386                          randconfig-a004
x86_64                        randconfig-a001
i386                          randconfig-a006
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a012
riscv                randconfig-r042-20230111
s390                 randconfig-r044-20230111
hexagon              randconfig-r041-20230111
hexagon              randconfig-r045-20230111
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
