Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4D3343D9D
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 05:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786684799; cv=none; b=OmLIYrktCcKDXuOgsus3hCIXxvfpIGpyugQJ/0pt9PSz/9lwqRB1kOpVzRpjcFLm/pdYJfFCz/ICEpmqLqdUhXPFwhTdRSEI2y9K6UvHIxhYnspKZXV8rDFSQx5yuthNmbLQxZmUosASIq8tOO7bT+TaLYLZqOM3ZLehiz3L1bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786684799; c=relaxed/simple;
	bh=jaQj8jS/hawl8Ur2wzOfU9E+NJSVXUw4UZm/bA1EGUk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=DAwsrZKcWqJlUfSi4mQ9rglB8uB4R4mlMXXxKAQyQPAZf9mnPo6NPvMnefqHAu+YbDHLU0HXHvSQVKPFJ2VdkONPu6NHgSzrC5oyJ1LHlpaymUxvfLca38ktYrdxOCKRgmh0UoA5b8Sj1hwqlU5T0Ef86XdHQAoIY5qGDkN6uI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NorYj4LT; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NorYj4LT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786684796; x=1818220796;
  h=date:from:to:cc:subject:message-id;
  bh=jaQj8jS/hawl8Ur2wzOfU9E+NJSVXUw4UZm/bA1EGUk=;
  b=NorYj4LTD0LaQkSTSdqJzATitBx1MIC/rKzKz+j3Y7ja8Q2vKBC0ZEgQ
   rhjbnIuenURiZ5c1+RYUaD8qZ/4QA6QQbNtN+LiLyKNSE85skHrXtFlnQ
   7RUqi1jflCAbPtjHrnsERsoBjXW9sbRnKcUq1CpRyRLjqLS5Qd77fnYi9
   iX/DRw+j5mrq5ALZz+88wKXS+YmwMEhSt26bUngGpTga7wcr6KBl48GWY
   90XpnWlYCWCTfi+7VUO3J3CgIfaVtcF+db0QEULvYWMNSc78sruGkEyBs
   16eltHzJRttQgfxGh9PBiJPlw9SpHPO/gwuWDQm3/bkIoP8uqJTznHsWJ
   w==;
X-CSE-ConnectionGUID: IYgrzbD5TJGthfsTZdzEyA==
X-CSE-MsgGUID: 89GEPM9aTresoYgSRGlW6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="97929338"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="97929338"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 22:19:51 -0700
X-CSE-ConnectionGUID: 64Vbnz1qQlO7bWb84WKIww==
X-CSE-MsgGUID: zfYKRM2tSI2DgIobvkbHww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="302370953"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 13 Aug 2026 22:19:51 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wukKa-00000000XqG-44uW;
	Fri, 14 Aug 2026 05:19:48 +0000
Date: Fri, 14 Aug 2026 13:19:31 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 5c37027ab53fba3f9cd95230f76d30f0df19329d
Message-ID: <202608141320.a5c6fpgm-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 5c37027ab53fba3f9cd95230f76d30f0df19329d  Merge branch 'for-7.3' into for-next

elapsed time: 2516m

