Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC08744780F;
	Thu, 24 Sep 2026 10:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790247471; cv=none; b=FHji2jjXAv26LSSay3G8M7Zs/82OdVafVYpITM4dmOFiWfICTG1fP8dmUjiK77yqjuSmysE+5EEZA0ve7EuQV8Sfuwo9y+qx/HnZxXopasS9jK8F9yQ9GMlXQkRpzfcqEX/QnOxf9DhUVx/NreFeikS/YnCfrBVwBY4XB2WZ3Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790247471; c=relaxed/simple;
	bh=3xX6Y+1JC3mm+xz311I53Qd6nLDPBCXrqF00YMpbftE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eu+WPHRY2o/v39nhz+RBfS14jK7UcMF0mtWAeKlF1ov1O/m+goAMIMqJxTsNydc6v4VVEbuHJrrj5Vo+DeznHMNqQfunRdCsOXz/Cuq1pGWoamHvjqBuigu9GjjxejD6rEMCKZtTZZq72rGvCiRx5e8TImAT0296LDYKO831bY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rwkH7yk/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZcaR9tcI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VGdEVve7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lQcXohwT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rwkH7yk/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZcaR9tcI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VGdEVve7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lQcXohwT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BAD6A21F05;
	Thu, 24 Sep 2026 10:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790247463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGe1Uyoj3hhwaqMmmb4P4GWQZZ0XVbX1aCs+aO9Y1iA=;
	b=rwkH7yk/nadi0w+6IrC3tuhGWnNWPkleBFeW/8SVSb7/yEL5RvRcN7EKX91i9dGkvCfrSl
	JhxQj7nh/5RfVYKaOBUlwys1qbT/5pxgrPVDkaYyn2hy4vG5JpVF/fCAXzNPrlTonHmO5c
	S7A0BtSAbMfg4+bag4QKVCZh54D85uk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790247463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGe1Uyoj3hhwaqMmmb4P4GWQZZ0XVbX1aCs+aO9Y1iA=;
	b=ZcaR9tcIrRhdwUhtPcQUMDU/BnzZD1b2TbxVw1Ln1mjLffpVUzU9Pyy+M4ae0dlCGg2r9t
	ffEYs6mm2LwOUWCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VGdEVve7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lQcXohwT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790247458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGe1Uyoj3hhwaqMmmb4P4GWQZZ0XVbX1aCs+aO9Y1iA=;
	b=VGdEVve7YyDaxnDIgn08n2nt1Hb+Rhy8pzwOvhyxpkOhY2jiGd8MALSMaKMiHo16n/c1yJ
	bO1ieKBMGNnp3GQVIWdNG1QSkhSnwLc5bHSdtCKULjtjpg3L9sDUBFA6GI8YvA3108+pHx
	+D+snlQkaUCM9jXELaSKS9GipaQ6uVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790247458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGe1Uyoj3hhwaqMmmb4P4GWQZZ0XVbX1aCs+aO9Y1iA=;
	b=lQcXohwTmm7KFljPOB4yE7ES2ohOCoH4SMLNRblhmwysOdz2dxoWV1F8ZSqaAnIgXxRqAT
	MiEGr4/JwtQAmTCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EF8B13668;
	Thu, 24 Sep 2026 10:57:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kOtDGiICtWqoAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 10:57:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 20EC2A132E; Thu, 24 Sep 2026 12:57:34 +0200 (CEST)
Date: Thu, 24 Sep 2026 12:57:34 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, 
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v8 3/3] writeback: record bdev targets in foreign
 writeback tracepoints
Message-ID: <xktq4fmpdlbtrncw2zjdu73mgstjsceq7qurdmatditlqhhavz@53m37febbjki>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
 <20260922125015.3435215-4-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922125015.3435215-4-sunjunchao@bytedance.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BAD6A21F05
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Tue 22-09-26 20:50:15, Julian Sun wrote:
> Add dev to track_foreign_dirty and flush_foreign so traces can
> distinguish foreign-wb tracking from the bdev-only path. Append the
> field to each event and print it as major:minor; zero denotes the
> normal foreign-wb path.
> 
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Hum, won't it be better to introduce new tracepoints instead of kind of
abusing the existing ones and filling in zeros? At least if I were to use
these tracepoints, I'd prefer that.

								Honza

