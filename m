Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601965;
	b=dJrFxtyg1o4licsdqnoGSr1LAfvcBI1nXn0upqxTP+8wHtnP9dpvR1gA41Huo2E9ykDd
	 ufFlilAWSwEOjUPWzZhXXoaI1KMxJdPaKzGFTeP1tBvKdlXVdL+wY2idyEYZ6rOz/kChn
	 DNXZx0f76LgQBhYuOg3oQVB0wfB8T5t8g8lsEIHHc93Wr/DC4UeO9NR/UDpXY/bXAKwsZ
	 72sBnvy1GDyg7crB8LgAGruvFI/ADOH0eUM+4NeR7FfmmIMth5F227y1vyeDmoPaU7GQg
	 0ZiyBVeKO+scmLgcwxjBGRrMBxNuvUpvdOGmk3wRLozv8QuUCJS9w9q8gIplmDrUgIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601965;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=jQyVKf+xKGyYu2gTWeUfHIN4PWX5+OTKCqL+rPAXxBM=;
	b=y4WTvI4qDWwO0esrJrqqm/u0TWKHyJob9gZ2B2HZTGrmMdgFglAAaqmXdoVp9QTTzGgY
	 QEsIbrRkNyqcfhbEEX24BM5BCz5CVsMhchpJ8Dpa546pfPHXCLPRK1WayDFUw+vLv3po+
	 +pCpdTaE2O3W52xjh9LrFopbpzS+VncA9qRz/u52ig+4BrVCtCjb+xNWI78/HQuDWz3nb
	 8QIiGh7k4pN4QSI70iQxoYKXUb2mRbxBrPvyJsFZFXRWbBSa1rT2dGiwg7Gq/H3HdX51G
	 peNlbsXtq2pcl+LOiY1OjRQV69VohLAreTgzZ2upB0iILYFMVntf2mjrofLqqtanojQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IzHl1KxN;
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F3A60A260E;
	Mon,  2 Nov 2026 06:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74F3A60A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IzHl1KxN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793601963; x=1825137963;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ve5h5MZP7tPfgfDQBI9dQre1wJZbL1TJsT4gIu4qPF0=;
  b=IzHl1KxNTdi55wEGJIZS8PM3DQ2XGohl9k8S1bykR4r2IAYM1LhQyU4Y
   dc6vG7GpnVbyeXMbSGm7FMjw+coHNUH5nwOaweFVV6OaYhMGJ3yL0om2q
   Ul0AYpmMe0cWkXiaoyDxliqMnwQhJWZE7cldJhIpzY+bFWzVIIxy03E/Z
   8ICCsdaeZ3yP5FHeKC2zfxVhoHawlybWyxiAqyug5HA1zYZHbRMevAJrC
   9bev+9sMQNAL4JRELo5J7o/nshi8/qk6BJ4snh9U/VUtkncuxWM2OD8zL
   hhIFG+IqHi9ZlPVhxRLuKOjZI/vM2Fz8WNHek6AZe67Khqz/8Yo/YiUtP
   g==;
X-CSE-ConnectionGUID: fQvPO7cbT1izV0mpMaH1pw==
X-CSE-MsgGUID: aqfMT82vQ6uNK8oRf4aF4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11953"; a="2314494"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2314494"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2026 22:46:02 -0800
X-CSE-ConnectionGUID: 8l3CM987Tjm3P9BwrFglaw==
X-CSE-MsgGUID: ThJWP+isTvCeYX2carf4Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="5867273"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 01 Nov 2026 22:45:55 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xNlnj-00000000gWe-2XRs;
	Mon, 02 Nov 2026 06:45:51 +0000
Date: Mon, 2 Nov 2026 14:45:19 +0800
From: kernel test robot <lkp@intel.com>
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
	Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/8] dma-heap: charge dma-buf memory via explicit memcg
Message-ID: <202611021401.ZN5EGF6G-lkp@intel.com>
References: <20261027-v2_20230123_tjmercier_google_com-v3-2-78d2c4cb8647@redhat.com>
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
In-Reply-To: <20261027-v2_20230123_tjmercier_google_com-v3-2-78d2c4cb8647@redhat.com>

Hi Albert,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907]

url:    https://github.com/intel-lab-lkp/linux/commits/Albert-Esteve/memcg-Add-MEMCG_DMABUF-accounting-infrastructure/20261027-160244
base:   24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
patch link:    https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-2-78d2c4cb8647%40redhat.com
patch subject: [PATCH v3 2/8] dma-heap: charge dma-buf memory via explicit memcg
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20261102/202611021401.ZN5EGF6G-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261102/202611021401.ZN5EGF6G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611021401.ZN5EGF6G-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: drivers/dma-buf/heaps/system_heap.ko: symbol 'mem_cgroup_reserve_dmabuf' undefined!
>> ERROR: modpost: drivers/dma-buf/heaps/system_heap.ko: symbol 'mem_cgroup_commit_dmabuf' undefined!
>> ERROR: modpost: drivers/dma-buf/heaps/system_heap.ko: symbol 'mem_cgroup_cancel_dmabuf' undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
