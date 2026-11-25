Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597904;
	b=hZXwOP3gMW5NWtEuka4amzKpoSCwzhrQDobYOwi7L5xb/+iIpUSEedS0saqHHct1muEP
	 hpk7OjDes7Pz/oxX5g1g9zwXQNSuiAFBjKPg6eMrOA4pXxxATyE4fNaFj+hq07b5t5yXz
	 qy/bxzAaHt/jlRKw4mDOCUCu8wi41UJvUpZepkqHUDjo5aH4Br5WgUSxI3mRYN0XdsAvq
	 qEXhDg/Sz/Qy6GNBvjbPQ5tHYZS3UYmyeGdT/QRD8kpERH+tmkoxE6ZM72glluo/ObabV
	 7mmKxTqlT0RJ2EUtllupSfOT6FYqQJB/fnXeoGKEKlhkw3aF/C/a1auLvlfoB5XIP5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597904;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=ZZdaU8zV0aC+KgCA7jwYTKqPf50mD5/clGMTjxDqQpQ=;
	b=Z6SCrnQpLrgTa0rnG9Ps6BadJxA6Rh4kH+txPpAYM5n+dzRl6Ndnvd4mxQVjPeTsIahT
	 5FNIbTPUXnjY/5vd09CkqDX0VCGB96aAVWzcevrapy+A5xdWfWaeK/jk0M3bB/jpBJkp2
	 ZVM5I1U5xcRcRAr5Ajv+8PoHAlRwIrr3dBAB16aEB3AslJ0DadLSW+nxcIAQLFmIOEaAk
	 CkYMxMIRQffHXC004YQINMTwibv8QsmMromO8qdaXIz+UfnmFDbLTxN11RiEzNW0P1g6e
	 +MRNCJS8w6KehoBocrgbU5jL/a3C2Q6XPPVa83HO+8NYNNC3jKMEsqoLQ62L0QU7SqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="GOh9ER/z";
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D526606A321
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 09:11:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D526606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GOh9ER/z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795597904; x=1827133904;
  h=date:from:to:cc:subject:message-id;
  bh=oibGhv0SDIsFZgrZfmd5+H0ZkXXgS9eVBSBaUmkGkec=;
  b=GOh9ER/zTGHXBdb++dxIPunc9weqZ5hJK2QrJ882o4rzW7d3tEcOfTiA
   2ALnE56sgXfLB8kqrpW2xfyRwUemrwyD+GFd7RdnhBfrh+ZhmcU3FZyo6
   P8F3k6YPZvLshyuyL0/TYZK+19QkZnTJfK+uWECKj5rH8eEZLO6mAEvnq
   /TMKTYylcy7dRr92AuRa1xBcFC33Ccw7jhaAZXGJkDRPBpmD4T96L6+ov
   gbMMia1yDxxnHjbnsdbG54gMcfCRb6udyQEoOUwwTWZTxU8Xvsqw4K2xM
   7gq9pJIF02ppdk02i4F2DFx5olkHvt5Jbp0rdOcgQmTSc1zkGUBFqpVWh
   Q==;
X-CSE-ConnectionGUID: TU/pN/MtSAG6jq/0xAfzjQ==
X-CSE-MsgGUID: ezuxhur1RFCWRTOmFR31wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4356525"
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="4356525"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 01:11:42 -0800
X-CSE-ConnectionGUID: fRn9256iTmSacAhXE1zrqw==
X-CSE-MsgGUID: o+V7Wyd2TeihzMJV72rwHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="12244635"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 25 Nov 2026 01:11:40 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xW92P-00000001RDi-3JvP;
	Wed, 25 Nov 2026 09:11:37 +0000
Date: Wed, 25 Nov 2026 17:11:25 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.4-fixes] BUILD SUCCESS
 c99f50e4acf86bfbbe313d79f281d83be1763260
Message-ID: <20261125171125.M5Gwzksz-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.4-fixes
branch HEAD: c99f50e4acf86bfbbe313d79f281d83be1763260  cgroup/rstat: disable preemption in css_rstat_updated()

