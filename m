Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D03B4CF461
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 03:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792380432; cv=none; b=IWAMvaTweAHhh47wDC3KUJjr/f0UtEmFH58CKPISk+BaM8Pjd5eqLx2p1p5RX9mLU3TXHANqAofMXRiHWEmAfd4tlNyq7qZ+/tGu13ZpTMPUfZB9VBLF18QsR+7ABY0bEG0d/v2J9lTdFgGqCH4ipZKSY7hfu9c9lL+aoOGgGTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792380432; c=relaxed/simple;
	bh=4AmXxpw7VhM1RlqerpjR/U7W/QnWjfrxtCRYZN9welo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=JobLpzmBwQ77gyZZri4n3s42IEVBFOzcUesNv32imlOc33saNqzZhdesYFVdcn+3JV9MnQ0qdghs0hggC5Twwx+/HbTjImGvJg18nh69gJRjvABp3AIkiZaRXvP9ac7YoFHZlFf6oDxKjGXPElURHAWrLPzPUM8wiQ5+doui0C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KNhGqdGS; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KNhGqdGS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792380431; x=1823916431;
  h=date:from:to:cc:subject:message-id;
  bh=4AmXxpw7VhM1RlqerpjR/U7W/QnWjfrxtCRYZN9welo=;
  b=KNhGqdGSVq75izJZCNB2ljg/ZvYyvyjCfBuDy9PAuwz+6kJmL6rrJzCu
   RakWLgFYjoh2Kza3GIUzPFKygnKekFKJCiMVZwKf+SSJvvovp9EYV+qgN
   XkZYPXneeoQYK0nBiOqrqHy0j45MFrQmp+LqyRzl5/rB5fEIBnqacWRWm
   E3c8dzt8dEiejyJiax/nvxQkVy+2aGsFFzWb3sNpy3rG9QbRhDYyczZj+
   5duD19nfhyIWSnyNzua1wsQGxhQU8dTslCbzjyXZaCd21g8dis4rKWBIz
   TXnb0dbMD4I4O4Lt5udzuXMr36wy2sbsjCJRRVdI77o0tLUZIMUwwBJG3
   A==;
X-CSE-ConnectionGUID: QLKpZt1gSd+nwxVoeafAPA==
X-CSE-MsgGUID: Tv250d+nSWGZGXMwiUqhFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="1051306"
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="1051306"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2026 20:27:10 -0700
X-CSE-ConnectionGUID: k/LU071TRyqFV6Y8BePmqQ==
X-CSE-MsgGUID: IiuqklD1Qb6CIgCfqeuFJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="2799499"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 18 Oct 2026 20:27:08 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIe1i-00000000LCs-0dFZ;
	Mon, 19 Oct 2026 03:27:06 +0000
Date: Mon, 19 Oct 2026 11:26:24 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.4] BUILD SUCCESS
 1850c669516cb8568150937497a9a16a7bfa1582
Message-ID: <202610191121.dpAU9uXE-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.4
branch HEAD: 1850c669516cb8568150937497a9a16a7bfa1582  selftests/cgroup: test pids.events notification

elapsed time: 1296m

