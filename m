Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB9F37204E
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 07:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790492629; cv=none; b=DiJHmLHKdyJO5vkBJXViU+RkGA4Mz/C4DjNPgR1oEvTJh40+g/6vJdLRD/x0po8gNgJmD15cItFChLd/32SVvixcvP8ZDbieRQlKS2vB7ur0XwC79sWQrE0N86esoyG6GUI8DyqLFH0jMDzM6x68YPQgUZh9QHsp2VKhnI6cm0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790492629; c=relaxed/simple;
	bh=78DfslAPIE26YQCnt/w1muCZv3/mSiWViobVAxd9Ilc=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Ixgn8Jw/4CqpRsScssIw4+3jyuAfdpU5/r9ULqBnaFjObTuw2B9ls0XiF8Mxm6PNve0Pshlebp2qwyPOdVN0Ava12271foVev1WcF/5dFm6iQ3bzneP8AF9hEp/I8EYkHZ3BFmR7thX9MON8clXRW7pbnI/i1VpG6mb++cy1AQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UJnAcoLj; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UJnAcoLj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790492626; x=1822028626;
  h=date:from:to:cc:subject:message-id;
  bh=78DfslAPIE26YQCnt/w1muCZv3/mSiWViobVAxd9Ilc=;
  b=UJnAcoLj6Ctw0M3XfIStt8vgGcvkHF8AlvCh4D+rO4wuPT3OaeXfh+4x
   Gl5gFTVn0AHhMtWxl+lA1P6hgPH9OAlSuqi5qjYy0PuUeaWO7J4gGEuBD
   4jE/rzr2vNrJj07XZj7Hf6zgw9U7OZkWDwd52w7pLC6I+DLDtMMBvJosU
   3feLpfbKNZK5R32gK4R+CfUkRPDSP5n/KkE5hy70wDoHc5CYGVE39cZ/C
   TqGAwoVJ8M/kOp6NS5/CGriMCpsb/uKEdal2VTC6oSZigPhfzaf9oo/D+
   iBinZqLC7NGzJfp9xF+Qiq19AA8ESTEBXslKNicA0O6LPVNngpikVLtbi
   Q==;
X-CSE-ConnectionGUID: kCA5htZGSO+FdlIQbf7h7w==
X-CSE-MsgGUID: ZdvvNG3tRP2fHsHAo3KRrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="116749774"
X-IronPort-AV: E=Sophos;i="6.27,125,1787036400"; 
   d="scan'208";a="116749774"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 00:03:46 -0700
X-CSE-ConnectionGUID: Peel10ZpSsiOSCJPp9OiYQ==
X-CSE-MsgGUID: SuBYB4MqQcSS2NKJ90G08Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,125,1787036400"; 
   d="scan'208";a="282808504"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 27 Sep 2026 00:02:35 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAiu8-00000000Mbf-2aU8;
	Sun, 27 Sep 2026 07:02:32 +0000
Date: Sun, 27 Sep 2026 15:02:08 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.3-fixes] BUILD SUCCESS
 1765a153d985c231357145e26798f9408db10e42
Message-ID: <202609271505.gS7ze9QP-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3-fixes
branch HEAD: 1765a153d985c231357145e26798f9408db10e42  cgroup/pids: Restore pids.events notifications in local mode

elapsed time: 3731m

