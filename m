Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E45B4C10D1;
	Mon, 21 Sep 2026 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790013483; cv=none; b=T0LwsbojI20UAoXb7qesBiKE5MtdLMmSBfaLQuz5pDpm8Jug3VNj13OD0CzVWXjkc3IBA53V/BiyHGOxF69UavTzQMagt+B7LcvN6VdSO4VVIaRbgK28U5cydAWJjvXDMiOv7aeAavnmfQFiGoL15BGWyFBPVVacuFS7r1p6g7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790013483; c=relaxed/simple;
	bh=ACnVqDRu9L4EX0PIQzq+ln5rZQhr/h9DYNn8XFGJUm8=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PSmAaMr63TIImloQBey7PlsTzEu9Q8Lea+xGZucoESd88z9lbuC64RO2MNlEHcx0b3zct4FZsVNfqWFyaq89h0YkUr1avJWWg65J7n7er8nJW/dEUCh0JGUMxhAlxF1RbFgZpJzbHGOuM386a9jGJlXJ9Ast31TuzXMsq2kMcbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/sDK9og; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/sDK9og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904521F000FF;
	Mon, 21 Sep 2026 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790013481;
	bh=VrEKRxhpsxO4YB1Z88WoC1VfhzGFQ3EMsTjDujrRO+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/sDK9ogDpGJxJewL8iIUth9DWQnev+2MEzZXFhD0YypTxIon+lddkV/B5MiXsboO
	 byMrkKP0wfUx7XngMjTu9nAl2JaQK7zF3Phju/+ez58bU954kYLbxc8z3/4Vc0WgzQ
	 KOftHb5AUK5N9gFffvyEvRM47sRdl27CRx18LUuqQktKtMjB9/XICkbjwojAmHMCx0
	 IOUpxI7tR5Dak2iI8yZqV+B2DzvoXQOeYv7BXJA3uNEFbHCW1NXGE79SgsXboqYDFB
	 G+yzrNcbI31AM4MpDGbVDD6WgYVtVj6uG6HlTqlFELJEHb+bHt6BsCAnyTE5hCf2DX
	 y4CbMiaMOzh0w==
Message-ID: <b15c63490f9164bf46d68ff3ec5dfc02@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, tj@kernel.org,
 akpm@linux-foundation.org
