Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E000349AA24;
	Wed, 30 Sep 2026 15:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783262; cv=none; b=FZ99+ThlczXfY+veqRb6FLfflVwFZUg6j1cK5ShDvBFNLhnzMXGITQYi3JLeTuxqumqVg2xHSPb2D/BUP/uTHfIavVjmdkRnoG+pzqtEueIv5vtalHJPWgQqd8ZsNFL5EGBmAS+P5Qq0YJ1wMEG9R7K7k9tk1lRhBr7ju/rpvWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783262; c=relaxed/simple;
	bh=QoFbyEjCsfTHVESMmjnO/0li1L1bptVdC8MzWR3qMXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCfTtYwjtlVZA4YFEjgbBHlzJEkdWnStd38LYH9QMxAfwcVSHHkgo2BPfXvznXFpXYtRYBze5gGgrlDNAuUeVPnng/9SY1Myn0f6Ejbg/LWtBJCxcmbeIeceFAFJOOI1wsC6Mix30z/yrr7ZRw+Ig4yUapfMsqLKCSSRStGaB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kbnbRj+I; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iezzI9hD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hU2ovLJx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6O7KPyP1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kbnbRj+I";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iezzI9hD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hU2ovLJx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6O7KPyP1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 95ADD21D7D;
	Wed, 30 Sep 2026 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790783251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWEmQKmmPhReb7fwoW/7UfQQaFElZ3XtfNvTjXF41Xg=;
	b=kbnbRj+IixvFQRj5EbeHLkwt0DIzrLadWWg2fQURXb9XsCxuJtMMIE1cSeNJyjKFIhJ7LJ
	hlYp83Gr12g6RUHz2UC0QbpqJiNkOwr76yiWJK/qS8LNWXDu6+nf9CIOBpb+OVT6u0Nevi
	SnRYELKASvbSUYGFBkV6g4AmIB2tmCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790783251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWEmQKmmPhReb7fwoW/7UfQQaFElZ3XtfNvTjXF41Xg=;
	b=iezzI9hDHDK+9JKCZCutemhDTh9upiXYLoJVnBQb5eqTLU/4IQDD3SA0x7fICDlV70BWwe
	wPXuJdS+DoqgmUBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hU2ovLJx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6O7KPyP1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790783247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWEmQKmmPhReb7fwoW/7UfQQaFElZ3XtfNvTjXF41Xg=;
	b=hU2ovLJxWFHhvaqHNLrf2Wpc9ib1CK87oDAEREZ1HBxWlOo48uMhpjr0F+H63IRjZRvWLM
	3dshQ7T+dQtdr8GXIqybiubeCKBE3uOVgBrHhvpgTV/03LKIb3sRPuRv/ld74C0KjaPJ2b
	iZSsnKvDEdBZu2R+7ET3ZcAL1DyO6hM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790783247;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWEmQKmmPhReb7fwoW/7UfQQaFElZ3XtfNvTjXF41Xg=;
	b=6O7KPyP16ybWmUhZROefAnyOZbGtbjGI5pDyZUGdtfOc41DjBd9+/B+KFPCo9wggqyhrrW
	rTLFYjkyOwzdOYAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 455F713722;
	Wed, 30 Sep 2026 15:47:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XJhHBg8vvWrFTQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 30 Sep 2026 15:47:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B33E5A13AD; Wed, 30 Sep 2026 17:47:22 +0200 (CEST)
Date: Wed, 30 Sep 2026 17:47:22 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Liz Fong-Jones <lizf@honeycomb.io>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ian@honeycomb.io
Subject: Re: [PATCH v3 0/2] writeback: let foreign flushes reach dying cgwbs
Message-ID: <7pajqtogz2c4hhedorbcb6ts4yr7pxevzwt2rubxsbwidiqs4t@u7lfwce5b3bf>
References: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
 <ffbfecce332d7f3a59f6533b6daa7f0c@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffbfecce332d7f3a59f6533b6daa7f0c@kernel.org>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 95ADD21D7D
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

Hello!

On Tue 29-09-26 09:32:01, Tejun Heo wrote:
> On Tue, Sep 29, 2026 at 01:40:49AM +0000, Liz Fong-Jones wrote:
> > 1.5s and 19.5s with it), because writing back the old wb's backlog took
> > up to 27s and the sibling's foreign flushes reached the new wb in the
> > meantime. Should foreign flushes also reach a replaced wb until it is
> > clean, or is that not worth it for this case?
> 
> I don't think the old wb needs to stay reachable if the new wb takes
> over its inodes. Instead of kicking writeback, can the takeover queue a
> work item which switches all of the old wb's inodes to the new wb, like
> cleanup_offline_cgwb() does for b_attached and b_dirty_time? The switch
> carries the dirty and writeback page counts, so foreign flushes reach
> the inodes through the new wb and nothing needs to be flushed right
> away.
> 
> That would also mean switching inodes on b_dirty, b_io and b_more_io
> while the flusher may be working on the old wb, which I'm not sure is
> safe. Jan, would that be okay?

The catch with these things is always to make sure that things like sync(2)
or sync_fs(2) don't miss inodes that are being switched because workers on
different wbs work independently. But these days we have wb_switch_rwsem
so switching of cgwb should be safe against racing sync_inodes_sb(). 

Another possible concern is that writeback workers assume they are the sole
party responsible for changing to which wb list inode is added, at least as
long as I_SYNC_QUEUED flag is set. But again AFAICS
process_inode_switch_wbs() takes care of all the locking properly and even
currently, switches could happen while writeback is in progress when the
inode's owner wb changes. So this should be fine.

Finally, I'd be concerned about the performance of inode_do_switch_wbs()
when we are switching many inodes with potentially many dirty folios. It's
going to be a lot of stat item updates... With this I'm not sure how much
it will matter in practice but since we'll burn those CPU cycles when doing
writeback as well, probably it won't be too bad.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
