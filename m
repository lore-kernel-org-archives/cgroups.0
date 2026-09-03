Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B7E13957E
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 04:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788409676; cv=none; b=W4KLRV6CtDHw+RqHop+DYjT5SKK53T4FywYYJxHWp7oJUbfdlIhACwGgwFwsFVQjQhB3fWGMMR/o3xKpl+O1ekthkmiN44Uyl1tAbw+PSgJfjhYBVkdJQHpTCNlCfDryQD1RjPR+jXzwbD0XjEiD4kllcGsly8+aoMGN/R4RZ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788409676; c=relaxed/simple;
	bh=hFi9YlapJe4Ra/DCwTgcVUb5T/TXj6yiSACagG/DPyo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=RqhwDp5mwF34YgGh2kozcg/V78yaOXJw0fBf1yoJmqzlCoHBYwl4UkWply4UWa5XQELcdhk9UX0GTnuQb8KUUPIC0fDNlICgSmj4yks57IChOOX4vQ08BdgJ/pedXG1BaoQ4cy3vSh7QSlh5AYbnFqHsFvucqBdMW8Y9540YqZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A/WXHW26; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A/WXHW26"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788409675; x=1819945675;
  h=date:from:to:cc:subject:message-id;
  bh=hFi9YlapJe4Ra/DCwTgcVUb5T/TXj6yiSACagG/DPyo=;
  b=A/WXHW26Ng0hNY2RmA76HVoBhxCZqbMsMVZzJZYI61P4ZcKbpvnNA14J
   XqbGil+RyBYxjBp5LRQ4lQORS4QJ8DRyRvGeibm8PgTXKtL+2FcRKZwSI
   tb8ktEtlqzY8GeVEJZb/VPBEvi53lsvp9tvugowMW/lQRGqVgkunawREd
   4paThNBoqSsupHJnXo5+TBd9hEpmyBCFmuL+gEuz32lnc4roDNrJ365pQ
   b7aoJogV9wnP9E9aZho/H80/tU7OKD7vwm0KfJ/qDzMKR4H/Od7mhkUy/
   tUdMkfoEg/AbTsWRyXYiBgSqV3Ahs4sFZ+um9jQ7VJOQ9HGpn3tmKtHzY
   Q==;
X-CSE-ConnectionGUID: Y9aoPKCNQi2iid4c0vB5fA==
X-CSE-MsgGUID: CUzXUpOrQ6SNQ1YIQ8Ki6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="100235942"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="100235942"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 21:27:54 -0700
X-CSE-ConnectionGUID: h/MFNOWVQ8KiZ3VcD6lq5Q==
X-CSE-MsgGUID: JdsQZsggRVWYpxFw5RSJww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="307800956"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 02 Sep 2026 21:27:53 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x1z3G-0000000045O-2LH4;
	Thu, 03 Sep 2026 04:27:50 +0000
Date: Thu, 03 Sep 2026 12:27:04 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 75f8b845df69ad3502838dbaff680f968e261d14
Message-ID: <202609031254.MtLpxHqK-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 75f8b845df69ad3502838dbaff680f968e261d14  Merge branch 'for-7.3-fixes' into for-next

elapsed time: 3571m

configs tested: 106
configs skipped: 3

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
arm64       randconfig-r053-20260902    clang-24
csky                    allmodconfig    gcc-16.1.0
csky                     allnoconfig    gcc-16.1.0
csky        randconfig-r061-20260902    clang-22
csky        randconfig-r062-20260902    clang-22
csky        randconfig-r072-20260902    gcc-14.3.0
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
openrisc    randconfig-r071-20260902    gcc-16.1.0
parisc                  allmodconfig    gcc-16.1.0
parisc                   allnoconfig    clang-24
parisc                  allyesconfig    clang-17
parisc      randconfig-r054-20260902    clang-24
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
sparc       randconfig-r052-20260902    clang-24
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
