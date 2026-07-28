Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EF03914E4
	for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785257754; cv=none; b=qFUdc9i99i1EbDDbsfpkrc1Hv3l/oMPSJpat68nCLW/5jCNy9Q9Rr8n58CQYstYnjcUPJ5S1wwRgmIVqdWVlTukuWF3wA1uishEbO9KPlLoDHEWDM4MFotJ8jymnArb6QrwaIBnxP7g74ksIGEpufVnwEx7m2YuQziL2cslgXug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785257754; c=relaxed/simple;
	bh=0mjpuZRpQxogwTizt2C3lDicCpVlWT9TOUP3k/i9ziU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHu1Kf4ZCqU1JG9AX2rXY/ChSSzQR+5Brgj7wVDuCFOv8oFtvmlSLz3fy6Zg7EMk72BRmDVhuj0A9ghaW0g1l3eoUugFwBH2aCNTWOxDT6v8bD+c2apAhwnqSV2qt1dwS3YwxMiNyIXndQ0CJSHG01UwCyn1FvX4rp5JB0R1nr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nzriWRMo; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nzriWRMo"
Date: Tue, 28 Jul 2026 09:55:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785257740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r5JlP6ioUX+/TbxbJL0DU8jGeR7d++HxnQJa+9ff9G4=;
	b=nzriWRMoPg/hlP/vXaFpykit9EB3DnLvs8Agjmn21AqnYWpvMInnIAWS8vM5GTeHOWuVBA
	GIjg2BePJN+1JkLrhCPwC3yKVQVWuo3/+KZhKYvXxcAsZnmqH6tLTUSwLSG+LlT3DPP9f5
	EG9bfe3zO9W22+H2NrI3/c7wWCR0gro=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Nhat Pham <nphamcs@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amjeUV3dAn7KPQgK@linux.dev>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
 <amhZ645Nhj856JfO@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amhZ645Nhj856JfO@tiehlicka>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 28, 2026 at 09:27:39AM +0200, Michal Hocko wrote:
> On Mon 27-07-26 13:48:58, Shakeel Butt wrote:
> > On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> > > On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > > > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> > 
> > [...]
> > 
> > > > 
> > > > TBH I am not entirely happy about this approach. It effectivelly reverts
> > > > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > > > It just makes it lockless. Assumption that a dying task will do so
> > > > quickly and with bounded resources has turned wrong on several
> > > > occasions.
> > > 
> > > That's why I kept it as RFC :)
> > > 
> > > > 
> > > > On the other hand I do undestand the contention issues and I can imagine
> > > > that the existing solution doesn't really work well for huge thread
> > > > groups that all end up lining up on the oom_lock just to learn there is
> > > > nothing really killable anymore because they are the oom victim...
> > > > 
> > > > Would it be just safer to bail out only for oom victim threads. This
> > > > would narrow down potential runaways for oom victims which should be
> > > > more limited than any killed/exiting task. It would also give the oom
> > > > killer/reaper chance to work. WDYT?
> > > 
> > > I will give the following patch a try with the reproducer I have. I am still
> > > improving the reproducer as I am still not able to recreate multi hour slowdown
> > > yet. I will report back once I have some results. 
> > > 
> > 
> > I have some results with the reproducer I (AI) wrote.
> > 
> > Setup: 20k threads, each with its robust_list head on its own page in a
> > large anon region pushed into a zswap pool (writeback off, so it's
> > unreclaimable and pins the memcg at the limit). On the OOM-group-kill
> > every thread faults that page in futex_cleanup() -> do_swap_page() ->
> > swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
> > in a loop so the oom_reaper can't reap the pool -- matching the host,
> > where the reaper was blocked and the memcg never fell below the limit.
> > 
> > I tested on next-20260726 as baseline and then tested your suggestion over it.
> > For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
> > drain the 20k threads in a VM (hours on the host, where each invocation
> > was a dump_header over netconsole). With the patch the dying tasks stop
> > entering out_of_memory and the storm is gone.
> > 
> > With the following suggestion, the threads of dying tasks stop entering
> > out_of_memory but the exit time doubled as each thread has to decompress the
> > page from zswap.
> > 
> > 	if (tsk_is_oom_victim(current))
> > 		goto force;
> > 
> > I also tested by replacing goto force with goto nomem and the exit time halved
> > i.e. ~20 seconds. Looking deeper it seems like each thread is still going
> > through the reclaim loops.
> > 
> > Just for testing purpose I moved this check along with goto nomem just before
> > the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
> > below 1 second. I think what we need is to detect early that the cgroup is
> > unreclaimable and the threads of exiting/reaped process should just return with
> > enomem.
> 
> Do you mean, something like this?
> --- 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..66f1eebf8c22 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2648,6 +2648,18 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!gfpflags_allow_blocking(gfp_mask))
>  		goto nomem;
>  
> +	/*
> +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> +	 * help but it might fail on mmap_lock contention. If the victim is a
> +	 * large thread group then all exiting threads might compete on oom_lock
> +	 * just to learn that there is nothing really killable anymore. Bail
> +	 * out early and fail the charge to expedite their exit. They are
> +	 * considered fully reclaimed by the oom reaper and they shouldn't contribute
> +	 * further charges.
> +	 */
> +	if (tsk_is_oom_victim(current) && mm_flags_test(current->signal->oom_mm))

I simply had tsk_is_oom_victim(current) check here. I assume you want
MMF_OOM_REAP_QUEUED in the mm_flags_test() above. Do you want me to test with
this additional mm_flags_test() as well?

> +		goto nomem;
> +
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
>  	raised_max_event = true;
>  
> 
> -- 
> Michal Hocko
> SUSE Labs
