Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6F63890F6
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 18:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785351078; cv=none; b=ScShL2joirRA46m6jNfxPsjB2vsw9+3YNbrhSZzGoKoX9inGNyoGG3uvqLXW4WS83RC478bYwYLtMFt+9XvT9a2w2vHaB5/MyAdI511z1AU2kKv/7wmBkhnq2mJjP9/Na+6G1yHSESBID8liUwxwL6Ujp+KG2FWkoRAkUU4j3F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785351078; c=relaxed/simple;
	bh=4nMOT9jrCH1Rf0saar++iDwUBziPm9P5JLww4bFvaH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WYsUBIMrQTHf3xpYkuupT9jAF944VI3/ibDu6sY87ntk+HwrYeqygpOvc2T4YL1RlivT2AEMe9WOmVWlRlrrWwLVsm1PNhKj1X7BAOoF+jA4X9Wfwwzsxdycx+WNSLdRW0w315sk2R26HrfaZUW2b/iccb2s3v1HOTysDXrz0Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=BWFbW7sE; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="BWFbW7sE"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e85499ffbso112274185a.0
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 11:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785351073; x=1785955873; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WT5HxsFSsFe8e43NEMOLV2lbYxngwkQWFWlRMgNk5So=;
        b=BWFbW7sE0LMpbEkMQ4/Q6QU47KrcsvjcYw3QL9kCSlYJxKYwufaAOQZi4DWeXiUORj
         ZbnTMf2AIXBMM+vMrcQfNzwGc5kTAkmB5QRNZ4ryPBiGwfVw0enBLW/AY5n/aHsZRX+c
         +uO53jeMQ4+spZ6LKHMN5i1QfeNSyylL7ec2SSLK76T/m1PnSsMNX4wNDNuFKncQ5dGs
         ged4GzwTWg5Wk4PH4Nc/rthrENBIw+rfAa2b6820XAV7kOktoIgFUEz8SrZqASUpgkoD
         8GLEOfMohTV6/0t9w03B4Kp0lDbrsJLU/RZxzIkfV/aWIRqyajCvVm4rVYtux+NIeA+Q
         ZR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785351073; x=1785955873;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WT5HxsFSsFe8e43NEMOLV2lbYxngwkQWFWlRMgNk5So=;
        b=hUQenohXp4WcWo6yl2pjYG6O3X12MuiqSbIUGmt32cw9NpS4y9Dk+/R5HE5RvUWCCa
         1ta9u9vHnoH7lZrPjl172Mk93vf5i5EAvaO9YBKTqMfWRFYgyNKKawWCJqb4LVvzuTLq
         8yJAXRpPESBz8ZOkn1tIK0Vc9DPzHOh7xgvk9+CtVSQ6oIz2YKXcf0mAfMosdEFHPc3/
         dXggV2NawgYuMDjbPEYUynrtjB19mC3QlfiHHWDc3vgtqZjB3zN1ZDt5JjbSFiSBkfWP
         6cs1OXGQScpBXq0DMjJ53HyTb8Cw6tMEzXzxqyMrivAEYlVWIBu2e1Gv6whfCWZ0tTY5
         dMfg==
X-Forwarded-Encrypted: i=1; AHgh+RplBgo2YUQWC7Q8wEiB2SbqSLB42HrFjjyBPKKuUKlBDN+cDHVfyPuLArrWKUUXLtRJWQ951E/0@vger.kernel.org
X-Gm-Message-State: AOJu0YztM782zR1+AJ4ZAnXb1+af82Ivxq5ofmyw1H6xnbj+9mpvvNue
	sw+KEZ52UKtILo3aAfdvezAm0reCh3tdjSMYSJyksdVXGxkoPzj+6Mh93Xqm3LUWznc=
X-Gm-Gg: AR+sD10p1yKtvSlVO+m3N/RwB7t8FQSWZls9DjG6BMwatk3HFZO83o47HbcLQ42p98L
	ZsDvcjk9njdqAwFY87b3xR129+6b/TJKcQOAXb+VVRISem4XBZSBDv4Bo7I0kmwF+YS4hwONWQx
	B1VcvEzge0V7ifNVPTQopQbYUzZ5pKv8jBOWvpfGRMkte0GMDWPF02dANYycSjOMPTPeAC7VeQ1
	tn574+PQzajfpAjYFmOGSPC8/TKea3zQTMHhQjcZczTkvjPDRV66qkfNbKsS8/Y/99h1N7/fgGR
	cfYLNuh7GIBxBwDehRAfSyetzxsB6BJKRjGyFxX9o77sl6ey1tU67Mhc8VFzXTwFux9yzjjNIj3
	S2XBQ3oTXQtjqWNsQHy4c3I7bFAWK5T3lBGgyk8jyI3VwUg4d99H5Xi3SPfTSG25UBxNOBA057E
	R8mikg2svG4jVmaot6bYeNu6YLmn7n+zjcoHF8UPoPjp27iTx1xRR4mKo/gzip
X-Received: by 2002:a05:620a:25ce:b0:91c:ac0a:690b with SMTP id af79cd13be357-93483dd5620mr11089285a.17.1785351073008;
        Wed, 29 Jul 2026 11:51:13 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3227707sm233230485a.6.2026.07.29.11.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 11:51:12 -0700 (PDT)
Date: Wed, 29 Jul 2026 14:51:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: bypass the reclaim and oom killer for dying tasks
 once oom_reaper is done
Message-ID: <ampLn-xkHnBVNHJ9@cmpxchg.org>
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

On Tue, Jul 28, 2026 at 07:46:12PM -0700, Shakeel Butt wrote:
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

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
