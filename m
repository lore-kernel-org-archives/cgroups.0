Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975273;
	b=t4lV6VyzmnvYDIcIswWKpUTL/6w/qW1RzwudQCwKn7d6qlk6to/9ulxOHrKphLXViX5W
	 b+ezpSNz3Hz4rsjms3oA5Biz+HKTcBfo5pyvWEd3VJTqLzHndPpq3Q8nn0Vc3RaCRzER7
	 kZPa76uZm2xlBKMNc7t4K6VnndF+lIGEKumqmlT99aCQJnFI1wUUAvm6su9CqxiWOkqhu
	 w5dz9cadGegnTgUFXexebiJ7LTqWSGFTXgIKk7sQYO09lImt07A9slf5VkZsbVvyinMBq
	 Jfgq3aAnjMqn84EY65YdQ5ENB7+Tcz44O7eDO5emXWqmuSoCYdQFctDUpO5h5u9miwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975273;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=aGRJsmQE2mVuxcglw902L7X/EHKiTdSswwL48S8Y4+k=;
	b=dYM32zaCer/pKQDg4mpu4J0lu9tp+x8GBqvlvcSjcLhkMMKkaaH2dDGd7NhJvUI5lgm2
	 6iadYy4u14uccioToq6AshQEGIB1CANL3J3/QaqUPmXtGkKi8jtJ2wI/C3qIYmp2He2OV
	 Uf7iUydGmdTl8WBrg5s9qcXOuHIp8sHCeXHBLGPptHd2HoUKyjfLp53T4ZU5ahHeSw9lD
	 27BA6i6nhwHNswQ1f2gQb3S6MobLe4sAQaf+rDZBRPsVD+7C9FPSY4NX4NZe1hwi+vXIo
	 9Ydx0MLhAaoDImxN+YN4ikWea57+7ywFBMjiPiGdvxA9opETwC8svqdVhvg39UjVg9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ru7YyDd0;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=P1v1r4tZ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2XZAQy4y;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=w8LEnZte;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6496606A32D;
	Fri,  6 Nov 2026 14:27:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6496606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Ru7YyDd0;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=P1v1r4tZ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2XZAQy4y;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=w8LEnZte
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8A7B1F83F;
	Fri,  6 Nov 2026 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aGRJsmQE2mVuxcglw902L7X/EHKiTdSswwL48S8Y4+k=;
	b=Ru7YyDd0eBwbcDveMop510Y8AtJeFr3YwvRcjZlOv3iwgIv/2XDqGUttOze5uV7pLEjZK2
	U90pJlqqehmsIdOouqL8o5A6yRSQa9cKGkbFyQjsHRqjBgZYD9IqAA1sZAL6lP/aZ+goYG
	KsoLWo29tGZbVs4/1wSDid2QfNRXVh8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aGRJsmQE2mVuxcglw902L7X/EHKiTdSswwL48S8Y4+k=;
	b=P1v1r4tZ9/aooFo6kkbVrUpbM9m+NL+qWWFpfcVDdtNs7d6NPS/n6jZv+MtIBkPs/1gHyq
	wu1JGh6gWIDtnTDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2XZAQy4y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=w8LEnZte
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aGRJsmQE2mVuxcglw902L7X/EHKiTdSswwL48S8Y4+k=;
	b=2XZAQy4yvS62csVGU3Ukwqxn2O+55ap9As10NtLgFhdjuFy+M6HJa4vh/LTa8DAXB+weYb
	GCzfPcEaZ/0vo3jRcGbZlJpbNEDPAtgE9Uew4kqrXn0UUYiactfsyR9WGTF2idfKmco2A3
	fc5/3oB1EDC6R78mIwqOuziVEIb+kxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aGRJsmQE2mVuxcglw902L7X/EHKiTdSswwL48S8Y4+k=;
	b=w8LEnZterPqOfbCtYSeIkaGTsnijcVMV4ZpfxekxeBfMisVXR0xBAlMNvPuNok3H2lRITG
	hk13AldRlNIvNmCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB62C132C9;
	Fri,  6 Nov 2026 14:27:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SJHnI+Xj7WricgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 14:27:49 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 44AF221B8C; Fri, 06 Nov 2026 15:27:49 +0100 (CET)
