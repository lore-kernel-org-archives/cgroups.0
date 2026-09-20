Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAD143DED9;
	Sun, 20 Sep 2026 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789907893; cv=none; b=o2A09PuuUssap0htTyZVCcT4R9mu6IZC6zhYTDMH2ULwHkGxAh/zeD1N3nBo8lWsBBmVoVErpoxC//TLAPboaBTkPLRMHf+Iis2w2RhvVrHnhYuJzswIEbAZ508vE6dPQKXPIBxBRMhjcFN08OzSxFBumMyAKfy5JqHfDQJCa98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789907893; c=relaxed/simple;
	bh=qqllzSvWdnqpBfqHONybq1LFWlpsTlV7xqOhXtAC8ag=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=uMJum5bmEr6snpyd9bk3S3EuOerunDjoj3clghVxsMsjiY/ioZuvEANauJH9O6q2V8YC6d8sUFmRDZKDQfd+biqq8kAxctvjXJgVy1dinMpC/LHudgL+d2QxePOWN+pagZPOJ5OOBhOoHsoMbmxm5WmzjaTAgjUGWCLwPe1wdS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzRdHciK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzRdHciK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40FE1F00893;
	Sun, 20 Sep 2026 12:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789907877;
	bh=mJsWGBtB6Jmto8DEzZ2y0wDci2YhQdizpVycyPmDhK0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VzRdHciKS1keY3iQi9SFZNCz1KV7/Ah55tDvKdZXTr5m8bGGeqn/s033sD58PhgIy
	 TfPrqGNOi7LjtXtgCutOGzPRAJZd45t5n4H1V1kR2NE5cgppgASisfIOm18ItWwGqG
	 YKByiV76Sx5uB6EYvm6oCPDQVNUH149ja80rHzVGxq5cSuvq1CWo+PaQJwNeBx4T/U
	 rb8FTL7vE18NDxitJ1BDuusxWO458ObxKwLqApe8wdYKsbM7CR+QvG2s+LzyBaxSvv
	 sMbO1bEWWfhj7wK8bPK9jgyjryTqIilpQREp60zmEBFiaP/SyD5LMSX3wZVFyymDM2
	 p2zEN6UTMbCow==
Date: Sun, 20 Sep 2026 02:37:56 -1000
Message-ID: <73204ebd8b41871c263e99196ee7fbf1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH v6 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
In-Reply-To: <20260917070119.2648123-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
	<20260917070119.2648123-1-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Julian.

On Thu, Sep 17, 2026 at 03:01:18PM +0800, Julian Sun wrote:
> Bdev foreign flushes can be triggered frequently. Use a dedicated
> workqueue to avoid interfering with tasks on existing workqueues. If
> allocation fails, retain the existing foreign-wb path.

Work items on an unbound workqueue don't interfere with each other beyond
max_active, so this isn't a reason for a dedicated workqueue. Wanting a
separate max_active pool for up to four long-blocking items per memcg is,
if that's the intent. Can you update the rationale?

> Use fixed per-memcg slots, with a shared lock protecting device records
> and in-flight state. Tracking is best effort: record only dev_t without
> holding device or inode references. Skip closed devices or devices whose
> open_mutex is busy. Device removal and device-number reuse may race with
> lookup.

Andrew asked why dev_t rather than a reference. The reasons you gave in the
thread belong here: the record is written under i_pages with IRQs off,
dropping a bdev reference can sleep, and a memcg that never throttles would
pin the device indefinitely.

It'd also help to say who this affects. Only filesystems that keep metadata
in the bdev page cache, so ext4 and the other buffer_head users but not
xfs, btrfs or f2fs. And that the decision is still blind to how much of the
memcg's dirty memory is actually in the bdev, so one dirty bitmap block
still flushes the whole mapping each time the memcg throttles.

> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")

This is new development rather than a fix. Maybe drop the tag? Patch 1
doesn't carry one, so a stable pick of this patch alone wouldn't build
anyway.

> +static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)

This lands above the "Foreign dirty flushing" overview, which now says
nothing about the bdev path. Can you move it below the overview and add a
sentence there?

> +	/*
> +	 * Tracking is best effort, so losing hints when all slots are occupied
> +	 * is expected.
> +	 */
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		ctx = &memcg->bdev_frn[i];
> +		if (ctx->inflight)
> +			continue;
> +		if (slot < 0)
> +			slot = i;
> +		if (!ctx->dev) {
> +			slot = i;
> +			break;
> +		}
> +	}

When all four are occupied this always evicts slot 0, and the comment says
the new hint is dropped, which isn't what happens.

Why not follow the cgwb_frn style? A timestamp per slot gives oldest-first
replacement here, expiry in mem_cgroup_flush_foreign() so a record from
long ago doesn't fire a flush when the memcg finally throttles, and
re-arming when the mapping is dirtied while a flush is in flight, which the
worker currently forgets when it clears the slot. It could also drop
frn_lock. An atomic in-flight flag on the work gives the same guarantee
done.cnt does, and a torn read of dev or the stamp only costs a wrong
best-effort flush, which is already the deal.

> +	if (memcg_bdev_frn_wq && bdev_inode &&
> +	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
> +		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
> +		return;
> +	}

Patch 3 moves the trace call below this. Might as well put it there here.

> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		struct bdev_frn_flush_ctx *ctx = &memcg->bdev_frn[i];
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&memcg->frn_lock, flags);
> +		if (!ctx->inflight && ctx->dev) {
> +			ctx->inflight = true;
> +			queue_work(memcg_bdev_frn_wq, &ctx->work);
> +		}
> +		spin_unlock_irqrestore(&memcg->frn_lock, flags);
> +	}

If the lock stays, one acquisition around the loop is enough.

> +#ifdef CONFIG_CGROUP_WRITEBACK
> +	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
> +					    WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
> +	WARN_ON(!memcg_bdev_frn_wq);
> +#endif

WQ_MEM_RECLAIM is for work items that memory reclaim depends on to make
forward progress. Nothing waits on these flushes. The throttled task just
sleeps and re-evaluates, and the bdi flusher remains the path that's
guaranteed to make progress. Can you drop the flag?

Thanks.

--
tejun
