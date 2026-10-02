Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F2746F4A6
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 09:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932551; cv=none; b=TBMVXG1XBWLfEiJk4S6UfHjLBBjIDrfgIhBZpqqSulWZkYcd51og7k8C/4BmgPHuXI1oHc7UO+jv+OoQUTne/zzds+CgpyAQOOxp00+4p5lDQjcyS9j4akWr95lK3wpwm08KVuIW8seH79oHNb8hE472hNL6avGGlWJM7G3WFr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932551; c=relaxed/simple;
	bh=zw7YlZKVvhxVkNmWOSUXTdz1iOSztrFzwtmnGYFuJcA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=irrnMj1QAsUGj+F5p/CWFTW5XOKuZykkfv0EYtAmfk81pMcddKXW9zCXMmgpT9BVyw0QrANEPdFk3uBHCgAfGLJDA9wdcYCFZYeVBOusEsxLIMON9Uli0BnlF3JFaqIW1Zx1EPqI011uf81CBtHN2/4Ld0a8ZRAxDhyFJIBc0fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nhSoqI70; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nhSoqI70"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790932550; x=1822468550;
  h=date:from:to:cc:subject:message-id;
  bh=zw7YlZKVvhxVkNmWOSUXTdz1iOSztrFzwtmnGYFuJcA=;
  b=nhSoqI702nU2gZCwh2jH03MunXDf5XQTXPKW79pIOEutNhHNm9R+5/p9
   EpzW8yE5zH3cWUoMhmDREnOTYSY2OimTD5tx8drTKum5zx888Tm46qb5X
   2OgGCTYqn3aPlEt7vpINIetBuPdYEtzbjjmvNlm8dCvEit1VK5hm3qEX2
   rularAaka/eRaznn53cJRW0+TNDmHBpU5l5fKxKGYCpvr2sW/Ycd+g5iH
   z8h8M6HLo8wuLHIa5XLCM1axYrjX8o5cyTGYJav6oEiE4tr8gVoKf9eE9
   rkzoOaEDR8iF3r93CaZ/ti696gpo4PJe4/vEzHvyEcbH9A1BFBO/4NWKu
   Q==;
X-CSE-ConnectionGUID: C4UnK+VUSe+JmKIWd1Cbvg==
X-CSE-MsgGUID: g5v07pTDRuOfri+jw1YA9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="91799537"
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="91799537"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2026 02:15:49 -0700
X-CSE-ConnectionGUID: 74uYxHN1RE67GA0lA7AoWg==
X-CSE-MsgGUID: 3bb7Yd5/TeaIcNWZpOV3SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="275330265"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 02 Oct 2026 02:15:48 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xCZMn-00000000St2-3mbK;
	Fri, 02 Oct 2026 09:15:45 +0000
Date: Fri, 02 Oct 2026 17:14:46 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 b39049c04ce69cbc039a4b002c911d7a9768a213
Message-ID: <202610021743.9Wu37JbC-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: b39049c04ce69cbc039a4b002c911d7a9768a213  Merge branch 'for-7.4' into for-next

elapsed time: 1085m

