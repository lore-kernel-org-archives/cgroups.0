Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0AC35C1AE
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 17:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788973999; cv=none; b=fmkvt8MMqoQt9EIEzQxz0jfUvzZfD44KRamapFg0+MC+1oMDCR+uSTYTePI+atyzQJe9p8cD8T/1fyfJnTFn41G9OEvsEtX8z0+f+dGQjQmL0PhILUJfhIt7Gqq3STRn4Hh9f7xZjqq6I1QPRYHcMwg14v0I+HXIXe1Y1vMCA28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788973999; c=relaxed/simple;
	bh=k8I6azWBlxmtMliMoonPzPf1dAyhMFIccOWxkVj1cew=;
	h=Date:From:To:Cc:Subject:Message-ID; b=oKXtOlaujSV8iMw1I1QPSd4TlCc2qFT99ZEup997PaCd/IRB4WV41tJOKflQYvAhojRYnA4kbsfJg3wTjoNOiSSAIv5uICdJDks2Mox2X2e4m+vah3I3MubHi/pZGAglgXvH2/TKldRj5inh7VklqVjQXYPWMs013HJZ5qgR4vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZmYDVjAA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZmYDVjAA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788973997; x=1820509997;
  h=date:from:to:cc:subject:message-id;
  bh=k8I6azWBlxmtMliMoonPzPf1dAyhMFIccOWxkVj1cew=;
  b=ZmYDVjAA5I2pGB5qgDak4UF5QoyM5eX+dCWDsSOpfNYWr6sfMkorhqeZ
   ilagtbDSKtZtYrfBJ9bSvFIwNHz5UtO4nCnY02XiXyweJooiFE5uxPIMY
   6L6CxqM1lldbTO3+FQN8tzoOsN06qCoVOzvLv7kCKjHjQZ6EBZdrOIZED
   Q+7Cx3EUTvWRK7KdHxIG8//er+N7eb4JER6lPoz148PAkDGQCj0DoVOXK
   wuBCeb7nT0SorCYUlt1x+GC0pwWt5x9f+FMklRUKoEZ9x7zrJ6jBMYb71
   TuJmC0OLW5LxPKY+RC0GreAGaptQH08qg3XGX8uD37XQBdx4tQykbC1Tn
   g==;
X-CSE-ConnectionGUID: XnW36iB4RNicBFCr5had7Q==
X-CSE-MsgGUID: wTlSVK2+TaGwEDq42BeI6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="100006140"
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="100006140"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 10:13:16 -0700
X-CSE-ConnectionGUID: gOJokII+Rf6diw/91g+4Tw==
X-CSE-MsgGUID: kEKnbmp4ToeYE6BbzPxaiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="267697030"
Received: from lkp-server01.sh.intel.com (HELO a3e91e2cf319) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 09 Sep 2026 10:13:16 -0700
Received: from kbuild by a3e91e2cf319 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4LrG-000000000g0-0W12;
	Wed, 09 Sep 2026 17:13:14 +0000
Date: Thu, 10 Sep 2026 01:13:09 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.4] BUILD SUCCESS
 c367ce5b31ffd4d958f3f6c5fe1c9e820dc9f526
Message-ID: <202609100106.udZ5dHKy-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.4
branch HEAD: c367ce5b31ffd4d958f3f6c5fe1c9e820dc9f526  cgroup: Make the offline drain interruptible

elapsed time: 1292m

configs tested: 82
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-19
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    clang-20
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    clang-17
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    clang-17
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-14
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    clang-20
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
