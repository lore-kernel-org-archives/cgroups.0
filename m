Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCBC17A2E8
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 19:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786821631; cv=none; b=hqXVOJ9qg2PxzdUb0ap2KzV8dGE/pj06wOCrkp1cxGB5MT3+xPhCM76Pyw7fztQwKXbKzNrNvsxe60AaYJFPUourL/pcK+JHg3Watl06t4bOKCWa69vQQ1rYtzx9jYTE1ywflUxQ3Xa0WCM2C5I84m80209wmRLA2qRk6tOVNFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786821631; c=relaxed/simple;
	bh=es1upZSfw+GDFk7iS7KckxveC0HgwWL/IhQ9PsbGcAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fg+aYT6dwH0YE/LT7lwh+++lchInKCEbxjBNmUhpp2J/gkMi6ROst16aEVhNaGsfk0t11Y5ibUQus5dFskPp8kaQlM+70ZfQMF4UwgBXd2/ccatCbh6Y6HNFKVQ/a2hSMAt5s8lXAjYvh+3POWsuj3uL1YUB/wnjiXIegy5i33k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VmBtt5S7; arc=none smtp.client-ip=91.218.175.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VmBtt5S7"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=es1upZSfw+GDFk7iS7KckxveC0HgwWL/IhQ9PsbGcAE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786821626; v=1; x=1787426426;
 b=VmBtt5S7LDM4MUKJMgn91rXfUw9m4TuZ3XCYz82ApVtjoX0eaXaZuJgDX7zqnTeBoBcJOfB7
 VgJjdMB2LcTdL3WV/fL0cQe1x7v44bMQ/uVxoP28AZO7ZYhtzHphTayXrua1QGxKlEbFyFz/eIl
 0obUNZFKdJC9hKCOqDujjZJU=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:16::)
	by smtp.migadu.com with ESMTPS id 1201a916540915ec;
	Sat, 15 Aug 2026 19:20:26 +0000
X-Migadu-Flow: FLOW_OUT
Date: Sat, 15 Aug 2026 12:20:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kernel test robot <yi1.lai@intel.com>
Cc: Usama Arif <usama.arif@linux.dev>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <aoC7k_AULngjkHQ-@linux.dev>
References: <202608131743.c6a7dda4-lkp@intel.com>
 <an34C2N-yqfok2Nn@linux.dev>
 <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev>
 <an3-aksL0MZPM3ZJ@linux.dev>
 <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>
 <aoAABX59IzUXz/Rv@ly-workstation>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoAABX59IzUXz/Rv@ly-workstation>

