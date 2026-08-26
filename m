Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCAE40855
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 00:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787703156; cv=none; b=At/NDzAdsHxODr9SSbuGGoiVMIAAQnL2tjkaypENex2MuEfFmxnj6eYow3iQLigznOGB5jJTNxM7Zu9HnzFZW25D4+OgPCoQQjFPEmBgXpzEsYMUj8FGd6kdLSaeFgNYlILeU08Q72lMzRblgvoNkcCBXBZIcaGW9TK/hIk0drg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787703156; c=relaxed/simple;
	bh=NyoxoQ9VUsk6/t9e/TzAfCij6u/2Raf2Y0KDLkEIMg4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=S5xwfMY9P07BG5VhWg6FM1n1zPodRsZm9KbYAOG8pzZW3bpaa4xtV+Jk/WGvzec91m8Vqx5m3GjE5tFZEUtLjkNc1ZnmPFjLHFZVmWR6pFg+6KhjkEqbNErmcHYmPIhUpeRxvQFoTBaKaiUoejMAYKxycMzNhhhXj/DRU9u9znQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DoPeGyOq; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DoPeGyOq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787703154; x=1819239154;
  h=date:from:to:cc:subject:message-id;
  bh=NyoxoQ9VUsk6/t9e/TzAfCij6u/2Raf2Y0KDLkEIMg4=;
  b=DoPeGyOq9vRGckdu51oq1muBHAsq02XzvWQbHZXzKDAiRQs8ZpjcbFBn
   WR1d5dtu77iQjbkIEXTHPlt+5/k4tXtHKnsEFXIXAvBAp6iO4+ifI6VPU
   djkrdIcsmmOUaSalDLdYjl/j14nGYBqrwqc87+V//KC8Ni87yZyMHWjRF
   KGao4kMBOCC1FoN7QKMGqibyTwz8tXpFY3J/fSqoEcOhdMC+gTMPZURa0
   48KsXdVaB1aA6HzAMtEWPT4ozjhxAx2UkD8arn9IhCXVfuzx81uZ+Tnqg
   5WZre8hWljZRswrHDZUDYrA9cwt45XBT6kS627Td9gA4nfuRmawV4kLpu
   w==;
X-CSE-ConnectionGUID: 3fo+0CphSvqyNqfYgjiaIA==
X-CSE-MsgGUID: hStKHY+aT+25KK0RdH7ZRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88056083"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88056083"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 17:12:34 -0700
X-CSE-ConnectionGUID: XOv25HFqQ0OSUrA/RdVINw==
X-CSE-MsgGUID: FCc01xU1SKqGZVVh648NBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="264170447"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 25 Aug 2026 17:12:33 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wz1Fm-000000006bh-3RFp;
	Wed, 26 Aug 2026 00:12:30 +0000
Date: Wed, 26 Aug 2026 08:12:02 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.3-fixes] BUILD SUCCESS
 87d347a8c8545a9234d1dd215023064413284c34
Message-ID: <202608260850.gm1mBwbw-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3-fixes
branch HEAD: 87d347a8c8545a9234d1dd215023064413284c34  selftests/cgroup: Add test for preserving boot-isolated CPUs

elapsed time: 792m

configs tested: 15
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
alpha           defconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arm        hisi_defconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
i386         allmodconfig    gcc-14
loongarch       defconfig    clang-24
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    gcc-11.5.0
parisc       allmodconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
parisc          defconfig    gcc-16.1.0
sh              defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
