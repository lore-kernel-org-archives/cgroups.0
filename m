Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0E72E8E09
	for <cgroups@vger.kernel.org>; Mon,  3 Aug 2026 22:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785794936; cv=none; b=ivemKY7FUtoNjnUrv9IJPGH6c7DzaRUj4xS+CPLAO8p79eAzkkdM6uO/4WWyHvYoiEJm/NFwo0IJ0C6W1SzOT08sZ1ZN9j8dulQSPdd0BX8IxTzDXVrrrby+umBk54MNbE4QmHEQFAqrDNafa9ddpW+0ZO28yN4X4plsBd+Drtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785794936; c=relaxed/simple;
	bh=Fswvsls2nW/VBsuG60aZMym8egLhK7A8l7uJstezVK8=;
	h=Date:From:To:Cc:Subject:Message-ID; b=huSGAPY1SxXdw3Rv8nA5rhUNo3yAMTn3a+USImcR3m31F0hkjdMpgRqCZIjfPJBZu6NTnLc0uVcLYa7jvOwjUaVXix7yqXPqthwh6xDCDmCpfl2HLcDudUrnl97OV0JSBkvTnE79SreXbFUstfQSW3JolaKkhrJLwCfYjNCKPVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E77E1cCV; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E77E1cCV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785794935; x=1817330935;
  h=date:from:to:cc:subject:message-id;
  bh=Fswvsls2nW/VBsuG60aZMym8egLhK7A8l7uJstezVK8=;
  b=E77E1cCVKzFdPOECcO8u9N7xvuKCL0jrl16v4bPwHpintTP5+HD74Eie
   7krmM9vY43dEJKXIS4cZGkjUFvWARm+u7MfA363Xb4xCIuUgZ0u/x1DOb
   bi4gajYwnwzzX0DI8q36TvQUXT7M5OMsBTT+m7BTOtjstkOC+yBRFmdvb
   y8lx1t3tCAWjEvlY6EOEtlmaAcxvTVMlk6xv9HOEb2TDikwolN/dNmWVl
   f15j5G3/b5d+2MIBmZLEiWjOU15C3goS1z2gEzrySKYzJ+lWGdhDoJe+v
   bsRrWreLbMiCp0tPNgVk78eFnoE3hfyKErwFcSo94L+HREj2FgI7LAxbx
   Q==;
X-CSE-ConnectionGUID: GEgFewwaSKuNpKDSW97+sA==
X-CSE-MsgGUID: PwDTX/1DSKOBbLJ80PYdJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86350827"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="86350827"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 15:08:55 -0700
X-CSE-ConnectionGUID: oT6Ok8osTxy1jI/zmkzbnQ==
X-CSE-MsgGUID: PmwTDGoCQzKHjCtm/aC3xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="265167597"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 03 Aug 2026 15:08:53 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wr0q2-0000000085O-3slJ;
	Mon, 03 Aug 2026 22:08:50 +0000
Date: Tue, 04 Aug 2026 06:08:40 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.3] BUILD SUCCESS
 77bc7e952f660a7bab9741fe352f960f3675a650
Message-ID: <202608040620.qs1Yc8N4-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3
branch HEAD: 77bc7e952f660a7bab9741fe352f960f3675a650  selftests/cgroup: add user_usec sanity check in test_cpucg_nice

elapsed time: 734m

