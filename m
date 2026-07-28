Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF6C376463
	for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 04:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785212393; cv=none; b=WM4VJusu96h/pmYoJjBf5ynIKCfUM3TZ2cN3aWcsnK0OVJ1cwm3oK2FzFqZaJ8UelSCVMEqr00aO6FiX2zIwLtSnXTllpY60RrCqcuCJ/b1kCqzAyeWwFkbY8Du0XAvVwKpvWnkp2djhq9jZ1bbY1vvsIgq9U7JQ+0Hw8MmymQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785212393; c=relaxed/simple;
	bh=n5bneWQcHRIz4Shg6hmHYSuk8/fA/r/XLw7iyUlPR9M=;
	h=Date:From:To:Cc:Subject:Message-ID; b=oBpXK576+wgnAl+F85nU+olwABs3K8yTzhGq1PWsppdJC71ICXcCqJEI4gbJKCKhZcbmWmFkVSSKHnBY8WJP3eWROd+pWQ6TjoBu1kYgkS8c6XFQv+eZLkeGCnus0GaXLzgFeBA45gFgX02GYxynAkZKy6TQ+Vbks0KLf/AuCk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=USVupYux; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="USVupYux"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785212391; x=1816748391;
  h=date:from:to:cc:subject:message-id;
  bh=n5bneWQcHRIz4Shg6hmHYSuk8/fA/r/XLw7iyUlPR9M=;
  b=USVupYuxX9ERrXkTQoAoovoNkte/0pW5DSLexEotzsuryxBLI84eDl9T
   kjg+C32IgUAXoHYnZpY8xVmLjtvXuj/3HAwQZXM5tyc5hjWNUsa/Q+nla
   XfJkosdhvg4OljaD/SSHNUqP0rejpv9sxBzb1RuNe1jnvNphnHiKwhVWW
   lt5LpfHGB4PRzoIs3RTBz2vhf4f+ZeK6IWnFsjzhVYY8tOWCQ85LBUGHV
   A/UZQzahIv9PAvJ5SqppXL1fjBdBBlkqvxQcoaAXb0yHpytXCSrDsh3rS
   6f1iBZ8TL9qg/f/tubCCmr2Nr2/tbLbOeg8M7xfUFZhHHGiXX+ujffWxG
   A==;
X-CSE-ConnectionGUID: jW+8kZPESb6sYtq3HObMuA==
X-CSE-MsgGUID: XGw/w3EKQ2uEpNIuedxLdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="96375755"
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="96375755"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 21:19:50 -0700
X-CSE-ConnectionGUID: JYOgP53UTEuxvPFZCKL06g==
X-CSE-MsgGUID: QVVpBwXNS7mNeGftBVd7iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="256242897"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 27 Jul 2026 21:19:49 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1woZI8-00000000dwY-1TFq;
	Tue, 28 Jul 2026 04:19:45 +0000
Date: Tue, 28 Jul 2026 12:19:01 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 eb21ac5fec4db1539fc81b5feca00c2b20170afb
Message-ID: <202607281248.PlEkGWRs-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: eb21ac5fec4db1539fc81b5feca00c2b20170afb  Merge branch 'for-7.3' into for-next

elapsed time: 1594m

configs tested: 82
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260728    gcc-8.5.0
arc                  randconfig-002-20260728    gcc-8.5.0
arm                      imx_v6_v7_defconfig    clang-24
arm                  randconfig-001-20260728    gcc-8.5.0
arm                  randconfig-002-20260728    gcc-8.5.0
arm                  randconfig-003-20260728    gcc-8.5.0
arm                  randconfig-004-20260728    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
hexagon              randconfig-001-20260728    gcc-11.5.0
hexagon              randconfig-002-20260728    gcc-11.5.0
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260728    gcc-14
i386       buildonly-randconfig-002-20260728    gcc-14
i386       buildonly-randconfig-003-20260728    gcc-14
i386       buildonly-randconfig-004-20260728    gcc-14
i386       buildonly-randconfig-005-20260728    gcc-14
i386       buildonly-randconfig-006-20260728    gcc-14
i386                          randconfig-011    gcc-14
i386                 randconfig-011-20260728    gcc-14
i386                 randconfig-012-20260728    gcc-14
i386                 randconfig-013-20260728    gcc-14
i386                 randconfig-014-20260728    gcc-14
i386                 randconfig-015-20260728    gcc-14
i386                 randconfig-016-20260728    gcc-14
i386                 randconfig-017-20260728    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260728    gcc-11.5.0
loongarch            randconfig-002-20260728    gcc-11.5.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260728    gcc-11.5.0
nios2                randconfig-002-20260728    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260728    gcc-10.5.0
parisc               randconfig-002-20260728    gcc-10.5.0
powerpc              randconfig-001-20260728    gcc-10.5.0
powerpc              randconfig-002-20260728    gcc-10.5.0
powerpc64            randconfig-001-20260728    gcc-10.5.0
powerpc64            randconfig-002-20260728    gcc-10.5.0
riscv                randconfig-001-20260728    gcc-14.3.0
riscv                randconfig-002-20260728    gcc-14.3.0
s390                 randconfig-001-20260728    gcc-14.3.0
s390                 randconfig-002-20260728    gcc-14.3.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260728    gcc-14.3.0
sh                   randconfig-002-20260728    gcc-14.3.0
sparc                         randconfig-001    gcc-11.5.0
sparc                randconfig-001-20260728    gcc-11.5.0
sparc                randconfig-002-20260728    gcc-11.5.0
sparc64              randconfig-001-20260728    gcc-11.5.0
sparc64              randconfig-002-20260728    gcc-11.5.0
um                   randconfig-001-20260728    gcc-11.5.0
um                   randconfig-002-20260728    gcc-11.5.0
x86_64     buildonly-randconfig-001-20260728    clang-22
x86_64     buildonly-randconfig-002-20260728    clang-22
x86_64     buildonly-randconfig-003-20260728    clang-22
x86_64     buildonly-randconfig-004-20260728    clang-22
x86_64     buildonly-randconfig-005-20260728    clang-22
x86_64     buildonly-randconfig-006-20260728    clang-22
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260728    gcc-12
x86_64               randconfig-002-20260728    gcc-12
x86_64               randconfig-003-20260728    gcc-12
x86_64               randconfig-004-20260728    gcc-12
x86_64               randconfig-005-20260728    gcc-12
x86_64               randconfig-006-20260728    gcc-12
x86_64               randconfig-071-20260728    clang-22
x86_64               randconfig-072-20260728    clang-22
x86_64               randconfig-073-20260728    clang-22
x86_64               randconfig-074-20260728    clang-22
x86_64               randconfig-075-20260728    clang-22
x86_64               randconfig-076-20260728    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260728    gcc-11.5.0
xtensa               randconfig-002-20260728    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
