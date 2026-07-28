Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C745632B104
	for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 04:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785213804; cv=none; b=hKOcex+orkm91gPbCHMdDgTFZawjOyQAYfSQiRkoYMbeNLF8Z7KVtdOO9uID3iiIO9vroJhoAwuAKd0tWzNL7Rq+pDlxZLLFK8laqF6zu8ZNt1zK0kEYZJ27FVOspaDOXtTvwaZD1R8iZg/w6fAxhWgIvliUidGzt571X0vvBwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785213804; c=relaxed/simple;
	bh=LPHJT6svHYE+a6KY8lDpS4mC8UwB0a/G2cw9cuz7sEY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=bxp3E2cFg0X/mKC3YSNl/4+0qCWnf1z+UPzhN1/OknkyT9FAxDWomGQSHY0oXRrK1tOTxfUUBHlIz1G6mnxNffp090D4csqG5MBIesqAf9hkEhMZ25NWJNwmI9NLW0q1Ipz0zSTXBB3YwA7FVsPIUVHn3XFUchT2yVNRGqMpGVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OGjSNssB; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OGjSNssB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785213803; x=1816749803;
  h=date:from:to:cc:subject:message-id;
  bh=LPHJT6svHYE+a6KY8lDpS4mC8UwB0a/G2cw9cuz7sEY=;
  b=OGjSNssBX9uhhBfOLAd7AQSqi1/a3yXCtDJBfK/3EWHaG2vtGuMfIkFH
   DUy+vJfU9TgR8bUWmaZsDbomin9UfQq8QCVvVv1gQJC4mEt3dqxqtlrlE
   dlh+2fjq7qO/FNPDkhsiziJBXs2pqllVBo9YCmEr4ZI75V5Hk5AmCg75J
   ceBgzGHCfTwa29ncgpZit5w6y6MLD690phERr3dauLEIslkdb3/xw2iCn
   wth8KCwHgAptEaJK9v1Nrra1s5Et6wgAA/NyWeAdfEZ1Eo36HLWvVQogK
   9rod+i1+/UZVRPe86SIwC6ddNHDJlxqfYz78zaobC9Z0Fh4S9VZAVn6vN
   g==;
X-CSE-ConnectionGUID: 0PTjatxfTHiZbxRDSQ859A==
X-CSE-MsgGUID: UulVDpT8TTSXP6li4/A2+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="96145469"
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="96145469"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 21:43:22 -0700
X-CSE-ConnectionGUID: H48M+u1lTk6NX4n7UPMjcw==
X-CSE-MsgGUID: +xV6tIoHRyWpSYnHSEbsNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="284138014"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 27 Jul 2026 21:43:21 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1woZew-00000000dz7-3GBG;
	Tue, 28 Jul 2026 04:43:18 +0000
Date: Tue, 28 Jul 2026 12:43:14 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.3] BUILD SUCCESS
 3864c95587a4b487cf231ec0ab8c3d1c11764eb7
Message-ID: <202607281259.937Sv1qK-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3
branch HEAD: 3864c95587a4b487cf231ec0ab8c3d1c11764eb7  docs: cgroup-v2: mark memory.pressure and io.pressure as read-write

elapsed time: 1619m

configs tested: 12
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha    allnoconfig    gcc-16.1.0
alpha   allyesconfig    gcc-16.1.0
arc     allmodconfig    gcc-16.1.0
arc     allyesconfig    gcc-16.1.0
csky    allmodconfig    gcc-16.1.0
i386    allmodconfig    gcc-14
nios2   allmodconfig    gcc-11.5.0
nios2    allnoconfig    gcc-11.5.0
parisc  allmodconfig    gcc-16.1.0
parisc  allyesconfig    gcc-16.1.0
x86_64         kexec    clang-22
x86_64  rhel-9.4-bpf    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
