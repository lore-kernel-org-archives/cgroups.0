Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB403E44F6
	for <cgroups@vger.kernel.org>; Fri, 26 Jun 2026 09:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782467612; cv=none; b=LOahtVziC4Ut2vqLb7rTOsbtRl+gqwL7rmTYbV+33bm65iZH6VcxKfD+aX/SmqpnEBJMtwu/RBTOUr9bBdecxzojKssHp4JQy0OL1PqYkusnP5gt1jOK8A370vSDdkND5SL0ch3V11l1jX2ekCEm1tiuLsUir39td0nRsQDO2MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782467612; c=relaxed/simple;
	bh=l12pqAsMrKiwI9DkbaWkqdPuU+hQsTx0R9qH/aranUU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ZUXmQflCjKRdY8FWuS2mGnEWRkaNZw78ZaPHKYk311RU0bEn2ZOIWr3kIUgB1nonsGs/+NJ3Ox6JzvzS38zqQJLCLtbsklRTazpIqWWHchLABZJiX6ulieZ9Nkep+VNAYkLevAfOQnsjY2pDkCIkM72v1a2ZYsVOAq0P1uQMER4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iq6Sg4vb; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iq6Sg4vb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782467611; x=1814003611;
  h=date:from:to:cc:subject:message-id;
  bh=l12pqAsMrKiwI9DkbaWkqdPuU+hQsTx0R9qH/aranUU=;
  b=iq6Sg4vbDBc5YdJSWsqy1W3k3gR0SmgbuQTq9Z3X5FTK7troGPoCnZrE
   fYtn+3R/cqrRQEmAZV98F8SBJYXyVYNJnnzxzHLxW1lbJciBF+c+iTZba
   trA0xWubv6svIr17KZRFLAxhW4k0AQIsAheFVbvRYles/LC0W/kG5drkw
   hO2XQtKnPveRHX0otdhbKS+q+qAKi/9JGcsYepY1X/HunFWOSffYfJdbI
   sWwiUPgMHuxaCgu5W16IPx40pqpMDbDQn2MQoIl9keu2iQ+7Cfw3LpuML
   GoYHsc7DKvvaiCuqhmnekGL7OHUT4yGVVclW1n3lfG9f5ropTBkakBdNE
   w==;
X-CSE-ConnectionGUID: 3UrdXnP/QX+LtRm8PspzDg==
X-CSE-MsgGUID: TXxW1Y/GT1ytkxTyydezXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="83139284"
X-IronPort-AV: E=Sophos;i="6.24,226,1774335600"; 
   d="scan'208";a="83139284"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 02:53:30 -0700
X-CSE-ConnectionGUID: 8z5W8JCLSpWmXsVHkQWzUA==
X-CSE-MsgGUID: UUb+2PNsRT+Zbxkj3MBLUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,226,1774335600"; 
   d="scan'208";a="274489847"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 26 Jun 2026 02:53:29 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wd3FD-000000004y7-0rtN;
	Fri, 26 Jun 2026 09:53:08 +0000
Date: Fri, 26 Jun 2026 17:51:30 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 dc2eb3bcf9686ff69ca27e7b5d8ca131469d61c0
Message-ID: <202606261720.bd7JEs5d-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: dc2eb3bcf9686ff69ca27e7b5d8ca131469d61c0  Merge branch 'for-7.3' into for-next

elapsed time: 725m

