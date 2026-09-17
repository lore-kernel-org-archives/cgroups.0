Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D574B1CFF
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689363; cv=none; b=ki2Gw2Iwpp3CBLwKwiadBVVqrkEf4yYI5BllkK5hwMPR8ddBPuRgBkkQI5+iGIDkfflRWDxE/AIusEfa18e5hj8V3UwJ+8kZxBQS9ONo0QOW79Gzrg1VqKnuQMLMlnfaIM7zSNNc6A/BFQSn5eOpiH5A7kdU3xelsvPoLahq8NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689363; c=relaxed/simple;
	bh=xeLU+pY5K7YanxqWeC9v8CslKMKwd/7+5oVYxH04TdI=;
	h=Date:From:To:Cc:Subject:Message-ID; b=B+WLheeFXBr6hRkfvLwv2NskmULUN9DiaYIU7PxiMtEGkE1iq0Pg1uSjxk+BEiUZvs6Sbc40L0O9dxIoAuDH6cXHivZ/FIgCDsGAe9OIkSXom/iPtK8O7msRqq5YRGmXzpRBXtrOy9qEP6dqud0tFEip6Kp+o0chWp+VFJiB+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TmKNYtBX; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TmKNYtBX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789689361; x=1821225361;
  h=date:from:to:cc:subject:message-id;
  bh=xeLU+pY5K7YanxqWeC9v8CslKMKwd/7+5oVYxH04TdI=;
  b=TmKNYtBXueEeZZWJDhqd0qRN+Wm5WDRG18eSyMXe4axTIdzjtq3R0lzc
   syn1WFwfm2qDB3kxH3TgYHC+XcjuFz0OBg+nNGryutTBAgPKR2FyGsWZl
   GT4n2ZQzpcDjmSAMSwEwfC0sBbj7At5k8U5TPWc7uR7N088C0ndm4xSEv
   hOMywsmZPsju00P+umkOxRK4F1x4fgF8jevMv59jluTZpSpmA6sGlotAi
   BihX8aZFLdSzkpSA8iZ7L9Q6DPA1DTqAVmj4qM7GrXJk/TreGvKncWpXQ
   wA0vQCnWKz31GmIMQNjurF6hMA0r9+J2wf6nPz6LstMqkCvSgHkwKOTWd
   w==;
X-CSE-ConnectionGUID: GOXr4U/MR/KraP1nlCtudg==
X-CSE-MsgGUID: bgT01HgrQZ2abwAjP3zUEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="100826253"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="100826253"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 16:56:00 -0700
X-CSE-ConnectionGUID: 0smMg0CxSQam4Xf99AmDSQ==
X-CSE-MsgGUID: ZLVUMJ7uQO2GrTBSVZMb6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="2517327"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 17 Sep 2026 16:56:00 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x7LxN-000000008mj-1WMc;
	Thu, 17 Sep 2026 23:55:57 +0000
Date: Fri, 18 Sep 2026 07:55:27 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 02f890299bd9a8de7d4a83aecb4a882ea98fc70e
Message-ID: <202609180723.xdAdKjfd-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 02f890299bd9a8de7d4a83aecb4a882ea98fc70e  Merge branch 'for-7.3-fixes' into for-next

elapsed time: m

