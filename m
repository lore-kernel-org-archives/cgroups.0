Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422861;
	b=Sjs3um/bLMcCaXHDdKJ6SO989CpD9RV9SoGrxs4IuVPSJBHWLj/RUZ2S/OChRRFbJXfi
	 28Q1ZZJhmGF8oPy2Rma2kMvnLcojMlr5Ku7STST0b6dGBf1lHtHrnaIpCnIt08sfjUAUc
	 JuDUjn3tL2orD0PSbYuwqPUZtZZw7dOCbujJfK0sAhaxRZio3jAOYISGxuxNuONezQ+93
	 THsln20hTCUK+NBWoafSnWbTQi/CTEbLKHg/5r5jzDJZZp6lOQAHF1JL5Xx2PgpVZLPce
	 dchRYqnHmSd9RDBCxMvoOww1fM5aMbEw4HuVGCqM3pbaOavJbjKh9xwJbR6tV/0j19A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422861;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=V52knNZ6VRZXxjUewCwGRW4IHcwZfFifzfh81lf1q+s=;
	b=qFu/2mEbQr2PJ0aUyNieiDmgZjcNzsqqwiL/x9fnL/8VTqM0RDF3ihmmF8qvfLKM79el
	 4FFH/rfGkTUDLVedsIyppEecAgkDsZQAD5Rjno6dlOSP5Jt7/WZAMUF2cP29YMOOqk52R
	 iZ34fkW7ysHlLyGqMUIQseSJ2LTmif6w+7pfzO8c+xcjhwhhEIzi3Cdl0fKLv33wvnqY+
	 WhiWt5ZZ6l4hNtDCqVJRXRGitsA/qeHItEXwlUKNs8gvpJKNHLRiAc5QCSxBk7LwE9q5W
	 U3RzChm5BqFtN1LJoU3Ks5XkAqfg37rVBADiXsM+DlxkLO3LvqBaYU8S+oto2lkoU3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iIMJw5Sa;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACCB606A31C
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 18:47:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ACCB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iIMJw5Sa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794422861; x=1825958861;
  h=date:from:to:cc:subject:message-id;
  bh=v7zw+v92eZvg+91Zu4evgBc7b1P3LPRsuGKu8m1TnE4=;
  b=iIMJw5SaFtXg9D9LS5BavdoejFhQwLtWGMGYrz8b+tmCP09z569owzHj
   P0ik6MTRlvht18Jcef12Rzqdd1X+gczgomXwSVYDXZ6a8WdcBwiwT77Sb
   oGHwHHDv8sKBaRBYelhBi3VwEseDTYvaA9kA3WN7G1rZ+zN5MCyHLtTcQ
   7dpmmu6xH3CjVBW7P7ISBdwgrhfZ0FX4TfdkuK+cAkz+MDfyntgAIeDfQ
   NqxcSi+XnNhpz3ZuYKKjXAX6zPLI5L7jn2q/y5Rn8q03bm9eJsS3YVV9K
   3ASKqFn6OEN56Mvnu+sZ4/COJ1LH5+66l1ba0lzipPFuV5YcQ61jJtlhR
   g==;
X-CSE-ConnectionGUID: Vx3PwXmgRB+Tf1R5Vn2VIA==
X-CSE-MsgGUID: ktDbECVfTnKR2PK03NSFtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3284883"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3284883"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 10:47:41 -0800
X-CSE-ConnectionGUID: Ds+X5LkhTISwnbP3Oju8LA==
X-CSE-MsgGUID: XI3LhypFTdWFGKo7z8653A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8479119"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 10:47:39 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRDM9-00000000zVP-2CtO;
	Wed, 11 Nov 2026 18:47:37 +0000
Date: Thu, 12 Nov 2026 02:46:38 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 54d1e05c5d2291e701d1debb02fb243d4dd9edfe
Message-ID: <20261112024638.BSifbbpJ-lkp@intel.com>
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
branch HEAD: 54d1e05c5d2291e701d1debb02fb243d4dd9edfe  Merge branch 'for-7.4-fixes' into for-next

elapsed time: 1386m

