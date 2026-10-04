Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2503F1043
	for <cgroups@vger.kernel.org>; Sun,  4 Oct 2026 04:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791088073; cv=none; b=SJYNIVfvu7VDBOKhLosRSwgzjXTB6kq943y3iybT/SSdOefyt7t+ZSPJ0qIU1ouR1IMK963fa3mty+MwFqFqdktRebkC4VPOhVx+WuYjf3rfNSK9M0mRhbW1uqL96JKtQYYgQT+MxDfpbvN4M+cAG9aPj4SkywJa0z1lp0JcgR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791088073; c=relaxed/simple;
	bh=ZCfu3QWGgmnEBr6CtXrv39Xef5bIlhqdMyzGlQbsPLY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=n5cndUWlSo55KM0LDXIlCH8ltZBIaczoWBTdbTx5uRQI21K8718jJypaktf3uZDQYVUPQoIjRTl7X1MNBT/e4aL0ucVh2zEaiR/+DS69dobQGy5Aa66QIOygy7IN0HH94hU7yIzIpXz3Air5SQsEGjrx39zxrb2o/Oj/hHAtEzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WDsK1e9f; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WDsK1e9f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791088071; x=1822624071;
  h=date:from:to:cc:subject:message-id;
  bh=ZCfu3QWGgmnEBr6CtXrv39Xef5bIlhqdMyzGlQbsPLY=;
  b=WDsK1e9fMV2X3QmLrxc00ASngrto/Kv3JBdLV7tdzTEtmFBJtST6Ph5V
   ceq1eRFbf8CcDLiXa09Gq0fqTd0lOj7bCny3bWVAPzXmimv3DH6YvD06y
   92oZMz0aqGAUiWwYGJiXlQ+Ad7O0qCK6riErSJAbyvYLgn6oR/GC+xSBi
   vmAU4nlPvwBmlhoKjF3D6DYJgNbA+U1uyLRZr+giRVeeLLgTATiVHD3M2
   HTzWeZX/afcRFqNWYjMWAJigTlvGgamz8cmglBU1GfIQaxYjbWlwYTygS
   ovw+BdBHfWK0FUcwSqXla3CddlKHXDp7Ixy7qSHBQWysbEkAhLUTfcVMN
   Q==;
X-CSE-ConnectionGUID: 7dBAAuXPTlmrBBHcNRQigg==
X-CSE-MsgGUID: QPcwaQZqQaCa4EqoRJ9RLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11924"; a="79355663"
X-IronPort-AV: E=Sophos;i="6.27,138,1787036400"; 
   d="scan'208";a="79355663"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2026 21:27:48 -0700
X-CSE-ConnectionGUID: X8bWhvVbQXaGQSjTB4OyNg==
X-CSE-MsgGUID: +EmS8Cj8R7CNYfcZJ4MnhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,138,1787036400"; 
   d="scan'208";a="276088871"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 03 Oct 2026 21:27:47 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDDpA-00000000USA-0ZmJ;
	Sun, 04 Oct 2026 04:27:44 +0000
Date: Sun, 04 Oct 2026 12:27:41 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 7965da4a7fc0a2b2e7d599021f7e6157c80f8704
Message-ID: <202610041238.ya5Rest3-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 7965da4a7fc0a2b2e7d599021f7e6157c80f8704  Merge branch 'for-7.3-fixes' into for-next

elapsed time: 1373m