configs tested: 166
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260803    gcc-8.5.0
arc                  randconfig-001-20260804    gcc-8.5.0
arc                  randconfig-002-20260803    gcc-8.5.0
arc                  randconfig-002-20260804    gcc-8.5.0
arm                  randconfig-001-20260803    gcc-8.5.0
arm                  randconfig-001-20260804    gcc-8.5.0
arm                  randconfig-002-20260803    gcc-8.5.0
arm                  randconfig-002-20260804    gcc-8.5.0
arm                  randconfig-003-20260803    gcc-8.5.0
arm                  randconfig-003-20260804    gcc-8.5.0
arm                  randconfig-004-20260803    gcc-8.5.0
arm                  randconfig-004-20260804    gcc-8.5.0
arm                          stm32_defconfig    gcc-16.1.0
arm64                randconfig-001-20260803    gcc-12.5.0
arm64                randconfig-001-20260804    gcc-11.5.0
arm64                randconfig-002-20260803    gcc-12.5.0
arm64                randconfig-002-20260804    gcc-11.5.0
arm64                randconfig-003-20260803    gcc-12.5.0
arm64                randconfig-003-20260804    gcc-11.5.0
arm64                randconfig-004-20260803    gcc-12.5.0
arm64                randconfig-004-20260804    gcc-11.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260803    gcc-12.5.0
csky                 randconfig-001-20260804    gcc-11.5.0
csky                 randconfig-002-20260803    gcc-12.5.0
csky                 randconfig-002-20260804    gcc-11.5.0
hexagon              randconfig-001-20260803    clang-18
hexagon              randconfig-001-20260804    gcc-16.1.0
hexagon              randconfig-002-20260803    clang-18
hexagon              randconfig-002-20260804    gcc-16.1.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    clang-22
i386       buildonly-randconfig-001-20260803    clang-22
i386       buildonly-randconfig-002-20260803    clang-22
i386       buildonly-randconfig-003-20260803    clang-22
i386       buildonly-randconfig-004-20260803    clang-22
i386       buildonly-randconfig-005-20260803    clang-22
i386       buildonly-randconfig-006-20260803    clang-22
i386                          randconfig-001    gcc-13
i386                 randconfig-001-20260803    gcc-13
i386                 randconfig-001-20260804    clang-22
i386                 randconfig-002-20260803    gcc-13
i386                 randconfig-002-20260804    clang-22
i386                 randconfig-003-20260803    gcc-13
i386                 randconfig-003-20260804    clang-22
i386                 randconfig-004-20260803    gcc-13
i386                 randconfig-004-20260804    clang-22
i386                 randconfig-005-20260803    gcc-13
i386                 randconfig-005-20260804    clang-22
i386                 randconfig-006-20260803    gcc-13
i386                 randconfig-006-20260804    clang-22
i386                 randconfig-007-20260803    gcc-13
i386                 randconfig-007-20260804    clang-22
i386                 randconfig-011-20260803    clang-22
i386                 randconfig-011-20260803    gcc-14
i386                 randconfig-012-20260803    clang-22
i386                 randconfig-013-20260803    clang-22
i386                 randconfig-013-20260803    gcc-14
i386                 randconfig-014-20260803    clang-22
i386                 randconfig-014-20260803    gcc-14
i386                 randconfig-015-20260803    clang-22
i386                 randconfig-015-20260803    gcc-14
i386                 randconfig-016-20260803    clang-22
i386                 randconfig-017-20260803    clang-22
i386                 randconfig-017-20260803    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260803    clang-18
loongarch            randconfig-001-20260804    gcc-16.1.0
loongarch            randconfig-002-20260803    clang-18
loongarch            randconfig-002-20260804    gcc-16.1.0
mips                    decstation_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260803    clang-18
nios2                randconfig-001-20260804    gcc-16.1.0
nios2                randconfig-002-20260803    clang-18
nios2                randconfig-002-20260804    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-15.2.0
parisc               randconfig-001-20260803    gcc-15.2.0
parisc               randconfig-001-20260804    gcc-8.5.0
parisc               randconfig-002-20260803    gcc-15.2.0
parisc               randconfig-002-20260804    gcc-8.5.0
powerpc              randconfig-001-20260803    gcc-15.2.0
powerpc              randconfig-001-20260804    gcc-8.5.0
powerpc              randconfig-002-20260803    gcc-15.2.0
powerpc              randconfig-002-20260804    gcc-8.5.0
powerpc                    redwood_defconfig    clang-24
powerpc                    taishan_defconfig    clang-21
powerpc64            randconfig-001-20260803    gcc-15.2.0
powerpc64            randconfig-001-20260804    gcc-8.5.0
powerpc64            randconfig-002-20260803    gcc-15.2.0
powerpc64            randconfig-002-20260804    gcc-8.5.0
riscv                         randconfig-001    gcc-8.5.0
riscv                randconfig-001-20260803    gcc-8.5.0
riscv                randconfig-002-20260803    gcc-8.5.0
s390                 randconfig-001-20260803    gcc-8.5.0
s390                 randconfig-002-20260803    gcc-8.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260803    gcc-8.5.0
sh                   randconfig-002-20260803    gcc-8.5.0
sparc                randconfig-001-20260803    gcc-16.1.0
sparc                randconfig-001-20260803    gcc-8.5.0
sparc                randconfig-001-20260804    gcc-16.1.0
sparc                randconfig-002-20260803    gcc-16.1.0
sparc                randconfig-002-20260804    gcc-16.1.0
sparc64              randconfig-001-20260803    gcc-15.2.0
sparc64              randconfig-001-20260803    gcc-16.1.0
sparc64              randconfig-001-20260804    gcc-16.1.0
sparc64              randconfig-002-20260803    clang-24
sparc64              randconfig-002-20260803    gcc-16.1.0
sparc64              randconfig-002-20260804    gcc-16.1.0
um                   randconfig-001-20260803    gcc-13
um                   randconfig-001-20260803    gcc-16.1.0
um                   randconfig-001-20260804    gcc-16.1.0
um                   randconfig-002-20260803    clang-24
um                   randconfig-002-20260803    gcc-16.1.0
um                   randconfig-002-20260804    gcc-16.1.0
x86_64     buildonly-randconfig-001-20260803    clang-22
x86_64     buildonly-randconfig-002-20260803    clang-22
x86_64     buildonly-randconfig-003-20260803    clang-22
x86_64     buildonly-randconfig-004-20260803    clang-22
x86_64     buildonly-randconfig-005-20260803    clang-22
x86_64     buildonly-randconfig-006-20260803    clang-22
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260803    gcc-14
x86_64               randconfig-002-20260803    gcc-14
x86_64               randconfig-003-20260803    gcc-14
x86_64               randconfig-004-20260803    gcc-14
x86_64               randconfig-005-20260803    gcc-14
x86_64               randconfig-006-20260803    gcc-14
x86_64               randconfig-011-20260803    gcc-14
x86_64               randconfig-011-20260804    clang-22
x86_64               randconfig-012-20260803    gcc-14
x86_64               randconfig-012-20260804    clang-22
x86_64               randconfig-013-20260803    gcc-14
x86_64               randconfig-013-20260804    clang-22
x86_64               randconfig-014-20260803    gcc-14
x86_64               randconfig-014-20260804    clang-22
x86_64               randconfig-015-20260803    gcc-14
x86_64               randconfig-015-20260804    clang-22
x86_64               randconfig-016-20260803    gcc-14
x86_64               randconfig-016-20260804    clang-22
x86_64                        randconfig-071    clang-22
x86_64               randconfig-071-20260803    clang-22
x86_64               randconfig-071-20260803    gcc-14
x86_64               randconfig-072-20260803    clang-22
x86_64               randconfig-073-20260803    clang-22
x86_64               randconfig-074-20260803    clang-22
x86_64               randconfig-075-20260803    clang-22
x86_64               randconfig-076-20260803    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260803    gcc-16.1.0
xtensa               randconfig-001-20260803    gcc-8.5.0
xtensa               randconfig-001-20260804    gcc-16.1.0
xtensa               randconfig-002-20260803    gcc-16.1.0
xtensa               randconfig-002-20260803    gcc-8.5.0
xtensa               randconfig-002-20260804    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
