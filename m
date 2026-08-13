Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8457338BF75
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 17:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642208; cv=none; b=OF6pnzmjnbIV7I7WVQVn08FPy7fAUH/ATMEhd/qk34j8/k9NN/9pjIJdyc1172M4XyYLuzuZJGnE2Xv9zns1tGL9qqJ6KAHfgOLhJYNza2XYcR4j0jM1oHHTs9PbX9chYDVKpwjvB6jg+Tfor80bmA+DKrt2c0HSUU/9eulkHkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642208; c=relaxed/simple;
	bh=2SULDOBGIaHFQU3kCInO6iJOy9ARJPIe/mpS+vulX48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/x5rTlvreNU5Lldu9Gavva0F1xF0w8n1x59WFraBncopMAHqoiCJ3KQvZqlFsTqrYQJPzvkJn3Bsj+p55rKsNMa9L5MAvsU634usLayp1Ddk54/huMFZcB8NxPpIEvmoQ/+LxAUHn/G9tQDPg+8eRoUL02fSvf5fEwM+Eoz+/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BZYtuuH1; arc=none smtp.client-ip=95.215.58.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BZYtuuH1"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2SULDOBGIaHFQU3kCInO6iJOy9ARJPIe/mpS+vulX48=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786642202; v=1; x=1787247002;
 b=BZYtuuH1EiElIrJtc0feLgTEpyZBb8E4FzaotY8Yi1r3kN0lOuOQ1hHOruRfupne8QUyB8g8
 0Gci4wrVWCPN6ykyEbf84VsN28pBJB987gv1b5sEXXALmRJ1A2wh/dXmaPKcuHbdu6/MnbFggUQ
 7+S28LeaYvLuV3ruZF93D56Y=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:44::)
	by smtp.migadu.com with ESMTPS id a602e21a5272711a;
	Thu, 13 Aug 2026 17:30:01 +0000
X-Migadu-Flow: FLOW_OUT
Date: Thu, 13 Aug 2026 10:29:54 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: kernel test robot <yi1.lai@intel.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <an3-aksL0MZPM3ZJ@linux.dev>
References: <202608131743.c6a7dda4-lkp@intel.com>
 <an34C2N-yqfok2Nn@linux.dev>
 <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev>

On Thu, Aug 13, 2026 at 06:14:50PM +0100, Usama Arif wrote:
> 
> 
> On 13/08/2026 18:01, Shakeel Butt wrote:
> > On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
> >>
> >>
> >> Hello,
> >>
> >> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
> >>
> >> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> >>
> >> in testcase: stress-ng
> >> version: stress-ng-x86_64-29ce10a2c-1_20260712
> >> with following parameters:
> >>
> >> 	nr_threads: 100%
> >> 	testtime: 60s
> >> 	test: mremap
> >> 	cpufreq_governor: performance
> >>
> >>
> >>
> >> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
> >> compiler: gcc-14
> >> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
> >>
> >> (please refer to attached dmesg/kmsg for entire log/backtrace)
> >>
> > 
> > Hi there,
> > 
> > Can you please test the following patch and see if it fixes the regression?
> > 
> > 
> > From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
> > From: Shakeel Butt <shakeel.butt@linux.dev>
> > Date: Thu, 13 Aug 2026 09:38:28 -0700
> > Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  include/linux/memcontrol.h | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index e78bc98ab229..e25d5b9a1db8 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -246,8 +246,13 @@ struct mem_cgroup {
> >  	/* handle for "memory.swap.events" */
> >  	struct cgroup_file swap_events_file;
> >  
> > -	/* memory.stat */
> > +	/* Read-mostly. */
> >  	struct memcg_vmstats	*vmstats;
> > +	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> > +	int			kmemcg_id;
> > +
> > +	/* Write-hot from here on; do not let it share with the above. */
> > +	CACHELINE_PADDING(_pad_);
> >  
> >  	/* memory.events */
> >  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
> > @@ -266,9 +271,6 @@ struct mem_cgroup {
> >  #if BITS_PER_LONG < 64
> >  	seqlock_t		socket_pressure_seqlock;
> >  #endif
> > -	int kmemcg_id;
> > -
> > -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> >  
> >  #ifdef CONFIG_CGROUP_WRITEBACK
> >  	struct list_head cgwb_list;
> 
> 
> I was currently testing this diff, not sure which one would be better.

I was just checking if false sharing of vmstats_percpu is the cause. If your
patch does not increase the struct size, we can go with that as a backportable
fix. I am planning to rearrange fields of struct mem_cgroup more drastically and
have it more stable as future work as we continuously see these regressions keep
popping up.

> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229b..215e2e87f42b2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -268,10 +268,15 @@ struct mem_cgroup {
>  #endif
>         int kmemcg_id;
> 
> -       struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> -
>  #ifdef CONFIG_CGROUP_WRITEBACK
>         struct list_head cgwb_list;
> +#endif
> +
> +       /* Keep the hot per-CPU stats pointer away from memory event counters. */
> +       struct memcg_vmstats_percpu __percpu *vmstats_percpu
> +               ____cacheline_aligned_in_smp;
> +
> +#ifdef CONFIG_CGROUP_WRITEBACK
>         struct wb_domain cgwb_domain;
>         struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>  #endif
> 
