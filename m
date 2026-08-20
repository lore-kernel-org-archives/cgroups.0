Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485282D47F4
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 22:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787263611; cv=none; b=Hqi/XPDdY3nD/jWT1rOqHkWDzHHEU5lB9XesxVSfld7WUpYi/HOPAOMd34qfV5OqffjmYs8h3d+dnarLRJ3BRMs1os+Q7kKD9f1FTIUV4++UbiNF39oZMJAMhN95hagpiWTwlqZE3SanQfZ6a8je20cfDpA5EEYe30UlGYUqPG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787263611; c=relaxed/simple;
	bh=Fz3VaSTls2K/47oN4CgG5Di2GF0YsUsYrXgHzG7Kyo8=;
	h=Date:From:To:Cc:Subject:Message-ID; b=gYvtS6Om2jXv+ft5fYHvTO+PIcF65rCg5hqEL+YZZpwJnTKVJec6+0K1Geyus1bFh5bUGt/Aj0YUklos2mMpXSHtcSQmpCsfgb8zIDMeYtC/W7q1Kk1fu+++eDFG8lKs0gqOnsf6JF9nrsXpY+/NfQHq1LTm1bm8eqfPslhVNj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ektehcxr; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ektehcxr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787263610; x=1818799610;
  h=date:from:to:cc:subject:message-id;
  bh=Fz3VaSTls2K/47oN4CgG5Di2GF0YsUsYrXgHzG7Kyo8=;
  b=EktehcxrFabbnQ7EBizc12vuqCY7fEYortSMS5VfcIONLQtE8Wipjatt
   F6KnLx1GqopsuEpg8eK7/rVh7sUvye8MuX1qLksyqdFNuqJUdNxZAfRxq
   Pf1CUjJE6oTP/P8REvW+8T772RKeJgHUCb67NSHO2YdFID72MvC7jDTwP
   kQTpzb5RrPMeYsxzpGBHS2SSYpgy8da0qoFkK/2zyxVWbwoY83c2KCp2w
   NdWiZ/D9FcHLFwupl1AAApkiexCWvJcgQZvFttfK3QeQSyy7PsATKcT7P
   20UEvwETN9azTkR8T8oYNwxaBQCoGmdEXr2gExMxly7n+1uLqMiwNTVWh
   g==;
X-CSE-ConnectionGUID: 6D8egaVsRzu3d1+bfJm4kA==
X-CSE-MsgGUID: ZASqz0KJRjGoHmNAOi9JXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="105191726"
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="105191726"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 15:06:43 -0700
X-CSE-ConnectionGUID: pM3GvRFQT4qQONWBOLLFLg==
X-CSE-MsgGUID: cDcOM7/6RLm7WURhHfJcXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="262874966"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 20 Aug 2026 15:06:41 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wxAuE-00000000npO-2vWs;
	Thu, 20 Aug 2026 22:06:38 +0000
Date: Fri, 21 Aug 2026 06:06:01 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 e0c62cce00d19e9d9d6edc845e38b2ecb505daed
Message-ID: <202608210649.QKN1Nbgr-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: e0c62cce00d19e9d9d6edc845e38b2ecb505daed  Merge branch 'for-7.3-fixes' into for-next

elapsed time: 1493m

