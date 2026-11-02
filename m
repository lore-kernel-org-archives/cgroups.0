Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609202;
	b=xXTFSlPyS0FWpXYv6C/AUE9vOwDdvWwtihZqgatDDJe0X5YJMOujkF8RdXLvuHp2KxZo
	 6U4yPTEL+bQCSRbNw0hh+STSseN33oUbo4fKiZC77hhp9w7zL1zzKJtccGvujDOYIHZW/
	 Pnu8q8vnUcQfxjin9+1zGdKEBJz0Wa14maX5/r/1sUc+c8cuZ/Vcof0LVgJxd+7M2ArD1
	 uHZjCw1mDMgpLGLWgO43sj0q2PNw5v35s3masLdNGnlzWWW8gX3hwE5SJWh1btJcWdLPE
	 NdQXSsiSE7vqAiqHHew3NzA8+1dSkz4Bt2poAZ2OaCB8AkEcmxBJ7pxtjXRlQ1c43cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609202;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=LhbTInRgkBXlbPXlXEHaIHOTP4lL/qI0/4M9rSDHTRQ=;
	b=kRuTFXW8nrE9Y80nWbg3xrdhB8tZ/bQAt74uhEJ8dMDNX7NIjApUHAv3xr//RHX2pOpl
	 AThtb+ZCxdKCdFJ9Ev1+U6z8E9wQcF5iacFN9ydrHxqkP2dk/+grtuXj0F4wVOvR/Rkqy
	 XPM6ltZvPqGmotyS3/dvv1czFznDvBjtx2xXVuCPMg48nM0FwN+oEcgkr+ACP3L/g3RVz
	 MJW3/uUvWSCLD2ZS2kppVkiyBmwiu4x1Ropt5JSOpCbTokU0aJ/xkQJbtGqJZjzRkgsuW
	 eazSkj9JIV7Ll743jhdM+mBa4hKptCzrQwpy3vq+JQTR/wImgrPOixSGPGqv4Yp6CIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Zc23m8QG;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33FE606A326
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 08:46:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F33FE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Zc23m8QG
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b042c0759so1327750f8f.2
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 00:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793609200; x=1794214000; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LhbTInRgkBXlbPXlXEHaIHOTP4lL/qI0/4M9rSDHTRQ=;
        b=Zc23m8QGRQ39gSk+r4Mjk2hQU+Hf6Eih+t6vqtLOlb+DjWqZGdRnen5vZkd1/b3eoY
         g5H4X0X508kmuvLY1i6aFsDn6gEsTMgH5yYgmWPBMYr7ZABNS5ICm4geEPuWOB2qJRWp
         6pNobdOkGNR83ltf9UMLcx+wpCqMEnGtuzS7OsK6O8478Mt9AQrFVC/wlLleRhOPxUUS
         DXfNmprqIdaAZnC95LXXNINJJzJUc0ek2UcFYpz6Ydlu4ZTd4rfAgdvPPV7wzl0GPJJx
         yoqNrq9sw0l49s1QfJ4V28AmP9GLeC5hy1DrvnWD4MHvis52+9S7yNb0UHPCLrcpZw7u
         v4fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793609200; x=1794214000;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LhbTInRgkBXlbPXlXEHaIHOTP4lL/qI0/4M9rSDHTRQ=;
        b=LDtl8eD7wJhA8XnEfQ54cjdnL5m6CYmwS/aUtx19z/dD5sdaOa7X4+GXOJpffmO5JB
         c6F+KZ7dlzks/Yt0GAPqXLd8BcPlVOr71CgNMGMW/kuYeDjznqDMMZF1oB2Fd6j36DPh
         aM3gX0YVPfH/0FcjwSCUMxzFudOfEOQfQthq/dbIbWZnq6+C9b2GJj77M2bv833L4QDu
         iC1L6OxqR9pLdjjKk0Fu5bNEb0lgn8pRXqpZy90XdnYKCdDyCLuJT0BxhFW/O9AkkmMM
         P1+ndq4ApKYnByqECxqaJXJen8q7N0lS9RWVWt+7r0TefF3m1Rf/+zgI/u1ueYALuuXV
         I2MQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8NOc4GsSvHJzOv9Cw+4F14rbV1dKPsdcMDlZnVBxC/Z8cUmTaWGmERPG/Hf5TFoQ6AFXVoH+N@vger.kernel.org
X-Gm-Message-State: APuU4Z8Az/RBxl9Dh5Bri7m342f8x+11X9G1rmdwe6UNsbpfJdA1n+ls
	ldbCdxtQI1RVi20/s9aIfbiT4jG773+I4ells3PiG/8iGvFnUniLl5j65DaBUBQoukU=
