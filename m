Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE78212542
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 03:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789442579; cv=none; b=KD93Z732fkYHvOa9g3YehzFSmooVt/U3jc1QE7dUbAibdhWiA6Po2RhmztA8SiiC/2BDb/ZN1tBon4De4OTed03VVfC6tTv9DYjnAIK36V+y8kPZV5eH2pI+Pjx3b7VKsekXal3MoY6DJ/rVRJvhDr9shvuxW+S/PVYfFao9U5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789442579; c=relaxed/simple;
	bh=u8Kom/UOEYGNaGpXQe0LRiQ0RUURHGYHYvari3HkpUM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=LgA5Z01nLUS9zR+bOqV1jXZCvBaM5npY6Ta4J/bJEbtP29Nwf3sKeXLoimp7FuCJe8JRheMiZTtZ2/3LHCYVucBI/82ZXjonWBfQoBQsfkGL8gvjqmdGo7ChBNGdYbaKM2r4MAyjIerjEtTl86um3g0y7gsjwM5VoKOMNySnbhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZDjt9K+u; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZDjt9K+u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789442577; x=1820978577;
  h=date:from:to:cc:subject:message-id;
  bh=u8Kom/UOEYGNaGpXQe0LRiQ0RUURHGYHYvari3HkpUM=;
  b=ZDjt9K+uKWxgIkQLkvVZJsXdI0r0u/81z3WX+zozdsZ3hhup0Iwq8SS0
   2x567MlyD+DSdIMMAUqJknwlPkL860Fde8xwsrTU5cf2EJEtoYXbklC91
   f4eH7zdAJfJuqC97KK8C53BOZuB+SSFUG8mIvXLJXM+ULlTp86IcSAHkZ
   t8PpR1xPUuN/waMjjLCWi5ntmBuGVMLGXYjjGRBDOjCgsAqMfR/QlfRU/
   lsHh30orjObA1Hh2YbpT+kpwUUfsxylyyZsn2GiFt6eR+eG3A0298VRm1
   SDauvZeqfzQBeguEm5uJpCJKBoTIbvI5NiUR9LNzxi3zkDJYOIVGzQxoX
   w==;
X-CSE-ConnectionGUID: PTWnPvpYQTGjx/UwY1I4uw==
X-CSE-MsgGUID: IYJce+2zSbqgsZAS6Mi58A==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89738824"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89738824"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 20:22:57 -0700
X-CSE-ConnectionGUID: FsT1KgcUSvKx/ikCwgimrw==
X-CSE-MsgGUID: fpYVfuIiSym1WymFTfOzvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="296313168"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 14 Sep 2026 20:22:55 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6Jkz-000000003wp-0m5Q;
	Tue, 15 Sep 2026 03:22:53 +0000
Date: Tue, 15 Sep 2026 11:22:37 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.4] BUILD SUCCESS
 e8f69fe59a104b4a97a3365dbb43c72996c2acde
Message-ID: <202609151133.5rJDg0np-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.4
branch HEAD: e8f69fe59a104b4a97a3365dbb43c72996c2acde  cgroup/dmem: Fix eviction helper reference in dmem_cgroup_try_charge()

elapsed time: 1429m

