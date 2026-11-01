Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793558469;
	b=NWE1NmiN3BQf8kNssLMA0ODxlN2TSR6yZjI65D0lvgUan3bEYXus396YD91i2MKMLhP0
	 eBbkUXVAZH1t+HxuZl1/eQYGbgsKIEgAryI+ywGdbKI3GI1fBSaGYciy7V9i9ix9IBtER
	 ZihYNB/RgBoMHob9FMx9JK6YFSkdnW+WvAxN0RAHAFN4w/V/P33I562GMatkBJBRkixgx
	 +9glIW3iRrNRmTVN92eXey7fUfJ65FyohkyyRrxUMvuZvzYXM/QXl/UkDQ9bAUqbNfHaO
	 daYbBMYYb4nch7ww+5hlt/uE8R/w5DnlIJOFai3BT2+buz6wmVHUa8PI65aE19RhFYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793558469;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=za06qCuR6PFQvbxVS7dP96UA0weC+QP/FtKUsgmmHOQ=;
	b=g5w1Rzxx7DmKRXAda6yIZ9myZcwcchjzYMM9w4CGOGSpoooLpVy+2PllThC/8whOXh0k
	 4Zt0wnABajjrs+6J2NjIsmlpCzekiR+tvf2dFMqPSBz5bDFttJ1is8rZjPBphv1Xk6fPM
	 9YzfuLnX5NnV/9GyxZmrkmV6F1yduC5tn0gSNV4HWw5iwVPXt3BhjAXKq4rM4IwMUY0Qb
	 gv0E0Rbq3e/kCB5f5yDaGf9EMHSyK96miEg5CsKja61+C5pHCOG3DTNwUIpI1C6dFa0ye
	 jqPir1x3v67zW+PE0LOGfY9LTq8blzuoMwQheXGjh9sQRRFfKXrDRZaxyhSxu44QnwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Rx5jyGmw;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98A6606A324
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 18:41:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C98A6606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Rx5jyGmw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793558467; x=1825094467;
  h=date:from:to:cc:subject:message-id;
  bh=VVfxC21E21UzJsuKlrjX+8qyZMBm9rssocAzbc12oVk=;
  b=Rx5jyGmwJylTlsFCHAV004wdPMDvSpoEeRtjfm6OeRkhJOwzNR42+yX2
   Kubc2IF/Sr0mbVG/yB2qRllIYeNMDWMOJ8KKFu8Us9e406E0Y+VrkAHmh
   Bb0695AmiJV6s/ItjljAZ6e8dbbftGWqpmUUS9jxY9xUH9fUCFq9xeb9h
   5wQrCRCk3/LEfPfBdz3Oiz71duR4AfoQj03U6KXdvrg3gbix6VSx6sUia
   OFuPXC0qefaIMHd/uXsV3rNtltF63KRtNmZP9Xyt3CaKaNHscKxXIe1+S
   G2KNKFd0tp5PJzsKs3ZsQ4bkoPpRrRiNOLpu+H2ZKhka0MEDq3dQh26Co
   Q==;
X-CSE-ConnectionGUID: F9OdhkORTQO+UKu9DvaKiw==
X-CSE-MsgGUID: tTJ8Yg//TCuUh2oEcf8KwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11953"; a="2139406"
X-IronPort-AV: E=Sophos;i="6.27,190,1787036400"; 
   d="scan'208";a="2139406"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2026 10:41:07 -0800
X-CSE-ConnectionGUID: R4wZHbybQ2ydEnzC8a3KaA==
X-CSE-MsgGUID: 7jl56lEnSf6ip9YUQuopLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,190,1787036400"; 
   d="scan'208";a="5772799"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 01 Nov 2026 10:41:06 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xNaUK-00000000fE8-0W8k;
	Sun, 01 Nov 2026 18:41:04 +0000
Date: Mon, 02 Nov 2026 02:40:36 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.5] BUILD SUCCESS
 63572eb9ab96bed176b33cca4f62c7c95946c812
Message-ID: <20261102024036.5DOk6Uaw-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.5
branch HEAD: 63572eb9ab96bed176b33cca4f62c7c95946c812  cgroup/cpuset: Drop redundant no-cpu check in partcmd_update with newmask

elapsed time: 2441m