configs tested: 263
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                                 defconfig    gcc-16.1.0
arc                            randconfig-001    gcc-16.1.0
arc                   randconfig-001-20260626    gcc-13.4.0
arc                   randconfig-001-20260626    gcc-16.1.0
arc                            randconfig-002    gcc-16.1.0
arc                   randconfig-002-20260626    gcc-13.4.0
arc                   randconfig-002-20260626    gcc-16.1.0
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                            randconfig-001    gcc-16.1.0
arm                   randconfig-001-20260626    gcc-13.4.0
arm                   randconfig-001-20260626    gcc-16.1.0
arm                            randconfig-002    gcc-16.1.0
arm                   randconfig-002-20260626    gcc-13.4.0
arm                   randconfig-002-20260626    gcc-16.1.0
arm                            randconfig-003    gcc-16.1.0
arm                   randconfig-003-20260626    gcc-13.4.0
arm                   randconfig-003-20260626    gcc-16.1.0
arm                            randconfig-004    gcc-16.1.0
arm                   randconfig-004-20260626    gcc-13.4.0
arm                   randconfig-004-20260626    gcc-16.1.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                          randconfig-001    clang-23
arm64                 randconfig-001-20260626    clang-23
arm64                 randconfig-001-20260626    gcc-8.5.0
arm64                          randconfig-002    clang-23
arm64                 randconfig-002-20260626    clang-23
arm64                 randconfig-002-20260626    gcc-8.5.0
arm64                          randconfig-003    clang-23
arm64                 randconfig-003-20260626    clang-23
arm64                 randconfig-003-20260626    gcc-8.5.0
arm64                          randconfig-004    clang-23
arm64                 randconfig-004-20260626    clang-23
arm64                 randconfig-004-20260626    gcc-8.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                           randconfig-001    clang-23
csky                  randconfig-001-20260626    clang-23
csky                  randconfig-001-20260626    gcc-8.5.0
csky                           randconfig-002    clang-23
csky                  randconfig-002-20260626    clang-23
csky                  randconfig-002-20260626    gcc-8.5.0
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260626    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260626    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                 buildonly-randconfig-001    gcc-14
i386        buildonly-randconfig-001-20260626    gcc-14
i386                 buildonly-randconfig-002    gcc-14
i386        buildonly-randconfig-002-20260626    gcc-14
i386                 buildonly-randconfig-003    gcc-14
i386        buildonly-randconfig-003-20260626    gcc-14
i386                 buildonly-randconfig-004    gcc-14
i386        buildonly-randconfig-004-20260626    gcc-14
i386                 buildonly-randconfig-005    gcc-14
i386        buildonly-randconfig-005-20260626    gcc-14
i386                 buildonly-randconfig-006    gcc-14
i386        buildonly-randconfig-006-20260626    gcc-14
i386                                defconfig    gcc-16.1.0
i386                           randconfig-001    gcc-14
i386                  randconfig-001-20260626    gcc-14
i386                           randconfig-002    gcc-14
i386                  randconfig-002-20260626    gcc-14
i386                           randconfig-003    gcc-14
i386                  randconfig-003-20260626    gcc-14
i386                           randconfig-004    gcc-14
i386                  randconfig-004-20260626    gcc-14
i386                           randconfig-005    gcc-14
i386                  randconfig-005-20260626    gcc-14
i386                           randconfig-006    gcc-14
i386                  randconfig-006-20260626    gcc-14
i386                           randconfig-007    gcc-14
i386                  randconfig-007-20260626    gcc-14
i386                           randconfig-011    gcc-14
i386                  randconfig-011-20260626    gcc-14
i386                           randconfig-012    gcc-14
i386                  randconfig-012-20260626    gcc-14
i386                           randconfig-013    gcc-14
i386                  randconfig-013-20260626    gcc-14
i386                           randconfig-014    gcc-14
i386                  randconfig-014-20260626    gcc-14
i386                           randconfig-015    gcc-14
i386                  randconfig-015-20260626    gcc-14
i386                           randconfig-016    gcc-14
i386                  randconfig-016-20260626    gcc-14
i386                           randconfig-017    gcc-14
i386                  randconfig-017-20260626    gcc-14
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260626    gcc-11.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260626    gcc-11.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                                defconfig    clang-23
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                      mmu_defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                     loongson2k_defconfig    gcc-16.1.0
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                               defconfig    clang-23
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260626    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260626    gcc-11.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260626    gcc-8.5.0
parisc                         randconfig-002    gcc-8.5.0
parisc                randconfig-002-20260626    gcc-8.5.0
parisc64                            defconfig    clang-23
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                      ep88xc_defconfig    gcc-16.1.0
powerpc                   motionpro_defconfig    clang-23
powerpc                        randconfig-001    gcc-8.5.0
powerpc               randconfig-001-20260626    gcc-8.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260626    gcc-8.5.0
powerpc64                      randconfig-001    gcc-8.5.0
powerpc64             randconfig-001-20260626    gcc-8.5.0
powerpc64                      randconfig-002    gcc-8.5.0
powerpc64             randconfig-002-20260626    gcc-8.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv             nommu_k210_sdcard_defconfig    gcc-16.1.0
riscv                          randconfig-001    clang-23
riscv                 randconfig-001-20260626    clang-23
riscv                          randconfig-002    clang-23
riscv                 randconfig-002-20260626    clang-23
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                           randconfig-001    clang-23
s390                  randconfig-001-20260626    clang-23
s390                           randconfig-002    clang-23
s390                  randconfig-002-20260626    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                               allyesconfig    clang-17
sh                                  defconfig    gcc-14
sh                             randconfig-001    clang-23
sh                    randconfig-001-20260626    clang-23
sh                             randconfig-002    clang-23
sh                    randconfig-002-20260626    clang-23
sparc                             allnoconfig    clang-23
sparc                               defconfig    gcc-16.1.0
sparc                          randconfig-001    gcc-12.5.0
sparc                 randconfig-001-20260626    gcc-12.5.0
sparc                          randconfig-002    gcc-12.5.0
sparc                 randconfig-002-20260626    gcc-12.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64                        randconfig-001    gcc-12.5.0
sparc64               randconfig-001-20260626    gcc-12.5.0
sparc64                        randconfig-002    gcc-12.5.0
sparc64               randconfig-002-20260626    gcc-12.5.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             randconfig-001    gcc-12.5.0
um                    randconfig-001-20260626    gcc-12.5.0
um                             randconfig-002    gcc-12.5.0
um                    randconfig-002-20260626    gcc-12.5.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260626    gcc-14
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260626    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260626    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260626    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260626    gcc-14
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260626    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260626    clang-22
x86_64                randconfig-002-20260626    clang-22
x86_64                randconfig-003-20260626    clang-22
x86_64                randconfig-004-20260626    clang-22
x86_64                randconfig-005-20260626    clang-22
x86_64                randconfig-006-20260626    clang-22
x86_64                         randconfig-011    gcc-14
x86_64                randconfig-011-20260626    gcc-14
x86_64                         randconfig-012    gcc-14
x86_64                randconfig-012-20260626    gcc-14
x86_64                         randconfig-013    gcc-14
x86_64                randconfig-013-20260626    gcc-14
x86_64                         randconfig-014    gcc-14
x86_64                randconfig-014-20260626    gcc-14
x86_64                         randconfig-015    gcc-14
x86_64                randconfig-015-20260626    gcc-14
x86_64                         randconfig-016    gcc-14
x86_64                randconfig-016-20260626    gcc-14
x86_64                         randconfig-071    gcc-14
x86_64                randconfig-071-20260626    gcc-14
x86_64                         randconfig-072    gcc-14
x86_64                randconfig-072-20260626    gcc-14
x86_64                         randconfig-073    gcc-14
x86_64                randconfig-073-20260626    gcc-14
x86_64                         randconfig-074    gcc-14
x86_64                randconfig-074-20260626    gcc-14
x86_64                         randconfig-075    gcc-14
x86_64                randconfig-075-20260626    gcc-14
x86_64                         randconfig-076    gcc-14
x86_64                randconfig-076-20260626    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                         randconfig-001    gcc-12.5.0
xtensa                randconfig-001-20260626    gcc-12.5.0
xtensa                         randconfig-002    gcc-12.5.0
xtensa                randconfig-002-20260626    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
