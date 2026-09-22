Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EC33C1F4F
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 06:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790059238; cv=none; b=kaIdp9pJ7C5UfljIcdl9OHlFUC1Uuh6Z5OwPQCEHYHRfTlKGJzo2PURYn53CrKQx9+q0SRNNJ6F8cTwKvvkn9W0862QWst2tC5MbWy1I5HVSPRTopi0ADpdLIN9keTexlqFR5XCmMamem3CcrQDP+SBE5BeYLpCD2gxcH6hHaEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790059238; c=relaxed/simple;
	bh=4KffkF5XH8pepkRR4jSMypQTteP6j58wBbansQA6ZQ8=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Jr/NZABMqatGIbXYWHMcgYBoTROINHDKICqXHtnqgKLvijyy8S8kVIawCBZfyanOPVu34WKvAHp7zKOniRwPkG2NXDl+pCLzsPMrO9VzEu13yottwOTWSJTfuiiM9wrjsAqQqZh4yH3oqaFuWNCQF4rFdx5TsWu7kvcehRtU0uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5rdphIP; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5rdphIP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790059236; x=1821595236;
  h=date:from:to:cc:subject:message-id;
  bh=4KffkF5XH8pepkRR4jSMypQTteP6j58wBbansQA6ZQ8=;
  b=T5rdphIPL9YO1tLJqAwJq8WXH4nDIqC2GmmhkWiJxVFMt4dSCKbAJo7I
   e3MCNIhWizIlXgHBLxnxafDjmdoyo0RzRKbQ/W9yyBuPBowDHpPeRlFvv
   qRuIrTS76HwTYPDF6wRknDkGa5bld0DnhV+OgG/l0Fua4jvqMNL5YgN/q
   HU0l1/piIOKPePbDEeGj/jtWuJ9d5UVVvqe1GwfBNWKpjH66dSFbb2MOQ
   7uYSGpZr8NBbm/9A5AASXl9JD2+RfmpPxVhkNMZdnoZbIZNWCtaPeK7AW
   K7Eop7XiXFw1by4siQvcsBtDFCGd2B1BisYFvCgIzWEYCzWdgUm5NgJ/+
   Q==;
X-CSE-ConnectionGUID: kwuS43bnTnS3avh8Pj4ANQ==
X-CSE-MsgGUID: LN8KjAUjTz+lYoCvrhAPYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90650713"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="90650713"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 23:40:32 -0700
X-CSE-ConnectionGUID: y9tXgbzVQK65x+nk06C43A==
X-CSE-MsgGUID: apeht96HRqmzv+4ThW3FMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="269523039"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 21 Sep 2026 23:40:31 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x8uB3-00000000F5r-08fn;
	Tue, 22 Sep 2026 06:40:29 +0000
Date: Tue, 22 Sep 2026 14:39:46 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.3-fixes] BUILD SUCCESS
 c774ec8f0a5d02a06d34c27f5a7de7e333b91265
Message-ID: <202609221443.71dFxQal-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3-fixes
branch HEAD: c774ec8f0a5d02a06d34c27f5a7de7e333b91265  selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode

elapsed time: 3814m

