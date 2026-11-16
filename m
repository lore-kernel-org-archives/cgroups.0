Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830557;
	b=v9ZhtHvtKp/FMXLHPlxTxElrbRY6g8A+H7NiRa1v6LbbRM2aJQ8qWT/EjZtqVKkgxD3s
	 8rsMdQ+sndPUJhy6RdkCQARUEPcVGJJMTrNWVqZgsP97RkFur74JQCMFb91zwimhk0fP8
	 gNB8jDrPq9Iy5PcToUDICYuiB+lvVXJBMtXaETSjEAb5tT+hrD7CS1aaQhj9uefp/VVb+
	 BT4Cg/4VJittRTJUxkmkCCLDjzNGG7wJeTIgknmrOm6RLQkZZad9drjCRMv7budHGAV5K
	 p2c9WHhYggYvVWFaIZOwp4xAge6p7ozpelKwXm/ui1vcDgDwSyveMe/ptRBB5S30wdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830557;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=ZfIdSDStGtaEkWQsi0TknzzW68oHmYr9tTHX1Uu9t9U=;
	b=Kd00zJjtPpsXt+0OG/x/sZ3r1jj5sZbvww0hy8KiQEKeforY6zD28OXF259jQf5v0n9/
	 NG8WOp1S/8XQCTk3v0ZIr0o0o4XndeCY4kBuYqF/O3ybfWWdzM3KY/kJ/xresuOGWETS8
	 tg8vNhhf+Dw3EkhnTxq6pWqy+/Fb64o8v7V6XkC+HgjG4F0uO0AdkTk9WsCOpdVlxgK7e
	 djNDqB4dXhEDoHJhGaHEgesKJnkQkNoIZg9OF0EU4ufTtyxjhKyS9fe8/XOn6IrUVOD+w
	 f4iI2hPHX4kxp96u1BYo9KgFqqf5npmFQhgitxL1CWshkWUmImY7sERhmeepo68Jr+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NtuKAx0V;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE1C606A32F
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 12:02:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABE1C606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NtuKAx0V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794830557; x=1826366557;
  h=date:from:to:cc:subject:message-id;
  bh=rdzXuoXLIeiAWiFhRvkfT7Wdm68kPVY70w86J4C2kM4=;
  b=NtuKAx0VSEfR2xdPzdQVKcwsokOWkq9wg/bOXiqPkiPMAy9cakn+X2mh
   W48AfDkT2DmNPZhKEJhTkJpGR7q81MgbB0UmBK739IydmT2VP7goCLPKx
   JE9kDLQjfYs4xPSOYA9b4UT8KMI1ijst2y64j+eB4x1ohulHQmhIB1zBc
   PZh7CcN7k15jpoLemLODcnWGzm2K0YdWHwKUGHoZ5rOIa2AbXbgkad3+i
   ta6qtY9GzRYi7EQbFhDSs2d/UZfOkDEqnLJAHGp+plbhmtX80NWmkPS0m
   v4+mCDMyazl+YosokhjIsHUUU9CVg7Exv9Ge/ASktYpY3LBs7WJ1GW9jO
   w==;
X-CSE-ConnectionGUID: RKupqQ7JQjadNue1uwn5og==
X-CSE-MsgGUID: gZrUJbV0RXqNTPUxDMpfbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11967"; a="3434340"
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="3434340"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 04:02:36 -0800
X-CSE-ConnectionGUID: ymJOWBH9QK+x4ZhKPT/pGw==
X-CSE-MsgGUID: i2bIqtLmTGWWnKcrPJ0vew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="9716384"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 16 Nov 2026 04:02:35 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xSvPs-000000018Tu-0GIA;
	Mon, 16 Nov 2026 12:02:32 +0000
Date: Mon, 16 Nov 2026 20:02:21 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 87b33aeb162b94cf4a30be48b30eeb27adc2054f
Message-ID: <20261116200221.cyDy0tIj-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 87b33aeb162b94cf4a30be48b30eeb27adc2054f  Merge branch 'for-7.4-fixes' into for-next

elapsed time: 918m

