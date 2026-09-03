Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D9F1E1DF0
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 04:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408289; cv=none; b=WcDMW/M6Kcgmdtmiqtvt0m46VzsPfzmoPuMOWDxz8TrIqKnAr0Tlfi+fPs9P4VQ8/gQc6fRbDFWD4sz6yEIPcPqe/FOzbGRfa5T6VgE02CHNERHqA5de+6Igyrv/THMBjF5LQ5sGMtI6MTY9logQNSw5CuBgApTuF3Oc0taEHgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408289; c=relaxed/simple;
	bh=2XNu1nsuvU00S58l8x3LCHveMPKIzTtO0IFCGuLPZ3I=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ezSEmQYbCj/K6Tc7WfEo34IshwlEei25hqkSkqdoiPRg+FbExid8j2vYhCWQi/OVmgeshhNMSeVOMi1phRjjNPOJ6KbpO7jM48ZhKEzjF1Rfiw4QHLPBYkR762S1R+ZMqIbOKpyqHG7YAsl2r00igK/X21r16SEWnHAjqfk2xXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AFjv8A6a; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AFjv8A6a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788408289; x=1819944289;
  h=date:from:to:cc:subject:message-id;
  bh=2XNu1nsuvU00S58l8x3LCHveMPKIzTtO0IFCGuLPZ3I=;
  b=AFjv8A6akItbBwqouXVDrkqIJipPcpryzpyZIAsPbR6y+B5BUnyZOrma
   i20+e8+hGT7C+2gpENFY3htyay+8oHrnH/uYBEAMAlWcPLROdN6ZgLIZB
   7MqoSc4hzW19pbqlH5yRoHAVwUNupIsvfxxKAUK3IDYMYo8v+LphIPn08
   Diy+oucilj2s8CjFLLM8j7KgWvt/dWIjW1PDfg54Ms1OCk4HriM2iYF9N
   SKkM7UF2Dk23kTYwEEAwQTpAv65IYfj1nD8xgb4TWtbPiiD3OGONvnQTL
   KYicFRwnFQzgorr7kyRevnAIoC1LL1KlazrniGwu/Axv9ddKnFahoALiT
   Q==;
X-CSE-ConnectionGUID: kJ5dqyLOSFyyLVn4M5CSmA==
X-CSE-MsgGUID: fb09CQykRcSCueNgELD6+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="92579477"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="92579477"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 21:04:48 -0700
X-CSE-ConnectionGUID: qvWV0n7GTj2VGRti/SdxnA==
X-CSE-MsgGUID: TGbx0x2qQvGqUYiEVxXpsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="294462977"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 02 Sep 2026 21:04:46 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x1ygt-000000003yJ-3kph;
	Thu, 03 Sep 2026 04:04:43 +0000
Date: Thu, 03 Sep 2026 12:03:44 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.3-fixes] BUILD SUCCESS
 3f4b7d1a49c5c826f3be9b684313eea5b83ac232
Message-ID: <202609031241.iOzOA0Ay-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3-fixes
branch HEAD: 3f4b7d1a49c5c826f3be9b684313eea5b83ac232  selftests/cgroup: test clone3() into a previously killed cgroup

elapsed time: 3548m

