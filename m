From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 03db7716159477b595e9af01be8003b7e994cc79
Date: Tue, 11 Oct 2022 19:16:50 +0800
Message-ID: <634550a2.o/y75F8TcI9EWfEn%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665487046; x=1697023046;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=HwwtWoDq4wy6K6LEkAoGaoTIfiEUpw75Mm1enDNt/sw=;
  b=VSW1qs3W996YmIlGvhgqsQsGOJKW3cytr28jc+4IMa7t/3oHq1+TQxAv
   QDvDTRKWBkM4PzhDQuSedV62scPbiKN0zFqx5rrRnIL45xoUUBateGjcW
   rqTF2lKkOVzib5kMutE8glp4KMPrLPAIs4/UJ8tWUApCl1jRRi3hKGo+2
   nt4jU88aONTH3zWyQA9brrnr06Jiq0UyjOqOtJ4nOCRdcYjwAGJuN597I
   +/qk772VD46SSG5aAnGBws+DMBRZKZyL7kf/hoRzWEfdlbYEBj/+5nQzl
   jd/6XRjEf5GicuS0i/kEHfGIV8m6pIefmtp7w3na5/Ir9l/kkxI9LijhW
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 03db7716159477b595e9af01be8003b7e994cc79  Revert "cgroup: enable cgroup_get_from_file() on cgroup1"

elapsed time: 724m

configs tested: 64
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                           x86_64_defconfig
arc                  randconfig-r043-20221010
um                             i386_defconfig
arc                                 defconfig
alpha                               defconfig
s390                 randconfig-r044-20221010
riscv                randconfig-r042-20221010
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                    rhel-8.3-kselftests
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
arc                              allyesconfig
s390                                defconfig
alpha                            allyesconfig
x86_64                              defconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
s390                             allmodconfig
i386                 randconfig-a015-20221010
sh                               allmodconfig
i386                                defconfig
mips                             allyesconfig
m68k                             allmodconfig
m68k                             allyesconfig
i386                 randconfig-a016-20221010
s390                             allyesconfig
i386                 randconfig-a011-20221010
arm                                 defconfig
i386                 randconfig-a013-20221010
x86_64                               rhel-8.3
i386                 randconfig-a014-20221010
i386                 randconfig-a012-20221010
x86_64                           allyesconfig
ia64                             allmodconfig
x86_64               randconfig-a011-20221010
i386                             allyesconfig
arm64                            allyesconfig
x86_64               randconfig-a014-20221010
arm                              allyesconfig
x86_64               randconfig-a012-20221010
x86_64               randconfig-a013-20221010
x86_64               randconfig-a016-20221010
x86_64               randconfig-a015-20221010
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015

clang tested configs:
hexagon              randconfig-r045-20221010
hexagon              randconfig-r041-20221010
i386                 randconfig-a005-20221010
i386                 randconfig-a003-20221010
i386                 randconfig-a006-20221010
i386                 randconfig-a002-20221010
i386                 randconfig-a001-20221010
i386                 randconfig-a004-20221010
x86_64               randconfig-a002-20221010
x86_64               randconfig-a001-20221010
x86_64               randconfig-a004-20221010
x86_64               randconfig-a005-20221010
x86_64               randconfig-a006-20221010
x86_64               randconfig-a003-20221010
x86_64                        randconfig-a012
x86_64                        randconfig-a016
x86_64                        randconfig-a014

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
