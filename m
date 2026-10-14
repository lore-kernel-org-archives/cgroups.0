Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE3454B1B1
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 16:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791997175; cv=none; b=U83Zz5Y4khJ7vIkPQrR5Ed3FOOkRDk9O/9iNVYVH4WVLjMwPR/KL/3jsoFMj5Zh8Z+zngXXsAE+sX1OaVoch17p6U66dSDL7lnoj+HBNFZcYpTzjW0a7K2/brg8TaUS6HRjhXBI3hG2/VCb6EaIWGXMh426Yx8gBBfsYJjH2e38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791997175; c=relaxed/simple;
	bh=NsHpXNZdRRSaNrBGxP0ycOFnmOfLshkw+2EOdYd5N8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDrPGIivqsce5aU6j8Bg8H+0QniwbhqQEbIMwnMC+cY7BD8I2E+EeYVZp14278vf17w0NRwL8OqxGbRSrs4wPG5JNjs/3lc93fFd8s23DQkMZOl4gzw+WLRk2XowU2IqjpPV3ofRThvN53DifaWk8LoCv/+Gv2tn4DQ5sMEhRx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WZGE/Xuq; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WZGE/Xuq"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a1682bff3cso5551455e9.1
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 09:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791997172; x=1792601972; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=prPunQqbna8thQ76F5VpQmbPqh027UVozqQG4+ve53M=;
        b=WZGE/XuqFSB5e83HawttFSumX8nUdVsjC6JQabKgwSOfKG6b65dvTgLa1px+gqmgXN
         oSZJeclgzgiUUcS3buqNUHb8Zblysadp/ASrwOQelUwwt4u3IHH9p7E6WEWtCTaqCjQP
         1d9dvqDZi1xswOJe7/7kwnSERVm1/BkuO3++v1V0IgSSIjdmNNkmlO+o3XHVwBkuR8Nz
         lmv+1srH3qzRYu06cdKCJKYe+4AwuGk1pibRip4m0SqrPie9d7gubIYItpm4flgSnvKh
         twM4Yth8ju5Wiyo75H5jeUKUgjg26no8MvsCnw463U7q5mK295XMGihDvJsKuOzcZFc1
         HiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997172; x=1792601972;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=prPunQqbna8thQ76F5VpQmbPqh027UVozqQG4+ve53M=;
        b=16+sbvTfSale2nbvw/xYiHFWPadD9sUV0YGKvzPN86byyY+xPw7EgVxSYo07lrbJse
         3zZOKYrb+NiRVFTCEWWkcF+OHbc1cPN4vIGdTFlHZEvOa2wa/sPqr63n1Dr6WzBiEUzP
         e5LvPPGKiApn8O8DF+NHNp4QQAFQqIeDnqWr7+j4TWjyvNUYQtG0I6N0iFzSaZaI3656
         6oOsDI92JYsep43LzQAYAT2ZeQNoyqZF7l+Mhk8gZ/oNYa/LZ2P3NHvwfAXkMc0hMJZV
         K/Y+rz/EV9quvaoQyeNBwzIuRkAuhIzouyHqHgJnUs3qohCergZPSzVlmJj85sQEpJzZ
         YmHw==
X-Forwarded-Encrypted: i=1; AKwUvBzS0/3Zc+vCVpMkolMCr9ApAIHaqr7UMk/eaFBMZVYUytsU4VbfbvuwFE6bhUCTncbA3YK3y1wr@vger.kernel.org
X-Gm-Message-State: AFq9FYLHIgZ2ERkzJZuR7tR8k2zMTRiqaXdsz4n64LNb9FzhccwKpqvD
	/l/w9YDX9mwCmKCszp0lOkKzA6uHSvRGIvwWuLvPyGoVN4Mf2LVXwgPypp8FyZiUIK0=
