From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 674b745e22b3caae48ad20422795eefd3f832a7b
Date: Thu, 24 Nov 2022 20:57:11 +0800
Message-ID: <637f6a27.Fe0r8IMIiZfjGK9w%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669294636; x=1700830636;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Kw0L4NM8Tm+uPTRhWMFYNJRMX46UCwAiJrVgnDn31pM=;
  b=c8KEdTIsWqs0OH5VrynNTVSK9ulWqyomSYcr2pwwO6mbv2WZLbUA/6OE
   fBY6+5bjq2SVG8ya3K/hF5uBHOZ6ScmV242ULYiDFpcDcg2YGO196LXdO
   RJCFFA5HXVAHb1xHuHVgUB9RbysIMfh67Pv5I2A7BU2Mp8b7pXJkYa42p
   kL9ArZ9sNLjvDW65AMZQT9w/NINVIM726OtEKHfUzwyJa2+olABw2hDX9
   HaFfsNDl50u0tQFwjN3mLtEPgtAnYuH3O2Mycw3negD12Y0BbtJjG+9Kw
   4UyF3u3SUg0WzSfFVKh0T2aPGD0bkCwqFhASZL+ElBK4yaSzfp/GG+oTY
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 674b745e22b3caae48ad20422795eefd3f832a7b  cgroup: remove rcu_read_lock()/rcu_read_unlock() in critical section of spin_lock_irq()

elapsed time: 1162m

configs tested: 45
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
s390                                defconfig
arc                                 defconfig
um                             i386_defconfig
alpha                               defconfig
um                           x86_64_defconfig
s390                             allmodconfig
powerpc                           allnoconfig
mips                             allyesconfig
powerpc                          allmodconfig
sh                               allmodconfig
s390                             allyesconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
arc                              allyesconfig
alpha                            allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
i386                 randconfig-a011-20221121
i386                 randconfig-a012-20221121
i386                 randconfig-a013-20221121
i386                 randconfig-a014-20221121
i386                 randconfig-a016-20221121
i386                 randconfig-a015-20221121
x86_64                            allnoconfig
x86_64                              defconfig
i386                          debian-10.3-kvm
i386                        debian-10.3-kunit
i386                         debian-10.3-func
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                    nommu_k210_defconfig
riscv                             allnoconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
x86_64                               rhel-8.3
i386                                defconfig
x86_64                           allyesconfig
arm64                            allyesconfig
arm                                 defconfig
arm                              allyesconfig
i386                             allyesconfig

clang tested configs:
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
