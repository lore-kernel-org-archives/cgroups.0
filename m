From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 cdf56564f9fe3638407014a830f3c762d126d4bc
Date: Sun, 25 Sep 2022 04:12:31 +0800
Message-ID: <632f64af.3IKw0Hdo/G2kPymG%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664050382; x=1695586382;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=U+bIEEkIfNCoeP/hr6ZQOjzkdg8ynhrDiqTk+PM9l0o=;
  b=P8PXCE4aYpMJw+yfXJ3xHgPmqJ58+Eegu1RCLTZXZ2S34HpU/pGEstQm
   XRcQUztrlo4k0ED3GnduB33PkEnxxMoEXCP7+ipHVh/D4z5D78D5SAjfa
   Vd5qjEQzmO4heHGj5C74iiSty1Yy27O93PcV5p4n318wccVuiu9ihPWW/
   vwMUNeCqGpiQ3BISvQ5QsR5rJtsVTfGq2J2vqnR8d2OpEVdOYlgHavu9P
   P7rTkjnn/9vvxIQSRwHVxJq155MEYcycnNm0f361LS5f5UVme6QwSmC5i
   5UhyrPh3SZDDFmvN+IOsCYFn+XEoW1a1e/S58qiQo+vlZWjJaabu5NiQS
   A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: cdf56564f9fe3638407014a830f3c762d126d4bc  Merge branch 'for-6.1' into for-next

elapsed time: 997m

configs tested: 61
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                             allyesconfig
x86_64                          rhel-8.3-func
s390                                defconfig
x86_64                    rhel-8.3-kselftests
arc                  randconfig-r043-20220923
x86_64                              defconfig
x86_64                           allyesconfig
s390                 randconfig-r044-20220923
arc                              allyesconfig
x86_64                               rhel-8.3
riscv                randconfig-r042-20220923
alpha                            allyesconfig
powerpc                           allnoconfig
m68k                             allyesconfig
powerpc                          allmodconfig
m68k                             allmodconfig
mips                             allyesconfig
x86_64                        randconfig-a004
sh                               allmodconfig
i386                          randconfig-a001
x86_64                        randconfig-a002
i386                          randconfig-a003
i386                                defconfig
x86_64                        randconfig-a006
arm                                 defconfig
x86_64                        randconfig-a013
i386                          randconfig-a005
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                             allyesconfig
i386                          randconfig-a014
i386                          randconfig-a012
arm                              allyesconfig
arm64                            allyesconfig
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
x86_64                        randconfig-a005
x86_64                        randconfig-a001
i386                          randconfig-a002
x86_64                        randconfig-a003
i386                          randconfig-a004
x86_64                        randconfig-a012
i386                          randconfig-a006
x86_64                        randconfig-a016
x86_64                        randconfig-a014
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
