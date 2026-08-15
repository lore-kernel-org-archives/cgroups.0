Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A8829B77E
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 05:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786773519; cv=none; b=qGjyeDWxF+jNxIPOJOXY6SJW2F1QY7oHtD95aX/+9ajgIZYw+qzT3CKis6E9yMZT3CICXfwY8/CvTjT02t4WpKaRk3IUzmnDNB/ZtmURjDyXyR6YgSzbIrWUGZJrQuaN42OpZHU5nxYDk10tdoy6fRrrLSuIy/pxOTbF7Gj53Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786773519; c=relaxed/simple;
	bh=gjNgyi75mKSLP0qFZKF47roDus09J1ZqRh7z5MgfQmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0MDC3OXiCl+rO1y+YfkWKdpSEcF+yoE73GuwqzjwHzq1hwqjYgJTLA1al7OW0XReGoqMpK+G2YBKYRv3Qe8GxYcR89+FwFojRDFHpr6sD35DXHfRmXraeJqku8HTmP6KKFoKtZu+Rj6wpDGBLcEf/aMYuy12+e1lZmCvIMUb6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f1dq3FUr; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f1dq3FUr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786773518; x=1818309518;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gjNgyi75mKSLP0qFZKF47roDus09J1ZqRh7z5MgfQmQ=;
  b=f1dq3FUrVgslrL13wGwTpueqXjWdKVVqCtCOQTeFqqdq/eVlTiCSAJod
   3kyb1AVfkYnMxdLiQ5MkZ8RoARvCxGLjKxQorghcbM6JMYfKFQD3q0/ME
   vLM0g/MY4Uqclt+f+ZFtF2u/UgsjU4yA5qreuMwfyiUZosL5wVyWAab+D
   CmV/iaiAvsPoAl/iUzx9SrzxgnbRwUUqx6JO5S5dptKVHKn+d2A1UNh6/
   raEhCyHv3oaAWT7f6DPwtRoHF2DciXZdB5UElEtQbe25Fge8+BpNGSP5J
   E6qQ3qCzgP4oSAQt8JGfEf+qZC780X2oGZ4RL05gAYDp5q4GhFz3qsO4X
   g==;
X-CSE-ConnectionGUID: 0G+LFR2ISLm/QZRwJblpwA==
X-CSE-MsgGUID: R6mAcFCRSbOL8aKCXzV5IA==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="87264103"
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="87264103"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 22:58:37 -0700
X-CSE-ConnectionGUID: uehPhlSGQi6zUjC9n0w1tA==
X-CSE-MsgGUID: 4PqaEcKTS7G8yfZBQqcEMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="302647734"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 22:58:33 -0700
Date: Sat, 15 Aug 2026 13:58:29 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, oe-lkp@lists.linux.dev,
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	cgroups@vger.kernel.org
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <aoAABX59IzUXz/Rv@ly-workstation>
References: <202608131743.c6a7dda4-lkp@intel.com>
 <an34C2N-yqfok2Nn@linux.dev>
 <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev>
 <an3-aksL0MZPM3ZJ@linux.dev>
 <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>

