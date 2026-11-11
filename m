Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422801;
	b=xz6RGv8K98YOKPThvRS2p0JTDGEGRlnJDAgTJOfLf8rR17c2J5ov+jq9KX+wLpyexxhm
	 TWdG1DaLV34g7g6+ur8u8sFeSCLDlA9PNHIgECq+WWUyOZ9bo/03RYx/hIxniKHhGe0rQ
	 7skkJ5MOm8m0HsiYjiANNBvWV96wEdHCaS9yorXb/8/wTOTs9KSNr6BK3wl6XGVA6YtVS
	 0IVcJfTve04CxnuScfi/vAK5COLXx8qcI16yq6xFwqcECQ2h7UK85Q6jrdVLbFmpqLCEY
	 nB7rcimKlWyEq1vls0v2PhhE8a9Q+3xf4+cLa6Zm6b0XpNxH1XJZcHwuJkh55ACh35g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422801;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=x0irH5FpV//u6w+d5wugnB2cP4pReKlOh7DzqRvGtPY=;
	b=ZqWzavg1caJtO/GsfE2JIkZCq5SuIad4Pn+CbPcpALlr9FHSpiSrh0gdCBRahamAi3CV
	 kQJXlLnfTwaPGr8OmSy5wmDEYY7Eoi6X/ZiPtubej4PVYz0KFfTIZvugdQrQraq62zeKs
	 ISIywGOdwsC3bN3Rh+gL5ZDfWNV4LiuOqCHFCZPj8W0gurL2aslJMJgJKtqFecSW6l4Zs
	 Cgg1rvcJ1t3YzKPfaV1S/gcAvcR0/LwmvGvtUSoj/3CZ3CDmDDCHMgEAsHr33Eby+hVqf
	 sexehEAJPleidPVmh4E03+YKMT8rLQYKNdgpReUJQVFocw5W1T87FF0OhJZN4GkcW1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B2qf2Cls;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D395606A31C
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 18:46:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D395606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B2qf2Cls
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794422801; x=1825958801;
  h=date:from:to:cc:subject:message-id;
  bh=ABYt6Vuwz9vg+uc67c9YGmaz5P89QhkiGENSo2vjfZk=;
  b=B2qf2Cls4J4kfuLJsOP/mOZuvEMYomGQjrImpgValFm0ImWn7DB7iM9C
   AlaEckCIJNaw9FIt0qfnX+96+QPYmd3HQsVGXSR2ydP0zH+WK1+MWbXeI
   xjMIvxndJ9GhlGVwRoObeD+MPndnJ2WRcNkBkDYhRu+mhoQGnh9zIuVjH
   v+y13MsBGSLmQABkX3oTHxVtKPM+JPJWS6MhfJu1p0VC1ye2QXrzwrNpI
   GcAdpzqYbfR+6C7Ha7/H3H4/e2H3MDKo6ftOqJUtgLNG6vCZfZF4fioLD
   uRqsREf6BiAN77w62LSsCzsqeXNbvql5YbUbgdXze02/Oz3icViKNOQvn
   A==;
X-CSE-ConnectionGUID: Th5y/VKaSnGHonCqWIPLBA==
X-CSE-MsgGUID: nfiDPNO/QcyBDg+H3QvaPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3284814"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3284814"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 10:46:41 -0800
X-CSE-ConnectionGUID: Eib/QJNpTombfUnhYySFHA==
X-CSE-MsgGUID: PR7Mx6K5ToW0dZedvqXyDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8478956"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 10:46:39 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRDLB-00000000zVH-1uHm;
	Wed, 11 Nov 2026 18:46:37 +0000
Date: Thu, 12 Nov 2026 02:46:13 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.4-fixes] BUILD SUCCESS
 56681bc448a80bb2473026b41c44c133766bc38d
Message-ID: <20261112024613.sIWeFrqX-lkp@intel.com>
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
branch HEAD: 56681bc448a80bb2473026b41c44c133766bc38d  cgroup/cpuset: Correctly set isolated_cpus when switching partition state

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