X-Gm-Gg: AYBFou0Qcijxk5A7l1cc3RvCa/82H4WYmsDechIylbtzXb5sZNYKfOqkdgvMBZaCufU
	bXQ/wWTgaarqJZZB7MjMTeRngaDL21Ud02DErVgCWsRFx/oYAxcJWAaOmnhXLdYqoE1uIjvjLbi
	OSbDMmQAet1M/C4EkzK3AZwHu1Qvc7bx2+bInerGGISn3IVVr9KCwQQITHyOgtQxW5OhplByphY
	KYfm3Q48qm02OAWSZFtGloGyNeQGRk6R3q8bg5SZg62h1ifwi31JEQBddTznLoYQPAr5Kbsv3Yg
	xUsTA7K4wiiDpQbbwrAjhQ6HgDBYROYKVelhEIZp9QtT8nr8Mhp4sWnNUQNbKdoD1uMr0K71JqC
	pGM26vKV8LKT8w80vIImU0QrYZap9i1qKmOSdj2/HZL5bX914vFPNUXA9IBKnnN5tkuqam0XyfK
	H7fEi3nSbLjr+Qep6cGcQxc2qmKD3+lTDH/J3ypX7h98+1bw0A02pU+7sliTLQbG1luiQPeXiHK
	rR4+iQ8sXlTug81iv7pOE4lDkeKcVk5gQwi3n1IKrsNXz+eourCau1W611+gr6onktZ1+mt9OJK
	5kqncEcGKpUxrFYxpydcdz8cfZojtxgvcf/v17Y=
X-Received: by 2002:a5d:64c4:0:b0:488:7787:469d with SMTP id ffacd0b85a97d-48e6e4fca0amr22529624f8f.25.1793609200314;
        Mon, 02 Nov 2026 00:46:40 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8c0b6sm18086023f8f.41.2026.11.02.00.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 00:46:39 -0800 (PST)
Date: Mon, 2 Nov 2026 09:46:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] memcg: force charges from reclaim before trying
 the limits
Message-ID: <auhN7v127jwy-q-W@tiehlicka>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-3-shakeel.butt@linux.dev>
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
In-Reply-To: <20261030205418.341214-3-shakeel.butt@linux.dev>

On Fri 30-10-26 13:54:13, Shakeel Butt wrote:
> Reclaim can charge memory, for example when zswap stores a page.
> try_charge_memcg() forces these PF_MEMALLOC charges, but only after
> they fail at a limit. A charge that fits still has memory.high
> enforced. That can make a task in direct reclaim do more reclaim and
> sleep longer later, and kswapd records overage that it never handles.
> 
> It is also a problem for the next patches, which make kernel threads
> queue high_work. The worker charges memory from its own reclaim, so it
> can queue itself again. With those patches but not this one, the worker
> queued itself in 118 of 284 runs in a VM test with incompressible zswap
> data.
> 
> Check PF_MEMALLOC before trying the limits. Reclaim charges then skip
> memory.high, as they can already go over memory.max. Drop the
> PF_MEMALLOC check in memcg_enforce_high(), which no longer sees them.
> 
> Other effects:
> - As before, the check reads current, so it also catches interrupts on
>   a PF_MEMALLOC task such as kswapd. Softirqs set PF_MEMALLOC
>   themselves for swap over network, so the check can't be limited to
>   task context.
> - These charges no longer charge a batch or refill the per-cpu stock.
> - MEMCG_MAX still goes to the first cgroup that the charge puts over
>   its limit. On cgroup v1, memory.failcnt no longer counts them.
> - high_work can still run again and again when there is nothing left
>   to reclaim. This only stops reclaim from queuing more reclaim.
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/memcontrol.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0e484f7f823a..af95a4574a0f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2762,7 +2762,6 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  	 * when it rechecks the overage and simply bail out.
>  	 */
>  	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> -	    !(current->flags & PF_MEMALLOC) &&
>  	    gfpflags_allow_blocking(gfp_mask))
>  		__mem_cgroup_handle_over_high(gfp_mask);
>  }
> @@ -2787,6 +2786,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (consume_stock(memcg, nr_pages))
>  		return ret;
>  
> +	/*
> +	 * Reclaim may need memory to free memory. Let it go over the
> +	 * limits for a while rather than fail or OOM kill. Doing this
> +	 * before trying the limits also skips memory.high, so the
> +	 * high_work worker can't queue itself from its own reclaim.
> +	 */
> +	if (unlikely(current->flags & PF_MEMALLOC)) {
> +		/* Find the cgroup this charge puts over its limit, if any. */
> +		for (mem_over_limit = memcg; mem_over_limit;
> +		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
> +			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
> +				break;
> +		goto force;
> +	}

This is racy. Not a huge deal as we would get a false event in the worst
case but I think it would make more sense to check the margine after the
charge is forced. So this would become
--- 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..bd202ec05acf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2653,13 +2653,20 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool passed_oom = false;
 	unsigned int reclaim_options;
 	bool drained = false;
-	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
 retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
+	/*
+	 * Reclaim may need memory to free memory. Let it go over the
+	 * limits for a while rather than fail or OOM kill. Doing this
+	 * before trying the limits also skips memory.high, so the
+	 * high_work worker can't queue itself from its own reclaim.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
 
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
@@ -2683,15 +2690,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
-	/*
-	 * Prevent unbounded recursion when reclaim operations need to
-	 * allocate memory. This might exceed the limits temporarily,
-	 * but we prefer facilitating memory reclaim and getting back
-	 * under the limit over triggering OOM kills in these cases.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC))
-		goto force;
-
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
@@ -2712,7 +2710,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto nomem;
 
 	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
@@ -2773,13 +2770,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
 		return -ENOMEM;
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
@@ -2789,6 +2779,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
+	/*
+	 * If the allocation has to be enforced, don't forget to raise
+	 * a MEMCG_MAX event.
+	 */
+	for (mem_over_limit = memcg; mem_over_limit;
+	     mem_over_limit = parent_mem_cgroup(mem_over_limit))
+		if (!mem_cgroup_margin(mem_over_limit))
+			__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+
 	return 0;
 
 done_restock:
-- 
Michal Hocko
SUSE Labs