configs tested: 151
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    clang-24
arc                  randconfig-001-20260820    clang-24
arc                  randconfig-002-20260820    clang-24
arm                  randconfig-001-20260820    clang-24
arm                  randconfig-002-20260820    clang-24
arm                  randconfig-003-20260820    clang-24
arm                  randconfig-004-20260820    clang-24
arm                          sunxi_defconfig    gcc-16.1.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260820    clang-24
arm64                randconfig-001-20260820    gcc-14.3.0
arm64                randconfig-001-20260821    gcc-8.5.0
arm64                randconfig-002-20260820    clang-24
arm64                randconfig-002-20260820    gcc-14.3.0
arm64                randconfig-002-20260821    gcc-8.5.0
arm64                randconfig-003-20260820    clang-24
arm64                randconfig-003-20260820    gcc-14.3.0
arm64                randconfig-003-20260821    gcc-8.5.0
arm64                randconfig-004-20260820    clang-24
arm64                randconfig-004-20260820    gcc-14.3.0
arm64                randconfig-004-20260821    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260820    clang-24
csky                 randconfig-001-20260820    gcc-14.3.0
csky                 randconfig-001-20260821    gcc-8.5.0
csky                 randconfig-002-20260820    clang-24
csky                 randconfig-002-20260820    gcc-14.3.0
csky                 randconfig-002-20260821    gcc-8.5.0
hexagon                       randconfig-001    gcc-14.3.0
hexagon              randconfig-001-20260820    gcc-14.3.0
hexagon              randconfig-002-20260820    gcc-14.3.0
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260820    gcc-14
i386       buildonly-randconfig-001-20260821    gcc-14
i386       buildonly-randconfig-002-20260820    gcc-14
i386       buildonly-randconfig-002-20260821    gcc-14
i386       buildonly-randconfig-003-20260820    gcc-14
i386       buildonly-randconfig-003-20260821    gcc-14
i386       buildonly-randconfig-004-20260820    gcc-14
i386       buildonly-randconfig-004-20260821    gcc-14
i386       buildonly-randconfig-005-20260820    gcc-14
i386       buildonly-randconfig-005-20260821    gcc-14
i386       buildonly-randconfig-006-20260820    gcc-14
i386       buildonly-randconfig-006-20260821    gcc-14
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260820    clang-22
i386                 randconfig-002-20260820    clang-22
i386                 randconfig-003-20260820    clang-22
i386                 randconfig-004-20260820    clang-22
i386                 randconfig-005-20260820    clang-22
i386                 randconfig-006-20260820    clang-22
i386                 randconfig-007-20260820    clang-22
i386                          randconfig-011    gcc-14
i386                 randconfig-011-20260820    gcc-14
i386                 randconfig-012-20260820    gcc-14
i386                 randconfig-013-20260820    gcc-14
i386                 randconfig-014-20260820    gcc-14
i386                 randconfig-015-20260820    gcc-14
i386                 randconfig-016-20260820    gcc-14
i386                 randconfig-017-20260820    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260820    gcc-14.3.0
loongarch            randconfig-002-20260820    gcc-14.3.0
m68k                          sun3_defconfig    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260820    gcc-14.3.0
nios2                randconfig-002-20260820    gcc-14.3.0
openrisc        de0_nano_multicore_defconfig    gcc-16.1.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-8.5.0
parisc               randconfig-001-20260820    gcc-8.5.0
parisc               randconfig-002-20260820    gcc-8.5.0
powerpc              randconfig-001-20260820    gcc-8.5.0
powerpc              randconfig-002-20260820    gcc-8.5.0
powerpc                    sequoia_defconfig    clang-24
powerpc64            randconfig-001-20260820    gcc-8.5.0
powerpc64            randconfig-002-20260820    gcc-8.5.0
riscv                         randconfig-001    clang-24
riscv                randconfig-001-20260820    clang-24
riscv                randconfig-001-20260821    clang-24
riscv                randconfig-002-20260820    clang-24
riscv                randconfig-002-20260821    clang-24
s390                 randconfig-001-20260820    clang-24
s390                 randconfig-001-20260821    clang-24
s390                 randconfig-002-20260820    clang-24
s390                 randconfig-002-20260821    clang-24
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260820    clang-24
sh                   randconfig-001-20260821    clang-24
sh                   randconfig-002-20260820    clang-24
sh                   randconfig-002-20260821    clang-24
sparc                         randconfig-001    gcc-8.5.0
sparc                randconfig-001-20260820    gcc-13.4.0
sparc                randconfig-001-20260821    gcc-8.5.0
sparc                randconfig-002-20260820    gcc-13.4.0
sparc                randconfig-002-20260821    gcc-8.5.0
sparc                      sparc64_defconfig    gcc-16.1.0
sparc64              randconfig-001-20260820    gcc-13.4.0
sparc64              randconfig-001-20260821    gcc-8.5.0
sparc64              randconfig-002-20260820    gcc-13.4.0
sparc64              randconfig-002-20260821    gcc-8.5.0
um                   randconfig-001-20260820    gcc-13.4.0
um                   randconfig-001-20260821    gcc-8.5.0
um                   randconfig-002-20260820    gcc-13.4.0
um                   randconfig-002-20260821    gcc-8.5.0
x86_64     buildonly-randconfig-001-20260820    gcc-14
x86_64     buildonly-randconfig-002-20260820    gcc-14
x86_64     buildonly-randconfig-003-20260820    gcc-14
x86_64     buildonly-randconfig-004-20260820    gcc-14
x86_64     buildonly-randconfig-005-20260820    gcc-14
x86_64     buildonly-randconfig-006-20260820    gcc-14
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260820    clang-22
x86_64               randconfig-002-20260820    clang-22
x86_64               randconfig-003-20260820    clang-22
x86_64               randconfig-004-20260820    clang-22
x86_64               randconfig-005-20260820    clang-22
x86_64               randconfig-006-20260820    clang-22
x86_64               randconfig-011-20260820    clang-22
x86_64               randconfig-012-20260820    clang-22
x86_64               randconfig-013-20260820    clang-22
x86_64               randconfig-014-20260820    clang-22
x86_64               randconfig-015-20260820    clang-22
x86_64               randconfig-016-20260820    clang-22
x86_64                        randconfig-071    gcc-14
x86_64               randconfig-071-20260820    clang-22
x86_64               randconfig-071-20260820    gcc-14
x86_64               randconfig-072-20260820    clang-22
x86_64               randconfig-072-20260820    gcc-14
x86_64               randconfig-073-20260820    clang-22
x86_64               randconfig-073-20260820    gcc-14
x86_64               randconfig-074-20260820    clang-22
x86_64               randconfig-074-20260820    gcc-14
x86_64               randconfig-075-20260820    clang-22
x86_64               randconfig-075-20260820    gcc-14
x86_64               randconfig-076-20260820    clang-22
x86_64               randconfig-076-20260820    gcc-14
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260820    gcc-13.4.0
xtensa               randconfig-001-20260821    gcc-8.5.0
xtensa               randconfig-002-20260820    gcc-13.4.0
xtensa               randconfig-002-20260821    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