configs tested: 175
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r1303-20260922    gcc-14.3.0 sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260922    gcc-8.5.0
arc                   randconfig-1001-20260922    gcc-16.1.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                            h3600_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260922    gcc-16.1.0
arm                   randconfig-1001-20260922    gcc-10.5.0
arm                   randconfig-1002-20260922    clang-24
arm                   randconfig-1003-20260922    gcc-8.5.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260922    clang-24
arm64                 randconfig-1001-20260922    gcc-11.5.0
arm64                 randconfig-1002-20260922    gcc-9.5.0
arm64                 randconfig-1003-20260922    gcc-11.5.0
arm64                randconfig-r1308-20260921    clang-21   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260922    gcc-16.1.0
csky                  randconfig-1001-20260922    gcc-12.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260922    clang-17
hexagon               randconfig-1001-20260922    clang-17
hexagon              randconfig-r1300-20260922    clang-24   sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20260922    clang-22
i386        buildonly-randconfig-1001-20260922    clang-22
i386        buildonly-randconfig-1002-20260922    gcc-14
i386        buildonly-randconfig-1003-20260922    gcc-14
i386        buildonly-randconfig-1004-20260922    gcc-14
i386        buildonly-randconfig-1005-20260922    gcc-12
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260921    clang-22
i386                  randconfig-1001-20260921    clang-22
i386                  randconfig-1002-20260921    clang-22
i386                  randconfig-1003-20260921    gcc-14
i386                  randconfig-1004-20260921    gcc-13
i386                  randconfig-1005-20260921    clang-22
i386                  randconfig-1006-20260921    clang-22
i386                  randconfig-1007-20260921    gcc-14
i386                  randconfig-1008-20260921    clang-22
i386                  randconfig-1009-20260921    gcc-14
i386                  randconfig-1010-20260921    gcc-14
i386                  randconfig-1011-20260921    clang-22
i386                  randconfig-1012-20260921    clang-22
i386                  randconfig-1013-20260921    clang-22
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260922    gcc-16.1.0
loongarch             randconfig-1001-20260922    clang-18
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           eyeq6_defconfig    clang-24
mips                       loongson1_defconfig    gcc-16.1.0
mips                       loongson3_defconfig    gcc-16.1.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260922    gcc-10.5.0
nios2                 randconfig-1001-20260922    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260921    gcc-8.5.0
parisc                randconfig-1001-20260921    gcc-13.4.0
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                  canyonlands_defconfig    clang-22
powerpc                        ebony_defconfig    clang-24
powerpc                      rainier_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260921    clang-17
powerpc               randconfig-1001-20260921    clang-24
powerpc              randconfig-r1301-20260922    gcc-13.4.0 sparse
powerpc              randconfig-r1309-20260921    clang-22   sparse
powerpc                      redwood_defconfig    clang-24
powerpc64             randconfig-1000-20260921    gcc-10.5.0
powerpc64             randconfig-1001-20260921    gcc-8.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260922    gcc-8.5.0
riscv                 randconfig-1001-20260922    gcc-13.4.0
riscv                randconfig-r1302-20260922    clang-24   sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260922    clang-19
s390                  randconfig-1001-20260922    clang-21
s390                 randconfig-r1306-20260921    clang-17   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260922    gcc-10.5.0
sh                    randconfig-1001-20260922    gcc-16.1.0
sh                   randconfig-r1307-20260921    gcc-9.5.0  sparse
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260921    gcc-8.5.0
sparc                 randconfig-1001-20260921    gcc-11.5.0
sparc                randconfig-r1304-20260922    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260921    clang-21
sparc64               randconfig-1001-20260921    clang-22
sparc64              randconfig-r1305-20260922    gcc-8.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260921    gcc-14
um                    randconfig-1001-20260921    gcc-14
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20260921    clang-22
x86_64      buildonly-randconfig-1001-20260921    gcc-13
x86_64      buildonly-randconfig-1002-20260921    clang-22
x86_64      buildonly-randconfig-1003-20260921    clang-22
x86_64      buildonly-randconfig-1004-20260921    clang-22
x86_64      buildonly-randconfig-1005-20260921    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20260921    gcc-13
x86_64                randconfig-1001-20260921    clang-22
x86_64                randconfig-1002-20260921    gcc-14
x86_64                randconfig-1003-20260921    gcc-14
x86_64                randconfig-1004-20260921    clang-22
x86_64                randconfig-1005-20260921    clang-22
x86_64                randconfig-1006-20260922    clang-22
x86_64                randconfig-1007-20260922    gcc-14
x86_64                randconfig-1008-20260922    clang-22
x86_64                randconfig-1009-20260922    clang-22
x86_64                randconfig-1010-20260922    gcc-14
x86_64                randconfig-1011-20260922    clang-22
x86_64                randconfig-1012-20260922    clang-22
x86_64                randconfig-1013-20260922    gcc-14
x86_64                randconfig-1014-20260922    clang-22
x86_64                randconfig-1015-20260922    clang-22
x86_64                randconfig-1016-20260922    gcc-14
x86_64                randconfig-1017-20260922    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260921    gcc-11.5.0
xtensa                randconfig-1001-20260921    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
