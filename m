Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE113BADB3
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 06:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785394688; cv=none; b=uu1PQVQ0+vfIeIeBCBNjjjzY9npecRHDeKSugalPb7WKpvpG31+abJGnro3v9zH90ZaZQQFXX/AnTQbWl1Z7mj+pgpHD5oivoajfMqlJn81q3u/Mg0lWZGclQPxaWY5hQnI0292uvFOOvLbnJVi53cAVc990eG1PlyzPFo3gVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785394688; c=relaxed/simple;
	bh=dWIzzfF4hnIFYj6RIyObsN4+XyGrDvSpzzRaIeybbqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VcqT4ahpnptts2SKa0NsRVQlCG2rDw/zMKkYOCuH3a3BVB6kTzeOygyjg3FimgQr7ImUCPMfZvYvc+f5vDLnXEUSWE6ZNYrKhDQUu3O4hcN63z9AjEn2QWvLPpkVm3uP3wZ1+8kHwcp7Wux/ylePRrj3iQge6N581KN2j1KTzcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QWPgSEM+; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QWPgSEM+"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so10543685e9.3
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 23:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785394666; x=1785999466; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1GxtdDx0vobVNpbZd99PS3VLnLhCu/f+aaBy6tly+S4=;
        b=QWPgSEM+Wqh3NeWhmN/Y9UNvk6cYdwpwQKE5+xLTz+dW4w3LZ712ZQcOm1iTLbABUm
         0J21vufCqAuEVpoVSbGUzlO8cKcBqPszD7b4TBl+Zo+GtZFNZor2YO2TrE24HNgLE90H
         uVFabtzfY+hpg9FQyd6uMwMW1pfVcIYemP6XndzleBYKex4L2xgawiRZg6krnrYf5tNL
         LRISJt8ej/oyLzwwnOiBiMVR8WglvFDEv2KmYFAB4h2Y5EkFhnp3njKzkMFrltjPqFCY
         sMlaii0xwO5fFKFMAH9/5yKxs1JATH8DSSDn4gDydxgz/qPSPL9+dO77W6kcbq4TezHn
         ka7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394666; x=1785999466;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1GxtdDx0vobVNpbZd99PS3VLnLhCu/f+aaBy6tly+S4=;
        b=jzU8teWeAiOIW3Dgjk6LVIAoT3yn1sDORA20ABXPUKSzuMLnVGSXx2YEKgjyqHBCFw
         5+y6Hk3j97gumxCykqRc7vPUlU1i7ITHMxpn0bYykk5na0B1X3OI+Xpy+6UZ5V0xerQH
         vuizcvHs4vnX0z1C4pUYoJJlgHSvYQBEEG5q1WBIV35BuG5kBJa71vNk2xK94QR2mv2+
         qeBZJ9W6EWTA/mY2Z2L4mbavtLCwoqGP/vF7EsPpKCpidtsvrseMK5hgdvsU1c133zcH
         DwfgRd+5ZXJDNdVKrDahSMNkBC2AIOMKXlFfVkMp+pDecFRjXf5ouWuL4VlUfENn7Mzi
         vJtg==
X-Forwarded-Encrypted: i=1; AHgh+RoJfbEwJ3Ki+Dmqkr5xcPj50MXx5ABFIjn36UZcTENTieD7fWVe8/gj+YzH6mrl29W+LbfsF9LH@vger.kernel.org
X-Gm-Message-State: AOJu0YyjPGXmB75cmJeusD1P/Gk0ZlCq1zfBmXizPIDkGsCukhQlvBqo
	Vf5agV2I7I32DCPZ9WjlPewNtSQbAJjY8+Z6CKLFAgDhwLBnglBTXtiTdKHluDV2U1w=
X-Gm-Gg: AR+sD12A7UbXQBtTpNzZgghTYvRpGy8XrdCZ7T8ktqrdkLgpRMgHWmwKBFCmBzyDWv1
	20BG/Bkr2VvcRuktE5BUWTOMGzpYVis6WLF4S1XMJo1GXkyYlX9ZD5MeNBsTUSHHA3hYYcWJzEM
	MogSkKqXptE5yhw1Ckdx+xgGI762o+iOTgBh89z1sDiiWj43Eb/+xTGJUTSKnXhGHB6M4QtLVcD
	V2fEYetevWxBwFvxnbMTjZjXVO59CQ4zNyZnps3/2OO6v617auyyEnUKA8LC2bXM1kAdKZcm+bl
	8WJcXL1Um41UVl/bAphGoNQ0QJMSDaL4BVTzRwMBBstNiv/Ba29K/pspQLeKI+gYLliGWcIon4h
	NiUtABRPrJaaqlacF9qeFp1f03ziRP0kgregV53e4c2OLx50DAsoD3FzzklNKcr6edIAVSyGfIj
	+VmNPe5vBBiKMcPkyFFiT0uDyTs/D1gb9eUpub4R3SPDcrtoS7qJCVa45t6W5bep5iepGMxpiqp
	bBj3E0tkBPRvogDFO4=
X-Received: by 2002:a05:600c:55d8:b0:492:4a50:41fe with SMTP id 5b1f17b1804b1-49800ebf6c6mr10549755e9.22.1785394666265;
        Wed, 29 Jul 2026 23:57:46 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49764d848edsm113990275e9.4.2026.07.29.23.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:57:45 -0700 (PDT)
Date: Thu, 30 Jul 2026 08:57:44 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: bypass the reclaim and oom killer for dying tasks
 once oom_reaper is done
