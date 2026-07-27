Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63A33E47B
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 15:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166739; cv=none; b=Sdl3x9ihHPCAl2a285WzY0ZKLrXqSHsUI4iY6qRPLEENOa7fkz7Jai1ELGs0Wji8vKnielNvuxQBiR1TEJohSU59+5IJ58lbnIprB5HNOASE7gmvaCEOTrTrX6JLL1Atw4UXIq0TyFqNUmytm68I+kqxQ4Yc99n8lQE+n57EMd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166739; c=relaxed/simple;
	bh=9GYD39912XUTCFDNJCkVCUoSOLyirKAaZ/mX0IP6O6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WG+gfbZDXfKplMD+ByoXAOVokB3idxa8koe7ugrXHJF18L5G7Vi5MHRmG8+pvIwfPLeG17iOSu+/9mMDS2WMn/npHxj+97k4LLMzcV5dkx5CJ+2O+Ok8y9Xlhsq/hrqEx5F1A2bWyaM8EeDdEwIaru47FqSZiO5pbgam67Jm7bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kDgJ6qV6; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kDgJ6qV6"
Date: Mon, 27 Jul 2026 08:38:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785166725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a1lsZlrq00ZIeRzGocQiS21Kw0pb1EHsAJMo62alk8g=;
	b=kDgJ6qV6z/P9vqTdFCOyqlojE6tx4hzyC1t5U0i+1nM+95V6/pLFg/UTd8f3V6bJvLKEE/
	hAuqhebg7H8GzrlVOM+NeognpgaAvb2IHuEHv25Vg4mBU8Qx/+0h4l/XzGXJx4jtdPxttZ
	HSRTsQLem2VoqBiC18+jTI/iCks1P8U=
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
Message-ID: <amd6N4DVzZkl90cs@linux.dev>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amds50dIVOiQNz0k@tiehlicka>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> > At Meta, we are seeing instances where an OOM killed job is stuck in the
> > exit path for several hours. In one particular case, the job was stuck
> > for more than 8 hours and I had to manually remove the memory.max limits
> > to allow the process to exit.
> > 
> > The job was a single process job and had ~55 GiB memory.max and zswap
> > enabled. It had almost 0 anon in memory and ~111 GiB in zswap compressed
> > to ~51 GiB zswap pool (i.e. almost all of memory.current was zswap).
> > Nothing was left on the LRUs to reclaim.
> > 
> > On further inspection, I observed ~20k threads of that process stuck
> > with the following stack:
> > 
> > [<0>] mem_cgroup_out_of_memory+0x4e/0xa0
> > [<0>] charge_memcg+0x8bf/0x990
> > [<0>] mem_cgroup_swapin_charge_folio+0x4e/0x80
> > [<0>] __read_swap_cache_async+0x10c/0x260
> > [<0>] swapin_readahead+0x116/0x3f0
> > [<0>] do_swap_page+0x13c/0x1ce0
> > [<0>] handle_mm_fault+0x61d/0x11f0
> > [<0>] do_user_addr_fault+0x3e7/0x6d0
> > [<0>] exc_page_fault+0x8f/0x110
> > [<0>] asm_exc_page_fault+0x22/0x30
> > [<0>] __get_user_8+0x14/0x20
> > [<0>] futex_cleanup+0x27/0x1c0
> > [<0>] futex_exit_release+0x47/0x60
> > [<0>] do_exit+0x107/0x940
> > [<0>] do_group_exit+0x81/0xa0
> > [<0>] get_signal+0x2b1/0x6e0
> > [<0>] arch_do_signal_or_restart+0x1a/0x1c0
> > [<0>] exit_to_user_mode_loop+0xa8/0x1c0
> > [<0>] do_syscall_64+0x152/0x250
> > [<0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53
> > 
> > In addition the dmesg was filled with "Out of memory and no killable
> > processes..." messages.
> > 
> > I have no idea why oom reaper was not able to reap/unmap the process. My
> > guess is that since oom reaper tries to acquire mmap_lock in read mode
> > limited number of times and then gives up, there might a thread of that
> > process which had mmap_lock in write mode at that time.
> > 
> > My initial suspicion was the futex_cleanup and kernel page fault causing
> > infinite fault and charge retries but that was put to rest in previous
> > discussions happened on similar problem [1].
> > 
> > My current theory is that it is just a simple slow serialization behind
> > the oom_lock. Unlike page allocator, memcg charge code takes the
> > oom_lock without the "try". Though memcg oom code uses
> > mutex_lock_killable(),  note that in the call stack get_stack() consumes
> > SIGKILL (or sigdelset(SIGKILL)) before calling do_cgroup_exit(). So this
> > mutex_lock_killable() is just a mutex_lock() here. Therefore 10s of
> > thousands of threads are waiting on oom_lock and one by one they get
> > -EFAULT from get_user() in the futex cleanup code and bails out.
> > 
> > Discussion from [1] lead to the commit a75ffa26122b ("memcg, oom: do not
> > bypass oom killer for dying tasks") which routes dying tasks into the OOM
> > path precisely so the oom_reaper can reap their mm and free the memory
> > asynchronously. But the reaper is best-effort and one-shot: if it cannot
> > take mmap_lock for read (e.g. a sibling thread holds it for write) it
> > sets MMF_OOM_SKIP and never retries, leaving only the glacial
> > oom_lock-serialized synchronous drain.
> > 
> > Let's short-circuit that path: once reclaim has failed, if current is
> > dying, force the charge instead of invoking the OOM killer for it. A
> > dying task frees its memory as soon as it finishes exiting, so running
> > the (necessarily no-victim) OOM killer for it is pointless - and doing so
> > for 10s of thousands of exiting threads is exactly what serializes them
> > behind oom_lock. The dying task instead faults its page in, completes
> > exit and releases its memory, including the zswap pool, so the memcg
> > recovers on its own without the oom_lock serialization and dump_header
> > storm.
> 
> TBH I am not entirely happy about this approach. It effectivelly reverts
> a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> It just makes it lockless. Assumption that a dying task will do so
> quickly and with bounded resources has turned wrong on several
> occasions.

That's why I kept it as RFC :)

> 
> On the other hand I do undestand the contention issues and I can imagine
> that the existing solution doesn't really work well for huge thread
> groups that all end up lining up on the oom_lock just to learn there is
> nothing really killable anymore because they are the oom victim...
> 
> Would it be just safer to bail out only for oom victim threads. This
> would narrow down potential runaways for oom victims which should be
> more limited than any killed/exiting task. It would also give the oom
> killer/reaper chance to work. WDYT?

I will give the following patch a try with the reproducer I have. I am still
improving the reproducer as I am still not able to recreate multi hour slowdown
yet. I will report back once I have some results. 

> --- 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..3e0a6b601767 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2685,6 +2685,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (gfp_mask & __GFP_RETRY_MAYFAIL)
>  		goto nomem;
>  
> +	/*
> +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> +	 * help but it might fail on mmap_lock contention. If the victim is a
> +	 * large thread group then all exiting threads might compete on oom_lock
> +	 * just to learn that there is nothing really killable anymore. Bail
> +	 * out early and force the charge to expedite their exit.
> +	 */
> +	if (tsk_is_oom_victim(current))
> +		goto force
>  	/* Avoid endless loop for tasks bypassed by the oom killer */
>  	if (passed_oom && task_is_dying())
>  		goto nomem;
> -- 
> Michal Hocko
> SUSE Labs
