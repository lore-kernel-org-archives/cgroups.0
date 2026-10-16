Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736BC1D432D;
	Fri, 16 Oct 2026 21:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792186106; cv=none; b=OOB0Oi30ZqAQqp5SPQGXKQJ5oYVUoUghjF09DavbmBxtsKMjYqK+mTdgNyCYxMYZGxa49GLPV5krQ3rP+xo2kptUHXzXH8rsdwgSv42xiiviYIgdwCYJWkm0JKz/mymWKxFuYmAh7XScRxw8uKhxQwX8t0+C4yU9MTm5C63pjnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792186106; c=relaxed/simple;
	bh=3yW94EvGIctt7sRzx8qc6G7IIBlQRjys8xk0V6EgEBM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=AHbmIyFyybzcTorQT6eAH5WMXzCjEv2MB6PqWXFr0lru7n9Gmb0WQDqjHtlTFbu7yyC/0B45elOSLbODnD3ujMrK0NPOiA2ZhGAabZZVNDjgSnj3aEVIMfhj4y/pdO6/Sh03eiP/Hpal4fGVSmiWjUij/EWaP/tDIFFmFbQvsqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bhK5CACk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bhK5CACk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F8E1F000C4;
	Fri, 16 Oct 2026 21:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792186105;
	bh=YL8v3ikz/W8u+Qt9X03/iAXSAmcRvygnsgXdC5kGQwQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bhK5CACkCHQDF66EDC8C2pABK4CFbYwJawdxJRRT3/v6QK1aLVKO+9lIN7vy4Z2pA
	 PQpGUx1JRAQOh4Sk1x98fZuPu7U3alrLDAMglVo077+b7R3JWIHvvtrnagJXXVSDgP
	 zNmSiXjqu4MWnj+UDkMBE/ZNGCY974pVR9pOccNupA4QGF8KKo3F777YSClX1cNHF6
	 ekKkbFdHbFpcZWn4mzly4QAn52eanzAZ+cu7su5MG3XFiK37Wg+SgjX9lHsez7fqO/
	 K87QMoeOKB4hqBGKX16vjjWoLNfRoR63BJAf7rG3xAQxjOAZepRXSWVTIlho1A2+lt
	 OIa1G1c5NFUIg==
Date: Fri, 16 Oct 2026 11:28:24 -1000
Message-ID: <29b280c82730b879e5f3ccdb35639ead@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ian@honeycomb.io
Subject: Re: [PATCH] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
In-Reply-To: <20261015114307.1041273-1-lizf@honeycomb.io>
References: <20261015114307.1041273-1-lizf@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Liz.

On Thu, Oct 15, 2026 at 11:43:09AM +0000, Liz Fong-Jones wrote:
> Trigger: a wb has lazytime-dirty inodes on b_dirty_time when a sync
> starts, an inode on it gets a timestamp update after the sync's cutoff,
> and then its memcg (or, if the wb is already dying, any memcg) is
> removed, which runs cleanup_offline_cgwb() on it before the sync work
> queues inodes.

The late inode has to be one without a pending lazytime update. One
already on b_dirty_time keeps its position and dirtied_when.

cleanup_offline_cgwbs_workfn() skips wbs with anything on b_dirty, b_io
or b_more_io. So the scan has to land between wb_writeback() fixing
dirtied_before and taking list_lock for the first queue_io(), which is a
few instructions. The exception is a multi-pass drain that started
before the wb got dirty IO, as the loop doesn't recheck. Maybe say that
the window is narrow so that stable can weigh it?

> Once an isw fills before the scan reaches a newer inode, or a later pass
> walks past it, older inodes land in front of it on b_dirty_time.

A pass keeps the inodes it walks in order, so the only reordering is
between the walked inodes and the ones a filled pass didn't reach. "or a
later pass walks past it" doesn't seem to be a separate case.

> Tejun spotted this reordering racing with a sync on b_dirty in a patch
> under review and suggested holding wb_switch_rwsem for read across that
> scan [1]. cleanup_offline_cgwb()'s scan of b_dirty_time needs the same.

The description is pretty long for a six-line fix. Maybe drop this
paragraph, which Suggested-by and Link already cover, move the test
details below ---, and tighten the rest?

> +	/*
> +	 * The scan reorders b_dirty_time.  Keep it out of a sync's way, which
> +	 * could otherwise miss timestamps moved past its cutoff.
> +	 */

The inodes' dirtied_when doesn't change. What moves is their list
position. Maybe something like:

	/*
	 * The scan moves walked inodes to the newest end of b_dirty_time,
	 * past ones it didn't reach. If one of those was dirtied after a
	 * sync's cutoff, the sync's queue_io() stops there and misses the
	 * moved ones. Exclude syncs as process_inode_switch_wbs() does.
	 */

None of the above is blocking.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