X-Gm-Gg: AYBFou3qEkNcbEE4wpLisMtHX8DpCwNjx8DohU2FzJdzd6U8zq8iX55WEgLnSmYr2Ct
	33UfRqaIl7jJSj8nw2EAQwJDgdbj0HwhudWlZCDznE9wOvQNSyzjL+PYqCuZrpqjDtfRW+Vejfv
	TykUo+UZsPp69/AFgn3bcM4yvqUVae/Qx4A2G5lirGqyaN7W3eTBRPYPzzP0gvGnUGxxM7k2Er7
	EUZnubloKC/p5ocSNLWXfqiGeaY9CaJ8e3vnFCcPFsHBgi5V+IYj2RtdnrzykC77pmc0UiFfyYm
	tRKjUlUqjPUaYFaWLO1P0Wtv3j/TP6bBAig0TVhkby5hux7kyM1dIsBce+GDfEsAQvNJXtxT/NT
	Ut5d3Gb2GNL51XL6h9Ck8aujRXiw/PwjUzNtbxo1zSedVONDG30+6PuOsyxEAYXQ4WPn00ireGV
	AA8kO1LrvsMTptTudllhsoxP6g+fyWrAtkoiy9w+1D/Z2DuQJ96HR3Q+lapdWDl/15NfdxpwvRE
	s+E/aZ/vX8b
X-Received: by 2002:a05:600c:821a:b0:4a1:74a1:7ecc with SMTP id 5b1f17b1804b1-4a18e446ef5mr292644385e9.1.1791997171723;
        Wed, 14 Oct 2026 09:59:31 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0aaa9f9sm13247466f8f.19.2026.10.14.09.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 09:59:31 -0700 (PDT)
Date: Wed, 14 Oct 2026 18:59:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as-08j9_1C2F_N8s@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
 <as9p2uFqCQprwdnI@tiehlicka>
 <as97Nzob4XuzO9Ss@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as97Nzob4XuzO9Ss@linux.dev>

On Wed 14-10-26 09:06:00, Shakeel Butt wrote:
> On Wed, Oct 14, 2026 at 01:39:06PM +0200, Michal Hocko wrote:
> > On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> > > Kernel threads and remote chargers use high_work when memory.high is
> > > exceeded. Their allocations during reclaim can also charge memory,
> > > for example when zswap stores a page.
> > > 
> > > Without a check, the high_work worker can queue itself from its own
> > > reclaim. The pending bit is cleared before high_work runs, so each run
> > > can queue another run.
> > 
> > What does that mean really? Does this delays the actual run?
> 
> It will not delay the actual charge request. This mainly means that we keep
> enqueing the high reclaim work even from high reclaim context and can
> potentially keep wasting CPU if high reclaim is not very successful.

Hmm, so is there any practical problem if we do that? What exactly do you
mean by "keep wasting CPU"?
 
> > > Skip memory.high enforcement for charges from task context with
> > > PF_MEMALLOC set when they would use high_work. This covers kernel
> > > threads and remote charges. The memory is still charged. Interrupt
> > > charges keep their current path.
> > > 
> > > In a VM with incompressible zswap data, the worker queued itself 163 times
> > > without this check.
> > > 
> > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > 
> > The patch itself looks OK. I am wondering whether we can unify the check
> > with the existing one which forces the allocation through in main
> > charging path.
> 
> The force charge (and ENOMEM) paths bypass the memory.high enforcement
> altogether.

Exactly. Isn't that exactl what we want to achieve here as well?

> Only successful charges (done_restock label) goes through
> memory.high enforcement. So, even if we move this check in try_charge_memcg, it
> will still be a separate check before calling high enforcement function. I think
> this check is very high_work specific and better to be in the high enforcement
> function.

I meant something like the following

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..832b40ee5b6f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2653,7 +2653,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool passed_oom = false;
 	unsigned int reclaim_options;
 	bool drained = false;
-	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
@@ -2661,6 +2660,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (consume_stock(memcg, nr_pages))
 		return 0;
 
+	/*
+	 * Prevent unbounded recursion when reclaim operations need to
+	 * allocate memory. This might exceed the limits temporarily,
+	 * but we prefer facilitating memory reclaim and getting back
+	 * under the limit over triggering OOM kills in these cases.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
+
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
@@ -2683,15 +2691,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
 
@@ -2712,7 +2711,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto nomem;
 
 	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
@@ -2773,13 +2771,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
@@ -2789,6 +2780,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
+	if (mem_cgroup_margin(memcg))
+		__memcg_memory_event(memcg, MEMCG_MAX, allow_spinning);
 	return 0;
 
 done_restock:

-- 
Michal Hocko
SUSE Labs