configs tested: 135
configs skipped: 6

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260813    gcc-13.4.0
arc                  randconfig-001-20260814    gcc-10.5.0
arc                  randconfig-002-20260813    gcc-13.4.0
arc                  randconfig-002-20260814    gcc-10.5.0
arm                         exynos_defconfig    clang-17
arm                       keystone_defconfig    gcc-16.1.0
arm                  randconfig-001-20260813    gcc-13.4.0
arm                  randconfig-001-20260814    gcc-10.5.0
arm                  randconfig-002-20260813    gcc-13.4.0
arm                  randconfig-002-20260814    gcc-10.5.0
arm                  randconfig-003-20260813    gcc-13.4.0
arm                  randconfig-003-20260814    gcc-10.5.0
arm                  randconfig-004-20260813    gcc-13.4.0
arm                  randconfig-004-20260814    gcc-10.5.0
arm64                randconfig-001-20260813    gcc-16.1.0
arm64                randconfig-002-20260813    gcc-16.1.0
arm64                randconfig-003-20260813    gcc-16.1.0
arm64                randconfig-004-20260813    gcc-16.1.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260813    gcc-16.1.0
csky                 randconfig-002-20260813    gcc-16.1.0
hexagon              randconfig-001-20260813    gcc-11.5.0
hexagon              randconfig-002-20260813    gcc-11.5.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-14
i386       buildonly-randconfig-001-20260813    gcc-14
i386       buildonly-randconfig-001-20260814    clang-22
i386       buildonly-randconfig-002-20260813    gcc-14
i386       buildonly-randconfig-002-20260814    clang-22
i386       buildonly-randconfig-003-20260813    gcc-14
i386       buildonly-randconfig-003-20260814    clang-22
i386       buildonly-randconfig-004-20260813    gcc-14
i386       buildonly-randconfig-004-20260814    clang-22
i386       buildonly-randconfig-005-20260813    gcc-14
i386       buildonly-randconfig-005-20260814    clang-22
i386       buildonly-randconfig-006-20260813    gcc-14
i386       buildonly-randconfig-006-20260814    clang-22
i386                 randconfig-001-20260813    clang-22
i386                 randconfig-002-20260813    clang-22
i386                 randconfig-003-20260813    clang-22
i386                 randconfig-004-20260813    clang-22
i386                 randconfig-005-20260813    clang-22
i386                 randconfig-006-20260813    clang-22
i386                 randconfig-007-20260813    clang-22
i386                          randconfig-011    clang-22
i386                 randconfig-011-20260813    clang-22
i386                 randconfig-012-20260813    clang-22
i386                 randconfig-013-20260813    clang-22
i386                 randconfig-014-20260813    clang-22
i386                 randconfig-015-20260813    clang-22
i386                 randconfig-016-20260813    clang-22
i386                 randconfig-017-20260813    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260813    gcc-11.5.0
loongarch            randconfig-002-20260813    gcc-11.5.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260813    gcc-11.5.0
nios2                randconfig-002-20260813    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-10.5.0
parisc               randconfig-001-20260813    gcc-10.5.0
parisc               randconfig-002-20260813    gcc-10.5.0
powerpc                   adder875_defconfig    gcc-16.1.0
powerpc                 mpc866_ads_defconfig    clang-17
powerpc              randconfig-001-20260813    gcc-10.5.0
powerpc              randconfig-002-20260813    gcc-10.5.0
powerpc                    taishan_defconfig    clang-21
powerpc64            randconfig-001-20260813    gcc-10.5.0
powerpc64            randconfig-002-20260813    gcc-10.5.0
riscv                         randconfig-001    gcc-10.5.0
riscv                randconfig-001-20260813    gcc-10.5.0
riscv                randconfig-001-20260814    gcc-13.4.0
riscv                randconfig-002-20260813    gcc-10.5.0
riscv                randconfig-002-20260814    gcc-13.4.0
s390                 randconfig-001-20260813    gcc-10.5.0
s390                 randconfig-001-20260814    gcc-13.4.0
s390                 randconfig-002-20260813    gcc-10.5.0
s390                 randconfig-002-20260814    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260813    gcc-10.5.0
sh                   randconfig-001-20260814    gcc-13.4.0
sh                   randconfig-002-20260813    gcc-10.5.0
sh                   randconfig-002-20260814    gcc-13.4.0
sparc                         randconfig-001    clang-20
sparc                randconfig-001-20260813    clang-20
sparc                randconfig-001-20260814    clang-24
sparc                randconfig-002-20260813    clang-20
sparc                randconfig-002-20260814    clang-24
sparc64              randconfig-001-20260813    clang-20
sparc64              randconfig-001-20260814    clang-24
sparc64              randconfig-002-20260813    clang-20
sparc64              randconfig-002-20260814    clang-24
um                   randconfig-001-20260813    clang-20
um                   randconfig-001-20260814    clang-24
um                   randconfig-002-20260813    clang-20
um                   randconfig-002-20260814    clang-24
x86_64     buildonly-randconfig-001-20260813    gcc-14
x86_64     buildonly-randconfig-002-20260813    gcc-14
x86_64     buildonly-randconfig-003-20260813    gcc-14
x86_64     buildonly-randconfig-004-20260813    gcc-14
x86_64     buildonly-randconfig-005-20260813    gcc-14
x86_64     buildonly-randconfig-006-20260813    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260813    gcc-13
x86_64               randconfig-002-20260813    gcc-13
x86_64               randconfig-003-20260813    gcc-13
x86_64               randconfig-004-20260813    gcc-13
x86_64               randconfig-005-20260813    gcc-13
x86_64               randconfig-006-20260813    gcc-13
x86_64               randconfig-011-20260813    gcc-14
x86_64               randconfig-012-20260813    gcc-14
x86_64               randconfig-013-20260813    gcc-14
x86_64               randconfig-014-20260813    gcc-14
x86_64               randconfig-015-20260813    gcc-14
x86_64               randconfig-016-20260813    gcc-14
x86_64                        randconfig-071    gcc-14
x86_64               randconfig-071-20260813    gcc-14
x86_64               randconfig-072-20260813    gcc-14
x86_64               randconfig-073-20260813    gcc-14
x86_64               randconfig-074-20260813    gcc-14
x86_64               randconfig-075-20260813    gcc-14
x86_64               randconfig-076-20260813    gcc-14
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260813    clang-20
xtensa               randconfig-001-20260814    clang-24
xtensa               randconfig-002-20260813    clang-20
xtensa               randconfig-002-20260814    clang-24

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