configs tested: 303
configs skipped: 11

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
alpha                randconfig-r121-20260914    gcc-12.5.0 sparse
alpha                randconfig-r132-20260914    gcc-12.5.0 sparse
arc                              allmodconfig    clang-24
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-24
arc                          axs101_defconfig    gcc-16.1.0
arc                      axs103_smp_defconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                         haps_hs_defconfig    clang-24
arc                 nsimosci_hs_smp_defconfig    clang-21
arc                   randconfig-001-20260914    gcc-13.4.0
arc                   randconfig-001-20260915    clang-24
arc                   randconfig-002-20260914    gcc-13.4.0
arc                   randconfig-002-20260915    clang-24
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-24
arm                                 defconfig    gcc-16.1.0
arm                         lpc18xx_defconfig    clang-21
arm                            mmp2_defconfig    gcc-16.1.0
arm                         orion5x_defconfig    clang-21
arm                             pxa_defconfig    clang-21
arm                   randconfig-001-20260914    gcc-13.4.0
arm                   randconfig-001-20260915    clang-24
arm                   randconfig-002-20260914    gcc-13.4.0
arm                   randconfig-002-20260915    clang-24
arm                   randconfig-003-20260914    gcc-13.4.0
arm                   randconfig-003-20260915    clang-24
arm                   randconfig-004-20260914    gcc-13.4.0
arm                   randconfig-004-20260915    clang-24
arm                    vt8500_v6_v7_defconfig    gcc-14
arm64                            allmodconfig    clang-24
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260914    gcc-9.5.0
arm64                 randconfig-001-20260915    gcc-12.5.0
arm64                 randconfig-002-20260914    gcc-9.5.0
arm64                 randconfig-002-20260915    gcc-12.5.0
arm64                 randconfig-003-20260914    gcc-9.5.0
arm64                 randconfig-003-20260915    gcc-12.5.0
arm64                 randconfig-004-20260914    gcc-9.5.0
arm64                 randconfig-004-20260915    gcc-12.5.0
arm64                randconfig-r112-20260915    clang-24 sparse
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260914    gcc-9.5.0
csky                  randconfig-001-20260915    gcc-12.5.0
csky                  randconfig-002-20260914    gcc-9.5.0
csky                  randconfig-002-20260915    gcc-12.5.0
csky                 randconfig-r121-20260915    clang-24 sparse
csky                 randconfig-r122-20260914    gcc-12.5.0 sparse
csky                 randconfig-r131-20260914    gcc-13.4.0 sparse
csky                 randconfig-r134-20260915    gcc-12.5.0 sparse
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    gcc-16.1.0
hexagon               randconfig-001-20260914    gcc-13.4.0
hexagon               randconfig-001-20260915    clang-24
hexagon               randconfig-002-20260914    gcc-13.4.0
hexagon               randconfig-002-20260915    clang-24
hexagon              randconfig-r113-20260915    clang-24 sparse
hexagon              randconfig-r133-20260914    gcc-12.5.0 sparse
hexagon              randconfig-r134-20260915    gcc-15.2.0 sparse
i386                             allmodconfig    clang-22
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386        buildonly-randconfig-001-20260914    gcc-14
i386        buildonly-randconfig-001-20260915    clang-22
i386        buildonly-randconfig-002-20260914    gcc-14
i386        buildonly-randconfig-002-20260915    clang-22
i386        buildonly-randconfig-003-20260914    gcc-14
i386        buildonly-randconfig-003-20260915    clang-22
i386        buildonly-randconfig-004-20260914    gcc-14
i386        buildonly-randconfig-004-20260915    clang-22
i386        buildonly-randconfig-005-20260914    gcc-14
i386        buildonly-randconfig-005-20260915    clang-22
i386        buildonly-randconfig-006-20260914    gcc-14
i386        buildonly-randconfig-006-20260915    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260914    clang-22
i386                  randconfig-001-20260915    clang-22
i386                  randconfig-002-20260914    clang-22
i386                  randconfig-002-20260915    clang-22
i386                  randconfig-003-20260914    clang-22
i386                  randconfig-003-20260915    clang-22
i386                  randconfig-004-20260914    clang-22
i386                  randconfig-004-20260915    clang-22
i386                  randconfig-005-20260914    clang-22
i386                  randconfig-005-20260915    clang-22
i386                  randconfig-006-20260914    clang-22
i386                  randconfig-006-20260915    clang-22
i386                  randconfig-007-20260914    clang-22
i386                  randconfig-007-20260915    clang-22
i386                  randconfig-011-20260914    clang-22
i386                  randconfig-011-20260915    gcc-14
i386                  randconfig-012-20260914    clang-22
i386                  randconfig-012-20260915    gcc-14
i386                  randconfig-013-20260914    clang-22
i386                  randconfig-013-20260915    gcc-14
i386                  randconfig-014-20260914    clang-22
i386                  randconfig-014-20260915    gcc-14
i386                  randconfig-015-20260914    clang-22
i386                  randconfig-015-20260915    gcc-14
i386                  randconfig-016-20260914    clang-22
i386                  randconfig-016-20260915    gcc-14
i386                  randconfig-017-20260914    clang-22
i386                  randconfig-017-20260915    gcc-14
i386                  randconfig-061-20260914    gcc-14 sparse
i386                  randconfig-062-20260914    gcc-14 sparse
i386                  randconfig-063-20260914    gcc-14 sparse
i386                 randconfig-r132-20260914    gcc-13.4.0 sparse
loongarch                        allmodconfig    clang-24
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-24
loongarch             randconfig-001-20260914    gcc-13.4.0
loongarch             randconfig-001-20260915    clang-24
loongarch             randconfig-002-20260914    gcc-13.4.0
loongarch             randconfig-002-20260915    clang-24
loongarch            randconfig-r122-20260915    clang-24 sparse
loongarch            randconfig-r131-20260914    gcc-12.5.0 sparse
loongarch            randconfig-r131-20260915    gcc-15.2.0 sparse
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-24
m68k                                defconfig    clang-24
m68k                        mvme16x_defconfig    gcc-14
m68k                 randconfig-r111-20260914    gcc-12.5.0 sparse
m68k                 randconfig-r113-20260914    gcc-12.5.0 sparse
m68k                 randconfig-r134-20260915    gcc-11.5.0 sparse
m68k                          sun3x_defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-24
microblaze           randconfig-r123-20260914    gcc-12.5.0 sparse
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                        bcm47xx_defconfig    clang-24
mips                     cu1000-neo_defconfig    gcc-16.1.0
mips                econet_en751221_defconfig    clang-21
mips                           ip22_defconfig    gcc-16.1.0
mips                           ip32_defconfig    gcc-14
mips                 randconfig-r131-20260915    gcc-12.5.0 sparse
mips                 randconfig-r134-20260914    gcc-13.4.0 sparse
nios2                            allmodconfig    clang-20
nios2                             allnoconfig    clang-24
nios2                               defconfig    clang-24
nios2                 randconfig-001-20260914    gcc-13.4.0
nios2                 randconfig-001-20260915    clang-24
nios2                 randconfig-002-20260914    gcc-13.4.0
nios2                 randconfig-002-20260915    clang-24
openrisc                         allmodconfig    clang-20
openrisc                          allnoconfig    clang-24
openrisc                   de0_nano_defconfig    clang-24
openrisc                            defconfig    gcc-16.1.0
openrisc             randconfig-r112-20260914    gcc-12.5.0 sparse
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-24
parisc                           allyesconfig    clang-17
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260914    gcc-8.5.0
parisc                randconfig-001-20260915    gcc-8.5.0
parisc                randconfig-002-20260914    gcc-8.5.0
parisc                randconfig-002-20260915    gcc-8.5.0
parisc               randconfig-r133-20260914    gcc-13.4.0 sparse
parisc64                            defconfig    clang-24
powerpc                           allnoconfig    clang-24
powerpc                   currituck_defconfig    gcc-16.1.0
powerpc                    ge_imp3a_defconfig    gcc-14
powerpc                      katmai_defconfig    gcc-16.1.0
powerpc                     mpc83xx_defconfig    gcc-16.1.0
powerpc                  mpc866_ads_defconfig    clang-24
powerpc                  mpc885_ads_defconfig    clang-21
powerpc                      pasemi_defconfig    clang-24
powerpc               randconfig-001-20260914    gcc-8.5.0
powerpc               randconfig-001-20260915    gcc-8.5.0
powerpc               randconfig-002-20260914    gcc-8.5.0
powerpc               randconfig-002-20260915    gcc-8.5.0
powerpc              randconfig-r133-20260915    gcc-12.5.0 sparse
powerpc                    socrates_defconfig    clang-24
powerpc                     tqm8541_defconfig    gcc-16.1.0
powerpc64             randconfig-001-20260914    gcc-8.5.0
powerpc64             randconfig-001-20260915    gcc-8.5.0
powerpc64             randconfig-002-20260914    gcc-8.5.0
powerpc64             randconfig-002-20260915    gcc-8.5.0
powerpc64            randconfig-r132-20260915    gcc-12.5.0 sparse
riscv                            allmodconfig    clang-24
riscv                             allnoconfig    clang-24
riscv                            allyesconfig    clang-24
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260914    gcc-13.4.0
riscv                 randconfig-002-20260914    gcc-13.4.0
riscv                randconfig-r111-20260915    clang-24 sparse
s390                             allmodconfig    clang-17
s390                              allnoconfig    clang-24
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260914    gcc-13.4.0
s390                  randconfig-002-20260914    gcc-13.4.0
s390                 randconfig-r123-20260915    clang-24 sparse
s390                 randconfig-r131-20260915    gcc-11.5.0 sparse
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-24
sh                               allyesconfig    clang-17
sh                                  defconfig    gcc-14
sh                          kfr2r09_defconfig    gcc-16.1.0
sh                            migor_defconfig    gcc-16.1.0
sh                          r7780mp_defconfig    clang-24
sh                    randconfig-001-20260914    gcc-13.4.0
sh                    randconfig-002-20260914    gcc-13.4.0
sh                          sdk7786_defconfig    clang-21
sh                           se7705_defconfig    gcc-14
sh                           se7751_defconfig    gcc-16.1.0
sh                   sh7770_generic_defconfig    gcc-16.1.0
sparc                             allnoconfig    clang-24
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260914    gcc-16.1.0
sparc                 randconfig-001-20260915    gcc-13.4.0
sparc                 randconfig-002-20260914    gcc-16.1.0
sparc                 randconfig-002-20260915    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260914    gcc-16.1.0
sparc64               randconfig-001-20260915    gcc-13.4.0
sparc64               randconfig-002-20260914    gcc-16.1.0
sparc64               randconfig-002-20260915    gcc-13.4.0
sparc64              randconfig-r132-20260915    gcc-15.2.0 sparse
sparc64              randconfig-r133-20260915    gcc-15.2.0 sparse
sparc64              randconfig-r134-20260914    gcc-12.5.0 sparse
um                               allmodconfig    clang-17
um                                allnoconfig    clang-24
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260914    gcc-16.1.0
um                    randconfig-001-20260915    gcc-13.4.0
um                    randconfig-002-20260914    gcc-16.1.0
um                    randconfig-002-20260915    gcc-13.4.0
um                   randconfig-r132-20260915    gcc-11.5.0 sparse
um                   randconfig-r133-20260915    gcc-11.5.0 sparse
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-24
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260914    gcc-14
x86_64      buildonly-randconfig-001-20260915    clang-22
x86_64      buildonly-randconfig-002-20260914    gcc-14
x86_64      buildonly-randconfig-002-20260915    clang-22
x86_64      buildonly-randconfig-003-20260914    gcc-14
x86_64      buildonly-randconfig-003-20260915    clang-22
x86_64      buildonly-randconfig-004-20260914    gcc-14
x86_64      buildonly-randconfig-004-20260915    clang-22
x86_64      buildonly-randconfig-005-20260914    gcc-14
x86_64      buildonly-randconfig-005-20260915    clang-22
x86_64      buildonly-randconfig-006-20260914    gcc-14
x86_64      buildonly-randconfig-006-20260915    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-011-20260914    clang-22
x86_64                randconfig-011-20260915    gcc-14
x86_64                randconfig-012-20260914    clang-22
x86_64                randconfig-012-20260915    gcc-14
x86_64                randconfig-013-20260914    clang-22
x86_64                randconfig-013-20260915    gcc-14
x86_64                randconfig-014-20260914    clang-22
x86_64                randconfig-014-20260915    gcc-14
x86_64                randconfig-015-20260914    clang-22
x86_64                randconfig-015-20260915    gcc-14
x86_64                randconfig-016-20260914    clang-22
x86_64                randconfig-016-20260915    gcc-14
x86_64                randconfig-071-20260914    clang-22
x86_64                randconfig-071-20260915    clang-22
x86_64                randconfig-072-20260914    clang-22
x86_64                randconfig-072-20260915    clang-22
x86_64                randconfig-073-20260914    clang-22
x86_64                randconfig-073-20260915    clang-22
x86_64                randconfig-074-20260914    clang-22
x86_64                randconfig-074-20260915    clang-22
x86_64                randconfig-075-20260914    clang-22
x86_64                randconfig-075-20260915    clang-22
x86_64                randconfig-076-20260914    clang-22
x86_64                randconfig-076-20260915    clang-22
x86_64                randconfig-121-20260914    gcc-14 sparse
x86_64                randconfig-122-20260914    gcc-14 sparse
x86_64                randconfig-123-20260914    gcc-14 sparse
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                           alldefconfig    clang-24
xtensa                            allnoconfig    clang-24
xtensa                           allyesconfig    clang-20
xtensa                randconfig-001-20260914    gcc-16.1.0
xtensa                randconfig-001-20260915    gcc-13.4.0
xtensa                randconfig-002-20260914    gcc-16.1.0
xtensa                randconfig-002-20260915    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
