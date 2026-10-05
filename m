Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128231FA859;
	Mon,  5 Oct 2026 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791217565; cv=none; b=pS+5y834GcLsL9xB31nhvkFK91rREtQjTibu8iLYhhsg3R92FqOdpK5KT8AK2c7k2kDgUMyORUQwoobRDWuI95a6sfTs5GNHTXxJHrTPeejC/LC/3S0dZdlI4vcoKpQlL73PGAx7f8cDkOFsy5G0Cb/nKlJvNAVJMWVAHT3uz2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791217565; c=relaxed/simple;
	bh=aX00HN74P56Ti0fjxmYSIF8ai5X/I1u1ihtfnIbPfrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQTNrZ8nMAhISOYUROGjV5EkTJeoC+o/xkPP/xCIk3Hn7R4QKPeiENTQwku6q0V/laWd1b/ulGwVm7ZatbOT/QDtQj6j9K/YiB6bkSwUJXRRrT8hAAWU0KWX4llcGiDIwBEN4nmGMbqbkt9nRcrCNSQKpVHLqHXpldYyxh/onck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k5ruQcs/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/uqe5lrM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bna+jeUN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ljolE5FX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k5ruQcs/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/uqe5lrM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bna+jeUN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ljolE5FX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 534A521CC9;
	Mon,  5 Oct 2026 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791217557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QCxilX6Jn3NHwpmrQszL9nBtZP+KGRKGSWPtHz/iVU=;
	b=k5ruQcs/on2VIzOXmxqSS4IfZ8wf8r/4SV8G3Fdr+JJby1qa2X7bl98nKgAAgmZd7yJal0
	otTQlTiFFDc4hYaJCiCJkvNAQdvOiPbNod2YvcEkkXtdLYNSTuoBho0LcCoqlRHhD/EPzb
	uzIYbioILKr1owBgdsDbD40Qq/c2pnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791217557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QCxilX6Jn3NHwpmrQszL9nBtZP+KGRKGSWPtHz/iVU=;
	b=/uqe5lrMr+KbBX+d1oDtcrnwCe1K7WykRsGn5rf3yW6RV1/KVRPYtWEVdt9FhzndnPexep
	HxTgMuod5n952/Bw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791217553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QCxilX6Jn3NHwpmrQszL9nBtZP+KGRKGSWPtHz/iVU=;
	b=Bna+jeUN7vDJuAQDE0OYULGaLBRqrJz0GjUweYJBDTlet0ToeEucKYTWFl+8qfEt9gnXE4
	xqCTx1ilWdrVH7SHLfJ9pKPNEVugJPw7/Y6UD8bGfiXkY3vwAiseYC6RimegfTLJsR1LXU
	txWfS2NAwOIRp/jrk+uoZ/aErveQLzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791217553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QCxilX6Jn3NHwpmrQszL9nBtZP+KGRKGSWPtHz/iVU=;
	b=ljolE5FXb6fhoA41wVfhQWOHSZPyVH3M4vv8Vv0KneEzDxhIsyyBZWCJeZXMqNPzvMFl0d
	D7QPKOBnXMfcu4Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0F3013688;
	Mon,  5 Oct 2026 16:25:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TpvxLpDPw2qXMwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 05 Oct 2026 16:25:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1CB3CA13FC; Mon, 05 Oct 2026 18:25:52 +0200 (CEST)
Date: Mon, 5 Oct 2026 18:25:52 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Julian Sun <sunjunchao@bytedance.com>, 
	linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	willy@infradead.org, tj@kernel.org, akpm@linux-foundation.org, 
	Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
 <asNfNHd-kcsI4B1S@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asNfNHd-kcsI4B1S@infradead.org>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
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
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Mon 05-10-26 01:26:28, Christoph Hellwig wrote:
> On Fri, Oct 02, 2026 at 01:10:42PM +0200, Jan Kara wrote:
> > FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
> > for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
> > for bdev mappings will cause issues because some users may be using bdevs
> > directly for their workloads and they could still expect proper memcg
> > accounting to work in that case.
> 
> Agreed that it should not set unconditionally.
> 
> > We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
> > it when releasing bdev) but that would have to make sure there are no
> > folios in the bdev mapping when changing the flag as otherwise the
> > accounting would go wrong. Looks it might be doable but getting all the
> > cornercases right will be hairy and overall not very appealing to me...
> 
> I'd rather not support special case writeback code just for this legacy
> fs abuses bdev buffer cache case.  And we basically need to tear
> down pagecache at unmount anyway, as i_blkbits can change, so while
> we do need to be careful, I don't think it really is a major issue.

OK, after some more thought yes, I think we can make that work.

> We might be able to restrict to setting it when
> CONFIG_BLK_DEV_WRITE_MOUNTED is disabled to avoid the problem of non-fs
> shared mmap writers, as anyone using a modern kernel and cgroups really
> should have that disabled.

I don't think that's really needed. If such writes are happening, they are
*very* limited and done by a system administrator only (as they are very
dangerous) so the fact the writes will get charged to the root cgroup is
not an issue.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