configs tested: 497
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r1302-20260925    clang-18   sparse
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260925    clang-24
arc                   randconfig-1000-20260926    clang-24
arc                   randconfig-1000-20260927    gcc-11.5.0
arc                   randconfig-1001-20260925    clang-24
arc                   randconfig-1001-20260926    clang-24
arc                   randconfig-1001-20260927    gcc-11.5.0
arc                  randconfig-r1301-20260926    gcc-9.5.0  sparse
arc                  randconfig-r1307-20260926    gcc-9.5.0  sparse
arc                  randconfig-r1309-20260925    clang-22   sparse
arc                  randconfig-r2101-20260925    gcc-9.5.0  cocci
arc                  randconfig-r2107-20260925    gcc-16.1.0 cocci
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                        aspeed_g4_defconfig    gcc-16.1.0
arm                          assabet_defconfig    gcc-16.1.0
arm                          axm55xx_defconfig    gcc-16.1.0
arm                                  defconfig    gcc-16.1.0
arm                             hisi_defconfig    clang-24
arm                       jornada720_defconfig    clang-24
arm                         keystone_defconfig    clang-24
arm                         keystone_defconfig    gcc-16.1.0
arm                        omap2plus_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260925    clang-24
arm                   randconfig-1000-20260926    clang-24
arm                   randconfig-1000-20260927    gcc-11.5.0
arm                   randconfig-1001-20260925    clang-24
arm                   randconfig-1001-20260926    clang-24
arm                   randconfig-1001-20260927    gcc-11.5.0
arm                   randconfig-1002-20260925    clang-24
arm                   randconfig-1002-20260926    clang-24
arm                   randconfig-1002-20260927    gcc-11.5.0
arm                   randconfig-1003-20260925    clang-24
arm                   randconfig-1003-20260926    clang-24
arm                   randconfig-1003-20260927    gcc-11.5.0
arm                  randconfig-r1307-20260926    gcc-8.5.0  sparse
arm                           sp7021_defconfig    clang-24
arm                         spear3xx_defconfig    gcc-16.1.0
arm                            u8500_defconfig    gcc-11.5.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260925    clang-24
arm64                 randconfig-1000-20260926    gcc-8.5.0
arm64                 randconfig-1000-20260927    clang-17
arm64                 randconfig-1001-20260925    clang-24
arm64                 randconfig-1001-20260926    gcc-8.5.0
arm64                 randconfig-1001-20260927    clang-17
arm64                 randconfig-1002-20260925    clang-24
arm64                 randconfig-1002-20260926    gcc-8.5.0
arm64                 randconfig-1002-20260927    clang-17
arm64                 randconfig-1003-20260925    clang-24
arm64                 randconfig-1003-20260926    gcc-8.5.0
arm64                 randconfig-1003-20260927    clang-17
arm64                randconfig-r1303-20260925    clang-18   sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260925    clang-24
csky                  randconfig-1000-20260926    gcc-8.5.0
csky                  randconfig-1000-20260927    clang-17
csky                  randconfig-1001-20260925    clang-24
csky                  randconfig-1001-20260926    gcc-8.5.0
csky                  randconfig-1001-20260927    clang-17
csky                 randconfig-r1302-20260926    gcc-13.4.0 sparse
csky                 randconfig-r1302-20260926    gcc-9.5.0  sparse
csky                 randconfig-r1309-20260926    gcc-16.1.0 sparse
csky                 randconfig-r1309-20260926    gcc-9.5.0  sparse
csky                 randconfig-r2200-20260925    gcc-10.5.0 smatch
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20260925    gcc-9.5.0
hexagon               randconfig-1000-20260926    gcc-10.5.0
hexagon               randconfig-1000-20260927    gcc-11.5.0
hexagon               randconfig-1001-20260925    gcc-9.5.0
hexagon               randconfig-1001-20260926    gcc-10.5.0
hexagon               randconfig-1001-20260927    gcc-11.5.0
hexagon              randconfig-r2100-20260925    clang-19   cocci
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20260925    clang-22
i386        buildonly-randconfig-1000-20260926    gcc-14
i386        buildonly-randconfig-1000-20260927    clang-22
i386        buildonly-randconfig-1001-20260925    clang-22
i386        buildonly-randconfig-1001-20260926    gcc-14
i386        buildonly-randconfig-1001-20260927    clang-22
i386        buildonly-randconfig-1002-20260925    clang-22
i386        buildonly-randconfig-1002-20260926    gcc-14
i386        buildonly-randconfig-1002-20260927    clang-22
i386        buildonly-randconfig-1003-20260925    clang-22
i386        buildonly-randconfig-1003-20260926    gcc-14
i386        buildonly-randconfig-1003-20260927    clang-22
i386        buildonly-randconfig-1004-20260925    clang-22
i386        buildonly-randconfig-1004-20260926    gcc-14
i386        buildonly-randconfig-1004-20260927    clang-22
i386        buildonly-randconfig-1005-20260925    clang-22
i386        buildonly-randconfig-1005-20260926    gcc-14
i386        buildonly-randconfig-1005-20260927    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20260925    clang-22
i386                  randconfig-1000-20260926    gcc-14
i386                  randconfig-1000-20260927    clang-22
i386                  randconfig-1001-20260925    clang-22
i386                  randconfig-1001-20260926    gcc-14
i386                  randconfig-1001-20260927    clang-22
i386                  randconfig-1002-20260925    clang-22
i386                  randconfig-1002-20260926    gcc-14
i386                  randconfig-1002-20260927    clang-22
i386                  randconfig-1003-20260925    clang-22
i386                  randconfig-1003-20260926    gcc-14
i386                  randconfig-1003-20260927    clang-22
i386                  randconfig-1004-20260925    clang-22
i386                  randconfig-1004-20260926    gcc-14
i386                  randconfig-1004-20260927    clang-22
i386                  randconfig-1005-20260925    clang-22
i386                  randconfig-1005-20260926    gcc-14
i386                  randconfig-1005-20260927    clang-22
i386                  randconfig-1006-20260925    clang-22
i386                  randconfig-1006-20260926    gcc-14
i386                  randconfig-1006-20260927    clang-22
i386                  randconfig-1007-20260925    gcc-12
i386                  randconfig-1007-20260926    gcc-14
i386                  randconfig-1007-20260927    gcc-14
i386                  randconfig-1008-20260925    gcc-12
i386                  randconfig-1008-20260926    gcc-14
i386                  randconfig-1008-20260927    gcc-14
i386                  randconfig-1009-20260925    gcc-12
i386                  randconfig-1009-20260926    gcc-14
i386                  randconfig-1009-20260927    gcc-14
i386                  randconfig-1010-20260925    gcc-12
i386                  randconfig-1010-20260926    gcc-14
i386                  randconfig-1010-20260927    gcc-14
i386                  randconfig-1011-20260925    gcc-12
i386                  randconfig-1011-20260926    gcc-14
i386                  randconfig-1011-20260927    gcc-14
i386                  randconfig-1012-20260925    gcc-12
i386                  randconfig-1012-20260926    gcc-14
i386                  randconfig-1012-20260927    gcc-14
i386                  randconfig-1013-20260925    gcc-12
i386                  randconfig-1013-20260926    gcc-14
i386                  randconfig-1013-20260927    gcc-14
i386                  randconfig-1300-20260925    clang-22   sparse
i386                  randconfig-1300-20260926    gcc-13     sparse
i386                  randconfig-1301-20260925    clang-22   sparse
i386                  randconfig-1301-20260926    gcc-13     sparse
i386                  randconfig-1302-20260925    clang-22   sparse
i386                  randconfig-1302-20260926    gcc-13     sparse
i386                  randconfig-2100-20260925    clang-22   cocci
i386                  randconfig-2100-20260925    gcc-14     cocci
i386                  randconfig-2101-20260925    clang-22   cocci
i386                  randconfig-2102-20260925    clang-22   cocci
i386                  randconfig-2103-20260925    clang-22   cocci
i386                  randconfig-2200-20260925    gcc-14     smatch
i386                 randconfig-r1300-20260926    gcc-8.5.0  sparse
i386                 randconfig-r1307-20260925    clang-22   sparse
i386                 randconfig-r2101-20260925    clang-22   cocci
i386                 randconfig-r2107-20260925    clang-22   cocci
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260925    gcc-9.5.0
loongarch             randconfig-1000-20260926    gcc-10.5.0
loongarch             randconfig-1000-20260927    gcc-11.5.0
loongarch             randconfig-1001-20260925    gcc-9.5.0
loongarch             randconfig-1001-20260926    gcc-10.5.0
loongarch             randconfig-1001-20260927    gcc-11.5.0
loongarch            randconfig-r1305-20260925    clang-18   sparse
loongarch            randconfig-r1306-20260925    clang-22   sparse
loongarch            randconfig-r1308-20260925    clang-22   sparse
loongarch            randconfig-r1309-20260926    gcc-8.5.0  sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                                 defconfig    clang-24
m68k                       m54418evb_defconfig    gcc-16.1.0
m68k                             q40_defconfig    gcc-16.1.0
m68k                 randconfig-r1304-20260926    gcc-8.5.0  sparse
m68k                 randconfig-r1305-20260926    gcc-9.5.0  sparse
m68k                 randconfig-r1308-20260926    gcc-16.1.0 sparse
m68k                 randconfig-r2201-20260925    gcc-13.4.0 smatch
m68k                            sun3_defconfig    clang-24
m68k                            sun3_defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                           ath25_defconfig    gcc-11.5.0
mips                   cavium_octeon_defconfig    gcc-16.1.0
mips                            ci20_defconfig    clang-24
mips                          cobalt_defconfig    gcc-16.1.0
mips                      cu1000-neo_defconfig    gcc-16.1.0
mips                          db1xxx_defconfig    gcc-16.1.0
mips                 econet_en751221_defconfig    gcc-16.1.0
mips                           eyeq6_defconfig    gcc-16.1.0
mips                      eyeq6lplus_defconfig    gcc-16.1.0
mips                            ip27_defconfig    gcc-16.1.0
mips                      loongson2k_defconfig    gcc-16.1.0
mips                 malta_qemu_32r6_defconfig    gcc-16.1.0
mips                       maltasmvp_defconfig    gcc-16.1.0
nios2                             alldefconfig    gcc-11.5.0
nios2                             alldefconfig    gcc-16.1.0
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20260925    gcc-9.5.0
nios2                 randconfig-1000-20260926    gcc-10.5.0
nios2                 randconfig-1000-20260927    gcc-11.5.0
nios2                 randconfig-1001-20260925    gcc-9.5.0
nios2                 randconfig-1001-20260926    gcc-10.5.0
nios2                 randconfig-1001-20260927    gcc-11.5.0
nios2                randconfig-r1305-20260926    gcc-13.4.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.1.0
openrisc                     or1ksim_defconfig    gcc-16.1.0
openrisc             randconfig-r1308-20260926    gcc-8.5.0  sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260925    clang-24
parisc                randconfig-1000-20260926    clang-24
parisc                randconfig-1000-20260927    clang-24
parisc                randconfig-1001-20260925    clang-24
parisc                randconfig-1001-20260926    clang-24
parisc                randconfig-1001-20260927    clang-24
parisc               randconfig-r1300-20260925    clang-18   sparse
parisc               randconfig-r2200-20260925    gcc-14.3.0 smatch
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                  canyonlands_defconfig    gcc-11.5.0
powerpc                    currituck_defconfig    gcc-16.1.0
powerpc                     ge_imp3a_defconfig    gcc-16.1.0
powerpc                      rainier_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20260925    clang-24
powerpc               randconfig-1000-20260926    clang-24
powerpc               randconfig-1000-20260927    clang-24
powerpc               randconfig-1001-20260925    clang-24
powerpc               randconfig-1001-20260926    clang-24
powerpc               randconfig-1001-20260927    clang-24
powerpc              randconfig-r2105-20260925    gcc-15.2.0 cocci
powerpc                      tqm8540_defconfig    gcc-11.5.0
powerpc64             randconfig-1000-20260925    clang-24
powerpc64             randconfig-1000-20260926    clang-24
powerpc64             randconfig-1000-20260927    clang-24
powerpc64             randconfig-1001-20260925    clang-24
powerpc64             randconfig-1001-20260926    clang-24
powerpc64             randconfig-1001-20260927    clang-24
powerpc64            randconfig-r1306-20260926    gcc-16.1.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20260925    clang-24
riscv                 randconfig-1000-20260926    gcc-9.5.0
riscv                 randconfig-1000-20260927    gcc-16.1.0
riscv                 randconfig-1001-20260925    clang-24
riscv                 randconfig-1001-20260926    gcc-9.5.0
riscv                 randconfig-1001-20260927    gcc-16.1.0
riscv                 randconfig-2000-20260925    gcc-11.5.0
riscv                 randconfig-2001-20260925    gcc-11.5.0
riscv                 randconfig-2001-20260925    gcc-9.5.0
riscv                randconfig-r1301-20260926    gcc-13.4.0 sparse
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20260925    clang-24
s390                  randconfig-1000-20260926    gcc-9.5.0
s390                  randconfig-1000-20260927    gcc-16.1.0
s390                  randconfig-1001-20260925    clang-24
s390                  randconfig-1001-20260926    gcc-9.5.0
s390                  randconfig-1001-20260927    gcc-16.1.0
s390                  randconfig-2000-20260925    gcc-11.5.0
s390                  randconfig-2000-20260925    gcc-8.5.0
s390                  randconfig-2001-20260925    clang-24
s390                  randconfig-2001-20260925    gcc-11.5.0
s390                 randconfig-r1305-20260926    gcc-8.5.0  sparse
s390                 randconfig-r2103-20260925    gcc-9.5.0  cocci
s390                 randconfig-r2106-20260925    gcc-11.5.0 cocci
s390                 randconfig-r2202-20260925    gcc-8.5.0  smatch
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.1.0
sh                          apsh4a3a_defconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                             hp6xx_defconfig    gcc-16.1.0
sh                           kfr2r09_defconfig    gcc-11.5.0
sh                             migor_defconfig    gcc-11.5.0
sh                           polaris_defconfig    gcc-16.1.0
sh                    randconfig-1000-20260925    clang-24
sh                    randconfig-1000-20260926    gcc-9.5.0
sh                    randconfig-1000-20260927    gcc-16.1.0
sh                    randconfig-1001-20260925    clang-24
sh                    randconfig-1001-20260926    gcc-9.5.0
sh                    randconfig-1001-20260927    gcc-16.1.0
sh                    randconfig-2000-20260925    gcc-11.5.0
sh                    randconfig-2000-20260925    gcc-14.3.0
sh                    randconfig-2001-20260925    gcc-11.5.0
sh                    randconfig-2001-20260925    gcc-16.1.0
sh                   randconfig-r1303-20260926    gcc-9.5.0  sparse
sh                   randconfig-r2100-20260925    gcc-9.5.0  cocci
sh                   randconfig-r2104-20260925    gcc-16.1.0 cocci
sh                    rts7751r2dplus_defconfig    gcc-16.1.0
sh                           sdk7780_defconfig    gcc-16.1.0
sh                    secureedge5410_defconfig    gcc-11.5.0
sh                              sh03_defconfig    gcc-16.1.0
sh                             titan_defconfig    gcc-16.1.0
sh                           urquell_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260925    gcc-12
sparc                 randconfig-1000-20260926    gcc-14
sparc                 randconfig-1000-20260927    clang-24
sparc                 randconfig-1001-20260925    gcc-12
sparc                 randconfig-1001-20260926    gcc-14
sparc                 randconfig-1001-20260927    clang-24
sparc                 randconfig-2000-20260925    gcc-14.3.0
sparc                 randconfig-2000-20260925    gcc-16.1.0
sparc                 randconfig-2001-20260925    gcc-16.1.0
sparc                randconfig-r1301-20260925    clang-18   sparse
sparc                randconfig-r1303-20260926    gcc-13.4.0 sparse
sparc                randconfig-r1304-20260925    clang-18   sparse
sparc                randconfig-r1306-20260926    gcc-8.5.0  sparse
sparc                randconfig-r1307-20260926    gcc-16.1.0 sparse
sparc                randconfig-r2105-20260925    gcc-16.1.0 cocci
sparc                randconfig-r2106-20260925    gcc-16.1.0 cocci
sparc                randconfig-r2202-20260925    gcc-15.2.0 smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20260925    gcc-12
sparc64               randconfig-1000-20260926    gcc-14
sparc64               randconfig-1000-20260927    clang-24
sparc64               randconfig-1001-20260925    gcc-12
sparc64               randconfig-1001-20260926    gcc-14
sparc64               randconfig-1001-20260927    clang-24
sparc64               randconfig-2000-20260925    gcc-15.2.0
sparc64               randconfig-2000-20260925    gcc-16.1.0
sparc64               randconfig-2001-20260925    clang-20
sparc64               randconfig-2001-20260925    gcc-16.1.0
sparc64              randconfig-r1300-20260926    gcc-9.5.0  sparse
sparc64              randconfig-r1302-20260926    gcc-8.5.0  sparse
sparc64              randconfig-r1303-20260926    gcc-8.5.0  sparse
sparc64              randconfig-r1304-20260926    gcc-13.4.0 sparse
sparc64              randconfig-r2102-20260925    gcc-15.2.0 cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260925    gcc-12
um                    randconfig-1000-20260926    gcc-14
um                    randconfig-1000-20260927    clang-24
um                    randconfig-1001-20260925    gcc-12
um                    randconfig-1001-20260926    gcc-14
um                    randconfig-1001-20260927    clang-24
um                    randconfig-2000-20260925    gcc-14
um                    randconfig-2000-20260925    gcc-16.1.0
um                    randconfig-2001-20260925    gcc-14
um                    randconfig-2001-20260925    gcc-16.1.0
um                   randconfig-r1304-20260926    gcc-9.5.0  sparse
um                   randconfig-r2104-20260925    gcc-14     cocci
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260925    clang-22
x86_64      buildonly-randconfig-1000-20260926    gcc-14
x86_64      buildonly-randconfig-1000-20260927    gcc-14
x86_64      buildonly-randconfig-1001-20260925    clang-22
x86_64      buildonly-randconfig-1001-20260926    gcc-14
x86_64      buildonly-randconfig-1001-20260927    gcc-14
x86_64      buildonly-randconfig-1002-20260925    clang-22
x86_64      buildonly-randconfig-1002-20260926    gcc-14
x86_64      buildonly-randconfig-1002-20260927    gcc-14
x86_64      buildonly-randconfig-1003-20260925    clang-22
x86_64      buildonly-randconfig-1003-20260926    gcc-14
x86_64      buildonly-randconfig-1003-20260927    gcc-14
x86_64      buildonly-randconfig-1004-20260925    clang-22
x86_64      buildonly-randconfig-1004-20260926    gcc-14
x86_64      buildonly-randconfig-1004-20260927    gcc-14
x86_64      buildonly-randconfig-1005-20260925    clang-22
x86_64      buildonly-randconfig-1005-20260926    gcc-14
x86_64      buildonly-randconfig-1005-20260927    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260925    gcc-14
x86_64                randconfig-1000-20260926    gcc-14
x86_64                randconfig-1000-20260927    clang-22
x86_64                randconfig-1001-20260925    gcc-14
x86_64                randconfig-1001-20260926    gcc-14
x86_64                randconfig-1001-20260927    clang-22
x86_64                randconfig-1002-20260925    gcc-14
x86_64                randconfig-1002-20260926    gcc-14
x86_64                randconfig-1002-20260927    clang-22
x86_64                randconfig-1003-20260925    gcc-14
x86_64                randconfig-1003-20260926    gcc-14
x86_64                randconfig-1003-20260927    clang-22
x86_64                randconfig-1004-20260925    gcc-14
x86_64                randconfig-1004-20260926    gcc-14
x86_64                randconfig-1004-20260927    clang-22
x86_64                randconfig-1005-20260925    gcc-14
x86_64                randconfig-1005-20260926    gcc-14
x86_64                randconfig-1005-20260927    clang-22
x86_64                randconfig-1006-20260925    clang-22
x86_64                randconfig-1006-20260926    gcc-14
x86_64                randconfig-1006-20260927    clang-22
x86_64                randconfig-1007-20260925    clang-22
x86_64                randconfig-1007-20260926    gcc-14
x86_64                randconfig-1007-20260927    clang-22
x86_64                randconfig-1008-20260925    clang-22
x86_64                randconfig-1008-20260926    gcc-14
x86_64                randconfig-1008-20260927    clang-22
x86_64                randconfig-1009-20260925    clang-22
x86_64                randconfig-1009-20260926    gcc-14
x86_64                randconfig-1009-20260927    clang-22
x86_64                randconfig-1010-20260925    clang-22
x86_64                randconfig-1010-20260926    gcc-14
x86_64                randconfig-1010-20260927    clang-22
x86_64                randconfig-1011-20260925    clang-22
x86_64                randconfig-1011-20260926    gcc-14
x86_64                randconfig-1011-20260927    clang-22
x86_64                randconfig-1012-20260925    clang-22
x86_64                randconfig-1012-20260926    clang-22
x86_64                randconfig-1012-20260927    clang-22
x86_64                randconfig-1013-20260925    clang-22
x86_64                randconfig-1013-20260926    clang-22
x86_64                randconfig-1013-20260927    clang-22
x86_64                randconfig-1014-20260925    clang-22
x86_64                randconfig-1014-20260926    clang-22
x86_64                randconfig-1014-20260927    clang-22
x86_64                randconfig-1015-20260925    clang-22
x86_64                randconfig-1015-20260926    clang-22
x86_64                randconfig-1015-20260927    clang-22
x86_64                randconfig-1016-20260925    clang-22
x86_64                randconfig-1016-20260926    clang-22
x86_64                randconfig-1016-20260927    clang-22
x86_64                randconfig-1017-20260925    clang-22
x86_64                randconfig-1017-20260926    clang-22
x86_64                randconfig-1017-20260927    clang-22
x86_64                randconfig-1300-20260925    clang-22   sparse
x86_64                randconfig-1300-20260926    gcc-13     sparse
x86_64                randconfig-1301-20260925    clang-22   sparse
x86_64                randconfig-1301-20260926    gcc-13     sparse
x86_64                randconfig-1302-20260925    clang-22   sparse
x86_64                randconfig-1302-20260926    gcc-13     sparse
x86_64                randconfig-2100-20260925    clang-22   cocci
x86_64                randconfig-2100-20260925    gcc-14     cocci
x86_64                randconfig-2101-20260925    clang-22   cocci
x86_64                randconfig-2102-20260925    clang-22   cocci
x86_64                randconfig-2103-20260925    clang-22   cocci
x86_64                randconfig-2200-20260925    gcc-14     smatch
x86_64               randconfig-r1301-20260926    gcc-8.5.0  sparse
x86_64               randconfig-r1306-20260926    gcc-9.5.0  sparse
x86_64               randconfig-r1308-20260926    gcc-9.5.0  sparse
x86_64               randconfig-r2103-20260925    clang-22   cocci
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
xtensa                randconfig-1000-20260925    gcc-12
xtensa                randconfig-1000-20260926    gcc-14
xtensa                randconfig-1000-20260927    clang-24
xtensa                randconfig-1001-20260925    gcc-12
xtensa                randconfig-1001-20260926    gcc-14
xtensa                randconfig-1001-20260927    clang-24
xtensa                randconfig-2000-20260925    gcc-12.5.0
xtensa                randconfig-2000-20260925    gcc-16.1.0
xtensa                randconfig-2001-20260925    gcc-16.1.0
xtensa                randconfig-2001-20260925    gcc-8.5.0
xtensa               randconfig-r1300-20260926    gcc-13.4.0 sparse
xtensa               randconfig-r2102-20260925    gcc-9.5.0  cocci
xtensa                     xip_kc705_defconfig    clang-24

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
