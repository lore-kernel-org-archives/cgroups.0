Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5D3644C1
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 20:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788467376; cv=none; b=BYowiA9CITKoymwCSSjeIsEm1T75eY4XOtU/zMoUuK5j2SWVTtWER3P4DwxNd4HUI/vv2ugcmoCdJ+i88p0xwWR2mFQQ98RBrz2tNo7Vsl8afCmsQ0XaauPdojLwfQ/sZc1jeQ34GVvJqnu5NaGgfMz2TPqFt20K/8cuPBtT+r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788467376; c=relaxed/simple;
	bh=kWDboPW1DkDZ/GZyLcRXS+15jbd32DvrhgHPd2IbYDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mverMW3/qnMYAt89X16eEkOZqMrBlOTy2vgHRpUMxoFjB2u+PdRVW8YaLvAmfJEaEMsr/JMFyDfmVQxAm4/miFfIBY9xKM4MF96OHFu1tM8ZPxL8bqYBcf7oM4D/Hia+k586QA9GqUMInfRJ8T4FQErCdZyv9eyKFNcX/MsEVJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=If3TwaPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="If3TwaPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF851F000E9;
	Thu,  3 Sep 2026 20:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788467363;
	bh=345y6CZtFGlCHyHHMSkZRxvx0a17X3ZelXVrjUdMfG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=If3TwaPD9N+4ZsolxPiDB2fhxUQI6avIDBpLH82GsRUPq/oSiQb3PiZfiDAsu8ROe
	 xcR/ich1UxcK74iPqSqKppXn4jdQUbkS39GbeGw8wuECH9n1VXBewTmqFYTJWucv9P
	 zkL1oIND43X8oL3VGYP9duQmWjtYgbPH0IukaamsG7iS3IPpG1rBsiA8Wia9vkrCkL
	 kDTk07r1fHOI1wxYiUjAENnSMTTmiH+UtkES1gwEm2U2fEtKzpLwJme6N8GwwqXO/r
	 44Ujc7LKT0wPhr62YaqK4517WmaSogOQHilQjmXMd5wRtyxvYBmxcE4Y6k1VBsOfhy
	 46CSoLbTG5HmQ==
Date: Thu, 3 Sep 2026 10:29:22 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
	jack@suse.cz
Subject: Re: [PATCH v2] writeback, memcg: skip foreign dirty tracking for
 bdev inodes
Message-ID: <apnYouiUINQR-98e@slm.duckdns.org>
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903083303.2769873-1-sunjunchao@bytedance.com>

Hello,

On Thu, Sep 03, 2026 at 04:33:03PM +0800, Julian Sun wrote:
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

Was this reproduced from an actual workload with adverse effects? If so, can
you please explain the workload and effects with concrete details?

> Skip foreign dirty tracking when the folio mapping's host inode is on the
> blockdev pseudo superblock. This prevents bdev-originated records from
> triggering later foreign flushes.

If you do this, tho, that means now cgroups that accumulated a lot of
metadata writes on ext4 and crunched for memory don't have a way to relieve
the pressure outside of periodic or other lucky flushes. ie. I have a hard
time judging whether this is net plus or not without learning more about how
this patch came to be.

Thanks.

-- 
tejun