> ---
>  include/trace/events/writeback.h | 22 ++++++++++++++--------
>  mm/memcontrol.c                  |  8 +++++---
>  2 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index 13ee076ccd16..ffd1b8df4231 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -273,9 +273,9 @@ TRACE_EVENT(inode_switch_wbs,
>  
>  TRACE_EVENT(track_foreign_dirty,
>  
> -	TP_PROTO(struct folio *folio, struct bdi_writeback *wb),
> +	TP_PROTO(struct folio *folio, struct bdi_writeback *wb, dev_t dev),
>  
> -	TP_ARGS(folio, wb),
> +	TP_ARGS(folio, wb, dev),
>  
>  	TP_STRUCT__entry(
>  		__array(char,		name, 32)
> @@ -284,6 +284,7 @@ TRACE_EVENT(track_foreign_dirty,
>  		__field(u64,		cgroup_ino)
>  		__field(u64,		page_cgroup_ino)
>  		__field(unsigned int,	memcg_id)
> +		__field(dev_t,		dev)
>  	),
>  
>  	TP_fast_assign(
> @@ -295,34 +296,37 @@ TRACE_EVENT(track_foreign_dirty,
>  		__entry->ino		= inode ? inode->i_ino : 0;
>  		__entry->memcg_id	= wb->memcg_css->id;
>  		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
> +		__entry->dev		= dev;
>  
>  		rcu_read_lock();
>  		__entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);
>  		rcu_read_unlock();
>  	),
>  
> -	TP_printk("bdi %s[%llu]: ino=%llu memcg_id=%u cgroup_ino=%llu page_cgroup_ino=%llu",
> +	TP_printk("bdi %s[%llu]: ino=%llu memcg_id=%u cgroup_ino=%llu page_cgroup_ino=%llu dev=%u:%u",
>  		__entry->name,
>  		__entry->bdi_id,
>  		__entry->ino,
>  		__entry->memcg_id,
>  		__entry->cgroup_ino,
> -		__entry->page_cgroup_ino
> +		__entry->page_cgroup_ino,
> +		MAJOR(__entry->dev), MINOR(__entry->dev)
>  	)
>  );
>  
>  TRACE_EVENT(flush_foreign,
>  
>  	TP_PROTO(struct bdi_writeback *wb, unsigned int frn_bdi_id,
> -		 unsigned int frn_memcg_id),
> +		 unsigned int frn_memcg_id, dev_t dev),
>  
> -	TP_ARGS(wb, frn_bdi_id, frn_memcg_id),
> +	TP_ARGS(wb, frn_bdi_id, frn_memcg_id, dev),
>  
>  	TP_STRUCT__entry(
>  		__array(char,		name, 32)
>  		__field(u64,		cgroup_ino)
>  		__field(unsigned int,	frn_bdi_id)
>  		__field(unsigned int,	frn_memcg_id)
> +		__field(dev_t,		dev)
>  	),
>  
>  	TP_fast_assign(
> @@ -330,13 +334,15 @@ TRACE_EVENT(flush_foreign,
>  		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
>  		__entry->frn_bdi_id	= frn_bdi_id;
>  		__entry->frn_memcg_id	= frn_memcg_id;
> +		__entry->dev		= dev;
>  	),
>  
> -	TP_printk("bdi %s: cgroup_ino=%llu frn_bdi_id=%u frn_memcg_id=%u",
> +	TP_printk("bdi %s: cgroup_ino=%llu frn_bdi_id=%u frn_memcg_id=%u dev=%u:%u",
>  		__entry->name,
>  		__entry->cgroup_ino,
>  		__entry->frn_bdi_id,
> -		__entry->frn_memcg_id
> +		__entry->frn_memcg_id,
> +		MAJOR(__entry->dev), MINOR(__entry->dev)
>  	)
>  );
>  #endif
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6042c694d56c..534b0d537a09 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3956,12 +3956,12 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  	struct inode *inode = mapping->host;
>  
>  	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {
> -		trace_track_foreign_dirty(folio, wb);
> +		trace_track_foreign_dirty(folio, wb, inode->i_rdev);
>  		mem_cgroup_track_foreign_bdev(memcg, inode->i_rdev);
>  		return;
>  	}
>  
> -	trace_track_foreign_dirty(folio, wb);
> +	trace_track_foreign_dirty(folio, wb, 0);
>  
>  	/*
>  	 * Pick the slot to use.  If there is already a slot for @wb, keep
> @@ -4032,6 +4032,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
>  			 * the timestamp for a later flush.
>  			 */
>  			frn->at = 0;
> +			trace_flush_foreign(wb, 0, 0, frn->dev);
>  			queue_work(memcg_bdev_frn_wq, &frn->work);
>  		}
>  	}
> @@ -4048,7 +4049,8 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
>  		if (time_after64(frn->at, now - intv) &&
>  		    atomic_read(&frn->done.cnt) == 1) {
>  			frn->at = 0;
> -			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id);
> +			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id,
> +					    0);
>  			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
>  					       WB_REASON_FOREIGN_FLUSH,
>  					       &frn->done);
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
