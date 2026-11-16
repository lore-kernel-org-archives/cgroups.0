Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819424;
	b=ZIqY1N7Q4HyQVp6kfQdBkgFpjS2x0zZzo2rONaJzG/qEhY4Yd+SchcBGoGyjD209zK93
	 54GHJSghq3vivwnQ3tFsxwctxkcIbJK3S6SVdnRmNOdNdiwEyTRPDhmsGRrv2Ns5xMV8D
	 zhiIYXSQa59neBdvX6fxpoz9xxNav7QLq6oMjWJNLxBE0tiLWnZz3JsMLnxS71iIUazKv
	 ePV0vpox3PjcEwBs+u1VpD2FNcKEsNaclqXhwUGhLkmQCm5rHK9Ntp9Gzkyw9YicfMlqm
	 4PlGeDzDMYp/t5Q9mv9B5ynnafpS+e8IyXj3LjY2pUPTQO9f+7V/DzKb45V/i6M9PTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819424;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=jqqQIn5fN3ExvqQJ702aRkMFV4vd8sFUVArqXPGGWmU=;
	b=fDZHPJEouu1fMn4g2lTrCxljnKsSs/44FfQN13WcW57+/0U3MK3TjNRMEVcNcyHLdrvL
	 SZRVDMdxL/BVK0ORTV0b+WxBBHwOGTBbF43lZV8PUr9iwO/ZMcNWhzCmNvZkWbYLmEDhX
	 TOc3cxB5bIdEl2Jtrtl1yqU6aTgHK/by2X/ZwaJ/eH+S1940YIVpNEzDDclaosS8I4hUR
	 /NnbeC5cZLLlH7XZDKt2VTWMzNABVP4op/8Ze2EQ2LPFOrMjE5EfHGaKlQsV2zhGnnbQi
	 jWhaU8S1FSua2LXQDBXbP3WJQ2kxHN7VL3Jz0sS0sOWsnfL6YFWaXh2ZCC9iISwh6sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GpZnQFXB;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3C5606A31C;
	Mon, 16 Nov 2026 08:57:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A3C5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GpZnQFXB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794819424; x=1826355424;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j+APYi05VYl+fOsRhxa5u2olSjyXjy7TsU2aLGBHaSw=;
  b=GpZnQFXB5YFxrIICpkK79qgC9H6v2smfS0X4Y7AIoHpeKs7bGOzSh7aX
   Y4y62K93Uvd57/0kvBgM6jihBiIAoZZgbDOE3aqXoxNtUU1dJGwY4MDeV
   77mDbQXXP4BQVuf3Zkd0Tb/ytHiafkU0o8ktfWDXy3mvPxUH6gLdt+SJ7
   8z8FttEhlU3jGidPrM4iWrkJjv7lyThf5QNmrtP+PrKQ9LQhFXY7Apys1
   2DAURllVmd5ed6jq6Wghp9QiSqENzQtk3tLF7FdeCl+EJj/7a9Q4LpF6Y
   xin3ts3iKmIgyAty6Ykzanb4qOIvNPrIasNw9HdDvCzvYe1QJEL6qh1nV
   w==;
X-CSE-ConnectionGUID: tgJw/Sk8THGOaKvvXMBJhg==
X-CSE-MsgGUID: CNWk83w8SBKot9mLmCdz7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11967"; a="3557084"
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="3557084"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 00:57:02 -0800
X-CSE-ConnectionGUID: kVie1Q6rS9uiOHhXIECVrw==
X-CSE-MsgGUID: +8zQcbTKQQ6zfgRIkv9O8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="9384413"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 16 Nov 2026 00:56:58 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xSsWF-000000018AK-3xJI;
	Mon, 16 Nov 2026 08:56:55 +0000
Date: Mon, 16 Nov 2026 16:56:35 +0800
From: kernel test robot <lkp@intel.com>
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH-next v4 5/6] cgroup/cpuset: Handle remote partitions
 before local partitions in cpuset_handle_hotplug()
Message-ID: <202611161625.POIP7bQr-lkp@intel.com>
References: <20261116012330.2271010-6-longman@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116012330.2271010-6-longman@redhat.com>

Hi Waiman,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tj-cgroup/for-next]
[also build test WARNING on next-20261113]
[cannot apply to linus/master v7.4-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Waiman-Long/cgroup-cpuset-Fix-incorrect-partition-invalidation-logic-in-cpuset_hotplug_update_tasks/20261115-202304
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
patch link:    https://lore.kernel.org/r/20261116012330.2271010-6-longman%40redhat.com
patch subject: [PATCH-next v4 5/6] cgroup/cpuset: Handle remote partitions before local partitions in cpuset_handle_hotplug()
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20261116/202611161625.POIP7bQr-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project ca14e3d05c4e63d6e8103945c86b958ed2f55d5f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261116/202611161625.POIP7bQr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611161625.POIP7bQr-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: kernel/cgroup/cpuset.c:1895 function parameter 'tmp' not described in 'remote_partition_scan'
>> Warning: kernel/cgroup/cpuset.c:1895 Excess function parameter 'tmpmask' description in 'remote_partition_scan' (did you mean one of: 'tmp')
>> Warning: kernel/cgroup/cpuset.c:1895 function parameter 'tmp' not described in 'remote_partition_scan'
>> Warning: kernel/cgroup/cpuset.c:1895 Excess function parameter 'tmpmask' description in 'remote_partition_scan' (did you mean one of: 'tmp')

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
