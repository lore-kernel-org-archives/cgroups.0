Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2858C50C288
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 19:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788464083; cv=none; b=F0wFrF6uLvtcwryMkeq7g4yXZXPNn74/opcHSEXcZs9X++bt5mPtkLz+JNmm9m8qk/3yg1JxvkIdDHDN8NYkuBQXNdpD8HUntEJFhTesJ9nxJru4LvHrT7TGXIe0Y++21thkVhfpuqSK+ef25LMBM5eGGMoI5MdbpEPAG/0fDXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788464083; c=relaxed/simple;
	bh=isQHEi07ge6EFI0JDD+py6jjJBr/TTVzhs0gdmyR6AI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=i7NGjrt5mZznBfGx/uWMsMADkEG34QGErpaw/MCOJ/b1gfvcsuH4pLb1LmwJ3d4TdAbbmZMUel8gNutHQ/rRn1T9maKkj7+iFcfnCrHl9x343MzjkUmkuUk/OBstP+SPB1yDb/FDa17W2Kx/jupAoR6Sx/LoDmYIly7f94cZqgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gbka91Sk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gbka91Sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7616D1F00A3D;
	Thu,  3 Sep 2026 19:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788464067;
	bh=cEe0Xe4BGpisjWutg3Hd6ntpHOx/Gjz8x6DaZwu6w6I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Gbka91Sk8dHFzSVk+rS7sdjg/NU835GPWh8k5QJ1FOTqyrifht+DmIEQz7ZV98V+R
	 ZMyk+C44h1OmLiDxoEVLz7TBeY6QV6/heypUssRvfn7Fpqp+Lp/LwaYRpcc+60tjOP
	 jVq4CP/4n/HFTbW+75H5vG6rE8TqPeXSRjR6/e58=
Date: Thu, 3 Sep 2026 12:34:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, axboe@kernel.dk, tj@kernel.org, jack@suse.cz
Subject: Re: [PATCH v2] writeback, memcg: skip foreign dirty tracking for
 bdev inodes
Message-Id: <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
In-Reply-To: <20260903083303.2769873-1-sunjunchao@bytedance.com>
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  3 Sep 2026 16:33:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> Foreign dirty flushing handles cases where a dirtied folio's memcg and
> the memcg owning its inode wb differ.
> 
> wbc_detach_inode() notes that "concurrent write sharing of an inode is
> expected to be very rare". This expectation does not hold for bdev inodes.
> A bdev inode and mapping are shared by buffered users of the block device,
> while the inode has a single wb owner. On ext4, buffer-cache folios used
> by metadata and journal I/O can therefore be charged to different memcgs
> while sharing the same mapping. Normal bdev activity can thus produce
> frequent folio/wb ownership mismatches.
> 
> This was reproduced on cgroup v2 with the memory and I/O controllers
> enabled, using ext4 on a loop device. jbd2 repeatedly generated
> track_foreign_dirty events for bdev folios charged to unrelated memcgs.
> When one of those memcgs entered dirty throttling, the resulting record led
> to a flush_foreign event and queued writeback with reason=foreign_flush for
> the bdev inode's root wb.
> 
> Skip foreign dirty tracking when the folio mapping's host inode is on the
> blockdev pseudo superblock. This prevents bdev-originated records from
> triggering later foreign flushes.
> 
> The tradeoff is that dirty throttling in the folio's memcg no longer uses
> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
> folios remain subject to normal writeback. This is preferable because a
> single bdev wb owner does not identify which cgroup is responsible for a
> mapping shared by buffered bdev users. Flushing it can write back data
> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
> foreign dirty tracking for non-bdev inodes remain unchanged.

When fixing something, please always describe the userspace-visible
runtime effects.

I'm thinking probably "unnecessary I/O"?  If so, has this been
quantified/measured?  If not, can the effects be guessed about?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  	u64 oldest_at = now;
>  	int oldest = -1;
>  	int i;
> +	struct address_space *mapping = folio_mapping(folio);
> +	struct inode *bdev_inode = mapping ? mapping->host : NULL;
> +
> +	/*
> +	 * Bdev inodes are usually shared by many memcgs so foreign
> +	 * tracking leads to frequent flushes which is counterproductive.
> +	 */
> +	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
> +		return;
>  
>  	trace_track_foreign_dirty(folio, wb);
>  
> -- 
> 2.39.5
