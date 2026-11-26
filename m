Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795699786;
	b=fDdzkfoeH0EOUkIYceXpQsx3+3/C08xrllkO1SGkGNWyoxfQtpTk3pC8YUEHW1mrvgND
	 V9fftdcIeQPMx88tu95DhhFbu3anfN+Hww78Xjm6ys8oHQ7iajdE4BminwryeYsiurWEx
	 Dw8Qxv/Epz1WunNwQH+o61nIwV0zNe1Zq7h+BV4S3qEIP3n2vDLJZ40JVFSuiHwVnJy4j
	 /tsFLafcMTsmZI1o+oPcrF8nCisc+OAl7HJ7xdeLtfur35HhCca/Rn6WwJkmFP422a3KO
	 AzlrDMechIsbBfw4yhwuv0Cp5kItIvDmPYZN6eAmIvyFVZ3XHH3iFK3P6MoLjWAZiVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699786;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=hoBGNgGY6uRhBVWeqNuBk7nBPhzw5E3ehiFZAtqafLON52h2s1g06kGeIRs8j0NyvMtM
	 0mNYzVIMbDHwNzfResQtawl4j5VYU/VuE6HXcaQ9/aqOFSJsNWts8zQXsn2mo2m+JNCBe
	 AUt5Zy6HZANsFGYmiAw2Z4P72057Gw/M4I6BNeOwSmIN+oegAuL9Z184UirtHcAyPo7b2
	 dSurXDsYZ1Yy2ZWLukgCl6JnBqidX+MpCVviU7G1F2z6224vuq7iK8cgq8FiSAl/Qbaem
	 J5ghyA7r3UrXBgbwhCKdDHs2q0HBqyOhjJWj9ZTc4U2Z7kGhm43iEqzKwVv3Y0DALPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=STsQXCyy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=STsQXCyy;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B30606A31E;
	Thu, 26 Nov 2026 13:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8B30606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=STsQXCyy;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=STsQXCyy
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 832841F82D;
	Thu, 26 Nov 2026 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795699783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=CHmbyS7rE8D9y6HmMS/dNYUQ9+I6L1l9cZmrUzcYKiQU3JHWp8M0wGxqDzydGfXj0Mldst
	IZMUi3/aW9s/JCTj8X6oe+vV8fowpoJDqdS8FUGCfl9q93wIG0IH6AQiCR+8i8ZdjEp8v4
	CqUk0KbJSMxBtcwg5vLnv863Y/aHZN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795699783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=STsQXCyyhppnt+hXynu1+B4O5f6wcSuPJvxY2UcOXafOnKrfh7fE/y4P2qGwyEj4Mt3957
	XP6KkhAVY6ulBaAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CHmbyS7r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=STsQXCyy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795699783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=CHmbyS7rE8D9y6HmMS/dNYUQ9+I6L1l9cZmrUzcYKiQU3JHWp8M0wGxqDzydGfXj0Mldst
	IZMUi3/aW9s/JCTj8X6oe+vV8fowpoJDqdS8FUGCfl9q93wIG0IH6AQiCR+8i8ZdjEp8v4
	CqUk0KbJSMxBtcwg5vLnv863Y/aHZN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795699783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ETYE+9jLVYhPwhx8oW4f7yzkUUYn0BFPEg3N+uQXDg=;
	b=STsQXCyyhppnt+hXynu1+B4O5f6wcSuPJvxY2UcOXafOnKrfh7fE/y4P2qGwyEj4Mt3957
	XP6KkhAVY6ulBaAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 578E3134C3;
	Thu, 26 Nov 2026 13:29:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YVL2DEc0CGuWZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Nov 2026 13:29:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id DB69D27E29; Thu, 26 Nov 2026 14:29:38 +0100 (CET)
Date: Thu, 26 Nov 2026 14:29:38 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, 
	Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
 against filesystem freeze
