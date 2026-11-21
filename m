Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795255312;
	b=x05gtMO8ldEF2C+xFoXzD6fq+1f/yCAhcPuhzfswFi3H3dKRhZQ4+FscmoSCWXLzg8Wq
	 5CJKcNh3lShjxke4PgxnZc8XFL21w8uA4KhbmICTihXLiFAxDLz2lO7pqeh/YHwGD3Zzw
	 7GbGh9H9iQkdrPaQGA0abzVJwwo/wcSNrkg1UITN67xtyOW2mEbS8vhYqlzlT9qWyiXK5
	 PH+KZUZIFCGZ6eAaE5/LcPUdW3q9rHAbVRr4VV7J50fbJxQSxsSbi/27YsaZFFK+fxXd0
	 vI/5dOd7ugyUf7VKjf/QoCzS3UntLpHulcAitQE/pF872ElGOjZcUlpEeTtQk1SSxyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795255312;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=0iLrgKiBXYhJ0kV7UEcjVMICphmvwPVOu/R+vQ1ryRw=;
	b=fGUKAmtQ0JtrCDrH+PHDQGfY8+gFhEWBnbdiBcrbznVK6zR7yrzXtaGiHqUyN9QdZ/EJ
	 Myt/XjOp/68YpaGlhPwkFHgxGvRPzb3zgBnU0SCHzP+g+8f6dvvl2pMTfrjKn1gzjGGzL
	 eCjH6C4knGwI9fpuuBYRVbI4DV1JmugCsqnCy5WJFQQyq4/V/6W8Z3chXBuuhDI60xMKh
	 aV2ySEKd3nP4yy+aKqqJ1x7fLX3w+9Hd15s36sfJfO+Rq8l1hZreN4hXEzbgRxvPP/j9B
	 ZMXG7qctMaZ9h6Axe1fmD6ZrIUUn9QmGYdBOO8yt2mUrCsmOK8Ssh8K5bNYQwk1aC2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=k9f1iayA;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C247606A680;
	Sat, 21 Nov 2026 10:01:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C247606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=k9f1iayA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795255312; x=1826791312;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qoUwdqVJuskEKxFdpm9I3StToR1r1PnxXAishHwsR+0=;
  b=k9f1iayAQpPZOnH+1V4iEbUHkBCI+VXH1xkBtmPrGo2v1p8j0Rj3AhOF
   bc5brAa6yU+H+b9/U32/Oqij71Sq5TKXMl/MBi6B9w9/LiIbuGIk9JJ8d
   z3pHXaFM9SibDCfzSVcCyrPGlw+rXdf2stntPhkL4f0C2Zx8Y1zwRcp2L
   m8ZqGzWZhdMf8+t7wEha8dRaUuH8bZZ6NMs5sO+fqUAOCppj0CoFr5ka/
   /CnZ06yozczv0YxApFL5r5qKU5W53KYBFcb/xgSEVvkG6jQY7YRGuyO7i
   c5ssuOMeQbxxwqbi3nLNB9R5LkV1+9MBetoalj/ocEudsap/B6mIEJQ3w
   w==;
X-CSE-ConnectionGUID: KDT8Wo5GRUyULMRG7BKxuw==
X-CSE-MsgGUID: Io1J+KlSSFGTigrcb9SKuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4011156"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4011156"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2026 02:01:51 -0800
X-CSE-ConnectionGUID: eQ+V7i+5Tga8Bp3IPgcd0A==
X-CSE-MsgGUID: F2pB6URmS36jLm6RP/ridw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="11161179"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 21 Nov 2026 02:01:44 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUhue-00000001JsJ-2qXj;
	Sat, 21 Nov 2026 10:01:40 +0000
Date: Sat, 21 Nov 2026 18:01:33 +0800
From: kernel test robot <lkp@intel.com>
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ridong Chen <ridong.chen@linux.dev>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Waiman Long <longman@redhat.com>
Subject: Re: [PATCH-next 1/3] tick/sched: Make tick_nohz_full_mask and
 HK_TYPE_KERNEL_NOISE cpumask consistent
Message-ID: <202611211717.qIDq0wIX-lkp@intel.com>
References: <20261121031329.240177-2-longman@redhat.com>
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
In-Reply-To: <20261121031329.240177-2-longman@redhat.com>

Hi Waiman,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tj-cgroup/for-next]
[also build test WARNING on tip/sched/core tip/timers/nohz linus/master v7.4-rc3 next-20261119]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Waiman-Long/tick-sched-Make-tick_nohz_full_mask-and-HK_TYPE_KERNEL_NOISE-cpumask-consistent/20261120-221327
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
patch link:    https://lore.kernel.org/r/20261121031329.240177-2-longman%40redhat.com
patch subject: [PATCH-next 1/3] tick/sched: Make tick_nohz_full_mask and HK_TYPE_KERNEL_NOISE cpumask consistent
config: powerpc-akebono_defconfig (https://download.01.org/0day-ci/archive/20261121/202611211717.qIDq0wIX-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 3b14d7c370558b46e5f0c6494a05c492e59bf32c)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/202611211717.qIDq0wIX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611211717.qIDq0wIX-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: EXPORT_SYMBOL used for init symbol 'housekeeping_set_cpu'. Remove __init or EXPORT_SYMBOL.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
