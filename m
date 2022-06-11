From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 5f69a6577bc33d8f6d6bbe02bccdeb357b287f56
Date: Sat, 11 Jun 2022 18:53:51 +0800
Message-ID: <62a4743f.sj9KOMk5GZYO0a1Y%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654944852; x=1686480852;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=dMfi3JFqP/5HNTIVD1cl3zNvzANcKbIBmYyQT0IKXPM=;
  b=J5wDOQbui0dvaaW1aUfrLDUHOw097EorUHibNQyZxMT5X6NiY66WrNyp
   eHCOsGnjvMCI3p7aa0QCqlg+p78WHc0fPAJT9W7+smn+vbSp5NKNJQODm
   XDVwopwtOpItkDwVAf/xPM5kHO22RC0mRQnVMKXkEwlAgVavzM7pWqQd1
   iCV5s3lPqLGjRXBByZ6PjiDiIR+kV7yzvBZA5rY5TVzshxxb5ubEnkGMh
   a7nsotTHB05QM8OVu0bm7CAaEjSP+wVQypG4r1UwSaHMue8yZo3F9hO0J
   dfVqNwxpHKHoil+JHqoYkQTqxeLLkowtvd/z6h5W7twSJ4F1SCewjVBH3
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 5f69a6577bc33d8f6d6bbe02bccdeb357b287f56  psi: dont alloc memory for psi by default

elapsed time: 5373m

configs tested: 70
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm64                               defconfig
arm64                            allyesconfig
arm                              allyesconfig
arm                                 defconfig
arm                              allmodconfig
ia64                             allmodconfig
ia64                             allyesconfig
ia64                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
alpha                               defconfig
csky                                defconfig
nios2                            allyesconfig
alpha                            allyesconfig
nios2                               defconfig
arc                              allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
arc                                 defconfig
xtensa                           allyesconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
s390                                defconfig
s390                             allyesconfig
s390                             allmodconfig
i386                   debian-10.3-kselftests
i386                                defconfig
i386                             allyesconfig
sparc                               defconfig
sparc                            allyesconfig
mips                             allmodconfig
mips                             allyesconfig
riscv                             allnoconfig
riscv                            allyesconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
i386                              debian-10.3
powerpc                           allnoconfig
um                             i386_defconfig
um                           x86_64_defconfig
powerpc                          allmodconfig
powerpc                          allyesconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a011
x86_64                        randconfig-a006
i386                          randconfig-a012
x86_64                        randconfig-a004
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                           rhel-8.3-syz
x86_64                                  kexec
x86_64                         rhel-8.3-kunit
x86_64                              defconfig
x86_64                           allyesconfig

clang tested configs:
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
i386                          randconfig-a011

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
