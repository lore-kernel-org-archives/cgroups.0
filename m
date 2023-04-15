From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 5199604d1ee5513e1357e8cfe7243a36129b4ffb
Date: Sat, 15 Apr 2023 14:06:43 +0800
Message-ID: <643a3ef3.N+FhyvkoDKHMmyGK%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681538836; x=1713074836;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=MObnA+qLIG6+qFWr0Lx5g/Gd2tkI6nua3UZeFchNP5Y=;
  b=MZ2Mh/p6drJLP7COi0jCjSuLcmTZShMdQh9yfnTzmEMOaUv4W9MgwhHk
   G3xr/CitPgS8/MBWuPCGzZ7jRK8bfLhZMPngWFXh2HzXiRR8471Jx3fHA
   Ai8rHggoFmbyHMbSrJqUXnTOfxAKizD4z1j8YrmUH1Jww59GqSqkDV0mu
   UdVOV8EcLrn3+aFMlwat93rqiA/5il371uApFQCsB+D+/Vehobm9Ql19c
   ceLnXImP47fuGBMDmKLet3DsXeQDc0kgcoN0pLfn33HAV+HypOTKxxsnm
   2dBESXhROtbyn0+BOhpT6fEL3cBQePUf2ZUEtgl0E4BWLsSbTUniWxy5n
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 5199604d1ee5513e1357e8cfe7243a36129b4ffb  Merge branch 'for-6.4' into for-next

elapsed time: 722m

configs tested: 119
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r011-20230413   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                            hsdk_defconfig   gcc  
arc                  randconfig-r016-20230410   gcc  
arc                  randconfig-r043-20230409   gcc  
arc                  randconfig-r043-20230410   gcc  
arc                  randconfig-r043-20230412   gcc  
arc                  randconfig-r043-20230414   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                         socfpga_defconfig   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r004-20230414   clang
csky                                defconfig   gcc  
i386                             allyesconfig   gcc  
i386                         debian-10.3-func   gcc  
i386                   debian-10.3-kselftests   gcc  
i386                        debian-10.3-kunit   gcc  
i386                          debian-10.3-kvm   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230410   clang
i386                 randconfig-a002-20230410   clang
i386                 randconfig-a003-20230410   clang
i386                 randconfig-a004-20230410   clang
i386                 randconfig-a005-20230410   clang
i386                 randconfig-a006-20230410   clang
i386                 randconfig-a011-20230410   gcc  
i386                 randconfig-a012-20230410   gcc  
i386                 randconfig-a013-20230410   gcc  
i386                 randconfig-a014-20230410   gcc  
i386                 randconfig-a015-20230410   gcc  
i386                 randconfig-a016-20230410   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r013-20230409   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k                                defconfig   gcc  
m68k                        m5272c3_defconfig   gcc  
m68k                 randconfig-r011-20230412   gcc  
m68k                 randconfig-r011-20230415   gcc  
m68k                 randconfig-r013-20230412   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r014-20230413   gcc  
nios2                               defconfig   gcc  
openrisc             randconfig-r015-20230415   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r011-20230409   gcc  
parisc               randconfig-r011-20230410   gcc  
parisc               randconfig-r016-20230412   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                   microwatt_defconfig   clang
powerpc                     mpc83xx_defconfig   gcc  
powerpc                 mpc8540_ads_defconfig   gcc  
powerpc              randconfig-r014-20230412   gcc  
powerpc              randconfig-r015-20230410   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r042-20230409   gcc  
riscv                randconfig-r042-20230410   gcc  
riscv                randconfig-r042-20230412   gcc  
riscv                randconfig-r042-20230414   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r003-20230414   clang
s390                 randconfig-r044-20230409   gcc  
s390                 randconfig-r044-20230410   gcc  
s390                 randconfig-r044-20230412   gcc  
s390                 randconfig-r044-20230414   gcc  
sh                               allmodconfig   gcc  
sh                         microdev_defconfig   gcc  
sh                   randconfig-r012-20230412   gcc  
sh                   randconfig-r012-20230415   gcc  
sh                          urquell_defconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r015-20230412   gcc  
sparc                       sparc64_defconfig   gcc  
sparc64                          alldefconfig   gcc  
sparc64              randconfig-r013-20230413   gcc  
sparc64              randconfig-r013-20230415   gcc  
sparc64              randconfig-r016-20230415   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64                        randconfig-a001   clang
x86_64                        randconfig-a003   clang
x86_64                        randconfig-a005   clang
x86_64               randconfig-a011-20230410   gcc  
x86_64               randconfig-a012-20230410   gcc  
x86_64               randconfig-a013-20230410   gcc  
x86_64               randconfig-a014-20230410   gcc  
x86_64               randconfig-a015-20230410   gcc  
x86_64               randconfig-a016-20230410   gcc  
x86_64                        randconfig-k001   clang
x86_64                           rhel-8.3-bpf   gcc  
x86_64                         rhel-8.3-kunit   gcc  
x86_64                           rhel-8.3-kvm   gcc  
x86_64                           rhel-8.3-syz   gcc  
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r014-20230410   gcc  
xtensa               randconfig-r015-20230409   gcc  
xtensa               randconfig-r016-20230409   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
