From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.0-fixes] BUILD SUCCESS
 43626dade36fa74d3329046f4ae2d7fdefe401c6
Date: Sat, 27 Aug 2022 17:58:44 +0800
Message-ID: <6309ead4.11qVq4/6yiiXTFXB%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661594330; x=1693130330;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=g+pq9O4tYvwUt4bIztHA7XCzl8kWPhKRSrK65k+vHk4=;
  b=EnxWvHufeoStfma/gr1h08p3AuA0XPWKjHWxvQw6ane8QUkZalgqqQ2h
   rcPsxaYSdoKaWC1OlgcPkMni0UphSY3a7APTeOwyOO0FYgnPNJgHNhjpY
   I+9wuUoKRahEs+zFJlxmb3nfIwMoE3AmpF3WZqBoQwSQ497Wb/WL8SS5C
   jOTc+nxeNBv40+7PmScc05/dvx4Y5zfvQQeWNi++QnxHKTMA4E79Wo0+T
   QBkLp8lLTsM1e2gYxIBEWcnjt2KDQZHum5WtWs4CQqSrUJgS4QoJpXZ9F
   aqLLlZkGCm7Vf2/GSNZDjLv1U/xUev/SbEOwl7Ki73WPj2nPKnm7N22qg
   A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.0-fixes
branch HEAD: 43626dade36fa74d3329046f4ae2d7fdefe401c6  cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

elapsed time: 724m

configs tested: 121
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
loongarch                         allnoconfig
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
um                             i386_defconfig
i386                                defconfig
um                           x86_64_defconfig
s390                                defconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
loongarch                           defconfig
mips                             allyesconfig
sh                               allmodconfig
x86_64                              defconfig
x86_64                        randconfig-a004
s390                             allyesconfig
x86_64                        randconfig-a002
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit
x86_64                           allyesconfig
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a006
arm                                 defconfig
x86_64                        randconfig-a015
x86_64                           rhel-8.3-kvm
x86_64                    rhel-8.3-kselftests
parisc                              defconfig
arc                              allyesconfig
x86_64                           rhel-8.3-syz
arm                              allyesconfig
nios2                               defconfig
alpha                            allyesconfig
nios2                            allyesconfig
i386                             allyesconfig
m68k                             allyesconfig
arc                  randconfig-r043-20220824
m68k                             allmodconfig
arm64                            allyesconfig
riscv                randconfig-r042-20220824
s390                 randconfig-r044-20220826
s390                 randconfig-r044-20220824
riscv                randconfig-r042-20220826
i386                          randconfig-a001
arc                  randconfig-r043-20220826
i386                          randconfig-a003
arc                  randconfig-r043-20220825
i386                          randconfig-a005
parisc64                            defconfig
parisc                           allyesconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
powerpc                          allyesconfig
riscv                               defconfig
riscv                            allmodconfig
riscv                            allyesconfig
sh                          rsk7203_defconfig
parisc                generic-32bit_defconfig
arm                            xcep_defconfig
openrisc                  or1klitex_defconfig
ia64                            zx1_defconfig
i386                          randconfig-c001
sparc                               defconfig
xtensa                           allyesconfig
csky                                defconfig
sparc                            allyesconfig
x86_64                                  kexec
ia64                             allmodconfig
arm64                               defconfig
arm                              allmodconfig
m68k                                defconfig
ia64                                defconfig
mips                             allmodconfig

clang tested configs:
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
x86_64                        randconfig-a014
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a016
x86_64                        randconfig-a012
x86_64                        randconfig-a003
hexagon              randconfig-r041-20220825
hexagon              randconfig-r045-20220825
hexagon              randconfig-r041-20220824
hexagon              randconfig-r045-20220824
hexagon              randconfig-r045-20220826
hexagon              randconfig-r041-20220826
riscv                randconfig-r042-20220825
s390                 randconfig-r044-20220825
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
hexagon              randconfig-r045-20220827
riscv                randconfig-r042-20220827
hexagon              randconfig-r041-20220827
s390                 randconfig-r044-20220827
powerpc                      obs600_defconfig
arm                                 defconfig
arm                         bcm2835_defconfig
x86_64                        randconfig-k001
arm                           sama7_defconfig
riscv                            alldefconfig
arm                         mv78xx0_defconfig
hexagon              randconfig-r045-20220823
riscv                randconfig-r042-20220823
hexagon              randconfig-r041-20220823
s390                 randconfig-r044-20220823

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
