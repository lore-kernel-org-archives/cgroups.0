Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3416D3CF976
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 11:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789125623; cv=none; b=rY6m9bIKOd3cKch1FKyJ21CrHIb5fANbhTQsq4dqUft2Wi9xyFpntpYlLpkpCziQFCReE1qf+o49aH8bVTMwXlxIs5UXTTyT1MpA5teZTBeCtedNP8d2xDZdJCSlQf6YlI3QESngSrb91DBmq8x+Fd+mA6cipJRDvEArleg1HO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789125623; c=relaxed/simple;
	bh=mounJEJpqAqAJiHMUyFE2b3MjHjfrGGGPtzek9Mnj5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfOgewW9Auw4MHyYPm7GvpV1F3mv4/nZjQ/v/OcYylLN/pNaW1VZJeCy+U/eMZDbBqgMwRlTMggKy27CKLpmOwts1V7ckW5Fed11HRDQei9xi9Ff+F03X1D7RUuna/vqYG0YNTcCnMQqcz2x8xESsh3/ehyHm9qL0oOK3vVLNuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a4nwf5Aa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=71OVCowj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pKY2NinR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aFf3cNsi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a4nwf5Aa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="71OVCowj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pKY2NinR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aFf3cNsi"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CD16D21AB4;
	Fri, 11 Sep 2026 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789125616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cF050pABNTWd4QPvjkP8yXRmzSxGQTtL7sVvE8V5RnU=;
	b=a4nwf5AaXnoivV006w6a9h7Fur3fmXGif41Sc+QaSolO3OYu8rWO6MP4W4zs+X5QeW5jLE
	1o2z6G1py8XUq/5xw96ZKarB3cna2DEUJuzw59r+/qQslV0RXK9UGgSDU2Y178yOp/ULGv
	bWxnii0/DTEdGguPPU/VHB+xVYAZv80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789125616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cF050pABNTWd4QPvjkP8yXRmzSxGQTtL7sVvE8V5RnU=;
	b=71OVCowjfvzjEv7JxVBYWE6n9QqdAePvuVH1lt8I6NDVePP2xdJPEzevN3P1D5mnKKbhVD
	HXmpBdGkZu5ydSBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789125611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cF050pABNTWd4QPvjkP8yXRmzSxGQTtL7sVvE8V5RnU=;
	b=pKY2NinR2PoinIesd9mBmfQ4kzKhAD8tC8hNsjq6VXge+uYHLVyRuRDvJneApYUy3jZiSQ
	S4T8Q0REpOmhFMOPPZ1WYKGfeB1pSC0l8vUY95jHdg44R54MFEvJnQ5d70KAUaHWGXEeiO
	huZ05WumTahepvc1aaoT13Ehes30sds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789125611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cF050pABNTWd4QPvjkP8yXRmzSxGQTtL7sVvE8V5RnU=;
	b=aFf3cNsiYVucLkMBqwe9QnC3/fUHRXbUySgfDH301JmskDCpKw3+OfpwgHURmw9XpJlQ4y
	ALffrM7qLihmJCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1BB1132D3;
	Fri, 11 Sep 2026 11:20:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cIl3J+vjo2qpNwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 11 Sep 2026 11:20:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2F5FEA1342; Fri, 11 Sep 2026 13:20:07 +0200 (CEST)
Date: Fri, 11 Sep 2026 13:20:07 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	axboe@kernel.dk, tj@kernel.org
Subject: Re: [External] Re: [PATCH v3] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
Message-ID: <ekylbhyzseq25nxq2yivmmdt5xl5glum5proueyd5mrqfux2y6@fpvflg4crr2i>
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
 <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
 <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO

On Wed 09-09-26 21:18:11, Julian Sun wrote:
> On Wed, Sep 9, 2026 at 7:13 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Wed 09-09-26 11:43:43, Julian Sun wrote:
> > > The expectation in wbc_detach_inode() that "concurrent write sharing of an
> > > inode is expected to be very rare" does not hold for bdev inodes. On ext4,
> > > metadata from many memcgs shares the same bdev inode, so dirty throttling
> > > in those memcgs can repeatedly trigger foreign flushes of the owner wb.
> > > These flushes can also write ordinary file data, reducing overwrite
> > > coalescing under continuous buffered overwrites. The resulting extra I/O
> > > leaves less device bandwidth for other workloads.
> >
> > Hum. Are you aware of [1]? The guy is from the same company so I was
> > assuming you two are working together on the problem :).
> 
> Yes, Xin and I are on the same team, and we are looking at different
> ways to mitigate this issue.

OK :).

> We will continue trying to gather more evidence from production to
> better understand its actual impact. The number of calls to
> `balance_dirty_pages()` and the time spent in it might be useful
> metrics for this purpose.
> 
> Jan, if we can show that this patch provides a measurable improvement
> in production, would you consider accepting it? Or do you think we
> should still look for a better approach? If you think there is a
> better way to address this, we'd be very interested in your
> suggestion.

I definitely acknowledge that there's a problem with foreign flushing due
to bdev inodes that needs to be fixed because as Tejun wrote, bdev inodes
break the fundamental assumptions of foreign flushes. But so far I haven't
seen a solution which I'd definitely support.

Having data from production to understand what exactly is the practical
problem will hopefully help us understand how the solution should look
like. Is it just that we trigger too many flushes and that slows down
things? Or is even one foreign flush of the whole wb due to bdev inode
making performance bad? Is it that we have many foreign pages and foreign
flushes fail to properly write them?  These are questions we need to answer
to decide how the solution should look like. And the solution could be
anything from just limiting number of foreign flushes for a wb to 1
(because there really isn't big point in more of them being queued) to more
involved foreign page tracking for bdev inodes so that flushes can be more
targetted.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