configs tested: 305
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             alldefconfig    gcc-16.1.0
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r1304-20260917    clang-21   sparse
alpha                randconfig-r1306-20260917    clang-24   sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260917    gcc-15.2.0
arc                   randconfig-1000-20260918    gcc-16.1.0
arc                   randconfig-1001-20260917    gcc-15.2.0
arc                   randconfig-1001-20260918    gcc-16.1.0
arc                  randconfig-r1302-20260917    gcc-8.5.0  sparse
arc                  randconfig-r1303-20260917    gcc-8.5.0  sparse
arc                  randconfig-r1305-20260917    gcc-8.5.0  sparse
arc                            tb10x_defconfig    gcc-16.1.0
arc                         vdk_hs38_defconfig    clang-24
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                        aspeed_g4_defconfig    gcc-16.1.0
arm                                  defconfig    gcc-16.1.0
arm                           gemini_defconfig    gcc-16.1.0
arm                        imx_v6_v7_defconfig    gcc-16.1.0
arm                         mvebu_v5_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260917    gcc-15.2.0
arm                   randconfig-1000-20260918    gcc-16.1.0
arm                   randconfig-1001-20260917    gcc-15.2.0
arm                   randconfig-1001-20260918    gcc-16.1.0
arm                   randconfig-1002-20260917    gcc-15.2.0
arm                   randconfig-1002-20260918    gcc-16.1.0
arm                   randconfig-1003-20260917    gcc-15.2.0
arm                   randconfig-1003-20260918    gcc-16.1.0
arm                  randconfig-r1308-20260917    gcc-13.4.0 sparse
arm                          s5pv210_defconfig    clang-24
arm64                             alldefconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260917    gcc-11.5.0
arm64                 randconfig-1001-20260917    gcc-11.5.0
arm64                 randconfig-1002-20260917    gcc-11.5.0
arm64                 randconfig-1003-20260917    gcc-11.5.0
arm64                randconfig-r1306-20260917    clang-18   sparse
arm64                randconfig-r2107-20260917    clang-24
arm64                randconfig-r2202-20260917    gcc-16.1.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260917    gcc-11.5.0
csky                  randconfig-1001-20260917    gcc-11.5.0
csky                 randconfig-r1308-20260917    clang-24   sparse
csky                 randconfig-r1309-20260917    clang-18   sparse
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260917    clang-24
hexagon               randconfig-1001-20260917    clang-24
hexagon              randconfig-r1300-20260917    clang-21   sparse
hexagon              randconfig-r1301-20260917    gcc-8.5.0  sparse
hexagon              randconfig-r1304-20260917    gcc-8.5.0  sparse
hexagon              randconfig-r1307-20260917    clang-18   sparse
i386                              alldefconfig    gcc-16.1.0
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20260917    gcc-13
i386        buildonly-randconfig-1000-20260918    gcc-14
i386        buildonly-randconfig-1001-20260917    gcc-13
i386        buildonly-randconfig-1001-20260918    gcc-14
i386        buildonly-randconfig-1002-20260917    gcc-13
i386        buildonly-randconfig-1002-20260918    gcc-14
i386        buildonly-randconfig-1003-20260917    gcc-13
i386        buildonly-randconfig-1003-20260918    gcc-14
i386        buildonly-randconfig-1004-20260917    gcc-13
i386        buildonly-randconfig-1004-20260918    gcc-14
i386        buildonly-randconfig-1005-20260917    gcc-13
i386        buildonly-randconfig-1005-20260918    gcc-14
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260917    clang-22
i386                  randconfig-1000-20260918    gcc-12
i386                  randconfig-1001-20260917    clang-22
i386                  randconfig-1001-20260918    gcc-12
i386                  randconfig-1002-20260917    clang-22
i386                  randconfig-1002-20260918    gcc-12
i386                  randconfig-1003-20260917    clang-22
i386                  randconfig-1003-20260918    gcc-12
i386                  randconfig-1004-20260917    clang-22
i386                  randconfig-1004-20260918    gcc-12
i386                  randconfig-1005-20260917    clang-22
i386                  randconfig-1005-20260918    gcc-12
i386                  randconfig-1006-20260917    clang-22
i386                  randconfig-1006-20260918    gcc-12
i386                  randconfig-1007-20260917    clang-22
i386                  randconfig-1008-20260917    clang-22
i386                  randconfig-1009-20260917    clang-22
i386                  randconfig-1010-20260917    clang-22
i386                  randconfig-1011-20260917    clang-22
i386                  randconfig-1012-20260917    clang-22
i386                  randconfig-1013-20260917    clang-22
i386                  randconfig-1300-20260917    gcc-14     sparse
i386                  randconfig-1301-20260917    gcc-14     sparse
i386                  randconfig-1302-20260917    gcc-14     sparse
i386                  randconfig-2100-20260917    gcc-14
i386                  randconfig-2101-20260917    gcc-14
i386                  randconfig-2102-20260917    gcc-14
i386                  randconfig-2103-20260917    gcc-14
i386                  randconfig-2200-20260917    clang-22
i386                 randconfig-r2104-20260917    clang-24
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260917    clang-24
loongarch             randconfig-1001-20260917    clang-24
loongarch            randconfig-r1307-20260917    clang-24   sparse
loongarch            randconfig-r1309-20260917    gcc-13.4.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                          amcore_defconfig    gcc-16.1.0
m68k                          apollo_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                         m5272c3_defconfig    gcc-16.1.0
m68k                         mvme147_defconfig    gcc-16.1.0
m68k                 randconfig-r2201-20260917    gcc-13.4.0
m68k                           sun3x_defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze           randconfig-r2102-20260917    gcc-10.5.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                   cavium_octeon_defconfig    gcc-16.1.0
mips                            ci20_defconfig    gcc-16.1.0
mips                          cobalt_defconfig    gcc-16.1.0
mips                            gcw0_defconfig    clang-24
mips                            ip27_defconfig    gcc-16.1.0
mips                       malta_kvm_defconfig    gcc-16.1.0
mips                         omega2p_defconfig    clang-24
mips                 randconfig-r1309-20260917    clang-24   sparse
mips                 randconfig-r2103-20260917    gcc-10.5.0
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260917    clang-24
nios2                 randconfig-1001-20260917    clang-24
nios2                randconfig-r2101-20260917    gcc-10.5.0
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc                   or1klitex_defconfig    gcc-16.1.0
openrisc                     or1ksim_defconfig    gcc-16.1.0
openrisc             randconfig-r1300-20260917    gcc-8.5.0  sparse
openrisc             randconfig-r1308-20260917    clang-18   sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260917    gcc-11.5.0
parisc                randconfig-1000-20260918    gcc-8.5.0
parisc                randconfig-1001-20260917    gcc-11.5.0
parisc                randconfig-1001-20260918    gcc-8.5.0
parisc               randconfig-r1302-20260917    clang-21   sparse
parisc               randconfig-r1306-20260917    gcc-8.5.0  sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                        ebony_defconfig    clang-24
powerpc                       ep88xc_defconfig    gcc-16.1.0
powerpc                           g5_defconfig    clang-24
powerpc                      kmeter1_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260917    gcc-11.5.0
powerpc               randconfig-1000-20260918    gcc-8.5.0
powerpc               randconfig-1001-20260917    gcc-11.5.0
powerpc               randconfig-1001-20260918    gcc-8.5.0
powerpc                   storcenter_defconfig    gcc-16.1.0
powerpc                         warp_defconfig    gcc-16.1.0
powerpc64             randconfig-1000-20260917    gcc-11.5.0
powerpc64             randconfig-1000-20260918    gcc-8.5.0
powerpc64             randconfig-1001-20260917    gcc-11.5.0
powerpc64             randconfig-1001-20260918    gcc-8.5.0
powerpc64            randconfig-r1305-20260917    clang-21   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv              nommu_k210_sdcard_defconfig    clang-24
riscv                 randconfig-1000-20260917    clang-17
riscv                 randconfig-1001-20260917    clang-17
riscv                 randconfig-2000-20260917    gcc-14.3.0
riscv                 randconfig-2001-20260917    gcc-14.3.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260917    clang-17
s390                  randconfig-1001-20260917    clang-17
s390                  randconfig-2000-20260917    gcc-14.3.0
s390                  randconfig-2001-20260917    gcc-14.3.0
s390                 randconfig-r2106-20260917    clang-24
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                   defconfig    gcc-14
sh                          ecovec24_defconfig    gcc-16.1.0
sh                    randconfig-1000-20260917    clang-17
sh                    randconfig-1001-20260917    clang-17
sh                    randconfig-2000-20260917    gcc-14.3.0
sh                    randconfig-2001-20260917    gcc-14.3.0
sh                           rsk7269_defconfig    gcc-16.1.0
sh                            se7750_defconfig    clang-24
sh                      sh7710voipgw_defconfig    gcc-16.1.0
sh                             shmin_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260917    clang-17
sparc                 randconfig-1001-20260917    clang-17
sparc                 randconfig-2000-20260917    clang-17
sparc                 randconfig-2001-20260917    clang-17
sparc                randconfig-r1306-20260917    gcc-13.4.0 sparse
sparc                randconfig-r1307-20260917    gcc-13.4.0 sparse
sparc                randconfig-r1308-20260917    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260917    clang-17
sparc64               randconfig-1001-20260917    clang-17
sparc64               randconfig-2000-20260917    clang-17
sparc64               randconfig-2001-20260917    clang-17
sparc64              randconfig-r1301-20260917    clang-21   sparse
sparc64              randconfig-r1303-20260917    clang-21   sparse
sparc64              randconfig-r1309-20260917    gcc-8.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260917    clang-17
um                    randconfig-1001-20260917    clang-17
um                    randconfig-2000-20260917    clang-17
um                    randconfig-2001-20260917    clang-17
um                   randconfig-r2200-20260917    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260917    gcc-14
x86_64      buildonly-randconfig-1001-20260917    gcc-14
x86_64      buildonly-randconfig-1002-20260917    gcc-14
x86_64      buildonly-randconfig-1003-20260917    gcc-14
x86_64      buildonly-randconfig-1004-20260917    gcc-14
x86_64      buildonly-randconfig-1005-20260917    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260917    clang-22
x86_64                randconfig-1001-20260917    clang-22
x86_64                randconfig-1002-20260917    clang-22
x86_64                randconfig-1003-20260917    clang-22
x86_64                randconfig-1004-20260917    clang-22
x86_64                randconfig-1005-20260917    clang-22
x86_64                randconfig-1006-20260917    clang-22
x86_64                randconfig-1007-20260917    clang-22
x86_64                randconfig-1008-20260917    clang-22
x86_64                randconfig-1009-20260917    clang-22
x86_64                randconfig-1010-20260917    clang-22
x86_64                randconfig-1011-20260917    clang-22
x86_64                randconfig-1012-20260917    clang-22
x86_64                randconfig-1013-20260917    clang-22
x86_64                randconfig-1014-20260917    clang-22
x86_64                randconfig-1015-20260917    clang-22
x86_64                randconfig-1016-20260917    clang-22
x86_64                randconfig-1017-20260917    clang-22
x86_64                randconfig-1300-20260917    gcc-14     sparse
x86_64                randconfig-1301-20260917    gcc-14     sparse
x86_64                randconfig-1302-20260917    gcc-14     sparse
x86_64                randconfig-2100-20260917    gcc-13
x86_64                randconfig-2101-20260917    gcc-13
x86_64                randconfig-2102-20260917    gcc-13
x86_64                randconfig-2103-20260917    gcc-13
x86_64                randconfig-2200-20260917    gcc-14
x86_64               randconfig-r2105-20260917    clang-24
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
xtensa                            alldefconfig    gcc-16.1.0
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                   cadence_csp_defconfig    gcc-16.1.0
xtensa                           iss_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20260917    clang-17
xtensa                randconfig-1001-20260917    clang-17
xtensa                randconfig-2000-20260917    clang-17
xtensa                randconfig-2001-20260917    clang-17
xtensa               randconfig-r1307-20260917    gcc-8.5.0  sparse
xtensa               randconfig-r2100-20260917    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
