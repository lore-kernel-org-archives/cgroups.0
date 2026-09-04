Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38C33F4DD2
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 06:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503766; cv=none; b=WM/9A79zOlT0repHA5/46xmra+z0hVPtHcCIuQ7AoYSGcyJGvMrtSp3yMqwEfUWRN/LNT1GNMhLx5PYJeOW09uyeSi1c0f9uQKTdXxQejrqcpO046FqGqcR3/D/P+OM83yAE+WqoF/nwdRFU3GQXgurgXrSBVbu0tbCfp6FGuqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503766; c=relaxed/simple;
	bh=LbLGq6/4UgYFH9Nnd4m+t/CQzejhxnNDV3wqOJuxgSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WsHrvuJdLZdq0UoM6vGerc9f+JwkhGCpqc1muxQr2FTpZS69V1c6Rv9s6fjCR1NlNdiZDWRmUgAi6PIDrzS3Z4LuLwNTCEK6GcppbuTv6UsZzT/F9ZjSBX2POCesyOKVfig/mYLvz9q5s5SF6e2S1rU9u4p0z9Pohe6q74BA7WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccJvPGio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccJvPGio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DC91F00A3D;
	Fri,  4 Sep 2026 06:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503765;
	bh=757sSow4bZxacgFES5O5/6SYu86a200KKf1Pkw+peq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ccJvPGio6PTHW6jwkb7/NDj3fTlu3lr9EJCBIJjpKQYklYtlAbrbH/O9gf79D5Uxr
	 xBFRC2IXGv7MZMdykmWd0QUR8VoUYTdYz5LnSmhs8AfdZ2L/peo0LQasEbgmjJsL9g
	 vkEZOCMnBWyGxHKB5xmpfTDyCJeop+Nq4JuRMx44E+eZ1dgr3A3HByTGOWHUocewmy
	 REvebJ08P9SuUym90fBg4dfvn+IxEFocNw0ee5YHM3gap2AhvoE4KJDNQfGJFXekPP
	 jb8zsn7dBzviwnUfFpEZpBLIf4JfhvF6j/hXlP576HaZ+PynB/iRuCLjrkpjQLXy3B
	 iiU7L7tE2xa8Q==
Date: Thu, 3 Sep 2026 20:36:04 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
	jack@suse.cz
Subject: Re: [External] Re: [PATCH v2] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
Message-ID: <appm1E4rzQQB_srX@slm.duckdns.org>
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <apnYouiUINQR-98e@slm.duckdns.org>
 <3a7ca3ba-d2e6-40a1-95b2-4d0ee93d4242@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a7ca3ba-d2e6-40a1-95b2-4d0ee93d4242@bytedance.com>

Hello,

On Fri, Sep 04, 2026 at 12:34:27PM +0800, Julian Sun wrote:
...
> > Was this reproduced from an actual workload with adverse effects? If so, can
> > you please explain the workload and effects with concrete details?
> 
> Yes, this can be reproduced on many production machines. On one production
> machine, we observed 102 wb works with WB_REASON_FOREIGN_FLUSH as their
> reason, 101 of which belonged to the same wb. This wb was the owner of the
> bdev inode, and dirty pages were continuously being generated for it.

This is the mechanism triggering.

> The logic here is that, Once a memcg has recorded the owner wb of a bdev
> inode as foreign, any task in that memcg that reaches the throttling path in
> balance_dirty_pages() may queue one WB_REASON_FOREIGN_FLUSH work item for
> each recently recorded foreign wb, up to four in total, without checking
> whether those target wbs caused the current dirty throttling.
> 
> On this machine, the total nr_pages of the foreign-flush works was
> 630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of memory.
> Although nr_pages does not represent the number of dirty pages that will
> ultimately be written back, the actual number of pages written back may
> still be very large because the corresponding wb was continuously
> accumulating dirty pages.

Is this necessarily an adverse effect tho? These are all metadata flushes,
right? When they're gonna get written might change but do the extra flushes
change how much is going to be written? If so, how? If not, are the extra
flushes adding noticeable overhead in terms of cpu or io?

> > > Skip foreign dirty tracking when the folio mapping's host inode is on the
> > > blockdev pseudo superblock. This prevents bdev-originated records from
> > > triggering later foreign flushes.
> > 
> > If you do this, tho, that means now cgroups that accumulated a lot of
> > metadata writes on ext4 and crunched for memory don't have a way to relieve
> > the pressure outside of periodic or other lucky flushes. ie. I have a hard
> > time judging whether this is net plus or not without learning more about how
> > this patch came to be.
> 
> How about this approach? Before queuing a WB_REASON_FOREIGN_FLUSH work item,
> check the target wb and avoid queuing another one if it already has an
> unfinished WB_REASON_FOREIGN_FLUSH work item.
> 
> This approach can eliminate a large number of duplicate foreign flushes, but
> one issue remains: a memcg may dirty only a small number of pages in a bdev
> inode, and when that memcg enters dirty throttling, the throttling may be
> completely unrelated to the wb that owns the bdev inode, yet a foreign flush
> is still queued to that wb. This problem becomes more pronounced when the wb
> has a large number of dirty pages. Perhaps we should track the number of
> foreign pages in the memcg and avoid issuing a foreign flush when the number
> is below a certain percentage?

Yeah, maybe, but I'm kinda having a hard time evaluating anything as the
mental picture I have of the problem is too incomplete. Please fill us in.

Thanks.

-- 
tejun