configs tested: 101
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                    allnoconfig    gcc-16.1.0
alpha                   allyesconfig    gcc-16.1.0
alpha       randconfig-r054-20260902    clang-22
arc                     allmodconfig    clang-24
arc                     allmodconfig    gcc-16.1.0
arc                      allnoconfig    gcc-16.1.0
arc                     allyesconfig    clang-24
arc         randconfig-r122-20260901    clang-24
arc         randconfig-r122-20260902    clang-24
arm                      allnoconfig    gcc-16.1.0
arm                     allyesconfig    clang-24
arm         randconfig-r052-20260902    clang-22
arm         randconfig-r112-20260901    clang-24
arm64                   allmodconfig    clang-24
arm64                    allnoconfig    gcc-16.1.0
csky                    allmodconfig    gcc-16.1.0
csky                     allnoconfig    gcc-16.1.0
csky        randconfig-r061-20260902    clang-22
csky        randconfig-r062-20260902    clang-22
csky        randconfig-r111-20260902    clang-24
hexagon                 allmodconfig    gcc-16.1.0
hexagon                  allnoconfig    gcc-16.1.0
hexagon     randconfig-r053-20260902    clang-24
hexagon     randconfig-r071-20260902    clang-24
i386                    allmodconfig    clang-22
i386                     allnoconfig    gcc-16.1.0
i386                    allyesconfig    clang-22
i386         randconfig-051-20260901    gcc-12
i386         randconfig-051-20260902    clang-22
i386         randconfig-052-20260901    gcc-12
i386         randconfig-052-20260902    clang-22
i386         randconfig-053-20260901    gcc-12
i386         randconfig-053-20260902    clang-22
i386         randconfig-054-20260901    gcc-12
i386         randconfig-054-20260902    clang-22
i386         randconfig-141-20260901    gcc-14
i386         randconfig-141-20260902    clang-22
i386        randconfig-r063-20260901    clang-22
i386        randconfig-r063-20260902    clang-22
loongarch               allmodconfig    clang-24
loongarch                allnoconfig    gcc-16.1.0
m68k                    allmodconfig    gcc-16.1.0
m68k                     allnoconfig    gcc-16.1.0
m68k                    allyesconfig    clang-24
m68k                    allyesconfig    gcc-16.1.0
m68k        randconfig-r054-20260902    clang-24
microblaze               allnoconfig    gcc-16.1.0
microblaze              allyesconfig    gcc-16.1.0
microblaze  randconfig-r113-20260901    clang-24
mips                    allmodconfig    gcc-16.1.0
mips                     allnoconfig    gcc-16.1.0
mips                    allyesconfig    gcc-16.1.0
mips        randconfig-r134-20260902    gcc-13.4.0
nios2                   allmodconfig    clang-20
nios2                    allnoconfig    clang-24
nios2       randconfig-r072-20260902    gcc-8.5.0
nios2       randconfig-r111-20260901    clang-24
nios2       randconfig-r123-20260901    clang-24
openrisc                allmodconfig    clang-20
openrisc                 allnoconfig    clang-24
openrisc    randconfig-r052-20260902    clang-24
openrisc    randconfig-r053-20260902    clang-22
openrisc    randconfig-r064-20260902    clang-22
parisc                  allmodconfig    gcc-16.1.0
parisc                   allnoconfig    clang-24
parisc                  allyesconfig    clang-17
parisc      randconfig-r121-20260902    clang-24
powerpc                 allmodconfig    gcc-16.1.0
powerpc                  allnoconfig    clang-24
powerpc     randconfig-r132-20260902    gcc-13.4.0
powerpc     randconfig-r133-20260902    gcc-13.4.0
powerpc64   randconfig-r112-20260902    clang-24
riscv                   allmodconfig    clang-24
riscv                    allnoconfig    clang-24
riscv                   allyesconfig    clang-24
riscv       randconfig-r051-20260902    clang-22
s390                    allmodconfig    clang-17
s390                     allnoconfig    clang-24
s390                    allyesconfig    gcc-16.1.0
sh                      allmodconfig    gcc-16.1.0
sh                       allnoconfig    clang-24
sh                      allyesconfig    clang-17
sh          randconfig-r061-20260901    clang-22
sh          randconfig-r062-20260901    clang-22
sh          randconfig-r121-20260901    clang-24
sparc                    allnoconfig    clang-24
sparc64                 allmodconfig    clang-20
sparc64     randconfig-r051-20260902    clang-24
sparc64     randconfig-r113-20260902    clang-24
sparc64     randconfig-r131-20260902    gcc-13.4.0
um                      allmodconfig    clang-17
um                       allnoconfig    clang-24
um                      allyesconfig    gcc-16.1.0
um          randconfig-r064-20260901    clang-22
x86_64                  allmodconfig    clang-22
x86_64                   allnoconfig    clang-24
x86_64                  allyesconfig    clang-22
x86_64                 rhel-9.4-rust    clang-22
xtensa                   allnoconfig    clang-24
xtensa                  allyesconfig    clang-20
xtensa      randconfig-r123-20260902    clang-24

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