Subject: Re: [PATCH v7 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
Date: Mon, 21 Sep 2026 07:55:17 -1000
In-Reply-To: <20260921120658.1627992-3-sunjunchao@bytedance.com>
References: <20260921120658.1627992-1-sunjunchao@bytedance.com>
 <20260921120658.1627992-3-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Julian.

This is an AI review. The series was built here, and the bdev reference
across a racing last close and disk removal, the slot races, and the
css_free ordering were traced and look correct. Two behavioral notes and
some description and comment fixups.

On Mon, Sep 21, 2026 at 08:06:57PM +0800, Julian Sun wrote:
> Use fixed per-memcg slots. Tracking is best effort: record only dev_t

The slot policy this version adopted, oldest-first replacement, expiry
after dirty_expire_interval, and re-arming when the mapping is dirtied
while a flush is in flight, isn't stated anywhere. Can you add a sentence?

> If allocation fails, retain the existing foreign-wb path.

Andrew found this unclear on v6 and the subject is still implied. Something
like "If the workqueue can't be allocated at boot, bdev inodes keep using
the existing foreign-wb path."?

> This primarily affects filesystems that keep metadata in the bdev page
> cache, such as ext4 and other buffer_head users, rather than the usual

The branch keys on sb_is_blkdev_sb(), so buffered writers of raw block
devices are covered too whenever the bdev inode's wb belongs to another
cgroup. Worth a mention.

> +struct bdev_frn_flush_ctx {
> +	struct work_struct work;
> +	dev_t dev;			/* for bdev inode, device hint */
> +	u64 at;				/* last recorded dirtying time in jiffies */
> +	atomic_t inflight;
> +};

It sits next to memcg_cgwb_frn and is memcg's, so maybe memcg_bdev_frn?
"for bdev inode, device hint" doesn't say what the value is. Following the
sibling's comments, "dev_t of the foreign bdev inode", and @inflight could
use one too.

> + * For non-bdev inodes, when a foreign page - a page whose memcg and
> + * writeback ownerships don't match - is dirtied,
> + * mem_cgroup_track_foreign_dirty() records the inode owning bdi_writeback
> + * on the page owning memcg. When balance_dirty_pages() decides that the
> + * memcg needs to sleep due to high dirty ratio, it calls
>   * mem_cgroup_flush_foreign() which queues writeback on the recorded
>   * foreign bdi_writebacks which haven't expired.  Both the numbers of
>   * recorded bdi_writebacks and concurrent in-flight foreign writebacks are
>   * limited to MEMCG_CGWB_FRN_CNT.

The flush sentence and the slot limit apply to both paths now, so the "For
non-bdev inodes" scoping reads wrong. Maybe keep the original paragraph and
let the new one state only the difference: separate MEMCG_CGWB_FRN_CNT
slots keyed by dev_t, flushing only the bdev mapping, same expiry.

> + * These wb/bdev_inodes records only remember IDs and don't hold any object
> + * references. As being wrong occasionally doesn't matter, updates and
> + * accesses to the records are lockless and racy.

The paragraph above already says the bdev records hold no references, and
"wb/bdev_inodes records" doesn't parse. "Both kinds of records only
remember IDs ..." would do.

> +	if (memcg_bdev_frn_wq && bdev_inode &&
> +	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
> +		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
> +		return;
> +	}
>
>  	trace_track_foreign_dirty(folio, wb);

With this patch alone, foreign dirtying of a bdev folio no longer hits
track_foreign_dirty at all and patch 3 adds the call back inside the
branch. Can you keep the tracepoint firing on the bdev path here so that
patch 3 only adds the argument? Also, @bdev_inode can't be NULL:
__folio_mark_dirty() checked folio->mapping under the same lock and
folio_account_dirtied() already dereferenced mapping->host.

> +static void bdev_frn_flush_work(struct work_struct *work)
> +{
> +	struct bdev_frn_flush_ctx *ctx =
> +		container_of(work, struct bdev_frn_flush_ctx, work);
> +
> +	bdev_flush_by_dev(ctx->dev);
> +
> +	atomic_set(&ctx->inflight, 0);
> +}

The in-flight window is now just the submission of the bdev mapping, and
mem_cgroup_flush_foreign() runs on every throttle-loop iteration, so a
memcg that keeps dirtying and throttling requeues the flush back to back.
A folio the flush redirties, e.g. a buffer locked by a jbd2 checkpoint
write, re-stamps the slot on its own. The old record stayed in flight for
the whole owner-wb work. With a journal the write cadence of hot metadata
is still bounded by the commit interval, but for nojournal ext4 and other
buffer_head users it's bounded only by the throttle pause, for every
tenant of the filesystem while any tenant throttles. Not measured. The
description covers the target size but not the cadence.

Each pass also goes through wbc_attach_fdatawrite_inode() and
wbc_detach_inode(), so it votes in the bdev inode's wb-switch detection
like the owner-wb flush did, at the higher pass rate. Whether the bdev
inode ends up switching wbs more often is an open question.

> +		if (memcg_bdev_frn_wq && time_after64(ctx->at, now - intv) &&
> +		    atomic_cmpxchg(&ctx->inflight, 0, 1) == 0) {

Records are only created when the workqueue exists and @at stays 0
otherwise, so the wq test can't be false with a live record. Fine as
documentation, but the cover lists it as a fix.

> +		INIT_WORK(&ctx->work, bdev_frn_flush_work);
> +		atomic_set(&ctx->inflight, 0);

memcg is zero-allocated, so the atomic_set() isn't needed.

On patch 1, the kerneldoc's "does not wait for all I/O to complete"
understates it, the flush waits for nothing.

Thanks.

--
tejun
