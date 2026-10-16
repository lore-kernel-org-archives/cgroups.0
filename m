Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EB03C3438;
	Fri, 16 Oct 2026 22:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792190587; cv=none; b=T0PB13VeoQVhW/kwaNzYcS4t9KaaDmdJxPt+CIaV/64+aoGkoMzrakfod/lUkFibHERFYrVVnL3gMwZXlWV/2KWNLVrB5FH6BuYSKxf5RiFOsdarPQ1YB7iSpGOkSo5i4iSZaILsBuj8zqhHZkdbw38qSTYYVTXziy2FTUHrhbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792190587; c=relaxed/simple;
	bh=ky2kLmBQQDcgrQXuI9eZ052lL7tMjJhSAyVsflieb7Y=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=alHcV0V11mGxSc3g6Oq1vrDbVINyb/WAhYMniavBeZOBPnC2sZ7eUMpAihR6LDTp14Q7xhmOOpGBEBMSec7x+8z00GCnsGaf5NGaKGeq8jmJkj9/x7+GHVHbUH4Fn+88repbA45aDd3r8166sIJm4yk7v04GllImye2agyY8P8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiEujQYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiEujQYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759871F000C4;
	Fri, 16 Oct 2026 22:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792190585;
	bh=/hZbe7RB6+Bi29L6udyhEOuf33yUa63JOrb9nCRpHA0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YiEujQYpBQlsJbuSzPmj1eHQzFwASacSFLqspUDQfuGBomyDFTF6yeOvLbe23tcoY
	 IlTTCXTUid1xqaP3KqVpUaidLGlF1o5isUFYE90qUG95Hd/b/EbY9KL0DpcG1BnAth
	 hPwdkPC1Y60vW2KIxTIFox/PqXwVBfGHcaAAQeeRNUBvpkOV7Jtb87HnOm4/TL1BgS
	 F6mQZm0XbqeN6vsjKKp3YAOYVcRJwaFVQlSZSV/XOtz9KDiL/v1EX6W1Fk5tm9tL+B
	 zmF0lWKFVetyjRqk0im1FD6ObKpRD98kBZN4rGXoJ+EjUR4EL24DAhIPZXDFRomxTn
	 s/9xa0XIQifPQ==
Date: Fri, 16 Oct 2026 12:43:04 -1000
Message-ID: <97f9db644113ce22a7e302d1b79bcfd3@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v7 3/3] writeback: switch a replaced cgwb's inodes to its successor
In-Reply-To: <20261015-wb-dying-cgwb-flush-v7-3-9278d9ebaf5d@honeycomb.io>
References: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
 <20261015-wb-dying-cgwb-flush-v7-3-9278d9ebaf5d@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Thu, Oct 15, 2026 at 11:40:49AM +0000, Liz Fong-Jones wrote:
> When a live memcg's blkcg association changes, cgwb_create() replaces
> its killed wb in bdi->cgwb_tree. Foreign flushes for the memcg then
> find the new wb, but the inodes, dirty or not, are still attached to the
> old one, and they only move over as they are written back (see
> wbc_attach_and_unlock_inode()). Until then, other memcgs appending to
> those inodes stall in balance_dirty_pages().
>
> After the takeover, queue a work item that switches all inodes on the
> old wb's lists to the wb foreign flushes now find, like
> cleanup_offline_cgwb() does for b_attached and b_dirty_time, but
> including b_dirty, b_io and b_more_io. The switch carries the dirty and
> writeback page counts, so nothing needs to be written back first.
> cgwb_create() can run with interrupts disabled (folio_account_dirtied()
> -> inode_attach_wb()), so it only queues the work. A switch to the old
> wb that was queued before it was replaced can land after the work ran,
> so inode_switch_wbs_work_fn() queues the work again when the wb it
> switched inodes to is dying and no longer owns its slot. Inodes attached
> to the old wb but on none of its lists, such as one attached as the wb
> is replaced (see __inode_attach_wb()) or a clean one switched over from
> the root wb, still move over only when written back. If the successor is
> already gone, fall back like cleanup_offline_cgwb() does, to the nearest
> live ancestor's wb or the root wb.
>
> Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
> rescans by rotating scanned inodes"), the scan moves the inodes it walks
> to the newest end of each list, so hold wb_switch_rwsem for read across
> it, like the switches themselves. Otherwise a sync that has fixed its
> cutoff but not yet queued inodes can find older dirty inodes moved
> behind a newer one on b_dirty and return without writing them.
>
> Test: a live cgroup appends to 5000 files on XFS at 250MiB/s, io is
> disabled on its parent so its wb is killed, it creates a file (the
> takeover), and a sibling keeps appending to its files under a 4G parent
> limit. Worst lag of the sibling behind schedule over 30s, in three runs:
>
>   without this patch    9.1s   4.0s   1.0s
>   with this patch       1.7s   1.3s   1.0s
>
> Without this patch, moving the old wb's inodes over took up to 11s,
> first switch to last; with it, all 5001 were switched in a 23-35ms
> window, with up to 98MiB of the old cgroup's pages dirty.
>
> Suggested-by: Tejun Heo <tj@kernel.org>
> Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
> Assisted-by: Claude:claude-fable-5-1
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
