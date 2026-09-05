Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EB2351C02
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788620638; cv=none; b=tnDC2SLcG/nW0bQR/QQ6ngndxMiummyozThBD7GAcCnVW01P1JTrBZVZbOgOVfGiCfWyLMwUDV4RtBcIHqejHo2UkNvY+cOWo1zxCpvAFz9qx1RZKaAS1xYDms8dm7SU6Zkzgq1O4tiRubkfvy7WkbsQ8STQf6i1iBHRrNTruYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788620638; c=relaxed/simple;
	bh=bXt5GNrgWDFrfTkFgZN/1GXRpccRQywiyIOKcbVq9gk=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ddoeg+VWBCze4bdFDa6YuarDUab7oSjE8xYsagAstdCRIokxIaGfL4ysroG4O6p20gvtkBvSqfn+PspXg8rml6y9/IyiKagMiHPDwmY7sZf23r2fVVhFSL3trJIuQyjWfW+JaoOUDWwg2aKIR49uVwpRiQq/jSOWCi88ZfOcFew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F0Ynvyqp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F0Ynvyqp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788620636; x=1820156636;
  h=date:from:to:cc:subject:message-id;
  bh=bXt5GNrgWDFrfTkFgZN/1GXRpccRQywiyIOKcbVq9gk=;
  b=F0YnvyqpsRyEiqR3pub/ML1AXvTKrSSHshx3c8Uo2HyJELkJqTUylQG5
   kOsjD5FsV9D7+0FHA+54e4VcvBensBrq+h2eNCWZ8ARdkpw24R/wMVVqH
   4JxC6XJCDM8+5qLDIKtG8bvl8tO1Myjn2t9XVJXq9aW4DQmZl37lQHPqD
   xWffCvI0sslJH9HTUy2yyBIJGSZgNmlAmwIUrDH3FFZW6mZrbk6HCtTxa
   ywguBJnCKugStL7TjchT+q23QosJCqYCnHlWPwQUQwAtW2vJdT6dN6rlq
   V82wHJBIvua1Ib55E/ZNlwn77R3zqclfUEYy0Y0QG/kcYn1JSQtny2u4z
   w==;
X-CSE-ConnectionGUID: 38lS3VzRSJS4PkLKb+qysA==
X-CSE-MsgGUID: IPxnCKqkSfCaWg6I0jy7Iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11897"; a="106463556"
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="106463556"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2026 08:03:55 -0700
X-CSE-ConnectionGUID: eldpXh0YR1+EUTGUiX+vXw==
X-CSE-MsgGUID: yl2R/yh2TbyNty2JVowj+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,264,1779174000"; 
   d="scan'208";a="274118422"
Received: from lkp-server01.sh.intel.com (HELO 73f3364bc37e) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 05 Sep 2026 08:03:54 -0700
Received: from kbuild by 73f3364bc37e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2rvr-000000000dD-34Gn;
	Sat, 05 Sep 2026 15:03:51 +0000
Date: Sat, 05 Sep 2026 23:03:08 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:cgroup-drain-interruptible] BUILD SUCCESS
 18b1d3778d376a8aeae753e1dafcce5ee77d5da2
Message-ID: <202609052305.o1UNsHu8-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-drain-interruptible
branch HEAD: 18b1d3778d376a8aeae753e1dafcce5ee77d5da2  cgroup: Make the offline drain interruptible

elapsed time: 3555m

configs tested: 60
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    clang-24
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    gcc-16.1.0
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-24
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
openrisc     allmodconfig    clang-20
openrisc      allnoconfig    clang-24
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
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
