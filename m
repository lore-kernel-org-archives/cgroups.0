From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:test-merge] BUILD SUCCESS
 f6a72e65a90216f5be921e156ba0fba21472fdb7
Date: Tue, 27 Jun 2023 21:42:51 +0800
Message-ID: <202306272150.jMZYiKtb-lkp@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687873393; x=1719409393;
  h=date:from:to:cc:subject:message-id;
  bh=Y8VJ2xTu6CsTiNmwGbkhKXYvB0GRt0y4eEcC790IfSs=;
  b=kjjyKbdpuRScK7iejHRju+iCpZzfPj54D69F3pfRjHXtmY7TLSDCm/sT
   o/czglwCDLKjzVKCIezFdm+Hj4KPSRGfshLnUOzf4tENhYGIwm/d23iJi
   rROfuZop22JEvFEgVpLa4lO19J+PcT4uLSQFE9JkMU2r8MKjE5MqQqD72
   Ah4jqapykREYskAdVqMF7HqdvGf1tc39cBhSyw96fRpO/YEUWXzXXA2qJ
   Bx8qscz6sl58PwmFKjjuhJiQrC6hBlhRYggJCbzKbXPIm/SoXvGXTX4pr
   b+YsXkdqsac5mtQwTmwkW6Kzq0Fw1WCF9B8SHslo9tNfv8Mq79E3o+CC+
   g==;
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge
branch HEAD: f6a72e65a90216f5be921e156ba0fba21472fdb7  Merge branch 'for-6.5' into test-merge

elapsed time: 723m

configs tested: 111
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r043-20230627   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm                     am200epdkit_defconfig   clang
arm                       aspeed_g4_defconfig   clang
arm                                 defconfig   gcc  
arm                  randconfig-r006-20230627   clang
arm                  randconfig-r031-20230627   clang
arm                  randconfig-r035-20230627   clang
arm                  randconfig-r046-20230627   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
csky                                defconfig   gcc  
hexagon              randconfig-r041-20230627   clang
hexagon              randconfig-r045-20230627   clang
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-r004-20230627   gcc  
i386         buildonly-randconfig-r005-20230627   gcc  
i386         buildonly-randconfig-r006-20230627   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-i001-20230627   gcc  
i386                 randconfig-i002-20230627   gcc  
i386                 randconfig-i003-20230627   gcc  
i386                 randconfig-i004-20230627   gcc  
i386                 randconfig-i005-20230627   gcc  
i386                 randconfig-i006-20230627   gcc  
i386                 randconfig-i011-20230627   clang
i386                 randconfig-i012-20230627   clang
i386                 randconfig-i013-20230627   clang
i386                 randconfig-i014-20230627   clang
i386                 randconfig-i015-20230627   clang
i386                 randconfig-i016-20230627   clang
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
loongarch            randconfig-r032-20230627   gcc  
m68k                             allmodconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r013-20230627   gcc  
microblaze           randconfig-r016-20230627   gcc  
microblaze           randconfig-r021-20230627   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                          malta_defconfig   clang
nios2                               defconfig   gcc  
nios2                randconfig-r014-20230627   gcc  
openrisc             randconfig-r003-20230627   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                 mpc832x_rdb_defconfig   clang
powerpc               mpc834x_itxgp_defconfig   clang
powerpc              randconfig-r001-20230627   gcc  
powerpc              randconfig-r012-20230627   clang
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                randconfig-r004-20230627   gcc  
riscv                randconfig-r042-20230627   clang
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                          debug_defconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r026-20230627   clang
s390                 randconfig-r044-20230627   clang
sh                               allmodconfig   gcc  
sh                   randconfig-r011-20230627   gcc  
sh                   randconfig-r022-20230627   gcc  
sh                          rsk7264_defconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc64              randconfig-r024-20230627   gcc  
um                               allmodconfig   clang
um                                allnoconfig   clang
um                               allyesconfig   clang
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-r001-20230627   gcc  
x86_64       buildonly-randconfig-r002-20230627   gcc  
x86_64       buildonly-randconfig-r003-20230627   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-r005-20230627   gcc  
x86_64               randconfig-x001-20230627   clang
x86_64               randconfig-x002-20230627   clang
x86_64               randconfig-x003-20230627   clang
x86_64               randconfig-x004-20230627   clang
x86_64               randconfig-x005-20230627   clang
x86_64               randconfig-x006-20230627   clang
x86_64               randconfig-x011-20230627   gcc  
x86_64               randconfig-x012-20230627   gcc  
x86_64               randconfig-x013-20230627   gcc  
x86_64               randconfig-x014-20230627   gcc  
x86_64               randconfig-x015-20230627   gcc  
x86_64               randconfig-x016-20230627   gcc  
x86_64                          rhel-8.3-rust   clang
x86_64                               rhel-8.3   gcc  
xtensa               randconfig-r002-20230627   gcc  
xtensa               randconfig-r015-20230627   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