Message-ID: <amr16BmkkidgRolL@tiehlicka>
References: <20260729024612.3369005-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729024612.3369005-1-shakeel.butt@linux.dev>

On Tue 28-07-26 19:46:12, Shakeel Butt wrote:
> At Meta, we are seeing instances where an OOM killed job is stuck in the
> exit path for several hours. In one particular case, the job was stuck
> for more than 8 hours and I had to manually remove the memory.max limits
> to allow the process to exit.
> 
> The job was a single process job and had ~55 GiB memory.max and zswap
> enabled. It had almost 0 anon in memory and ~111 GiB in zswap compressed
> to ~51 GiB zswap pool (i.e. almost all of memory.current was zswap).
> Nothing was left on the LRUs to reclaim.
> 
> On further inspection, I observed ~20k threads of that process stuck
> with the following stack:
> 
> [<0>] mem_cgroup_out_of_memory+0x4e/0xa0
> [<0>] charge_memcg+0x8bf/0x990
> [<0>] mem_cgroup_swapin_charge_folio+0x4e/0x80
> [<0>] __read_swap_cache_async+0x10c/0x260
> [<0>] swapin_readahead+0x116/0x3f0
> [<0>] do_swap_page+0x13c/0x1ce0
> [<0>] handle_mm_fault+0x61d/0x11f0
> [<0>] do_user_addr_fault+0x3e7/0x6d0
> [<0>] exc_page_fault+0x8f/0x110
> [<0>] asm_exc_page_fault+0x22/0x30
> [<0>] __get_user_8+0x14/0x20
> [<0>] futex_cleanup+0x27/0x1c0
> [<0>] futex_exit_release+0x47/0x60
> [<0>] do_exit+0x107/0x940
> [<0>] do_group_exit+0x81/0xa0
> [<0>] get_signal+0x2b1/0x6e0
> [<0>] arch_do_signal_or_restart+0x1a/0x1c0
> [<0>] exit_to_user_mode_loop+0xa8/0x1c0
> [<0>] do_syscall_64+0x152/0x250
> [<0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> In addition the dmesg was filled with "Out of memory and no killable
> processes..." messages.
> 
> I have no idea why oom reaper was not able to reap/unmap the process. My
> guess is that since oom reaper tries to acquire mmap_lock in read mode
> limited number of times and then gives up, there might be a thread of
> that process which had mmap_lock in write mode at that time.
> 
> My initial suspicion was the futex_cleanup and kernel page fault causing
> infinite fault and charge retries but that was put to rest in previous
> discussions happened on similar problem [1].
> 
> My current theory is that it is just a simple slow serialization behind
> the oom_lock. Unlike page allocator, memcg charge code takes the
> oom_lock without the "try". Though memcg oom code uses
> mutex_lock_killable(), note that in the call stack get_signal() consumes
> SIGKILL (or sigdelset(SIGKILL)) before calling do_group_exit(). So this
> mutex_lock_killable() is just a mutex_lock() here. Therefore 10s of
> thousands of threads are waiting on oom_lock and one by one they get
> -EFAULT from get_user() in the futex cleanup code and bails out.
> 
> Discussion from [1] lead to the commit a75ffa26122b ("memcg, oom: do not
> bypass oom killer for dying tasks") which routes dying tasks into the OOM
> path precisely so the oom_reaper can reap their mm and free the memory
> asynchronously. But the reaper is best-effort and one-shot: if it cannot
> take mmap_lock for read (e.g. a sibling thread holds it for write) it
> sets MMF_OOM_SKIP and never retries, leaving only the glacial
> oom_lock-serialized synchronous drain.
> 
> Once MMF_OOM_SKIP is set there is no more asynchronous reclaim coming for
> the mm, so a dying task charging against it has nothing left to wait for:
> it frees its memory only once it finishes exiting. Running reclaim and the
> (no-victim) OOM killer for it is then pointless, and doing it for 10s of
> thousands of exiting threads is what serializes them behind oom_lock. So
> before reclaim, if current is an OOM victim whose reaper is done, fail the
> charge.
> 
> Reproduced with 20k threads, each parking a robust futex head on
> its own zswapped page, OOM-group-killed while a sibling holds mmap_lock
> for write so the reaper gives up and sets MMF_OOM_SKIP. Tested on
> next-20260728 and baseline show ~90 seconds exit time while with the
> patch the exit time reduced to ~3 seconds.
> 
> Link: https://lore.kernel.org/7a4e5591f45df455e6a485fc5400989569d3d22d.camel@surriel.com/ [1]
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks

> ---
>  mm/memcontrol.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8319ad8c5c23..f7a5f8a6cfee 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2653,6 +2653,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!gfpflags_allow_blocking(gfp_mask))
>  		goto nomem;
>  
> +	/*
> +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> +	 * help but it might fail on mmap_lock contention. If the victim is a
> +	 * large thread group then all exiting threads might compete on oom_lock
> +	 * just to learn that there is nothing really killable anymore. Bail
> +	 * out early and fail the charge to expedite their exit. They are
> +	 * considered fully reclaimed by the oom reaper and they shouldn't
> +	 * contribute further charges.
> +	 */
> +	if (tsk_is_oom_victim(current) &&
> +	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
> +		goto nomem;
> +
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
>  	raised_max_event = true;
>  
> -- 
> 2.53.0-Meta
> 

-- 
Michal Hocko
SUSE Labs
