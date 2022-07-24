From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-5.20] BUILD SUCCESS
 6a010a49b63ac8465851a79185d8deff966f8e1a
Date: Sun, 24 Jul 2022 13:13:18 +0800
Message-ID: <62dcd4ee.yQiq+Be9uu2ccqtF%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658639621; x=1690175621;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=+GBD/kwtlUB3+faJEeMz3I7wHgY2Uv5G84/vMfITpLo=;
  b=IRplb8/6QiI6YjKuIFWwzO8fzblk7uuoGmCHRNRnBgQzVMdmjjRtRlwm
   CqNZx/MSVcjrdnxBcgBeA5oRoT//YQ/MiYE6tQuGmanSYjZFpr8k0DZk+
   w/U0/QM7yt0YB/wDGbFYYXqPngwErBYPxHaW6Ox4O7Wt3YFfe/bQROBpi
   kYeQ+kYMpxg8kiJX/E1kaD7sDo9ApmjnkcnimiLFNYvOaG2cjde3DMyuk
   6z8PLKAazxvtkdi/bzuODd/mjwrWD3hoK5UVzM7A/49BcFAHHAgLEuol6
   e4CIzO9864pAmXc/w4bDMqeQz72S9CzPLEPi425c0rIZ+i8yKrN7M5boa
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.20
branch HEAD: 6a010a49b63ac8465851a79185d8deff966f8e1a  cgroup: Make !percpu threadgroup_rwsem operations optional

elapsed time: 809m

configs tested: 126
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
powerpc              randconfig-c003-20220724
i386                          randconfig-c001
sh                               alldefconfig
arm                          lpd270_defconfig
m68k                            mac_defconfig
um                                  defconfig
arm                           h5000_defconfig
mips                  decstation_64_defconfig
mips                         mpc30x_defconfig
powerpc                     pq2fads_defconfig
mips                       bmips_be_defconfig
mips                         bigsur_defconfig
sh                          rsk7269_defconfig
sh                     magicpanelr2_defconfig
sh                          r7785rp_defconfig
parisc                           alldefconfig
m68k                          amiga_defconfig
mips                 decstation_r4k_defconfig
sh                        sh7763rdp_defconfig
m68k                         amcore_defconfig
arm                            hisi_defconfig
sh                         ap325rxa_defconfig
xtensa                  nommu_kc705_defconfig
arm                           stm32_defconfig
arm                           tegra_defconfig
sh                                  defconfig
parisc                generic-64bit_defconfig
riscv                               defconfig
powerpc                 mpc837x_rdb_defconfig
mips                          rb532_defconfig
openrisc                         alldefconfig
arm                          simpad_defconfig
mips                           ci20_defconfig
sh                          kfr2r09_defconfig
powerpc                     tqm8548_defconfig
m68k                       m5208evb_defconfig
sh                            titan_defconfig
arm                            pleb_defconfig
ia64                         bigsur_defconfig
loongarch                           defconfig
parisc64                         alldefconfig
s390                                defconfig
s390                             allmodconfig
arc                                 defconfig
alpha                               defconfig
s390                             allyesconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
loongarch                         allnoconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
x86_64                        randconfig-c001
arm                  randconfig-c002-20220724
ia64                             allmodconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
sh                               allmodconfig
mips                             allyesconfig
i386                             allyesconfig
i386                                defconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
arc                  randconfig-r043-20220724
s390                 randconfig-r044-20220724
riscv                randconfig-r042-20220724
arc                  randconfig-r043-20220721
x86_64                    rhel-8.3-kselftests
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                               rhel-8.3
x86_64                           rhel-8.3-kvm
x86_64                          rhel-8.3-func
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit

clang tested configs:
mips                          malta_defconfig
powerpc                 mpc832x_mds_defconfig
arm                       mainstone_defconfig
mips                        qi_lb60_defconfig
mips                        bcm63xx_defconfig
riscv                    nommu_virt_defconfig
arm                  colibri_pxa270_defconfig
powerpc                     ppa8548_defconfig
mips                      malta_kvm_defconfig
mips                           rs90_defconfig
powerpc                   microwatt_defconfig
powerpc                 mpc8272_ads_defconfig
arm                        spear3xx_defconfig
x86_64                        randconfig-k001
x86_64                        randconfig-a005
x86_64                        randconfig-a003
x86_64                        randconfig-a001
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r041-20220724
hexagon              randconfig-r045-20220724
hexagon              randconfig-r041-20220721
hexagon              randconfig-r045-20220721
riscv                randconfig-r042-20220721
s390                 randconfig-r044-20220721

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
