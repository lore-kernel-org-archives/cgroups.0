Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F536145B3F;
	Wed, 14 Oct 2026 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792004741; cv=none; b=MS+2ugcHjntUIE11e5qbaOOnFrahi5mEnOhKwnsYXBaDt2IeVU1EoNuuHGMLqfSubeeuEf6QtPA5zh2Xcpl7o40TXLVTnr/2MItykCrzf+YvWDbwgBUDLq5kTBtfF6llxCaCdOmmz01k1xSrFvQ+oXQ++zu9w0K+08YkuAITvdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792004741; c=relaxed/simple;
	bh=bqwt4easrNgYXL0S8q08n+eJvcS2ScFTvqicsmr3CJk=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VqKC9Tfq/faiLMwxUAD5qRFTdMCl9eIHVxJbsZhc+EvboGiemFLqVlBOtPEh+n0qrO5CkKBw0CeqPrQ4MFgK5waoEUkDCe+urOTdI+It8I62nfKeZU3c/IwcSeZZwxAoRZSikm/f96NTxmiWgmWK0KuI2XIBoD9Y0KQ4MeAx84U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2KwKket; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2KwKket"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FE81F000C4;
	Wed, 14 Oct 2026 19:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792004739;
	bh=YyINmxXO7pd+spEYBHJ/vCjoSEPDem460Y+EQItZG60=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T2KwKketgjd78ySIjWZfpm14SK8fmn/dOIHeg5mSexSu49wSiIFL09CZgoCSlNZmV
	 dRSwwOOBSwSht+owNr5w6EKvDRfvqfCX3RrdYlgV427de0Ct/6OnNgMEQGoNkZpZhS
	 XWq+FzHLiklU/hnG3eZKRkX5HJ1Wg8sf8lMbt9yEO3ukX4BwkRnmng/FuAXpg8ONTn
	 /dgm3svw5odmG9ltLLcFDAC/v5bC9DoVDcIRhA/kfudaDw4H/lRAY3xihqBbQM3khC
	 YVFb15bIeGtRCGC97m61q8Syu2fhAEPXlV/DeFwWk5ytvozOGNoeLdlAb74nxTwBBo
	 ROPpDl6OXoiWA==
Date: Wed, 14 Oct 2026 09:05:38 -1000
Message-ID: <0bc5d58533f10b4841807be3025daa11@kernel.org>
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
Subject: Re: [PATCH v6 3/3] writeback: switch a replaced cgwb's inodes to its successor
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-3-1991b4e2dcff@honeycomb.io>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
 <20261002-wb-dying-cgwb-flush-v6-3-1991b4e2dcff@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Liz.

The following is a Claude-generated review.

On Fri, Oct 02, 2026 at 09:40:48PM +0000, Liz Fong-Jones wrote:
> + * Switch all inodes attached to @wb, dirty or not, to the wb that foreign
> + * flushes now find for @wb's memcg.  If that one is already gone, fall back

The scan only reaches inodes on @wb's lists, so any inode attached to @wb
but on none of them stays behind, not just one from the
__inode_attach_wb() race. A clean inode switched over from the root wb,
which keeps clean inodes off its lists, is one example. Maybe say "all
inodes on @wb's lists" here and broaden that sentence in the description?

> +	spin_lock(&wb->list_lock);
> +	restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_attached, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_more_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time, &nr);
> +	spin_unlock(&wb->list_lock);

With f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by
rotating scanned inodes") on mainline, isw_prepare_wbs_switch() moves
every scanned inode to the newest end of the list, and wb_switch_rwsem
keeps switches from landing during a sync but doesn't cover this scan.
On b_dirty, that can make a sync miss data:

1. A background work on the replaced wb yields to a sync_inodes_sb()
   work and leaves inodes on b_io.

2. The sync work fixes dirtied_before at entry but doesn't queue_io()
   until b_io drains.

3. Meanwhile, the memcg dirties a clean inode, which goes to the head of
   b_dirty.

4. This scan fills an isw from the tail of b_dirty and moves those older
   inodes in front of the new one.

5. Their switches block on wb_switch_rwsem, which the sync holds for
   write.

6. queue_io() stops at the new inode, so the older ones, dirtied before
   the sync started, are still dirty when it returns.

Maybe hold wb_switch_rwsem for read across the scan?

> +/* called with cgwb_lock held, possibly with interrupts disabled */

cgwb_lock is always taken with irqs disabled and lockdep_assert_held()
already says the rest. Maybe drop the comment?

> + * cgwb_kick_replaced - switch inodes away from @wb again if it was replaced

This queues replaced_work rather than switching anything. Maybe "queue
@wb's replaced_work if @wb has been replaced"?

Thanks.

-- 
tejun
