Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699A0494805
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141207; cv=none; b=p940uu8GxQQA4XcooPRCqIxwVv4vLfv5YVWCPuEm43X/DMjiXQivcpo19Znah5z3DPDnsYWoojtE8pWgS+g4wqMpXjGGez3l2Hq75SG0tZHEjLXfUKe2LiC/SN6vfZn9S0vB4qiT8PE7RCgygEKZj1whRD6rMIo0QVhbk65twGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141207; c=relaxed/simple;
	bh=1He2/t8OT3FakPV+P9CEM1nIM8aG+N1AP18rk4PIg6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EG25ReVSfKQ/ws0YnNKqThjAnFqoDwCTUpqUQQAp0Q5pUX3yWaNgZgDIvy3IUuR/uYCrGbg4iBibDXrXuMo7oiiVOyeRW7GcdiFBLjf2LXwlY5TLTSVIKL+HJoLr64D3TpYc+oz2ACBFlkmuEgd/UYM93T3ye/CNbNJCvUBj56c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yRG5ex+E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ibyTuXKy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RkpCoSdf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/uV3tk5l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yRG5ex+E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ibyTuXKy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RkpCoSdf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/uV3tk5l"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B72D421998;
	Fri, 11 Sep 2026 15:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789141191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISisgtuP+E44Yh84wawy3XFCNcwKdHPChIXb+WWrbb8=;
	b=yRG5ex+EgB7JBx7GgoY0xMIivNvnNeF+/ahkrQ6RI9VUTThFlHzeUDfRkQD79gt6PAZZRo
	QB9V1ct50L9FC6VBPHoyNtADtG3BzCnvgr/9kKHl/D6/CBK2EI6+uIc607aqyPkMK/oi43
	glGziJW/osokEeiCZUnyi0qDUuAxPbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789141191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISisgtuP+E44Yh84wawy3XFCNcwKdHPChIXb+WWrbb8=;
	b=ibyTuXKyLcMMID8pqMigaGopxJtiBJpdeCCWE2u61T/OgIVLnkEZbVXEK/xnidGY8NiTND
	8W55H2ZR3gYX40DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789141187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISisgtuP+E44Yh84wawy3XFCNcwKdHPChIXb+WWrbb8=;
	b=RkpCoSdfSHWj1fcGtwrDhT62/fsH7xBwSZ2zrwPbNGs6VmbGZdwjTzYiJjy1F8iWLGBvkD
	HpKgVD9dSpdoEI/pxQHyekwgrbZpWyVejI0I2fyfmaw5BHlfbNhSdIW2QUoPpjnAjn90qZ
	ze/kVeQhZNqGHOU663uUKvS9yhMyTgQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789141187;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISisgtuP+E44Yh84wawy3XFCNcwKdHPChIXb+WWrbb8=;
	b=/uV3tk5lQuLMBGbwQPAkn0EVQUwb3BC4zkQwrUMFqeDPefyjym38hC1nKr16gCgXqmQx+B
	FQZIBaAwPIhJgqBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58E82136ED;
	Fri, 11 Sep 2026 15:39:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1CI+FcMgpGp/QgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 11 Sep 2026 15:39:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DB29DA079E; Fri, 11 Sep 2026 17:39:31 +0200 (CEST)
Date: Fri, 11 Sep 2026 17:39:31 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	axboe@kernel.dk, tj@kernel.org
Subject: Re: [PATCH v3] writeback, memcg: skip foreign dirty tracking for
 bdev inodes
Message-ID: <l2awpukcp7lorvujvwdoqnlwlkkjl6e2kef6tnjvdw7qve2fni@vh4lspozoytt>
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
 <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
 <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
 <ekylbhyzseq25nxq2yivmmdt5xl5glum5proueyd5mrqfux2y6@fpvflg4crr2i>
 <db6d62f4-34f0-4237-ab58-c21b0968bee7@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db6d62f4-34f0-4237-ab58-c21b0968bee7@bytedance.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO

On Fri 11-09-26 19:39:42, Julian Sun wrote:
> On 9/11/26 7:20 PM, Jan Kara wrote:
> > On Wed 09-09-26 21:18:11, Julian Sun wrote:
> > > On Wed, Sep 9, 2026 at 7:13 PM Jan Kara <jack@suse.cz> wrote:
> > > > 
> > > > On Wed 09-09-26 11:43:43, Julian Sun wrote:
> > > > > The expectation in wbc_detach_inode() that "concurrent write sharing of an
> > > > > inode is expected to be very rare" does not hold for bdev inodes. On ext4,
> > > > > metadata from many memcgs shares the same bdev inode, so dirty throttling
> > > > > in those memcgs can repeatedly trigger foreign flushes of the owner wb.
> > > > > These flushes can also write ordinary file data, reducing overwrite
> > > > > coalescing under continuous buffered overwrites. The resulting extra I/O
> > > > > leaves less device bandwidth for other workloads.
> > > > 
> > > > Hum. Are you aware of [1]? The guy is from the same company so I was
> > > > assuming you two are working together on the problem :).
> > > 
> > > Yes, Xin and I are on the same team, and we are looking at different
> > > ways to mitigate this issue.
> > 
> > OK :).
> > 
> > > We will continue trying to gather more evidence from production to
> > > better understand its actual impact. The number of calls to
> > > `balance_dirty_pages()` and the time spent in it might be useful
> > > metrics for this purpose.
> > > 
> > > Jan, if we can show that this patch provides a measurable improvement
> > > in production, would you consider accepting it? Or do you think we
> > > should still look for a better approach? If you think there is a
> > > better way to address this, we'd be very interested in your
> > > suggestion.
> > 
> > I definitely acknowledge that there's a problem with foreign flushing due
> > to bdev inodes that needs to be fixed because as Tejun wrote, bdev inodes
> > break the fundamental assumptions of foreign flushes. But so far I haven't
> > seen a solution which I'd definitely support.
> > 
> > Having data from production to understand what exactly is the practical
> > problem will hopefully help us understand how the solution should look
> > like. Is it just that we trigger too many flushes and that slows down
> > things? Or is even one foreign flush of the whole wb due to bdev inode
> > making performance bad? Is it that we have many foreign pages and foreign
> > flushes fail to properly write them?  These are questions we need to answer
> > to decide how the solution should look like. And the solution could be
> > anything from just limiting number of foreign flushes for a wb to 1
> > (because there really isn't big point in more of them being queued) to more
> > involved foreign page tracking for bdev inodes so that flushes can be more
> > targetted.
> 
> Hi Jan,
> 
> Thanks for your feedback.
> 
> All the foreign flushes we've observed were triggered by bdev inodes.
> What we've observed is that the bdev inode has only around 10 MB of
> dirty pages, but it triggers writeback of around 40 GB of dirty pages
> across the entire wb. The actual foreign pages account for less than
> 10 MB, yet flushing them triggers writeback of the whole wb, and this
> happens repeatedly.
> 
> This appears to cause significant write amplification.
> 
> Limiting foreign flushes to one may not be sufficient in this case,
> since even a single flush can trigger a large amount of unnecessary
> writeback. I'm currently working on tracking foreign inodes so that
> foreign flushes can target those inodes specifically.

OK, good, these are already some tangible data to use :). So in that case
I'd maybe just:

1) Avoid adding 'wb' as foreign just because it owns bdev inode where we
are dirtying a page.
2) Track that we have some foreign pages in this particular bdev inode.
3) In balance dirty pages queue flushes of bdev inodes where we have
foreign pages (besides queueing standard foreign flushes).

I didn't put too much thought into how to integrate this in an elegant way
with the current writeback infrastructure but something like this shouldn't
be that hard and it should help you with the foreign flush issues you
observe.

> The impact on production workloads is not easy to measure directly,
> which is another challenge we're facing. We've had reports of slow
> dirty page writeback from production workloads. Although we haven't
> established the full causal chain yet, we suspect foreign flushes may
> be contributing to the problem.

Just being able to measure that "with these patches we don't need to flush
40GB of unrelated data in foreign flushes in our production workloads" is
enough to convince me they bring some tangible benefit for your workload
:).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
