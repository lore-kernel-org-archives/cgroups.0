From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 3109920b3d95ebee86198757328eefe51f458b06
Date: Fri, 29 Jul 2022 14:34:31 +0800
Message-ID: <62e37f77.X2YzH9qbG5BBPuo+%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659076531; x=1690612531;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=wmrB32ud727k1HoVT2qjOvqbMhSqmy8KWN0Rbdoy5tg=;
  b=JfnUqYOCFfLdPuKE0fgZgrETMyTg2ehy/lXKIV/xNjr2PEtIywXVODdY
   FuOx4BgzjkExZfNVIOFDa46EPmMV8DSrwkIzlEXAA3d4joGOyipN76gIM
   J88KQAWduE3bobat/ES6xzBs/GhYfhuqYg1Kr/w02Dq6JTEmKxhlvagRt
   hUq/WOIkfUrIGqCg+ubfW7O2sLwLNMsXV+YLuU+t9AXUBvxlRU8Dhsl1R
   TH2a4manAe/Bz7EcYmq2w0GV/JUeJ9x/1S3Gi5rx38+ttUAcs2bdi2Wdz
   ku/5YagKqUGUT0Rka/Vz2QlCHLj3sIa/8i81DLz0XiQMh28jcm338DiFb
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 3109920b3d95ebee86198757328eefe51f458b06  Merge branch 'for-5.20' into for-next

elapsed time: 723m

configs tested: 73
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
i386                                defconfig
i386                          randconfig-a001
powerpc                          allmodconfig
i386                          randconfig-a003
i386                          randconfig-a005
sh                               allmodconfig
i386                             allyesconfig
x86_64                        randconfig-a013
mips                             allyesconfig
powerpc                           allnoconfig
x86_64                        randconfig-a011
x86_64                        randconfig-a015
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
arm                                 defconfig
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-kvm
x86_64                        randconfig-a004
x86_64                           rhel-8.3-syz
x86_64                        randconfig-a002
x86_64                        randconfig-a006
arc                  randconfig-r043-20220728
arm64                            allyesconfig
arm                              allyesconfig
s390                 randconfig-r044-20220728
riscv                randconfig-r042-20220728
ia64                             allmodconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                           allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
csky                              allnoconfig
alpha                             allnoconfig
arc                               allnoconfig
riscv                             allnoconfig
ia64                          tiger_defconfig
microblaze                          defconfig
arm                         axm55xx_defconfig
nios2                         10m50_defconfig
alpha                               defconfig
m68k                        m5407c3_defconfig
powerpc                     taishan_defconfig
sh                         ap325rxa_defconfig
powerpc                      tqm8xx_defconfig
arm                          lpd270_defconfig
loongarch                           defconfig
loongarch                         allnoconfig

clang tested configs:
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
x86_64                        randconfig-a001
x86_64                        randconfig-a003
hexagon              randconfig-r045-20220728
hexagon              randconfig-r041-20220728
x86_64                        randconfig-a005
powerpc                      katmai_defconfig
arm                  colibri_pxa300_defconfig
arm                        magician_defconfig
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