elapsed time: 958m

configs tested: 520
configs skipped: 15

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261124    gcc-11.5.0
alpha                 randconfig-2001-20261124    gcc-11.5.0
alpha                 randconfig-2200-20261124    gcc-8.5.0  smatch
alpha                randconfig-r2101-20261124    clang-22   cocci
alpha                randconfig-r2103-20261124    gcc-9.5.0  cocci
alpha                randconfig-r2111-20261125    gcc-13.5.0 cocci
alpha                randconfig-r2300-20261124    gcc-14.4.0 sparse
alpha                randconfig-r2300-20261124    gcc-16.2.0 sparse
alpha                randconfig-r2306-20261124    gcc-16.2.0 sparse
alpha                randconfig-r2310-20261124    gcc-16.2.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                          haps_hs_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261125    gcc-8.5.0
arc                   randconfig-1001-20261125    gcc-8.5.0
arc                   randconfig-2000-20261124    gcc-11.5.0
arc                   randconfig-2000-20261125    gcc-10.5.0
arc                   randconfig-2001-20261124    gcc-11.5.0
arc                   randconfig-2001-20261125    gcc-10.5.0
arc                   randconfig-2002-20261124    gcc-11.5.0
arc                   randconfig-2002-20261125    gcc-10.5.0
arc                   randconfig-2003-20261124    gcc-11.5.0
arc                   randconfig-2003-20261125    gcc-10.5.0
arc                   randconfig-2004-20261124    gcc-11.5.0
arc                   randconfig-2004-20261125    gcc-10.5.0
arc                   randconfig-2005-20261124    gcc-11.5.0
arc                   randconfig-2005-20261125    gcc-10.5.0
arc                   randconfig-2200-20261124    gcc-8.5.0  smatch
arc                  randconfig-r2101-20261124    gcc-16.2.0 cocci
arc                  randconfig-r2107-20261124    gcc-8.5.0  cocci
arc                  randconfig-r2107-20261125    gcc-13.5.0 cocci
arc                  randconfig-r2109-20261124    gcc-15.3.0 cocci
arc                  randconfig-r2300-20261124    gcc-16.2.0 sparse
arc                  randconfig-r2301-20261124    clang-24   sparse
arc                  randconfig-r2301-20261124    gcc-14.4.0 sparse
arc                  randconfig-r2304-20261124    gcc-14.4.0 sparse
arc                  randconfig-r2304-20261124    gcc-16.2.0 sparse
arc                  randconfig-r2306-20261124    gcc-14     sparse
arc                  randconfig-r2308-20261124    gcc-14     sparse
arc                  randconfig-r2311-20261124    gcc-9.5.0  sparse
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                          assabet_defconfig    gcc-16.2.0
arm                          axm55xx_defconfig    gcc-16.2.0
arm                          bcm2835_defconfig    clang-17
arm                         clps711x_defconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                          lpc18xx_defconfig    clang-17
arm                          lpc32xx_defconfig    clang-17
arm                           moxart_defconfig    clang-17
arm                           moxart_defconfig    clang-24
arm                          mv78xx0_defconfig    clang-17
arm                          mv78xx0_defconfig    gcc-16.2.0
arm                           pxa168_defconfig    clang-17
arm                           pxa168_defconfig    gcc-16.2.0
arm                           pxa3xx_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261125    gcc-8.5.0
arm                   randconfig-1001-20261125    gcc-8.5.0
arm                   randconfig-1002-20261125    gcc-8.5.0
arm                   randconfig-1003-20261125    gcc-8.5.0
arm                   randconfig-2000-20261124    clang-17
arm                   randconfig-2001-20261124    clang-17
arm                   randconfig-2002-20261124    clang-17
arm                   randconfig-2200-20261124    clang-17   smatch
arm                  randconfig-r2100-20261124    clang-24   cocci
arm                  randconfig-r2100-20261124    gcc-16.2.0 cocci
arm                  randconfig-r2102-20261124    gcc-14.4.0 cocci
arm                  randconfig-r2105-20261124    gcc-16.2.0 cocci
arm                  randconfig-r2107-20261124    gcc-15.3.0 cocci
arm                  randconfig-r2300-20261124    clang-22   sparse
arm                  randconfig-r2300-20261124    gcc-16.2.0 sparse
arm                  randconfig-r2302-20261124    clang-24   sparse
arm                  randconfig-r2302-20261124    gcc-14.4.0 sparse
arm                  randconfig-r2303-20261124    gcc-16.2.0 sparse
arm                  randconfig-r2304-20261124    gcc-16.2.0 sparse
arm                            sama7_defconfig    clang-17
arm                          socfpga_defconfig    clang-17
arm                           sp7021_defconfig    clang-24
arm                           sp7021_defconfig    gcc-16.2.0
arm                            u8500_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261125    clang-24
arm64                 randconfig-1001-20261125    clang-24
arm64                 randconfig-1002-20261125    clang-24
arm64                 randconfig-1003-20261125    clang-24
arm64                 randconfig-2000-20261124    clang-17
arm64                 randconfig-2001-20261124    clang-17
arm64                 randconfig-2002-20261124    clang-17
arm64                 randconfig-2200-20261124    gcc-16.2.0 smatch
arm64                randconfig-r2101-20261124    clang-24   cocci
arm64                randconfig-r2105-20261124    gcc-8.5.0  cocci
arm64                randconfig-r2111-20261124    gcc-15.3.0 cocci
arm64                randconfig-r2300-20261124    gcc-16.2.0 sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261125    clang-24
csky                  randconfig-1001-20261125    clang-24
csky                  randconfig-2000-20261124    gcc-16.2.0
csky                  randconfig-2001-20261124    gcc-16.2.0
csky                  randconfig-2200-20261124    gcc-15.3.0 smatch
csky                 randconfig-r2105-20261124    clang-22   cocci
csky                 randconfig-r2111-20261124    gcc-11.5.0 cocci
csky                 randconfig-r2302-20261124    gcc-14.4.0 sparse
csky                 randconfig-r2303-20261124    gcc-14.4.0 sparse
csky                 randconfig-r2304-20261124    gcc-16.2.0 sparse
csky                 randconfig-r2309-20261124    clang-24   sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261125    gcc-11.5.0
hexagon               randconfig-1001-20261125    gcc-11.5.0
hexagon               randconfig-2000-20261124    gcc-16.2.0
hexagon               randconfig-2001-20261124    gcc-16.2.0
hexagon              randconfig-r2103-20261124    clang-22   cocci
hexagon              randconfig-r2107-20261124    gcc-14     cocci
hexagon              randconfig-r2108-20261124    gcc-11.5.0 cocci
hexagon              randconfig-r2110-20261124    gcc-11.5.0 cocci
hexagon              randconfig-r2302-20261124    gcc-16.2.0 sparse
hexagon              randconfig-r2303-20261124    clang-24   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261125    clang-22
i386        buildonly-randconfig-1001-20261125    clang-22
i386        buildonly-randconfig-1002-20261125    clang-22
i386        buildonly-randconfig-1003-20261125    clang-22
i386        buildonly-randconfig-1004-20261125    clang-22
i386        buildonly-randconfig-1005-20261125    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261125    clang-22
i386                  randconfig-1001-20261125    clang-22
i386                  randconfig-1002-20261125    clang-22
i386                  randconfig-1003-20261125    clang-22
i386                  randconfig-1004-20261125    clang-22
i386                  randconfig-1005-20261125    clang-22
i386                  randconfig-1006-20261125    clang-22
i386                  randconfig-2000-20261124    gcc-14
i386                  randconfig-2001-20261124    gcc-14
i386                  randconfig-2002-20261124    gcc-14
i386                  randconfig-2003-20261124    gcc-14
i386                  randconfig-2004-20261124    gcc-14
i386                  randconfig-2005-20261124    gcc-14
i386                  randconfig-2100-20261124    gcc-14     cocci
i386                  randconfig-2101-20261124    gcc-14     cocci
i386                  randconfig-2102-20261124    gcc-14     cocci
i386                  randconfig-2103-20261124    gcc-14     cocci
i386                  randconfig-2104-20261124    gcc-14     cocci
i386                  randconfig-2105-20261124    gcc-14     cocci
i386                  randconfig-2200-20261124    clang-22   smatch
i386                  randconfig-2300-20261124    gcc-14     sparse
i386                  randconfig-2301-20261124    gcc-14     sparse
i386                  randconfig-2302-20261124    gcc-14     sparse
i386                 randconfig-r2102-20261124    gcc-8.5.0  cocci
i386                 randconfig-r2103-20261124    gcc-16.2.0 cocci
i386                 randconfig-r2104-20261124    clang-22   cocci
i386                 randconfig-r2109-20261124    gcc-14     cocci
i386                 randconfig-r2110-20261124    gcc-11.5.0 cocci
i386                 randconfig-r2110-20261124    gcc-15.3.0 cocci
i386                 randconfig-r2111-20261124    gcc-11.5.0 cocci
i386                 randconfig-r2301-20261124    gcc-16.2.0 sparse
i386                 randconfig-r2303-20261124    clang-22   sparse
i386                 randconfig-r2305-20261124    gcc-16.2.0 sparse
i386                 randconfig-r2307-20261124    gcc-8.5.0  sparse
i386                 randconfig-r2308-20261124    gcc-16.2.0 sparse
i386                 randconfig-r2311-20261124    gcc-16.2.0 sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261125    gcc-11.5.0
loongarch             randconfig-1001-20261125    gcc-11.5.0
loongarch             randconfig-2000-20261124    clang-18
loongarch             randconfig-2001-20261124    clang-18
loongarch             randconfig-2200-20261124    gcc-16.2.0 smatch
loongarch            randconfig-r2100-20261124    gcc-9.5.0  cocci
loongarch            randconfig-r2105-20261124    gcc-14.4.0 cocci
loongarch            randconfig-r2106-20261124    gcc-15.3.0 cocci
loongarch            randconfig-r2305-20261124    gcc-14.4.0 sparse
loongarch            randconfig-r2307-20261124    gcc-14     sparse
loongarch            randconfig-r2309-20261124    gcc-16.2.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                        m5235evb_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261124    gcc-11.5.0
m68k                  randconfig-2001-20261124    gcc-11.5.0
m68k                  randconfig-2200-20261124    gcc-10.5.0 smatch
m68k                 randconfig-r2101-20261124    gcc-8.5.0  cocci
m68k                 randconfig-r2102-20261124    gcc-9.5.0  cocci
m68k                 randconfig-r2105-20261124    gcc-15.3.0 cocci
m68k                 randconfig-r2105-20261124    gcc-16.2.0 cocci
m68k                 randconfig-r2106-20261124    gcc-14.4.0 cocci
m68k                 randconfig-r2107-20261124    clang-20   cocci
m68k                 randconfig-r2107-20261124    gcc-11.5.0 cocci
m68k                 randconfig-r2111-20261124    gcc-8.5.0  cocci
m68k                 randconfig-r2301-20261124    gcc-14.4.0 sparse
m68k                           sun3x_defconfig    clang-17
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261124    gcc-11.5.0
microblaze            randconfig-2001-20261124    gcc-11.5.0
microblaze            randconfig-2200-20261124    gcc-8.5.0  smatch
microblaze           randconfig-r2100-20261124    gcc-14.4.0 cocci
microblaze           randconfig-r2101-20261124    gcc-14.4.0 cocci
microblaze           randconfig-r2106-20261125    gcc-13.5.0 cocci
microblaze           randconfig-r2107-20261124    gcc-11.5.0 cocci
microblaze           randconfig-r2108-20261124    gcc-15.3.0 cocci
microblaze           randconfig-r2108-20261125    gcc-13.5.0 cocci
microblaze           randconfig-r2110-20261124    gcc-8.5.0  cocci
microblaze           randconfig-r2300-20261124    clang-24   sparse
microblaze           randconfig-r2302-20261124    gcc-16.2.0 sparse
microblaze           randconfig-r2307-20261124    gcc-12.5.0 sparse
microblaze           randconfig-r2307-20261124    gcc-9.5.0  sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           ath79_defconfig    clang-17
mips                        bmips_be_defconfig    gcc-16.2.0
mips                      decstation_defconfig    clang-17
mips                  decstation_r4k_defconfig    clang-17
mips                            gcw0_defconfig    clang-24
mips                            ip30_defconfig    clang-17
mips                            ip30_defconfig    gcc-16.2.0
mips                       maltasmvp_defconfig    gcc-16.2.0
mips                       pic32mzda_defconfig    clang-24
mips                  randconfig-2000-20261124    gcc-16.2.0
mips                  randconfig-2001-20261124    gcc-16.2.0
mips                  randconfig-2002-20261124    gcc-16.2.0
mips                  randconfig-2200-20261124    clang-20   smatch
mips                 randconfig-r2100-20261124    gcc-8.5.0  cocci
mips                 randconfig-r2101-20261124    gcc-15.3.0 cocci
mips                 randconfig-r2108-20261124    gcc-14.4.0 cocci
mips                 randconfig-r2109-20261124    gcc-14.4.0 cocci
mips                 randconfig-r2110-20261124    gcc-14     cocci
mips                          rt305x_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261125    gcc-11.5.0
nios2                 randconfig-1001-20261125    gcc-11.5.0
nios2                 randconfig-2000-20261124    clang-18
nios2                 randconfig-2001-20261124    clang-18
nios2                 randconfig-2200-20261124    gcc-11.5.0 smatch
nios2                randconfig-r2103-20261124    gcc-8.5.0  cocci
nios2                randconfig-r2104-20261124    gcc-9.5.0  cocci
nios2                randconfig-r2108-20261124    clang-20   cocci
nios2                randconfig-r2108-20261124    gcc-8.5.0  cocci
nios2                randconfig-r2109-20261124    gcc-11.5.0 cocci
nios2                randconfig-r2109-20261125    gcc-13.5.0 cocci
nios2                randconfig-r2111-20261124    gcc-14     cocci
nios2                randconfig-r2304-20261124    clang-22   sparse
nios2                randconfig-r2305-20261124    clang-22   sparse
nios2                randconfig-r2307-20261124    clang-20   sparse
nios2                randconfig-r2308-20261124    gcc-12.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261124    gcc-16.2.0
openrisc              randconfig-2001-20261124    gcc-16.2.0
openrisc              randconfig-2002-20261124    gcc-16.2.0
openrisc              randconfig-2200-20261124    gcc-11.5.0 smatch
openrisc             randconfig-r2102-20261124    clang-22   cocci
openrisc             randconfig-r2103-20261124    gcc-16.2.0 cocci
openrisc             randconfig-r2104-20261124    gcc-15.3.0 cocci
openrisc             randconfig-r2104-20261124    gcc-16.2.0 cocci
openrisc             randconfig-r2106-20261124    gcc-15.3.0 cocci
openrisc             randconfig-r2111-20261124    gcc-11.5.0 cocci
openrisc             randconfig-r2300-20261124    gcc-14.4.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261125    clang-24
parisc                randconfig-1001-20261125    clang-24
parisc                randconfig-2000-20261124    clang-18
parisc                randconfig-2001-20261124    clang-18
parisc                randconfig-2200-20261124    gcc-9.5.0  smatch
parisc               randconfig-r2102-20261124    gcc-15.3.0 cocci
parisc               randconfig-r2105-20261124    clang-24   cocci
parisc               randconfig-r2109-20261124    gcc-8.5.0  cocci
parisc               randconfig-r2303-20261124    gcc-16.2.0 sparse
parisc               randconfig-r2305-20261124    gcc-16.2.0 sparse
parisc               randconfig-r2308-20261124    gcc-9.5.0  sparse
parisc               randconfig-r2311-20261124    clang-24   sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                      asp8347_defconfig    clang-24
powerpc                  canyonlands_defconfig    gcc-16.2.0
powerpc                  mpc836x_rdk_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261125    clang-24
powerpc               randconfig-1001-20261125    clang-24
powerpc               randconfig-2000-20261124    clang-24
powerpc               randconfig-2001-20261124    clang-24
powerpc               randconfig-2002-20261124    clang-24
powerpc               randconfig-2200-20261124    clang-21   smatch
powerpc              randconfig-r2102-20261124    gcc-16.2.0 cocci
powerpc              randconfig-r2104-20261124    gcc-16.2.0 cocci
powerpc              randconfig-r2104-20261124    gcc-8.5.0  cocci
powerpc              randconfig-r2106-20261124    clang-20   cocci
powerpc              randconfig-r2107-20261124    gcc-11.5.0 cocci
powerpc              randconfig-r2302-20261124    clang-22   sparse
powerpc              randconfig-r2306-20261124    gcc-12.5.0 sparse
powerpc                      tqm8555_defconfig    clang-17
powerpc                          wii_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261125    clang-24
powerpc64             randconfig-1001-20261125    clang-24
powerpc64             randconfig-2000-20261124    clang-24
powerpc64             randconfig-2001-20261124    clang-24
powerpc64             randconfig-2002-20261124    clang-24
powerpc64             randconfig-2200-20261124    gcc-12.5.0 smatch
powerpc64            randconfig-r2103-20261124    gcc-14.4.0 cocci
powerpc64            randconfig-r2302-20261124    gcc-16.2.0 sparse
powerpc64            randconfig-r2308-20261124    clang-20   sparse
powerpc64            randconfig-r2310-20261124    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv              nommu_k210_sdcard_defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261125    gcc-8.5.0
riscv                 randconfig-1001-20261125    gcc-8.5.0
riscv                 randconfig-2000-20261124    gcc-16.2.0
riscv                 randconfig-2001-20261124    gcc-16.2.0
riscv                 randconfig-2002-20261124    gcc-16.2.0
riscv                 randconfig-2003-20261124    gcc-16.2.0
riscv                 randconfig-2004-20261124    gcc-16.2.0
riscv                 randconfig-2005-20261124    gcc-16.2.0
riscv                 randconfig-2200-20261124    gcc-14.4.0 smatch
riscv                randconfig-r2102-20261124    gcc-16.2.0 cocci
riscv                randconfig-r2103-20261124    gcc-15.3.0 cocci
riscv                randconfig-r2105-20261124    gcc-16.2.0 cocci
riscv                randconfig-r2110-20261124    gcc-11.5.0 cocci
riscv                randconfig-r2111-20261124    clang-20   cocci
riscv                randconfig-r2305-20261124    gcc-16.2.0 sparse
riscv                randconfig-r2306-20261124    clang-24   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261125    gcc-8.5.0
s390                  randconfig-1001-20261125    gcc-8.5.0
s390                  randconfig-2000-20261124    clang-24
s390                  randconfig-2001-20261124    clang-24
s390                  randconfig-2002-20261124    clang-24
s390                  randconfig-2003-20261124    clang-24
s390                  randconfig-2004-20261124    clang-24
s390                  randconfig-2005-20261124    clang-24
s390                  randconfig-2200-20261124    clang-24   smatch
s390                 randconfig-r2102-20261124    gcc-16.2.0 cocci
s390                 randconfig-r2106-20261124    gcc-11.5.0 cocci
s390                 randconfig-r2106-20261124    gcc-14     cocci
s390                 randconfig-r2110-20261124    clang-20   cocci
s390                 randconfig-r2110-20261124    gcc-14.4.0 cocci
s390                 randconfig-r2304-20261124    clang-24   sparse
s390                 randconfig-r2310-20261124    gcc-8.5.0  sparse
s390                 randconfig-r2310-20261124    gcc-9.5.0  sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                              espt_defconfig    clang-24
sh                    randconfig-1000-20261125    gcc-8.5.0
sh                    randconfig-1001-20261125    gcc-8.5.0
sh                    randconfig-2000-20261124    gcc-11.5.0
sh                    randconfig-2001-20261124    gcc-11.5.0
sh                    randconfig-2002-20261124    gcc-11.5.0
sh                    randconfig-2003-20261124    gcc-11.5.0
sh                    randconfig-2004-20261124    gcc-11.5.0
sh                    randconfig-2005-20261124    gcc-11.5.0
sh                    randconfig-2200-20261124    gcc-16.2.0 smatch
sh                   randconfig-r2101-20261124    gcc-16.2.0 cocci
sh                   randconfig-r2106-20261124    gcc-11.5.0 cocci
sh                   randconfig-r2107-20261124    gcc-15.3.0 cocci
sh                   randconfig-r2108-20261124    gcc-11.5.0 cocci
sh                   randconfig-r2109-20261124    gcc-11.5.0 cocci
sh                   randconfig-r2305-20261124    gcc-16.2.0 sparse
sh                   randconfig-r2307-20261124    clang-24   sparse
sh                   randconfig-r2309-20261124    gcc-12.5.0 sparse
sh                   randconfig-r2309-20261124    gcc-9.5.0  sparse
sh                   randconfig-r2311-20261124    gcc-8.5.0  sparse
sh                            se7343_defconfig    gcc-16.2.0
sh                            se7780_defconfig    gcc-16.2.0
sh                         sh7757lcr_defconfig    gcc-16.2.0
sh                             shmin_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261125    gcc-12
sparc                 randconfig-1001-20261125    gcc-12
sparc                 randconfig-2000-20261124    gcc-8.5.0
sparc                 randconfig-2001-20261124    gcc-8.5.0
sparc                 randconfig-2200-20261124    gcc-11.5.0 smatch
sparc                randconfig-r2100-20261124    gcc-16.2.0 cocci
sparc                randconfig-r2103-20261124    clang-24   cocci
sparc                randconfig-r2103-20261124    gcc-16.2.0 cocci
sparc                randconfig-r2111-20261124    gcc-14.4.0 cocci
sparc                randconfig-r2301-20261124    gcc-16.2.0 sparse
sparc                randconfig-r2303-20261124    gcc-16.2.0 sparse
sparc                randconfig-r2304-20261124    gcc-14.4.0 sparse
sparc                randconfig-r2306-20261124    gcc-8.5.0  sparse
sparc                randconfig-r2307-20261124    gcc-16.2.0 sparse
sparc                randconfig-r2308-20261124    gcc-8.5.0  sparse
sparc                randconfig-r2309-20261124    clang-20   sparse
sparc                randconfig-r2311-20261124    clang-20   sparse
sparc64                           alldefconfig    clang-24
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261125    gcc-12
sparc64               randconfig-1001-20261125    gcc-12
sparc64               randconfig-2000-20261124    gcc-8.5.0
sparc64               randconfig-2001-20261124    gcc-8.5.0
sparc64               randconfig-2200-20261124    clang-24   smatch
sparc64              randconfig-r2104-20261124    clang-24   cocci
sparc64              randconfig-r2104-20261124    gcc-16.2.0 cocci
sparc64              randconfig-r2105-20261124    gcc-9.5.0  cocci
sparc64              randconfig-r2106-20261124    gcc-11.5.0 cocci
sparc64              randconfig-r2108-20261124    gcc-14     cocci
sparc64              randconfig-r2109-20261124    clang-20   cocci
sparc64              randconfig-r2109-20261124    gcc-15.3.0 cocci
sparc64              randconfig-r2306-20261124    gcc-9.5.0  sparse
sparc64              randconfig-r2310-20261124    clang-20   sparse
sparc64              randconfig-r2310-20261124    gcc-12.5.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261125    gcc-12
um                    randconfig-1001-20261125    gcc-12
um                    randconfig-2000-20261124    gcc-8.5.0
um                    randconfig-2001-20261124    gcc-8.5.0
um                    randconfig-2200-20261124    gcc-14     smatch
um                   randconfig-r2100-20261124    clang-22   cocci
um                   randconfig-r2101-20261124    gcc-16.2.0 cocci
um                   randconfig-r2101-20261124    gcc-9.5.0  cocci
um                   randconfig-r2102-20261124    clang-24   cocci
um                   randconfig-r2107-20261124    gcc-14.4.0 cocci
um                   randconfig-r2301-20261124    gcc-16.2.0 sparse
um                   randconfig-r2303-20261124    gcc-14.4.0 sparse
um                   randconfig-r2305-20261124    gcc-14.4.0 sparse
um                   randconfig-r2306-20261124    clang-20   sparse
um                   randconfig-r2308-20261124    clang-24   sparse
um                   randconfig-r2309-20261124    gcc-8.5.0  sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261125    clang-22
x86_64      buildonly-randconfig-1001-20261125    clang-22
x86_64      buildonly-randconfig-1002-20261125    clang-22
x86_64      buildonly-randconfig-1003-20261125    clang-22
x86_64      buildonly-randconfig-1004-20261125    clang-22
x86_64      buildonly-randconfig-1005-20261125    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261125    clang-22
x86_64                randconfig-1001-20261125    clang-22
x86_64                randconfig-1002-20261125    clang-22
x86_64                randconfig-1003-20261125    clang-22
x86_64                randconfig-1004-20261125    clang-22
x86_64                randconfig-1005-20261125    clang-22
x86_64                randconfig-2000-20261124    gcc-14
x86_64                randconfig-2001-20261124    gcc-14
x86_64                randconfig-2002-20261124    gcc-14
x86_64                randconfig-2003-20261124    gcc-14
x86_64                randconfig-2004-20261124    gcc-14
x86_64                randconfig-2005-20261124    gcc-14
x86_64                randconfig-2100-20261124    gcc-14     cocci
x86_64                randconfig-2101-20261124    gcc-14     cocci
x86_64                randconfig-2102-20261124    gcc-14     cocci
x86_64                randconfig-2103-20261124    gcc-14     cocci
x86_64                randconfig-2104-20261124    gcc-14     cocci
x86_64                randconfig-2105-20261124    gcc-14     cocci
x86_64                randconfig-2200-20261124    gcc-14     smatch
x86_64                randconfig-2300-20261124    gcc-14     sparse
x86_64                randconfig-2301-20261124    gcc-14     sparse
x86_64                randconfig-2302-20261124    gcc-14     sparse
x86_64               randconfig-r2100-20261124    gcc-15.3.0 cocci
x86_64               randconfig-r2106-20261124    gcc-8.5.0  cocci
x86_64               randconfig-r2110-20261124    gcc-15.3.0 cocci
x86_64               randconfig-r2301-20261124    clang-22   sparse
x86_64               randconfig-r2311-20261124    gcc-14     sparse
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
xtensa                   audio_kc705_defconfig    clang-17
xtensa                           iss_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261125    gcc-12
xtensa                randconfig-1001-20261125    gcc-12
xtensa                randconfig-2000-20261124    gcc-16.2.0
xtensa                randconfig-2001-20261124    gcc-16.2.0
xtensa                randconfig-2200-20261124    gcc-9.5.0  smatch
xtensa               randconfig-r2100-20261124    gcc-16.2.0 cocci
xtensa               randconfig-r2104-20261124    gcc-14.4.0 cocci
xtensa               randconfig-r2108-20261124    gcc-11.5.0 cocci
xtensa               randconfig-r2110-20261125    gcc-13.5.0 cocci
xtensa               randconfig-r2305-20261124    clang-24   sparse
xtensa               randconfig-r2309-20261124    gcc-14     sparse
xtensa               randconfig-r2310-20261124    gcc-14     sparse
xtensa               randconfig-r2311-20261124    gcc-12.5.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
