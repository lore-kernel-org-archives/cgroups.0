Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB668360EC9
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 01:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784682498; cv=none; b=dXNL+jz4bEUnNEz4p0HqAmqqAtUArQSmamz5/nqoQ8I+50I5WALkvaSt8qrc3Zg//ZOVpU9dCV6Fn2YF03BOynXhpfEU0S1Ox6ggQw15CD53PeE8y91XYT/f4jVHYyP2grVrlq6miWuEtzUCuJyALbwKueOQj8etHf5mqr8BLuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784682498; c=relaxed/simple;
	bh=KdJSa06l3wNVkqY80xtCbGq5OkmIZeqJ+kN/UEeeBlw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=U0uvHqVANopZPU7/k5Q5/AxXrj/EJE4XtT/6/g8soPPhmBsqFVwkUEWA4UyF9cgoDIkr246N0cGwQcZ7cyrg6VdZnLZgtNtgBGLtPRBhIT6zHATX0wZabw3CpFlqoKBCD6WrtufVr7G3eB0mZKlQChOw8urJYWYBIzLT3+18HsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fwvOhfSb; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fwvOhfSb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784682494; x=1816218494;
  h=date:from:to:cc:subject:message-id;
  bh=KdJSa06l3wNVkqY80xtCbGq5OkmIZeqJ+kN/UEeeBlw=;
  b=fwvOhfSbrziWdrqx84atTu+DLktUMvcao6EpELskDbl/lXovqsqU/jq+
   9IRIxLpKZmOFH6t61V4y/9A8zzzGIEOcmvZVZLREVdlQCJoG8MHZkQ2+3
   3KgJDWHp4vmSp6z+pOTcmiXNTOf4PX1uYB0h+V5qdM2ovJWUx/VzimwCQ
   CPTQ/PZiDnB1QJNxcrA63E0eMmEarufEfJLdZD24YQ4AL7iOuhxSsAyK2
   U9ZoL/NTboAfuWWladLYdf/12y5Hmpk5yrd37W12XFrvskoE6lsAUOGyN
   akgh8j5aPG+v+bmrO5sdK4Yp3ix0HjlJwUfU7t6LhcuFR/mq33AHimtsZ
   A==;
X-CSE-ConnectionGUID: gZHRN04IQ8+FRCXklZ/TlA==
X-CSE-MsgGUID: gCRRJd5vRyeWmdUwKFgUXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="95958406"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="95958406"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 18:08:14 -0700
X-CSE-ConnectionGUID: bRrDCiaGSdia9byrER1qfQ==
X-CSE-MsgGUID: QMvcMJsCRu+yeuXJM+UXkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="262873714"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 21 Jul 2026 18:08:13 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wmLRS-00000000YFw-40S0;
	Wed, 22 Jul 2026 01:08:10 +0000
Date: Wed, 22 Jul 2026 09:07:17 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 0ccf15cbb54ce4413e894fc9ed91abecc4f1017c
Message-ID: <202607220902.chyLHBNc-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 0ccf15cbb54ce4413e894fc9ed91abecc4f1017c  Merge branch 'for-7.3' into for-next

elapsed time: 5897m

configs tested: 43
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                  allnoconfig    gcc-16.1.0
alpha                 allyesconfig    gcc-16.1.0
alpha                    defconfig    gcc-16.1.0
arc                   allmodconfig    gcc-16.1.0
arc                   allyesconfig    gcc-16.1.0
arc        randconfig-001-20260722    clang-24
arc        randconfig-002-20260722    clang-24
arm               ep93xx_defconfig    clang-24
arm        randconfig-001-20260722    clang-24
arm        randconfig-002-20260722    clang-24
arm        randconfig-003-20260722    clang-24
arm        randconfig-004-20260722    clang-24
csky                  allmodconfig    gcc-16.1.0
hexagon    randconfig-001-20260722    gcc-8.5.0
hexagon    randconfig-002-20260722    gcc-8.5.0
i386                  allmodconfig    gcc-14
loongarch                defconfig    clang-24
loongarch  randconfig-001-20260722    gcc-8.5.0
loongarch  randconfig-002-20260722    gcc-8.5.0
nios2                 allmodconfig    gcc-11.5.0
nios2                  allnoconfig    gcc-11.5.0
nios2      randconfig-001-20260722    gcc-8.5.0
nios2      randconfig-002-20260722    gcc-8.5.0
parisc                allmodconfig    gcc-16.1.0
parisc                allyesconfig    gcc-16.1.0
parisc                   defconfig    gcc-16.1.0
riscv      randconfig-001-20260722    gcc-13.4.0
riscv      randconfig-002-20260722    gcc-13.4.0
s390       randconfig-001-20260722    gcc-13.4.0
s390       randconfig-002-20260722    gcc-13.4.0
sh                       defconfig    gcc-16.1.0
sh         randconfig-001-20260722    gcc-13.4.0
sh         randconfig-002-20260722    gcc-13.4.0
sparc      randconfig-001-20260722    gcc-9.5.0
sparc      randconfig-002-20260722    gcc-9.5.0
sparc64    randconfig-001-20260722    gcc-9.5.0
sparc64    randconfig-002-20260722    gcc-9.5.0
um         randconfig-001-20260722    gcc-9.5.0
um         randconfig-002-20260722    gcc-9.5.0
x86_64                       kexec    clang-22
x86_64                rhel-9.4-bpf    gcc-14
xtensa     randconfig-001-20260722    gcc-9.5.0
xtensa     randconfig-002-20260722    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
