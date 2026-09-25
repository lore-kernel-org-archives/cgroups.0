Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF549553B;
	Fri, 25 Sep 2026 10:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790332504; cv=none; b=J2vLTNX2vitSnf+RGRuYz43dvtgY0jwXsV4hQn46XlE6x7/La71f0htc95TriroiwfQrvJurQ0Yb6LUp1AbdEfSl29Zdz+MoZ/saqtktH0aorRWmUybqLo++zSQGO5JEK5Df3WuxbgoS7A7JcTV9Nqa7mNqbJAoZ7OWSe/lIaZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790332504; c=relaxed/simple;
	bh=+GqLfHS3KhW1SZDMZZg1WMpdlSQIHXFb/kVBuu90ZOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9QhRjtO5NRVwLt03PgZ87dyXGi7u/oCtcVVyt05nUzfrboD0+UMJ5+ooXd2qJXtmOokBDbdZwzWhXaGQ1VD43QHHZawZ35NqoEFfMagTf5Ipt4o+mV9DJgBe9nspKG5t2DFfDMJJNRpUIohaZ3bXeEDTUbCPxRIDm1cn922yok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sHDDZXOH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EWyleEm2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mbSFHP01; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AGIdiRXb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sHDDZXOH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EWyleEm2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mbSFHP01";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AGIdiRXb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0FB2020173;
	Fri, 25 Sep 2026 10:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790332497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmWBmGiYLCBQGGp6qkvxtGAccccpy3zMvAj3zCRN2IA=;
	b=sHDDZXOHSyUK2kf6s0YAqGzmTi1vLCDLNNZgXmrEbKyCLWk3J7pAlehfU+wKV/sYOePY5o
	ETEWt3g8dwmv9uvSNGzI4He+yjtRQ/5iPCQdf668Wuk8tfuF5w5ROa/ErRXmeA2J1LL4PE
	lrNZsZS/6b9cpZWAx0vHk+yo9/tJFJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790332497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmWBmGiYLCBQGGp6qkvxtGAccccpy3zMvAj3zCRN2IA=;
	b=EWyleEm27YWVXBqG2SbnDiPzTHLoUvyQvU3QF4ME+bjunA7e3IHn3i/g9pTQTCxgQsSiK8
	L6bm0pzL+BJ6NUDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mbSFHP01;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AGIdiRXb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790332493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmWBmGiYLCBQGGp6qkvxtGAccccpy3zMvAj3zCRN2IA=;
	b=mbSFHP01JNXU2AmaGwx4rwSzdR2m/ZlwshNNgiCJeWxKEtYfHICYb5ediWc41eQsBCcxtR
	ZJJitcTfNXFcg3VB1IsTLFJow0UNrZxUkMmf8fFlJbpbjMY8psqZxrKzV0RFDTk85zyht0
	saOm6R7j44wAcGono2I2vZPYhf33VJU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790332493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmWBmGiYLCBQGGp6qkvxtGAccccpy3zMvAj3zCRN2IA=;
	b=AGIdiRXb2jxsg3XbV7X5oEoMi5jXS9fP7pcbs03Qq08ABTAbG8C1K6tBCcZlDVd5d09IBA
	ARdF+jmpZ93xVxCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC338136F7;
	Fri, 25 Sep 2026 10:34:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nq/PLExOtmr+bwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 25 Sep 2026 10:34:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 67281A13DA; Fri, 25 Sep 2026 12:34:52 +0200 (CEST)
Date: Fri, 25 Sep 2026 12:34:52 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Julian Sun <sunjunchao@bytedance.com>, linux-block@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, 
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arYaMbJUh6unvz_t@infradead.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 0FB2020173
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
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
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Thu 24-09-26 23:52:33, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 02:44:42PM +0800, Julian Sun wrote:
> > Add bdev_flush_by_dev() to submit page-cache writeback for a device
> > identified by dev_t without requiring callers to hold a persistent
> > device reference.
> 
> This isn't really a flush is it?  This is writeback.

So bdev_writeback_by_dev()? Fine by me.

> > + *
> > + * May sleep while submitting writeback; does not wait for I/O completion.
> > + */
> > +void bdev_flush_by_dev(dev_t dev)
> > +{
> > +	struct block_device *bdev;
> > +
> > +	bdev = blkdev_get_no_open(dev, false);
> > +	if (!bdev)
> > +		return;
> 
> Please don't add more blkdev_get_no_open.  You can get from an
> bdevfs inode to the struct block_device trivially using
> I_BDEV instead of doing another lookup.  Or just grab a reference
> to the the inode, which would seem even easier.

Well, Julian is explaining that in the cover letter. We don't want memcgs
to hold bdev references just for foreign flush tracking. There's no easy
way to get rid of them so they could pin bdevs for a long time leading to
strange artifacts.

As you write, we could just hold a reference to the bdev inode. Those get
unhashed when the device dies (__del_gendisk()) so memcgs would be just
wasting some memory by holding these inodes alive. But still, transitioning
from inode to proper bdev reference verifying bdev is still alive will add
a bit of hairy code (essentially what blkdev_get_no_open() does plus
verification inode is still hashed). Plus when replacing foreign flush
entries you're under irqsafe xa_lock so doing iput() from there is kind of
a nogo.

So I think tracking devices by dev_t is a good way of dealing with these
problems. But then when flushing you have to transition from dev_t to
struct block_device and blkdev_get_no_open() is the canonical way of doing
that (and note this use is just internal to block/bdev.c).

So how would you prefer to deal with that?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