Date: Fri, 6 Nov 2026 15:27:49 +0100
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
Subject: Re: [PATCH 2/4] writeback: name the bdi in the slow writeback report
Message-ID: <n7s5cijjaiso6mhaqolsmfkyyfk7wkb4l4o2cnxqadjfllik7b@hh6u4v5f6t2t>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-2-bf0c3b9023a5@debian.org>
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
In-Reply-To: <20261106-writeback_stall_report-v1-2-bf0c3b9023a5@debian.org>
X-Rspamd-Queue-Id: D8A7B1F83F
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -13.01

On Fri 06-11-26 04:26:32, Breno Leitao wrote:
> The slow writeback report names the waiting task and how long it has
> waited, but not what it is waiting on. On a machine with several
> filesystems there is no way to tell which device is slow.
> 
> Pass the bdi to wb_wait_for_completion() and print its name on a second
> line, together with the number of work items still outstanding. A sync
> issues one work item per cgroup wb with dirty inodes, so the count also
> shows whether a single cgroup is holding up the others.
> 
> wb_wait_for_completion() took the bdi until commit 5b9cce4c7eb0
> ("writeback: Generalize and expose wb_completion") made it usable for
> the memcg foreign flushes. memcg tracks those by bdi id only and passes
> NULL, which bdi_dev_name() prints as "(unknown)".
> 
> The first line does not change, so anything matching on it keeps
> working. A sync on a throttled null_blk device now reports:
> 
>   INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.
>         bdi 252:0, work items left: 1
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Dunno, I'd put everything on one line. Otherwise things can get interleaved
by other messages. Kernel messages are not really an ABI, we can change
them...

								Honza

> ---
>  fs/fs-writeback.c           | 20 +++++++++++++-------
>  include/linux/backing-dev.h |  3 ++-
>  mm/memcontrol.c             |  2 +-
>  3 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 01a00d7542b371..3dee9d65eaf721 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -196,16 +196,20 @@ static void wb_queue_work(struct bdi_writeback *wb,
>  	spin_unlock_irq(&wb->work_lock);
>  }
>  
> -static bool wb_wait_for_completion_cb(struct wb_completion *done)
> +static bool wb_wait_for_completion_cb(struct wb_completion *done,
> +				      struct backing_dev_info *bdi)
>  {
>  	unsigned long timeout = sysctl_hung_task_timeout_secs;
>  	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
>  
>  	done->progress_stamp = jiffies;
> -	if (timeout && (waited_secs > timeout))
> +	if (timeout && (waited_secs > timeout)) {
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
>  			"completion for more than %lu seconds.\n",
>  			current->comm, current->pid, waited_secs);
> +		pr_info("      bdi %s, work items left: %d\n",
> +			bdi_dev_name(bdi), atomic_read(&done->cnt));
> +	}
>  
>  	return !atomic_read(&done->cnt);
>  }
> @@ -213,6 +217,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
>  /**
>   * wb_wait_for_completion - wait for completion of bdi_writeback_works
>   * @done: target wb_completion
> + * @bdi: bdi work items were issued to, NULL for the memcg foreign flushes
>   *
>   * Wait for one or more work items issued to @bdi with their ->done field
>   * set to @done, which should have been initialized with
> @@ -220,11 +225,12 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
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
> @@ -1164,7 +1170,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
>  		last_wb = wb;
>  
>  		rcu_read_unlock();
> -		wb_wait_for_completion(&fallback_work_done);
> +		wb_wait_for_completion(&fallback_work_done, bdi);
>  		goto restart;
>  	}
>  	rcu_read_unlock();
> @@ -2972,7 +2978,7 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
>  	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy);
> -	wb_wait_for_completion(&done);
> +	wb_wait_for_completion(&done, bdi);
>  }
>  
>  /**
> @@ -3069,7 +3075,7 @@ void sync_inodes_sb(struct super_block *sb)
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
