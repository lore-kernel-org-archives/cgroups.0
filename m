Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6899A40963A;
	Wed,  2 Sep 2026 09:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788339950; cv=none; b=udkFekmA24mnWQgS7OIlcZgWtTlC1APbKIzL3R+t/vW0yC24mbsz40C0/bqSxk44D94JTDtQvUL0KSI02ORY6nHJsGFl12s7roV9fq4cizk3qiLfbzv0DRz3AbEPUEjcjpFNYYpaIh0TjmpHcV+zSar2a9Fmwu0pfEjhgZAmQ/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788339950; c=relaxed/simple;
	bh=IRgqaVQfpdVTtZGwros05SmBtzySmvzQCq1CQDlR57E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hH3qjRhGuH1RkRMxxaXxgjbMb4u45KiFDgKU1nNMVAyLXX1silnks8KaiREx+C07y5+Rs9MB/HzMa6bN6EJPaELQNKuLENWEb22EVvTAY5EacN71Yf4WKnvQFqOHZNaSJ4XcrZ7ETgkhxhoYpYhPN97ZlIGD4z0R9ShnMCJoCkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DatNZzOu; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DatNZzOu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788339948; x=1819875948;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IRgqaVQfpdVTtZGwros05SmBtzySmvzQCq1CQDlR57E=;
  b=DatNZzOuFtJgtOo0VFxpAWPwHi1zuVfguuzv4Q4R3OwbSoMiR0R3Z7zB
   7TJhmr2r8TG5KDtRcPvA7eJIYUHrqX1wcL6YryEhSPPcgcGPXY+Iri7/f
   zmZdwUo5vQKKZmj/h+KCVLWYpFKaK1dl9qo+73nXZnLdZMzJaG6agRWX2
   lscRgbJ7hjlXklz0RH5ow596PYUdueWns5m1YPmpo8G2nUTNL+D36tzB8
   nYBDX56Ow52NFT9sGKJDIvG8NKEPJi/qJhncvNutR7ymTvqmhABFFzcdX
   0jlZ1cUauxkz7elEFGKK7x7CvDSnBHvqQvKaRT2Q/xzw8CJRvtIn4Ds5o
   A==;
X-CSE-ConnectionGUID: KbFcUGvXQI60JcHMmPpsEg==
X-CSE-MsgGUID: pQyWWYNDSzK35ZiV2KbLxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="99388687"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="99388687"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 02:05:47 -0700
X-CSE-ConnectionGUID: pufbLu4QTLihMWheY9csZw==
X-CSE-MsgGUID: XFbqF93VS86Z+2MRRRXhoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="266757516"
Received: from igk-lkp-server01.igk.intel.com (HELO 05545efcfdd3) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 02 Sep 2026 02:05:44 -0700
Received: from kbuild by 05545efcfdd3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x1guc-0000000009r-1040;
	Wed, 02 Sep 2026 09:05:42 +0000
Date: Wed, 2 Sep 2026 11:05:15 +0200
From: kernel test robot <lkp@intel.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>, cgroups@vger.kernel.org,
	longman@redhat.com, ridong.chen@linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH v2 6/6] selftests/cgroup: Add CPU release tests for
 type-change validation failures
Message-ID: <202609021151.JjV7JZjv-lkp@intel.com>
References: <20260828095643.13395-7-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828095643.13395-7-guopeng.zhang@linux.dev>

Hi Guopeng,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 87d347a8c8545a9234d1dd215023064413284c34]

url:    https://github.com/intel-lab-lkp/linux/commits/Guopeng-Zhang/cgroup-cpuset-Respect-child-CPU-ownership-in-type-changes/20260828-175638
base:   87d347a8c8545a9234d1dd215023064413284c34
patch link:    https://lore.kernel.org/r/20260828095643.13395-7-guopeng.zhang%40linux.dev
patch subject: [PATCH v2 6/6] selftests/cgroup: Add CPU release tests for type-change validation failures
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260902/202609021151.JjV7JZjv-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260902/202609021151.JjV7JZjv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609021151.JjV7JZjv-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: kernel/cgroup/cpuset.c:2431 function parameter 'owned_cpus' not described in 'validate_partition'
>> Warning: kernel/cgroup/cpuset.c:2431 function parameter 'owned_cpus' not described in 'validate_partition'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