configs tested: 230
configs skipped: 13

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             alldefconfig    gcc-16.2.0
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               alldefconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                       axs103_smp_defconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                             hsdk_defconfig    gcc-16.2.0
arc                         nsimosci_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261111    gcc-15.3.0
arc                   randconfig-1001-20261111    gcc-15.3.0
arc                            tb10x_defconfig    clang-19
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                      am200epdkit_defconfig    gcc-16.2.0
arm                          bcm2835_defconfig    gcc-16.2.0
arm                      davinci_all_defconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                             hisi_defconfig    gcc-16.2.0
arm                          lpc18xx_defconfig    gcc-16.2.0
arm                         mvebu_v5_defconfig    gcc-16.2.0
arm                         mvebu_v7_defconfig    clang-24
arm                        omap2plus_defconfig    gcc-16.2.0
arm                           pxa910_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261111    gcc-15.3.0
arm                   randconfig-1001-20261111    gcc-15.3.0
arm                   randconfig-1002-20261111    gcc-15.3.0
arm                   randconfig-1003-20261111    gcc-15.3.0
arm                         shmobile_defconfig    gcc-16.2.0
arm                          socfpga_defconfig    gcc-16.2.0
arm                         spear3xx_defconfig    gcc-16.2.0
arm                         spear6xx_defconfig    clang-19
arm                            sunxi_defconfig    clang-19
arm                        versatile_defconfig    clang-19
arm                         vexpress_defconfig    clang-19
arm                          vf610m4_defconfig    gcc-16.2.0
arm                     vt8500_v6_v7_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261111    gcc-13.5.0
arm64                 randconfig-1001-20261111    gcc-13.5.0
arm64                 randconfig-1002-20261111    gcc-13.5.0
arm64                 randconfig-1003-20261111    gcc-13.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261111    gcc-13.5.0
csky                  randconfig-1001-20261111    gcc-13.5.0
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261111    clang-17
hexagon               randconfig-1001-20261111    clang-17
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261111    clang-22
i386        buildonly-randconfig-1001-20261111    clang-22
i386        buildonly-randconfig-1002-20261111    clang-22
i386        buildonly-randconfig-1003-20261111    clang-22
i386        buildonly-randconfig-1004-20261111    clang-22
i386        buildonly-randconfig-1005-20261111    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261111    gcc-13
i386                  randconfig-1001-20261111    gcc-13
i386                  randconfig-1002-20261111    gcc-13
i386                  randconfig-1003-20261111    gcc-13
i386                  randconfig-1004-20261111    gcc-13
i386                  randconfig-1005-20261111    gcc-13
i386                  randconfig-1006-20261111    gcc-13
i386                  randconfig-1007-20261111    clang-22
i386                  randconfig-1008-20261111    clang-22
i386                  randconfig-1009-20261111    clang-22
i386                  randconfig-1010-20261111    clang-22
i386                  randconfig-1011-20261111    clang-22
i386                  randconfig-1012-20261111    clang-22
i386                  randconfig-1013-20261111    clang-22
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261111    clang-17
loongarch             randconfig-1001-20261111    clang-17
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                          amcore_defconfig    gcc-16.2.0
m68k                           atari_defconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                           multi_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           ath79_defconfig    gcc-16.2.0
mips                        bmips_be_defconfig    gcc-16.2.0
mips                 econet_en751221_defconfig    gcc-16.2.0
mips                           eyeq6_defconfig    clang-24
mips                             gpr_defconfig    clang-24
mips                        lemote2f_defconfig    clang-24
mips                       malta_kvm_defconfig    clang-19
mips                            mtx1_defconfig    clang-24
mips                         omega2p_defconfig    gcc-16.2.0
mips                         qi_lb60_defconfig    gcc-16.2.0
mips                            xway_defconfig    clang-19
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261111    clang-17
nios2                 randconfig-1001-20261111    clang-17
openrisc                          alldefconfig    gcc-16.2.0
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc                     or1ksim_defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261111    gcc-15.3.0
parisc                randconfig-1001-20261111    gcc-15.3.0
parisc64                          alldefconfig    clang-24
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                        eiger_defconfig    gcc-16.2.0
powerpc                         icon_defconfig    clang-19
powerpc                       pcm030_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261111    gcc-15.3.0
powerpc               randconfig-1001-20261111    gcc-15.3.0
powerpc                      stx_gp3_defconfig    gcc-16.2.0
powerpc                       tqm8xx_defconfig    gcc-16.2.0
powerpc                          wii_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261111    gcc-15.3.0
powerpc64             randconfig-1001-20261111    gcc-15.3.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261111    clang-17
riscv                 randconfig-1001-20261111    clang-17
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261111    clang-17
s390                  randconfig-1001-20261111    clang-17
s390                        zfcpdump_defconfig    gcc-16.2.0
sh                                alldefconfig    gcc-16.2.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                 ecovec24-romimage_defconfig    gcc-16.2.0
sh                  kfr2r09-romimage_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261111    clang-17
sh                    randconfig-1001-20261111    clang-17
sh                            se7780_defconfig    gcc-16.2.0
sh                              sh03_defconfig    gcc-16.2.0
sh                            sh2007_defconfig    gcc-16.2.0
sh                         sh7763rdp_defconfig    gcc-16.2.0
sh                         sh7785lcr_defconfig    gcc-16.2.0
sh                             shmin_defconfig    gcc-16.2.0
sh                               ul2_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261111    gcc-16.2.0
sparc                 randconfig-1001-20261111    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261111    gcc-16.2.0
sparc64               randconfig-1001-20261111    gcc-16.2.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261111    gcc-16.2.0
um                    randconfig-1001-20261111    gcc-16.2.0
um                            x86_64_defconfig    gcc-14
um                            x86_64_defconfig    gcc-16.2.0
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261111    gcc-14
x86_64      buildonly-randconfig-1001-20261111    gcc-14
x86_64      buildonly-randconfig-1002-20261111    gcc-14
x86_64      buildonly-randconfig-1003-20261111    gcc-14
x86_64      buildonly-randconfig-1004-20261111    gcc-14
x86_64      buildonly-randconfig-1005-20261111    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261111    clang-22
x86_64                randconfig-1001-20261111    clang-22
x86_64                randconfig-1002-20261111    clang-22
x86_64                randconfig-1003-20261111    clang-22
x86_64                randconfig-1004-20261111    clang-22
x86_64                randconfig-1005-20261111    clang-22
x86_64                randconfig-1006-20261111    clang-22
x86_64                randconfig-1007-20261111    clang-22
x86_64                randconfig-1008-20261111    clang-22
x86_64                randconfig-1009-20261111    clang-22
x86_64                randconfig-1010-20261111    clang-22
x86_64                randconfig-1011-20261111    clang-22
x86_64                randconfig-1012-20261111    gcc-14
x86_64                randconfig-1013-20261111    gcc-14
x86_64                randconfig-1014-20261111    gcc-14
x86_64                randconfig-1015-20261111    gcc-14
x86_64                randconfig-1016-20261111    gcc-14
x86_64                randconfig-1017-20261111    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261111    gcc-16.2.0
xtensa                randconfig-1001-20261111    gcc-16.2.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
