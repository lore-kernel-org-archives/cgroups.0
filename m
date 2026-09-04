Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0BA3ACF02
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 09:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512423; cv=none; b=FsA6Z7iEnWktaaH90D9k3xEyNNWqwPRydsPp9omywjvzfMTYU8Co7HTaN41X9D+CRH6zChcqV2XdZgnxyAj7f3vxUXDznEDVWVHEkvom/9kYk7lVjkOrfs3c3++toN77tIeSYioJHhJA5qmqiLMyCs6WMbyPwyQgN209W7K8/x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512423; c=relaxed/simple;
	bh=DynVF4jXj/DQ6NdYeydnbpxGDYW5B+c9r61GoWsdEjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRl9dVm/6irtNeVYbJ4COaamjEXqTHXlWcrkOFt7x5tO8AjFBJAJ43rX/7Q6/hVeQ3WwvQAF9+jESkUTD4f3fnFMSRchwB5CDZqfnIaJ3ATaG/cqC7dQuN4mZByhvWGfo5AtJYqzKUG516OupvEFs1w4R4aJlygL1R2b4YV0fAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2n+IpX51; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oKLGQ7sf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=X745eKzP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FT5soJ5p; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2n+IpX51";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oKLGQ7sf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="X745eKzP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FT5soJ5p"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 71B5122B0C;
	Fri,  4 Sep 2026 09:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788512415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lLfEq2d9SGszS5pQF4tLiNBc07Qp6BDCc4+wys6emDs=;
	b=2n+IpX51oNNOJVS+8qwEdtvECRq/AlSxFxH3HPpvkm3/Jbs/DGzbHpVuN828h9P6GPP7GE
	PH+pTFrYaan+XmNqEfGHVg7yT/NPqdzhIETV5k8zi1qnbj1JBiMYUj2WlT3pRgiuE6Or3b
	XjPD2CbmZJx2UuqN+or/T7cmaH3yIQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788512415;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lLfEq2d9SGszS5pQF4tLiNBc07Qp6BDCc4+wys6emDs=;
	b=oKLGQ7sfZ1iSt3f8Jg2UBQtw+OkGbj+ZayZPdfnP9EIpmCuAcDjJHSvdzWwvTfvd8ts39I
	EzHRl6TnuV2MG0DA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X745eKzP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FT5soJ5p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788512411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lLfEq2d9SGszS5pQF4tLiNBc07Qp6BDCc4+wys6emDs=;
	b=X745eKzP8BUGBUEj5dHInWHKaxpaFHhUT/sdYJtrjAYuDYBhlwzpow/j+ZxflKHx3KsoAe
	V0Z3L1ys3TMeqwMfN8h/A9l9Q+x4peXrOznZX6L0BrnlScO6GXPcfChIyOGk7A1UX0Guil
	vuPsGQtQNkf4ijtZjGu4uJSgosFohXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788512411;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lLfEq2d9SGszS5pQF4tLiNBc07Qp6BDCc4+wys6emDs=;
	b=FT5soJ5pKEagZVToBO4ECQ3dY1VxfC+VphmQKcFDkyQmfS2tT3O7MUkn6VSuLaKNw80sMt
	MFPaXZ3ZpVwEINCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C5CA13726;
	Fri,  4 Sep 2026 09:00:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aVGXEpuImmqjbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 04 Sep 2026 09:00:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C6E41A13CE; Fri, 04 Sep 2026 11:00:06 +0200 (CEST)
Date: Fri, 4 Sep 2026 11:00:06 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, axboe@kernel.dk, tj@kernel.org, 
	jack@suse.cz
Subject: Re: [External] Re: [PATCH v2] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
Message-ID: <j644hkswljrskiivxcimh2ms2zoilfptfhl7bdy6uu3tvqv6yd@m46nuyunp5ni>
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
 <5f34e3e1-749e-44d1-b3e7-50e11f7240e3@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f34e3e1-749e-44d1-b3e7-50e11f7240e3@bytedance.com>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 71B5122B0C
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
	RCPT_COUNT_TWELVE(0.00)[12];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email,bytedance.com:email];
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

On Fri 04-09-26 11:39:23, Julian Sun wrote:
> On 9/4/26 3:34 AM, Andrew Morton wrote:
> > On Thu,  3 Sep 2026 16:33:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
> > 
> > > Foreign dirty flushing handles cases where a dirtied folio's memcg and
> > > the memcg owning its inode wb differ.
> > > 
> > > wbc_detach_inode() notes that "concurrent write sharing of an inode is
> > > expected to be very rare". This expectation does not hold for bdev inodes.
> > > A bdev inode and mapping are shared by buffered users of the block device,
> > > while the inode has a single wb owner. On ext4, buffer-cache folios used
> > > by metadata and journal I/O can therefore be charged to different memcgs
> > > while sharing the same mapping. Normal bdev activity can thus produce
> > > frequent folio/wb ownership mismatches.
> > > 
> > > This was reproduced on cgroup v2 with the memory and I/O controllers
> > > enabled, using ext4 on a loop device. jbd2 repeatedly generated
> > > track_foreign_dirty events for bdev folios charged to unrelated memcgs.
> > > When one of those memcgs entered dirty throttling, the resulting record led
> > > to a flush_foreign event and queued writeback with reason=foreign_flush for
> > > the bdev inode's root wb.
> > > 
> > > Skip foreign dirty tracking when the folio mapping's host inode is on the
> > > blockdev pseudo superblock. This prevents bdev-originated records from
> > > triggering later foreign flushes.
> > > 
> > > The tradeoff is that dirty throttling in the folio's memcg no longer uses
> > > bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
> > > folios remain subject to normal writeback. This is preferable because a
> > > single bdev wb owner does not identify which cgroup is responsible for a
> > > mapping shared by buffered bdev users. Flushing it can write back data
> > > unrelated to the throttled memcg. Dirty accounting, normal writeback, and
> > > foreign dirty tracking for non-bdev inodes remain unchanged.
> > 
> > When fixing something, please always describe the userspace-visible
> > runtime effects.
> 
> Sorry, I overlooked this aspect.
> > 
> > I'm thinking probably "unnecessary I/O"?  If so, has this been
> > quantified/measured?  If not, can the effects be guessed about?
> 
> We suspect that a large amount of prematurely triggered foreign writeback
> consumes device writeback bandwidth, thereby degrading the performance of
> the entire writeback path.
> 
> On one production machine, the total nr_pages of the foreign-flush works was
> 630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of memory.
> Although nr_pages does not represent the number of dirty pages that will
> ultimately be written back, the actual number of pages written back may
> still be very large because the corresponding wb was continuously
> accumulating dirty pages.

As Tejun also wrote, it would be good to really quantify these effects -
best by demonstrating how this change improved writeback behavior (and we
are not so much interested in the number of submitted writeback works but
more in the observed load on the storage or completion of some workload).
The problem with your solution is that it has its downsided as well
(possible stalls in dirty throttling) so it should be very clear what are
we gaining to outweight this risk.

In principle I agree that a lot of submitted writeback works can degrade
writeback behavior - a lot of workloads has some set of folios that is
practically permanently dirty and if you are pushing writeback too much, we
will be just writing these folios over and over again without useful work
really done. Also if there's comparably small amount of folios dirty, the
IO resulting from writeback is generally less efficient. But how severe
these effects can get in case you describe is not clear...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
