From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 21786e5cb375a1e58a9175fee423e1d7f892d965
Date: Thu, 05 Jan 2023 18:31:14 +0800
Message-ID: <63b6a6f2.kedxrqkA4mpMHNvR%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672914706; x=1704450706;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=p//dgkXaSRaAXYrWVLyuFQT8CV14x392E80VhZ3qB5A=;
  b=k+PBM7gEKZ7ggvweniU7a0flNeAlFDjini7YD4vI20g2eBLC2Mpzfx4i
   8VXM2FP7/WK8s9TIlv3sAgWTU3xMdPY2Z2QjU/s0reyXsFxJOYZl+9CKA
   oBgDcD3poaIyGCGAMJtkPij7y1n2Y3Nk55NopMZssZJxDgCHJGMapFdT5
   Yh/kWwD72D6QYhEa0V2T0NNQ8lp0mMv5PPEZdgpAc1swKcdH5htnpPWxL
   oy6lDTFNf9E0V+VYK3bOc0dMjeEg7EPXZWQGAtkZ5TC7P2+XG9tUYJ/+Y
   B26CEf7p5o4WD7o34ldbp1vdHpCAfHe3fs+VtGp1Yo5sfItYcccdP+wtp
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 21786e5cb375a1e58a9175fee423e1d7f892d965  cgroup/cpuset: no need to explicitly init a global static variable

elapsed time: 724m

configs tested: 54
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
alpha                               defconfig
s390                             allmodconfig
s390                                defconfig
powerpc                           allnoconfig
x86_64                            allnoconfig
alpha                            allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
m68k                             allyesconfig
s390                             allyesconfig
sh                               allmodconfig
mips                             allyesconfig
powerpc                          allmodconfig
ia64                             allmodconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           rhel-8.3-syz
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-bpf
x86_64                         rhel-8.3-kunit
i386                 randconfig-a004-20230102
i386                 randconfig-a003-20230102
i386                 randconfig-a001-20230102
i386                 randconfig-a002-20230102
i386                 randconfig-a005-20230102
x86_64                              defconfig
i386                 randconfig-a006-20230102
x86_64                               rhel-8.3
arm                                 defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                          rhel-8.3-func
x86_64               randconfig-a004-20230102
x86_64               randconfig-a002-20230102
x86_64               randconfig-a003-20230102
x86_64               randconfig-a001-20230102
x86_64               randconfig-a005-20230102
x86_64               randconfig-a006-20230102
x86_64                        randconfig-a004
x86_64                        randconfig-a002
i386                                defconfig
x86_64                        randconfig-a006
i386                             allyesconfig
arm64                            allyesconfig
arm                              allyesconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func

clang tested configs:
x86_64                          rhel-8.3-rust
x86_64                        randconfig-k001
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