On Sat, Aug 15, 2026 at 01:58:29PM +0800, kernel test robot wrote:
> On Fri, Aug 14, 2026 at 11:32:09AM +0100, Usama Arif wrote:
> > 
> > 
> > On 13/08/2026 18:29, Shakeel Butt wrote:
> > > On Thu, Aug 13, 2026 at 06:14:50PM +0100, Usama Arif wrote:
> > >>
> > >>
> > >> On 13/08/2026 18:01, Shakeel Butt wrote:
> > >>> On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
> > >>>>
> > >>>>
> > >>>> Hello,
> > >>>>
> > >>>> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
> > >>>>
> > >>>> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> > >>>>
> > >>>> in testcase: stress-ng
> > >>>> version: stress-ng-x86_64-29ce10a2c-1_20260712
> > >>>> with following parameters:
> > >>>>
> > >>>> 	nr_threads: 100%
> > >>>> 	testtime: 60s
> > >>>> 	test: mremap
> > >>>> 	cpufreq_governor: performance
> > >>>>
> > >>>>
> > >>>>
> > >>>> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
> > >>>> compiler: gcc-14
> > >>>> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
> > >>>>
> > >>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
> > >>>>
> > >>>
> > >>> Hi there,
> > >>>
> > >>> Can you please test the following patch and see if it fixes the regression?
> > >>>
> > >>>
> > >>> From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
> > >>> From: Shakeel Butt <shakeel.butt@linux.dev>
> > >>> Date: Thu, 13 Aug 2026 09:38:28 -0700
> > >>> Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline
> > >>>
> > >>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > >>> ---
> > >>>  include/linux/memcontrol.h | 10 ++++++----
> > >>>  1 file changed, 6 insertions(+), 4 deletions(-)
> > >>>
> > >>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > >>> index e78bc98ab229..e25d5b9a1db8 100644
> > >>> --- a/include/linux/memcontrol.h
> > >>> +++ b/include/linux/memcontrol.h
> > >>> @@ -246,8 +246,13 @@ struct mem_cgroup {
> > >>>  	/* handle for "memory.swap.events" */
> > >>>  	struct cgroup_file swap_events_file;
> > >>>  
> > >>> -	/* memory.stat */
> > >>> +	/* Read-mostly. */
> > >>>  	struct memcg_vmstats	*vmstats;
> > >>> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> > >>> +	int			kmemcg_id;
> > >>> +
> > >>> +	/* Write-hot from here on; do not let it share with the above. */
> > >>> +	CACHELINE_PADDING(_pad_);
> > >>>  
> > >>>  	/* memory.events */
> > >>>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
> > >>> @@ -266,9 +271,6 @@ struct mem_cgroup {
> > >>>  #if BITS_PER_LONG < 64
> > >>>  	seqlock_t		socket_pressure_seqlock;
> > >>>  #endif
> > >>> -	int kmemcg_id;
> > >>> -
> > >>> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> > >>>  
> > >>>  #ifdef CONFIG_CGROUP_WRITEBACK
> > >>>  	struct list_head cgwb_list;
> > >>
> > >>
> > >> I was currently testing this diff, not sure which one would be better.
> > > 
> > > I was just checking if false sharing of vmstats_percpu is the cause. If your
> > > patch does not increase the struct size, we can go with that as a backportable
> > > fix. I am planning to rearrange fields of struct mem_cgroup more drastically and
> > > have it more stable as future work as we continuously see these regressions keep
> > > popping up.
> > > 
> > 
> > 
> > Yes this makes sense. I did not expect such a big change in a benchmark
> > with my patch, although I feel like the microbenchmark is probably not
> > that realistic.
> > 
> > I think another issue is that its a 4 socket system.
> > I only have access to a single socket system, and I see a 4.38% regression.
> > 
> > Do you know if there a way for kernel test robot to test the below patch
> > on its host?
> > 
> > 
> > >From b862e84e7bd6a54b1546b7f21a6cf991253def18 Mon Sep 17 00:00:00 2001
> > From: Usama Arif <usama.arif@linux.dev>
> > Date: Thu, 13 Aug 2026 11:42:05 -0700
> > Subject: [PATCH] mm/memcontrol: avoid false sharing between vmstats and events
> > 
> > Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> > struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> > This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> > vmstats_percpu pointer onto the same cacheline.
> > 
> > The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> > disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> > 60-second run on a 176-CPU test system.  Those writes bounce the line
> > while memcg statistics paths load vmstats_percpu.
> > 
> > Move cgwb_list into the existing alignment gap and cacheline-align
> > vmstats_percpu.  This separates the pointer from the event counters
> > without increasing the size of struct mem_cgroup in the tested
> > configuration.
> > 
> > The blamed commit reduced median mremap throughput by 4.38% on the
> > test system with one socket. The patched kernel brings the performance
> > to within 0.5% of the parent which is within the observed boot-to-boot
> > spread (up to 1.2%).
> > 
> > Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
> > Reported-by: kernel test robot <yi1.lai@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> >  include/linux/memcontrol.h | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index e78bc98ab229b..215e2e87f42b2 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -268,10 +268,15 @@ struct mem_cgroup {
> >  #endif
> >  	int kmemcg_id;
> >  
> > -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> > -
> >  #ifdef CONFIG_CGROUP_WRITEBACK
> >  	struct list_head cgwb_list;
> > +#endif
> > +
> > +	/* Keep the hot per-CPU stats pointer away from memory event counters. */
> > +	struct memcg_vmstats_percpu __percpu *vmstats_percpu
> > +		____cacheline_aligned_in_smp;
> > +
> > +#ifdef CONFIG_CGROUP_WRITEBACK
> >  	struct wb_domain cgwb_domain;
> >  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
> >  #endif
> > -- 
> > 2.53.0-Meta
> > 
> >
> 
> Tested the patch on the same test machine. Here are the test results
> from stress-ng mremap benchmark (60s, 256 instances):
> 
> 	Commit Avg.ops_per_sec
> Base	a33b5c91	57311.85
> Reregression ea928e9e	36542.09
> Fix	582a7676	57089.22
> 
> The performance regression introduced by ea928e9e is resolved.

Thanks a lot.

Usame, can you please send a formal patch and you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

> 
> > 
> > >>
> > >> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > >> index e78bc98ab229b..215e2e87f42b2 100644
> > >> --- a/include/linux/memcontrol.h
> > >> +++ b/include/linux/memcontrol.h
> > >> @@ -268,10 +268,15 @@ struct mem_cgroup {
> > >>  #endif
> > >>         int kmemcg_id;
> > >>
> > >> -       struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> > >> -
> > >>  #ifdef CONFIG_CGROUP_WRITEBACK
> > >>         struct list_head cgwb_list;
> > >> +#endif
> > >> +
> > >> +       /* Keep the hot per-CPU stats pointer away from memory event counters. */
> > >> +       struct memcg_vmstats_percpu __percpu *vmstats_percpu
> > >> +               ____cacheline_aligned_in_smp;
> > >> +
> > >> +#ifdef CONFIG_CGROUP_WRITEBACK
> > >>         struct wb_domain cgwb_domain;
> > >>         struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
> > >>  #endif
> > >>
> > 
