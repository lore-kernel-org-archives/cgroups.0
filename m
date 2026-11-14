Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794691095;
	b=MUnCTSV5GFLbBIzam3VQWUWOIy6RV/ouOfvBY7q/6OeuZm5HcGieuKzlzOG9q35g/and
	 16XO2tCtMj6TrYEOgQSxSOgu8vElble3OPkPsMPMZ/tiMjhWO8nBFO3kFzKYzL0KqgZXd
	 EV0vGtV7n5oO9sS+1r9w+NPM3QemUVcGlRsULnKLDNg3nvBZcsp9uxEM/yPp8QZVzP35+
	 Ffxjqh9Rpva59YgW59iorKTHxh67jUs8NyY0j2xwqgZ9+D4EVZY/meybd/5eX2i0dKmF0
	 5xsGyrnfMbRyYmca9F5NHzMaBMLHE1C5o5wcp5ApYtwMfu5TfIw83L3HNEmPmMpNK4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794691095;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=r8ZkbMjQKKtnAuYIO7jwsWwi4Er2Z5+7gpdr290Crug=;
	b=MhvZp+4u17D+Vx4ZNv4Brap1GJbv2cknpq+HLjpTXahq10LnjqRaO7811o1TsADaK127
	 daGy5SkkNhDN6O1idXx8xadTsyAvOI3tRAjSRcNCflkRnl8QDF6MYlDJTG2zERgoNX9nN
	 D3o5mM7ji2N1OEVi56MUQJlombQl54362RLKOdaQ8qlqO6GWTC6uqwGyhQYa6W2B/Ukdu
	 PdeZLVIxEPlKZKVtsxrXQpCG2HoSpeMaCth3PXjRkvzl+TfTNv3/ZssmfyuQVdNI/sfW+
	 njJiSbXdF9IuwbKo6Fsri23bRxRKyg/BPSixj0VrUP4xSbv6eCihcVswpCKjLfwYEsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HTAQYGr1;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D7E606A32D
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 21:18:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6D7E606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HTAQYGr1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794691095; x=1826227095;
  h=date:from:to:cc:subject:message-id;
  bh=mHqbSs1Qp3eL2M6/qSibP1hVETMCii/eAlxwn3nwVU8=;
  b=HTAQYGr1AONh/m8zQpZr0l+6xk8mC9aoKONQ7/pHEua7/1XhoOFbT/8u
   WTRYhlDI7YjJD6yUPEw6VQlBKoo5mOgap58WY3YkaaOOlXvHAOCwfNc6x
   F9eWgwF66T/44t9FucHhBqkfmUJc+cHJJG16vWg1RyxeA8gARR+slznoo
   Qc+hlXYKV4MthLeHuUcP+2Ec0FjA7bnti79mNvy4UyFcL/28ydElOCzRF
   4jpiL8aU+LymHbBDbS3LaTQhlWvDfZnuLDzV7u5/5Hd7Z9fQUZm7NrWU3
   vqlGhc1yT8ErGSzi6cgOM2IdmcL/OWiRtfwuUFSpcK9DJjTM4OdF3MOT4
   A==;
X-CSE-ConnectionGUID: tsNqsJJfRPa/dam8OfWRVg==
X-CSE-MsgGUID: 96RDYNjpT/qROC5aEDcWFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11966"; a="3345718"
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="3345718"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2026 13:18:14 -0800
X-CSE-ConnectionGUID: G9GH/ND3QrywG3+lM/h1DQ==
X-CSE-MsgGUID: WmsAdCcSQg+ddElJ7WHlqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,214,1787036400"; 
   d="scan'208";a="9746315"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 14 Nov 2026 13:18:13 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xSL8T-0000000160O-1iR7;
	Sat, 14 Nov 2026 21:18:09 +0000
Date: Sun, 15 Nov 2026 05:18:01 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.5] BUILD SUCCESS
 988547eec3498f4624297264eda1537469882e33
Message-ID: <20261115051801.ULHN17m6-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.5
branch HEAD: 988547eec3498f4624297264eda1537469882e33  selftests/cgroup: Make the object directory an order-only prerequisite

elapsed time: 791m

