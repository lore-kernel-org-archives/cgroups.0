Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F6428690
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 00:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787703158; cv=none; b=C2IACVfy0FFHSu/9frRbV9/XNBGtuThe1HmOiCIGDF/lyo/I77xiKm7X5x2iYaSuw+sjG9ruZeqzfIQlpqk50e6m93BB6qyPOiZO6gCttqRXYKLsH3ZUaNO3WdqgNo8tYXjP3/iggqvKvk+CFKXtl58ro7qLhUys0TlOCRRTOvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787703158; c=relaxed/simple;
	bh=lrjCiDc8C1Y5fBzGLbdpCg/F4xMuZABgBOZOBiFJmd0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=u6YcvufZjxpKDlWiZsWLA3cp9LxOX88tdkLDGIvYotO1xk+ZuIKevPhcYB116c5XL2ZmdCLipU0h/qEhhFdTbplTiJ7+Qb0NIj/ErWsArrlUBl7L27L5+2q2tHLxvSKDhSdgezxH8b26kzbT4xE5sdI2vcW1RjTEOpWT7savsvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a8T7YbD3; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a8T7YbD3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787703156; x=1819239156;
  h=date:from:to:cc:subject:message-id;
  bh=lrjCiDc8C1Y5fBzGLbdpCg/F4xMuZABgBOZOBiFJmd0=;
  b=a8T7YbD3CzX9wjus0LbpG+sVXsOoAwITrwcf24pDz4hO4FpccqOEWocy
   Xr1IsBldfd9N1erqyxs2co8DdKncJ18GBBo0rCgg7rR6irytyRrT6zsxd
   GwUDcV8rHZl9vfstxC6XwxNz1x2vQatcTWWmjFktGItqgeYIsTT5FJxHm
   QyCcwQ+bSXGuvdRvUi1bV7bTSYY0sudyALRDMaZx8yQH6+KRtuDakfRmJ
   N3EhibyVpmFSohQdGkRip9uY7l+caVEejgsB7haGRqwqsLKYPrZkv7ogj
   zJqLzMkU7lVGlCU86GDXF6gQdx5FLplCiLmVg9b6chzPlAroUjSP7EgzX
   w==;
X-CSE-ConnectionGUID: YrRcx16+Qe6w/l4xgkcgIg==
X-CSE-MsgGUID: P56EWdBbRUmJW5V0gcrK3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88056084"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88056084"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 17:12:34 -0700
X-CSE-ConnectionGUID: l1w3hKcyRw+z6adKY2CbeA==
X-CSE-MsgGUID: jO88S0BZSTmtGou+YeGEdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="264170449"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 25 Aug 2026 17:12:33 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wz1Fm-000000006bj-3pMG;
	Wed, 26 Aug 2026 00:12:30 +0000
Date: Wed, 26 Aug 2026 08:12:18 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 b57d03eb82b796a6451f834f3a9091908743060b
Message-ID: <202608260807.TyBRQuI3-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: b57d03eb82b796a6451f834f3a9091908743060b  Merge branch 'for-7.3-fixes' into for-next

elapsed time: 792m

configs tested: 15
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha           allnoconfig    gcc-16.1.0
alpha          allyesconfig    gcc-16.1.0
alpha             defconfig    gcc-16.1.0
arc            allmodconfig    gcc-16.1.0
arc            allyesconfig    gcc-16.1.0
csky           allmodconfig    gcc-16.1.0
i386           allmodconfig    gcc-14
loongarch         defconfig    clang-24
nios2          allmodconfig    gcc-11.5.0
nios2           allnoconfig    gcc-11.5.0
parisc         allmodconfig    gcc-16.1.0
parisc         allyesconfig    gcc-16.1.0
parisc            defconfig    gcc-16.1.0
sh                defconfig    gcc-16.1.0
sh         se7780_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
