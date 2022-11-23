From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 0a2cafe6c7c25597a026ab961c3182c8179c7959
Date: Wed, 23 Nov 2022 19:21:44 +0800
Message-ID: <637e0248.ePS9Lx4Pu+AW0tBS%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669202533; x=1700738533;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=9LVJzUiOSkCb1UmYVJpKLlDw71OQ1JKePXBgAQoeDyc=;
  b=hS7CPyQi9pjDkDU/lB/ksm0IRz3DJ6zJKN2ioJLWPlX8v/uh7VQnJN8Y
   H7w3gTRelSS5vIusVpadfFhIJaRyqvgwhFihhSb8XmE6gcU0L/HR80uRu
   1BTFya6H+CbEQLcab1Rc11jDf1yzObp4RWUfRAOyz7j0Doixs9Ojw74kp
   ofdMbHc7wCgpE7RxEqZMtxAiksANBDXBXOwVze/K+JZpohm9sLXfnnpG8
   z9kJyEYlCVhLZ9hd+pZDExoamDVerYAkGvDDXJJZzBJbt3jwDhO8TRvC3
   Vh7f3nVXprzCpsj8enICo18zdOWr4cly0dsFuKUmzaETZsXxd0MBr7ook
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 0a2cafe6c7c25597a026ab961c3182c8179c7959  cgroup/cpuset: Improve cpuset_css_alloc() description

elapsed time: 739m

configs tested: 91
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
powerpc                           allnoconfig
mips                             allyesconfig
sh                               allmodconfig
powerpc                          allmodconfig
um                           x86_64_defconfig
arc                                 defconfig
um                             i386_defconfig
alpha                               defconfig
s390                                defconfig
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
s390                             allmodconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
s390                             allyesconfig
x86_64                            allnoconfig
i386                             allyesconfig
i386                                defconfig
s390                 randconfig-r044-20221121
riscv                randconfig-r042-20221121
arc                  randconfig-r043-20221121
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64               randconfig-a011-20221121
x86_64               randconfig-a014-20221121
x86_64               randconfig-a012-20221121
x86_64               randconfig-a013-20221121
x86_64               randconfig-a016-20221121
x86_64               randconfig-a015-20221121
ia64                             allmodconfig
arm                           sunxi_defconfig
sh                           se7780_defconfig
sh                         ap325rxa_defconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
i386                 randconfig-a014-20221121
i386                 randconfig-a011-20221121
i386                 randconfig-a013-20221121
i386                 randconfig-a016-20221121
i386                 randconfig-a012-20221121
i386                 randconfig-a015-20221121
i386                          randconfig-c001
arm                          simpad_defconfig
powerpc                  iss476-smp_defconfig
sh                             espt_defconfig
arc                    vdk_hs38_smp_defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a004
x86_64                        randconfig-a002
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
arc                  randconfig-r043-20221120
powerpc                 mpc837x_mds_defconfig
sh                         microdev_defconfig
arc                               allnoconfig

clang tested configs:
powerpc                 mpc832x_rdb_defconfig
mips                     cu1000-neo_defconfig
powerpc                    gamecube_defconfig
i386                 randconfig-a001-20221121
i386                 randconfig-a005-20221121
i386                 randconfig-a006-20221121
i386                 randconfig-a004-20221121
i386                 randconfig-a003-20221121
i386                 randconfig-a002-20221121
x86_64               randconfig-a002-20221121
x86_64               randconfig-a001-20221121
x86_64               randconfig-a004-20221121
x86_64               randconfig-a006-20221121
x86_64               randconfig-a005-20221121
x86_64               randconfig-a003-20221121
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-k001
powerpc                     tqm5200_defconfig
powerpc                        fsp2_defconfig
powerpc                     kmeter1_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
