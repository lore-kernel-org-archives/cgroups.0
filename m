Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F60F388E46
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785162991; cv=none; b=NbMNoaW3SdJiCUA8cM5tpS+rtR3oHQf6KlLM1KV/3l+aYAPuSC/SrqdDu9mqVoOLkBApWXAAE9Ei7DbKnXeMNWP6W2uwXFrxW1QF086WAEVeg7fHiIszMLQqx3fgT2by298a2hrDVYCrra8eIN+n22ZsvUra2EpqSkAey8uSsns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785162991; c=relaxed/simple;
	bh=kmAgijWEQfXjui8UuzNgw/Oo+wC1O83LY9NFXQkdVws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtMwSwtKAPQgEZBIa5l95KQj7F/DD6jUj7kA1PJVHugCfxDVnB4JeBEVIPRgHoHVSexHiL2ci7OvjAwEXMJUYfLse9puIwao9gCz6TI7hNpuNhkuD/K5l9IQrJSKqjz5l+9DJCJbMBDA5CNW7h27gxaplyzCj0HEpPRsrrsCkE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MxsdpB3I; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MxsdpB3I"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4957eefd361so21086895e9.1
        for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 07:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785162985; x=1785767785; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oSC7HgsrY0npyqxa5DFWKPswHwp4PCTPNe4kvbfpoeM=;
        b=MxsdpB3IeRWIWsMbVNEVY8dHJidgLMtKB5LnS19zD2vFvCajTr/ZTkmncsebvebmrI
         /1WCrLIi5fH08lJoVs15LZVhA5jrMsVmUJALgRddOmtRoXCrg7u1RSvKhUfRKugzrCbZ
         1NOIrmtmdTFDk1aXmq6rbYGYRc+Woa7RtBm4zZTQfh1EdqbYMjRf+TDpAion2a8eY1qQ
         0aE12E9TjgueRjy7uhCR9YxdrEZBRDhY1gpjH3meMSZtCJ4uR6ZH3YoR/XX4tWmcCC5H
         CA8pZ6oEX34GGfRrDAHwqLjRtShNzeoep03Mp0TCerrKFJjCqTjtPg1MwYTxMpxl2CX4
         IxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785162985; x=1785767785;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oSC7HgsrY0npyqxa5DFWKPswHwp4PCTPNe4kvbfpoeM=;
        b=AxXHD1un7LMZ+XYP+F1HegEMvFyYXFvc8eoAaO3jyMQgfowwj9/EVkivYQSNBdJEmV
         SplPpVUyn7KKkPi3B+mVDTvR6GX+LoxdyC5ZcGeNhldCr9YNBLMLDEFeugA2/arf7eG/
         yrYYvFn8RTktAWbfq3P6CfLPK40ZHZcrQD2O8PDIwypiUxSzMe+v6ZbnDPptAaSuYISa
         dPXIQr/vZrU9uzIvyO8+ovHZ84iXwxj1ALkga3z6H31zxviGlIgqF1CzLbfFDdeGww9l
         lCEZzRK/SswydXfaS305VEBVqS7VBMDC22w865X4Nrso5Lt6NohihyLnAW0ojDNocZ0G
         z8cA==
X-Forwarded-Encrypted: i=1; AHgh+RrSOPC9hUGiZW2JrxgNH4xMTfrHO5u/ZkcSSuHWuK+mLhWMHnmh7l9Z9GTmXSd3kITcJfn+dqVu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+MYTDM99JSfXQLVdg1LABG/7HipONic0VQZVucOlp2rqDYG75
	hyyL0gAi7ck6sMlXlxmfyl3rvO/Nb7iMZ45I+hysa7/SIyVVwn0DMoe6hrLE+PCbOUw=
