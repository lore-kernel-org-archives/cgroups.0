Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BC93ED5BB
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 21:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786743856; cv=none; b=dG/RrZLYiMMooBAnaYsEkTyloQBl1ShiVT5TTy6mL8ULe6OrhuhFCy3Y3ttvk4LbTnbdhZ0QpXcKux+rEEj49s1uMIcDpMTc2Y64TZbgtMyBIWwL//wIR9mgoh4USYDpxSwb7NMPhxgdnPy6dpvnXI607nh7STCsRQlR/mlkSgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786743856; c=relaxed/simple;
	bh=/RATCvhIQ7i28lzvRCsLJYOjB7eWzC0K6ZPeMxpNtOs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=YOEENtxwlxe4EboHxZqpQ+4GJt1kahUs/KdX1oYnuY/Q8FIy1+VLPBXRptHorxXyEAx9sUfUYs+kekRx+rFCEDFwiEhxY9ptIbJ+ryo47wHrkJa6eRtqDP6A8f9p4SOSQekpqhKNv8YJOJkrIK91rXmoCfNRXYD9mJ+T1YX8gmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H/nnSf5S; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H/nnSf5S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786743854; x=1818279854;
  h=date:from:to:cc:subject:message-id;
  bh=/RATCvhIQ7i28lzvRCsLJYOjB7eWzC0K6ZPeMxpNtOs=;
  b=H/nnSf5Sce5l12R2ac43Sw7D8khzvjMOxanenivO2YoV0cFVFdMMnQ+0
   HAgZEdovMfs0Ab00PHSPJpbHherNOXlmq1Mz/VIoXcDA9UERrNDAMg6G/
   YVybTSWhPtboHqtX7y8DOj9gam9i0F/Xqrp63JUP7huwJTy+DirXma5Mc
   mI7VQgCif16PXZrpDP1RG6uKLg0Tp2urRfkBNyeqSn5du6MMNXKC0Moel
   OeAODxmrCw8gNuni8F5sxjDRf/+NQA9kkPu1iPH8esjSPBaglrMDH5+XU
   YMYPZfmdwZZ80rHzzl5czRQWj7zwM21A/GH5Vn4k6Ctt4UHLUFMUlLtvL
   A==;
X-CSE-ConnectionGUID: A8gUgXFaTiGn2NKp0m0MEw==
X-CSE-MsgGUID: zA8N2CnaStury/QzXRH90g==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="86442521"
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="86442521"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 14:44:11 -0700
X-CSE-ConnectionGUID: uwO3Bsv3RQigcmHPoOP1kQ==
X-CSE-MsgGUID: 6wapiseXSPWTCdV9oNH0ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="268185007"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 14 Aug 2026 14:44:10 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuzh9-00000000aHq-1Y6k;
	Fri, 14 Aug 2026 21:44:07 +0000
Date: Sat, 15 Aug 2026 05:43:33 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 52fe6ceddae5e6d32467304a3340448f680d2911
Message-ID: <202608150522.CX9R6z5N-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: 52fe6ceddae5e6d32467304a3340448f680d2911  Merge branch 'for-7.3' into for-next

elapsed time: 793m

configs tested: 15
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                allnoconfig    gcc-16.1.0
alpha               allyesconfig    gcc-16.1.0
alpha                  defconfig    gcc-16.1.0
arc                 allmodconfig    gcc-16.1.0
arc                 allyesconfig    gcc-16.1.0
arc        haps_hs_smp_defconfig    gcc-16.1.0
csky                allmodconfig    gcc-16.1.0
i386                allmodconfig    gcc-14
loongarch              defconfig    clang-24
nios2               allmodconfig    gcc-11.5.0
nios2                allnoconfig    gcc-11.5.0
parisc              allmodconfig    gcc-16.1.0
parisc              allyesconfig    gcc-16.1.0
parisc                 defconfig    gcc-16.1.0
sh                     defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
