From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-6.0-fixes] BUILD SUCCESS
 df02452f3df069a59bc9e69c84435bf115cb6e37
Date: Sat, 24 Sep 2022 21:36:22 +0800
Message-ID: <632f07d6.wOmN9/MSEoj7kqpT%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664026595; x=1695562595;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=nCrDbu7FmVSlBRPBq9Wz0WAUqxzubo6uhKRiW1kZWlA=;
  b=GR5lNBHFKTgc80YazLy5eY6BooGwyFxBbBmX8k5YmVZJn+0xdr7VCQR2
   7nqKAe68htxvy78TWIfbRKZSisTa8MQ5YeBTuaiyin+JvtyoyQYDZEQXX
   hkfhUehZoyRVzAdXBsCa+B2eF90DFjyygn/PbRmHNXn1BPaSYWxctJpxC
   I2Ts2F5APX2HFitAA4fZIKGYUgVABKQGnd8XjQdn9mb6N33sKAQ5/MoIk
   8w5xcE/2l3E1vzzAqbHgmK+1bG+Tj+T5KEsE4xWWGxBCDAoCi8xnGpVCB
   zUvcUiAAdDvHX5eKhaBdj5w1J+EVch2izpczh3Nr16sVXNSxNoiC1T4Ko
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-6.0-fixes
branch HEAD: df02452f3df069a59bc9e69c84435bf115cb6e37  cgroup: cgroup_get_from_id() must check the looked-up kn is a directory

elapsed time: 1198m

configs tested: 119
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
powerpc                           allnoconfig
s390                             allyesconfig
mips                             allyesconfig
arc                                 defconfig
s390                             allmodconfig
powerpc                          allmodconfig
alpha                               defconfig
s390                                defconfig
arc                  randconfig-r043-20220923
sh                               allmodconfig
s390                 randconfig-r044-20220923
m68k                             allmodconfig
arc                              allyesconfig
riscv                randconfig-r042-20220923
alpha                            allyesconfig
m68k                             allyesconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
i386                                defconfig
x86_64                               rhel-8.3
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
x86_64                        randconfig-a002
arm                                 defconfig
x86_64                        randconfig-a004
i386                             allyesconfig
x86_64                           allyesconfig
arm64                            allyesconfig
arm                              allyesconfig
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
ia64                             allmodconfig
i386                          randconfig-a001
i386                          randconfig-a014
x86_64                        randconfig-c001
arm                  randconfig-c002-20220923
i386                          randconfig-c001
x86_64                        randconfig-a006
i386                          randconfig-a003
i386                          randconfig-a012
csky                              allnoconfig
nios2                            allyesconfig
xtensa                              defconfig
m68k                        stmark2_defconfig
i386                          randconfig-a016
i386                          randconfig-a005
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
sh                  sh7785lcr_32bit_defconfig
sh                         ap325rxa_defconfig
nios2                         10m50_defconfig
sh                          sdk7780_defconfig
m68k                         apollo_defconfig
arm                            hisi_defconfig
sh                          rsk7201_defconfig
nios2                         3c120_defconfig
loongarch                           defconfig
loongarch                         allnoconfig
loongarch                        allmodconfig
nios2                               defconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
powerpc                     tqm8555_defconfig
arc                      axs103_smp_defconfig
sh                        edosk7760_defconfig
sh                        sh7785lcr_defconfig
sparc                               defconfig
xtensa                           allyesconfig
csky                                defconfig
sparc                            allyesconfig
x86_64                                  kexec
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
arm64                               defconfig
ia64                             allyesconfig
arm                              allmodconfig
m68k                                defconfig
ia64                                defconfig
mips                             allmodconfig
powerpc                          allyesconfig
riscv                               defconfig
riscv                            allmodconfig
riscv                            allyesconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func

clang tested configs:
hexagon              randconfig-r045-20220923
hexagon              randconfig-r041-20220923
x86_64                        randconfig-a014
x86_64                        randconfig-a012
x86_64                        randconfig-a016
x86_64                        randconfig-a001
x86_64                        randconfig-a003
i386                          randconfig-a011
i386                          randconfig-a013
i386                          randconfig-a015
x86_64                        randconfig-a005
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-k001
powerpc                 mpc836x_mds_defconfig
mips                     cu1830-neo_defconfig
arm                       netwinder_defconfig
x86_64                        randconfig-c007
arm                  randconfig-c002-20220923
i386                          randconfig-c001
s390                 randconfig-c005-20220923
riscv                randconfig-c006-20220923
mips                 randconfig-c004-20220923
powerpc              randconfig-c003-20220923

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