X-Gm-Gg: AR+sD13lkyvYm1GwKWNXRRIWWHGe+wNcjmkT+Ui1v08kpuceZZkxUmuNNrRA8/7CJzN
	o4YSSFZVng0Rq0Cb4bcP/YRu7tzpOMbHzDDfwlZ5CmHO7OsqXAQ29yUjEhvlj7Y2JbGu3woWde4
	/XiQKxgAMaDc6to+SzFu6khsN7R40Dzk7GmnmNAkhIuVnwayjrDdFjEFradZ9WDbZJ/s3cfKpK4
	fEyD07jvcvOsJOEyFqTV0abapQ74hA9muzw9cPcHPyT0NdL/RBf+/ztBqiBYBm1A9PNC7Dpy/eb
	sUcRfEiVdZCn6uoCBxck8fXqLYEroNBuMp6Z3ZoeqlpMNhay8Q6cHvnuYGws/zPDO96MvZohQm1
	7ctzsP418WD/we5lNm2SIR18nD8R4ZKexIxkddRQ8oy0ZCj/HEc8bFAnD1DRb9reutY9MNz76jB
	HnahytO9JblQ==
X-Received: by 2002:a05:600c:a016:b0:495:63e6:5fb8 with SMTP id 5b1f17b1804b1-496b56fa3c4mr111223425e9.12.1785162984790;
        Mon, 27 Jul 2026 07:36:24 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4858e86sm236866125e9.1.2026.07.27.07.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 07:36:24 -0700 (PDT)
Date: Mon, 27 Jul 2026 16:36:23 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amds50dIVOiQNz0k@tiehlicka>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723001908.4046643-1-shakeel.butt@linux.dev>

On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
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
> limited number of times and then gives up, there might a thread of that
> process which had mmap_lock in write mode at that time.
> 
> My initial suspicion was the futex_cleanup and kernel page fault causing
> infinite fault and charge retries but that was put to rest in previous
> discussions happened on similar problem [1].
> 
> My current theory is that it is just a simple slow serialization behind
> the oom_lock. Unlike page allocator, memcg charge code takes the
> oom_lock without the "try". Though memcg oom code uses
> mutex_lock_killable(),  note that in the call stack get_stack() consumes
> SIGKILL (or sigdelset(SIGKILL)) before calling do_cgroup_exit(). So this
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
> Let's short-circuit that path: once reclaim has failed, if current is
> dying, force the charge instead of invoking the OOM killer for it. A
> dying task frees its memory as soon as it finishes exiting, so running
> the (necessarily no-victim) OOM killer for it is pointless - and doing so
> for 10s of thousands of exiting threads is exactly what serializes them
> behind oom_lock. The dying task instead faults its page in, completes
> exit and releases its memory, including the zswap pool, so the memcg
> recovers on its own without the oom_lock serialization and dump_header
> storm.

TBH I am not entirely happy about this approach. It effectivelly reverts
a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
It just makes it lockless. Assumption that a dying task will do so
quickly and with bounded resources has turned wrong on several
occasions.

On the other hand I do undestand the contention issues and I can imagine
that the existing solution doesn't really work well for huge thread
groups that all end up lining up on the oom_lock just to learn there is
nothing really killable anymore because they are the oom victim...

Would it be just safer to bail out only for oom victim threads. This
would narrow down potential runaways for oom victims which should be
more limited than any killed/exiting task. It would also give the oom
killer/reaper chance to work. WDYT?
--- 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..3e0a6b601767 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2685,6 +2685,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
+	/*
+	 * OOM victim still needs to charge memory to exit. OOM reaper should
+	 * help but it might fail on mmap_lock contention. If the victim is a
+	 * large thread group then all exiting threads might compete on oom_lock
+	 * just to learn that there is nothing really killable anymore. Bail
+	 * out early and force the charge to expedite their exit.
+	 */
+	if (tsk_is_oom_victim(current))
+		goto force
 	/* Avoid endless loop for tasks bypassed by the oom killer */
 	if (passed_oom && task_is_dying())
 		goto nomem;
-- 
Michal Hocko
SUSE Labs