configs tested: 207
configs skipped: 8

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
arc                   randconfig-1000-20261019    clang-21
arc                   randconfig-1001-20261019    clang-21
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                       integrator_defconfig    gcc-16.2.0
arm                           pxa3xx_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261019    clang-21
arm                   randconfig-1001-20261019    clang-21
arm                   randconfig-1002-20261019    clang-21
arm                   randconfig-1003-20261019    clang-21
arm                        spear13xx_defconfig    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261019    clang-24
arm64                 randconfig-1001-20261019    clang-24
arm64                 randconfig-1002-20261019    clang-24
arm64                 randconfig-1003-20261019    clang-24
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261019    clang-24
csky                  randconfig-1001-20261019    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261019    clang-24
hexagon               randconfig-1001-20261019    clang-24
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261018    clang-22
i386        buildonly-randconfig-1000-20261019    clang-22
i386        buildonly-randconfig-1001-20261018    clang-22
i386        buildonly-randconfig-1001-20261019    clang-22
i386        buildonly-randconfig-1002-20261018    clang-22
i386        buildonly-randconfig-1002-20261019    clang-22
i386        buildonly-randconfig-1003-20261018    clang-22
i386        buildonly-randconfig-1003-20261019    clang-22
i386        buildonly-randconfig-1004-20261018    clang-22
i386        buildonly-randconfig-1004-20261019    clang-22
i386        buildonly-randconfig-1005-20261018    clang-22
i386        buildonly-randconfig-1005-20261019    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261019    clang-22
i386                  randconfig-1001-20261019    clang-22
i386                  randconfig-1002-20261019    clang-22
i386                  randconfig-1003-20261019    clang-22
i386                  randconfig-1004-20261019    clang-22
i386                  randconfig-1005-20261019    clang-22
i386                  randconfig-1006-20261019    clang-22
i386                  randconfig-1007-20261018    gcc-14
i386                  randconfig-1008-20261018    gcc-14
i386                  randconfig-1009-20261018    gcc-14
i386                  randconfig-1010-20261018    gcc-14
i386                  randconfig-1011-20261018    gcc-14
i386                  randconfig-1012-20261018    gcc-14
i386                  randconfig-1013-20261018    gcc-14
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch                 loongson32_defconfig    clang-24
loongarch             randconfig-1000-20261019    clang-24
loongarch             randconfig-1001-20261019    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                             mac_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                        rbtx49xx_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261019    clang-24
nios2                 randconfig-1001-20261019    clang-24
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261018    clang-24
parisc                randconfig-1000-20261019    gcc-8.5.0
parisc                randconfig-1001-20261018    clang-24
parisc                randconfig-1001-20261019    gcc-8.5.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                       cm5200_defconfig    clang-24
powerpc               randconfig-1000-20261018    clang-24
powerpc               randconfig-1000-20261019    gcc-8.5.0
powerpc               randconfig-1001-20261018    clang-24
powerpc               randconfig-1001-20261019    gcc-8.5.0
powerpc                      tqm8548_defconfig    clang-24
powerpc64             randconfig-1000-20261018    clang-24
powerpc64             randconfig-1000-20261019    gcc-8.5.0
powerpc64             randconfig-1001-20261018    clang-24
powerpc64             randconfig-1001-20261019    gcc-8.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261018    clang-17
riscv                 randconfig-1000-20261019    gcc-11.5.0
riscv                 randconfig-1001-20261018    clang-17
riscv                 randconfig-1001-20261019    gcc-11.5.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261018    clang-17
s390                  randconfig-1000-20261019    gcc-11.5.0
s390                  randconfig-1001-20261018    clang-17
s390                  randconfig-1001-20261019    gcc-11.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                           landisk_defconfig    clang-24
sh                           r7785rp_defconfig    clang-24
sh                    randconfig-1000-20261018    clang-17
sh                    randconfig-1000-20261019    gcc-11.5.0
sh                    randconfig-1001-20261018    clang-17
sh                    randconfig-1001-20261019    gcc-11.5.0
sh                           rsk7264_defconfig    gcc-16.2.0
sh                         sh7757lcr_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261019    clang-20
sparc                 randconfig-1001-20261019    clang-20
sparc                        sparc64_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261019    clang-20
sparc64               randconfig-1001-20261019    clang-20
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261019    clang-20
um                    randconfig-1001-20261019    clang-20
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261019    clang-22
x86_64      buildonly-randconfig-1001-20261019    clang-22
x86_64      buildonly-randconfig-1002-20261019    clang-22
x86_64      buildonly-randconfig-1003-20261019    clang-22
x86_64      buildonly-randconfig-1004-20261019    clang-22
x86_64      buildonly-randconfig-1005-20261019    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261018    clang-22
x86_64                randconfig-1000-20261019    clang-22
x86_64                randconfig-1001-20261018    clang-22
x86_64                randconfig-1001-20261019    clang-22
x86_64                randconfig-1002-20261018    clang-22
x86_64                randconfig-1002-20261019    clang-22
x86_64                randconfig-1003-20261018    clang-22
x86_64                randconfig-1003-20261019    clang-22
x86_64                randconfig-1004-20261018    clang-22
x86_64                randconfig-1004-20261019    clang-22
x86_64                randconfig-1005-20261018    clang-22
x86_64                randconfig-1005-20261019    clang-22
x86_64                randconfig-1006-20261018    clang-22
x86_64                randconfig-1006-20261019    clang-22
x86_64                randconfig-1007-20261018    clang-22
x86_64                randconfig-1007-20261019    clang-22
x86_64                randconfig-1008-20261018    clang-22
x86_64                randconfig-1008-20261019    clang-22
x86_64                randconfig-1009-20261018    clang-22
x86_64                randconfig-1009-20261019    clang-22
x86_64                randconfig-1010-20261018    clang-22
x86_64                randconfig-1010-20261019    clang-22
x86_64                randconfig-1011-20261018    clang-22
x86_64                randconfig-1011-20261019    clang-22
x86_64                randconfig-1012-20261019    gcc-14
x86_64                randconfig-1013-20261019    gcc-14
x86_64                randconfig-1014-20261019    gcc-14
x86_64                randconfig-1015-20261019    gcc-14
x86_64                randconfig-1016-20261019    gcc-14
x86_64                randconfig-1017-20261019    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261019    clang-20
xtensa                randconfig-1001-20261019    clang-20
xtensa                          virt_defconfig    gcc-16.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
