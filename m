Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2347383320
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 19:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788638231; cv=none; b=K4sfOKeFRzzWuofvkR/snjTdznyPZKb6bKvPdt9yWgItqVM6nTE8VHJXf+WgtGtJANLmbZp/Ln558YMj4m1r3MM8nESxpkgwuJefzcZuMd2VzFmnRbGS2ntqP2HnPiPQh/z1pD/ABZeiFfVx++78b7x8no+Smb3MSwwzKGAfgjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788638231; c=relaxed/simple;
	bh=eXlsr+UCPD8RkHCYw9rux+mYxAzQ6o9TaaI1OSSCsoI=;
	h=Date:From:To:Cc:Subject:Message-ID; b=nXRaFKw5KcqDLEAejFx8qgI/PnZgrRBT3OvPWK2ymFQ0Sq3PJoZDWIO3uxbZwmN2P2yKyBy+WQs4nDm/oG9zzGvhTeFqjUtkkwak/rp+i8TiH2y3H4NoHI6LKLYy/xYcO22bTXVd/tMfh0EXks9iw56AEgTBiWn16QfnILY4Ajo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m1fOXPsX; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m1fOXPsX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788638228; x=1820174228;
  h=date:from:to:cc:subject:message-id;
  bh=eXlsr+UCPD8RkHCYw9rux+mYxAzQ6o9TaaI1OSSCsoI=;
  b=m1fOXPsXnKiZFuCRpLdcn4yQpvT5PpHlSqm4SXe8xuLZdx0V9EFEXbQi
   q7HZip+4UTFT2VP98mwvpy4rtzy52RMhXPQMFCosuF/uhGBKeRUdm1MLz
   ibrU5vwUAzRTr3pc+3KyhMDjvZwqsbMdf4GoljscNcxHqSYvFfi89zGeJ
   tRlqzqM8kgOdGxMm9Ck9jtLE3Ja+DHgpoileJAlhVsxIwD9068jodnJY2
   yKt/nR1oELF0zZz4mf7z1eUdERum7fBedxRsUy/rp4GBIIKMbY4xFVzvQ
   TeYTZ+GoMFn0LdOeUfLvlGvsVjoxCiOcNN2YXtsf9CYyhKX4sCYGPh1/+
   A==;
X-CSE-ConnectionGUID: 8QBswFhOSSSx2acsX3LM5g==
X-CSE-MsgGUID: a5d0YZvzTSiZ39ugZDx7WQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11897"; a="89137492"
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="89137492"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2026 12:57:01 -0700
X-CSE-ConnectionGUID: gKs2OGRnS72rfT87V+ADnw==
X-CSE-MsgGUID: sF0YgR1NQwu9qE5zm6AOHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="266657860"
Received: from lkp-server01.sh.intel.com (HELO 73f3364bc37e) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 05 Sep 2026 12:56:59 -0700
Received: from kbuild by 73f3364bc37e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2wVV-0000000012f-0hj6;
	Sat, 05 Sep 2026 19:56:57 +0000
Date: Sun, 06 Sep 2026 03:56:39 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.4] BUILD SUCCESS
 93fccdb0456d963f0a7c515562eaf53dfe07f9c7
Message-ID: <202609060337.wpnmOIHx-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.4
branch HEAD: 93fccdb0456d963f0a7c515562eaf53dfe07f9c7  cgroup: namespace: Drop BUG_ON() in copy_cgroup_ns()

elapsed time: 3061m

configs tested: 58
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2         allnoconfig    clang-24
openrisc     allmodconfig    clang-20
openrisc      allnoconfig    clang-24
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc       allyesconfig    clang-17
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh           allyesconfig    clang-17
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa       allyesconfig    clang-20

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