configs tested: 342
configs skipped: 7

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2105-20261001    gcc-15.2.0 cocci
alpha                randconfig-r2201-20261001    gcc-15.2.0 smatch
alpha                randconfig-r2307-20261001    gcc-16.1.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                       axs103_smp_defconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261002    clang-17
arc                   randconfig-1001-20261002    clang-17
arc                  randconfig-r2105-20261001    gcc-8.5.0  cocci
arc                  randconfig-r2308-20261001    gcc-16.1.0 sparse
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                          assabet_defconfig    gcc-16.1.0
arm                                  defconfig    gcc-16.1.0
arm                             dove_defconfig    gcc-16.1.0
arm                       integrator_defconfig    gcc-16.1.0
arm                         mvebu_v7_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261002    clang-17
arm                   randconfig-1001-20261002    clang-17
arm                   randconfig-1002-20261002    clang-17
arm                   randconfig-1003-20261002    clang-17
arm                  randconfig-r2103-20261001    gcc-8.5.0  cocci
arm                  randconfig-r2201-20261001    gcc-16.1.0 smatch
arm                          s3c6400_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261002    gcc-12.5.0
arm64                 randconfig-1001-20261002    gcc-12.5.0
arm64                 randconfig-1002-20261002    gcc-12.5.0
arm64                 randconfig-1003-20261002    gcc-12.5.0
arm64                randconfig-r2201-20261001    gcc-16.1.0 smatch
arm64                randconfig-r2303-20261001    gcc-15.2.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261002    gcc-12.5.0
csky                  randconfig-1001-20261002    gcc-12.5.0
csky                 randconfig-r2105-20261001    clang-24   cocci
csky                 randconfig-r2302-20261001    gcc-14     sparse
csky                 randconfig-r2303-20261001    gcc-16.1.0 sparse
csky                 randconfig-r2305-20261001    gcc-15.2.0 sparse
csky                 randconfig-r2309-20261001    gcc-9.5.0  sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261002    gcc-13.4.0
hexagon               randconfig-1001-20261002    gcc-13.4.0
hexagon              randconfig-r2103-20261001    clang-24   cocci
hexagon              randconfig-r2104-20261001    clang-24   cocci
hexagon              randconfig-r2106-20261001    clang-24   cocci
hexagon              randconfig-r2200-20261001    clang-24   smatch
hexagon              randconfig-r2300-20261001    gcc-14     sparse
hexagon              randconfig-r2303-20261001    gcc-14     sparse
hexagon              randconfig-r2304-20261001    gcc-15.2.0 sparse
hexagon              randconfig-r2306-20261001    gcc-14     sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261002    clang-22
i386        buildonly-randconfig-1001-20261002    clang-22
i386        buildonly-randconfig-1002-20261002    clang-22
i386        buildonly-randconfig-1003-20261002    clang-22
i386        buildonly-randconfig-1004-20261002    clang-22
i386        buildonly-randconfig-1005-20261002    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261002    gcc-14
i386                  randconfig-1001-20261002    gcc-14
i386                  randconfig-1002-20261002    gcc-14
i386                  randconfig-1003-20261002    gcc-14
i386                  randconfig-1004-20261002    gcc-14
i386                  randconfig-1005-20261002    gcc-14
i386                  randconfig-1006-20261002    gcc-14
i386                  randconfig-1007-20261002    clang-22
i386                  randconfig-1008-20261002    clang-22
i386                  randconfig-1009-20261002    clang-22
i386                  randconfig-1010-20261002    clang-22
i386                  randconfig-1011-20261002    clang-22
i386                  randconfig-1012-20261002    clang-22
i386                  randconfig-1013-20261002    clang-22
i386                  randconfig-2100-20261001    gcc-14     cocci
i386                  randconfig-2101-20261001    gcc-14     cocci
i386                  randconfig-2102-20261001    clang-22   cocci
i386                  randconfig-2102-20261001    gcc-14     cocci
i386                  randconfig-2103-20261001    gcc-13     cocci
i386                  randconfig-2103-20261001    gcc-14     cocci
i386                  randconfig-2200-20261001    clang-22   smatch
i386                  randconfig-2300-20261001    clang-22   sparse
i386                  randconfig-2300-20261001    gcc-14     sparse
i386                  randconfig-2301-20261001    gcc-14     sparse
i386                  randconfig-2302-20261001    gcc-14     sparse
i386                 randconfig-r2103-20261001    gcc-9.5.0  cocci
i386                 randconfig-r2308-20261001    gcc-14     sparse
i386                 randconfig-r2309-20261001    gcc-14     sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261002    gcc-13.4.0
loongarch             randconfig-1001-20261002    gcc-13.4.0
loongarch            randconfig-r2102-20261001    gcc-8.5.0  cocci
loongarch            randconfig-r2104-20261001    gcc-14     cocci
loongarch            randconfig-r2107-20261001    gcc-14     cocci
loongarch            randconfig-r2107-20261001    gcc-15.2.0 cocci
loongarch            randconfig-r2201-20261001    clang-18   smatch
loongarch            randconfig-r2202-20261001    clang-21   smatch
loongarch            randconfig-r2302-20261001    gcc-15.2.0 sparse
loongarch            randconfig-r2304-20261001    gcc-16.1.0 sparse
loongarch            randconfig-r2305-20261001    gcc-15.2.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                         m5272c3_defconfig    gcc-16.1.0
m68k                        m5275evb_defconfig    gcc-16.1.0
m68k                       m54418evb_defconfig    gcc-16.1.0
m68k                 randconfig-r2200-20261001    gcc-8.5.0  smatch
m68k                 randconfig-r2301-20261001    gcc-14     sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2101-20261001    gcc-10.5.0 cocci
microblaze           randconfig-r2202-20261001    gcc-8.5.0  smatch
microblaze           randconfig-r2301-20261001    gcc-8.5.0  sparse
microblaze           randconfig-r2305-20261001    gcc-16.1.0 sparse
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                      decstation_defconfig    gcc-16.1.0
mips                            ip27_defconfig    gcc-16.1.0
mips                            ip28_defconfig    gcc-16.1.0
mips                         maltaup_defconfig    gcc-16.1.0
mips                     maltaup_xpa_defconfig    gcc-16.1.0
mips                            mtx1_defconfig    gcc-16.1.0
mips                 randconfig-r2100-20261001    gcc-8.5.0  cocci
mips                 randconfig-r2102-20261001    gcc-9.5.0  cocci
mips                 randconfig-r2105-20261001    gcc-9.5.0  cocci
mips                 randconfig-r2106-20261001    gcc-8.5.0  cocci
mips                 randconfig-r2200-20261001    clang-19   smatch
mips                 randconfig-r2202-20261001    clang-24   smatch
mips                 randconfig-r2301-20261001    gcc-16.1.0 sparse
mips                 randconfig-r2308-20261001    gcc-14     sparse
nios2                          3c120_defconfig    gcc-16.1.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261002    gcc-13.4.0
nios2                 randconfig-1001-20261002    gcc-13.4.0
nios2                randconfig-r2100-20261001    gcc-9.5.0  cocci
nios2                randconfig-r2101-20261001    gcc-9.5.0  cocci
nios2                randconfig-r2107-20261001    gcc-11.5.0 cocci
nios2                randconfig-r2201-20261001    gcc-10.5.0 smatch
nios2                randconfig-r2305-20261001    gcc-16.1.0 sparse
openrisc                          alldefconfig    gcc-16.1.0
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2103-20261001    clang-24   cocci
openrisc             randconfig-r2307-20261001    gcc-14     sparse
openrisc             randconfig-r2308-20261001    clang-20   sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261002    gcc-14.3.0
parisc                randconfig-1001-20261002    gcc-14.3.0
parisc               randconfig-r2102-20261001    clang-24   cocci
parisc               randconfig-r2104-20261001    gcc-15.2.0 cocci
parisc               randconfig-r2106-20261001    gcc-14     cocci
parisc               randconfig-r2107-20261001    clang-24   cocci
parisc               randconfig-r2200-20261001    gcc-8.5.0  smatch
parisc               randconfig-r2302-20261001    gcc-15.2.0 sparse
parisc               randconfig-r2304-20261001    gcc-15.2.0 sparse
parisc64                             defconfig    clang-24
powerpc                            allnoconfig    clang-24
powerpc                       arches_defconfig    gcc-16.1.0
powerpc                   iss476-smp_defconfig    gcc-16.1.0
powerpc                       katmai_defconfig    gcc-16.1.0
powerpc                      mpc83xx_defconfig    gcc-16.1.0
powerpc                       pcm030_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261002    gcc-14.3.0
powerpc               randconfig-1001-20261002    gcc-14.3.0
powerpc              randconfig-r2101-20261001    clang-24   cocci
powerpc              randconfig-r2102-20261001    clang-24   cocci
powerpc              randconfig-r2301-20261001    gcc-15.2.0 sparse
powerpc              randconfig-r2303-20261001    gcc-15.2.0 sparse
powerpc                      tqm8555_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20261002    gcc-14.3.0
powerpc64             randconfig-1001-20261002    gcc-14.3.0
powerpc64            randconfig-r2306-20261001    gcc-16.1.0 sparse
powerpc64            randconfig-r2307-20261001    clang-24   sparse
powerpc64            randconfig-r2309-20261001    clang-20   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv              nommu_k210_sdcard_defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261002    clang-24
riscv                 randconfig-1001-20261002    clang-24
riscv                 randconfig-2000-20261001    gcc-10.5.0
riscv                 randconfig-2000-20261001    gcc-9.5.0
riscv                 randconfig-2001-20261001    gcc-10.5.0
riscv                 randconfig-2001-20261001    gcc-8.5.0
riscv                randconfig-r2300-20261001    gcc-15.2.0 sparse
riscv                randconfig-r2300-20261001    gcc-16.1.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                           debug_defconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261002    clang-24
s390                  randconfig-1001-20261002    clang-24
s390                  randconfig-2000-20261001    gcc-10.5.0
s390                  randconfig-2000-20261001    gcc-9.5.0
s390                  randconfig-2001-20261001    clang-17
s390                  randconfig-2001-20261001    gcc-10.5.0
s390                 randconfig-r2302-20261001    gcc-16.1.0 sparse
s390                 randconfig-r2306-20261001    clang-20   sparse
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                          ap325rxa_defconfig    gcc-16.1.0
sh                          apsh4a3a_defconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261002    clang-24
sh                    randconfig-1001-20261002    clang-24
sh                    randconfig-2000-20261001    gcc-10.5.0
sh                    randconfig-2000-20261001    gcc-16.1.0
sh                    randconfig-2001-20261001    gcc-10.5.0
sh                   randconfig-r2100-20261001    clang-24   cocci
sh                   randconfig-r2104-20261001    gcc-12.5.0 cocci
sh                   randconfig-r2301-20261001    gcc-15.2.0 sparse
sh                           sdk7780_defconfig    gcc-16.1.0
sh                            se7780_defconfig    gcc-16.1.0
sh                             shmin_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261002    clang-24
sparc                 randconfig-1001-20261002    clang-24
sparc                 randconfig-2000-20261001    clang-24
sparc                 randconfig-2000-20261001    gcc-12.5.0
sparc                 randconfig-2001-20261001    clang-24
sparc                 randconfig-2001-20261001    gcc-14.3.0
sparc                randconfig-r2101-20261001    clang-24   cocci
sparc                randconfig-r2106-20261001    gcc-15.2.0 cocci
sparc                randconfig-r2107-20261001    gcc-8.5.0  cocci
sparc                randconfig-r2200-20261001    gcc-8.5.0  smatch
sparc                randconfig-r2309-20261001    gcc-16.1.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261002    clang-24
sparc64               randconfig-1001-20261002    clang-24
sparc64               randconfig-2000-20261001    clang-24
sparc64               randconfig-2001-20261001    clang-24
sparc64               randconfig-2001-20261001    gcc-8.5.0
sparc64              randconfig-r2101-20261001    gcc-8.5.0  cocci
sparc64              randconfig-r2106-20261001    gcc-8.5.0  cocci
sparc64              randconfig-r2304-20261001    gcc-14     sparse
sparc64              randconfig-r2307-20261001    clang-20   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261002    clang-24
um                    randconfig-1001-20261002    clang-24
um                    randconfig-2000-20261001    clang-17
um                    randconfig-2000-20261001    clang-24
um                    randconfig-2001-20261001    clang-24
um                   randconfig-r2100-20261001    clang-24   cocci
um                   randconfig-r2306-20261001    gcc-14     sparse
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-22   checkkconfigsymbols
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261002    gcc-14
x86_64      buildonly-randconfig-1001-20261002    gcc-14
x86_64      buildonly-randconfig-1002-20261002    gcc-14
x86_64      buildonly-randconfig-1003-20261002    gcc-14
x86_64      buildonly-randconfig-1004-20261002    gcc-14
x86_64      buildonly-randconfig-1005-20261002    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261002    gcc-14
x86_64                randconfig-1001-20261002    gcc-14
x86_64                randconfig-1002-20261002    gcc-14
x86_64                randconfig-1003-20261002    gcc-14
x86_64                randconfig-1004-20261002    gcc-14
x86_64                randconfig-1005-20261002    gcc-14
x86_64                randconfig-1006-20261002    clang-22
x86_64                randconfig-1007-20261002    clang-22
x86_64                randconfig-1008-20261002    clang-22
x86_64                randconfig-1009-20261002    clang-22
x86_64                randconfig-1010-20261002    clang-22
x86_64                randconfig-1011-20261002    clang-22
x86_64                randconfig-1012-20261002    clang-22
x86_64                randconfig-1013-20261002    clang-22
x86_64                randconfig-1014-20261002    clang-22
x86_64                randconfig-1015-20261002    clang-22
x86_64                randconfig-1016-20261002    clang-22
x86_64                randconfig-1017-20261002    clang-22
x86_64                randconfig-2100-20261001    gcc-14     cocci
x86_64                randconfig-2101-20261001    gcc-14     cocci
x86_64                randconfig-2102-20261001    gcc-14     cocci
x86_64                randconfig-2103-20261001    gcc-14     cocci
x86_64                randconfig-2200-20261001    clang-22   smatch
x86_64                randconfig-2300-20261001    clang-22   sparse
x86_64                randconfig-2300-20261001    gcc-14     sparse
x86_64                randconfig-2301-20261001    clang-22   sparse
x86_64                randconfig-2301-20261001    gcc-14     sparse
x86_64                randconfig-2302-20261001    gcc-14     sparse
x86_64               randconfig-r2100-20261001    gcc-14     cocci
x86_64               randconfig-r2103-20261001    clang-22   cocci
x86_64               randconfig-r2105-20261001    gcc-14     cocci
x86_64               randconfig-r2202-20261001    clang-22   smatch
x86_64               randconfig-r2300-20261001    gcc-14     sparse
x86_64               randconfig-r2305-20261001    gcc-14     sparse
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
xtensa                randconfig-1000-20261002    clang-24
xtensa                randconfig-1001-20261002    clang-24
xtensa                randconfig-2000-20261001    clang-24
xtensa                randconfig-2000-20261001    gcc-10.5.0
xtensa                randconfig-2001-20261001    clang-24
xtensa                randconfig-2001-20261001    gcc-8.5.0
xtensa               randconfig-r2102-20261001    gcc-15.2.0 cocci
xtensa               randconfig-r2104-20261001    gcc-8.5.0  cocci
xtensa               randconfig-r2300-20261001    gcc-15.2.0 sparse
xtensa               randconfig-r2304-20261001    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
