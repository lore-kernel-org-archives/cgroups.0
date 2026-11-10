Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317240;
	b=bmaYwZ6ZFTF6Y1P4URjDY9FpUhOv1p7RA7jFujm4vUdSCrwlyOfE8KZgc6jWSBGmOymB
	 +xVRvWbkgwoes5SBa+TDVU62Q/UGJCAGsS+NCNkBq9TRThUZwauUsbBMdidDaJ/LNqHN9
	 HTMBR2mtuQ0P8tQrp7OW23lt5yYgpt9srfijESA2x7+pJeHfGWzAJqS1COeze1lWjZo+l
	 jweuN33S5q51WtJlqYdT/S4D31Nr0iIkEdtvOWES0Pt6OSRCrxr4LcwbnyuuL7jS36KZw
	 zdyKSE46wi0PQSU3SA5awpTltE2UkQyMFiUeURB1121NE+8dGNboRxkYukimXmtENNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317240;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=TjaC6TK+Ekl+A3heooFKriRHs64IJvz2GQ27CnyNwYptEIntACDIQ+M/jZM131WDZZKR
	 jrS+muVbkrgvezPVZ3v/N2144Q02B0E26C1HawOIUDGT38CQ7nX3o/o2l9eZP+L18l8Ps
	 Yr1GjFgrXuuhW6NvAqg8XBVkp1KoSa7xRgWGmxBv7W2mCcNrsWV52gG3lGQtv+Ro2PGO3
	 wJxrfju78+7/XzSTb98oxS1O5ftphEd2nmzLXEg86668xG+N+DmhIT6FbMxgS0GlwfQwJ
	 We6fWeRLBEQ8gh+MHhdkIKTRy+Ws/brz+it1XkbuiNV7jbLZZnrbb0TcEPKWElWX4Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qKQcYFUJ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qKQcYFUJ;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C726F606A33C;
	Tue, 10 Nov 2026 13:27:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C726F606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qKQcYFUJ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qKQcYFUJ
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1D6521EB9;
	Tue, 10 Nov 2026 13:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=FSjbyIy9Eh1iq1WYwFosAs5h+QdUj3JseqQK+/Fyngw44MBKrqZiWFoCj6JPHfk+Yor7Yv
	Ef5CjXcET1VuoMjCctjuHDtpjbgZxWKDM3CGgXt37JOHFI5plgNG9+eiFs1UOtmBezmV/9
	jBnnqcWbLq3hzUNPZS5kkwXUdmqfEuA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317238;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=qKQcYFUJwJDWgKs0ErrbPdtu7yBepQbcQ6AITcH4Or8odAuLrS/V+qsslwZsMkhAvyIErp
	kS7QeLuGL42NmECg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=FSjbyIy9Eh1iq1WYwFosAs5h+QdUj3JseqQK+/Fyngw44MBKrqZiWFoCj6JPHfk+Yor7Yv
	Ef5CjXcET1VuoMjCctjuHDtpjbgZxWKDM3CGgXt37JOHFI5plgNG9+eiFs1UOtmBezmV/9
	jBnnqcWbLq3hzUNPZS5kkwXUdmqfEuA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317238;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=qKQcYFUJwJDWgKs0ErrbPdtu7yBepQbcQ6AITcH4Or8odAuLrS/V+qsslwZsMkhAvyIErp
	kS7QeLuGL42NmECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE66B13479;
	Tue, 10 Nov 2026 13:27:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bx7ZKrUb82paYwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:27:17 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6146B2250C; Tue, 10 Nov 2026 14:27:17 +0100 (CET)
Date: Tue, 10 Nov 2026 14:27:17 +0100
From: Jan Kara <jack@suse.cz>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Julian Sun <sunjunchao@bytedance.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] writeback: name the bdi in the slow writeback
 report
