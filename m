From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 980660cae7994ab03b31b2a32940c70e8421fc99
Date: Fri, 06 Jan 2023 14:49:08 +0800
Message-ID: <63b7c464.ZOXle8Ow7lBDtrz6%lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672987793; x=1704523793;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=oQQNlW233skbq3EJwlwoMPlwJ/s4JIGZDq3ttf0iuRs=;
  b=kJXcaJ4N+eJKGLvV1jmez4vGqg8mEEdsu8HXk5TBxs5gtoCEwBrUrAl9
   pvkKWLuj5ZB+ho4e/3wbsSmI2axPqbOFvEHnoN40Ck3Q2HELypKnIe/tn
   e3VOWpduuHXW4PjThRcOiXyn7w2bgIHnF5ZOG9pFcFEKVM7qkjdvClKtO
   jFvBp2Qh1EhulBLsdyOOmAe8p/mFatpgqSH1UNhyuLn9keoSN4YYJLrGK
   AsHiq1pZZomrwbNVsDXwXsMio9qU1QyfOtwXvsCw5mH/TXvqZcXvDudJb
   6+idaKl4oAgSCkJTs/PvS3clQLzkdyBOmX46ETRcVW9vqhOFTDoZ/HF8g
   Q==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 980660cae7994ab03b31b2a32940c70e8421fc99  docs: cgroup-v1: use numbered lists for user interface setup

elapsed time: 729m

configs tested: 62
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
alpha                               defconfig
s390                             allmodconfig
x86_64                            allnoconfig
s390                                defconfig
um                           x86_64_defconfig
um                             i386_defconfig
powerpc                           allnoconfig
mips                             allyesconfig
s390                 randconfig-r044-20230105
sh                               allmodconfig
s390                             allyesconfig
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
arc                  randconfig-r043-20230105
x86_64                              defconfig
i386                          randconfig-a001
i386                          randconfig-a003
x86_64                        randconfig-a004
x86_64                        randconfig-a002
m68k                             allyesconfig
m68k                             allmodconfig
alpha                            allyesconfig
i386                          randconfig-a005
arc                              allyesconfig
x86_64                        randconfig-a006
x86_64                           rhel-8.3-bpf
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-syz
x86_64                        randconfig-a013
powerpc                          allmodconfig
x86_64                        randconfig-a011
x86_64                         rhel-8.3-kunit
riscv                randconfig-r042-20230105
i386                                defconfig
x86_64                           rhel-8.3-kvm
x86_64                               rhel-8.3
x86_64                           allyesconfig
x86_64                          rhel-8.3-func
x86_64                        randconfig-a015
arm                                 defconfig
ia64                             allmodconfig
i386                             allyesconfig
arm64                            allyesconfig
arm                              allyesconfig

clang tested configs:
i386                          randconfig-a013
i386                          randconfig-a011
arm                  randconfig-r046-20230105
hexagon              randconfig-r045-20230105
hexagon              randconfig-r041-20230105
i386                          randconfig-a015
i386                          randconfig-a002
i386                          randconfig-a004
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                          rhel-8.3-rust
x86_64                        randconfig-a014
i386                          randconfig-a006
x86_64                        randconfig-a016
x86_64                        randconfig-a005
x86_64                        randconfig-a012

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