Message-ID: <chxughsxznjexjhb5sjy7dtzkemkarwt5gogkphhjsggis6mtf@uol26i75zbal>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Rspamd-Queue-Id: 832841F82D
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[linux-foundation.org,cmpxchg.org,kernel.org,linux.dev,infradead.org,suse.cz,zeniv.linux.org.uk,kernel.dk,lst.de,google.com,kroah.com,gmail.com,kvack.org,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.51

On Thu 26-11-26 02:08:56, Tejun Heo wrote:
> Legacy memcg reclaim has no dirty throttling, and shrink_folio_list() waits
> for a folio that is under writeback and already marked for reclaim (case 3
> in its comment). That wait can deadlock against a filesystem freeze:
> 
> 1. A task in write() to filesystem B holds freeze protection on B, enters
>    memcg reclaim and waits for writeback of a folio of a filesystem on a
>    loop device backed by a file on B.
> 
> 2. A freeze of B waits for the task to drop its freeze protection.
> 
> 3. The loop worker has to take freeze protection on B to write the folio out
>    and blocks behind the freeze.
> 
> The same applies to any driver that writes to a file on a local filesystem
> to serve block I/O and takes freeze protection for it.
> 
> Reclaim can't tell which filesystem a writeback depends on. Count the
> superblocks that are being frozen and make the wait time out after 15
> seconds. If one is being frozen at that point, warn and give up. Until none
> is, treat such folios like case 2 and skip the legacy writeback throttle, so
> that the task a freeze may be waiting for isn't held up.
> 
> This trades the deadlock for premature memcg OOM kills during such a freeze.
> The wait also no longer hits the folio_wait_writeback tracepoint, and the
> hung task detector no longer reports a task stuck in it for another reason
> as the task wakes up every 15 seconds.
> 
> Fixes: e62e384e9da8 ("memcg: prevent OOM with too many dirty pages")
> Reported-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>

Yeah, it's ugly but it should fix the deadlock. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> This was first posted in a private thread and is resent here for the lists,
> rebased onto the current mainline. The only other change is the added
> Reviewed-by tags.
> 
> This is on top of v7.4-rc4-388 (25faec9ce61c). In a test with a filesystem
> on a loop device backed by a file on another filesystem, writers to both in
> a v1 memcg and the backing filesystem frozen and thawed in a loop, the
> unpatched kernel deadlocks within seconds. With the patch, a stuck freeze
> gets through in 15 to 18 seconds.
> 
>  fs/super.c               |    7 +++++
>  include/linux/fs/super.h |    1 
>  mm/filemap.c             |   22 +++++++++++++++--
>  mm/internal.h            |    1 
>  mm/vmscan.c              |   58 ++++++++++++++++++++++++++++++++++++++++++++---
>  5 files changed, 83 insertions(+), 6 deletions(-)
> 
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -48,6 +48,9 @@ static int thaw_super_locked(struct supe
>  static LIST_HEAD(super_blocks);
>  static DEFINE_SPINLOCK(sb_lock);
>  
> +/* nr of superblocks that freeze_super() is in the middle of freezing */
> +atomic_t sb_nr_freezing;
> +
>  static char *sb_writers_name[SB_FREEZE_LEVELS] = {
>  	"sb_writers",
>  	"sb_pagefaults",
> @@ -2235,6 +2238,7 @@ retry:
>  		return 0;
>  	}
>  
> +	atomic_inc(&sb_nr_freezing);
>  	sb->s_writers.frozen = SB_FREEZE_WRITE;
>  	/* Release s_umount to preserve sb_start_write -> s_umount ordering */
>  	super_unlock_excl(sb);
> @@ -2249,6 +2253,7 @@ retry:
>  	ret = sync_filesystem(sb);
>  	if (ret) {
>  		sb->s_writers.frozen = SB_UNFROZEN;
> +		atomic_dec(&sb_nr_freezing);
>  		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
>  		wake_up_var(&sb->s_writers.frozen);
>  		deactivate_locked_super(sb);
> @@ -2265,6 +2270,7 @@ retry:
>  			printk(KERN_ERR
>  				"VFS:Filesystem freeze failed\n");
>  			sb->s_writers.frozen = SB_UNFROZEN;
> +			atomic_dec(&sb_nr_freezing);
>  			sb_freeze_unlock(sb, SB_FREEZE_FS);
>  			wake_up_var(&sb->s_writers.frozen);
>  			deactivate_locked_super(sb);
> @@ -2278,6 +2284,7 @@ retry:
>  	WARN_ON_ONCE(freeze_inc(sb, who) > 1);
>  	sb->s_writers.freeze_owner = freeze_owner;
>  	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
> +	atomic_dec(&sb_nr_freezing);
>  	wake_up_var(&sb->s_writers.frozen);
>  	lockdep_sb_freeze_release(sb);
>  	super_unlock_excl(sb);
> --- a/include/linux/fs/super.h
> +++ b/include/linux/fs/super.h
> @@ -234,6 +234,7 @@ int freeze_super(struct super_block *sup
>  		 const void *freeze_owner);
>  int thaw_super(struct super_block *super, enum freeze_holder who,
>  	       const void *freeze_owner);
> +extern atomic_t sb_nr_freezing;
>  
>  int sb_init_dio_done_wq(struct super_block *sb);
>  
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1245,8 +1245,8 @@ static inline bool folio_trylock_flag(st
>  	return true;
>  }
>  
> -static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
> -		int state, enum behavior behavior)
> +static inline int folio_wait_bit_common_timeout(struct folio *folio, int bit_nr, int state,
> +		enum behavior behavior, long timeout)
>  {
>  	wait_queue_head_t *q = folio_waitqueue(folio);
>  	int unfairness = sysctl_page_lock_unfairness;
> @@ -1324,7 +1324,9 @@ repeat:
>  			if (signal_pending_state(state, current))
>  				break;
>  
> -			io_schedule();
> +			timeout = io_schedule_timeout(timeout);
> +			if (!timeout)
> +				break;
>  			continue;
>  		}
>  
> @@ -1393,6 +1395,13 @@ repeat:
>  	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
>  }
>  
> +static inline int folio_wait_bit_common(struct folio *folio, int bit_nr, int state,
> +		enum behavior behavior)
> +{
> +	return folio_wait_bit_common_timeout(folio, bit_nr, state, behavior,
> +					     MAX_SCHEDULE_TIMEOUT);
> +}
> +
>  #ifdef CONFIG_MIGRATION
>  /**
>   * softleaf_entry_wait_on_locked - Wait for a migration entry or
> @@ -1490,6 +1499,13 @@ int folio_wait_bit_killable(struct folio
>  }
>  EXPORT_SYMBOL(folio_wait_bit_killable);
>  
> +/* wait up to @timeout jiffies for @bit_nr to clear, true if it cleared */
> +bool folio_wait_bit_timeout(struct folio *folio, int bit_nr, long timeout)
> +{
> +	return !folio_wait_bit_common_timeout(folio, bit_nr, TASK_UNINTERRUPTIBLE, SHARED,
> +					      timeout);
> +}
> +
>  /**
>   * folio_put_wait_locked - Drop a reference and wait for it to be unlocked
>   * @folio: The folio to wait for.
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1276,6 +1276,7 @@ struct migration_target_control {
>   */
>  ssize_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
>  			       struct folio *folio, loff_t fpos, size_t size);
> +bool folio_wait_bit_timeout(struct folio *folio, int bit_nr, long timeout);
>  
>  static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
>  {
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1157,6 +1157,55 @@ static bool may_enter_fs(struct folio *f
>  }
>  
>  /*
> + * Legacy memcg reclaim has no dirty throttling and waits for writeback in
> + * shrink_folio_list() instead. That wait can deadlock against a filesystem
> + * freeze:
> + *
> + * 1. A task holds freeze protection on filesystem B, e.g. in write(), enters
> + *    reclaim and waits for writeback of a folio whose I/O ends up as a write to
> + *    B, e.g. through a loop device backed by a file on B.
> + *
> + * 2. A freeze of B waits for the task to drop its freeze protection.
> + *
> + * 3. The write to B waits for the freeze.
> + *
> + * Reclaim can't tell which filesystem a writeback depends on. As a crude
> + * workaround, memcg_wait_writeback() times out and, if any filesystem is being
> + * frozen at that point, sets memcg_wb_wait_skip. While it is set, legacy memcg
> + * reclaim neither waits for nor throttles on writeback, so that the task a
> + * freeze may be waiting for isn't held up in reclaim and can drop its freeze
> + * protection. This can cause premature memcg OOM kills.
> + */
> +static bool memcg_wb_wait_skip;
> +
> +/*
> + * Test memcg_wb_wait_skip. It takes effect only while a filesystem is being
> + * frozen and is cleared here once none is. A freeze that starts before it is
> + * cleared inherits the skip.
> + */
> +static bool memcg_skip_wb_wait(void)
> +{
> +	if (!READ_ONCE(memcg_wb_wait_skip))
> +		return false;
> +	if (atomic_read(&sb_nr_freezing))
> +		return true;
> +	WRITE_ONCE(memcg_wb_wait_skip, false);
> +	return false;
> +}
> +
> +/* wait for writeback of @folio, see memcg_wb_wait_skip for the timeout */
> +static void memcg_wait_writeback(struct folio *folio)
> +{
> +	while (!folio_wait_bit_timeout(folio, PG_writeback, 15 * HZ)) {
> +		if (atomic_read(&sb_nr_freezing)) {
> +			WRITE_ONCE(memcg_wb_wait_skip, true);
> +			pr_warn("memcg1 writeback wait timed out during fs freeze, skipping waits, may OOM early\n");
> +			return;
> +		}
> +	}
> +}
> +
> +/*
>   * shrink_folio_list() returns the number of reclaimed pages
>   */
>  static unsigned int shrink_folio_list(struct list_head *folio_list,
> @@ -1277,7 +1326,9 @@ retry:
>  		 *    reclaim flag set. memcg does not have any dirty folio
>  		 *    throttling so we could easily OOM just because too many
>  		 *    folios are in writeback and there is nothing else to
> -		 *    reclaim. Wait for the writeback to complete.
> +		 *    reclaim. Wait for the writeback to complete. If
> +		 *    memcg_wait_writeback() gives up, such folios are treated
> +		 *    as in case 2 until no filesystem is being frozen.
>  		 *
>  		 * In cases 1) and 2) we activate the folios to get them out of
>  		 * the way while we continue scanning for clean folios on the
> @@ -1300,6 +1351,7 @@ retry:
>  
>  			/* Case 2 above */
>  			} else if (writeback_throttling_sane(sc) ||
> +			    memcg_skip_wb_wait() ||
>  			    !folio_test_reclaim(folio) ||
>  			    !may_enter_fs(folio, sc->gfp_mask) ||
>  			    (mapping &&
> @@ -1325,7 +1377,7 @@ retry:
>  			/* Case 3 above */
>  			} else {
>  				folio_unlock(folio);
> -				folio_wait_writeback(folio);
> +				memcg_wait_writeback(folio);
>  				/* then go back and try same folio again */
>  				list_add_tail(&folio->lru, folio_list);
>  				continue;
> @@ -2086,7 +2138,7 @@ static void handle_reclaim_writeback(uns
>  		 * enough for cgroupv1 writeback throttling to work
>  		 * on a large system.
>  		 */
> -		if (!writeback_throttling_sane(sc))
> +		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait())
>  			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
>  	}
>  
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
