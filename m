Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F8F27A92D
	for <cgroups@vger.kernel.org>; Mon,  3 Aug 2026 22:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785795992; cv=none; b=SPyMPTBc4pfFCSakv5ohUat6REYK4Gg88DcOniS4istj6ugEISk9DATeGJHDgkB2tOWg+vUTnZNnn42Byk7j2g+1Ccjcdd9Pq0ibOazX1ARQ+Q4htG/3645xuZwds7oJ1wLCCiR6J4a3DF8+cDw1J4rmfJrMYH5I4RC3qxqq8kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785795992; c=relaxed/simple;
	bh=9M/b72jBZi2MlJ3o5bc7n9MSHbw24wb3eDOWgimu4BQ=;
	h=Date:From:To:Cc:Subject:Message-ID; b=DAth9ii8YgTiDEGR5t1ts5CFJ6k8OoRcZx4bKRZMOr7/QbaRfktDIcARVR89Lal5BYIpBjY55t+q4HOgrapfMSSx6XgXAhdTp7SKdXLGfQiHbsQGjtuaO0caG51NxrOZ0ZEly6clXTBvk4hk6v3S1jgsCe080qr5GGzdutP43Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MjR4x52e; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MjR4x52e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785795990; x=1817331990;
  h=date:from:to:cc:subject:message-id;
  bh=9M/b72jBZi2MlJ3o5bc7n9MSHbw24wb3eDOWgimu4BQ=;
  b=MjR4x52eULp8QWVYsohx8JWzznL3mg3YfnJpCQklidlnjvdTG5k48BOh
   XokLDYg8XgmqOVXZw/pzfecwtGEthPVMxyM17h0ksXTsJqIyW70CLCKzT
   hLs6SmOqGhFTP8ZWkbG+v/MZhsjdKe9ApVGZcTY5HWn3v54k7RzBvyIay
   xM1Qx5iyYXf73E3kyw59RJzqluqo2Gaf3VydizPwEUYuR5p1PvmTU+nrH
   Qw9Si7dPw1DYtUaQ+hpLDU3lhc6Be1MXcpp9eOxKk0JQtePCORpvCULrZ
   Wk3PD8gICrrogl8gpfRbLJkHSaipRpFj0xeq/F/dD3qYh6eOwoNmFm7R4
   Q==;
X-CSE-ConnectionGUID: XZCBnPoISs2uRnT6Mo7Kuw==
X-CSE-MsgGUID: bV9W38ZtQoq3TxfJnqZnMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="73878977"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="73878977"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 15:26:29 -0700
X-CSE-ConnectionGUID: CmmTzVoDQX2rjr02P5XjdQ==
X-CSE-MsgGUID: my0zYPvxQpiqKtmo0/hrqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="260738302"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 03 Aug 2026 15:26:27 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wr173-0000000089A-1tfZ;
	Mon, 03 Aug 2026 22:26:25 +0000
Date: Tue, 04 Aug 2026 06:26:10 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 d81a3aae853f3975f6e549a187acdf22a42d64b1
Message-ID: <202608040656.Vr3KQyzt-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: d81a3aae853f3975f6e549a187acdf22a42d64b1  Merge branch 'for-7.2-fixes' into for-next

elapsed time: 750m

configs tested: 178
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
i386       buildonly-randconfig-001-20260804    gcc-14
i386       buildonly-randconfig-002-20260803    clang-22
i386       buildonly-randconfig-002-20260804    gcc-14
i386       buildonly-randconfig-003-20260803    clang-22
i386       buildonly-randconfig-003-20260804    gcc-14
i386       buildonly-randconfig-004-20260803    clang-22
i386       buildonly-randconfig-004-20260804    gcc-14
i386       buildonly-randconfig-005-20260803    clang-22
i386       buildonly-randconfig-005-20260804    gcc-14
i386       buildonly-randconfig-006-20260803    clang-22
i386       buildonly-randconfig-006-20260804    gcc-14
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
i386                 randconfig-011-20260804    gcc-13
i386                 randconfig-012-20260803    clang-22
i386                 randconfig-012-20260804    gcc-13
i386                 randconfig-013-20260803    clang-22
i386                 randconfig-013-20260804    gcc-13
i386                 randconfig-014-20260803    clang-22
i386                 randconfig-014-20260804    gcc-13
i386                 randconfig-015-20260803    clang-22
i386                 randconfig-015-20260804    gcc-13
i386                 randconfig-016-20260803    clang-22
i386                 randconfig-016-20260804    gcc-13
i386                 randconfig-017-20260803    clang-22
i386                 randconfig-017-20260804    gcc-13
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260803    clang-18
loongarch            randconfig-001-20260804    gcc-16.1.0
loongarch            randconfig-002-20260803    clang-18
loongarch            randconfig-002-20260804    gcc-16.1.0
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
powerpc                      eiger_defconfig    clang-24
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
sparc                randconfig-001-20260804    gcc-16.1.0
sparc                randconfig-002-20260803    gcc-16.1.0
sparc                randconfig-002-20260804    gcc-16.1.0
sparc64              randconfig-001-20260803    gcc-16.1.0
sparc64              randconfig-001-20260804    gcc-16.1.0
sparc64              randconfig-002-20260803    gcc-16.1.0
sparc64              randconfig-002-20260804    gcc-16.1.0
um                   randconfig-001-20260803    gcc-16.1.0
um                   randconfig-001-20260804    gcc-16.1.0
um                   randconfig-002-20260803    gcc-16.1.0
um                   randconfig-002-20260804    gcc-16.1.0
x86_64     buildonly-randconfig-001-20260803    clang-22
x86_64     buildonly-randconfig-001-20260804    gcc-14
x86_64     buildonly-randconfig-002-20260803    clang-22
x86_64     buildonly-randconfig-002-20260804    gcc-14
x86_64     buildonly-randconfig-003-20260803    clang-22
x86_64     buildonly-randconfig-003-20260804    gcc-14
x86_64     buildonly-randconfig-004-20260803    clang-22
x86_64     buildonly-randconfig-004-20260804    gcc-14
x86_64     buildonly-randconfig-005-20260803    clang-22
x86_64     buildonly-randconfig-005-20260804    gcc-14
x86_64     buildonly-randconfig-006-20260803    clang-22
x86_64     buildonly-randconfig-006-20260804    gcc-14
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260803    gcc-14
x86_64               randconfig-001-20260804    gcc-14
x86_64               randconfig-002-20260803    gcc-14
x86_64               randconfig-002-20260804    gcc-14
x86_64               randconfig-003-20260803    gcc-14
x86_64               randconfig-003-20260804    gcc-14
x86_64               randconfig-004-20260803    gcc-14
x86_64               randconfig-004-20260804    gcc-14
x86_64               randconfig-005-20260803    gcc-14
x86_64               randconfig-005-20260804    gcc-14
x86_64               randconfig-006-20260803    gcc-14
x86_64               randconfig-006-20260804    gcc-14
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
x86_64               randconfig-072-20260803    clang-22
x86_64               randconfig-073-20260803    clang-22
x86_64               randconfig-074-20260803    clang-22
x86_64               randconfig-075-20260803    clang-22
x86_64               randconfig-076-20260803    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260803    gcc-16.1.0
xtensa               randconfig-001-20260804    gcc-16.1.0
xtensa               randconfig-002-20260803    gcc-16.1.0
xtensa               randconfig-002-20260804    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