Message-ID: <llelav5t3bcbtyiujoe6lmqrzlgfcgc7oq7o2mfrzpio4c34d3@6ak5d4z7jqmz>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
 <20261110-writeback_stall_report-v2-2-9e0ed75074ca@debian.org>
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
In-Reply-To: <20261110-writeback_stall_report-v2-2-9e0ed75074ca@debian.org>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Tue 10-11-26 03:39:28, Breno Leitao wrote:
> The slow writeback report names the waiting task and how long it has
> waited, but not what it is waiting on. On a machine with several
> filesystems there is no way to tell which device is slow.
> 
> Pass the bdi to wb_wait_for_completion() and add its name to the
> report, together with the number of work items still outstanding. A
> sync issues one work item per cgroup wb with dirty inodes, so the count
> also shows whether a single cgroup is holding up the others.
> 
> wb_wait_for_completion() took the bdi until commit 5b9cce4c7eb0
> ("writeback: Generalize and expose wb_completion") made it usable for
> the memcg foreign flushes. memcg tracks those by bdi id only and passes
> NULL, which bdi_dev_name() prints as "(unknown)".
> 
> A sync of files dirtied from two cgroups, on a throttled null_blk
> device, now reports:
> 
>   [   10.043698] INFO: The task sync:276 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c           | 20 ++++++++++++--------
>  include/linux/backing-dev.h |  3 ++-
>  mm/memcontrol.c             |  2 +-
>  3 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 01a00d7542b371..c5e9e5c0d506a9 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -196,7 +196,8 @@ static void wb_queue_work(struct bdi_writeback *wb,
>  	spin_unlock_irq(&wb->work_lock);
>  }
>  
> -static bool wb_wait_for_completion_cb(struct wb_completion *done)
> +static bool wb_wait_for_completion_cb(struct wb_completion *done,
> +				      struct backing_dev_info *bdi)
>  {
>  	unsigned long timeout = sysctl_hung_task_timeout_secs;
>  	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
> @@ -204,8 +205,9 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
>  	done->progress_stamp = jiffies;
>  	if (timeout && (waited_secs > timeout))
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
> -			"completion for more than %lu seconds.\n",
> -			current->comm, current->pid, waited_secs);
> +			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
> +			current->comm, current->pid, waited_secs,
> +			bdi_dev_name(bdi), atomic_read(&done->cnt));
>  
>  	return !atomic_read(&done->cnt);
>  }
> @@ -213,6 +215,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
>  /**
>   * wb_wait_for_completion - wait for completion of bdi_writeback_works
>   * @done: target wb_completion
> + * @bdi: bdi work items were issued to, NULL for the memcg foreign flushes
>   *
>   * Wait for one or more work items issued to @bdi with their ->done field
>   * set to @done, which should have been initialized with
> @@ -220,11 +223,12 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
>   * are completed.  Work items which are waited upon aren't freed
>   * automatically on completion.
>   */
> -void wb_wait_for_completion(struct wb_completion *done)
> +void wb_wait_for_completion(struct wb_completion *done,
> +			    struct backing_dev_info *bdi)
>  {
>  	done->wait_start = jiffies;
>  	atomic_dec(&done->cnt);		/* put down the initial count */
> -	wait_event(*done->waitq, wb_wait_for_completion_cb(done));
> +	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
>  }
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> @@ -1164,7 +1168,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
>  		last_wb = wb;
>  
>  		rcu_read_unlock();
> -		wb_wait_for_completion(&fallback_work_done);
> +		wb_wait_for_completion(&fallback_work_done, bdi);
>  		goto restart;
>  	}
>  	rcu_read_unlock();
> @@ -2972,7 +2976,7 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
>  	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy);
> -	wb_wait_for_completion(&done);
> +	wb_wait_for_completion(&done, bdi);
>  }
>  
>  /**
> @@ -3069,7 +3073,7 @@ void sync_inodes_sb(struct super_block *sb)
>  	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
>  	bdi_down_write_wb_switch_rwsem(bdi);
>  	bdi_split_work_to_wbs(bdi, &work, false);
> -	wb_wait_for_completion(&done);
> +	wb_wait_for_completion(&done, bdi);
>  	bdi_up_write_wb_switch_rwsem(bdi);
>  
>  	wait_sb_inodes(sb);
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index c2284466e7aa66..808d939d2ca7f9 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -39,7 +39,8 @@ struct backing_dev_info *bdi_alloc(int node_id);
>  void wb_start_background_writeback(struct bdi_writeback *wb);
>  void wb_workfn(struct work_struct *work);
>  
> -void wb_wait_for_completion(struct wb_completion *done);
> +void wb_wait_for_completion(struct wb_completion *done,
> +			    struct backing_dev_info *bdi);
>  
>  extern spinlock_t bdi_lock;
>  extern struct list_head bdi_list;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ac6c43ea8c5a6d..df462d279a655e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4525,7 +4525,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> -		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> +		wb_wait_for_completion(&memcg->cgwb_frn[i].done, NULL);
>  #endif
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
>  		static_branch_dec(&memcg_sockets_enabled_key);
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
