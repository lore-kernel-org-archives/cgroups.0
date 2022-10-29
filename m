From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD REGRESSION
 6ab428604f724cf217a47b7d3f3353aab815b40e
Date: Sat, 29 Oct 2022 17:24:28 +0800
Message-ID: <635cf14c.5TSA5uJJpTPz+0MC%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667035522; x=1698571522;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=doRL1DVr9fa4daC4PHQlYi3fJEz389CZ7Oz/F424Jaw=;
  b=SARTPgLYwzPFB6tP3wJ9eLHC5Hey0xuiqDJsaj4xbUGIQReFUPaSnAxh
   UQQW/zJU/AYBspbfmpgxE/vxBrb53i7zadODfw9vYSKWi24Lffkwjwlji
   llqwQDrntLfaW2dhyXkNXQrO02WGbP87BBCLCHikjD05tDxoB158wYJf8
   qKYS6FhhihxjWZ6bmlm6UDWyUa80YL86hUipyeZPETO5C2BQXTAqRPbNV
   jaEg9kxIZKN5yKyIZ+JV75XqCEUp4wQ7HoqN0XHAMy59pZQaQAVe2G0US
   +haVVftUr2OQRTtqjU53cjRL/gUmG1CaAc+NH9S3Y96wiFIAJSBhSp7yU
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 6ab428604f724cf217a47b7d3f3353aab815b40e  cgroup: Implement DEBUG_CGROUP_REF

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202210291258.Php0YV92-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "css_get" [drivers/block/loop.ko] undefined!
ERROR: modpost: "css_get" [fs/btrfs/btrfs.ko] undefined!
ERROR: modpost: "css_put" [drivers/block/loop.ko] undefined!
ERROR: modpost: "css_put" [fs/btrfs/btrfs.ko] undefined!
ERROR: modpost: "css_put" [net/netfilter/xt_cgroup.ko] undefined!

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
`-- powerpc-allmodconfig
    |-- ERROR:css_get-drivers-block-loop.ko-undefined
    |-- ERROR:css_get-fs-btrfs-btrfs.ko-undefined
    |-- ERROR:css_put-drivers-block-loop.ko-undefined
    |-- ERROR:css_put-fs-btrfs-btrfs.ko-undefined
    `-- ERROR:css_put-net-netfilter-xt_cgroup.ko-undefined

elapsed time: 723m

configs tested: 84
configs skipped: 2

gcc tested configs:
arc                                 defconfig
alpha                               defconfig
powerpc                           allnoconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
s390                                defconfig
s390                             allmodconfig
x86_64                           rhel-8.3-kvm
x86_64                         rhel-8.3-kunit
x86_64                          rhel-8.3-func
s390                             allyesconfig
x86_64                    rhel-8.3-kselftests
i386                          randconfig-a016
sh                               allmodconfig
x86_64                           rhel-8.3-syz
x86_64                               rhel-8.3
s390                 randconfig-r044-20221028
ia64                             allmodconfig
i386                          randconfig-a005
i386                                defconfig
i386                          randconfig-a001
arc                  randconfig-r043-20221028
x86_64                        randconfig-a013
i386                          randconfig-a003
x86_64                           allyesconfig
powerpc                          allmodconfig
alpha                            allyesconfig
mips                             allyesconfig
x86_64                        randconfig-a002
i386                          randconfig-a014
x86_64                        randconfig-a015
m68k                             allyesconfig
arc                              allyesconfig
x86_64                        randconfig-a004
i386                          randconfig-a012
x86_64                        randconfig-a011
riscv                randconfig-r042-20221028
arm                                 defconfig
m68k                             allmodconfig
arm64                            allyesconfig
arm                              allyesconfig
i386                             allyesconfig
powerpc                      ep88xc_defconfig
powerpc                       ppc64_defconfig
powerpc                      makalu_defconfig
arm                           u8500_defconfig
arm                         lpc18xx_defconfig
arm                      jornada720_defconfig
sh                           se7722_defconfig
arm                        spear6xx_defconfig
xtensa                  nommu_kc705_defconfig
sparc64                          alldefconfig
i386                          randconfig-c001
sparc                            allyesconfig
powerpc                    sam440ep_defconfig
csky                             alldefconfig
m68k                        mvme16x_defconfig
powerpc                 canyonlands_defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3

clang tested configs:
x86_64                        randconfig-a016
i386                          randconfig-a004
i386                          randconfig-a006
i386                          randconfig-a002
x86_64                        randconfig-a001
x86_64                        randconfig-a005
x86_64                        randconfig-a003
hexagon              randconfig-r041-20221028
x86_64                        randconfig-a012
i386                          randconfig-a011
hexagon              randconfig-r045-20221028
x86_64                        randconfig-a014
i386                          randconfig-a013
i386                          randconfig-a015
s390                 randconfig-r044-20221029
hexagon              randconfig-r041-20221029
hexagon              randconfig-r045-20221029
riscv                randconfig-r042-20221029
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