configs tested: 556
configs skipped: 5

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261115    gcc-14.4.0
alpha                 randconfig-2000-20261115    gcc-8.5.0
alpha                 randconfig-2000-20261116    gcc-10.5.0
alpha                 randconfig-2001-20261115    gcc-16.2.0
alpha                 randconfig-2001-20261115    gcc-8.5.0
alpha                 randconfig-2001-20261116    gcc-10.5.0
alpha                 randconfig-2200-20261115    gcc-8.5.0  smatch
alpha                 randconfig-2200-20261116    gcc-15.3.0 smatch
alpha                randconfig-r2100-20261115    gcc-8.5.0  cocci
alpha                randconfig-r2102-20261115    gcc-8.5.0  cocci
alpha                randconfig-r2103-20261115    gcc-8.5.0  cocci
alpha                randconfig-r2105-20261115    gcc-8.5.0  cocci
alpha                randconfig-r2109-20261116    gcc-9.5.0  cocci
alpha                randconfig-r2111-20261115    gcc-13.5.0 cocci
alpha                randconfig-r2308-20261116    gcc-9.5.0  sparse
alpha                randconfig-r2310-20261115    gcc-11.5.0 sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261116    gcc-8.5.0
arc                   randconfig-1001-20261116    gcc-8.5.0
arc                   randconfig-2000-20261115    gcc-8.5.0
arc                   randconfig-2000-20261116    gcc-13.5.0
arc                   randconfig-2001-20261115    gcc-8.5.0
arc                   randconfig-2001-20261116    gcc-13.5.0
arc                   randconfig-2002-20261115    gcc-8.5.0
arc                   randconfig-2002-20261116    gcc-13.5.0
arc                   randconfig-2003-20261115    gcc-8.5.0
arc                   randconfig-2003-20261116    gcc-13.5.0
arc                   randconfig-2004-20261115    gcc-8.5.0
arc                   randconfig-2004-20261116    gcc-13.5.0
arc                   randconfig-2005-20261115    gcc-8.5.0
arc                   randconfig-2005-20261116    gcc-13.5.0
arc                   randconfig-2200-20261115    gcc-16.2.0 smatch
arc                   randconfig-2200-20261116    gcc-15.3.0 smatch
arc                  randconfig-r2108-20261115    gcc-13.5.0 cocci
arc                  randconfig-r2311-20261115    gcc-11.5.0 sparse
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                          at91_dt_defconfig    gcc-16.2.0
arm                      davinci_all_defconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                           gemini_defconfig    clang-24
arm                        imx_v4_v5_defconfig    clang-24
arm                           moxart_defconfig    clang-24
arm                             mps2_defconfig    clang-24
arm                        multi_v4t_defconfig    clang-24
arm                              mxs_defconfig    clang-17
arm                         neponset_defconfig    gcc-16.2.0
arm                          orion5x_defconfig    gcc-16.2.0
arm                              pxa_defconfig    gcc-14
arm                   randconfig-1000-20261116    gcc-8.5.0
arm                   randconfig-1001-20261116    gcc-8.5.0
arm                   randconfig-1002-20261116    gcc-8.5.0
arm                   randconfig-1003-20261116    gcc-8.5.0
arm                   randconfig-2000-20261115    clang-24
arm                   randconfig-2000-20261116    gcc-15.3.0
arm                   randconfig-2001-20261115    clang-24
arm                   randconfig-2001-20261115    gcc-10.5.0
arm                   randconfig-2001-20261116    gcc-15.3.0
arm                   randconfig-2002-20261115    clang-24
arm                   randconfig-2002-20261115    gcc-8.5.0
arm                   randconfig-2002-20261116    gcc-15.3.0
arm                   randconfig-2200-20261115    clang-17   smatch
arm                   randconfig-2200-20261116    gcc-13.5.0 smatch
arm                  randconfig-r2101-20261115    gcc-8.5.0  cocci
arm                  randconfig-r2108-20261116    clang-17   cocci
arm                  randconfig-r2308-20261115    gcc-11.5.0 sparse
arm                         realview_defconfig    clang-17
arm                            tegra_defconfig    gcc-16.2.0
arm                         vexpress_defconfig    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261116    gcc-10.5.0
arm64                 randconfig-1001-20261116    gcc-10.5.0
arm64                 randconfig-1002-20261116    gcc-10.5.0
arm64                 randconfig-1003-20261116    gcc-10.5.0
arm64                 randconfig-2000-20261115    clang-24
arm64                 randconfig-2000-20261115    gcc-13.5.0
arm64                 randconfig-2000-20261116    gcc-15.3.0
arm64                 randconfig-2001-20261115    clang-22
arm64                 randconfig-2001-20261115    clang-24
arm64                 randconfig-2001-20261116    gcc-15.3.0
arm64                 randconfig-2002-20261115    clang-24
arm64                 randconfig-2002-20261115    gcc-8.5.0
arm64                 randconfig-2002-20261116    gcc-15.3.0
arm64                 randconfig-2200-20261115    gcc-15.3.0 smatch
arm64                 randconfig-2200-20261116    gcc-8.5.0  smatch
arm64                randconfig-r2104-20261115    gcc-8.5.0  cocci
arm64                randconfig-r2106-20261115    gcc-13.5.0 cocci
arm64                randconfig-r2109-20261116    clang-17   cocci
arm64                randconfig-r2304-20261115    gcc-13.5.0 sparse
arm64                randconfig-r2311-20261116    gcc-9.5.0  sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261116    gcc-10.5.0
csky                  randconfig-1001-20261116    gcc-10.5.0
csky                  randconfig-2000-20261115    gcc-14.4.0
csky                  randconfig-2000-20261116    gcc-16.2.0
csky                  randconfig-2001-20261115    gcc-14.4.0
csky                  randconfig-2001-20261116    gcc-16.2.0
csky                  randconfig-2200-20261115    gcc-12.5.0 smatch
csky                  randconfig-2200-20261116    gcc-16.2.0 smatch
csky                 randconfig-r2102-20261116    gcc-8.5.0  cocci
csky                 randconfig-r2104-20261115    gcc-8.5.0  cocci
csky                 randconfig-r2105-20261116    gcc-12.5.0 cocci
csky                 randconfig-r2109-20261115    gcc-13.5.0 cocci
csky                 randconfig-r2304-20261116    gcc-8.5.0  sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261116    clang-17
hexagon               randconfig-1001-20261116    clang-17
hexagon               randconfig-2000-20261115    gcc-14.4.0
hexagon               randconfig-2000-20261116    gcc-16.2.0
hexagon               randconfig-2001-20261115    gcc-14.4.0
hexagon               randconfig-2001-20261116    gcc-16.2.0
hexagon               randconfig-2200-20261115    clang-24   smatch
hexagon               randconfig-2200-20261116    clang-17   smatch
hexagon              randconfig-r2110-20261116    clang-17   cocci
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261116    gcc-14
i386        buildonly-randconfig-1001-20261116    gcc-14
i386        buildonly-randconfig-1002-20261116    gcc-14
i386        buildonly-randconfig-1003-20261116    gcc-14
i386        buildonly-randconfig-1004-20261116    gcc-14
i386        buildonly-randconfig-1005-20261116    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261116    gcc-14
i386                  randconfig-1001-20261116    gcc-14
i386                  randconfig-1002-20261116    gcc-14
i386                  randconfig-1003-20261116    gcc-14
i386                  randconfig-1004-20261116    gcc-14
i386                  randconfig-1005-20261116    gcc-14
i386                  randconfig-1006-20261116    gcc-14
i386                  randconfig-1007-20261116    gcc-12
i386                  randconfig-1008-20261116    gcc-12
i386                  randconfig-1009-20261116    gcc-12
i386                  randconfig-1010-20261116    gcc-12
i386                  randconfig-1011-20261116    gcc-12
i386                  randconfig-1012-20261116    gcc-12
i386                  randconfig-1013-20261116    gcc-12
i386                  randconfig-2000-20261115    gcc-14
i386                  randconfig-2000-20261116    gcc-14
i386                  randconfig-2001-20261115    gcc-14
i386                  randconfig-2001-20261116    gcc-14
i386                  randconfig-2002-20261115    gcc-14
i386                  randconfig-2002-20261116    gcc-14
i386                  randconfig-2003-20261115    gcc-14
i386                  randconfig-2003-20261116    gcc-14
i386                  randconfig-2004-20261115    gcc-14
i386                  randconfig-2004-20261116    gcc-14
i386                  randconfig-2005-20261115    gcc-14
i386                  randconfig-2005-20261116    gcc-14
i386                  randconfig-2100-20261115    gcc-14     cocci
i386                  randconfig-2100-20261116    gcc-14     cocci
i386                  randconfig-2101-20261115    gcc-14     cocci
i386                  randconfig-2101-20261116    gcc-14     cocci
i386                  randconfig-2102-20261115    gcc-14     cocci
i386                  randconfig-2102-20261116    gcc-14     cocci
i386                  randconfig-2103-20261115    gcc-14     cocci
i386                  randconfig-2103-20261116    gcc-14     cocci
i386                  randconfig-2104-20261115    gcc-14     cocci
i386                  randconfig-2104-20261116    gcc-14     cocci
i386                  randconfig-2105-20261115    gcc-14     cocci
i386                  randconfig-2105-20261116    gcc-14     cocci
i386                  randconfig-2200-20261115    gcc-14     smatch
i386                  randconfig-2200-20261116    gcc-14     smatch
i386                  randconfig-2300-20261115    clang-22   sparse
i386                  randconfig-2301-20261115    clang-22   sparse
i386                  randconfig-2302-20261115    clang-22   sparse
i386                 randconfig-r2108-20261115    gcc-13.5.0 cocci
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261116    clang-17
loongarch             randconfig-1001-20261116    clang-17
loongarch             randconfig-2000-20261115    gcc-16.2.0
loongarch             randconfig-2000-20261115    gcc-8.5.0
loongarch             randconfig-2000-20261116    gcc-11.5.0
loongarch             randconfig-2001-20261115    clang-20
loongarch             randconfig-2001-20261115    gcc-8.5.0
loongarch             randconfig-2001-20261116    gcc-11.5.0
loongarch             randconfig-2200-20261115    gcc-16.2.0 smatch
loongarch             randconfig-2200-20261116    clang-19   smatch
loongarch            randconfig-r2101-20261116    gcc-8.5.0  cocci
loongarch            randconfig-r2109-20261115    gcc-13.5.0 cocci
loongarch            randconfig-r2111-20261116    gcc-14.4.0 cocci
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                        m5208evb_defconfig    clang-17
m68k                        m5249evb_defconfig    gcc-14
m68k                         m5272c3_defconfig    gcc-14
m68k                        m5282evb_defconfig    gcc-14
m68k                        m5329evb_defconfig    clang-17
m68k                  randconfig-2000-20261115    gcc-15.3.0
m68k                  randconfig-2000-20261115    gcc-8.5.0
m68k                  randconfig-2000-20261116    gcc-10.5.0
m68k                  randconfig-2001-20261115    gcc-8.5.0
m68k                  randconfig-2001-20261116    gcc-10.5.0
m68k                  randconfig-2200-20261116    gcc-14.4.0 smatch
m68k                 randconfig-r2106-20261116    gcc-9.5.0  cocci
m68k                 randconfig-r2301-20261116    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261115    gcc-10.5.0
microblaze            randconfig-2000-20261115    gcc-8.5.0
microblaze            randconfig-2000-20261116    gcc-10.5.0
microblaze            randconfig-2001-20261115    gcc-16.2.0
microblaze            randconfig-2001-20261115    gcc-8.5.0
microblaze            randconfig-2001-20261116    gcc-10.5.0
microblaze            randconfig-2200-20261115    gcc-12.5.0 smatch
microblaze            randconfig-2200-20261116    gcc-11.5.0 smatch
microblaze           randconfig-r2101-20261116    gcc-12.5.0 cocci
microblaze           randconfig-r2110-20261116    gcc-9.5.0  cocci
microblaze           randconfig-r2300-20261116    gcc-8.5.0  sparse
microblaze           randconfig-r2307-20261116    gcc-9.5.0  sparse
microblaze           randconfig-r2311-20261115    gcc-11.5.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           ath79_defconfig    gcc-16.2.0
mips                   cavium_octeon_defconfig    clang-17
mips                 econet_en751221_defconfig    gcc-16.2.0
mips                            ip27_defconfig    gcc-14
mips                            ip28_defconfig    clang-24
mips                            jazz_defconfig    gcc-14
mips                  randconfig-2000-20261115    clang-17
mips                  randconfig-2000-20261115    gcc-10.5.0
mips                  randconfig-2000-20261116    gcc-13.5.0
mips                  randconfig-2001-20261115    clang-20
mips                  randconfig-2001-20261115    gcc-10.5.0
mips                  randconfig-2001-20261116    gcc-13.5.0
mips                  randconfig-2002-20261115    clang-24
mips                  randconfig-2002-20261115    gcc-10.5.0
mips                  randconfig-2002-20261116    gcc-13.5.0
mips                  randconfig-2200-20261115    clang-24   smatch
mips                  randconfig-2200-20261116    gcc-8.5.0  smatch
mips                 randconfig-r2103-20261116    gcc-12.5.0 cocci
mips                 randconfig-r2107-20261116    clang-17   cocci
mips                 randconfig-r2108-20261116    gcc-14.4.0 cocci
mips                 randconfig-r2306-20261115    gcc-11.5.0 sparse
mips                 randconfig-r2309-20261116    gcc-16.2.0 sparse
mips                 randconfig-r2309-20261116    gcc-9.5.0  sparse
mips                            rs90_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261116    clang-17
nios2                 randconfig-1001-20261116    clang-17
nios2                 randconfig-2000-20261115    gcc-8.5.0
nios2                 randconfig-2000-20261116    gcc-11.5.0
nios2                 randconfig-2001-20261115    gcc-8.5.0
nios2                 randconfig-2001-20261116    gcc-11.5.0
nios2                 randconfig-2200-20261115    gcc-11.5.0 smatch
nios2                 randconfig-2200-20261116    gcc-11.5.0 smatch
nios2                randconfig-r2107-20261116    gcc-9.5.0  cocci
nios2                randconfig-r2108-20261116    gcc-9.5.0  cocci
nios2                randconfig-r2110-20261115    gcc-13.5.0 cocci
nios2                randconfig-r2300-20261115    gcc-13.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc          de0_nano_multicore_defconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261115    gcc-10.5.0
openrisc              randconfig-2000-20261116    gcc-13.5.0
openrisc              randconfig-2001-20261115    gcc-10.5.0
openrisc              randconfig-2001-20261115    gcc-12.5.0
openrisc              randconfig-2001-20261116    gcc-13.5.0
openrisc              randconfig-2002-20261115    gcc-10.5.0
openrisc              randconfig-2002-20261116    gcc-13.5.0
openrisc              randconfig-2200-20261115    gcc-12.5.0 smatch
openrisc              randconfig-2200-20261116    gcc-15.3.0 smatch
openrisc             randconfig-r2100-20261115    gcc-8.5.0  cocci
openrisc             randconfig-r2105-20261115    gcc-8.5.0  cocci
openrisc             randconfig-r2105-20261116    gcc-8.5.0  cocci
openrisc             randconfig-r2307-20261115    gcc-11.5.0 sparse
openrisc             randconfig-r2309-20261115    gcc-11.5.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261116    gcc-16.2.0
parisc                randconfig-1001-20261116    gcc-16.2.0
parisc                randconfig-2000-20261115    gcc-8.5.0
parisc                randconfig-2000-20261116    gcc-11.5.0
parisc                randconfig-2001-20261115    gcc-14.4.0
parisc                randconfig-2001-20261115    gcc-8.5.0
parisc                randconfig-2001-20261116    gcc-11.5.0
parisc                randconfig-2200-20261115    gcc-10.5.0 smatch
parisc                randconfig-2200-20261116    gcc-8.5.0  smatch
parisc               randconfig-r2102-20261115    gcc-8.5.0  cocci
parisc               randconfig-r2102-20261116    gcc-12.5.0 cocci
parisc               randconfig-r2107-20261115    gcc-13.5.0 cocci
parisc               randconfig-r2301-20261115    gcc-13.5.0 sparse
parisc               randconfig-r2302-20261115    gcc-13.5.0 sparse
parisc               randconfig-r2305-20261116    gcc-8.5.0  sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                        eiger_defconfig    clang-17
powerpc                       ep88xc_defconfig    clang-24
powerpc                     gamecube_defconfig    clang-24
powerpc                        holly_defconfig    clang-24
powerpc                   iss476-smp_defconfig    gcc-16.2.0
powerpc                  linkstation_defconfig    gcc-16.2.0
powerpc                   mpc885_ads_defconfig    clang-24
powerpc                     mvme5100_defconfig    clang-24
powerpc                      powernv_defconfig    clang-24
powerpc                       ppc44x_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261116    gcc-16.2.0
powerpc               randconfig-1001-20261116    gcc-16.2.0
powerpc               randconfig-2000-20261115    gcc-8.5.0
powerpc               randconfig-2000-20261116    clang-17
powerpc               randconfig-2001-20261115    gcc-8.5.0
powerpc               randconfig-2001-20261116    clang-17
powerpc               randconfig-2002-20261115    gcc-8.5.0
powerpc               randconfig-2002-20261116    clang-17
powerpc               randconfig-2200-20261115    clang-17   smatch
powerpc               randconfig-2200-20261116    clang-22   smatch
powerpc              randconfig-r2103-20261115    gcc-8.5.0  cocci
powerpc              randconfig-r2106-20261116    gcc-14.4.0 cocci
powerpc              randconfig-r2303-20261115    gcc-13.5.0 sparse
powerpc              randconfig-r2310-20261116    gcc-9.5.0  sparse
powerpc                     sam440ep_defconfig    clang-24
powerpc                      stx_gp3_defconfig    clang-24
powerpc                      tqm5200_defconfig    gcc-16.2.0
powerpc                         warp_defconfig    clang-24
powerpc64             randconfig-1000-20261116    gcc-16.2.0
powerpc64             randconfig-1001-20261116    gcc-16.2.0
powerpc64             randconfig-2000-20261115    gcc-8.5.0
powerpc64             randconfig-2000-20261116    clang-17
powerpc64             randconfig-2001-20261115    gcc-8.5.0
powerpc64             randconfig-2001-20261116    clang-17
powerpc64             randconfig-2002-20261115    gcc-8.5.0
powerpc64             randconfig-2002-20261116    clang-17
powerpc64             randconfig-2200-20261115    clang-24   smatch
powerpc64             randconfig-2200-20261116    clang-19   smatch
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261116    clang-17
riscv                 randconfig-1001-20261116    clang-17
riscv                 randconfig-2000-20261115    gcc-8.5.0
riscv                 randconfig-2000-20261116    clang-20
riscv                 randconfig-2001-20261115    gcc-8.5.0
riscv                 randconfig-2001-20261116    clang-20
riscv                 randconfig-2002-20261115    gcc-8.5.0
riscv                 randconfig-2002-20261116    clang-20
riscv                 randconfig-2003-20261115    gcc-8.5.0
riscv                 randconfig-2003-20261116    clang-20
riscv                 randconfig-2004-20261115    gcc-8.5.0
riscv                 randconfig-2004-20261116    clang-20
riscv                 randconfig-2005-20261115    gcc-8.5.0
riscv                 randconfig-2005-20261116    clang-20
riscv                 randconfig-2200-20261115    clang-24   smatch
riscv                 randconfig-2200-20261116    clang-24   smatch
riscv                randconfig-r2100-20261116    gcc-12.5.0 cocci
riscv                randconfig-r2106-20261115    gcc-13.5.0 cocci
riscv                randconfig-r2107-20261115    gcc-13.5.0 cocci
riscv                randconfig-r2111-20261116    gcc-9.5.0  cocci
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261116    clang-17
s390                  randconfig-1001-20261116    clang-17
s390                  randconfig-2000-20261115    gcc-13.5.0
s390                  randconfig-2000-20261116    clang-17
s390                  randconfig-2001-20261115    gcc-13.5.0
s390                  randconfig-2001-20261116    clang-17
s390                  randconfig-2002-20261115    gcc-13.5.0
s390                  randconfig-2002-20261116    clang-17
s390                  randconfig-2003-20261115    gcc-13.5.0
s390                  randconfig-2003-20261116    clang-17
s390                  randconfig-2004-20261115    gcc-13.5.0
s390                  randconfig-2004-20261116    clang-17
s390                  randconfig-2005-20261115    gcc-13.5.0
s390                  randconfig-2005-20261116    clang-17
s390                  randconfig-2200-20261115    clang-24   smatch
s390                  randconfig-2200-20261116    gcc-10.5.0 smatch
s390                 randconfig-r2106-20261116    clang-17   cocci
s390                 randconfig-r2110-20261115    gcc-13.5.0 cocci
s390                 randconfig-r2303-20261116    gcc-8.5.0  sparse
s390                 randconfig-r2306-20261116    gcc-9.5.0  sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                         apsh4ad0a_defconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                              espt_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261116    clang-17
sh                    randconfig-1001-20261116    clang-17
sh                    randconfig-2000-20261115    gcc-12.5.0
sh                    randconfig-2000-20261116    gcc-15.3.0
sh                    randconfig-2001-20261115    gcc-12.5.0
sh                    randconfig-2001-20261116    gcc-15.3.0
sh                    randconfig-2002-20261115    gcc-12.5.0
sh                    randconfig-2002-20261116    gcc-15.3.0
sh                    randconfig-2003-20261115    gcc-12.5.0
sh                    randconfig-2003-20261116    gcc-15.3.0
sh                    randconfig-2004-20261115    gcc-12.5.0
sh                    randconfig-2004-20261116    gcc-15.3.0
sh                    randconfig-2005-20261115    gcc-12.5.0
sh                    randconfig-2005-20261116    gcc-15.3.0
sh                    randconfig-2200-20261115    gcc-16.2.0 smatch
sh                    randconfig-2200-20261116    gcc-15.3.0 smatch
sh                   randconfig-r2309-20261115    gcc-11.5.0 sparse
sh                           sdk7786_defconfig    clang-17
sh                            se7206_defconfig    clang-17
sh                    sh7724_generic_defconfig    gcc-14
sh                               ul2_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261116    gcc-16.2.0
sparc                 randconfig-1001-20261116    gcc-16.2.0
sparc                 randconfig-2000-20261115    clang-24
sparc                 randconfig-2000-20261116    gcc-14
sparc                 randconfig-2001-20261115    clang-24
sparc                 randconfig-2001-20261116    gcc-14
sparc                 randconfig-2200-20261115    gcc-16.2.0 smatch
sparc                 randconfig-2200-20261116    gcc-15.3.0 smatch
sparc                randconfig-r2103-20261116    gcc-8.5.0  cocci
sparc                randconfig-r2107-20261116    gcc-14.4.0 cocci
sparc                randconfig-r2110-20261116    gcc-14.4.0 cocci
sparc                randconfig-r2306-20261115    gcc-11.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261116    gcc-16.2.0
sparc64               randconfig-1001-20261116    gcc-16.2.0
sparc64               randconfig-2000-20261115    clang-24
sparc64               randconfig-2000-20261116    gcc-14
sparc64               randconfig-2001-20261115    clang-24
sparc64               randconfig-2001-20261116    gcc-14
sparc64               randconfig-2200-20261115    gcc-13.5.0 smatch
sparc64               randconfig-2200-20261116    gcc-8.5.0  smatch
sparc64              randconfig-r2104-20261116    gcc-8.5.0  cocci
sparc64              randconfig-r2307-20261116    gcc-16.2.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261116    gcc-16.2.0
um                    randconfig-1001-20261116    gcc-16.2.0
um                    randconfig-2000-20261115    clang-24
um                    randconfig-2000-20261116    gcc-14
um                    randconfig-2001-20261115    clang-24
um                    randconfig-2001-20261116    gcc-14
um                    randconfig-2200-20261115    clang-24   smatch
um                    randconfig-2200-20261116    gcc-14     smatch
um                   randconfig-r2104-20261116    gcc-12.5.0 cocci
um                   randconfig-r2302-20261116    gcc-8.5.0  sparse
um                   randconfig-r2307-20261115    gcc-11.5.0 sparse
um                   randconfig-r2308-20261115    gcc-11.5.0 sparse
um                   randconfig-r2310-20261115    gcc-11.5.0 sparse
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261116    gcc-14
x86_64      buildonly-randconfig-1001-20261116    gcc-14
x86_64      buildonly-randconfig-1002-20261116    gcc-14
x86_64      buildonly-randconfig-1003-20261116    gcc-14
x86_64      buildonly-randconfig-1004-20261116    gcc-14
x86_64      buildonly-randconfig-1005-20261116    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261116    gcc-14
x86_64                randconfig-1001-20261116    gcc-14
x86_64                randconfig-1002-20261116    gcc-14
x86_64                randconfig-1003-20261116    gcc-14
x86_64                randconfig-1004-20261116    gcc-14
x86_64                randconfig-1005-20261116    gcc-14
x86_64                randconfig-1006-20261116    clang-22
x86_64                randconfig-1007-20261116    clang-22
x86_64                randconfig-1008-20261116    clang-22
x86_64                randconfig-1009-20261116    clang-22
x86_64                randconfig-1010-20261116    clang-22
x86_64                randconfig-1011-20261116    clang-22
x86_64                randconfig-1012-20261116    clang-22
x86_64                randconfig-1013-20261116    clang-22
x86_64                randconfig-1014-20261116    clang-22
x86_64                randconfig-1015-20261116    clang-22
x86_64                randconfig-1016-20261116    clang-22
x86_64                randconfig-1017-20261116    clang-22
x86_64                randconfig-2000-20261115    gcc-14
x86_64                randconfig-2000-20261116    gcc-14
x86_64                randconfig-2001-20261115    gcc-14
x86_64                randconfig-2001-20261116    gcc-14
x86_64                randconfig-2002-20261115    gcc-14
x86_64                randconfig-2002-20261116    gcc-14
x86_64                randconfig-2003-20261115    gcc-14
x86_64                randconfig-2003-20261116    gcc-14
x86_64                randconfig-2004-20261115    gcc-14
x86_64                randconfig-2004-20261116    gcc-14
x86_64                randconfig-2005-20261115    gcc-14
x86_64                randconfig-2005-20261116    gcc-14
x86_64                randconfig-2100-20261115    clang-22   cocci
x86_64                randconfig-2100-20261116    gcc-14     cocci
x86_64                randconfig-2101-20261115    clang-22   cocci
x86_64                randconfig-2101-20261116    gcc-14     cocci
x86_64                randconfig-2102-20261115    clang-22   cocci
x86_64                randconfig-2102-20261116    gcc-14     cocci
x86_64                randconfig-2103-20261115    clang-22   cocci
x86_64                randconfig-2103-20261116    gcc-14     cocci
x86_64                randconfig-2104-20261115    clang-22   cocci
x86_64                randconfig-2104-20261116    gcc-14     cocci
x86_64                randconfig-2105-20261115    clang-22   cocci
x86_64                randconfig-2105-20261116    gcc-14     cocci
x86_64                randconfig-2200-20261115    clang-22   smatch
x86_64                randconfig-2200-20261116    clang-22   smatch
x86_64                randconfig-2300-20261115    clang-22   sparse
x86_64                randconfig-2301-20261115    clang-22   sparse
x86_64                randconfig-2302-20261115    clang-22   sparse
x86_64               randconfig-r2101-20261115    gcc-8.5.0  cocci
x86_64               randconfig-r2111-20261115    gcc-13.5.0 cocci
x86_64               randconfig-r2305-20261115    gcc-13.5.0 sparse
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
xtensa                randconfig-1000-20261116    gcc-16.2.0
xtensa                randconfig-1001-20261116    gcc-16.2.0
xtensa                randconfig-2000-20261115    gcc-14.4.0
xtensa                randconfig-2000-20261116    gcc-16.2.0
xtensa                randconfig-2001-20261115    gcc-14.4.0
xtensa                randconfig-2001-20261116    gcc-16.2.0
xtensa                randconfig-2200-20261115    gcc-14.4.0 smatch
xtensa               randconfig-r2100-20261116    gcc-8.5.0  cocci
xtensa               randconfig-r2109-20261116    gcc-14.4.0 cocci
xtensa               randconfig-r2111-20261116    clang-17   cocci
xtensa               randconfig-r2306-20261116    gcc-16.2.0 sparse
xtensa               randconfig-r2308-20261116    gcc-16.2.0 sparse
xtensa               randconfig-r2310-20261116    gcc-16.2.0 sparse
xtensa               randconfig-r2311-20261116    gcc-16.2.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
