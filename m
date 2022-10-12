From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS WITH WARNING
 8248fe413216732f98563e8882b6c6ae617c327b
Date: Wed, 12 Oct 2022 13:58:09 +0800
Message-ID: <63465771.HuIMUTop7iDUWBQ9%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665554364; x=1697090364;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=FSmTMj7EKKSZu90bhrN2dE6B347/TX2bLtN2Z4e0N/g=;
  b=HhB5M8qItW4e9kDYvo56BWoTEOxapDUbXirQGPp2rguqT5wkMR6aGeV8
   C70EEDxUWS5gKGCbKNzPGHjHuALFc08MImZSAee5i+8SWRo++boDj6mPX
   k6ZjS/8nddHDB1Xufv0zXZRoaFBaR+RhyWdVtd0/w82Sds8WUt8YD7tMs
   WC2DEGuJrimU3sO2sGdmQzgMLvu8ee64ekW0LLuZSj3/TDdfGVnVuOeTO
   nh9iq/QJO0d0tF57KXfxfcb4LF+ow571Su/EafhoELk+J6fyekNnyBIPE
   soaMjMYeNnhnxEDghHO9uIM56HOLkJLGNu4miRlLttib+Zzz2mEHP3UUz
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 8248fe413216732f98563e8882b6c6ae617c327b  perf stat: Support old kernels for bperf cgroup counting

Warning reports:

https://lore.kernel.org/lkml/202210120440.qmxr3KCs-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Warning: (recently discovered and may have been fixed)

kernel/cgroup/cgroup.c:6765: warning: expecting prototype for cgroup_get_from_fd(). Prototype was for cgroup_v1v2_get_from_fd() instead

Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead
|-- alpha-randconfig-r026-20221012
|   `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead
|-- loongarch-allyesconfig
|   `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead
|-- m68k-allmodconfig
|   `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead
|-- m68k-randconfig-r005-20221010
|   `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead
|-- mips-allmodconfig
|   `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead
|-- openrisc-randconfig-r023-20221012
|   `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead
|-- powerpc-allmodconfig
|   `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead
|-- riscv-allyesconfig
|   `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead
`-- sparc-allyesconfig
    `-- kernel-cgroup-cgroup.c:warning:expecting-prototype-for-cgroup_get_from_fd().-Prototype-was-for-cgroup_v1v2_get_from_fd()-instead

elapsed time: 725m

configs tested: 64
configs skipped: 2

gcc tested configs:
arc                                 defconfig
alpha                               defconfig
x86_64                              defconfig
um                           x86_64_defconfig
um                             i386_defconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
s390                             allmodconfig
m68k                             allyesconfig
x86_64                               rhel-8.3
i386                                defconfig
x86_64                           rhel-8.3-syz
s390                 randconfig-r044-20221010
s390                                defconfig
riscv                randconfig-r042-20221010
arc                  randconfig-r043-20221010
x86_64                           allyesconfig
i386                 randconfig-a012-20221010
x86_64                         rhel-8.3-kunit
sh                               allmodconfig
alpha                            allyesconfig
arm                                 defconfig
x86_64               randconfig-a011-20221010
x86_64                           rhel-8.3-kvm
s390                             allyesconfig
i386                 randconfig-a011-20221010
arc                              allyesconfig
x86_64               randconfig-a014-20221010
x86_64               randconfig-a016-20221010
x86_64               randconfig-a015-20221010
m68k                             allmodconfig
x86_64               randconfig-a012-20221010
x86_64               randconfig-a013-20221010
i386                 randconfig-a013-20221010
i386                 randconfig-a014-20221010
ia64                             allmodconfig
powerpc                           allnoconfig
i386                 randconfig-a015-20221010
mips                             allyesconfig
arm                              allyesconfig
powerpc                          allmodconfig
arm64                            allyesconfig
i386                 randconfig-a016-20221010
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
i386                             allyesconfig

clang tested configs:
i386                 randconfig-a003-20221010
i386                 randconfig-a004-20221010
hexagon              randconfig-r041-20221010
i386                 randconfig-a002-20221010
hexagon              randconfig-r045-20221010
i386                 randconfig-a005-20221010
i386                 randconfig-a001-20221010
i386                 randconfig-a006-20221010
x86_64               randconfig-a002-20221010
x86_64               randconfig-a006-20221010
x86_64               randconfig-a001-20221010
x86_64               randconfig-a003-20221010
x86_64               randconfig-a004-20221010
x86_64               randconfig-a005-20221010
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
