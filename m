Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B7B218E91;
	Fri,  2 Oct 2026 11:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790939463; cv=none; b=C6rZk5iChv9InXGTQR29OzLRRiHaDilfPY0wRtRu7orihDJWVurm0hY6v5c51KMdld/eEKPK0N1+QfewsMaxhGgdjpSvLfmmr7FlKNV+HhNh53iS5KWV9Nnqr8x7BINxcjqzKa1Rw7ar8OXIuXbyEgy6xq8MOpM68dP6d0qpbyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790939463; c=relaxed/simple;
	bh=L1kKBgNe+bBQFflO4Yid6xY8Xi+E9XsTKHIkojvlkcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DkARugud9kaMNlHfy6j4OG3imsTcfPyif1w8WHESNL4ByPH4NJTPw2Tch+547asXRbFUVscYNiTqowxRjRztvRqGByJisnqmEZzoIoMIxfmO4f/Z+KaCSDcY1L8GuBn/btNAily77sY03E1I/mRCeKLz9Y+1GQStfWfX3SkVHrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sMe4+Qlm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4h/s4NNa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RgXx8RmF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8i2NzZnr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sMe4+Qlm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4h/s4NNa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RgXx8RmF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8i2NzZnr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5DE5F21D91;
	Fri,  2 Oct 2026 11:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790939455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sfEfBWrNG2dSSShC5UWTM6bV5UZX53RFwxm/btMyTAU=;
	b=sMe4+QlmuP0qwaDghsFrDHaofCGOeIjA8EswEDuJd2Lc1q/JSCzYhjp1IwTnOA9Qe0NRxH
	0HxevK9BIEgwZpay+C4z8JP7uUhJH6bDsMU4jGXyqy4V273+MAMeY8ZLXfyPODpQ1PayLz
	NN3H53J+luJ05+A6YlTKU3hkRSVXQTo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790939455;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sfEfBWrNG2dSSShC5UWTM6bV5UZX53RFwxm/btMyTAU=;
	b=4h/s4NNa+NlhLl+I2kPIewI8F+oxwK8uqVLNcVmvVVxVFIZDOeRuzZKppj6F5hrOYcZXYb
	eeZ9wtYg8ljQXNBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RgXx8RmF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8i2NzZnr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790939451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sfEfBWrNG2dSSShC5UWTM6bV5UZX53RFwxm/btMyTAU=;
	b=RgXx8RmF69ZqV1QwybR/NHa58iXFSAvl0YFksIro+jJ+9Sk5PkRiMT2A9U54VMv1TxhHZa
	pSm5ZzY3GUZTP5+xTNkWzQuYAFot69mxFnYxnh/I/Y9hkydagld+ntL8Q+xLEIbeIf2ILJ
	7pHQ2uEwlgJTITWv1seuyW/FQwdqlMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790939451;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sfEfBWrNG2dSSShC5UWTM6bV5UZX53RFwxm/btMyTAU=;
	b=8i2NzZnrxC0zQCAvZVCkdaStr7qCHRiBrv/0u6jq3Z6wRIg4iQCJP9L3ymZjwVnIuK6zGI
	0O9FA73dOsGkiKBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30C8E13C08;
	Fri,  2 Oct 2026 11:10:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /7CAAzuRv2ppagAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 02 Oct 2026 11:10:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B0F78A13C2; Fri, 02 Oct 2026 13:10:42 +0200 (CEST)
Date: Fri, 2 Oct 2026 13:10:42 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	willy@infradead.org, tj@kernel.org, akpm@linux-foundation.org, 
	Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5DE5F21D91
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Mon 28-09-26 17:51:09, Julian Sun wrote:
> On 9/28/26 2:24 PM, Christoph Hellwig wrote:
> >> So I think tracking devices by dev_t is a good way of dealing with these
> >> problems. But then when flushing you have to transition from dev_t to
> >> struct block_device and blkdev_get_no_open() is the canonical way of doing
> >> that (and note this use is just internal to block/bdev.c).
> > 
> > I'd really prefer not to grow more blkdev_get_no_open users.
> > 
> > But the more I look at this I wonder why we even bother.  Trying to
> > attribute individual bits of dirty metadata to cgroups is pretty much
> > insane.  Why don't we bypass memcg accounting for buffer_heads like we
> > always did for the XFS buffer cache, and what btrfs switched to last
> > year? See commit b55102826d7d ("btrfs: set AS_KERNEL_FILE on the
> > btree_inode") for the btrfs side.
> 
> That sounds reasonable. However, IMHO, the main difference is that ext4
> stores this metadata in the bdev page cache rather than a separate metadata
> cache as btrfs and XFS do. The same bdev->bd_mapping is also used for buffered
> reads of the raw block device from userspace. Setting AS_KERNEL_FILE on that
> mapping would therefore also charge newly allocated page-cache folios from
> those reads to the root memcg rather than the reader's memcg, bypassing its
> memory limits.
> 
> If we pass a flag from ext4's metadata buffer-cache allocation sites and
> check it in grow_buffers() to charge new folios to the root memcg, accounting
> them as kernel-file pages would still require persistent per-folio state.
> When a folio is removed from the page cache, the allocation context is gone,
> so we cannot tell whether it was counted as a kernel-file folio.
> 
> Separating ext4's metadata cache from the bdev page cache would address this,
> but that seems like a much larger, longer-term change.

FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
for bdev mappings will cause issues because some users may be using bdevs
directly for their workloads and they could still expect proper memcg
accounting to work in that case.

We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
it when releasing bdev) but that would have to make sure there are no
folios in the bdev mapping when changing the flag as otherwise the
accounting would go wrong. Looks it might be doable but getting all the
cornercases right will be hairy and overall not very appealing to me...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