configs tested: 428
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2303-20261003    gcc-8.5.0  sparse
arc                               alldefconfig    clang-24
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                  nsimosci_hs_smp_defconfig    gcc-16.1.0
arc                   randconfig-1000-20261003    clang-17
arc                   randconfig-1000-20261004    clang-22
arc                   randconfig-1001-20261003    clang-17
arc                   randconfig-1001-20261004    clang-22
arc                  randconfig-r2105-20261003    gcc-8.5.0  cocci
arc                  randconfig-r2106-20261003    gcc-8.5.0  cocci
arc                  randconfig-r2200-20261003    gcc-12.5.0 smatch
arc                  randconfig-r2302-20261003    gcc-13.4.0 sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                           collie_defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                           ixp4xx_defconfig    clang-24
arm                       jornada720_defconfig    clang-24
arm                          nhk8815_defconfig    clang-24
arm                              pxa_defconfig    clang-24
arm                             qcom_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261003    clang-17
arm                   randconfig-1000-20261004    clang-22
arm                   randconfig-1001-20261003    clang-17
arm                   randconfig-1001-20261004    clang-22
arm                   randconfig-1002-20261003    clang-17
arm                   randconfig-1002-20261004    clang-22
arm                   randconfig-1003-20261003    clang-17
arm                   randconfig-1003-20261004    clang-22
arm                  randconfig-r2103-20261003    gcc-14     cocci
arm                  randconfig-r2105-20261002    gcc-10.5.0 cocci
arm                  randconfig-r2309-20261003    gcc-8.5.0  sparse
arm                          s3c6400_defconfig    gcc-16.1.0
arm                          socfpga_defconfig    clang-24
arm                     vt8500_v6_v7_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261003    gcc-9.5.0
arm64                 randconfig-1000-20261004    gcc-16.1.0
arm64                 randconfig-1001-20261003    gcc-9.5.0
arm64                 randconfig-1001-20261004    gcc-16.1.0
arm64                 randconfig-1002-20261003    gcc-9.5.0
arm64                 randconfig-1002-20261004    gcc-16.1.0
arm64                 randconfig-1003-20261003    gcc-9.5.0
arm64                 randconfig-1003-20261004    gcc-16.1.0
arm64                randconfig-r2104-20261003    gcc-11.5.0 cocci
arm64                randconfig-r2106-20261003    clang-19   cocci
arm64                randconfig-r2202-20261003    clang-24   smatch
arm64                randconfig-r2300-20261003    gcc-9.5.0  sparse
arm64                randconfig-r2307-20261003    gcc-8.5.0  sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261003    gcc-9.5.0
csky                  randconfig-1000-20261004    gcc-16.1.0
csky                  randconfig-1001-20261003    gcc-9.5.0
csky                  randconfig-1001-20261004    gcc-16.1.0
csky                 randconfig-r2300-20261003    gcc-14     sparse
csky                 randconfig-r2303-20261003    gcc-16.1.0 sparse
csky                 randconfig-r2307-20261003    gcc-11.5.0 sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261003    gcc-16.1.0
hexagon               randconfig-1000-20261004    gcc-16.1.0
hexagon               randconfig-1001-20261003    gcc-16.1.0
hexagon               randconfig-1001-20261004    gcc-16.1.0
hexagon              randconfig-r2100-20261003    gcc-8.5.0  cocci
hexagon              randconfig-r2105-20261003    clang-19   cocci
hexagon              randconfig-r2106-20261002    clang-22   cocci
hexagon              randconfig-r2107-20261003    clang-19   cocci
hexagon              randconfig-r2304-20261003    gcc-14     sparse
hexagon              randconfig-r2307-20261003    gcc-16.1.0 sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261003    gcc-14
i386        buildonly-randconfig-1000-20261004    clang-22
i386        buildonly-randconfig-1001-20261003    gcc-14
i386        buildonly-randconfig-1001-20261004    clang-22
i386        buildonly-randconfig-1002-20261003    gcc-14
i386        buildonly-randconfig-1002-20261004    clang-22
i386        buildonly-randconfig-1003-20261003    gcc-14
i386        buildonly-randconfig-1003-20261004    clang-22
i386        buildonly-randconfig-1004-20261003    gcc-14
i386        buildonly-randconfig-1004-20261004    clang-22
i386        buildonly-randconfig-1005-20261003    gcc-14
i386        buildonly-randconfig-1005-20261004    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261003    gcc-14
i386                  randconfig-1000-20261004    gcc-14
i386                  randconfig-1001-20261003    gcc-14
i386                  randconfig-1001-20261004    gcc-14
i386                  randconfig-1002-20261003    gcc-14
i386                  randconfig-1002-20261004    gcc-14
i386                  randconfig-1003-20261003    gcc-14
i386                  randconfig-1003-20261004    gcc-14
i386                  randconfig-1004-20261003    gcc-14
i386                  randconfig-1004-20261004    gcc-14
i386                  randconfig-1005-20261003    gcc-14
i386                  randconfig-1005-20261004    gcc-14
i386                  randconfig-1006-20261003    gcc-14
i386                  randconfig-1006-20261004    gcc-14
i386                  randconfig-1007-20261003    gcc-14
i386                  randconfig-1007-20261004    clang-22
i386                  randconfig-1008-20261003    gcc-14
i386                  randconfig-1008-20261004    clang-22
i386                  randconfig-1009-20261003    gcc-14
i386                  randconfig-1009-20261004    clang-22
i386                  randconfig-1010-20261003    gcc-14
i386                  randconfig-1010-20261004    clang-22
i386                  randconfig-1011-20261003    gcc-14
i386                  randconfig-1011-20261004    clang-22
i386                  randconfig-1012-20261003    gcc-14
i386                  randconfig-1012-20261004    clang-22
i386                  randconfig-1013-20261003    gcc-14
i386                  randconfig-1013-20261004    clang-22
i386                  randconfig-2100-20261003    gcc-14     cocci
i386                  randconfig-2101-20261003    clang-22   cocci
i386                  randconfig-2101-20261003    gcc-14     cocci
i386                  randconfig-2102-20261003    gcc-14     cocci
i386                  randconfig-2103-20261003    clang-22   cocci
i386                  randconfig-2103-20261003    gcc-14     cocci
i386                  randconfig-2200-20261003    gcc-14     smatch
i386                  randconfig-2300-20261003    clang-22   sparse
i386                  randconfig-2301-20261003    clang-22   sparse
i386                  randconfig-2302-20261003    clang-22   sparse
i386                 randconfig-r2103-20261003    gcc-13.4.0 cocci
i386                 randconfig-r2107-20261003    clang-21   cocci
i386                 randconfig-r2302-20261003    gcc-16.1.0 sparse
i386                 randconfig-r2306-20261003    gcc-8.5.0  sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261003    gcc-16.1.0
loongarch             randconfig-1000-20261004    gcc-16.1.0
loongarch             randconfig-1001-20261003    gcc-16.1.0
loongarch             randconfig-1001-20261004    gcc-16.1.0
loongarch            randconfig-r2101-20261003    gcc-16.1.0 cocci
loongarch            randconfig-r2102-20261003    gcc-13.4.0 cocci
loongarch            randconfig-r2201-20261003    gcc-16.1.0 smatch
loongarch            randconfig-r2300-20261003    gcc-16.1.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                          apollo_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                 randconfig-r2101-20261003    gcc-12.5.0 cocci
m68k                 randconfig-r2102-20261003    gcc-8.5.0  cocci
m68k                 randconfig-r2103-20261003    gcc-12.5.0 cocci
m68k                 randconfig-r2201-20261003    gcc-9.5.0  smatch
m68k                 randconfig-r2202-20261003    gcc-11.5.0 smatch
m68k                 randconfig-r2301-20261003    gcc-14     sparse
m68k                 randconfig-r2304-20261003    gcc-13.4.0 sparse
m68k                 randconfig-r2306-20261003    gcc-16.1.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2200-20261003    gcc-8.5.0  smatch
microblaze           randconfig-r2201-20261003    gcc-13.4.0 smatch
microblaze           randconfig-r2301-20261003    gcc-16.1.0 sparse
microblaze           randconfig-r2301-20261003    gcc-8.5.0  sparse
microblaze           randconfig-r2305-20261003    gcc-9.5.0  sparse
microblaze           randconfig-r2306-20261003    gcc-12.5.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           eyeq6_defconfig    gcc-16.1.0
mips                            ip32_defconfig    gcc-16.1.0
mips                 malta_qemu_32r6_defconfig    gcc-16.1.0
mips                 randconfig-r2101-20261003    gcc-13.4.0 cocci
mips                 randconfig-r2102-20261003    gcc-8.5.0  cocci
mips                 randconfig-r2107-20261003    gcc-8.5.0  cocci
mips                 randconfig-r2200-20261003    clang-24   smatch
mips                 randconfig-r2303-20261003    gcc-13.4.0 sparse
mips                 randconfig-r2303-20261003    gcc-9.5.0  sparse
mips                 randconfig-r2308-20261003    gcc-8.5.0  sparse
mips                 randconfig-r2309-20261003    gcc-16.1.0 sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261003    gcc-16.1.0
nios2                 randconfig-1000-20261004    gcc-16.1.0
nios2                 randconfig-1001-20261003    gcc-16.1.0
nios2                 randconfig-1001-20261004    gcc-16.1.0
nios2                randconfig-r2100-20261003    gcc-14     cocci
nios2                randconfig-r2101-20261003    gcc-14     cocci
nios2                randconfig-r2306-20261003    gcc-8.5.0  sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2104-20261003    gcc-8.5.0  cocci
openrisc             randconfig-r2202-20261003    gcc-12.5.0 smatch
openrisc             randconfig-r2300-20261003    gcc-8.5.0  sparse
openrisc             randconfig-r2302-20261003    gcc-9.5.0  sparse
openrisc             randconfig-r2306-20261003    gcc-11.5.0 sparse
openrisc             randconfig-r2307-20261003    gcc-14     sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                 generic-32bit_defconfig    gcc-16.1.0
parisc                randconfig-1000-20261003    gcc-11.5.0
parisc                randconfig-1000-20261004    gcc-12.5.0
parisc                randconfig-1001-20261003    gcc-11.5.0
parisc                randconfig-1001-20261004    gcc-12.5.0
parisc               randconfig-r2101-20261003    gcc-8.5.0  cocci
parisc               randconfig-r2102-20261003    gcc-12.5.0 cocci
parisc               randconfig-r2104-20261003    gcc-8.5.0  cocci
parisc               randconfig-r2202-20261003    gcc-14.3.0 smatch
parisc               randconfig-r2304-20261003    gcc-8.5.0  sparse
parisc               randconfig-r2305-20261003    gcc-8.5.0  sparse
parisc               randconfig-r2308-20261003    gcc-14     sparse
parisc64                          alldefconfig    gcc-16.1.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                      kmeter1_defconfig    gcc-16.1.0
powerpc                      powernv_defconfig    clang-24
powerpc               randconfig-1000-20261003    gcc-11.5.0
powerpc               randconfig-1000-20261004    gcc-12.5.0
powerpc               randconfig-1001-20261003    gcc-11.5.0
powerpc               randconfig-1001-20261004    gcc-12.5.0
powerpc              randconfig-r2104-20261003    clang-21   cocci
powerpc              randconfig-r2107-20261003    gcc-11.5.0 cocci
powerpc              randconfig-r2309-20261003    clang-21   sparse
powerpc64             randconfig-1000-20261003    gcc-11.5.0
powerpc64             randconfig-1000-20261004    gcc-12.5.0
powerpc64             randconfig-1001-20261003    gcc-11.5.0
powerpc64             randconfig-1001-20261004    gcc-12.5.0
powerpc64            randconfig-r2100-20261003    gcc-15.2.0 cocci
powerpc64            randconfig-r2106-20261003    gcc-11.5.0 cocci
powerpc64            randconfig-r2300-20261003    gcc-13.4.0 sparse
powerpc64            randconfig-r2308-20261003    gcc-10.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261003    gcc-12.5.0
riscv                 randconfig-1000-20261004    gcc-11.5.0
riscv                 randconfig-1001-20261003    gcc-12.5.0
riscv                 randconfig-1001-20261004    gcc-11.5.0
riscv                 randconfig-2000-20261003    clang-17
riscv                 randconfig-2000-20261003    gcc-16.1.0
riscv                 randconfig-2001-20261003    gcc-16.1.0
riscv                 randconfig-2001-20261003    gcc-9.5.0
riscv                randconfig-r2201-20261003    clang-24   smatch
riscv                randconfig-r2301-20261003    gcc-9.5.0  sparse
riscv                randconfig-r2307-20261003    gcc-8.5.0  sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261003    gcc-12.5.0
s390                  randconfig-1000-20261004    gcc-11.5.0
s390                  randconfig-1001-20261003    gcc-12.5.0
s390                  randconfig-1001-20261004    gcc-11.5.0
s390                  randconfig-2000-20261003    clang-24
s390                  randconfig-2000-20261003    gcc-16.1.0
s390                  randconfig-2001-20261003    gcc-13.4.0
s390                  randconfig-2001-20261003    gcc-16.1.0
s390                 randconfig-r2100-20261003    gcc-12.5.0 cocci
s390                 randconfig-r2103-20261003    gcc-8.5.0  cocci
s390                 randconfig-r2309-20261003    gcc-11.5.0 sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261003    gcc-12.5.0
sh                    randconfig-1000-20261004    gcc-11.5.0
sh                    randconfig-1001-20261003    gcc-12.5.0
sh                    randconfig-1001-20261004    gcc-11.5.0
sh                    randconfig-2000-20261003    gcc-16.1.0
sh                    randconfig-2001-20261003    gcc-16.1.0
sh                   randconfig-r2101-20261003    gcc-8.5.0  cocci
sh                   randconfig-r2201-20261003    gcc-16.1.0 smatch
sh                   randconfig-r2301-20261003    gcc-13.4.0 sparse
sh                   randconfig-r2304-20261003    gcc-9.5.0  sparse
sh                   randconfig-r2306-20261003    gcc-14     sparse
sh                            se7724_defconfig    gcc-16.1.0
sh                      sh7710voipgw_defconfig    gcc-16.1.0
sh                         sh7785lcr_defconfig    gcc-16.1.0
sparc                             alldefconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261003    clang-17
sparc                 randconfig-1000-20261004    gcc-14
sparc                 randconfig-1001-20261003    clang-17
sparc                 randconfig-1001-20261004    gcc-14
sparc                 randconfig-2000-20261003    gcc-14
sparc                 randconfig-2000-20261003    gcc-16.1.0
sparc                 randconfig-2001-20261003    gcc-14
sparc                 randconfig-2001-20261003    gcc-16.1.0
sparc                randconfig-r2105-20261003    gcc-11.5.0 cocci
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261003    clang-17
sparc64               randconfig-1000-20261004    gcc-14
sparc64               randconfig-1001-20261003    clang-17
sparc64               randconfig-1001-20261004    gcc-14
sparc64               randconfig-2000-20261003    gcc-14
sparc64               randconfig-2000-20261003    gcc-8.5.0
sparc64               randconfig-2001-20261003    gcc-14
sparc64               randconfig-2001-20261003    gcc-8.5.0
sparc64              randconfig-r2100-20261003    gcc-8.5.0  cocci
sparc64              randconfig-r2106-20261003    clang-21   cocci
sparc64              randconfig-r2200-20261003    clang-24   smatch
sparc64              randconfig-r2202-20261002    gcc-11.5.0 smatch
sparc64              randconfig-r2302-20261003    gcc-8.5.0  sparse
sparc64              randconfig-r2304-20261003    gcc-16.1.0 sparse
sparc64              randconfig-r2305-20261003    gcc-13.4.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261003    clang-17
um                    randconfig-1000-20261004    gcc-14
um                    randconfig-1001-20261003    clang-17
um                    randconfig-1001-20261004    gcc-14
um                    randconfig-2000-20261003    clang-24
um                    randconfig-2000-20261003    gcc-14
um                    randconfig-2001-20261003    gcc-14
um                   randconfig-r2102-20261003    gcc-8.5.0  cocci
um                   randconfig-r2104-20261003    clang-19   cocci
um                   randconfig-r2105-20261003    clang-21   cocci
um                   randconfig-r2107-20261002    clang-21   cocci
um                   randconfig-r2308-20261003    gcc-11.5.0 sparse
um                   randconfig-r2308-20261003    gcc-16.1.0 sparse
um                   randconfig-r2309-20261003    gcc-14     sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22   checkkconfigsymbols
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261003    clang-22
x86_64      buildonly-randconfig-1000-20261004    gcc-14
x86_64      buildonly-randconfig-1001-20261003    clang-22
x86_64      buildonly-randconfig-1001-20261004    gcc-14
x86_64      buildonly-randconfig-1002-20261003    clang-22
x86_64      buildonly-randconfig-1002-20261004    gcc-14
x86_64      buildonly-randconfig-1003-20261003    clang-22
x86_64      buildonly-randconfig-1003-20261004    gcc-14
x86_64      buildonly-randconfig-1004-20261003    clang-22
x86_64      buildonly-randconfig-1004-20261004    gcc-14
x86_64      buildonly-randconfig-1005-20261003    clang-22
x86_64      buildonly-randconfig-1005-20261004    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261003    clang-22
x86_64                randconfig-1000-20261004    gcc-14
x86_64                randconfig-1001-20261003    clang-22
x86_64                randconfig-1001-20261004    gcc-14
x86_64                randconfig-1002-20261003    clang-22
x86_64                randconfig-1002-20261004    gcc-14
x86_64                randconfig-1003-20261003    clang-22
x86_64                randconfig-1003-20261004    gcc-14
x86_64                randconfig-1004-20261003    clang-22
x86_64                randconfig-1004-20261004    gcc-14
x86_64                randconfig-1005-20261003    clang-22
x86_64                randconfig-1005-20261004    gcc-14
x86_64                randconfig-1006-20261003    clang-22
x86_64                randconfig-1006-20261004    clang-22
x86_64                randconfig-1007-20261003    clang-22
x86_64                randconfig-1007-20261004    clang-22
x86_64                randconfig-1008-20261003    clang-22
x86_64                randconfig-1008-20261004    clang-22
x86_64                randconfig-1009-20261003    clang-22
x86_64                randconfig-1009-20261004    clang-22
x86_64                randconfig-1010-20261003    clang-22
x86_64                randconfig-1010-20261004    clang-22
x86_64                randconfig-1011-20261003    clang-22
x86_64                randconfig-1011-20261004    clang-22
x86_64                randconfig-1012-20261003    clang-22
x86_64                randconfig-1013-20261003    clang-22
x86_64                randconfig-1014-20261003    clang-22
x86_64                randconfig-1015-20261003    clang-22
x86_64                randconfig-1016-20261003    clang-22
x86_64                randconfig-1017-20261003    clang-22
x86_64                randconfig-2100-20261003    clang-22   cocci
x86_64                randconfig-2101-20261003    clang-22   cocci
x86_64                randconfig-2102-20261003    clang-22   cocci
x86_64                randconfig-2103-20261003    clang-22   cocci
x86_64                randconfig-2200-20261003    gcc-14     smatch
x86_64                randconfig-2300-20261003    clang-22   sparse
x86_64                randconfig-2301-20261003    clang-22   sparse
x86_64                randconfig-2302-20261003    clang-22   sparse
x86_64               randconfig-r2102-20261003    gcc-14     cocci
x86_64               randconfig-r2303-20261003    gcc-14     sparse
x86_64               randconfig-r2305-20261003    gcc-14     sparse
x86_64               randconfig-r2308-20261003    gcc-8.5.0  sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261003    clang-17
xtensa                randconfig-1000-20261004    gcc-14
xtensa                randconfig-1001-20261003    clang-17
xtensa                randconfig-1001-20261004    gcc-14
xtensa                randconfig-2000-20261003    gcc-14
xtensa                randconfig-2000-20261003    gcc-8.5.0
xtensa                randconfig-2001-20261003    gcc-10.5.0
xtensa                randconfig-2001-20261003    gcc-14
xtensa               randconfig-r2100-20261003    gcc-13.4.0 cocci
xtensa               randconfig-r2104-20261002    gcc-12.5.0 cocci
xtensa               randconfig-r2107-20261003    gcc-8.5.0  cocci
xtensa               randconfig-r2200-20261003    gcc-8.5.0  smatch
xtensa               randconfig-r2202-20261003    gcc-8.5.0  smatch
xtensa               randconfig-r2302-20261003    gcc-14     sparse
xtensa               randconfig-r2305-20261003    gcc-16.1.0 sparse
xtensa               randconfig-r2307-20261003    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