On Fri, Aug 14, 2026 at 11:32:09AM +0100, Usama Arif wrote:
> 
> 
> On 13/08/2026 18:29, Shakeel Butt wrote:
> > On Thu, Aug 13, 2026 at 06:14:50PM +0100, Usama Arif wrote:
> >>
> >>
> >> On 13/08/2026 18:01, Shakeel Butt wrote:
> >>> On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
> >>>>
> >>>>
> >>>> Hello,
> >>>>
> >>>> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
> >>>>
> >>>> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> >>>>
> >>>> in testcase: stress-ng
> >>>> version: stress-ng-x86_64-29ce10a2c-1_20260712
> >>>> with following parameters:
> >>>>
> >>>> 	nr_threads: 100%
> >>>> 	testtime: 60s
> >>>> 	test: mremap
> >>>> 	cpufreq_governor: performance
> >>>>
> >>>>
> >>>>
> >>>> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
> >>>> compiler: gcc-14
> >>>> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
> >>>>
> >>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
> >>>>
> >>>
> >>> Hi there,
> >>>
> >>> Can you please test the following patch and see if it fixes the regression?
> >>>
> >>>
> >>> From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
> >>> From: Shakeel Butt <shakeel.butt@linux.dev>
> >>> Date: Thu, 13 Aug 2026 09:38:28 -0700
> >>> Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline
> >>>
> >>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> >>> ---
> >>>  include/linux/memcontrol.h | 10 ++++++----
> >>>  1 file changed, 6 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> >>> index e78bc98ab229..e25d5b9a1db8 100644
> >>> --- a/include/linux/memcontrol.h
> >>> +++ b/include/linux/memcontrol.h
> >>> @@ -246,8 +246,13 @@ struct mem_cgroup {
> >>>  	/* handle for "memory.swap.events" */
> >>>  	struct cgroup_file swap_events_file;
> >>>  
> >>> -	/* memory.stat */
> >>> +	/* Read-mostly. */
> >>>  	struct memcg_vmstats	*vmstats;
> >>> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> >>> +	int			kmemcg_id;
> >>> +
> >>> +	/* Write-hot from here on; do not let it share with the above. */
> >>> +	CACHELINE_PADDING(_pad_);
> >>>  
> >>>  	/* memory.events */
> >>>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
> >>> @@ -266,9 +271,6 @@ struct mem_cgroup {
> >>>  #if BITS_PER_LONG < 64
> >>>  	seqlock_t		socket_pressure_seqlock;
> >>>  #endif
> >>> -	int kmemcg_id;
> >>> -
> >>> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> >>>  
> >>>  #ifdef CONFIG_CGROUP_WRITEBACK
> >>>  	struct list_head cgwb_list;
> >>
> >>
> >> I was currently testing this diff, not sure which one would be better.
> > 
> > I was just checking if false sharing of vmstats_percpu is the cause. If your
> > patch does not increase the struct size, we can go with that as a backportable
> > fix. I am planning to rearrange fields of struct mem_cgroup more drastically and
> > have it more stable as future work as we continuously see these regressions keep
> > popping up.
> > 
> 
> 
> Yes this makes sense. I did not expect such a big change in a benchmark
> with my patch, although I feel like the microbenchmark is probably not
> that realistic.
> 
> I think another issue is that its a 4 socket system.
> I only have access to a single socket system, and I see a 4.38% regression.
> 
> Do you know if there a way for kernel test robot to test the below patch
> on its host?
> 
> 
> >From b862e84e7bd6a54b1546b7f21a6cf991253def18 Mon Sep 17 00:00:00 2001
> From: Usama Arif <usama.arif@linux.dev>
> Date: Thu, 13 Aug 2026 11:42:05 -0700
> Subject: [PATCH] mm/memcontrol: avoid false sharing between vmstats and events
> 
> Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> vmstats_percpu pointer onto the same cacheline.
> 
> The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> 60-second run on a 176-CPU test system.  Those writes bounce the line
> while memcg statistics paths load vmstats_percpu.
> 
> Move cgwb_list into the existing alignment gap and cacheline-align
> vmstats_percpu.  This separates the pointer from the event counters
> without increasing the size of struct mem_cgroup in the tested
> configuration.
> 
> The blamed commit reduced median mremap throughput by 4.38% on the
> test system with one socket. The patched kernel brings the performance
> to within 0.5% of the parent which is within the observed boot-to-boot
> spread (up to 1.2%).
> 
> Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
> Reported-by: kernel test robot <yi1.lai@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/memcontrol.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229b..215e2e87f42b2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -268,10 +268,15 @@ struct mem_cgroup {
>  #endif
>  	int kmemcg_id;
>  
> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> -
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct list_head cgwb_list;
> +#endif
> +
> +	/* Keep the hot per-CPU stats pointer away from memory event counters. */
> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu
> +		____cacheline_aligned_in_smp;
> +
> +#ifdef CONFIG_CGROUP_WRITEBACK
>  	struct wb_domain cgwb_domain;
>  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>  #endif
> -- 
> 2.53.0-Meta
> 
>

Tested the patch on the same test machine. Here are the test results
from stress-ng mremap benchmark (60s, 256 instances):

	Commit Avg.ops_per_sec
Base	a33b5c91	57311.85
Reregression ea928e9e	36542.09
Fix	582a7676	57089.22

The performance regression introduced by ea928e9e is resolved.

> 
> >>
> >> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> >> index e78bc98ab229b..215e2e87f42b2 100644
> >> --- a/include/linux/memcontrol.h
> >> +++ b/include/linux/memcontrol.h
> >> @@ -268,10 +268,15 @@ struct mem_cgroup {
> >>  #endif
> >>         int kmemcg_id;
> >>
> >> -       struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> >> -
> >>  #ifdef CONFIG_CGROUP_WRITEBACK
> >>         struct list_head cgwb_list;
> >> +#endif
> >> +
> >> +       /* Keep the hot per-CPU stats pointer away from memory event counters. */
> >> +       struct memcg_vmstats_percpu __percpu *vmstats_percpu
> >> +               ____cacheline_aligned_in_smp;
> >> +
> >> +#ifdef CONFIG_CGROUP_WRITEBACK
> >>         struct wb_domain cgwb_domain;
> >>         struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
> >>  #endif
> >>
> 