configs tested: 620
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261113    gcc-8.5.0
alpha                 randconfig-2000-20261114    gcc-12.5.0
alpha                 randconfig-2001-20261113    gcc-8.5.0
alpha                 randconfig-2001-20261114    gcc-12.5.0
alpha                 randconfig-2200-20261113    gcc-8.5.0  smatch
alpha                 randconfig-2200-20261114    gcc-9.5.0  smatch
alpha                randconfig-r2100-20261114    gcc-15.3.0 cocci
alpha                randconfig-r2101-20261114    clang-17   cocci
alpha                randconfig-r2110-20261113    gcc-14     cocci
alpha                randconfig-r2302-20261114    gcc-16.2.0 sparse
alpha                randconfig-r2303-20261114    gcc-8.5.0  sparse
alpha                randconfig-r2304-20261113    gcc-14.4.0 sparse
alpha                randconfig-r2305-20261114    gcc-8.5.0  sparse
alpha                randconfig-r2306-20261114    gcc-13.5.0 sparse
alpha                randconfig-r2308-20261114    gcc-8.5.0  sparse
alpha                randconfig-r2309-20261114    clang-19   sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261114    clang-24
arc                   randconfig-1000-20261115    gcc-11.5.0
arc                   randconfig-1001-20261114    clang-24
arc                   randconfig-1001-20261115    gcc-11.5.0
arc                   randconfig-2000-20261113    gcc-16.2.0
arc                   randconfig-2000-20261114    gcc-11.5.0
arc                   randconfig-2001-20261113    gcc-16.2.0
arc                   randconfig-2001-20261114    gcc-11.5.0
arc                   randconfig-2002-20261113    gcc-16.2.0
arc                   randconfig-2002-20261114    gcc-11.5.0
arc                   randconfig-2003-20261113    gcc-16.2.0
arc                   randconfig-2003-20261114    gcc-11.5.0
arc                   randconfig-2004-20261113    gcc-16.2.0
arc                   randconfig-2004-20261114    gcc-11.5.0
arc                   randconfig-2005-20261113    gcc-16.2.0
arc                   randconfig-2005-20261114    gcc-11.5.0
arc                   randconfig-2200-20261113    gcc-14.4.0 smatch
arc                   randconfig-2200-20261114    gcc-8.5.0  smatch
arc                  randconfig-r2100-20261114    gcc-12.5.0 cocci
arc                  randconfig-r2101-20261114    gcc-10.5.0 cocci
arc                  randconfig-r2101-20261114    gcc-12.5.0 cocci
arc                  randconfig-r2103-20261114    gcc-15.3.0 cocci
arc                  randconfig-r2107-20261114    clang-24   cocci
arc                  randconfig-r2108-20261114    clang-24   cocci
arc                  randconfig-r2301-20261114    gcc-16.2.0 sparse
arc                  randconfig-r2304-20261113    gcc-8.5.0  sparse
arc                  randconfig-r2305-20261114    gcc-12.5.0 sparse
arc                  randconfig-r2306-20261114    gcc-8.5.0  sparse
arc                  randconfig-r2311-20261114    gcc-15.3.0 sparse
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                             dove_defconfig    clang-24
arm                             mps2_defconfig    clang-24
arm                         multi_v5_defconfig    clang-24
arm                            omap1_defconfig    clang-24
arm                   randconfig-1000-20261114    clang-24
arm                   randconfig-1000-20261115    gcc-11.5.0
arm                   randconfig-1001-20261114    clang-24
arm                   randconfig-1001-20261115    gcc-11.5.0
arm                   randconfig-1002-20261114    clang-24
arm                   randconfig-1002-20261115    gcc-11.5.0
arm                   randconfig-1003-20261114    clang-24
arm                   randconfig-1003-20261115    gcc-11.5.0
arm                   randconfig-2000-20261113    gcc-14.4.0
arm                   randconfig-2000-20261114    gcc-10.5.0
arm                   randconfig-2001-20261113    gcc-14.4.0
arm                   randconfig-2001-20261114    gcc-10.5.0
arm                   randconfig-2002-20261113    gcc-14.4.0
arm                   randconfig-2002-20261114    gcc-10.5.0
arm                   randconfig-2200-20261113    clang-24   smatch
arm                   randconfig-2200-20261114    clang-17   smatch
arm                  randconfig-r2101-20261114    gcc-15.3.0 cocci
arm                  randconfig-r2102-20261114    gcc-14     cocci
arm                  randconfig-r2105-20261114    gcc-8.5.0  cocci
arm                  randconfig-r2106-20261114    clang-24   cocci
arm                  randconfig-r2110-20261114    clang-24   cocci
arm                  randconfig-r2111-20261114    clang-24   cocci
arm                  randconfig-r2300-20261113    gcc-14.4.0 sparse
arm                  randconfig-r2302-20261114    gcc-14.4.0 sparse
arm                  randconfig-r2309-20261114    clang-24   sparse
arm                  randconfig-r2311-20261114    gcc-8.5.0  sparse
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261114    gcc-16.2.0
arm64                 randconfig-1001-20261114    gcc-16.2.0
arm64                 randconfig-1002-20261114    gcc-16.2.0
arm64                 randconfig-1003-20261114    gcc-16.2.0
arm64                 randconfig-2000-20261113    gcc-14.4.0
arm64                 randconfig-2000-20261114    gcc-10.5.0
arm64                 randconfig-2001-20261113    gcc-14.4.0
arm64                 randconfig-2001-20261114    gcc-10.5.0
arm64                 randconfig-2002-20261113    gcc-14.4.0
arm64                 randconfig-2002-20261114    gcc-10.5.0
arm64                 randconfig-2200-20261113    gcc-8.5.0  smatch
arm64                 randconfig-2200-20261114    clang-17   smatch
arm64                randconfig-r2101-20261114    gcc-14     cocci
arm64                randconfig-r2102-20261114    clang-17   cocci
arm64                randconfig-r2102-20261114    gcc-15.3.0 cocci
arm64                randconfig-r2103-20261114    clang-17   cocci
arm64                randconfig-r2104-20261114    clang-17   cocci
arm64                randconfig-r2303-20261113    gcc-14.4.0 sparse
arm64                randconfig-r2308-20261114    gcc-15.3.0 sparse
arm64                randconfig-r2310-20261114    clang-19   sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261114    gcc-16.2.0
csky                  randconfig-1001-20261114    gcc-16.2.0
csky                  randconfig-2000-20261114    gcc-16.2.0
csky                  randconfig-2001-20261114    gcc-16.2.0
csky                  randconfig-2200-20261113    gcc-10.5.0 smatch
csky                  randconfig-2200-20261114    gcc-16.2.0 smatch
csky                 randconfig-r2104-20261113    gcc-9.5.0  cocci
csky                 randconfig-r2107-20261114    clang-24   cocci
csky                 randconfig-r2108-20261114    clang-21   cocci
csky                 randconfig-r2109-20261114    clang-21   cocci
csky                 randconfig-r2302-20261114    gcc-16.2.0 sparse
csky                 randconfig-r2302-20261114    gcc-8.5.0  sparse
csky                 randconfig-r2303-20261113    gcc-8.5.0  sparse
csky                 randconfig-r2306-20261114    clang-22   sparse
csky                 randconfig-r2307-20261114    clang-24   sparse
csky                 randconfig-r2307-20261114    gcc-13.5.0 sparse
csky                 randconfig-r2310-20261114    clang-22   sparse
csky                 randconfig-r2310-20261114    gcc-13.5.0 sparse
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261114    clang-24
hexagon               randconfig-1000-20261115    clang-24
hexagon               randconfig-1001-20261114    clang-24
hexagon               randconfig-1001-20261115    clang-24
hexagon               randconfig-2000-20261114    gcc-16.2.0
hexagon               randconfig-2001-20261114    gcc-16.2.0
hexagon               randconfig-2200-20261114    clang-24   smatch
hexagon              randconfig-r2102-20261114    gcc-8.5.0  cocci
hexagon              randconfig-r2104-20261114    gcc-12.5.0 cocci
hexagon              randconfig-r2104-20261114    gcc-15.3.0 cocci
hexagon              randconfig-r2106-20261113    gcc-14     cocci
hexagon              randconfig-r2107-20261113    gcc-14     cocci
hexagon              randconfig-r2108-20261114    clang-22   cocci
hexagon              randconfig-r2109-20261114    clang-22   cocci
hexagon              randconfig-r2111-20261114    clang-17   cocci
hexagon              randconfig-r2306-20261113    clang-24   sparse
hexagon              randconfig-r2306-20261114    gcc-11.5.0 sparse
hexagon              randconfig-r2311-20261114    clang-19   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261114    gcc-14
i386        buildonly-randconfig-1001-20261114    gcc-14
i386        buildonly-randconfig-1002-20261114    gcc-14
i386        buildonly-randconfig-1003-20261114    gcc-14
i386        buildonly-randconfig-1004-20261114    gcc-14
i386        buildonly-randconfig-1005-20261114    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261114    gcc-12
i386                  randconfig-1000-20261115    clang-22
i386                  randconfig-1001-20261114    gcc-12
i386                  randconfig-1001-20261115    clang-22
i386                  randconfig-1002-20261114    gcc-12
i386                  randconfig-1002-20261115    clang-22
i386                  randconfig-1003-20261114    gcc-12
i386                  randconfig-1003-20261115    clang-22
i386                  randconfig-1004-20261114    gcc-12
i386                  randconfig-1004-20261115    clang-22
i386                  randconfig-1005-20261114    gcc-12
i386                  randconfig-1005-20261115    clang-22
i386                  randconfig-1006-20261114    gcc-12
i386                  randconfig-1006-20261115    clang-22
i386                  randconfig-1007-20261114    clang-22
i386                  randconfig-1008-20261114    clang-22
i386                  randconfig-1009-20261114    clang-22
i386                  randconfig-1010-20261114    clang-22
i386                  randconfig-1011-20261114    clang-22
i386                  randconfig-1012-20261114    clang-22
i386                  randconfig-1013-20261114    clang-22
i386                  randconfig-2000-20261113    gcc-12
i386                  randconfig-2000-20261114    clang-22
i386                  randconfig-2001-20261113    gcc-12
i386                  randconfig-2001-20261114    clang-22
i386                  randconfig-2002-20261113    gcc-12
i386                  randconfig-2002-20261114    clang-22
i386                  randconfig-2003-20261113    gcc-12
i386                  randconfig-2003-20261114    clang-22
i386                  randconfig-2004-20261113    gcc-12
i386                  randconfig-2004-20261114    clang-22
i386                  randconfig-2005-20261113    gcc-12
i386                  randconfig-2005-20261114    clang-22
i386                  randconfig-2100-20261113    gcc-14     cocci
i386                  randconfig-2100-20261114    gcc-14     cocci
i386                  randconfig-2101-20261113    gcc-14     cocci
i386                  randconfig-2101-20261114    gcc-14     cocci
i386                  randconfig-2102-20261113    gcc-14     cocci
i386                  randconfig-2102-20261114    gcc-14     cocci
i386                  randconfig-2103-20261113    gcc-14     cocci
i386                  randconfig-2103-20261114    gcc-14     cocci
i386                  randconfig-2104-20261113    gcc-14     cocci
i386                  randconfig-2104-20261114    gcc-14     cocci
i386                  randconfig-2105-20261113    gcc-14     cocci
i386                  randconfig-2105-20261114    gcc-14     cocci
i386                  randconfig-2200-20261113    clang-22   smatch
i386                  randconfig-2200-20261114    gcc-14     smatch
i386                  randconfig-2300-20261114    clang-22   sparse
i386                  randconfig-2301-20261114    clang-22   sparse
i386                  randconfig-2302-20261114    clang-22   sparse
i386                 randconfig-r2100-20261114    gcc-14     cocci
i386                 randconfig-r2101-20261114    gcc-12.5.0 cocci
i386                 randconfig-r2106-20261114    clang-22   cocci
i386                 randconfig-r2106-20261114    clang-24   cocci
i386                 randconfig-r2108-20261114    gcc-8.5.0  cocci
i386                 randconfig-r2110-20261114    clang-21   cocci
i386                 randconfig-r2111-20261114    clang-24   cocci
i386                 randconfig-r2300-20261114    gcc-8.5.0  sparse
i386                 randconfig-r2306-20261114    clang-22   sparse
i386                 randconfig-r2309-20261114    clang-22   sparse
i386                 randconfig-r2310-20261114    clang-22   sparse
i386                 randconfig-r2311-20261114    clang-22   sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261114    clang-24
loongarch             randconfig-1000-20261115    clang-24
loongarch             randconfig-1001-20261114    clang-24
loongarch             randconfig-1001-20261115    clang-24
loongarch             randconfig-2000-20261113    gcc-8.5.0
loongarch             randconfig-2000-20261114    gcc-11.5.0
loongarch             randconfig-2001-20261113    gcc-8.5.0
loongarch             randconfig-2001-20261114    gcc-11.5.0
loongarch             randconfig-2200-20261114    clang-18   smatch
loongarch            randconfig-r2100-20261114    clang-17   cocci
loongarch            randconfig-r2105-20261114    gcc-14     cocci
loongarch            randconfig-r2109-20261114    clang-17   cocci
loongarch            randconfig-r2300-20261114    gcc-16.2.0 sparse
loongarch            randconfig-r2303-20261114    gcc-8.5.0  sparse
loongarch            randconfig-r2305-20261114    gcc-14.4.0 sparse
loongarch            randconfig-r2309-20261114    clang-22   sparse
loongarch            randconfig-r2309-20261114    gcc-8.5.0  sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                  randconfig-2000-20261113    gcc-8.5.0
m68k                  randconfig-2000-20261114    gcc-12.5.0
m68k                  randconfig-2001-20261113    gcc-8.5.0
m68k                  randconfig-2001-20261114    gcc-12.5.0
m68k                  randconfig-2200-20261114    gcc-16.2.0 smatch
m68k                 randconfig-r2104-20261114    gcc-11.5.0 cocci
m68k                 randconfig-r2107-20261114    clang-17   cocci
m68k                 randconfig-r2110-20261114    clang-17   cocci
m68k                 randconfig-r2301-20261114    gcc-8.5.0  sparse
m68k                 randconfig-r2303-20261114    gcc-14.4.0 sparse
m68k                 randconfig-r2310-20261114    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261113    gcc-8.5.0
microblaze            randconfig-2000-20261114    gcc-12.5.0
microblaze            randconfig-2001-20261113    gcc-8.5.0
microblaze            randconfig-2001-20261114    gcc-12.5.0
microblaze            randconfig-2200-20261113    gcc-8.5.0  smatch
microblaze            randconfig-2200-20261114    gcc-9.5.0  smatch
microblaze           randconfig-r2109-20261114    clang-24   cocci
microblaze           randconfig-r2109-20261114    gcc-8.5.0  cocci
microblaze           randconfig-r2111-20261114    clang-22   cocci
microblaze           randconfig-r2300-20261113    gcc-8.5.0  sparse
microblaze           randconfig-r2302-20261114    gcc-8.5.0  sparse
microblaze           randconfig-r2304-20261114    gcc-8.5.0  sparse
microblaze           randconfig-r2311-20261113    clang-24   sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                            jazz_defconfig    clang-24
mips                         omega2p_defconfig    clang-24
mips                  randconfig-2000-20261113    gcc-16.2.0
mips                  randconfig-2000-20261114    gcc-16.2.0
mips                  randconfig-2001-20261113    gcc-16.2.0
mips                  randconfig-2001-20261114    gcc-16.2.0
mips                  randconfig-2002-20261113    gcc-16.2.0
mips                  randconfig-2002-20261114    gcc-16.2.0
mips                  randconfig-2200-20261113    clang-24   smatch
mips                  randconfig-2200-20261114    gcc-15.3.0 smatch
mips                 randconfig-r2105-20261114    gcc-11.5.0 cocci
mips                 randconfig-r2106-20261114    clang-17   cocci
mips                 randconfig-r2108-20261114    clang-17   cocci
mips                 randconfig-r2301-20261114    gcc-16.2.0 sparse
mips                 randconfig-r2303-20261114    gcc-12.5.0 sparse
mips                 randconfig-r2308-20261114    clang-19   sparse
mips                 randconfig-r2308-20261114    gcc-13.5.0 sparse
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261114    clang-24
nios2                 randconfig-1000-20261115    clang-24
nios2                 randconfig-1001-20261114    clang-24
nios2                 randconfig-1001-20261115    clang-24
nios2                 randconfig-2000-20261113    gcc-8.5.0
nios2                 randconfig-2000-20261114    gcc-11.5.0
nios2                 randconfig-2001-20261113    gcc-8.5.0
nios2                 randconfig-2001-20261114    gcc-11.5.0
nios2                 randconfig-2200-20261113    gcc-10.5.0 smatch
nios2                 randconfig-2200-20261114    gcc-11.5.0 smatch
nios2                randconfig-r2103-20261114    gcc-12.5.0 cocci
nios2                randconfig-r2105-20261114    gcc-12.5.0 cocci
nios2                randconfig-r2300-20261114    gcc-16.2.0 sparse
nios2                randconfig-r2304-20261114    gcc-12.5.0 sparse
nios2                randconfig-r2306-20261114    clang-24   sparse
nios2                randconfig-r2307-20261113    clang-24   sparse
nios2                randconfig-r2307-20261114    clang-22   sparse
nios2                randconfig-r2310-20261114    gcc-11.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc              randconfig-2000-20261113    gcc-16.2.0
openrisc              randconfig-2000-20261114    gcc-16.2.0
openrisc              randconfig-2001-20261113    gcc-16.2.0
openrisc              randconfig-2001-20261114    gcc-16.2.0
openrisc              randconfig-2002-20261113    gcc-16.2.0
openrisc              randconfig-2002-20261114    gcc-16.2.0
openrisc              randconfig-2200-20261113    gcc-14.4.0 smatch
openrisc              randconfig-2200-20261114    gcc-16.2.0 smatch
openrisc             randconfig-r2101-20261114    gcc-15.3.0 cocci
openrisc             randconfig-r2102-20261114    gcc-12.5.0 cocci
openrisc             randconfig-r2103-20261113    gcc-9.5.0  cocci
openrisc             randconfig-r2104-20261114    gcc-10.5.0 cocci
openrisc             randconfig-r2106-20261114    clang-21   cocci
openrisc             randconfig-r2110-20261114    clang-24   cocci
openrisc             randconfig-r2301-20261113    gcc-14.4.0 sparse
openrisc             randconfig-r2302-20261113    gcc-8.5.0  sparse
openrisc             randconfig-r2305-20261113    gcc-8.5.0  sparse
openrisc             randconfig-r2307-20261114    clang-19   sparse
openrisc             randconfig-r2307-20261114    gcc-11.5.0 sparse
openrisc             randconfig-r2307-20261114    gcc-15.3.0 sparse
openrisc             randconfig-r2309-20261114    gcc-13.5.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                randconfig-2000-20261113    gcc-8.5.0
parisc                randconfig-2000-20261114    gcc-11.5.0
parisc                randconfig-2001-20261113    gcc-8.5.0
parisc                randconfig-2001-20261114    gcc-11.5.0
parisc                randconfig-2200-20261113    gcc-16.2.0 smatch
parisc                randconfig-2200-20261114    gcc-8.5.0  smatch
parisc               randconfig-r2100-20261114    gcc-10.5.0 cocci
parisc               randconfig-r2102-20261113    gcc-9.5.0  cocci
parisc               randconfig-r2103-20261114    gcc-15.3.0 cocci
parisc               randconfig-r2103-20261114    gcc-8.5.0  cocci
parisc               randconfig-r2108-20261113    gcc-14     cocci
parisc               randconfig-r2304-20261114    gcc-16.2.0 sparse
parisc               randconfig-r2305-20261114    gcc-8.5.0  sparse
parisc               randconfig-r2310-20261114    clang-24   sparse
parisc64                             defconfig    clang-24
powerpc                     adder875_defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                    motionpro_defconfig    clang-24
powerpc                      mpc5200_defconfig    clang-24
powerpc                  mpc837x_rdb_defconfig    clang-24
powerpc               randconfig-2000-20261114    gcc-8.5.0
powerpc               randconfig-2001-20261114    gcc-8.5.0
powerpc               randconfig-2002-20261114    gcc-8.5.0
powerpc               randconfig-2200-20261113    clang-24   smatch
powerpc               randconfig-2200-20261114    clang-24   smatch
powerpc              randconfig-r2100-20261114    gcc-15.3.0 cocci
powerpc              randconfig-r2100-20261114    gcc-8.5.0  cocci
powerpc              randconfig-r2101-20261114    gcc-11.5.0 cocci
powerpc              randconfig-r2105-20261114    gcc-10.5.0 cocci
powerpc              randconfig-r2107-20261114    clang-22   cocci
powerpc              randconfig-r2111-20261113    gcc-14     cocci
powerpc              randconfig-r2111-20261114    clang-24   cocci
powerpc              randconfig-r2301-20261114    gcc-8.5.0  sparse
powerpc              randconfig-r2306-20261114    gcc-15.3.0 sparse
powerpc              randconfig-r2308-20261114    clang-22   sparse
powerpc              randconfig-r2308-20261114    gcc-11.5.0 sparse
powerpc64             randconfig-2000-20261114    gcc-8.5.0
powerpc64             randconfig-2001-20261114    gcc-8.5.0
powerpc64             randconfig-2002-20261114    gcc-8.5.0
powerpc64             randconfig-2200-20261114    clang-17   smatch
powerpc64            randconfig-r2102-20261114    gcc-12.5.0 cocci
powerpc64            randconfig-r2103-20261114    gcc-10.5.0 cocci
powerpc64            randconfig-r2103-20261114    gcc-11.5.0 cocci
powerpc64            randconfig-r2104-20261114    gcc-12.5.0 cocci
powerpc64            randconfig-r2106-20261114    clang-24   cocci
powerpc64            randconfig-r2108-20261114    clang-24   cocci
powerpc64            randconfig-r2109-20261114    clang-24   cocci
powerpc64            randconfig-r2110-20261114    clang-24   cocci
powerpc64            randconfig-r2300-20261114    gcc-12.5.0 sparse
powerpc64            randconfig-r2300-20261114    gcc-14.4.0 sparse
powerpc64            randconfig-r2301-20261113    gcc-8.5.0  sparse
powerpc64            randconfig-r2305-20261113    gcc-14.4.0 sparse
powerpc64            randconfig-r2305-20261114    gcc-16.2.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                 randconfig-1000-20261114    gcc-15.3.0
riscv                 randconfig-1001-20261114    gcc-15.3.0
riscv                 randconfig-2000-20261113    gcc-11.5.0
riscv                 randconfig-2000-20261114    gcc-12.5.0
riscv                 randconfig-2001-20261113    gcc-11.5.0
riscv                 randconfig-2001-20261114    gcc-12.5.0
riscv                 randconfig-2002-20261113    gcc-11.5.0
riscv                 randconfig-2002-20261114    gcc-12.5.0
riscv                 randconfig-2003-20261113    gcc-11.5.0
riscv                 randconfig-2003-20261114    gcc-12.5.0
riscv                 randconfig-2004-20261113    gcc-11.5.0
riscv                 randconfig-2004-20261114    gcc-12.5.0
riscv                 randconfig-2005-20261113    gcc-11.5.0
riscv                 randconfig-2005-20261114    gcc-12.5.0
riscv                 randconfig-2200-20261113    clang-17   smatch
riscv                 randconfig-2200-20261114    clang-24   smatch
riscv                randconfig-r2309-20261114    gcc-11.5.0 sparse
riscv                randconfig-r2310-20261113    clang-24   sparse
riscv                randconfig-r2311-20261114    clang-22   sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                  randconfig-1000-20261114    gcc-15.3.0
s390                  randconfig-1001-20261114    gcc-15.3.0
s390                  randconfig-2000-20261114    clang-24
s390                  randconfig-2001-20261114    clang-24
s390                  randconfig-2002-20261114    clang-24
s390                  randconfig-2003-20261114    clang-24
s390                  randconfig-2004-20261114    clang-24
s390                  randconfig-2005-20261114    clang-24
s390                  randconfig-2200-20261113    clang-24   smatch
s390                  randconfig-2200-20261114    clang-24   smatch
s390                 randconfig-r2100-20261113    gcc-9.5.0  cocci
s390                 randconfig-r2103-20261114    gcc-12.5.0 cocci
s390                 randconfig-r2107-20261114    gcc-8.5.0  cocci
s390                 randconfig-r2111-20261114    clang-21   cocci
s390                 randconfig-r2306-20261114    clang-19   sparse
s390                 randconfig-r2311-20261114    gcc-11.5.0 sparse
s390                 randconfig-r2311-20261114    gcc-8.5.0  sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                          ecovec24_defconfig    clang-24
sh                              espt_defconfig    clang-24
sh                    randconfig-1000-20261114    gcc-15.3.0
sh                    randconfig-1001-20261114    gcc-15.3.0
sh                    randconfig-2000-20261114    gcc-13.5.0
sh                    randconfig-2001-20261114    gcc-13.5.0
sh                    randconfig-2002-20261114    gcc-13.5.0
sh                    randconfig-2003-20261114    gcc-13.5.0
sh                    randconfig-2004-20261114    gcc-13.5.0
sh                    randconfig-2005-20261114    gcc-13.5.0
sh                    randconfig-2200-20261113    gcc-14.4.0 smatch
sh                    randconfig-2200-20261114    gcc-9.5.0  smatch
sh                   randconfig-r2102-20261114    gcc-11.5.0 cocci
sh                   randconfig-r2102-20261114    gcc-15.3.0 cocci
sh                   randconfig-r2104-20261114    gcc-15.3.0 cocci
sh                   randconfig-r2105-20261114    gcc-12.5.0 cocci
sh                   randconfig-r2110-20261114    clang-22   cocci
sh                   randconfig-r2302-20261114    gcc-12.5.0 sparse
sh                   randconfig-r2303-20261114    gcc-16.2.0 sparse
sh                   randconfig-r2304-20261114    gcc-14.4.0 sparse
sh                   randconfig-r2307-20261114    gcc-8.5.0  sparse
sh                            se7206_defconfig    clang-24
sh                            se7750_defconfig    clang-24
sh                            se7751_defconfig    clang-24
sh                    sh7770_generic_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                 randconfig-1000-20261114    gcc-12.5.0
sparc                 randconfig-1001-20261114    gcc-12.5.0
sparc                 randconfig-2000-20261113    clang-24
sparc                 randconfig-2000-20261114    clang-21
sparc                 randconfig-2001-20261113    clang-24
sparc                 randconfig-2001-20261114    clang-21
sparc                 randconfig-2200-20261113    gcc-14.4.0 smatch
sparc                 randconfig-2200-20261114    gcc-8.5.0  smatch
sparc                randconfig-r2100-20261114    gcc-11.5.0 cocci
sparc                randconfig-r2105-20261114    gcc-15.3.0 cocci
sparc                randconfig-r2108-20261114    clang-24   cocci
sparc                randconfig-r2303-20261114    gcc-16.2.0 sparse
sparc                randconfig-r2304-20261114    gcc-16.2.0 sparse
sparc                randconfig-r2304-20261114    gcc-8.5.0  sparse
sparc                randconfig-r2307-20261114    gcc-8.5.0  sparse
sparc                randconfig-r2309-20261114    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261114    gcc-12.5.0
sparc64               randconfig-1001-20261114    gcc-12.5.0
sparc64               randconfig-2000-20261113    clang-24
sparc64               randconfig-2000-20261114    clang-21
sparc64               randconfig-2001-20261113    clang-24
sparc64               randconfig-2001-20261114    clang-21
sparc64               randconfig-2200-20261113    gcc-15.3.0 smatch
sparc64               randconfig-2200-20261114    gcc-16.2.0 smatch
sparc64              randconfig-r2102-20261114    gcc-10.5.0 cocci
sparc64              randconfig-r2104-20261114    gcc-14     cocci
sparc64              randconfig-r2308-20261113    clang-24   sparse
sparc64              randconfig-r2308-20261114    clang-22   sparse
sparc64              randconfig-r2311-20261114    gcc-13.5.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261114    gcc-12.5.0
um                    randconfig-1001-20261114    gcc-12.5.0
um                    randconfig-2000-20261113    clang-24
um                    randconfig-2000-20261114    clang-21
um                    randconfig-2001-20261113    clang-24
um                    randconfig-2001-20261114    clang-21
um                    randconfig-2200-20261113    clang-24   smatch
um                    randconfig-2200-20261114    gcc-14     smatch
um                   randconfig-r2101-20261113    gcc-9.5.0  cocci
um                   randconfig-r2104-20261114    gcc-8.5.0  cocci
um                   randconfig-r2107-20261114    clang-21   cocci
um                   randconfig-r2110-20261114    gcc-8.5.0  cocci
um                   randconfig-r2111-20261114    gcc-8.5.0  cocci
um                   randconfig-r2301-20261114    gcc-14.4.0 sparse
um                   randconfig-r2308-20261114    clang-24   sparse
um                   randconfig-r2309-20261113    clang-24   sparse
um                   randconfig-r2309-20261114    gcc-15.3.0 sparse
um                   randconfig-r2311-20261114    clang-24   sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261114    gcc-14
x86_64      buildonly-randconfig-1001-20261114    gcc-14
x86_64      buildonly-randconfig-1002-20261114    gcc-14
x86_64      buildonly-randconfig-1003-20261114    gcc-14
x86_64      buildonly-randconfig-1004-20261114    gcc-14
x86_64      buildonly-randconfig-1005-20261114    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261114    gcc-14
x86_64                randconfig-1000-20261115    gcc-14
x86_64                randconfig-1001-20261114    gcc-14
x86_64                randconfig-1001-20261115    gcc-14
x86_64                randconfig-1002-20261114    gcc-14
x86_64                randconfig-1002-20261115    gcc-14
x86_64                randconfig-1003-20261114    gcc-14
x86_64                randconfig-1003-20261115    gcc-14
x86_64                randconfig-1004-20261114    gcc-14
x86_64                randconfig-1004-20261115    gcc-14
x86_64                randconfig-1005-20261114    gcc-14
x86_64                randconfig-1005-20261115    gcc-14
x86_64                randconfig-1006-20261114    gcc-14
x86_64                randconfig-1007-20261114    gcc-14
x86_64                randconfig-1008-20261114    gcc-14
x86_64                randconfig-1009-20261114    gcc-14
x86_64                randconfig-1010-20261114    gcc-14
x86_64                randconfig-1011-20261114    gcc-14
x86_64                randconfig-1012-20261114    clang-22
x86_64                randconfig-1012-20261115    gcc-14
x86_64                randconfig-1013-20261114    clang-22
x86_64                randconfig-1013-20261115    gcc-14
x86_64                randconfig-1014-20261114    clang-22
x86_64                randconfig-1014-20261115    gcc-14
x86_64                randconfig-1015-20261114    clang-22
x86_64                randconfig-1015-20261115    gcc-14
x86_64                randconfig-1016-20261114    clang-22
x86_64                randconfig-1016-20261115    gcc-14
x86_64                randconfig-1017-20261114    clang-22
x86_64                randconfig-1017-20261115    gcc-14
x86_64                randconfig-2000-20261114    gcc-14
x86_64                randconfig-2001-20261114    gcc-14
x86_64                randconfig-2002-20261114    gcc-14
x86_64                randconfig-2003-20261114    gcc-14
x86_64                randconfig-2004-20261114    gcc-14
x86_64                randconfig-2005-20261114    gcc-14
x86_64                randconfig-2100-20261113    clang-22   cocci
x86_64                randconfig-2100-20261114    gcc-14     cocci
x86_64                randconfig-2101-20261113    clang-22   cocci
x86_64                randconfig-2101-20261114    gcc-14     cocci
x86_64                randconfig-2102-20261113    clang-22   cocci
x86_64                randconfig-2102-20261114    gcc-14     cocci
x86_64                randconfig-2103-20261113    clang-22   cocci
x86_64                randconfig-2103-20261114    gcc-14     cocci
x86_64                randconfig-2104-20261113    clang-22   cocci
x86_64                randconfig-2104-20261114    gcc-14     cocci
x86_64                randconfig-2105-20261113    clang-22   cocci
x86_64                randconfig-2105-20261114    gcc-14     cocci
x86_64                randconfig-2200-20261113    clang-22   smatch
x86_64                randconfig-2200-20261114    gcc-14     smatch
x86_64                randconfig-2300-20261114    clang-22   sparse
x86_64                randconfig-2301-20261114    clang-22   sparse
x86_64                randconfig-2302-20261114    clang-22   sparse
x86_64               randconfig-r2101-20261114    gcc-8.5.0  cocci
x86_64               randconfig-r2103-20261114    gcc-14     cocci
x86_64               randconfig-r2105-20261113    gcc-9.5.0  cocci
x86_64               randconfig-r2105-20261114    clang-17   cocci
x86_64               randconfig-r2105-20261114    gcc-15.3.0 cocci
x86_64               randconfig-r2109-20261113    gcc-14     cocci
x86_64               randconfig-r2300-20261114    gcc-8.5.0  sparse
x86_64               randconfig-r2306-20261114    gcc-8.5.0  sparse
x86_64               randconfig-r2307-20261114    clang-22   sparse
x86_64               randconfig-r2310-20261114    gcc-15.3.0 sparse
x86_64               randconfig-r2310-20261114    gcc-8.5.0  sparse
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
xtensa                randconfig-1000-20261114    gcc-12.5.0
xtensa                randconfig-1001-20261114    gcc-12.5.0
xtensa                randconfig-2000-20261114    gcc-16.2.0
xtensa                randconfig-2001-20261114    gcc-16.2.0
xtensa                randconfig-2200-20261113    gcc-12.5.0 smatch
xtensa               randconfig-r2106-20261114    gcc-8.5.0  cocci
xtensa               randconfig-r2107-20261114    clang-24   cocci
xtensa               randconfig-r2109-20261114    clang-24   cocci
xtensa               randconfig-r2301-20261114    gcc-12.5.0 sparse
xtensa               randconfig-r2302-20261113    gcc-14.4.0 sparse
xtensa               randconfig-r2305-20261114    gcc-16.2.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
