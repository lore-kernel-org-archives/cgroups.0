Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E08543AB0
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 05:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786684797; cv=none; b=VV5X704mjfyyHE55q6c4v/yx4FA/UUpn1nkkMqhR81Esndg3kuH7GgEvNvqSdaQsOrebiesncRiVJSRyuFD+bn3rzl6F3jCKNZAKttjyHIj58bwa7VxCjL5wacjF2J7Z52sy9SO3Eu0BBEuZs0ZC2iT1GYSMt7GFgUCAg1CrguI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786684797; c=relaxed/simple;
	bh=Sqr6Rhdj9jH5m28b+hPS7W9/gCOptJ43rjWICzbn2Iw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=TucaJb9sm6IS90ZR2C438YxMViKW73xkpr/lk3mKT3KZC2sekfAzcPEOOUzLfurI0VSrmEdPJcn09i/yKGSQsOejCJJ017OxjI1P8XOp+lLM9+/MIOdbxZOikH4LM3f5GUQOB7W0ewNOiaq9H5/Y3enx6ywri3TuVFI4MGox8VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kcnyPiT7; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kcnyPiT7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786684794; x=1818220794;
  h=date:from:to:cc:subject:message-id;
  bh=Sqr6Rhdj9jH5m28b+hPS7W9/gCOptJ43rjWICzbn2Iw=;
  b=kcnyPiT7WleRiouwvSA4E9UvqUjd3XvyxNYIeLqH85I4u1jjxYaD4RzS
   jpZBwJVhYdKlMNJSpeWR64pj5xRRArG80ceA0KGwXv5WNorVgwI02cXfg
   s5bJgj3wLqsoAPKg55L1tpew5588kwQsYg7hPdhMjSPjCl0VeOoi8LGtA
   uZndLRCuzaJSIxh33F1ewbu6cVlQoegOsnL/NCqXSGbNDkM8OTtVo47Wi
   mOyNqsSlyJOcfy9aF5CLGJpv+m1bQyXKZPFSgI25pEf6A93KKf36bYFNl
   asqQQxJmttoy4iC+fUH0B/DZsJygsf5f1IvF9C08cLgfAUn1C6IqzRtEB
   g==;
X-CSE-ConnectionGUID: 5yFdJYzeQ9i4PwnYYL6ZKg==
X-CSE-MsgGUID: wVsOoN/1Q1igyKIFKmbysw==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="97929341"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="97929341"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 22:19:52 -0700
X-CSE-ConnectionGUID: bu5zxGJ3TrGvsWF5s4VQqQ==
X-CSE-MsgGUID: YDR0/3RGTOuA+LdGkhpIGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="302370954"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 13 Aug 2026 22:19:51 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wukKa-00000000XqE-3aCV;
	Fri, 14 Aug 2026 05:19:48 +0000
Date: Fri, 14 Aug 2026 13:19:18 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.3] BUILD SUCCESS
 44f57a2b1b9fabe3735a9b2669bb146ddb571fce
Message-ID: <202608141306.25kSUp8y-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3
branch HEAD: 44f57a2b1b9fabe3735a9b2669bb146ddb571fce  cgroup/cpuset: Add test for partition root invalidation returning wrong CPUs

elapsed time: 2516m

configs tested: 125
configs skipped: 8

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
sh                          se7712_defconfig    gcc-16.1.0
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
