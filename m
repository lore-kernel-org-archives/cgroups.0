From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 a3fdeeb3f1c1fad3b7b07aa96a7e422fde3c2c15
Date: Sat, 22 Jul 2023 17:26:21 +0800
Message-ID: <202307221719.nAJ25wyg-lkp@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690018097; x=1721554097;
  h=date:from:to:cc:subject:message-id;
  bh=jUvJFyjqxIXL1l2xtdYEqopTLc3bjd1qeXeM4VuTEC8=;
  b=U7g4WafIaK3m71dbH3XlB4vikAFiDQ00H/Q/B60Mo3usAegGhvNjkJDi
   3WGUDLlkIvXlsFQyoe01Z6LaG0w+WADzCaOtcnx5eOjEhrv23tVkAafzI
   pomm4M9YCa0+SaLNrrJyq3Xzwuxyadx2EhIF+mu0jC/IUHWs5kGNnYXPJ
   exjtLt+Q+orur/qBfEDqWjhPrTnTZg8/hHLyu0R2W02HnOEkXgGDJpusD
   0js6ZN3O63n/4xblECPu7KL8D9982tUghoK/uqk5epZcFSAuHxWyIgrQ7
   cG+GFoy3VpIFxiSPwo4N0y/dGS4lf8EIUQZ5CwxVIOrgC+laaoQrK1xjC
   g==;
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: a3fdeeb3f1c1fad3b7b07aa96a7e422fde3c2c15  cgroup: fix obsolete comment above cgroup_create()

elapsed time: 727m

configs tested: 125
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r001-20230720   gcc  
alpha                randconfig-r014-20230720   gcc  
alpha                randconfig-r021-20230720   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r043-20230720   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                  randconfig-r031-20230720   clang
arm                  randconfig-r033-20230720   clang
arm                  randconfig-r046-20230720   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r003-20230720   gcc  
arm64                randconfig-r022-20230720   clang
arm64                randconfig-r032-20230720   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r004-20230720   gcc  
csky                 randconfig-r005-20230720   gcc  
csky                 randconfig-r012-20230720   gcc  
csky                 randconfig-r016-20230720   gcc  
hexagon              randconfig-r024-20230720   clang
hexagon              randconfig-r041-20230720   clang
hexagon              randconfig-r045-20230720   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230720   gcc  
i386         buildonly-randconfig-r005-20230720   gcc  
i386         buildonly-randconfig-r006-20230720   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230720   gcc  
i386                 randconfig-i002-20230720   gcc  
i386                 randconfig-i003-20230720   gcc  
i386                 randconfig-i004-20230720   gcc  
i386                 randconfig-i005-20230720   gcc  
i386                 randconfig-i006-20230720   gcc  
i386                 randconfig-i011-20230720   clang
i386                 randconfig-i012-20230720   clang
i386                 randconfig-i013-20230720   clang
i386                 randconfig-i014-20230720   clang
i386                 randconfig-i015-20230720   clang
i386                 randconfig-i016-20230720   clang
i386                 randconfig-r002-20230720   gcc  
i386                 randconfig-r021-20230720   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r015-20230720   gcc  
loongarch            randconfig-r023-20230720   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r006-20230720   gcc  
m68k                 randconfig-r014-20230720   gcc  
m68k                 randconfig-r025-20230720   gcc  
microblaze           randconfig-r011-20230720   gcc  
microblaze           randconfig-r024-20230720   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r004-20230720   clang
mips                 randconfig-r012-20230720   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r026-20230720   gcc  
openrisc             randconfig-r022-20230720   gcc  
openrisc             randconfig-r025-20230720   gcc  
openrisc             randconfig-r036-20230720   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r003-20230720   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc              randconfig-r001-20230720   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r002-20230720   gcc  
riscv                randconfig-r042-20230720   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r044-20230720   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r006-20230720   gcc  
sh                   randconfig-r011-20230720   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc                randconfig-r005-20230720   gcc  
sparc                randconfig-r034-20230720   gcc  
sparc64              randconfig-r013-20230720   gcc  
sparc64              randconfig-r036-20230720   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                   randconfig-r031-20230720   clang
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230720   gcc  
x86_64       buildonly-randconfig-r002-20230720   gcc  
x86_64       buildonly-randconfig-r003-20230720   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-r013-20230720   clang
x86_64               randconfig-r033-20230720   gcc  
x86_64               randconfig-x001-20230720   clang
x86_64               randconfig-x002-20230720   clang
x86_64               randconfig-x003-20230720   clang
x86_64               randconfig-x004-20230720   clang
x86_64               randconfig-x005-20230720   clang
x86_64               randconfig-x006-20230720   clang
x86_64               randconfig-x011-20230720   gcc  
x86_64               randconfig-x012-20230720   gcc  
x86_64               randconfig-x013-20230720   gcc  
x86_64               randconfig-x014-20230720   gcc  
x86_64               randconfig-x015-20230720   gcc  
x86_64               randconfig-x016-20230720   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