configs tested: 248
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261031    gcc-9.5.0
arc                   randconfig-1000-20261101    clang-22
arc                   randconfig-1001-20261031    gcc-9.5.0
arc                   randconfig-1001-20261101    clang-22
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                           collie_defconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                           gemini_defconfig    gcc-16.2.0
arm                          mv78xx0_defconfig    gcc-16.2.0
arm                           pxa168_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261031    gcc-9.5.0
arm                   randconfig-1000-20261101    clang-22
arm                   randconfig-1001-20261031    gcc-9.5.0
arm                   randconfig-1001-20261101    clang-22
arm                   randconfig-1002-20261031    gcc-9.5.0
arm                   randconfig-1002-20261101    clang-22
arm                   randconfig-1003-20261031    gcc-9.5.0
arm                   randconfig-1003-20261101    clang-22
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261031    clang-24
arm64                 randconfig-1000-20261101    clang-22
arm64                 randconfig-1001-20261031    clang-24
arm64                 randconfig-1001-20261101    clang-22
arm64                 randconfig-1002-20261031    clang-24
arm64                 randconfig-1002-20261101    clang-22
arm64                 randconfig-1003-20261031    clang-24
arm64                 randconfig-1003-20261101    clang-22
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261031    clang-24
csky                  randconfig-1000-20261101    clang-22
csky                  randconfig-1001-20261031    clang-24
csky                  randconfig-1001-20261101    clang-22
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261101    gcc-16.2.0
hexagon               randconfig-1001-20261101    gcc-16.2.0
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261031    clang-22
i386        buildonly-randconfig-1000-20261101    gcc-14
i386        buildonly-randconfig-1001-20261031    clang-22
i386        buildonly-randconfig-1001-20261101    gcc-14
i386        buildonly-randconfig-1002-20261031    clang-22
i386        buildonly-randconfig-1002-20261101    gcc-14
i386        buildonly-randconfig-1003-20261031    clang-22
i386        buildonly-randconfig-1003-20261101    gcc-14
i386        buildonly-randconfig-1004-20261031    clang-22
i386        buildonly-randconfig-1004-20261101    gcc-14
i386        buildonly-randconfig-1005-20261031    clang-22
i386        buildonly-randconfig-1005-20261101    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261031    clang-22
i386                  randconfig-1000-20261101    gcc-14
i386                  randconfig-1001-20261031    clang-22
i386                  randconfig-1001-20261101    gcc-14
i386                  randconfig-1002-20261031    clang-22
i386                  randconfig-1002-20261101    gcc-14
i386                  randconfig-1003-20261031    clang-22
i386                  randconfig-1003-20261101    gcc-14
i386                  randconfig-1004-20261031    clang-22
i386                  randconfig-1004-20261101    gcc-14
i386                  randconfig-1005-20261031    clang-22
i386                  randconfig-1005-20261101    gcc-14
i386                  randconfig-1006-20261031    clang-22
i386                  randconfig-1006-20261101    gcc-14
i386                  randconfig-1007-20261031    gcc-14
i386                  randconfig-1007-20261101    clang-22
i386                  randconfig-1008-20261031    gcc-14
i386                  randconfig-1008-20261101    clang-22
i386                  randconfig-1009-20261031    gcc-14
i386                  randconfig-1009-20261101    clang-22
i386                  randconfig-1010-20261031    gcc-14
i386                  randconfig-1010-20261101    clang-22
i386                  randconfig-1011-20261031    gcc-14
i386                  randconfig-1011-20261101    clang-22
i386                  randconfig-1012-20261031    gcc-14
i386                  randconfig-1012-20261101    clang-22
i386                  randconfig-1013-20261031    gcc-14
i386                  randconfig-1013-20261101    clang-22
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261101    gcc-16.2.0
loongarch             randconfig-1001-20261101    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                          amcore_defconfig    gcc-16.2.0
m68k                           amiga_defconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                            virt_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                          bigsur_defconfig    gcc-16.2.0
mips                  decstation_r4k_defconfig    gcc-16.2.0
mips                      loongson2k_defconfig    gcc-16.2.0
mips                         maltaup_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261101    gcc-16.2.0
nios2                 randconfig-1001-20261101    gcc-16.2.0
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261031    gcc-13.5.0
parisc                randconfig-1000-20261101    gcc-8.5.0
parisc                randconfig-1001-20261031    gcc-13.5.0
parisc                randconfig-1001-20261101    gcc-8.5.0
parisc64                             defconfig    clang-24
powerpc                     adder875_defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                           g5_defconfig    gcc-16.2.0
powerpc                     ge_imp3a_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261031    gcc-13.5.0
powerpc               randconfig-1000-20261101    gcc-8.5.0
powerpc               randconfig-1001-20261031    gcc-13.5.0
powerpc               randconfig-1001-20261101    gcc-8.5.0
powerpc64             randconfig-1000-20261031    gcc-13.5.0
powerpc64             randconfig-1000-20261101    gcc-8.5.0
powerpc64             randconfig-1001-20261031    gcc-13.5.0
powerpc64             randconfig-1001-20261101    gcc-8.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261031    gcc-8.5.0
riscv                 randconfig-1000-20261101    gcc-8.5.0
riscv                 randconfig-1001-20261031    gcc-8.5.0
riscv                 randconfig-1001-20261101    gcc-8.5.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261031    gcc-8.5.0
s390                  randconfig-1000-20261101    gcc-8.5.0
s390                  randconfig-1001-20261031    gcc-8.5.0
s390                  randconfig-1001-20261101    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                         dreamcast_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261031    gcc-8.5.0
sh                    randconfig-1000-20261101    gcc-8.5.0
sh                    randconfig-1001-20261031    gcc-8.5.0
sh                    randconfig-1001-20261101    gcc-8.5.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261031    gcc-11.5.0
sparc                 randconfig-1000-20261101    gcc-8.5.0
sparc                 randconfig-1001-20261031    gcc-11.5.0
sparc                 randconfig-1001-20261101    gcc-8.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261031    gcc-11.5.0
sparc64               randconfig-1000-20261101    gcc-8.5.0
sparc64               randconfig-1001-20261031    gcc-11.5.0
sparc64               randconfig-1001-20261101    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261031    gcc-11.5.0
um                    randconfig-1000-20261101    gcc-8.5.0
um                    randconfig-1001-20261031    gcc-11.5.0
um                    randconfig-1001-20261101    gcc-8.5.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261101    clang-22
x86_64      buildonly-randconfig-1001-20261101    clang-22
x86_64      buildonly-randconfig-1002-20261101    clang-22
x86_64      buildonly-randconfig-1003-20261101    clang-22
x86_64      buildonly-randconfig-1004-20261101    clang-22
x86_64      buildonly-randconfig-1005-20261101    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261031    gcc-14
x86_64                randconfig-1000-20261101    gcc-14
x86_64                randconfig-1001-20261031    gcc-14
x86_64                randconfig-1001-20261101    gcc-14
x86_64                randconfig-1002-20261031    gcc-14
x86_64                randconfig-1002-20261101    gcc-14
x86_64                randconfig-1003-20261031    gcc-14
x86_64                randconfig-1003-20261101    gcc-14
x86_64                randconfig-1004-20261031    gcc-14
x86_64                randconfig-1004-20261101    gcc-14
x86_64                randconfig-1005-20261031    gcc-14
x86_64                randconfig-1005-20261101    gcc-14
x86_64                randconfig-1006-20261031    clang-22
x86_64                randconfig-1006-20261101    clang-22
x86_64                randconfig-1007-20261031    clang-22
x86_64                randconfig-1007-20261101    clang-22
x86_64                randconfig-1008-20261031    clang-22
x86_64                randconfig-1008-20261101    clang-22
x86_64                randconfig-1009-20261031    clang-22
x86_64                randconfig-1009-20261101    clang-22
x86_64                randconfig-1010-20261031    clang-22
x86_64                randconfig-1010-20261101    clang-22
x86_64                randconfig-1011-20261031    clang-22
x86_64                randconfig-1011-20261101    clang-22
x86_64                randconfig-1012-20261101    gcc-14
x86_64                randconfig-1013-20261101    gcc-14
x86_64                randconfig-1014-20261101    gcc-14
x86_64                randconfig-1015-20261101    gcc-14
x86_64                randconfig-1016-20261101    gcc-14
x86_64                randconfig-1017-20261101    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261031    gcc-11.5.0
xtensa                randconfig-1000-20261101    gcc-8.5.0
xtensa                randconfig-1001-20261031    gcc-11.5.0
xtensa                randconfig-1001-20261101    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
