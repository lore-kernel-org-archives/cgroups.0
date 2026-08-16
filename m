Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D2F3FFD
	for <cgroups@vger.kernel.org>; Sun, 16 Aug 2026 00:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786838485; cv=none; b=olYMXnNUs9DG8DJ2IStV1OajFutp2at2kKTQoeokwpG1ehAh5eK29LJZyCeErAlJIA20wb5n8oi5VlZxwWciMixlJjjBQoYFI6xeEjo2jmIJaM0VEzsWg9Qp2U7E4Lt8ieCiIxDRerBjlpSLrw/jzpB6sTDOgXrxsjTCMTtY/yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786838485; c=relaxed/simple;
	bh=RCwa3g7FtGVuSA84GtWN7s2+0mvZR/VmrVJl3AV3jRA=;
	h=Date:From:To:Cc:Subject:Message-ID; b=XNkcUzNkODnKEv8qdJ6JytOZJo91vAAsh3iHo+tJvNOaiWAFK0gDKxaz7toexekXRw80kcgGhapZC8I97D+ugSuGhZaV4AyRtMK9lk66OLzxQqji6eqbNi0LIQyRg58tZd62p/A9zsaI3VlDKoxv9GRCCs2Nm1SfDRYt1d3C+e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JX1vUBE8; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JX1vUBE8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786838484; x=1818374484;
  h=date:from:to:cc:subject:message-id;
  bh=RCwa3g7FtGVuSA84GtWN7s2+0mvZR/VmrVJl3AV3jRA=;
  b=JX1vUBE882BzKzClb64sAMPkBCvC85gf36BP6+3Jqlb+eP7mhK8y047y
   nBdbbjyXyB0VYkoSpKS/4dhiYLMh0B8PKBqksBBu4Y5tvnwZy/hCz8SWl
   ybksmOhi6/rTQzQKN7K5i2TKNHW88pv+pQocep44p4zSsLNYKGfO8NUUf
   rWCCqr12LCfgauxIYdN6fSEZdigfpJn7kOz+uBnZUMnrZH7sFpJGL0gE/
   lAEtk1o0ytCKNrVTUA/j4PBPGZoKWIDlPbkfAmWUKUbGr6J2gl6Carejw
   MQslIc2Pg5Kg9D39j+Zv47kHwn1FSK28+reo0cDNymnT9/lzCepEcc25O
   g==;
X-CSE-ConnectionGUID: /0oXqpgOS6afsgOITO6rlw==
X-CSE-MsgGUID: /SSmikyfTP6B+UyZj3iVEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11876"; a="98727498"
X-IronPort-AV: E=Sophos;i="6.25,226,1779174000"; 
   d="scan'208";a="98727498"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2026 17:01:21 -0700
X-CSE-ConnectionGUID: vH8MWr1ORaeI45IFJMFPUg==
X-CSE-MsgGUID: cj4xDwvKTcy8prF36PrO7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,226,1779174000"; 
   d="scan'208";a="302794955"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 15 Aug 2026 17:01:21 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wvOJS-00000000cY5-2dr9;
	Sun, 16 Aug 2026 00:01:18 +0000
Date: Sun, 16 Aug 2026 08:01:09 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-next] BUILD SUCCESS
 dc2aa1e1be68af29e7088d3dcfec9ce57d0f3a1d
Message-ID: <202608160858.JZb17Kcw-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
branch HEAD: dc2aa1e1be68af29e7088d3dcfec9ce57d0f3a1d  Merge branch 'for-7.3' into for-next

elapsed time: 771m

configs tested: 15
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha        allnoconfig    gcc-16.1.0
alpha       allyesconfig    gcc-16.1.0
alpha          defconfig    gcc-16.1.0
arc         allmodconfig    gcc-16.1.0
arc         allyesconfig    gcc-16.1.0
arm        pxa_defconfig    gcc-16.1.0
csky        allmodconfig    gcc-16.1.0
i386        allmodconfig    gcc-14
loongarch      defconfig    clang-24
nios2       allmodconfig    gcc-11.5.0
nios2        allnoconfig    gcc-11.5.0
parisc      allmodconfig    gcc-16.1.0
parisc      allyesconfig    gcc-16.1.0
parisc         defconfig    gcc-16.1.0
sh             defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
