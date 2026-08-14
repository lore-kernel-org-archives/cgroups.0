Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5223EB104
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 21:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786743792; cv=none; b=J5eX/czx3a8poouluhsiYAfyxP9h+3BK+T+88hADGIQk8H4U0PX7/EH3CSJwfYzDTBjB1mUkxUtINvfK8FozlrTT5cK/FgRSmtp6lXZc2LP78GUNNgroQsxYS4h3qIpzipSK46BeKM5G67X4R2ME1vYDux9YDbf2MGf5mhIGMrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786743792; c=relaxed/simple;
	bh=CrqedTfEiKJ05RbouOSj390zU83KUFoMMxOoYWpSi8c=;
	h=Date:From:To:Cc:Subject:Message-ID; b=azR/QABaTIw8uiKEn/47RAN6W1bvZ+uO0DjR4Zgvs6icp6H1JNXBRULrFW2dGSmjQAXWNrzKTU5fJXkJFtSbzZ/7U/xErFNiSBUnHD9NxMg7/z0d4aWKhUYiPYH9gNjxlbhCSs1N5skLMj18thffimJwY6bjwKZ+WvUpJK8vEBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WS8TRLin; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WS8TRLin"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786743791; x=1818279791;
  h=date:from:to:cc:subject:message-id;
  bh=CrqedTfEiKJ05RbouOSj390zU83KUFoMMxOoYWpSi8c=;
  b=WS8TRLinmPX3ePBndy326Ak4Er1y09DaMvvqUn6QG4VQEH4XzB+cR94O
   Uw/eDcxjr76NaG95u1E0WIwuEB57BUPjMh9ZNR1TbbVx0munsrKpE+UWl
   dI1ecFk9LfXhoyYv44u++OjE67hLlQbW1fevfmCeao6vafOx89HVP+bqQ
   ki4k2AF76quxgWsnWjwIWOsEBPnOypj27w1E8GLgyQT0Ex3VQJ8kDsJjw
   IC52b5UnNX6dfIUI1SSFfE6Eancx1ZzrzCTDDvCx18qxD63a6Z9Wz2FZ5
   +FByQyIOtM7/ixo199dYsw9RwugXksPuoeldmLIHZnqGQrbX4XtIUf1bP
   A==;
X-CSE-ConnectionGUID: z4dJAaTsSzCC4Fa+5KkrVw==
X-CSE-MsgGUID: d9BoOJs9QIeD3egZx50taQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="98839759"
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="98839759"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 14:43:11 -0700
X-CSE-ConnectionGUID: sMSIVQjcTVO9zBeHXIoNfg==
X-CSE-MsgGUID: lknEho4bS2yb1RvuOTIuWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="262995912"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 14 Aug 2026 14:43:09 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuzgB-00000000aHX-0XET;
	Fri, 14 Aug 2026 21:43:07 +0000
Date: Sat, 15 Aug 2026 05:42:15 +0800
From: kernel test robot <lkp@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Subject: [tj-cgroup:for-7.3] BUILD SUCCESS
 ddabc5dbd262f3ca981e679ddae99ed7a9adb279
Message-ID: <202608150504.5gQXsA5i-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-7.3
branch HEAD: ddabc5dbd262f3ca981e679ddae99ed7a9adb279  selftests/cgroup: Preserve CPU hotplug write errors

elapsed time: 792m

configs tested: 15
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha             allnoconfig    gcc-16.1.0
alpha            allyesconfig    gcc-16.1.0
alpha               defconfig    gcc-16.1.0
arc              allmodconfig    gcc-16.1.0
arc              allyesconfig    gcc-16.1.0
csky             allmodconfig    gcc-16.1.0
i386             allmodconfig    gcc-14
loongarch           defconfig    clang-24
nios2            allmodconfig    gcc-11.5.0
nios2             allnoconfig    gcc-11.5.0
parisc           allmodconfig    gcc-16.1.0
parisc           allyesconfig    gcc-16.1.0
parisc              defconfig    gcc-16.1.0
powerpc    amigaone_defconfig    gcc-16.1.0
sh                  defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
