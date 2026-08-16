Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8A932B13A
	for <cgroups@vger.kernel.org>; Sun, 16 Aug 2026 01:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786845206; cv=none; b=R5XAh4RB17Sv/UZ4KtFxf7zSkGsR48MxhW39ZWf94hwbnad2QRxNcI4Iv6+YJZoBolL27fABam9GGwCkI1aOamd1NDoDhgTZZ6h946RDI+oPC7nrDJdAgZOLXTfv+zTMzhcLYmy0PfF2BrzHEB0WSk48BhzZ1bn2SN8jO/OdLbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786845206; c=relaxed/simple;
	bh=VnklqxDuKsdnzXswho0PlI/+ZPfZjdspvThTONWKaWs=;
	h=Date:From:To:Cc:Subject:Message-ID; b=hkqmQQB3JwyBOMjaeI23hDcbQW3bJmf1W7Heym0g1KfnjRvDYOR2Zll24kIeQeOxmZT4xmPCxLqD1PV/78Fneq3iZoJb0qZ1ys6nDk0f/ZJZW00TeNrftTrosKU5PGZqdhHyGeH5rK6QnIgVXmvP+hNUyiMfXMlhPBFXc08hnmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jLf2tqst; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jLf2tqst"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786845205; x=1818381205;
  h=date:from:to:cc:subject:message-id;
  bh=VnklqxDuKsdnzXswho0PlI/+ZPfZjdspvThTONWKaWs=;
  b=jLf2tqstfCdMSIPIVgpysRPDPpOVQvlFaD4b6epepH1l46mp3vFYg6jr
   KNn58Ap1G/h48SyqIiCfefnWd4KxCniLHE7N2ivVr8eIGQp7psPOyHf8n
   /kMr4Z70VofoSi34twr/CshTHMNhHcalJAIVOa+bZRScGnDArDnbraHee
   L7TxDfT5WH9J4H7ASWejkvX9Te44BKtOAtShh4OGGNJ79ZfCzsb3JOkCi
   pYMWYzwEC+M7lV1YsJaRHfJC6OvB/UspWjhZuX6QoIagA+m/xwUmLR9Ix
   QwJ6YpC8iJL2dpGoKIjTOKnq+ieaHb/2syp71+C/lZpp3mIUgSTbHNIYb
   Q==;
X-CSE-ConnectionGUID: 98R50iTUSzKOT1orBCDk0g==
X-CSE-MsgGUID: bsB3eIc3SVCIL0XBUmZecA==
X-IronPort-AV: E=McAfee;i="6800,10657,11876"; a="87226690"
X-IronPort-AV: E=Sophos;i="6.25,226,1779174000"; 
   d="scan'208";a="87226690"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2026 18:53:22 -0700
X-CSE-ConnectionGUID: D22hJULGTA+Fe1UAjtcQKQ==
X-CSE-MsgGUID: 0siiNR5SS9a0u/ive7ULyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,226,1779174000"; 
   d="scan'208";a="258362596"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 15 Aug 2026 18:53:20 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wvQ3q-00000000cey-0YPO;
	Sun, 16 Aug 2026 01:53:18 +0000
Date: Sun, 16 Aug 2026 09:53:11 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.3] BUILD SUCCESS
 2d19207f3fc8e08bab3270af2e3835358ab1473a
Message-ID: <202608160958.hzGL8jVE-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3
branch HEAD: 2d19207f3fc8e08bab3270af2e3835358ab1473a  selftests/cgroup: Remove redundant chown in test_cgcore_lesser_ns_open

elapsed time: 884m

configs tested: 15
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha            allnoconfig    gcc-16.1.0
alpha           allyesconfig    gcc-16.1.0
alpha              defconfig    gcc-16.1.0
arc             allmodconfig    gcc-16.1.0
arc             allyesconfig    gcc-16.1.0
csky            allmodconfig    gcc-16.1.0
i386            allmodconfig    gcc-14
loongarch          defconfig    clang-24
mips       bcm47xx_defconfig    clang-24
nios2           allmodconfig    gcc-11.5.0
nios2            allnoconfig    gcc-11.5.0
parisc          allmodconfig    gcc-16.1.0
parisc          allyesconfig    gcc-16.1.0
parisc             defconfig    gcc-16.1.0
sh                 defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
