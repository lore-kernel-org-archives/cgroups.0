Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4417B3D813A
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788273854; cv=none; b=ZeengsrCXwQNtlwu8TZOArclFM47VjkBphHly+8549IpGtWtNG6S+u0mmluhL1g/iZr49z/osQdZipRglxqOKHq1afqidYKZDp2Rd7w06Dg5gTY/fbVxA4Bs9vtXxgKE5LKfXfD73tlj+aIaQ36Klts6Tr9Wj68rzKqq65C2U2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788273854; c=relaxed/simple;
	bh=2Em2zk60UyQcUzytoc8LfogcmzSENaU6QXoOU9dYovg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSeCyly4MC68qy+4QPlO+JsUZVClMBLSxCXnvw4I8FVxnpDllSFI55EVro15f0RwmcsgdVt5oo7FLmwGeOhl0dlCMl0bUVZ9MtRBquYWD9FasgwDR8AlDFyQn3PNtfIS8nrM7dxQjqs+VsdZ5AjuiwrauH3YI2CB9h7xCfkQW04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YDX0Pe9q; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OMf2n6Oo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WkLy24zm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6Pxovp5P; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YDX0Pe9q";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OMf2n6Oo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WkLy24zm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6Pxovp5P"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F5B0220D5;
	Tue,  1 Sep 2026 14:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788273845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/gTDEhVKdEhY/hU+0ykwPzObhxDg0wKu9fWSTc7Y9g=;
	b=YDX0Pe9quX55bY2G/mUM3F009pTxAiFCrZMFAVbWSVHPy1owBESl8CICtz5SLVDXJk0xbU
	V1AFR7rdGZaYntaECSQ1ZGFoGm4em4izvRtFdHRqueWx1y9P50kqQRmwRSR+J20pPi97y/
	emB7IJboIBSe/qzjZQgPFugWEquQF3M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788273845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/gTDEhVKdEhY/hU+0ykwPzObhxDg0wKu9fWSTc7Y9g=;
	b=OMf2n6OoLdjJqRPThc+EdieDSdE3Gjs9vU+qOL9/ZEIAkXvpmmCx4z2uBjjWetwZYFz7jj
	T3KBYqdYJhvTXeAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788273841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/gTDEhVKdEhY/hU+0ykwPzObhxDg0wKu9fWSTc7Y9g=;
	b=WkLy24zmDiV2Qbe5c5R9RKDkYqPc+z5lQ+IbsxahrgE/SqlN7jZSNZbL/beGhY3/75qC6o
	W8zPLn8twvvXqLYocbRB5iYPn5s4BCEloanGhsHK3nUDfjP19lA6qtQnNnLbqS2YDskzLJ
	O3py4GYxsPk4cShF408p8Eq+gNR5fkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788273841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/gTDEhVKdEhY/hU+0ykwPzObhxDg0wKu9fWSTc7Y9g=;
	b=6Pxovp5PTJjL5SxcAxUkopWjGa+vqMTVCyAdH/AUnNqVB3+PQroE3PV7MGFp8LY9QEA5oZ
	d/2s/Z3MB6RGoeAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A4B91369E;
	Tue,  1 Sep 2026 14:44:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tZhbBrHklmocAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 01 Sep 2026 14:44:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 940A5A13B2; Tue, 01 Sep 2026 16:44:00 +0200 (CEST)
Date: Tue, 1 Sep 2026 16:44:00 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk, tj@kernel.org, 
	jack@suse.cz
Subject: Re: [PATCH] writeback, memcg: skip foreign dirty tracking for bdev
 inodes
Message-ID: <b4yiuuthnjfgoc2djz5cju3jahstzwizqyaqxo5dd3qijmsww7@66sink2shhwu>
References: <20260901131028.1120284-1-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901131028.1120284-1-sunjunchao@bytedance.com>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Tue 01-09-26 21:10:28, Julian Sun wrote:
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

I suppose the real downside of foreign flushes is ultimately reduced
performance?

> The tradeoff is that dirty throttling in the folio's memcg no longer uses
> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
> folios remain subject to normal writeback. This is preferable because a
> single bdev wb owner does not identify which cgroup is responsible for a
> mapping shared by buffered bdev users. Flushing it can write back data
> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
> foreign dirty tracking for non-bdev inodes remain unchanged.
> 
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

To me this looks as a sensible workaround but I'd be a bit worried whether
a memcg that dirties a significant amount of bdev folios (compared to its
dirty limit) cannot be blocked in dirty throttling due to this - as the
comment above mem_cgroup_track_foreign_dirty_slowpath() describes. I'd
defer to Tejun to judge if can be severe enough. But I think if we go this
path, the added condition should have at least a short comment like:

	/*
	 * Bdev inodes are usually shared by many memcgs so foreign
	 * tracking leads to frequent flushes which is counterproductive.
	 */

because otherwise this condition really makes you wonder what is going on.

								Honza
> ---
>  mm/memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..5d7320f76c06 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3898,6 +3898,11 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  	u64 oldest_at = now;
>  	int oldest = -1;
>  	int i;
> +	struct address_space *mapping = folio_mapping(folio);
> +	struct inode *bdev_inode = mapping ? mapping->host : NULL;
> +
> +	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
> +		return;
>  
>  	trace_track_foreign_dirty(folio, wb);
>  
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
